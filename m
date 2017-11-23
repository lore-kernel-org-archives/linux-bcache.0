From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Thu, 23 Nov 2017 12:43:26 +0100
Message-ID: <20171123124326.53b7d3a0@jupiter.sol.kaishome.de>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
        <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
        <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
        <58151524-1294-2c8a-42a0-a5f21886625d@coly.li>
        <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
        <f6c02ce5-eeff-955f-53a6-0db07aaecd08@lyle.org>
        <eee65109-aa05-d639-e0fe-12259e726803@profihost.ag>
        <93a1e381-ea82-b5c0-444b-6bdd3062e7f0@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43181 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdKWLnj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Nov 2017 06:43:39 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1eHpuh-0005sw-LC
        for linux-bcache@vger.kernel.org; Thu, 23 Nov 2017 12:43:27 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Wed, 22 Nov 2017 20:42:20 +0100
schrieb Stefan Priebe - Profihost AG <s.priebe@profihost.ag>:

> Hi Coly,
>   Hi Michael,
> 
> 
> Am 22.11.2017 um 20:06 schrieb Stefan Priebe - Profihost AG:
> > Am 22.11.2017 um 18:51 schrieb Michael Lyle:  
> >> Hi Coly, Stefan--
> >>
> >> On 11/22/2017 05:14 AM, Stefan Priebe - Profihost AG wrote:  
>  [...]  
>  [...]  
> >>
> >> I don't think there's any chance this patch will do anything.  If
> >> there's a deadlock, the whole thing will become stuck forever and
> >> never allow registration or progress on the device again-- which
> >> doesn't match the symptoms here.  
> > 
> > No it does not ;-)
> >   
> >> This probably relates to udev configuration in your environment
> >> somehow.  
> 
> I found the problem the device is not detected as bcache by blkid -
> see here:
> 
> '/sbin/blkid -o udev -p /dev/sdf1'(out) 'ID_FS_AMBIVALENT=other:bcache
> other:xfs_external_log'
> 
> normally it looks like this:
> '/sbin/blkid -o udev -p /dev/sdg1'(out) 'ID_FS_TYPE=bcache'
> 
> so instead of setting the FS_TYPE to bcache it's ID_FS_AMBIVALENT
> which skips the bcache udev rules.
> 
> Just no idea how to fix that.

Maybe move bcache ontop of other FS in /etc/filesystems?

There's maybe an orphan XFS superblock hanging around. You could
disassemble the bcache device, wipefs, and recreate.


-- 
Regards,
Kai

Replies to list-only preferred.
