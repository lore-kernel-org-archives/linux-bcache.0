From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2] bcache: export zoned information for backing
 device
Date: Mon, 11 May 2020 09:06:33 +0000
Message-ID: <BY5PR04MB690062564D66C5E3573CE1E1E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200510165232.67500-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16139 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgEKJGh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 11 May 2020 05:06:37 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>

On 2020/05/11 1:52, Coly Li wrote:=0A=
> This is a very basic zoned device support. With this patch, bcache=0A=
> device is able to,=0A=
> - Export zoned device attribution via sysfs=0A=
> - Response report zones request, e.g. by command 'blkzone report'=0A=
> But the bcache device is still NOT able to,=0A=
> - Response any zoned device management request or IOCTL command=0A=
> =0A=
> Here are the testings I have done,=0A=
> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'=0A=
> - read /sys/block/bcache0/queue/nr_zones, content is number of zones=0A=
>   including all zone types.=0A=
> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size=0A=
>   in sectors.=0A=
> - run 'blkzone report /dev/bcache0', all zones information displayed.=0A=
> - run 'blkzone reset /dev/bcache0', operation is rejected with error=0A=
>   information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:=0A=
>   Operation not supported"=0A=
=0A=
Weird. If report zones works, reset should also, modulo the zone size probl=
em=0A=
for the first zone. You may get EINVAL, but not ENOTTY.=0A=
=0A=
> - Sequential writes by dd, I can see some zones' write pointer 'wptr'=0A=
>   values updated.=0A=
> =0A=
> All of these are very basic testings, if you have better testing=0A=
> tools or cases, please offer me hint.=0A=
> =0A=
> Thanks in advance for your review and comments.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> CC: Hannes Reinecke <hare@suse.com>=0A=
> CC: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> CC: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/md/bcache/bcache.h  | 10 +++++=0A=
>  drivers/md/bcache/request.c | 74 +++++++++++++++++++++++++++++++++++++=
=0A=
>  drivers/md/bcache/super.c   | 51 +++++++++++++++++++++----=0A=
>  3 files changed, 128 insertions(+), 7 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h=0A=
> index 74a9849ea164..0d298b48707f 100644=0A=
> --- a/drivers/md/bcache/bcache.h=0A=
> +++ b/drivers/md/bcache/bcache.h=0A=
> @@ -221,6 +221,7 @@ BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);=0A=
>  struct search;=0A=
>  struct btree;=0A=
>  struct keybuf;=0A=
> +struct bch_report_zones_args;=0A=
>  =0A=
>  struct keybuf_key {=0A=
>  	struct rb_node		node;=0A=
> @@ -277,6 +278,8 @@ struct bcache_device {=0A=
>  			  struct bio *bio, unsigned int sectors);=0A=
>  	int (*ioctl)(struct bcache_device *d, fmode_t mode,=0A=
>  		     unsigned int cmd, unsigned long arg);=0A=
> +	int (*report_zones)(struct bch_report_zones_args *args,=0A=
> +			    unsigned int nr_zones);=0A=
>  };=0A=
>  =0A=
>  struct io {=0A=
> @@ -748,6 +751,13 @@ struct bbio {=0A=
>  	struct bio		bio;=0A=
>  };=0A=
>  =0A=
> +struct bch_report_zones_args {=0A=
> +	struct bcache_device *bcache_device;=0A=
> +	sector_t sector;=0A=
> +	void *orig_data;=0A=
> +	report_zones_cb orig_cb;=0A=
> +};=0A=
> +=0A=
>  #define BTREE_PRIO		USHRT_MAX=0A=
>  #define INITIAL_PRIO		32768U=0A=
>  =0A=
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c=0A=
> index 71a90fbec314..bd50204caac7 100644=0A=
> --- a/drivers/md/bcache/request.c=0A=
> +++ b/drivers/md/bcache/request.c=0A=
> @@ -1190,6 +1190,19 @@ blk_qc_t cached_dev_make_request(struct request_qu=
eue *q, struct bio *bio)=0A=
>  		}=0A=
>  	}=0A=
>  =0A=
> +	/*=0A=
> +	 * zone management request may change the data layout and content=0A=
> +	 * implicitly on backing device, which introduces unacceptible=0A=
=0A=
s/unacceptible/unacceptable=0A=
=0A=
> +	 * inconsistency between the backing device and the cache device.=0A=
> +	 * Therefore all zone management related request will be denied here.=
=0A=
> +	 */=0A=
> +	if (op_is_zone_mgmt(bio->bi_opf)) {=0A=
> +		pr_err_ratelimited("zoned device management request denied.");=0A=
> +		bio->bi_status =3D BLK_STS_NOTSUPP;=0A=
> +		bio_endio(bio);=0A=
> +		return BLK_QC_T_NONE;=0A=
=0A=
OK. That explains the operation not supported for "blkzone reset". I do not=
=0A=
think this is good. With this, the drive will be writable only exactly once=
,=0A=
without the possibility for the user to reset any zone and rewrite them. Al=
l=0A=
zone compliant file systems will fail (f2fs, zonefs, btrfs coming).=0A=
=0A=
At the very least REQ_OP_ZONE_RESET should be allowed and trigger an=0A=
invalidation on the cache device of all blocks of the zone that are cached.=
=0A=
=0A=
Note: the zone management operations will need to be remapped like report z=
ones,=0A=
but in reverse: the BIO start sector must be increase by the zone size.=0A=
=0A=
> +	}=0A=
> +=0A=
>  	generic_start_io_acct(q,=0A=
>  			      bio_op(bio),=0A=
>  			      bio_sectors(bio),=0A=
> @@ -1233,6 +1246,24 @@ static int cached_dev_ioctl(struct bcache_device *=
d, fmode_t mode,=0A=
>  	if (dc->io_disable)=0A=
>  		return -EIO;=0A=
>  =0A=
> +	/*=0A=
> +	 * zone management ioctl commands may change the data layout=0A=
> +	 * and content implicitly on backing device, which introduces=0A=
> +	 * unacceptible inconsistency between the backing device and=0A=
> +	 * the cache device. Therefore all zone management related=0A=
> +	 * ioctl commands will be denied here.=0A=
> +	 */=0A=
> +	switch (cmd) {=0A=
> +	case BLKRESETZONE:=0A=
> +	case BLKOPENZONE:=0A=
> +	case BLKCLOSEZONE:=0A=
> +	case BLKFINISHZONE:=0A=
> +		return -EOPNOTSUPP;=0A=
=0A=
Same comment as above. Of note is that only BLKRESETZONE will result in cac=
he=0A=
inconsistency if not taken care of with an invalidation of the cached block=
s of=0A=
the zone on the cache device. Open and close operations have no effect on d=
ata.=0A=
Finish zone will artificially increase the zone write pointer to the end of=
 the=0A=
zone to make it full but without actually writing any data. So there is no =
need=0A=
I think to change anything on the cache device in that case.=0A=
=0A=
> +	default:=0A=
> +		/* Other commands fall through*/=0A=
> +		break;=0A=
> +	}=0A=
> +=0A=
>  	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);=0A=
>  }=0A=
>  =0A=
> @@ -1261,6 +1292,48 @@ static int cached_dev_congested(void *data, int bi=
ts)=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> +static int cached_dev_report_zones_cb(struct blk_zone *zone,=0A=
> +				      unsigned int idx,=0A=
> +				      void *data)=0A=
> +{=0A=
> +	struct bch_report_zones_args *args =3D data;=0A=
> +	struct bcache_device *d =3D args->bcache_device;=0A=
> +	struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);=0A=
> +	unsigned long data_offset =3D dc->sb.data_offset;=0A=
> +=0A=
> +	if (zone->start >=3D data_offset) {=0A=
> +		zone->start -=3D data_offset;=0A=
> +		zone->wp -=3D data_offset;=0A=
=0A=
Since the zone that contains the super block has to be ignored, the remappi=
ng of=0A=
the zone start can be done unconditionally. For the write pointer remapping=
, you=0A=
need to handle several cases: conventional zones, full zones and read-only =
zones=0A=
do not have a valid write pointer value, so no updating. You also need to s=
kip=0A=
offline zones.=0A=
=0A=
> +	} else {=0A=
> +		/*=0A=
> +		 * Normally the first zone is conventional zone,=0A=
> +		 * we don't need to worry about how to maintain=0A=
> +		 * the write pointer.=0A=
> +		 * But the zone->len is special, because the=0A=
> +		 * sector 0 on bcache device is 8KB offset on=0A=
> +		 * backing device indeed.=0A=
> +		 */=0A=
> +		zone->len -=3D data_offset;=0A=
=0A=
This should not be necessary if the first zone containing the super block i=
s=0A=
skipped entirely.=0A=
=0A=
> +	}=0A=
> +=0A=
> +	return args->orig_cb(zone, idx, args->orig_data);=0A=
> +}=0A=
> +=0A=
> +static int cached_dev_report_zones(struct bch_report_zones_args *args,=
=0A=
> +				   unsigned int nr_zones)=0A=
> +{=0A=
> +	struct bcache_device *d =3D args->bcache_device;=0A=
> +	struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);=0A=
> +	sector_t sector =3D args->sector + dc->sb.data_offset;=0A=
> +=0A=
> +	/* sector is real LBA of backing device */=0A=
> +	return blkdev_report_zones(dc->bdev,=0A=
> +				   sector,=0A=
> +				   nr_zones,=0A=
> +				   cached_dev_report_zones_cb,=0A=
> +				   args);=0A=
> +}=0A=
> +=0A=
>  void bch_cached_dev_request_init(struct cached_dev *dc)=0A=
>  {=0A=
>  	struct gendisk *g =3D dc->disk.disk;=0A=
> @@ -1268,6 +1341,7 @@ void bch_cached_dev_request_init(struct cached_dev =
*dc)=0A=
>  	g->queue->backing_dev_info->congested_fn =3D cached_dev_congested;=0A=
>  	dc->disk.cache_miss			=3D cached_dev_cache_miss;=0A=
>  	dc->disk.ioctl				=3D cached_dev_ioctl;=0A=
> +	dc->disk.report_zones			=3D cached_dev_report_zones;=0A=
>  }=0A=
>  =0A=
>  /* Flash backed devices */=0A=
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c=0A=
> index d98354fa28e3..b7d496040cee 100644=0A=
> --- a/drivers/md/bcache/super.c=0A=
> +++ b/drivers/md/bcache/super.c=0A=
> @@ -679,10 +679,31 @@ static int ioctl_dev(struct block_device *b, fmode_=
t mode,=0A=
>  	return d->ioctl(d, mode, cmd, arg);=0A=
>  }=0A=
>  =0A=
> +static int report_zones_dev(struct gendisk *disk,=0A=
> +			    sector_t sector,=0A=
> +			    unsigned int nr_zones,=0A=
> +			    report_zones_cb cb,=0A=
> +			    void *data)=0A=
> +{=0A=
> +	struct bcache_device *d =3D disk->private_data;=0A=
> +	struct bch_report_zones_args args =3D {=0A=
> +		.bcache_device =3D d,=0A=
> +		.sector =3D sector,=0A=
> +		.orig_data =3D data,=0A=
> +		.orig_cb =3D cb,=0A=
> +	};=0A=
> +=0A=
> +	if (d->report_zones)=0A=
> +		return d->report_zones(&args, nr_zones);=0A=
=0A=
It looks to me like this is not necessary. This function could just be=0A=
cached_dev_report_zones() and you can drop the dc->disk.report_zones method=
.=0A=
=0A=
> +=0A=
> +	return -EOPNOTSUPP;=0A=
> +}=0A=
> +=0A=
>  static const struct block_device_operations bcache_ops =3D {=0A=
>  	.open		=3D open_dev,=0A=
>  	.release	=3D release_dev,=0A=
>  	.ioctl		=3D ioctl_dev,=0A=
> +	.report_zones	=3D report_zones_dev,=0A=
>  	.owner		=3D THIS_MODULE,=0A=
>  };=0A=
>  =0A=
> @@ -815,8 +836,12 @@ static void bcache_device_free(struct bcache_device =
*d)=0A=
>  	closure_debug_destroy(&d->cl);=0A=
>  }=0A=
>  =0A=
> -static int bcache_device_init(struct bcache_device *d, unsigned int bloc=
k_size,=0A=
> -			      sector_t sectors, make_request_fn make_request_fn)=0A=
> +static int bcache_device_init(struct cached_dev *dc,=0A=
> +			      struct bcache_device *d,=0A=
> +			      unsigned int block_size,=0A=
> +			      sector_t sectors,=0A=
> +			      make_request_fn make_request_fn)=0A=
> +=0A=
>  {=0A=
>  	struct request_queue *q;=0A=
>  	const size_t max_stripes =3D min_t(size_t, INT_MAX,=0A=
> @@ -886,6 +911,17 @@ static int bcache_device_init(struct bcache_device *=
d, unsigned int block_size,=0A=
>  	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);=0A=
>  	blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);=0A=
>  =0A=
> +	/*=0A=
> +	 * If this is for backing device registration, and it is an=0A=
> +	 * zoned device (e.g. host-managed S.M.R. hard drive), set=0A=
> +	 * up zoned device attribution properly for sysfs interface.=0A=
> +	 */=0A=
> +	if (dc && bdev_is_zoned(dc->bdev)) {=0A=
> +		q->limits.zoned =3D bdev_zoned_model(dc->bdev);=0A=
> +		q->nr_zones =3D blkdev_nr_zones(dc->bdev->bd_disk);=0A=
> +		q->limits.chunk_sectors =3D bdev_zone_sectors(dc->bdev);=0A=
=0A=
You need to call blk_revalidate_disk_zones() here:=0A=
=0A=
	blk_revalidate_disk_zones(dc->bdev->bd_disk);=0A=
=0A=
but call it *after* setting the bc device capacity to=0A=
=0A=
	get_capacity(dc->bdev->bd_disk) - bdev_zone_sectors(dc->bdev);=0A=
=0A=
Which I think is in fact the sectors argument to this function ?=0A=
=0A=
With that information blk_revalidate_disk_zones() will check the zones and =
set=0A=
q->nr_zones.=0A=
=0A=
=0A=
> +	}=0A=
> +=0A=
>  	blk_queue_write_cache(q, true, true);=0A=
>  =0A=
>  	return 0;=0A=
> @@ -1337,9 +1373,9 @@ static int cached_dev_init(struct cached_dev *dc, u=
nsigned int block_size)=0A=
>  		dc->partial_stripes_expensive =3D=0A=
>  			q->limits.raid_partial_stripes_expensive;=0A=
>  =0A=
> -	ret =3D bcache_device_init(&dc->disk, block_size,=0A=
> -			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset,=0A=
> -			 cached_dev_make_request);=0A=
> +	ret =3D bcache_device_init(dc, &dc->disk, block_size,=0A=
> +			dc->bdev->bd_part->nr_sects - dc->sb.data_offset,=0A=
=0A=
dc->sb.data_offset should be the device zone size (chunk sectors) to skip t=
he=0A=
entire first zone and preserve the "all zones have the same size" constrain=
t.=0A=
=0A=
> +			cached_dev_make_request);=0A=
>  	if (ret)=0A=
>  		return ret;=0A=
>  =0A=
> @@ -1451,8 +1487,9 @@ static int flash_dev_run(struct cache_set *c, struc=
t uuid_entry *u)=0A=
>  =0A=
>  	kobject_init(&d->kobj, &bch_flash_dev_ktype);=0A=
>  =0A=
> -	if (bcache_device_init(d, block_bytes(c), u->sectors,=0A=
> -			flash_dev_make_request))=0A=
> +	if (bcache_device_init(NULL, d, block_bytes(c),=0A=
> +			       u->sectors,=0A=
> +			       flash_dev_make_request))=0A=
>  		goto err;=0A=
>  =0A=
>  	bcache_device_attach(d, c, u - c->uuids);=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
