From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date: Mon, 18 May 2020 00:33:21 +0000
Message-ID: <BY5PR04MB69005621AE920061F7FD383CE7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-bcache@vger.kernel.org

On 2020/05/16 12:55, Coly Li wrote:=0A=
> For a zoned device, e.g. host managed SMR hard drive, REQ_OP_ZONE_RESET=
=0A=
> is to reset the LBA of a zone's write pointer back to the start LBA of=0A=
> this zone. After the write point is reset, all previously stored data=0A=
> in this zone is invalid and unaccessible anymore. Therefore, this op=0A=
> code changes on disk data, belongs to a WRITE request op code.=0A=
> =0A=
> Current REQ_OP_ZONE_RESET is defined as number 6, but the convention of=
=0A=
> the op code is, READ requests are even numbers, and WRITE requests are=0A=
> odd numbers. See how op_is_write defined,=0A=
> =0A=
> 397 static inline bool op_is_write(unsigned int op)=0A=
> 398 {=0A=
> 399         return (op & 1);=0A=
> 400 }=0A=
> =0A=
> When create bcache device on top of the zoned SMR drive, bcache driver=0A=
> has to handle the REQ_OP_ZONE_RESET bio by invalidate all cached data=0A=
> belongs to the LBA range of the restting zone. A wrong op code value=0A=
> will make the this zone management bio goes into bcache' read requests=0A=
> code path and causes undefined result.=0A=
> =0A=
> This patch changes REQ_OP_ZONE_RESET value from 6 to 13, the new odd=0A=
> number will make bcache driver handle this zone management bio properly=
=0A=
> in write requests code path.=0A=
> =0A=
> Fixes: 87374179c535 ("block: add a proper block layer data direction enco=
ding")=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Cc: Jens Axboe <axboe@fb.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> Cc: Shaun Tancheff <shaun.tancheff@seagate.com>=0A=
> ---=0A=
>  include/linux/blk_types.h | 4 ++--=0A=
>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index 31eb92876be7..8f7bc15a6de3 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -282,8 +282,6 @@ enum req_opf {=0A=
>  	REQ_OP_DISCARD		=3D 3,=0A=
>  	/* securely erase sectors */=0A=
>  	REQ_OP_SECURE_ERASE	=3D 5,=0A=
> -	/* reset a zone write pointer */=0A=
> -	REQ_OP_ZONE_RESET	=3D 6,=0A=
>  	/* write the same sector many times */=0A=
>  	REQ_OP_WRITE_SAME	=3D 7,=0A=
>  	/* reset all the zone present on the device */=0A=
> @@ -296,6 +294,8 @@ enum req_opf {=0A=
>  	REQ_OP_ZONE_CLOSE	=3D 11,=0A=
>  	/* Transition a zone to full */=0A=
>  	REQ_OP_ZONE_FINISH	=3D 12,=0A=
> +	/* reset a zone write pointer */=0A=
> +	REQ_OP_ZONE_RESET	=3D 13,=0A=
=0A=
As Chaitanya pointed out, this is already used. Please rebase on Jens=0A=
block/for-5.8/block branch.=0A=
=0A=
I do not see any problem with this change, but as Christoph commented, sinc=
e=0A=
zone reset does not transfer any data, I do not really see the necessity fo=
r=0A=
this. Zone reset is indeed data-destructive, but it is not a "write" comman=
d.=0A=
But following DISCARD and having the op number as an odd number is OK I thi=
nk.=0A=
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
