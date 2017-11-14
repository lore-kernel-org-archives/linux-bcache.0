From: Michael Lyle <mlyle@lyle.org>
Subject: Re: bcache failure hangs something in kernel
Date: Tue, 14 Nov 2017 09:20:56 -0800
Message-ID: <CAJ+L6qc+DKZ4tkfk3whUBZOjdTByMqxUrvOOQ0yhR_fSYq+oSw@mail.gmail.com>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
 <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org> <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
 <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org> <87r2t1xa6w.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:45142 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932069AbdKNRU5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Nov 2017 12:20:57 -0500
Received: by mail-qt0-f172.google.com with SMTP id n32so10774690qtb.2
        for <linux-bcache@vger.kernel.org>; Tue, 14 Nov 2017 09:20:57 -0800 (PST)
In-Reply-To: <87r2t1xa6w.fsf@esperi.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Alexandr Kuznetsov <progmachine@xenlab.one>, linux-bcache@vger.kernel.org

On Tue, Nov 14, 2017 at 5:27 AM, Nix <nix@esperi.org.uk> wrote:
> Every time I rebooted I got warnings that bcache couldn't clean up
in time, and I suspect this caused corruption in the end (fairly fast,
actually, less than a month after starting using bcache: it had only
just finished populating).

What did you see?  A message like this is normal:

[    2.224767] bcache: bch_journal_replay() journal replay done, 432
keys in 243 entries, seq 40691386

but anything else is strange...  If you were consistently seeing other
messages that means something unusual was happening (an already
badly-corrupted volume or bad hardware).

> The thing is in none mode at the moment, waiting for me to revamp my
> shutdown process to rotate the initramfs into place at shutdown so I can
> unmount the rootfs and stop the bcache, in the hope that that might give
> it a chance to shut down neatly. (Even so, finding that dirty shutdown
> can corrupt the bcache is unpleasant. I guess nobody does powerfail
> tests? How do most people shut down their bcache-on-rootfs systems?)

I've been doing a fair amount of powerfail tests with OK results.
Unfortunately, my production bcache machines had some unplanned power
failure testing in the past week as well.  Also I sometimes write
crashy kernel code and end up testing unclean shutdown that way.

I have not experienced bcache corruption yet, though that doesn't say
there's not an issue.  This doesn't sound at all like what Alexandr
experienced, either.

There's not a bucket corruption message in the kernel, -- maybe you
saw a bad btree message at bucket xxxxx, block xxx, dev xxxx?

What SSD are you using?  A known issue is that there are families of
SSDs that do not do the right thing on shutdown-- e.g. some devices
based around LSI/SandForce that do emergency-writeback-from-RAM that
have underprovisioned / missing capacitors.

Mike
