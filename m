From: "Cyril B." <cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org>
Subject: Re: [PATCH] Don't register if a non-bcache superblock is found as
 well
Date: Mon, 22 Jul 2013 12:38:35 +0200
Message-ID: <51ED0BAB.4040604@excellency.fr>
References: <ksh1nq$dvp$1@ger.gmane.org> <1374430637-12954-1-git-send-email-g2p.code@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374430637-12954-1-git-send-email-g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Gabriel wrote:
> This should fix it.
>
> Because the raid superblock is at the end of the device, bcache's
> udev rules could detect a bcache device on the unassembled raid
> member.  A better fix would be to merge probe-bcache into
> util-linux's blkid.


I'm afraid that doesn't work: with that patch, my backing device doesn't 
even get registered anymore, since blkid will detect it as XFS:

# /sbin/blkid -o udev /dev/md10
ID_FS_UUID=08e8619f-6815-4380-b8c8-9eab18d1643c
ID_FS_UUID_ENC=08e8619f-6815-4380-b8c8-9eab18d1643c
ID_FS_TYPE=xfs

Cyril
