From: Nix <nix@esperi.org.uk>
Subject: Re: bcache failure hangs something in kernel
Date: Fri, 17 Nov 2017 20:13:36 +0000
Message-ID: <87zi7kvf2n.fsf@esperi.org.uk>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
        <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
        <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
        <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
        <87r2t1xa6w.fsf@esperi.org.uk>
        <CAJ+L6qc+DKZ4tkfk3whUBZOjdTByMqxUrvOOQ0yhR_fSYq+oSw@mail.gmail.com>
        <87inecyayq.fsf@esperi.org.uk>
        <CAJ+L6qdNvhLSrXsHhR5V0u5BwH78+nLomeSa2Sjq9ML7XVpgdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:51374 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdKQUNk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Nov 2017 15:13:40 -0500
In-Reply-To: <CAJ+L6qdNvhLSrXsHhR5V0u5BwH78+nLomeSa2Sjq9ML7XVpgdQ@mail.gmail.com>
        (Michael Lyle's message of "Tue, 14 Nov 2017 11:03:58 -0800")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Alexandr Kuznetsov <progmachine@xenlab.one>, linux-bcache@vger.kernel.org

On 14 Nov 2017, Michael Lyle stated:

> On Tue, Nov 14, 2017 at 10:25 AM, Nix <nix@esperi.org.uk> wrote:
>> [   11.497914] bad checksum at bucket 28262, block 0, 36185 keys
>
> That's no good-- shouldn't have checksum errors.  It means either the
> metadata we wrote got corrupted by the disk, or a metadata write
> didn't happen in the order we requested.

Ugh!!! That would cause definite problems for any fs...

>> is way too short for the SSD in question (an ATA-connected DC3510) to
>> write more than a GiB or so, a small fraction of the 350GiB I have
>> devoted to bcache.
>
> I've seen things hit this couple second timeout before.  It basically
> means that garbage collection is busy analyzing stuff on the disk and
> doesn't get around to checking the "should I exit now?" flag in time.

Note that at its peak the cache had 120GiB of stuff in it. The cache is
350GiB. I find it hard to understand why GC would be running at all,
let alone taking ages to do anything.

> Even if it did, as long as acknowledged IO is written it's OK.  That
> is, it's OK for anything we're trying to write to be lost, as long as
> the drive hasn't told us it's done and then later that write gets
> "undone".
>
> I think there has to be something somewhat unique to your
> environment-- at an environment I used to administrate (before working

Oh I'm sure it is. One of the uniquenesses is that my shutdown procedure
is gross: kill as many processes as possible, toposort and lazily
unmount everything, wait a bit, sync, wait a bit more, reboot... nothing
saner seems to work reliably in the presence of the maze of bind mounts
and unshared fs hierarchies on my system.

Hence my plan to revisit this and redesign it so it can reliably unmount
everything, pivot to an initramfs, unmount the root, and stop the bcache
before I try to enable the caches again.

(There is nothing unusual about the hardware, and the storage stack is
just WD disks -> partitions -> md6 -> bcache -> LVM PV (and then xfs and
LUKSed xfs in that). The LVM PV is part of a VG that extends over
unbcached md6 too. The SSD is just partitioned with one partition
devoted to a cache device. No unusual controllers or anything, just
ordinary Intel S2600CWTR built-in mobo ATA stuff.)

> have a bad arc-fault circuit breaker in my home that has dumped power
> on my two ext4 root-on bcache-on md machines three times in the past
> couple weeks without issue.  Each of my production machines has 15
> unsafe shutdowns in smartctl -- a number that I can't quite explain
> because I think the real number should be 7-8 or so... and my bcache
> development test rig has 145 (!).

Hm. Maybe I should re-enable it and see what happens? If it goes wrong,
if there anything I can do with the wreckage to help track this down?
(In particular the wreckage left on the cache device after I've flipped
it back into none mode?)

-- 
NULL && (void)
