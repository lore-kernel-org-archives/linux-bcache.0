From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] block: change REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL
 to be odd numbers
Date: Mon, 25 May 2020 01:27:59 +0000
Message-ID: <CY4PR04MB37515C060B07C147B14D7629E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522132309.112794-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:12142 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387925AbgEYB2O (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 May 2020 21:28:14 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Keith Busch <kbusch@kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>

On 2020/05/22 22:25, Coly Li wrote:=0A=
> Currently REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are defined as=0A=
> even numbers 6 and 8, such zone reset bios are treated as READ bios by=0A=
> bio_data_dir(), which is obviously misleading.=0A=
> =0A=
> The macro bio_data_dir() is defined in include/linux/bio.h as,=0A=
>  55 #define bio_data_dir(bio) \=0A=
>  56         (op_is_write(bio_op(bio)) ? WRITE : READ)=0A=
> =0A=
> And op_is_write() is defined in include/linux/blk_types.h as,=0A=
> 397 static inline bool op_is_write(unsigned int op)=0A=
> 398 {=0A=
> 399         return (op & 1);=0A=
> 400 }=0A=
> =0A=
> The convention of op_is_write() is when there is data transfer then the=
=0A=
> op code should be odd number, and treat as a write op. bio_data_dir()=0A=
> treats all bio direction as READ if op_is_write() reports false, and=0A=
> WRITE if op_is_write() reports true.=0A=
> =0A=
> Because REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are even numbers,=0A=
> although they don't transfer data but reporting them as READ bio by=0A=
> bio_data_dir() is misleading and might be wrong. Because these two=0A=
> commands will reset the writer pointers of the resetting zones, and all=
=0A=
> content after the reset write pointer will be invalid and unaccessible,=
=0A=
> obviously they are not READ bios in any means.=0A=
> =0A=
> This patch changes REQ_OP_ZONE_RESET from 6 to 15, and changes=0A=
> REQ_OP_ZONE_RESET_ALL from 8 to 17. Now bios with these two op code=0A=
> can be treated as WRITE by bio_data_dir(). Although they don't transfer=
=0A=
> data, now we keep them consistent with REQ_OP_DISCARD and=0A=
> REQ_OP_WRITE_ZEROES with the ituition that they change on-media content=
=0A=
> and should be WRITE request.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>=0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Cc: Jens Axboe <axboe@fb.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> Cc: Shaun Tancheff <shaun.tancheff@seagate.com>=0A=
> ---=0A=
>  include/linux/blk_types.h | 8 ++++----=0A=
>  1 file changed, 4 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index ccb895f911b1..447b46a0accf 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -300,12 +300,8 @@ enum req_opf {=0A=
>  	REQ_OP_DISCARD		=3D 3,=0A=
>  	/* securely erase sectors */=0A=
>  	REQ_OP_SECURE_ERASE	=3D 5,=0A=
> -	/* reset a zone write pointer */=0A=
> -	REQ_OP_ZONE_RESET	=3D 6,=0A=
>  	/* write the same sector many times */=0A=
>  	REQ_OP_WRITE_SAME	=3D 7,=0A=
> -	/* reset all the zone present on the device */=0A=
> -	REQ_OP_ZONE_RESET_ALL	=3D 8,=0A=
>  	/* write the zero filled sector many times */=0A=
>  	REQ_OP_WRITE_ZEROES	=3D 9,=0A=
>  	/* Open a zone */=0A=
> @@ -316,6 +312,10 @@ enum req_opf {=0A=
>  	REQ_OP_ZONE_FINISH	=3D 12,=0A=
>  	/* write data at the current zone write pointer */=0A=
>  	REQ_OP_ZONE_APPEND	=3D 13,=0A=
> +	/* reset a zone write pointer */=0A=
> +	REQ_OP_ZONE_RESET	=3D 15,=0A=
> +	/* reset all the zone present on the device */=0A=
> +	REQ_OP_ZONE_RESET_ALL	=3D 17,=0A=
>  =0A=
>  	/* SCSI passthrough using struct scsi_request */=0A=
>  	REQ_OP_SCSI_IN		=3D 32,=0A=
> =0A=
=0A=
I think this is OK. Not sure if it needs to be a separate patch or if it sh=
ould=0A=
be part of the bcache series... Jens ?=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
