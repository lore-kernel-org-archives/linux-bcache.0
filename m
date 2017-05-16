From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: make-bcache bug?
Date: Tue, 16 May 2017 04:02:52 +0200
Message-ID: <20170516040252.6a85ff22@jupiter.sol.kaishome.de>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
        <20170514220055.2d06210e@jupiter.sol.kaishome.de>
        <20170514201940.76bu7rz764jeplnd@merlins.org>
        <20170514232816.79c2530e@jupiter.sol.kaishome.de>
        <8737c6th8m.fsf@esperi.org.uk>
        <20170515203745.4fc14030@jupiter.sol.kaishome.de>
        <20170516005848.GO29894@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42201 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdEPCDE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 15 May 2017 22:03:04 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dARpA-0005hY-Lx
        for linux-bcache@vger.kernel.org; Tue, 16 May 2017 04:02:56 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Mon, 15 May 2017 17:58:48 -0700
schrieb Marc MERLIN <marc@merlins.org>:

> On Mon, May 15, 2017 at 08:37:45PM +0200, Kai Krakow wrote:
> > Am Mon, 15 May 2017 13:52:09 +0100
> > schrieb Nix <nix@esperi.org.uk>:
> >   
> > > On 14 May 2017, Kai Krakow said:  
>  [...]  
> > > 
> > > udev does a blkid to see how the block device needs to be
> > > activated: this relies on precisely the information wipefs
> > > removes. Avoiding this problem is why wipefs *exists*. :)  
> > 
> > Yes, but something triggered udev when it shouldn't...
> > 
> > This ends up in unregistering/stopping the bcache, then wipefs the
> > cdev, then look if udev was triggered and eventually stop it again.
> > 
> > I guess everytime I ran "fdisk -l" to double-check the devices, or
> > "lsblk", or "blkid", udev was triggered and re-enabled the bcache.
> > This is a race you cannot win. ;-)  
> 
> Note that this is orthogonal to the problem I reported.
> It tells me 
> Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
> when it fact this does not work, apparently ever.
> 
> So either the message gets changed, or 
> make-bcache  --wipe-bcache
> -C /dev/sde2 Device /dev/sde2 already has a non-bcache superblock,
> remove it using wipefs and wipefs -a does not happen. there was no
> non-bcache superblock.

I look at both source codes of wipefs and make-bcache should give a
clue.

Since you made me curious, I'll probably take a look this weekend.


-- 
Regards,
Kai

Replies to list-only preferred.
