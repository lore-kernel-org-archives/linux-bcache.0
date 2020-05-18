From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 2/4] block: block: change REQ_OP_ZONE_RESET_ALL
 from 8 to 15
Date: Mon, 18 May 2020 00:36:16 +0000
Message-ID: <BY5PR04MB69005EDE7328EEB0FA78872EE7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-3-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20395 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgERAgU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 20:36:20 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>

On 2020/05/16 12:55, Coly Li wrote:=0A=
> For a zoned device, e.g. host managed SMR hard drive, the request op=0A=
> REQ_OP_ZONE_RESET_ALL is to reset LBA of all zones' writer pointers to=0A=
> the start LBA of the zone they belong to. After all the write pointers=0A=
> are reset, all previously stored data is invalid and unaccessible.=0A=
> Therefore this op code changes on-disk data, belongs to WRITE request=0A=
> op code.=0A=
> =0A=
> Similar to the problem of REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET_ALL is=0A=
> even number 8, it means bios with REQ_OP_ZONE_RESET_ALL in bio->bi_opf=0A=
> will be treated as READ request by op_is_write().=0A=
> =0A=
> Same problem will happen when bcache device is created on top of zoned=0A=
> device like host managed SMR hard drive, bcache driver should invalid=0A=
> all cached data for the REQ_OP_ZONE_RESET_ALL request, but this zone=0A=
> management bio is mistakenly treated as READ request and go into bcache=
=0A=
> read code path, which will cause undefined behavior.=0A=
> =0A=
> This patch changes REQ_OP_ZONE_RESET_ALL value from 8 to 15, this new=0A=
> odd number will make bcache driver handle this zone management bio in=0A=
> write request code path properly.=0A=
> =0A=
> Fixes: e84e8f066395 ("block: add req op to reset all zones and flag")=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Jens Axboe <axboe@kernel.dk>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> ---=0A=
> Changelog:=0A=
> v2: fix typo for REQ_OP_ZONE_RESET_ALL.=0A=
> v1: initial version.=0A=
> =0A=
>  include/linux/blk_types.h | 4 ++--=0A=
>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index 8f7bc15a6de3..618032fa1b29 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -284,8 +284,6 @@ enum req_opf {=0A=
>  	REQ_OP_SECURE_ERASE	=3D 5,=0A=
>  	/* write the same sector many times */=0A=
>  	REQ_OP_WRITE_SAME	=3D 7,=0A=
> -	/* reset all the zone present on the device */=0A=
> -	REQ_OP_ZONE_RESET_ALL	=3D 8,=0A=
>  	/* write the zero filled sector many times */=0A=
>  	REQ_OP_WRITE_ZEROES	=3D 9,=0A=
>  	/* Open a zone */=0A=
> @@ -296,6 +294,8 @@ enum req_opf {=0A=
>  	REQ_OP_ZONE_FINISH	=3D 12,=0A=
>  	/* reset a zone write pointer */=0A=
>  	REQ_OP_ZONE_RESET	=3D 13,=0A=
> +	/* reset all the zone present on the device */=0A=
> +	REQ_OP_ZONE_RESET_ALL	=3D 15,=0A=
=0A=
Same comment as for patch 1. And you can probably squash this patch into pa=
tch 1=0A=
to avoid repeating mostly the same explanation twice in the commit message.=
=0A=
REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are very closely related. The l=
atter=0A=
may actually be processed using the former anyway, so the op number change =
for=0A=
both should be a single patch to be consistent.=0A=
=0A=
>  =0A=
>  	/* SCSI passthrough using struct scsi_request */=0A=
>  	REQ_OP_SCSI_IN		=3D 32,=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
