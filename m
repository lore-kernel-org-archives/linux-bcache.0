From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Disabling bcache from boot when it crashes?
Date: Wed, 24 Feb 2016 19:10:07 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602241904140.32077@mail.ewheeler.net>
References: <20160215060410.GA30802@merlins.org> <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net> <20160224163716.GA19447@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:37687 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750973AbcBXTKT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 14:10:19 -0500
In-Reply-To: <20160224163716.GA19447@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Wed, 24 Feb 2016, Marc MERLIN wrote:

> On Wed, Feb 24, 2016 at 06:53:05AM +0000, Eric Wheeler wrote:
> > Do you have the bcache stability patches? 4.3.3 might be missing some 
> > critical patches.
> > 
> > Be sure to cherry-pick these from linux 4.5-rc1:
> > 	git cherry-pick 2ef9ccbf~1..627ccd20
> > or use one of the 4.1 or 3.18 longterm kernels.
> > 
> > I've not see any memory allocation issues before in bcache, but you 
> > definitely want those patches for general stability.
> 
> I'm running 4.4.2, so I'm assuming I don't have those fixes, thanks for the
> heads up.

4.1.18 has the patches, so unless there is something specific in 4.4 that 
you need, I recommend 4.1.  We've been running 4.1.17 with patches in 
production for a while and it works great.  Haven't tried vanilla 4.1.18 
yet, but I plan to soon.
 
> Well, your message is timely, just as you wrote this, I got bcache that
> crashed my system as I was shutting down, and then I was unable to ever
> reboot because bcache would detect my partitions, start bcache, and crash
> before I could do anything to fix it.
> 
> A few questions though:
> 1) is there any bcache boot option I can give to disable bcache at boot
> time?

This is probably distribution specific.  Exclude bcache from your initrd 
unless your rootfs is bcache (update-initramfs, dracut, etc).  Maybe 
blacklist the module and manually modprobe it when you are ready to load 
it.
 
> 2) I had to boot from rescue media and sadly the version of wipefs there
> wasn't good enough to find the bcache sig and remove it.
> I then tried to change the bcache cache partition type to 0, but that didn't
> help either.
> Eventually I had to shrink the bcache cache partition to 1 cylinder and
> finally then it stopped being detected at boot and the crashes stopped.
> (dd of /dev/zero would have worked, but it's an ssd, and I didn't want to
> allocate blocks on the flash that had not been used yet to give more room
> for garbage collection).
> 
> Was there a better way of doing this?

Probably just `make-bcache -C` of the cache with a force option?  

I think the superblock is in the first 2MB of the disk, so you could do 
something like this:
	dd if=/dev/zero bs=1M count=2 of=/cachedev

> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.

Funny, I use my mouse the same way!

-Eric

> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> 
