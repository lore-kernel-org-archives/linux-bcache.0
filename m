From: Marc MERLIN <marc@merlins.org>
Subject: Re: make-bcache bug?
Date: Sun, 14 May 2017 13:19:40 -0700
Message-ID: <20170514201940.76bu7rz764jeplnd@merlins.org>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
 <20170514220055.2d06210e@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35284 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759193AbdENUTp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 May 2017 16:19:45 -0400
Content-Disposition: inline
In-Reply-To: <20170514220055.2d06210e@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Sun, May 14, 2017 at 10:00:55PM +0200, Kai Krakow wrote:
> Am Sun, 14 May 2017 10:58:40 -0700
> schrieb Marc MERLIN <marc@merlins.org>:
> 
> > bcache-tools (1.0.8-2+b1)
> > 
> > gargamel:~# make-bcache  -C /dev/sde2
> > Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
> > gargamel:~# make-bcache  --wipe-bcache -C /dev/sde2 
> > Device /dev/sde2 already has a non-bcache superblock, remove it using
> > wipefs and wipefs -a
> > 
> > /dev/sde2 is an old bcache I'm reformatting.
> > The first message is correct
> > The 2nd one is not "/dev/sde2 already has a non-bcache superblock"
> > 
> > Clearly it can't have a bcache and not a bcache superblock, right?
> 
> I don't think that each filesystem puts their superblocks in the same
> position. Plus, there are usually backup superblocks across the area.
> 
> So you may well see both warnings and both are correct.
> 
> Use wipefs, there seems to be an orphan superblock.

Doesn't wipefs -a clear just 16 bytes or so?
I did it and it fixed my problem, but this block device was a bcache
before, and of course on top of that bcache I then added a filesystem.

Let's test this.
1) I wipefs'ed it
2) I made a new cache device on top
3) I did not put a filesystem or use it, because registration is broken
and still rquires a reboot
bcache: register_cache() error opening sde2: cache_alloc(): -ENOMEM
bcache: register_bcache() error opening /dev/sde2: (null)

4) recreating a new cache on top fo the unused cache, fails again.
Basically the superblock detection is not working right and detects
bcache as a non bcache superblock.

gargamel:/mnt/btrfs_pool2# make-bcache  -C /dev/sde2
Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
gargamel:/mnt/btrfs_pool2# make-bcache  --wipe-bcache -C /dev/sde2 
Device /dev/sde2 already has a non-bcache superblock, remove it using wipefs and wipefs -a

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
