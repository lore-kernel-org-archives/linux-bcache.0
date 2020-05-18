From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Date: Mon, 18 May 2020 00:39:57 +0000
Message-ID: <BY5PR04MB69002D8AB1B63F428D28428FE7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-4-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kbusch@kernel.org" <kbusch@kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 2020/05/16 12:55, Coly Li wrote:=0A=
> The bcache driver is bio based and NOT request based multiqueued driver,=
=0A=
> if a zoned SMR hard drive is used as backing device of a bcache device,=
=0A=
> calling blk_revalidate_disk_zones() for the bcache device will fail due=
=0A=
> to the following check in blk_revalidate_disk_zones(),=0A=
> 478       if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
> 479             return -EIO;=0A=
> =0A=
> Now bcache is able to export the zoned information from the underlying=0A=
> zoned SMR drives and format zonefs on top of a bcache device, the=0A=
> resitriction that a zoned device should be multiqueued is unnecessary=0A=
> for now.=0A=
> =0A=
> Although in commit ae58954d8734c ("block: don't handle bio based drivers=
=0A=
> in blk_revalidate_disk_zones") it is said that bio based drivers should=
=0A=
> not call blk_revalidate_disk_zones() and just manually update their own=
=0A=
> q->nr_zones, but this is inaccurate. The bio based drivers also need to=
=0A=
> set their zone size and initialize bitmaps for cnv and seq zones, it is=
=0A=
> necessary to call blk_revalidate_disk_zones() for bio based drivers.=0A=
> =0A=
> This patch removes the above queue_is_mq() restriction to permit=0A=
> bcache driver calls blk_revalidate_disk_zones() for bcache device zoned=
=0A=
> information initialization.=0A=
> =0A=
> Fixes: ae58954d8734c ("block: don't handle bio based drivers in blk_reval=
idate_disk_zones")=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Jens Axboe <axboe@kernel.dk>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> ---=0A=
>  block/blk-zoned.c | 2 --=0A=
>  1 file changed, 2 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index f87956e0dcaf..1e0708c68267 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -475,8 +475,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk)=
=0A=
>  =0A=
>  	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))=0A=
>  		return -EIO;=0A=
> -	if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
> -		return -EIO;=0A=
=0A=
Same comment as Christoph: BIO drivers can set nr_zones and chunk_sectors=
=0A=
themselves, manually. They also do not need the bitmaps as BIO devices do n=
ot=0A=
have an elevator, and as Christoph said, can (if needed) look at the bitmap=
s of=0A=
the underlying device (e.g. for zone conv vs seq zone type differentiation)=
.=0A=
=0A=
So I do not think this patch is needed, and would only cause more memory=0A=
consumption for no good reason that I can see.=0A=
=0A=
>  =0A=
>  	/*=0A=
>  	 * Ensure that all memory allocations in this context are done as if=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
