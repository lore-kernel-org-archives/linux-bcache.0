From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache
 device
Date: Mon, 25 May 2020 01:24:47 +0000
Message-ID: <CY4PR04MB37511266F1D87572D3C648CFE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-3-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:54708 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388104AbgEYBY5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 May 2020 21:24:57 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>

On 2020/05/22 21:18, Coly Li wrote:=0A=
> Fortunately the zoned device management interface is designed to use=0A=
> bio operations, the bcache code just needs to do a little change to=0A=
> handle the zone management bios.=0A=
> =0A=
> Bcache driver needs to handle 5 zone management bios for now, all of=0A=
> them are handled by cached_dev_nodata() since their bi_size values=0A=
> are 0.=0A=
> - REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE, REQ_OP_ZONE_FINISH:=0A=
>     The LBA conversion is already done in cached_dev_make_request(),=0A=
>   just simply send such zone management bios to backing device is=0A=
>   enough.=0A=
> - REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET_ALL:=0A=
>     If thre is cached data (clean or dirty) on cache device covered=0A=
>   by the LBA range of resetting zone(s), such cached data must be=0A=
=0A=
The first part of the sentence is a little unclear... Did you mean:=0A=
=0A=
If the cache device holds data of the target zones, cache invalidation is n=
eeded=0A=
before forwarding...=0A=
=0A=
>   invalidate from the cache device before forwarding the zone reset=0A=
>   bios to the backing device. Otherwise data inconsistency or further=0A=
>   corruption may happen from the view of bcache device.=0A=
>     The difference of REQ_OP_ZONE_RESET_ALL and REQ_OP_ZONE_RESET is=0A=
>   when the zone management bio is to reset all zones, send all zones=0A=
>   number reported by the bcache device (s->d->disk->queue->nr_zones)=0A=
>   into bch_data_invalidate_zones() as parameter 'size_t nr_zones'. If=0A=
>   only reset a single zone, just set 1 as 'size_t nr_zones'.=0A=
> =0A=
> By supporting zone managememnt bios with this patch, now a bcache device=
=0A=
=0A=
s/managememnt/management=0A=
=0A=
> can be formatted by zonefs, and the zones can be reset by truncate -s 0=
=0A=
> on the zone files under seq/ directory. Supporting REQ_OP_ZONE_RESET_ALL=
=0A=
> makes the whole disk zones reset much faster. In my testing on a 14TB=0A=
> zoned SMR hard drive, 1 by 1 resetting 51632 seq zones by sending=0A=
> REQ_OP_ZONE_RESET bios takes 4m34s, by sending a single=0A=
> REQ_OP_ZONE_RESET_ALL bio takes 12s, which is 22x times faster.=0A=
> =0A=
> REQ_OP_ZONE_RESET_ALL is supported by bcache only when the backing device=
=0A=
> supports it. So the bcache queue flag is set QUEUE_FLAG_ZONE_RESETALL on=
=0A=
> only when queue of backing device has such flag, which can be checked by=
=0A=
> calling blk_queue_zone_resetall() on backing device's request queue.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
> Changelog:=0A=
> v2: an improved version without any generic block layer change.=0A=
> v1: initial version depends on other generic block layer changes.=0A=
> =0A=
>  drivers/md/bcache/request.c | 99 ++++++++++++++++++++++++++++++++++++-=
=0A=
>  drivers/md/bcache/super.c   |  2 +=0A=
>  2 files changed, 100 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c=0A=
> index 34f63da2338d..700b8ab5dec9 100644=0A=
> --- a/drivers/md/bcache/request.c=0A=
> +++ b/drivers/md/bcache/request.c=0A=
> @@ -1052,18 +1052,115 @@ static void cached_dev_write(struct cached_dev *=
dc, struct search *s)=0A=
>  	continue_at(cl, cached_dev_write_complete, NULL);=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * Invalidate the LBA range on cache device which is covered by the=0A=
> + * the resetting zones.=0A=
> + */=0A=
> +static int bch_data_invalidate_zones(struct closure *cl,=0A=
> +				      size_t zone_sector,=0A=
> +				      size_t nr_zones)=0A=
=0A=
No need for the line break after the second argument.=0A=
=0A=
> +{=0A=
> +	struct search *s =3D container_of(cl, struct search, cl);=0A=
> +	struct data_insert_op *iop =3D &s->iop;=0A=
> +	int max_keys, free_keys;=0A=
> +	size_t start =3D zone_sector;=0A=
> +	int ret;=0A=
> +=0A=
> +	max_keys =3D (block_bytes(iop->c) - sizeof(struct jset)) /=0A=
> +		   sizeof(uint64_t);=0A=
> +	bch_keylist_init(&iop->insert_keys);=0A=
> +	ret =3D bch_keylist_realloc(&iop->insert_keys, max_keys, iop->c);=0A=
> +	if (ret < 0)=0A=
> +		return -ENOMEM;=0A=
> +=0A=
> +	while (nr_zones-- > 0) {=0A=
> +		atomic_t *journal_ref =3D NULL;=0A=
> +		size_t size =3D s->d->disk->queue->limits.chunk_sectors;=0A=
> +more_keys:=0A=
> +		bch_keylist_reset(&iop->insert_keys);=0A=
> +		free_keys =3D max_keys;=0A=
> +=0A=
> +		while (size > 0 && free_keys >=3D 2) {=0A=
> +			size_t sectors =3D min_t(size_t, size,=0A=
> +					       1U << (KEY_SIZE_BITS - 1));=0A=
> +=0A=
> +			bch_keylist_add(&iop->insert_keys,=0A=
> +					&KEY(iop->inode, start, sectors));=0A=
> +			start +=3D sectors;=0A=
> +			size -=3D sectors;=0A=
> +			free_keys -=3D 2;=0A=
> +		}=0A=
> +=0A=
> +		/* Insert invalidate keys into btree */=0A=
> +		journal_ref =3D bch_journal(iop->c, &iop->insert_keys, NULL);=0A=
> +		if (!journal_ref) {=0A=
> +			ret =3D -EIO;=0A=
> +			break;=0A=
> +		}=0A=
> +=0A=
> +		ret =3D bch_btree_insert(iop->c,=0A=
> +				&iop->insert_keys, journal_ref, NULL);=0A=
> +		atomic_dec_bug(journal_ref);=0A=
> +		if (ret < 0)=0A=
> +			break;=0A=
> +=0A=
> +		if (size)=0A=
> +			goto more_keys;=0A=
> +	}=0A=
> +=0A=
> +	bch_keylist_free(&iop->insert_keys);=0A=
> +=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
>  static void cached_dev_nodata(struct closure *cl)=0A=
>  {=0A=
>  	struct search *s =3D container_of(cl, struct search, cl);=0A=
>  	struct bio *bio =3D &s->bio.bio;=0A=
> +	int nr_zones =3D 1;=0A=
>  =0A=
>  	if (s->iop.flush_journal)=0A=
>  		bch_journal_meta(s->iop.c, cl);=0A=
>  =0A=
> -	/* If it's a flush, we send the flush to the backing device too */=0A=
> +	if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET_ALL ||=0A=
> +	    bio_op(bio) =3D=3D REQ_OP_ZONE_RESET) {=0A=
> +		int err =3D 0;=0A=
> +		/*=0A=
> +		 * If this is REQ_OP_ZONE_RESET_ALL bio, cached data=0A=
> +		 * covered by all zones should be invalidate from the=0A=
=0A=
s/invalidate/invalidated=0A=
=0A=
> +		 * cache device.=0A=
> +		 */=0A=
> +		if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET_ALL)=0A=
> +			nr_zones =3D s->d->disk->queue->nr_zones;=0A=
=0A=
Not: sending a REQ_OP_ZONE_RESET BIO to a conventional zone will be failed =
by=0A=
the disk... This is not allowed by the ZBC/ZAC specs. So invalidation the c=
ache=0A=
for conventional zones is not really necessary. But as an initial support, =
I=0A=
think this is fine. This can be optimized later.=0A=
=0A=
> +=0A=
> +		err =3D bch_data_invalidate_zones(=0A=
> +			cl, bio->bi_iter.bi_sector, nr_zones);=0A=
> +=0A=
> +		if (err < 0) {=0A=
> +			s->iop.status =3D errno_to_blk_status(err);=0A=
> +			/* debug, should be removed before post patch */=0A=
> +			bio->bi_status =3D BLK_STS_TIMEOUT;=0A=
=0A=
You did not remove it :)=0A=
=0A=
> +			/* set by bio_cnt_set() in do_bio_hook() */=0A=
> +			bio_put(bio);=0A=
> +			/*=0A=
> +			 * Invalidate cached data fails, don't send=0A=
> +			 * the zone reset bio to backing device and=0A=
> +			 * return failure. Otherwise potential data=0A=
> +			 * corruption on bcache device may happen.=0A=
> +			 */=0A=
> +			goto continue_bio_complete;=0A=
> +		}=0A=
> +=0A=
> +	}=0A=
> +=0A=
> +	/*=0A=
> +	 * For flush or zone management bios, of cause=0A=
> +	 * they should be sent to backing device too.=0A=
> +	 */=0A=
>  	bio->bi_end_io =3D backing_request_endio;=0A=
>  	closure_bio_submit(s->iop.c, bio, cl);=0A=
=0A=
You cannot submit a REQ_OP_ZONE_RESET_ALL to the backing dev here, at least=
 not=0A=
unconditionally. The problem is that if the backing dev doe not have any=0A=
conventional zones at its LBA 0, REQ_OP_ZONE_RESET_ALL will really reset al=
l=0A=
zones, including the first zone of the device that contains bcache super bl=
ock.=0A=
So you will loose/destroy the bcache setup. You probably did not notice thi=
s=0A=
because your test drive has conventional zones at LBA 0 and reset all does =
not=0A=
have any effect on conventional zones...=0A=
=0A=
The easy way to deal with this is to not set the QUEUE_FLAG_ZONE_RESETALL f=
lag=0A=
for the bcache device queue. If it is not set, the block layer will=0A=
automatically issue only single zone REQ_OP_ZONE_RESET BIOs. That is slower=
,=0A=
yes, but that cannot be avoided when the backend disk does not have any=0A=
conventional zones. The QUEUE_FLAG_ZONE_RESETALL flag can be kept if the ba=
ckend=0A=
disk first zone containing the bcache super block is a conventional zone.=
=0A=
=0A=
>  =0A=
> +continue_bio_complete:=0A=
>  	continue_at(cl, cached_dev_bio_complete, NULL);=0A=
>  }=0A=
>  =0A=
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c=0A=
> index d5da7ad5157d..70c31950ec1b 100644=0A=
> --- a/drivers/md/bcache/super.c=0A=
> +++ b/drivers/md/bcache/super.c=0A=
> @@ -1390,6 +1390,8 @@ static int bch_cached_dev_zone_init(struct cached_d=
ev *dc)=0A=
>  		 */=0A=
>  		d_q->nr_zones =3D b_q->nr_zones -=0A=
>  			(dc->sb.data_offset / d_q->limits.chunk_sectors);=0A=
> +		if (blk_queue_zone_resetall(b_q))=0A=
> +			blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, d_q);=0A=
=0A=
See above comment.=0A=
=0A=
>  	}=0A=
>  =0A=
>  	return 0;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
