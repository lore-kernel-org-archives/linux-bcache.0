From: Michael Lyle <mlyle@lyle.org>
Subject: Re: bcache failure hangs something in kernel
Date: Tue, 14 Nov 2017 11:03:58 -0800
Message-ID: <CAJ+L6qdNvhLSrXsHhR5V0u5BwH78+nLomeSa2Sjq9ML7XVpgdQ@mail.gmail.com>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
 <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org> <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
 <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org> <87r2t1xa6w.fsf@esperi.org.uk>
 <CAJ+L6qc+DKZ4tkfk3whUBZOjdTByMqxUrvOOQ0yhR_fSYq+oSw@mail.gmail.com> <87inecyayq.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:50888 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754982AbdKNTEA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Nov 2017 14:04:00 -0500
Received: by mail-qt0-f169.google.com with SMTP id u42so5136521qte.7
        for <linux-bcache@vger.kernel.org>; Tue, 14 Nov 2017 11:04:00 -0800 (PST)
In-Reply-To: <87inecyayq.fsf@esperi.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Alexandr Kuznetsov <progmachine@xenlab.one>, linux-bcache@vger.kernel.org

On Tue, Nov 14, 2017 at 10:25 AM, Nix <nix@esperi.org.uk> wrote:
> [   11.497914] bad checksum at bucket 28262, block 0, 36185 keys

That's no good-- shouldn't have checksum errors.  It means either the
metadata we wrote got corrupted by the disk, or a metadata write
didn't happen in the order we requested.

> Reboots with the cache enabled always featured a message from bcache an
> instant before reboot saying it had timed out: from the code, the
> timeout is based on a (short!) delay without any concern for whether,
> say, the SSD is in the middle of writing a bunch of data, and the delay
> is way too short for the SSD in question (an ATA-connected DC3510) to
> write more than a GiB or so, a small fraction of the 350GiB I have
> devoted to bcache.

I've seen things hit this couple second timeout before.  It basically
means that garbage collection is busy analyzing stuff on the disk and
doesn't get around to checking the "should I exit now?" flag in time.
Not ideal but relatively harmless.  (It's not trying to write back the
dirty data at this phase or anything).

> I note that the SMART data's bus reset count on the SSD suggests that
> rebooting resets the bus as part of POST (the count of bus resets is
> identical to the count of OS reboots plus firmware upgrades from the
> IPMI event log), which likely halts any ongoing writes.

Even if it did, as long as acknowledged IO is written it's OK.  That
is, it's OK for anything we're trying to write to be lost, as long as
the drive hasn't told us it's done and then later that write gets
"undone".

I think there has to be something somewhat unique to your
environment-- at an environment I used to administrate (before working
on bcache myself), there were about 100 bcache roots in writeback
mode-- and we both unceremoniously lost power with active workload a
couple of times and did several clean shutdowns for upgrades without
losing a volume to corruption (though we did lose many disks that
didn't feel like working at all again after power failure).  And now I
have a bad arc-fault circuit breaker in my home that has dumped power
on my two ext4 root-on bcache-on md machines three times in the past
couple weeks without issue.  Each of my production machines has 15
unsafe shutdowns in smartctl -- a number that I can't quite explain
because I think the real number should be 7-8 or so... and my bcache
development test rig has 145 (!).

Mike
