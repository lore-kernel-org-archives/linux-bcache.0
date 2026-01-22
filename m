Received: from sg-1-23.ptr.blmpb.com (sg-1-23.ptr.blmpb.com [118.26.132.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8FB47DD56
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 07:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769068468; cv=none; b=A4yaJs0hYKd/y2gvr2SfbyLFs+h0YJQHcHynKWCVm2S5/dW+8WuGNh22Wg00OFzjqR2f5IvqcCZAZVaFVFpkvAIjKGmxBGRRzwEtjF7Pr6PdMdmOlA4avefSsmFjd6AasJkEloyUuRBXTu3rY1EXbsyJz7lDsgS4/Kk8udUUFMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769068468; c=relaxed/simple;
	bh=rqhEQAZNHmYJ+vNl2taNH/lrZpJGNWHkcUNWt4gKGAo=;
	h=To:Date:Content-Disposition:Content-Type:In-Reply-To:References:
	 Cc:From:Subject:Message-Id:Mime-Version; b=Z5X8MsasUu6VN/iTRLuaQl0Rm9u5FFWAcZAOK7aNlDNPLcnS35BTH993Rc5aXeRNqEC2TgiF4PTxweA9lWF5GoCnuHipmvAWoDjv1fRziNX2Mxt2pa+069cXuVlP2BIgvMT0glPSKoad+4qqCeKa5u78+xaEVSUZ22ZR0RIA5Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=DVT4zquY; arc=none smtp.client-ip=118.26.132.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="DVT4zquY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769068453;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=h6OqwW7Mo0EDXdHzz8SjdspoC4z3NgrHx04EPrnccRE=;
 b=DVT4zquY71Ae3aJ7lCq+NFC4OzEYIjPx8RBozZ5fzq6taiPN2+J9HboJhgY0hZ31oUXiPp
 qApm9YKEr20/xNmdz/dsFZ6hFoyK/tIZtH6/KxhCcRQ6tepy8qyCwKBZAPM/6CdW0bIql5
 zTnu44Ui03iJGx9yV+ygOAQTYYBYk6VDGUkXMF9Zif/Qln4oApml7PN9ILV/2HkWKa0Xn6
 54RWSKJormi0E+G8I+TRMlu3nJ7hlbsQoZXtMreaP34DPwS4oQUQ9N/or/EvfUrAIPU0ss
 Y2fmOKrzE7hclZmPePhrDUphVWb+FjBaFW3QPKi5BeDEGdsa3yip9yubHNjoLw==
To: <zhangshida2026@163.com>
Date: Thu, 22 Jan 2026 15:54:09 +0800
Received: from studio.local ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Thu, 22 Jan 2026 15:54:10 +0800
Content-Disposition: inline
X-Lms-Return-Path: <lba+26971d7a3+d0bea3+vger.kernel.org+colyli@fnnas.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260122061321.359218-1-zhangshida2026@163.com>
References: <20260122061321.359218-1-zhangshida2026@163.com>
Cc: <kent.overstreet@linux.dev>, <axboe@kernel.dk>, <sashal@kernel.org>, 
	<hch@infradead.org>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <zhangshida@kylinos.cn>, 
	<starzhangzsd@gmail.com>, "Christoph Hellwig" <hch@lst.de>
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH RESEND v3] bcache: use bio cloning for detached device requests
Message-Id: <aXHXismbTcMCPLab@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>

On Thu, Jan 22, 2026 at 02:13:21PM +0800, zhangshida2026@163.com wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> Previously, bcache hijacked the bi_end_io and bi_private fields of
> the incoming bio when the backing device was in a detached state.
> This is fragile and breaks if the bio is needed to be processed by
> other layers.
> 
> This patch transitions to using a cloned bio embedded within a private
> structure. This ensures the original bio's metadata remains untouched.
> 
> Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
> Co-developed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>

Acked-by: Coly Li <colyli@fnnas.com>

Thanks.

Coly Li


> ---
>  drivers/md/bcache/bcache.h  |  9 +++++
>  drivers/md/bcache/request.c | 79 ++++++++++++++++---------------------
>  drivers/md/bcache/super.c   | 12 +++++-
>  3 files changed, 54 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 8ccacba8554..ec9ff971508 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -273,6 +273,8 @@ struct bcache_device {
>  
>  	struct bio_set		bio_split;
>  
> +	struct bio_set		bio_detached;
> +
>  	unsigned int		data_csum:1;
>  
>  	int (*cache_miss)(struct btree *b, struct search *s,
> @@ -753,6 +755,13 @@ struct bbio {
>  	struct bio		bio;
>  };
>  
> +struct detached_dev_io_private {
> +	struct bcache_device	*d;
> +	unsigned long		start_time;
> +	struct bio		*orig_bio;
> +	struct bio              bio;
> +};
> +
>  #define BTREE_PRIO		USHRT_MAX
>  #define INITIAL_PRIO		32768U
>  
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 82fdea7dea7..a02aecac05c 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1077,68 +1077,58 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
>  	continue_at(cl, cached_dev_bio_complete, NULL);
>  }
>  
> -struct detached_dev_io_private {
> -	struct bcache_device	*d;
> -	unsigned long		start_time;
> -	bio_end_io_t		*bi_end_io;
> -	void			*bi_private;
> -	struct block_device	*orig_bdev;
> -};
> -
>  static void detached_dev_end_io(struct bio *bio)
>  {
> -	struct detached_dev_io_private *ddip;
> -
> -	ddip = bio->bi_private;
> -	bio->bi_end_io = ddip->bi_end_io;
> -	bio->bi_private = ddip->bi_private;
> +	struct detached_dev_io_private *ddip =
> +		container_of(bio, struct detached_dev_io_private, bio);
> +	struct bio *orig_bio = ddip->orig_bio;
>  
>  	/* Count on the bcache device */
> -	bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
> +	bio_end_io_acct(orig_bio, ddip->start_time);
>  
>  	if (bio->bi_status) {
> -		struct cached_dev *dc = container_of(ddip->d,
> -						     struct cached_dev, disk);
> +		struct cached_dev *dc = bio->bi_private;
> +
>  		/* should count I/O error for backing device here */
>  		bch_count_backing_io_errors(dc, bio);
> +		orig_bio->bi_status = bio->bi_status;
>  	}
>  
> -	kfree(ddip);
> -	bio_endio(bio);
> +	bio_put(bio);
> +	bio_endio(orig_bio);
>  }
>  
> -static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
> -		struct block_device *orig_bdev, unsigned long start_time)
> +static void detached_dev_do_request(struct bcache_device *d,
> +		struct bio *orig_bio, unsigned long start_time)
>  {
>  	struct detached_dev_io_private *ddip;
>  	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
> +	struct bio *clone_bio;
>  
> -	/*
> -	 * no need to call closure_get(&dc->disk.cl),
> -	 * because upper layer had already opened bcache device,
> -	 * which would call closure_get(&dc->disk.cl)
> -	 */
> -	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
> -	if (!ddip) {
> -		bio->bi_status = BLK_STS_RESOURCE;
> -		bio_endio(bio);
> +	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
> +	    !bdev_max_discard_sectors(dc->bdev)) {
> +		bio_endio(orig_bio);
>  		return;
>  	}
>  
> -	ddip->d = d;
> +	clone_bio = bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
> +				    &d->bio_detached);
> +	if (!clone_bio) {
> +		orig_bio->bi_status = BLK_STS_RESOURCE;
> +		bio_endio(orig_bio);
> +		return;
> +	}
> +
> +	ddip = container_of(clone_bio, struct detached_dev_io_private, bio);
>  	/* Count on the bcache device */
> -	ddip->orig_bdev = orig_bdev;
> +	ddip->d = d;
>  	ddip->start_time = start_time;
> -	ddip->bi_end_io = bio->bi_end_io;
> -	ddip->bi_private = bio->bi_private;
> -	bio->bi_end_io = detached_dev_end_io;
> -	bio->bi_private = ddip;
> -
> -	if ((bio_op(bio) == REQ_OP_DISCARD) &&
> -	    !bdev_max_discard_sectors(dc->bdev))
> -		detached_dev_end_io(bio);
> -	else
> -		submit_bio_noacct(bio);
> +	ddip->orig_bio = orig_bio;
> +
> +	clone_bio->bi_end_io = detached_dev_end_io;
> +	clone_bio->bi_private = dc;
> +
> +	submit_bio_noacct(clone_bio);
>  }
>  
>  static void quit_max_writeback_rate(struct cache_set *c,
> @@ -1214,10 +1204,10 @@ void cached_dev_submit_bio(struct bio *bio)
>  
>  	start_time = bio_start_io_acct(bio);
>  
> -	bio_set_dev(bio, dc->bdev);
>  	bio->bi_iter.bi_sector += dc->sb.data_offset;
>  
>  	if (cached_dev_get(dc)) {
> +		bio_set_dev(bio, dc->bdev);
>  		s = search_alloc(bio, d, orig_bdev, start_time);
>  		trace_bcache_request_start(s->d, bio);
>  
> @@ -1237,9 +1227,10 @@ void cached_dev_submit_bio(struct bio *bio)
>  			else
>  				cached_dev_read(dc, s);
>  		}
> -	} else
> +	} else {
>  		/* I/O request sent to backing device */
> -		detached_dev_do_request(d, bio, orig_bdev, start_time);
> +		detached_dev_do_request(d, bio, start_time);
> +	}
>  }
>  
>  static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index c17d4517af2..238d12ffdae 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -887,6 +887,7 @@ static void bcache_device_free(struct bcache_device *d)
>  	}
>  
>  	bioset_exit(&d->bio_split);
> +	bioset_exit(&d->bio_detached);
>  	kvfree(d->full_dirty_stripes);
>  	kvfree(d->stripe_sectors_dirty);
>  
> @@ -949,6 +950,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>  		goto out_ida_remove;
>  
> +	if (bioset_init(&d->bio_detached, 4,
> +			offsetof(struct detached_dev_io_private, bio),
> +			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> +		goto out_bioset_split_exit;
> +
>  	if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
>  		/*
>  		 * This should only happen with BCACHE_SB_VERSION_BDEV.
> @@ -964,7 +970,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	d->disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
>  	if (IS_ERR(d->disk))
> -		goto out_bioset_exit;
> +		goto out_bioset_detach_exit;
>  
>  	set_capacity(d->disk, sectors);
>  	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
> @@ -976,7 +982,9 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	d->disk->private_data	= d;
>  	return 0;
>  
> -out_bioset_exit:
> +out_bioset_detach_exit:
> +	bioset_exit(&d->bio_detached);
> +out_bioset_split_exit:
>  	bioset_exit(&d->bio_split);
>  out_ida_remove:
>  	ida_free(&bcache_device_idx, idx);
> -- 
> 2.34.1
