From: Gabriel <g2p.code@gmail.com>
Subject: Re: [PATCH] bcache: Take data offset from the bdev superblock.
Date: Mon, 08 Apr 2013 23:23:59 +0200
Message-ID: <5163356F.50406@gmail.com>
References: <51629766.6030805@gmail.com> <1365415866-16344-1-git-send-email-g2p.code+bcache@gmail.com> <20130408204956.GH15749@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130408204956.GH15749@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Gabriel <g2p.code+bcache@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Le lun. 08 avril 2013 22:49:56 CEST, Kent Overstreet a =C3=A9crit :
> On Mon, Apr 08, 2013 at 12:11:06PM +0200, Gabriel wrote:
>> Add a new superblock version, and consolidate related defines.
>
> So, I think BDEV_WITH_OFFSET looks ok, but what's the use case for it=
? I
> was going to add it way back but we decided not to implement the hack=
 we
> thought we needed it for - if you or someone is going to use it I'll =
go
> ahead and apply it.

It's for converting existing devices to bcache.

https://github.com/g2p/blocks converts a partition to bcache by putting
a bcache superblock immediately before and shifting the partition start
to the left by exactly 1MB.  The 1MB alignment is to play nice with=20
other partitioning tools and drives with 4k sectors.

blocks also converts logical volumes to bcache, and for that it has to=20
insert exactly 4MB (an LVM physical extent) before the filesystem data.

I'm already using the new format, it allowed me to get rid of some=20
complicated stuff that sandwiched a partition table on top of an LV so=20
that the original filesystem data was at the start of its container dev=
ice.

> As for BCACHE_SB_VERSION_CDEV_WITH_UUID, can you explain why you adde=
d
> that? I suspect it's needed but I can't remember why I didn't add it
> when I added the new UUID format (or perhaps I just forgot)

I took the name from a comment in the kernel-side bcache.h.
BCACHE_SB_VERSION_CDEV is the version make-bcache writes, and=20
BCACHE_SB_VERSION_CDEV_WITH_UUID is what the kernel updates it too; I=20
just changed the version names so that user-side and kernel-side were=20
more consistent, internally and with each other.
The kernel doesn't discriminate these two versions when opening, so it=20
should be possible to define only the latter and deprecate the other.
