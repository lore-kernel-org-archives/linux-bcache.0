From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: How to use multiple backing devices
Date: Tue, 9 Feb 2016 23:15:25 +0100
Message-ID: <20160209231525.5bdc9016@jupiter.sol.kaishome.de>
References: <87oabq8p81.fsf@vostro.rath.org>
	<20160209083847.0cff87c6@jupiter.sol.kaishome.de>
	<87pow5euqe.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51765 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989AbcBIWPh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 9 Feb 2016 17:15:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1aTGZM-0005pZ-12
	for linux-bcache@vger.kernel.org; Tue, 09 Feb 2016 23:15:36 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 09 Feb 2016 23:15:36 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Tue, 09 Feb 2016 23:15:36 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Tue, 09 Feb 2016 08:03:53 -0800
schrieb Nikolaus Rath <Nikolaus@rath.org>:

> On Feb 09 2016, Kai Krakow <hurikhan77@gmail.com> wrote:
> > Am Mon, 08 Feb 2016 20:47:10 -0800
> > schrieb Nikolaus Rath <Nikolaus@rath.org>:
> >
> >> Hello,
> >> 
> >> If I'm understanding Documentation/bcache.txt correctly, I should
> >> be able to use one SSD to cache multiple spinning disks.
> >> 
> >> However, I'm at a loss of how to set this up in practice. I
> >> believe I need to do
> >> 
> >>   make-bcache -B /dev/sda  # spinning rust
> >>   make-bcache -B /dev/sdb  # spinning rust 
> >>   make-bcache -C /dev/sdc  # ssd
> >> 
> >> and then something like
> >> 
> >>   echo <CSET-UUID> > /sys/block/bcacheX/bcache/attach
> >> 
> >> 
> >> But what do I have to put for X, and what for CSET-UUID? I believe
> >> for at least one of those values I will have two options (because
> >> there are two backing devices).
> >
> > Create it in one go:
> >
> > make-bcache -C /dev/sdc -B /dev/sd{a,b}
> >
> > It will take away the hassle. Everything should be setup now.
> 
> Yeah, but unfortunately I don't have enough space for that. I need to
> create one, move the data over from second, create the second, move
> data over from the SSD, and then create the SSD is caching device.

Then do it like me:

1. Backup!
2. Remove first device from btrfs pool, run wipefs over it then!!
3. Format backing storage on it
4. Add bcache device back to the pool.
5. Repeat with next device from step 2, prepare to wait long!
6. Rebalance
7. Format caching device, enable caching device
8. Migrate your fstab/initrd whatever...

You should not enable caching before step 6, or your SSD may wear out a
lot.

You may need to add some temporary spare disk if you don't have enough
space available.

> > But if you want to do it manually: you have to run "echo" twice -
> > for each X (the backing devices). CSET-UUID comes
> > from /sys/fs/bcache where you will find a UUID per each bcache
> > caching device, which is just one for your case.
> 
> 
> Ah, ok. Intuitively attaching the same cache device to two different
> backing devices sounds dangerous, but I'll  take your word that the
> code is designed for that...

It's actually documented somewhere on the web page: One caching device
can back multiple backing devices. No need to partition it.

There were (are?) plans for even allowing attaching one backing device
to multiple caching devices (even n:n attaching) to allow for
redundancy, performance pushes, and error resiliency. Tho, I don't know
if that is implemented yet.

Also, keep an eye on your SSD wear if you're using writeback mode (use
smartctl for it with mail notifications). You may want to switch to
write-around or write-through mode before it potentially wears out.
The latter two modes should be safe, tho. Go, replace the SSD then.
Maybe trim your SSD first, then only partition and ever use only 80% of
it to increase life time as the drive can do better wear-levelling then
(sometimes called over-provisioning by manufacturers, this is even one
performance tuning option in most manufacturers Windows tools).


-- 
Regards,
Kai

Replies to list-only preferred.
