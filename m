From: Nix <nix@esperi.org.uk>
Subject: Re: Add Bcache to an existing Filesystem
Date: Tue, 27 Jun 2017 14:45:08 +0100
Message-ID: <878tkdy26z.fsf@esperi.org.uk>
References: <46fc48b2-55db-471f-8318-5e60555e228e@upx.com>
        <CAPmG0jZyiA-3xbjoQFRP4X9Xkra6aOsbojK8HJqAALdycPkajQ@mail.gmail.com>
        <864cf409-86ca-dbe1-c6bc-89667a978f44@upx.com>
        <CAPmG0jZ2ye9z-n8efF9zd7CbBDVFoykrszceq10WpepaGrhx5Q@mail.gmail.com>
        <20170627104654.Horde.qG1pMDnsa0LUeSdzxkMOzCc@webmail.nde.ag>
        <87d19py36k.fsf@esperi.org.uk>
        <bbf7d8b5-5d0d-c4ae-7af4-9799b6a5ed25@upx.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:52240 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbdF0NpL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 09:45:11 -0400
In-Reply-To: <bbf7d8b5-5d0d-c4ae-7af4-9799b6a5ed25@upx.com> (FERNANDO
        FREDIANI's message of "Tue, 27 Jun 2017 10:37:47 -0300")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>
Cc: linux-bcache@vger.kernel.org

On 27 Jun 2017, FERNANDO FREDIANI said:

> Hello Nix
>
> What exactlly you mean by "exploded" ? Has it stopped working at all
> and has that stopped the systems running on the top of it or it just
> stopped the caching device and the backing continued to work well.

It stopped the caching device and refused to mount the rootfs atop it
until I explicitly dissociated it. I haven't reactivated it since (I
might do so once I've rejigged my shutdown process to fully unmount
everything via the early root filesystem, but this system is a crucial
machine in active use and it takes ages to get around to such things).

See <https://marc.info/?l=linux-bcache&m=149687387202378>.

> Regarding my scenario, just to clarify I have 4 x /dev/sdX forming a
> /dev/md124 in RAID 10. This /dev/md124 is the backing device of my
> bcache which in turn has /dev/nvme0n1 as the caching device making
> /dev/bcache0. I guess this would be the most coming scenario right ?

I think so: s/RAID 10/journalled RAID 6/ and you have my setup (well,
part of it: the start of the disk is in uncached RAID-0, and the end is
in unjournalled, uncached RAID-6 with a write bitmap, but the middle
portion is a RAID-6 with bcache -- albeit, presently, in 'none' mode.)

-- 
NULL && (void)
