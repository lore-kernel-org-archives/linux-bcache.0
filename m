Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ECF3B9614
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 03:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769052327; cv=none; b=sZxklzznVkiWCrTX3DIY/RqgGx9d40OadFk0Araoqc3CfH/UavcmgDkOGQI3SMSd2qKdiYYU8WcooYFfAQLOxBEFuaKVhh7GRMYrRramuQuyUnaoGruINnQcad49GloPVuUgBYJB4BFniNJVuab9EiZIaPuet3VzyWCWzAO+Z7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769052327; c=relaxed/simple;
	bh=L1KOxSlfsaqeTHEfyEMerMMiGaYevZT4YzGPKUdS2tI=;
	h=Subject:From:Date:In-Reply-To:Mime-Version:Content-Type:To:Cc:
	 Message-Id:Content-Disposition:References; b=ftYpcQYiYMfXCUeOvcRwwIlYT8DihaEiEecyybm3k0fJS+ia89HnIct+apEMFrfLPn2PmKDnPDMINTp6080sPUb5tSnggN4vYI6fQjwS3Ojvk6PyrDd2dpvvQnBr7EKU70z6h7jOkqo+3+PR1Fn2gxzf4UYlBjbLNRaJW1YP/Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ujULFKQZ; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ujULFKQZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769052307;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4GuYHkq67wOMif+zk7FU5EaaictjxdqP+VnTPX1cNVU=;
 b=ujULFKQZkdBHEmFkewN8FltmpkbfZzb/Kc+NXIqG1pHlD8hG1Aq/mWGyRglvtLHq+GLNdL
 L6gQcGpr3Bjtzn0E1Mzd4eH9FKMbHY105YaSS1dOPM8zqbWyWLqdrWjB1ZHzNoOGEoSSsA
 62O1U1Cj9kpxqQw93vmYtf4ySrQ8tz/tl5fZiHX05vtIe8Hcwj5aR1n9oRMZZmoQLrzoyv
 7W9f/V3kwQBwJxNhZIZ0z09llgMB3DmYXljZKLJ9LcxoIS5ShMEbFhy+yyIvm/2pXIpEtP
 d/4v3tKpkEqNluYG089jVUwu2KzM323RS4sNMq1pG7ZFl7w6tl7njCsXa+CZGg==
Subject: Re: Fwd: [PATCH v3] bcache: use bio cloning for detached device requests
Content-Transfer-Encoding: quoted-printable
From: "Coly Li" <colyli@fnnas.com>
Date: Thu, 22 Jan 2026 11:25:04 +0800
X-Lms-Return-Path: <lba+269719892+4884c4+vger.kernel.org+colyli@fnnas.com>
In-Reply-To: <CANubcdUShtRu_t+VACzqpeEUdFtxqP+ErYFr-iWHgwqzD18Pog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: "Stephen Zhang" <starzhangzsd@gmail.com>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Jens Axboe" <axboe@kernel.dk>, "Sasha Levin" <sashal@kernel.org>, 
	"Christoph Hellwig" <hch@infradead.org>, <linux-bcache@vger.kernel.org>, 
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, 
	"zhangshida" <zhangshida@kylinos.cn>
Message-Id: <aXGYYse4RjgLenVZ@studio.local>
Content-Disposition: inline
References: <20260122013650.321766-1-zhangshida@kylinos.cn> <CANubcdUShtRu_t+VACzqpeEUdFtxqP+ErYFr-iWHgwqzD18Pog@mail.gmail.com>
Received: from studio.local ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Thu, 22 Jan 2026 11:25:05 +0800

On Thu, Jan 22, 2026 at 09:40:32AM +0800, Stephen Zhang wrote:
> ---------- Forwarded message ---------
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A zhangshida <starzhangzsd@gmail.com>
> Date: 2026=E5=B9=B41=E6=9C=8822=E6=97=A5=E5=91=A8=E5=9B=9B 09:37
> Subject: [PATCH v3] bcache: use bio cloning for detached device requests
> To: <colyli@fnnas.com>, <kent.overstreet@linux.dev>,
> <axboe@kernel.dk>, <sashal@kernel.org>, <hch@infradead.org>
> Cc: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
> <zhangshida@kylinos.cn>, <starzhangzsd@gmail.com>, Christoph Hellwig
> <hch@lst.de>
>=20
>=20
> From: Shida Zhang <zhangshida@kylinos.cn>
>=20
> Previously, bcache hijacked the bi_end_io and bi_private fields of
> the incoming bio when the backing device was in a detached state.
> This is fragile and breaks if the bio is needed to be processed by
> other layers.
>=20
> This patch transitions to using a cloned bio embedded within a private
> structure. This ensures the original bio's metadata remains untouched.
>=20
> Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
> Co-developed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>

Acked-by: Coly Li <colyli@fnnas.com>

Thanks.

Coly Li


> ---
>=20
>=20
> Changelog:
> v2:
> - Renamed `bio_detach` to `bio_detached`
> https://lore.kernel.org/all/CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1=
YGEH9Q@mail.gmail.com/
>=20
> v1:
> https://lore.kernel.org/all/20260115074811.230807-1-zhangshida@kylinos.cn=
/
>=20
>  drivers/md/bcache/bcache.h  |  9 +++++
>  drivers/md/bcache/request.c | 79 ++++++++++++++++---------------------
>  drivers/md/bcache/super.c   | 12 +++++-
>  3 files changed, 54 insertions(+), 46 deletions(-)
>=20
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 8ccacba8554..ec9ff971508 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -273,6 +273,8 @@ struct bcache_device {
>=20
>         struct bio_set          bio_split;
>=20
> +       struct bio_set          bio_detached;
> +
>         unsigned int            data_csum:1;
>=20
>         int (*cache_miss)(struct btree *b, struct search *s,
> @@ -753,6 +755,13 @@ struct bbio {
>         struct bio              bio;
>  };
>=20
> +struct detached_dev_io_private {
> +       struct bcache_device    *d;
> +       unsigned long           start_time;
> +       struct bio              *orig_bio;
> +       struct bio              bio;
> +};
> +
>  #define BTREE_PRIO             USHRT_MAX
>  #define INITIAL_PRIO           32768U
>=20
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 82fdea7dea7..a02aecac05c 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1077,68 +1077,58 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
>         continue_at(cl, cached_dev_bio_complete, NULL);
>  }
>=20
> -struct detached_dev_io_private {
> -       struct bcache_device    *d;
> -       unsigned long           start_time;
> -       bio_end_io_t            *bi_end_io;
> -       void                    *bi_private;
> -       struct block_device     *orig_bdev;
> -};
> -
>  static void detached_dev_end_io(struct bio *bio)
>  {
> -       struct detached_dev_io_private *ddip;
> -
> -       ddip =3D bio->bi_private;
> -       bio->bi_end_io =3D ddip->bi_end_io;
> -       bio->bi_private =3D ddip->bi_private;
> +       struct detached_dev_io_private *ddip =3D
> +               container_of(bio, struct detached_dev_io_private, bio);
> +       struct bio *orig_bio =3D ddip->orig_bio;
>=20
>         /* Count on the bcache device */
> -       bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
> +       bio_end_io_acct(orig_bio, ddip->start_time);
>=20
>         if (bio->bi_status) {
> -               struct cached_dev *dc =3D container_of(ddip->d,
> -                                                    struct cached_dev, d=
isk);
> +               struct cached_dev *dc =3D bio->bi_private;
> +
>                 /* should count I/O error for backing device here */
>                 bch_count_backing_io_errors(dc, bio);
> +               orig_bio->bi_status =3D bio->bi_status;
>         }
>=20
> -       kfree(ddip);
> -       bio_endio(bio);
> +       bio_put(bio);
> +       bio_endio(orig_bio);
>  }
>=20
> -static void detached_dev_do_request(struct bcache_device *d, struct bio =
*bio,
> -               struct block_device *orig_bdev, unsigned long start_time)
> +static void detached_dev_do_request(struct bcache_device *d,
> +               struct bio *orig_bio, unsigned long start_time)
>  {
>         struct detached_dev_io_private *ddip;
>         struct cached_dev *dc =3D container_of(d, struct cached_dev, disk=
);
> +       struct bio *clone_bio;
>=20
> -       /*
> -        * no need to call closure_get(&dc->disk.cl),
> -        * because upper layer had already opened bcache device,
> -        * which would call closure_get(&dc->disk.cl)
> -        */
> -       ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO=
);
> -       if (!ddip) {
> -               bio->bi_status =3D BLK_STS_RESOURCE;
> -               bio_endio(bio);
> +       if (bio_op(orig_bio) =3D=3D REQ_OP_DISCARD &&
> +           !bdev_max_discard_sectors(dc->bdev)) {
> +               bio_endio(orig_bio);
>                 return;
>         }
>=20
> -       ddip->d =3D d;
> +       clone_bio =3D bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
> +                                   &d->bio_detached);
> +       if (!clone_bio) {
> +               orig_bio->bi_status =3D BLK_STS_RESOURCE;
> +               bio_endio(orig_bio);
> +               return;
> +       }
> +
> +       ddip =3D container_of(clone_bio, struct detached_dev_io_private, =
bio);
>         /* Count on the bcache device */
> -       ddip->orig_bdev =3D orig_bdev;
> +       ddip->d =3D d;
>         ddip->start_time =3D start_time;
> -       ddip->bi_end_io =3D bio->bi_end_io;
> -       ddip->bi_private =3D bio->bi_private;
> -       bio->bi_end_io =3D detached_dev_end_io;
> -       bio->bi_private =3D ddip;
> -
> -       if ((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
> -           !bdev_max_discard_sectors(dc->bdev))
> -               detached_dev_end_io(bio);
> -       else
> -               submit_bio_noacct(bio);
> +       ddip->orig_bio =3D orig_bio;
> +
> +       clone_bio->bi_end_io =3D detached_dev_end_io;
> +       clone_bio->bi_private =3D dc;
> +
> +       submit_bio_noacct(clone_bio);
>  }
>=20
>  static void quit_max_writeback_rate(struct cache_set *c,
> @@ -1214,10 +1204,10 @@ void cached_dev_submit_bio(struct bio *bio)
>=20
>         start_time =3D bio_start_io_acct(bio);
>=20
> -       bio_set_dev(bio, dc->bdev);
>         bio->bi_iter.bi_sector +=3D dc->sb.data_offset;
>=20
>         if (cached_dev_get(dc)) {
> +               bio_set_dev(bio, dc->bdev);
>                 s =3D search_alloc(bio, d, orig_bdev, start_time);
>                 trace_bcache_request_start(s->d, bio);
>=20
> @@ -1237,9 +1227,10 @@ void cached_dev_submit_bio(struct bio *bio)
>                         else
>                                 cached_dev_read(dc, s);
>                 }
> -       } else
> +       } else {
>                 /* I/O request sent to backing device */
> -               detached_dev_do_request(d, bio, orig_bdev, start_time);
> +               detached_dev_do_request(d, bio, start_time);
> +       }
>  }
>=20
>  static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index c17d4517af2..238d12ffdae 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -887,6 +887,7 @@ static void bcache_device_free(struct bcache_device *=
d)
>         }
>=20
>         bioset_exit(&d->bio_split);
> +       bioset_exit(&d->bio_detached);
>         kvfree(d->full_dirty_stripes);
>         kvfree(d->stripe_sectors_dirty);
>=20
> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
> bcache_device *d, unsigned int block_size,
>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>                 goto out_ida_remove;
>=20
> +       if (bioset_init(&d->bio_detached, 4,
> +                       offsetof(struct detached_dev_io_private, bio),
> +                       BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> +               goto out_bioset_split_exit;
> +
>         if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
>                 /*
>                  * This should only happen with BCACHE_SB_VERSION_BDEV.
> @@ -964,7 +970,7 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
>=20
>         d->disk =3D blk_alloc_disk(&lim, NUMA_NO_NODE);
>         if (IS_ERR(d->disk))
> -               goto out_bioset_exit;
> +               goto out_bioset_detach_exit;
>=20
>         set_capacity(d->disk, sectors);
>         snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
> @@ -976,7 +982,9 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
>         d->disk->private_data   =3D d;
>         return 0;
>=20
> -out_bioset_exit:
> +out_bioset_detach_exit:
> +       bioset_exit(&d->bio_detached);
> +out_bioset_split_exit:
>         bioset_exit(&d->bio_split);
>  out_ida_remove:
>         ida_free(&bcache_device_idx, idx);
> --
> 2.34.1
