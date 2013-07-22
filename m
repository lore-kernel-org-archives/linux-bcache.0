From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Don't register if a non-bcache superblock is found as
 well
Date: Mon, 22 Jul 2013 13:00:20 +0200
Message-ID: <51ED10C4.2050808@gmail.com>
References: <ksh1nq$dvp$1@ger.gmane.org> <1374430637-12954-1-git-send-email-g2p.code@gmail.com> <51ED0BAB.4040604@excellency.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51ED0BAB.4040604-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Cyril B." <cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org>
Cc: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Gabriel wrote:
>> This should fix it.
>>
>> Because the raid superblock is at the end of the device, bcache's
>> udev rules could detect a bcache device on the unassembled raid
>> member.  A better fix would be to merge probe-bcache into
>> util-linux's blkid.
>
> I'm afraid that doesn't work: with that patch, my backing device doesn't even get registered anymore, since blkid will detect it as XFS:

I just tried making an xfs filesystem on a bcache device,
and the xfs superblock isn't visible to the backing device.

Your problem is likely an old superblock; use wipefs before make-bcache.

If you do find a filesystem that doesn't put its blkid magic
at a fixed offset from the start of the device, we could
consider alternatives, like whitelisting them or porting to blkid.

For now, better safe than sorry.
