Received: from lf-2-48.ptr.blmpb.com (lf-2-48.ptr.blmpb.com [101.36.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C85330328
	for <linux-bcache@vger.kernel.org>; Wed,  8 Jul 2026 03:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783483055; cv=none; b=X9EbqdxiHv2Z0z2jmAbH82HlLfmboPecYqzUyyxzB+9kWIT6IMS0FLtS4o39QbA/2cYMYZq7rP1QC5JmTy9p3RXy5CXNzT9H2hkeY4lWkC+490whlpGW0CTBT5l1BLczqpry6iSjBcBFZwvDHUXGZde1V1tHrk0Sarkk7iOIcog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783483055; c=relaxed/simple;
	bh=Qii0laOW3Vty9U7dYxw+XxFlyyiJHpXhCqGxBFYgJhg=;
	h=In-Reply-To:Cc:References:Message-Id:Content-Disposition:
	 Content-Type:Subject:Date:To:Mime-Version:From; b=OPKr2XFD+pRRXOcKaWa9VieaRAi0tZaFoCI+zMlQ4njc144/BIVo/0T2HqZ9/+AlFvVNlt7md0lbDzQHdoWuAZO9P0lx4PdvVQQPx05XTjeM1apFZRy5JgJYV3ySEQnHRIAiIqlr53PSPiyoUTy0d93GpVzAU5pAi079mhgIbTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=WEWAlmRI; arc=none smtp.client-ip=101.36.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="WEWAlmRI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783483006;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aqmm9vSfuqi0J4SbsNWQ8Qc0x9JH0MhJiXP+H/Nhdws=;
 b=WEWAlmRIT2B9B5uLiP/JzIg5/DLvjJMsScuXySGMq/EfWREJaBG3wdM0nQHF6P37t+5qx1
 VcfDCqqpFNono8Nb5Vv5TXB22QG4CV/3zTkjSJmY4eyTBHTkEekzKC+7GZAacFUUuFKZKJ
 30/KuRVF2xrsUDglAUQExybTLY3eGKDRqzqCuKtbNTgkIFJCu9R/4Opa1zBs9yuA8UTjJS
 rgQJ5EALnX02G/9FWkFmG8I7l3VQ9jx8SOYVJ988xjk9QXcPj0lIUaLDMUS3L8wh2ASfF1
 RpOR4kDKWa31O8qLEo45cNli0K616I8ZcRRexNjLz+cVBDWUhJWxLVkChBoOhg==
In-Reply-To: <20260527082750.726707-1-zhoujifeng@kylinsec.com.cn>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Coly Li <colyli@fygo.io>
X-Lms-Return-Path: <lba+26a4dca7e+2465b6+vger.kernel.org+colyli@fygo.io>
Cc: <linux-bcache@vger.kernel.org>
References: <20260527082750.726707-1-zhoujifeng@kylinsec.com.cn>
Message-Id: <ak3Jf2ZUhQmDmA3A@studio.local>
Content-Disposition: inline
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH RFC v3] bcache: flush backing device before cleaning the writeback dirty keys
Date: Wed, 8 Jul 2026 11:56:42 +0800
To: "Zhou Jifeng" <zhoujifeng@kylinsec.com.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Coly Li" <colyli@fygo.io>
Received: from studio.local ([120.245.64.95]) by smtp.larksuite.com with ESMTPS; Wed, 08 Jul 2026 03:56:45 +0000

On Wed, May 27, 2026 at 01:27:50AM +0800, Zhou Jifeng wrote:
> Coly Li proposed an RFC that collects written-back keys into an on-stack
> per-pass batch (struct writeback_batch) inside read_dirty() and issues
> one REQ_PREFLUSH per pass (~500 IOs, bounded by KEYBUF_NR).  This patch
> builds directly on that design: the core data structures, function names
> (writeback_flush(), writeback_finish_batch()), and naming convention all
> follow Coly's RFC.
>=20
> The extension is a persistent preallocated batch (dc->writeback_batch)
> that survives across read_dirty() passes, controlled by a new sysfs knob
> writeback_flush_interval:
>=20
>   writeback_flush_interval =3D 0  (default):
>     writeback_finish_batch() is triggered after every read_dirty() pass
>     (because !0 is always true), reproducing Coly's one-flush-per-pass
>     behavior exactly.  In this mode keys never accumulate between passes,
>     so bch_writeback_finish_batch() (the GC hook) skips each device =E2=
=80=94
>     there is nothing pending to flush.
>=20
>   writeback_flush_interval > 0  (cross-pass batching):
>     writeback_finish_batch() fires only when the accumulated key count
>     reaches the threshold.  The GC hook flushes pending keys before
>     btree_gc_start() so GC can reclaim their bucket space.
>=20
> Signed-off-by: Coly Li <colyli@fygo.io>
> Signed-off-by: Zhou Jifeng <zhoujifeng@kylinsec.com.cn>

Hi Jifeng,

I tried to review your change, but failed. Your patch mixed the add/delete
lines together, it is not easy to assemble the code context in my brain.
Further more, I am not able to place my review comments in proper location.

Can you re-generate the patch again? Keep the existed functions in their
original locations, and add your new code together.

I tried, after the re-format, the change is clean and much easier to
review. If you can regenerate the patch in this more clear why, that will
be very helpful.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/bcache.h    |  20 +++++
>  drivers/md/bcache/btree.c     |   2 +
>  drivers/md/bcache/btree.h     |   1 +
>  drivers/md/bcache/sysfs.c     |   6 ++
>  drivers/md/bcache/writeback.c | 137 ++++++++++++++++++++++++++++------
>  drivers/md/bcache/writeback.h |   1 +
>  6 files changed, 145 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index ec9ff9715..03e401575 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -247,6 +247,24 @@ struct keybuf {
>  	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
>  };
> =20
> +struct writeback_bkey {
> +	BKEY_PADDED(key);
> +	struct list_head	list;
> +};
> +
> +#define WRITEBACK_FLUSH_INTERVAL_DEFAULT	0
> +#define WRITEBACK_FLUSH_INTERVAL_MIN		0
> +#define WRITEBACK_FLUSH_INTERVAL_MAX		50000
> +
> +struct writeback_batch {
> +	spinlock_t		lock;
> +	u32			count;
> +	struct list_head	keys;
> +
> +	DECLARE_ARRAY_ALLOCATOR(struct writeback_bkey, pool,
> +				WRITEBACK_FLUSH_INTERVAL_MAX);
> +};
> +
>  struct bcache_device {
>  	struct closure		cl;
> =20
> @@ -347,6 +365,8 @@ struct cached_dev {
>  	struct workqueue_struct	*writeback_write_wq;
> =20
>  	struct keybuf		writeback_keys;
> +	struct writeback_batch	writeback_batch;
> +	unsigned int		writeback_flush_interval;
> =20
>  	struct task_struct	*status_update_thread;
>  	/*
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 27a129d47..d10c03f60 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -25,6 +25,7 @@
>  #include "btree.h"
>  #include "debug.h"
>  #include "extents.h"
> +#include "writeback.h"
> =20
>  #include <linux/slab.h>
>  #include <linux/bitops.h>
> @@ -1837,6 +1838,7 @@ static void bch_btree_gc(struct cache_set *c)
>  	closure_init_stack(&writes);
>  	bch_btree_op_init(&op, SHRT_MAX);
> =20
> +	bch_writeback_finish_batch(c);
>  	btree_gc_start(c);
> =20
>  	/* if CACHE_SET_IO_DISABLE set, gc thread should stop too */
> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> index 45d64b541..701b0009c 100644
> --- a/drivers/md/bcache/btree.h
> +++ b/drivers/md/bcache/btree.h
> @@ -414,4 +414,5 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cach=
e_set *c,
>  					  struct bkey *end,
>  					  keybuf_pred_fn *pred);
>  void bch_update_bucket_in_use(struct cache_set *c, struct gc_stat *stats=
);
> +void bkey_put(struct cache_set *c, struct bkey *k);
>  #endif
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index cfac56caa..7a87c64d7 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -150,6 +150,7 @@ rw_attribute(copy_gc_enabled);
>  rw_attribute(idle_max_writeback_rate);
>  rw_attribute(gc_after_writeback);
>  rw_attribute(size);
> +rw_attribute(writeback_flush_interval);
> =20
>  static ssize_t bch_snprint_string_list(char *buf,
>  				       size_t size,
> @@ -212,6 +213,7 @@ SHOW(__bch_cached_dev)
>  	var_print(writeback_rate_fp_term_mid);
>  	var_print(writeback_rate_fp_term_high);
>  	var_print(writeback_rate_minimum);
> +	var_print(writeback_flush_interval);
> =20
>  	if (attr =3D=3D &sysfs_writeback_rate_debug) {
>  		char rate[20];
> @@ -353,6 +355,9 @@ STORE(__cached_dev)
> =20
>  	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
> =20
> +	sysfs_strtoul_clamp(writeback_flush_interval, dc->writeback_flush_inter=
val,
> +			    WRITEBACK_FLUSH_INTERVAL_MIN, WRITEBACK_FLUSH_INTERVAL_MAX);
> +
>  	if (attr =3D=3D &sysfs_io_disable) {
>  		int v =3D strtoul_or_return(buf);
> =20
> @@ -540,6 +545,7 @@ static struct attribute *bch_cached_dev_attrs[] =3D {
>  #endif
>  	&sysfs_backing_dev_name,
>  	&sysfs_backing_dev_uuid,
> +	&sysfs_writeback_flush_interval,
>  	NULL
>  };
>  ATTRIBUTE_GROUPS(bch_cached_dev);
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.=
c
> index 4b237074f..f36b515d6 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -348,39 +348,122 @@ static CLOSURE_CALLBACK(dirty_io_destructor)
>  	kfree(io);
>  }
> =20
> -static CLOSURE_CALLBACK(write_dirty_finish)
> +static void writeback_batch_init(struct writeback_batch *wb)
>  {
> -	closure_type(io, struct dirty_io, cl);
> -	struct keybuf_key *w =3D io->bio.bi_private;
> -	struct cached_dev *dc =3D io->dc;
> +	wb->count =3D 0;
> +	spin_lock_init(&wb->lock);
> +	array_allocator_init(&wb->pool);
> +	INIT_LIST_HEAD(&wb->keys);
> +}
> =20
> -	bio_free_pages(&io->bio);
> +static void writeback_add_key(struct cached_dev *dc, struct bkey *key)
> +{
> +	struct writeback_bkey *bk;
> +	unsigned int i;
> =20
> -	/* This is kind of a dumb way of signalling errors. */
> -	if (KEY_DIRTY(&w->key)) {
> -		int ret;
> -		unsigned int i;
> -		struct keylist keys;
> +	spin_lock(&dc->writeback_batch.lock);
> +	bk =3D array_alloc(&dc->writeback_batch.pool);
> +	if (!bk) {
> +		spin_unlock(&dc->writeback_batch.lock);
> +		return;
> +	}
> +
> +	for (i =3D 0; i < KEY_PTRS(key); i++)
> +		atomic_inc(&PTR_BUCKET(dc->disk.c, key, i)->pin);
> =20
> -		bch_keylist_init(&keys);
> +	bkey_copy(&bk->key, key);
> +	INIT_LIST_HEAD(&bk->list);
> +	list_add_tail(&bk->list, &dc->writeback_batch.keys);
> +	dc->writeback_batch.count++;
> +	spin_unlock(&dc->writeback_batch.lock);
> +}
> =20
> -		bkey_copy(keys.top, &w->key);
> -		SET_KEY_DIRTY(keys.top, false);
> -		bch_keylist_push(&keys);
> +static int writeback_flush(struct cached_dev *dc)
> +{
> +	struct bio bio;
> +	int ret;
> =20
> -		for (i =3D 0; i < KEY_PTRS(&w->key); i++)
> -			atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
> +	bio_init(&bio, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
> =20
> -		ret =3D bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
> +	ret =3D submit_bio_wait(&bio);
> +	if (ret)
> +		bch_count_backing_io_errors(dc, &bio);
> =20
> -		if (ret)
> -			trace_bcache_writeback_collision(&w->key);
> +	bio_uninit(&bio);
> +	return ret;
> +}
> =20
> -		atomic_long_inc(ret
> -				? &dc->disk.c->writeback_keys_failed
> -				: &dc->disk.c->writeback_keys_done);
> +static void writeback_finish_batch(struct cached_dev *dc)
> +{
> +	struct writeback_bkey *bk, *tmp;
> +	struct keylist keys;
> +	LIST_HEAD(local);
> +	int flush_ret, ret;
> +
> +	spin_lock(&dc->writeback_batch.lock);
> +	if (list_empty(&dc->writeback_batch.keys)) {
> +		spin_unlock(&dc->writeback_batch.lock);
> +		return;
> +	}
> +	list_splice_init(&dc->writeback_batch.keys, &local);
> +	dc->writeback_batch.count =3D 0;
> +	spin_unlock(&dc->writeback_batch.lock);
> +
> +	flush_ret =3D writeback_flush(dc);
> +
> +	list_for_each_entry(bk, &local, list) {
> +		if (flush_ret =3D=3D 0) {
> +			bch_keylist_init(&keys);
> +			bkey_copy(keys.top, &bk->key);
> +			SET_KEY_DIRTY(keys.top, false);
> +			bch_keylist_push(&keys);
> +			ret =3D bch_btree_insert(dc->disk.c, &keys, NULL,
> +					       &bk->key);
> +			if (ret)
> +				trace_bcache_writeback_collision(&bk->key);
> +			atomic_long_inc(ret
> +					? &dc->disk.c->writeback_keys_failed
> +					: &dc->disk.c->writeback_keys_done);
> +		} else {
> +			bkey_put(dc->disk.c, &bk->key);
> +		}
>  	}
> =20
> +	spin_lock(&dc->writeback_batch.lock);
> +	list_for_each_entry_safe(bk, tmp, &local, list) {
> +		list_del(&bk->list);
> +		array_free(&dc->writeback_batch.pool, bk);
> +	}
> +	spin_unlock(&dc->writeback_batch.lock);
> +}
> +
> +void bch_writeback_finish_batch(struct cache_set *c)
> +{
> +	unsigned int i;
> +
> +	for (i =3D 0; i < c->devices_max_used; i++) {
> +		struct bcache_device *d =3D c->devices[i];
> +		struct cached_dev *dc;
> +
> +		if (!d || UUID_FLASH_ONLY(&c->uuids[i]))
> +			continue;
> +		dc =3D container_of(d, struct cached_dev, disk);
> +		if (dc->writeback_flush_interval)
> +			writeback_finish_batch(dc);
> +	}
> +}
> +
> +static CLOSURE_CALLBACK(write_dirty_finish)
> +{
> +	closure_type(io, struct dirty_io, cl);
> +	struct keybuf_key *w =3D io->bio.bi_private;
> +	struct cached_dev *dc =3D io->dc;
> +
> +	bio_free_pages(&io->bio);
> +
> +	if (KEY_DIRTY(&w->key))
> +		writeback_add_key(dc, &w->key);
> +
>  	bch_keybuf_del(&dc->writeback_keys, w);
>  	up(&dc->in_flight);
> =20
> @@ -818,9 +901,15 @@ static int bch_writeback_thread(void *arg)
> =20
>  		read_dirty(dc);
> =20
> +		if (!dc->writeback_flush_interval ||
> +		    dc->writeback_batch.count >=3D dc->writeback_flush_interval)
> +			writeback_finish_batch(dc);
> +
>  		if (searched_full_index) {
>  			unsigned int delay =3D dc->writeback_delay * HZ;
> =20
> +			writeback_finish_batch(dc);
> +
>  			while (delay &&
>  			       !kthread_should_stop() &&
>  			       !test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
> @@ -831,6 +920,8 @@ static int bch_writeback_thread(void *arg)
>  		}
>  	}
> =20
> +	writeback_finish_batch(dc);
> +
>  	if (dc->writeback_write_wq)
>  		destroy_workqueue(dc->writeback_write_wq);
> =20
> @@ -1049,6 +1140,7 @@ void bch_cached_dev_writeback_init(struct cached_de=
v *dc)
>  	sema_init(&dc->in_flight, 64);
>  	init_rwsem(&dc->writeback_lock);
>  	bch_keybuf_init(&dc->writeback_keys);
> +	writeback_batch_init(&dc->writeback_batch);
> =20
>  	dc->writeback_metadata		=3D true;
>  	dc->writeback_running		=3D false;
> @@ -1064,6 +1156,7 @@ void bch_cached_dev_writeback_init(struct cached_de=
v *dc)
>  	dc->writeback_rate_fp_term_mid =3D 10;
>  	dc->writeback_rate_fp_term_high =3D 1000;
>  	dc->writeback_rate_i_term_inverse =3D 10000;
> +	dc->writeback_flush_interval	=3D WRITEBACK_FLUSH_INTERVAL_DEFAULT;
> =20
>  	/* For dc->writeback_lock contention in update_writeback_rate() */
>  	dc->rate_update_retry =3D 0;
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.=
h
> index 31df71695..12b4c4420 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -151,5 +151,6 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c=
, unsigned int inode,
>  void bch_sectors_dirty_init(struct bcache_device *d);
>  void bch_cached_dev_writeback_init(struct cached_dev *dc);
>  int bch_cached_dev_writeback_start(struct cached_dev *dc);
> +void bch_writeback_finish_batch(struct cache_set *c);
> =20
>  #endif
> --=20
> 2.34.1
>
