From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v4 0/3] bcache: support zoned device as bcache backing
 device
Date: Mon, 25 May 2020 05:25:31 +0000
Message-ID: <CY4PR04MB3751BEA457F5B95A4D6EFB01E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 2020/05/22 21:19, Coly Li wrote:=0A=
> Hi folks,=0A=
> =0A=
> This is series, now bcache can support zoned device (e.g. host managed=0A=
> SMR hard drive) as the backing deice. Currently writeback mode is not=0A=
> support yet, which is on the to-do list (requires on-disk super block=0A=
> format change).=0A=
> =0A=
> The first patch makes bcache to export the zoned information to upper=0A=
> layer code, for example formatting zonefs on top of the bcache device.=0A=
> By default, zone 0 of the zoned device is fully reserved for bcache=0A=
> super block, therefore the reported zones number is 1 less than the=0A=
> exact zones number of the physical SMR hard drive.=0A=
> =0A=
> The second patch handles zone management command for bcache. Indeed=0A=
> these zone management commands are wrappered as zone management bios.=0A=
> For REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL zone management bios,=0A=
> before forwarding the bio to backing device, all cached data covered=0A=
> by the resetting zone(s) must be invalidated to keep data consistency.=0A=
> For rested zone management bios just minus the bi_sector by data_offset=
=0A=
> and simply forward to the zoned backing device.=0A=
> =0A=
> The third patch is to make sure after bcache device starts, the cache=0A=
> mode cannot be changed to writeback via sysfs interface. Bcache-tools=0A=
> is modified to notice users and convert to writeback mode to the default=
=0A=
> writethrough mode when making a bcache device.=0A=
> =0A=
> There is one thing not addressed by this series, that is re-write the=0A=
> bcache super block after REQ_OP_ZONE_RESET_ALL command. There will be=0A=
> quite soon that all seq zones device may appear, but it is OK to make=0A=
> bcache support such all seq-zones device a bit later.=0A=
> =0A=
> Now a bcache device created with a zoned SMR drive can pass these test=0A=
> cases,=0A=
> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'=0A=
> - read /sys/block/bcache0/queue/nr_zones, content is number of zones=0A=
>   excluding zone 0 of the backing device (reserved for bcache super=0A=
>   block).=0A=
> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size=0A=
>   in sectors.=0A=
> - run 'blkzone report /dev/bcache0', all zones information displayed.=0A=
> - run 'blkzone reset -o <zone LBA> -c <zones number> /dev/bcache0',=0A=
>   conventional zones will reject the command, seqential zones covered=0A=
>   by the command range will reset its write pointer to start LBA of=0A=
>   their zones. If <zone LBA> is 0 and <zones number> covers all zones,=0A=
>   REQ_OP_ZONE_RESET_ALL command will be received and handled by bcache=0A=
>   device properly.=0A=
> - zonefs can be created on top of the bcache device, with/without cache=
=0A=
>   device attached. All sequential direct write and random read work well=
=0A=
>   and zone reset by 'truncate -s 0 <zone file>' works too.=0A=
> - Writeback cache mode does not support yet.=0A=
> =0A=
> Now all prevous code review comments are addressed by this RFC version.=
=0A=
> Please don't hesitate to offer your opinion on this version.=0A=
> =0A=
> Thanks in advance for your help.=0A=
=0A=
Coly,=0A=
=0A=
One more thing: your patch series lacks support for REQ_OP_ZONE_APPEND. It =
would=0A=
be great to add that. As is, since you do not set the max_zone_append_secto=
rs=0A=
queue limit for the bcache device, that command will not be issued by the b=
lock=0A=
layer. But zonefs (and btrfs) will use zone append in (support for zonefs i=
s=0A=
queued already in 5.8, btrfs will come later).=0A=
=0A=
If bcache writethrough policy results in a data write to be issued to both =
the=0A=
backend device and the cache device, then some special code will be needed:=
=0A=
these 2 BIOs will need to be serialized since the actual write location of =
a=0A=
zone append command is known only on completion of the command. That is, th=
e=0A=
zone append BIO needs to be issued to the backend device first, then to the=
=0A=
cache SSD device as a regular write once the zone append completes and its =
write=0A=
location is known.=0A=
=0A=
=0A=
> =0A=
> Coly Li=0A=
> ---=0A=
> Changelog:=0A=
> v4: another improved version without any other generic block change.=0A=
> v3: an improved version depends on other generic block layer changes.=0A=
> v2: the first RFC version for comments and review.=0A=
> v1: the initial version posted just for information.=0A=
> =0A=
> =0A=
> Coly Li (3):=0A=
>   bcache: export bcache zone information for zoned backing device=0A=
>   bcache: handle zone management bios for bcache device=0A=
>   bcache: reject writeback cache mode for zoned backing device=0A=
> =0A=
>  drivers/md/bcache/bcache.h  |  10 +++=0A=
>  drivers/md/bcache/request.c | 168 +++++++++++++++++++++++++++++++++++-=
=0A=
>  drivers/md/bcache/super.c   |  98 ++++++++++++++++++++-=0A=
>  drivers/md/bcache/sysfs.c   |   5 ++=0A=
>  4 files changed, 279 insertions(+), 2 deletions(-)=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
