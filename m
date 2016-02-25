From: Marc MERLIN <marc@merlins.org>
Subject: Re: Disabling bcache from boot when it crashes?
Date: Wed, 24 Feb 2016 21:48:04 -0800
Message-ID: <20160225054804.GA15421@merlins.org>
References: <20160215060410.GA30802@merlins.org> <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net> <20160224163716.GA19447@merlins.org> <alpine.LRH.2.11.1602241904140.32077@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37932 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbcBYFsP (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 00:48:15 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1602241904140.32077@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Wed, Feb 24, 2016 at 07:10:07PM +0000, Eric Wheeler wrote:
> On Wed, 24 Feb 2016, Marc MERLIN wrote:
> 
> > On Wed, Feb 24, 2016 at 06:53:05AM +0000, Eric Wheeler wrote:
> > > Do you have the bcache stability patches? 4.3.3 might be missing some 
> > > critical patches.
> > > 
> > > Be sure to cherry-pick these from linux 4.5-rc1:
> > > 	git cherry-pick 2ef9ccbf~1..627ccd20
> > > or use one of the 4.1 or 3.18 longterm kernels.
> > > 
> > > I've not see any memory allocation issues before in bcache, but you 
> > > definitely want those patches for general stability.
> > 
> > I'm running 4.4.2, so I'm assuming I don't have those fixes, thanks for the
> > heads up.
> 
> 4.1.18 has the patches, so unless there is something specific in 4.4 that 
> you need, I recommend 4.1.  We've been running 4.1.17 with patches in 
> production for a while and it works great.  Haven't tried vanilla 4.1.18 
> yet, but I plan to soon.
>  
> > Well, your message is timely, just as you wrote this, I got bcache that
> > crashed my system as I was shutting down, and then I was unable to ever
> > reboot because bcache would detect my partitions, start bcache, and crash
> > before I could do anything to fix it.
> > 
> > A few questions though:
> > 1) is there any bcache boot option I can give to disable bcache at boot
> > time?
> 
> This is probably distribution specific.  Exclude bcache from your initrd 
> unless your rootfs is bcache (update-initramfs, dracut, etc).  Maybe 
> blacklist the module and manually modprobe it when you are ready to load 
> it.
  
So I gave this some more thought. This is not how things work.
You have bcache either built in your kernel, so you can't remove it, or as
an early loaded module in initrd, and it's pretty damn hard to stop that
module from loading if your kernel crashes before you can even get a shell.

Either way, when you hit a crashing bug with bcache, your kernel will
consistently crash until you remove or delete the contents of the partition,
which you can only do from rescue media.
In my experience, the rescue media doesn't have make-bcache, or even a
version of wipefs recent enough to clear the cache partition, so you're left
with dd or just deleting the partition.
Needless to say that it's very sub optimal for the average user who doesn't
have rescue media on hand and can't look up the internet easily to find otu
what to do after their system doesn't boot.

So, I hope it makes sense that it would be good to have something like
bcache=off as a command line option to recover when things go wrong (in my
job, it's 'when', not 'if' ;) ).

> I think the superblock is in the first 2MB of the disk, so you could do 
> something like this:
> 	dd if=/dev/zero bs=1M count=2 of=/cachedev
 
Thanks.
I'll still wait for you to tell me that there is nothing you'd like me to
try to help you find out why bcache is crashing before I wipe the data on my
now corrupted cache partition.

> > "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> 
> Funny, I use my mouse the same way!

:)

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
