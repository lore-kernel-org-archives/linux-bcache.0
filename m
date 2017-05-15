From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: make-bcache bug?
Date: Mon, 15 May 2017 20:37:45 +0200
Message-ID: <20170515203745.4fc14030@jupiter.sol.kaishome.de>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
        <20170514220055.2d06210e@jupiter.sol.kaishome.de>
        <20170514201940.76bu7rz764jeplnd@merlins.org>
        <20170514232816.79c2530e@jupiter.sol.kaishome.de>
        <8737c6th8m.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44076 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932948AbdEOSh4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 15 May 2017 14:37:56 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1dAKsN-0001y2-7B
        for linux-bcache@vger.kernel.org; Mon, 15 May 2017 20:37:47 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Mon, 15 May 2017 13:52:09 +0100
schrieb Nix <nix@esperi.org.uk>:

> On 14 May 2017, Kai Krakow said:
> > I had done this previously, too, and had no such message. But I had
> > to use wipefs anyway because otherwise udev came and triggered the
> > device for reasons I couldn't really follow.  
> 
> udev does a blkid to see how the block device needs to be activated:
> this relies on precisely the information wipefs removes. Avoiding this
> problem is why wipefs *exists*. :)

Yes, but something triggered udev when it shouldn't...

This ends up in unregistering/stopping the bcache, then wipefs the
cdev, then look if udev was triggered and eventually stop it again.

I guess everytime I ran "fdisk -l" to double-check the devices, or
"lsblk", or "blkid", udev was triggered and re-enabled the bcache. This
is a race you cannot win. ;-)

-- 
Regards,
Kai

Replies to list-only preferred.
