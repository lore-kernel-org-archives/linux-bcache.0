From: Nix <nix@esperi.org.uk>
Subject: Re: bcache failure hangs something in kernel
Date: Tue, 14 Nov 2017 13:27:03 +0000
Message-ID: <87r2t1xa6w.fsf@esperi.org.uk>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
        <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
        <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
        <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:59766 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754693AbdKNOZC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Nov 2017 09:25:02 -0500
In-Reply-To: <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org> (Michael Lyle's
        message of "Fri, 13 Oct 2017 01:11:41 -0700")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Alexandr Kuznetsov <progmachine@xenlab.one>, linux-bcache@vger.kernel.org

On 13 Oct 2017, Michael Lyle said:

> On 10/13/2017 12:59 AM, Alexandr Kuznetsov wrote:
>> I thought that lvm is old, mature and safe technology, but here it is
>> stuck, then manualy interrupted and result is catastrophic data corruption.
>> lvm sits on top of that sandwich of block devices, on layer of
>> /dev/bcache* devices. Another question here is how crazy lvm could
>> damage data outside of /dev/bcache* devices? This means that some
>> necessary io buffer range checks are missing inside bcache.
>
> I don't know what commands you ran.  I've never seen/heard of a bcache
> superblock corrupted, and I believe the mappings/shrink are appropriate.

I have also had corruption on a writethrough bcache (atop RAID-6, with
LVM PVs within it) causing (rootfs) mount failure: bucket corruption,
IIRC. Every time I rebooted I got warnings that bcache couldn't clean up
in time, and I suspect this caused corruption in the end (fairly fast,
actually, less than a month after starting using bcache: it had only
just finished populating).

The thing is in none mode at the moment, waiting for me to revamp my
shutdown process to rotate the initramfs into place at shutdown so I can
unmount the rootfs and stop the bcache, in the hope that that might give
it a chance to shut down neatly. (Even so, finding that dirty shutdown
can corrupt the bcache is unpleasant. I guess nobody does powerfail
tests? How do most people shut down their bcache-on-rootfs systems?)

-- 
NULL && (void)
