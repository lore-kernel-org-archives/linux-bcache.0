From: Marc MERLIN <marc@merlins.org>
Subject: Re: make-bcache bug?
Date: Mon, 15 May 2017 17:58:48 -0700
Message-ID: <20170516005848.GO29894@merlins.org>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org> <20170514220055.2d06210e@jupiter.sol.kaishome.de> <20170514201940.76bu7rz764jeplnd@merlins.org> <20170514232816.79c2530e@jupiter.sol.kaishome.de> <8737c6th8m.fsf@esperi.org.uk> <20170515203745.4fc14030@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37174 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdEPA6t (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 15 May 2017 20:58:49 -0400
Content-Disposition: inline
In-Reply-To: <20170515203745.4fc14030@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Mon, May 15, 2017 at 08:37:45PM +0200, Kai Krakow wrote:
> Am Mon, 15 May 2017 13:52:09 +0100
> schrieb Nix <nix@esperi.org.uk>:
> 
> > On 14 May 2017, Kai Krakow said:
> > > I had done this previously, too, and had no such message. But I had
> > > to use wipefs anyway because otherwise udev came and triggered the
> > > device for reasons I couldn't really follow.  
> > 
> > udev does a blkid to see how the block device needs to be activated:
> > this relies on precisely the information wipefs removes. Avoiding this
> > problem is why wipefs *exists*. :)
> 
> Yes, but something triggered udev when it shouldn't...
> 
> This ends up in unregistering/stopping the bcache, then wipefs the
> cdev, then look if udev was triggered and eventually stop it again.
> 
> I guess everytime I ran "fdisk -l" to double-check the devices, or
> "lsblk", or "blkid", udev was triggered and re-enabled the bcache. This
> is a race you cannot win. ;-)

Note that this is orthogonal to the problem I reported.
It tells me 
Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
when it fact this does not work, apparently ever.

So either the message gets changed, or 
make-bcache  --wipe-bcache -C /dev/sde2                                               
Device /dev/sde2 already has a non-bcache superblock, remove it using wipefs and wipefs -a
does not happen. there was no non-bcache superblock.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
