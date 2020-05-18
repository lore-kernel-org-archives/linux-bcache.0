From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 4/4] block: set bi_size to REQ_OP_ZONE_RESET bio
Date: Mon, 18 May 2020 00:59:18 +0000
Message-ID: <BY5PR04MB6900FDE1CD0D754084FCCA38E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-5-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:32862 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgERA7W (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 20:59:22 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>, Ajay Joshi <Ajay.Joshi@wdc.com>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>

On 2020/05/16 12:55, Coly Li wrote:=0A=
> Now for zoned device, zone management ioctl commands are converted into=
=0A=
> zone management bios and handled by blkdev_zone_mgmt(). There are 4 zone=
=0A=
> management bios are handled, their op code is,=0A=
> - REQ_OP_ZONE_RESET=0A=
>   Reset the zone's writer pointer and empty all previously stored data.=
=0A=
> - REQ_OP_ZONE_OPEN=0A=
>   Open the zones in the specified sector range, no influence on data.=0A=
> - REQ_OP_ZONE_CLOSE=0A=
>   Close the zones in the specified sector range, no influence on data.=0A=
> - REQ_OP_ZONE_FINISH=0A=
>   Mark the zone as full, no influence on data.=0A=
> All the zone management bios has 0 byte size, a.k.a their bi_size is 0.=
=0A=
> =0A=
> Exept for REQ_OP_ZONE_RESET request, zero length bio works fine for=0A=
> other zone management bio, before the zoned device e.g. host managed SMR=
=0A=
> hard drive can be created as a bcache device.=0A=
> =0A=
> When a bcache device (virtual block device to forward bios like md raid=
=0A=
> drivers) can be created on top of the zoned device, and a fast SSD is=0A=
> attached as a cache device, bcache driver may cache the frequent random=
=0A=
> READ requests on fast SSD to accelerate hot data READ performance.=0A=
> =0A=
> When bcache driver receives a zone management bio for REQ_OP_ZONE_RESET=
=0A=
> op, while forwarding the request to underlying zoned device e.g. host=0A=
> managed SMR hard drive, it should also invalidate all cached data from=0A=
> SSD for the resetting zone. Otherwise bcache will continue provide the=0A=
> outdated cached data to READ request and cause potential data storage=0A=
> inconsistency and corruption.=0A=
> =0A=
> In order to invalidate outdated data from SSD for the reset zone, bcache=
=0A=
> needs to know not only the start LBA but also the range length of the=0A=
> resetting zone. Otherwise, bcache won't be able to accurately invalidate=
=0A=
> the outdated cached data.=0A=
> =0A=
> Is it possible to simply set the bi_size inside bcache driver? The=0A=
> answer is NO. Although every REQ_OP_ZONE_RESET bio has exact length as=0A=
> zone size or q->limits.chunk_sectors, it is possible that some other=0A=
> layer stacking block driver (in the future) exists between bcache driver=
=0A=
> and blkdev_zone_mgmt() where the zone management bio is made.=0A=
=0A=
But bcache "knows" what underlying devices it is using, right ? So getting =
the=0A=
SMR drive zone size using blk_queue_zone_sectors(), bdev_zone_sectors() or =
by=0A=
directly accessing q->limits->chunk_sectors should not be a problem at all,=
 no ?=0A=
=0A=
> =0A=
> The best location to set bi_size is where the zone management bio is=0A=
> composed in blkdev_zone_mgmt(), then no matter how this bio is split=0A=
> before bcache driver receives it, bcache driver can always correctly=0A=
> invalidate the resetting range.=0A=
> =0A=
> This patch sets the bi_size of REQ_OP_ZONE_RESET bio for each resetting=
=0A=
> zone. Here REQ_OP_ZONE_RESET_ALL is special whose bi_size should be set=
=0A=
> as capacity of whole drive size, then bcache can invalidate all cached=0A=
> data from SSD for the zoned backing device.=0A=
=0A=
NACK. The problem here is that struct bio_vec bv_len field and struct bvec_=
iter=0A=
bi_size field are both "unsigned int". So they can describe at most 4G x 51=
2B =3D=0A=
2TB ranges. For REQ_OP_ZONE_RESET_ALL, that is simply way too small (we alr=
eady=0A=
are at 20TB capacity for SMR). One cannot issue a BIO with a length that is=
 the=0A=
entire disk capacity.=0A=
=0A=
I really think that bcache should handle the zone management ops as a speci=
al=0A=
case. I understand the goal of trying to minimize that by integrating them =
as=0A=
much as possible into the regular bcache IO path, but that really seems=0A=
dangerous to me. Since these operations will need remapping in bcache anywa=
y=0A=
(for handling the first hidden zone containing the super block), all specia=
l=0A=
processing can be done under a single "if" which should not impact too much=
=0A=
performance of regular read/write commands in the hot path.=0A=
=0A=
Device mapper has such code: see __split_and_process_bio() and its use of=
=0A=
op_is_zone_mgmt() function to handle zone management requests slightly=0A=
differently than other BIOs. That remove the need for relying on op_is_writ=
e()=0A=
direction (patch 1 and 2 in this series) for reset zones too, which in the =
end=0A=
will I think make your bcache code a lot more solid.=0A=
=0A=
> =0A=
> With this change, now bcache code can handle REQ_OP_ZONE_RESET bio in=0A=
> the way very similar to REQ_OP_DISCARD bio with very little change.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Ajay Joshi <ajay.joshi@wdc.com>=0A=
> Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> ---=0A=
> Changelog:=0A=
> v2: fix typo for REQ_OP_ZONE_RESET_ALL.=0A=
> v1: initial version.=0A=
> =0A=
>  block/blk-zoned.c | 4 ++++=0A=
>  1 file changed, 4 insertions(+)=0A=
> =0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index 1e0708c68267..01d91314399b 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -227,11 +227,15 @@ int blkdev_zone_mgmt(struct block_device *bdev, enu=
m req_opf op,=0A=
>  		if (op =3D=3D REQ_OP_ZONE_RESET &&=0A=
>  		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {=0A=
>  			bio->bi_opf =3D REQ_OP_ZONE_RESET_ALL;=0A=
> +			bio->bi_iter.bi_sector =3D sector;=0A=
> +			bio->bi_iter.bi_size =3D nr_sectors;=0A=
>  			break;=0A=
>  		}=0A=
>  =0A=
>  		bio->bi_opf =3D op | REQ_SYNC;=0A=
>  		bio->bi_iter.bi_sector =3D sector;=0A=
> +		if (op =3D=3D REQ_OP_ZONE_RESET)=0A=
> +			bio->bi_iter.bi_size =3D zone_sectors;=0A=
>  		sector +=3D zone_sectors;=0A=
>  =0A=
>  		/* This may take a while, so be nice to others */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
