From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: make-bcache bug?
Date: Sun, 14 May 2017 23:28:16 +0200
Message-ID: <20170514232816.79c2530e@jupiter.sol.kaishome.de>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
        <20170514220055.2d06210e@jupiter.sol.kaishome.de>
        <20170514201940.76bu7rz764jeplnd@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42402 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754259AbdENV22 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 May 2017 17:28:28 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dA13s-0001bq-F3
        for linux-bcache@vger.kernel.org; Sun, 14 May 2017 23:28:20 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Sun, 14 May 2017 13:19:40 -0700
schrieb Marc MERLIN <marc@merlins.org>:

> On Sun, May 14, 2017 at 10:00:55PM +0200, Kai Krakow wrote:
> > Am Sun, 14 May 2017 10:58:40 -0700
> > schrieb Marc MERLIN <marc@merlins.org>:
> >   
> > > bcache-tools (1.0.8-2+b1)
> > > 
> > > gargamel:~# make-bcache  -C /dev/sde2
> > > Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
> > > gargamel:~# make-bcache  --wipe-bcache -C /dev/sde2 
> > > Device /dev/sde2 already has a non-bcache superblock, remove it
> > > using wipefs and wipefs -a
> > > 
> > > /dev/sde2 is an old bcache I'm reformatting.
> > > The first message is correct
> > > The 2nd one is not "/dev/sde2 already has a non-bcache superblock"
> > > 
> > > Clearly it can't have a bcache and not a bcache superblock,
> > > right?  
> > 
> > I don't think that each filesystem puts their superblocks in the
> > same position. Plus, there are usually backup superblocks across
> > the area.
> > 
> > So you may well see both warnings and both are correct.
> > 
> > Use wipefs, there seems to be an orphan superblock.  
> 
> Doesn't wipefs -a clear just 16 bytes or so?
> I did it and it fixed my problem, but this block device was a bcache
> before, and of course on top of that bcache I then added a filesystem.
> 
> Let's test this.
> 1) I wipefs'ed it
> 2) I made a new cache device on top
> 3) I did not put a filesystem or use it, because registration is
> broken and still rquires a reboot
> bcache: register_cache() error opening sde2: cache_alloc(): -ENOMEM
> bcache: register_bcache() error opening /dev/sde2: (null)
> 
> 4) recreating a new cache on top fo the unused cache, fails again.
> Basically the superblock detection is not working right and detects
> bcache as a non bcache superblock.
> 
> gargamel:/mnt/btrfs_pool2# make-bcache  -C /dev/sde2
> Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
> gargamel:/mnt/btrfs_pool2# make-bcache  --wipe-bcache -C /dev/sde2 
> Device /dev/sde2 already has a non-bcache superblock, remove it using
> wipefs and wipefs -a

I had done this previously, too, and had no such message. But I had to
use wipefs anyway because otherwise udev came and triggered the device
for reasons I couldn't really follow.

If you get udev not to interfere with such actions, you usually also do
not need to reboot because unregistration and registration works.

But you can also easily get stuck when you decompose the bcache device
in the wrong way. It will simply stay registered then and cannot be
unregistered because the device is still in use. In that situation I
wouldn't wipefs the device.


-- 
Regards,
Kai

Replies to list-only preferred.
