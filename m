Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D7F272E53
	for <linux-bcache@vger.kernel.org>; Wed,  2 Sep 2026 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788361949; cv=none; b=f2Is/+X4LqZQbYfmM/p76O4oZoeNVabfzXgV26b3rRPHcZ0V6Xlx2Q8BctMVIkx9AK9C3iqSTo3lp8bUwheQh3tde9A9kAwVjrWISyiBgfF132tAzyC0AA9ubDluryPJHyxpdW7pV3697eaUqNj3hGFV45vrnTcX7aMw7iff7wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788361949; c=relaxed/simple;
	bh=y2l5k4OLBtLYINM8HfcAfCWSpRHmV/B+rmJStpiCyRo=;
	h=Mime-Version:To:Message-Id:Content-Disposition:From:Subject:
	 Content-Type:In-Reply-To:Cc:Date:References; b=suE6zKseWytuBFMt5THTYpTZhJ6OHAe3zBAFN+ZS6hNaX+BYFJUYBloc5L9O8TLSiOPv21GMOaaDc5+M0B+CFoiFr1BlBtYScdrWN9oYBiwD8PziimgEVM71mH7CNH4Ytl6tWDPRSy/rDph6BUZtiJO5QVNd0wUyeRGpU/EuH24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=CpvNhn3I; arc=none smtp.client-ip=209.127.231.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="CpvNhn3I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788361931;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Wp1Chb2f/mLGYRHBndgrgvQotBcpEyotmtLygNUpcpE=;
 b=CpvNhn3I+5Mn4SuBVHCP6MZsTGkmUbvlkGRUdH6Cue4AOcBlgU3A705fjDj3u9icjzjMFy
 1SQTpdm+SCdWqt4H3/WIfe8aBTMv2Ext5Wor80MOfpKtV4dp6f5ftacSyUlYsKZKDHc+R/
 3aSqo/exfQb5OqKWqoGOGXGGs7xbHgQ9ijOGr42ja0jYHijORxyOs3pYBdiNsKzp3PA74Z
 zOzBo6qveB35q9pnZ8K2U59o1qlrqPknyB5kTuDngyMNLiKImk1x76Q9GKhrYGkAWUxhpx
 s8ZiQA689gLTUoRu+7/9SIsCWoGgU2+T9Zhkk5ac23rR3JXxsszkm19D4dPFtQ==
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fygo.io>
To: "Ankit Kapoor" <ankitkap@google.com>
Message-Id: <apgJusGeeXrEkt-f@studio.local>
Content-Disposition: inline
X-Lms-Return-Path: <lba+26a983cca+169fb9+vger.kernel.org+colyli@fygo.io>
From: "Coly Li" <colyli@fygo.io>
Subject: Re: [PATCH v3 1/2] bcache: track active bypass writes to fix read miss race
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260808040549.2778125-2-ankitkap@google.com>
Received: from studio.local ([120.245.64.136]) by smtp.larksuite.com with ESMTPS; Wed, 02 Sep 2026 15:12:09 +0000
Content-Transfer-Encoding: 7bit
Cc: <linux-bcache@vger.kernel.org>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	<linux-kernel@vger.kernel.org>
Date: Wed, 2 Sep 2026 23:12:07 +0800
References: <20260808040549.2778125-1-ankitkap@google.com> <20260808040549.2778125-2-ankitkap@google.com>

On Sat, Aug 08, 2026 at 04:05:48AM +0800, Ankit Kapoor wrote:
> A race condition exists between a read cache miss and a bypass write
> due to either congestion or sequential bypass, which causes stale data
> to be cached when the read cache miss runs concurrently with a bypass
> write targeting the same sectors. If the read cache miss fetches data
> from the backing device before the write to the backing device finishes,
> stale data populates the cache.
> 
> The root cause is that bcache currently executes btree key
> invalidation in parallel with (or prior to) writing the actual data
> payload to the backing device. Under this sequence, a concurrent read
> path can register a cache miss and insert a placeholder key. If the
> write's btree key invalidation completes before the read finishes
> fetching old data from the backing device, the read's subsequent key
> replacement will not detect a collision, allowing stale data to
> persist in the cache.
> 
> Fix this by tracking active bypass writes and serializing cache
> invalidation.
> 
> First, divide the backing device space into 32MB chunks and track
> concurrent bypass writes using refcounts. The tracking counters are
> stored in dynamically allocated pages backed by a dedicated mempool
> to prevent allocation failures under memory pressure, minimizing overall
> footprint (a single 4KB page supports 32GB of disk space using u32
> counters).
> 
> On a cache miss read, bcache checks if there are any active bypass
> writes overlapping the target sectors. If an active bypass write is
> detected, the read is forced to bypass the cache to ensure data
> consistency.
> 
> Second, serialize the btree key invalidation (bch_data_insert) for
> bypass writes so that it executes in cached_dev_write_complete(), after
> the payload has been written to the backing device. This prevents early
> invalidation from opening a window where a concurrent read miss could
> fetch and re-cache stale data before the bypass write reaches the disk.
> 
> Suggested-by: Coly Li <colyli@fygo.io>
> Signed-off-by: Ankit Kapoor <ankitkap@google.com>

Hi Ankit,

I have seen the patch 2/2 with the RCU usage. The implementation is not
ideal as I expected. Your code help me to realize maybe choosing RCU isn't
the best method. 

I try to compose a kind of lock-less refcount check method without RCU,
and it looks fine, but I don't test it yet. 

Here I replay the idea inline with your code.

> ---
>  drivers/md/bcache/bcache.h  |  35 ++++++++++
>  drivers/md/bcache/request.c | 131 +++++++++++++++++++++++++++++++++++-
>  drivers/md/bcache/super.c   |  39 +++++++++++
>  3 files changed, 202 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index ec9ff9715081..2e50526a52fc 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -299,6 +299,12 @@ enum stop_on_failure {
>  	BCH_CACHED_DEV_STOP_MODE_MAX,
>  };
>  
> +struct bch_bypass_page {
> +	u32		*counts;
> +	unsigned int	active;
> +	spinlock_t	lock;
> +};
> +
>  struct cached_dev {
>  	struct list_head	list;
>  	struct bcache_device	disk;
> @@ -407,8 +413,37 @@ struct cached_dev {
>  	 */
>  #define BCH_WBRATE_UPDATE_MAX_SKIPS	15
>  	unsigned int		rate_update_retry;
> +
> +	/* For tracking active bypass writes */
> +#define BCH_BYPASS_CHUNK_SHIFT		16  /* 2^16 sectors = 32MB */
> +#define BCH_BYPASS_PAGE_COUNTERS	(PAGE_SIZE / sizeof(u32))
> +#define BCH_BYPASS_PAGE_SHIFT		(PAGE_SHIFT - 2)
> +#define BCH_BYPASS_PAGE_MASK		((1UL << BCH_BYPASS_PAGE_SHIFT) - 1)
> +	struct bch_bypass_page	*bypass_pages;
> +	unsigned long		bypass_num_pages;
> +	mempool_t		bypass_mempool;
>  };
>  
> +static inline unsigned long sector_to_bypass_chunk(sector_t sector)
> +{
> +	return sector >> BCH_BYPASS_CHUNK_SHIFT;
> +}
> +
> +static inline unsigned long bypass_chunk_to_page(unsigned long chunk)
> +{
> +	return chunk >> BCH_BYPASS_PAGE_SHIFT;
> +}
> +
> +static inline unsigned long bypass_chunk_to_offset(unsigned long chunk)
> +{
> +	return chunk & BCH_BYPASS_PAGE_MASK;
> +}
> +
> +static inline sector_t bypass_chunk_to_sector(unsigned long chunk)
> +{
> +	return (sector_t)chunk << BCH_BYPASS_CHUNK_SHIFT;
> +}
> +

The above code is good.



>  enum alloc_reserve {
>  	RESERVE_BTREE,
>  	RESERVE_PRIO,
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 3fa3b13a410f..bfd28b68f499 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -492,6 +492,9 @@ struct search {
>  	struct block_device	*orig_bdev;
>  	unsigned long		start_time;
>  
> +	sector_t		bypass_sector;
> +	unsigned int		bypass_sectors;
> +
>  	struct btree_op		op;
>  	struct data_insert_op	iop;
>  };

Make sense.


> @@ -763,11 +766,16 @@ static inline struct search *search_alloc(struct bio *bio,
>  
>  /* Cached devices */
>  
> +static void bch_bypass_write_end(struct cached_dev *dc, sector_t sector, unsigned int sectors);
> +
>  static CLOSURE_CALLBACK(cached_dev_bio_complete)
>  {
>  	closure_type(s, struct search, cl);
>  	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
>  
> +	if (s->iop.bypass && op_is_write(bio_op(s->orig_bio)))
> +		bch_bypass_write_end(dc, s->bypass_sector, s->bypass_sectors);
> +

Looks good.


>  	cached_dev_put(dc);
>  	search_free(&cl->work);
>  }
> @@ -830,6 +838,110 @@ static CLOSURE_CALLBACK(cached_dev_cache_miss_done)
>  	closure_put(&d->cl);
>  }
>  
> +static void bch_bypass_write_start(struct cached_dev *dc, sector_t sector, unsigned int sectors)
> +{
> +	unsigned long start_chunk = sector_to_bypass_chunk(sector);
> +	unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
> +	unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
> +	unsigned long chunk;
> +
> +	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
> +		return;
> +
> +	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
> +		unsigned long pg_idx = bypass_chunk_to_page(chunk);
> +		unsigned long pg_off = bypass_chunk_to_offset(chunk);
> +		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
> +		u32 *new_counts;
> +		u32 *dup_counts = NULL;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&pg->lock, flags);
> +		if (!pg->counts) {
> +			spin_unlock_irqrestore(&pg->lock, flags);
> +			new_counts = mempool_alloc(&dc->bypass_mempool, GFP_NOIO);
> +			memset(new_counts, 0, PAGE_SIZE);
> +			spin_lock_irqsave(&pg->lock, flags);
> +			if (pg->counts)
> +				dup_counts = new_counts;
> +			else
> +				pg->counts = new_counts;
> +		}
> +		pg->counts[pg_off]++;
> +		pg->active++;
> +		spin_unlock_irqrestore(&pg->lock, flags);
> +
> +		if (dup_counts)
> +			mempool_free(dup_counts, &dc->bypass_mempool);
> +	}
> +}
> +
> +static void bch_bypass_write_end(struct cached_dev *dc, sector_t sector, unsigned int sectors)
> +{
> +	unsigned long start_chunk = sector_to_bypass_chunk(sector);
> +	unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
> +	unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
> +	unsigned long chunk;
> +
> +	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
> +		return;
> +
> +	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
> +		unsigned long pg_idx = bypass_chunk_to_page(chunk);
> +		unsigned long pg_off = bypass_chunk_to_offset(chunk);
> +		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
> +		u32 *counts = NULL;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&pg->lock, flags);
> +		if (WARN_ON_ONCE(!pg->counts || !pg->counts[pg_off])) {
> +			spin_unlock_irqrestore(&pg->lock, flags);
> +			continue;
> +		}
> +
> +		pg->counts[pg_off]--;
> +		pg->active--;
> +		if (!pg->active) {
> +			counts = pg->counts;
> +			pg->counts = NULL;
> +		}
> +		spin_unlock_irqrestore(&pg->lock, flags);
> +
> +		if (counts)
> +			mempool_free(counts, &dc->bypass_mempool);
> +	}
> +}
> +

I like the code to increase/decrease refcounts from small to large LBA.
I don't like spin_lock_irqsave()/spin_unlock_irqsave() here,
1. irqsave/restore might be unncessary, see my comments in following
   cached_dev_write_complete().
2, comparing to cmpxchg, using spin lock has an extra store operation,
   also also has more memory barrier operation on non-x86_64 archs.

I try to compose bch_bypass_write_start() and bch_bypass_write_end()
for your reference. I try to show what I thought based on your perfect
code base.


static void bch_bypass_page_put(struct cached_dev *dc,
                               struct bch_bypass_page *pg)
{
       unsigned long flags;

       if (refcount_dec_and_lock_irqsave(&pg->ref, &pg->lock,
					 &flags)) {
               atomic_t *counts = pg->counts;

               pg->counts = NULL;
               spin_unlock_irqrestore(&pg->lock, flags);
               mempool_free(counts, &dc->bypass_mempool);
       }
}

static void bch_bypass_write_start(struct cached_dev *dc,
				   sector_t sector,
				   unsigned int sectors)
{
       unsigned long start_chunk = sector_to_bypass_chunk(sector);
       unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
       unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
       unsigned long chunk;

       if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
               return;

       for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
               unsigned long pg_idx = bypass_chunk_to_page(chunk);
               unsigned long pg_off = bypass_chunk_to_offset(chunk);
               struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
               atomic_t *counts;
               unsigned long flags;

retry:
               counts = READ_ONCE(pg->counts);
               if (!counts) {
                       atomic_t *new_counts;

                       new_counts = mempool_alloc(&dc->bypass_mempool,
                                                  GFP_NOIO);
                       memset(new_counts, 0, PAGE_SIZE);

                       spin_lock_irqsave(&pg->lock, flags);
                       if (pg->counts) {
                               refcount_inc(&pg->ref);
                               counts = pg->counts;
                               spin_unlock_irqrestore(&pg->lock, flags);
                               mempool_free(new_counts,
					    &dc->bypass_mempool);
                       } else {
                               pg->counts = new_counts;
                               refcount_set(&pg->ref, 1);
                               counts = new_counts;
                               spin_unlock_irqrestore(&pg->lock, flags);
                       }
               } else {
                       if (!refcount_inc_not_zero(&pg->ref))
                               goto retry;

                       if (unlikely(READ_ONCE(pg->counts) != counts)) {
                               bch_bypass_page_put(dc, pg);
                               goto retry;
                       }
               }

               atomic_inc(&counts[pg_off]);
       }
}

static void bch_bypass_write_end(struct cached_dev *dc,
				 sector_t sector,
				 unsigned int sectors)
{
       unsigned long start_chunk = sector_to_bypass_chunk(sector);
       unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
       unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
       unsigned long chunk;

       if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
               return;

       for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
               unsigned long pg_idx = bypass_chunk_to_page(chunk);
               unsigned long pg_off = bypass_chunk_to_offset(chunk);
               struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
               atomic_t *counts;

               counts = READ_ONCE(pg->counts);

               if (!WARN_ON_ONCE(!counts || !atomic_read(&counts[pg_off])))
                       atomic_dec(&counts[pg_off]);

               bch_bypass_page_put(dc, pg);
       }
}

In the above code, pg->ref is used to make sure during accessing the refcount at
counts[pg_off], the counters page are refrenced and won't be freed. It is similar
to pg->active in your patch.


> +static bool bch_has_active_bypass_writes(struct cached_dev *dc, sector_t sector,
> +					 unsigned int sectors)
> +{
> +	unsigned long start_chunk = sector_to_bypass_chunk(sector);
> +	unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
> +	unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
> +	unsigned long chunk;
> +	bool has_active = false;
> +
> +	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
> +		return false;
> +
> +	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
> +		unsigned long pg_idx = bypass_chunk_to_page(chunk);
> +		unsigned long pg_off = bypass_chunk_to_offset(chunk);
> +		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&pg->lock, flags);
> +		if (pg->counts && pg->counts[pg_off] > 0) {
> +			has_active = true;
> +			spin_unlock_irqrestore(&pg->lock, flags);
> +			break;
> +		}
> +		spin_unlock_irqrestore(&pg->lock, flags);
> +	}
> +
> +	return has_active;
> +}
> +

From the above code, firstly spin_lock_irqsave() is unnecessary. And I try
my best to avoid to use spin_lock/unlock routines. Although indeed the
location to call bch_has_active_bypass_writes() is not very hot, make it
less cost is always better.

static bool bch_has_active_bypass_writes(struct cached_dev *dc,
					 sector_t sector,
					 unsigned int sectors)
{
       unsigned long start_chunk = sector_to_bypass_chunk(sector);
       unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
       unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
       unsigned long chunk;
       bool has_active = false;

       if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
               return false;

       for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
               unsigned long pg_idx = bypass_chunk_to_page(chunk);
               unsigned long pg_off = bypass_chunk_to_offset(chunk);
               struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
               atomic_t *counts;
               int val = 0;

retry:
               counts = READ_ONCE(pg->counts);
               if (!counts)
                       continue;

               if (!refcount_inc_not_zero(&pg->ref))
                       goto retry;

               if (unlikely(READ_ONCE(pg->counts) != counts)) {
                       bch_bypass_page_put(dc, pg);
                       goto retry;
               }

               val = atomic_read(&counts[pg_off]);
               bch_bypass_page_put(dc, pg);

               if (val > 0) {
                       has_active = true;
                       break;
               }
       }

       return has_active;
}


>  static CLOSURE_CALLBACK(cached_dev_read_done)
>  {
>  	closure_type(s, struct search, cl);
> @@ -864,7 +976,9 @@ static CLOSURE_CALLBACK(cached_dev_read_done)
>  	bio_complete(s);
>  
>  	if (s->iop.bio &&
> -	    !test_bit(CACHE_SET_STOPPING, &s->iop.c->flags)) {
> +	    !test_bit(CACHE_SET_STOPPING, &s->iop.c->flags) &&
> +	    !bch_has_active_bypass_writes(dc, s->iop.bio->bi_iter.bi_sector,
> +					  bio_sectors(s->iop.bio))) {
>  		BUG_ON(!s->iop.replace);
>  		closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
>  	}

Yes, this is key change. If there is bypass write flying after
the check key inserted, don't insert the replacement key back into btree.



> @@ -975,7 +1089,13 @@ static CLOSURE_CALLBACK(cached_dev_write_complete)
>  	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
>  
>  	up_read_non_owner(&dc->writeback_lock);
> -	cached_dev_bio_complete(&cl->work);
> +
> +	if (s->iop.bypass) {
> +		closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
> +		continue_at(cl, cached_dev_bio_complete, NULL);

The ordering this correct, but the usage of continue_at() here is wrong.
cached_dev_write_complete() might be called in irq context, call continue_at
without a workqueue will run cached_dev_bio_complete() directly in irq context.
There are potential blocking operations inside cached_dev_bio_complete(),
so this is not wanted.

You should use a workqueue, e.g. s->iop.wq, or directly bcache_wq,
	continue_at(cl, cached_dev_bio_complete, s->iop.wq);


> +	} else {
> +		cached_dev_bio_complete(&cl->work);
> +	}
>  }
>  
>  static void cached_dev_write(struct cached_dev *dc, struct search *s)
> @@ -1018,6 +1138,10 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>  		s->iop.bio = s->orig_bio;
>  		bio_get(s->iop.bio);
>  
> +		s->bypass_sector = bio->bi_iter.bi_sector;
> +		s->bypass_sectors = bio_sectors(bio);
> +		bch_bypass_write_start(dc, s->bypass_sector, s->bypass_sectors);
> +
>  		if (bio_op(bio) == REQ_OP_DISCARD &&
>  		    !bdev_max_discard_sectors(dc->bdev))
>  			goto insert_data;
> @@ -1058,7 +1182,8 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>  	}
>  
>  insert_data:
> -	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
> +	if (!s->iop.bypass)
> +		closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
>  	continue_at(cl, cached_dev_write_complete, NULL);
>  }
> 

The above changes look good to me.


 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 97d9adb0bf96..b994483511de 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1346,6 +1346,16 @@ void bch_cached_dev_release(struct kobject *kobj)
>  {
>  	struct cached_dev *dc = container_of(kobj, struct cached_dev,
>  					     disk.kobj);
> +	if (dc->bypass_pages) {
> +		unsigned long i;
> +
> +		for (i = 0; i < dc->bypass_num_pages; i++) {
> +			if (dc->bypass_pages[i].counts)
> +				mempool_free(dc->bypass_pages[i].counts, &dc->bypass_mempool);
> +		}
> +		kvfree(dc->bypass_pages);
> +		mempool_exit(&dc->bypass_mempool);
> +	}
>  	kfree(dc);
>  	module_put(THIS_MODULE);
>  }

free bypass_pages should not be executed here. See my last comments in this
email after cached_dev_init().


> @@ -1407,6 +1417,31 @@ static CLOSURE_CALLBACK(cached_dev_flush)
>  	continue_at(cl, cached_dev_free, system_percpu_wq);
>  }
>  
> +static int bch_cached_dev_bypass_init(struct cached_dev *dc, sector_t sectors)
> +{
> +	unsigned long chunks =
> +		sector_to_bypass_chunk(sectors + (1UL << BCH_BYPASS_CHUNK_SHIFT) - 1);
> +	unsigned long i;
> +
> +	dc->bypass_num_pages = DIV_ROUND_UP(chunks, BCH_BYPASS_PAGE_COUNTERS);
> +	dc->bypass_pages = kvcalloc(dc->bypass_num_pages,
> +				   sizeof(struct bch_bypass_page),
> +				   GFP_KERNEL);
> +	if (!dc->bypass_pages)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < dc->bypass_num_pages; i++)
> +		spin_lock_init(&dc->bypass_pages[i].lock);
> +
> +	if (mempool_init_kmalloc_pool(&dc->bypass_mempool, 16, PAGE_SIZE)) {
> +		kvfree(dc->bypass_pages);
> +		dc->bypass_pages = NULL;
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}

In general the above code is fine, but I suggest to change the order of
some lines, and the result code looks in the following shape.

static int bch_cached_dev_bypass_init(struct cached_dev *dc, sector_t sectors)
{
       unsigned long chunks;
       unsigned long i;

       if (dc->bypass_pages)
               return 0;

       chunks = DIV_ROUND_UP(sectors, 1UL << BCH_BYPASS_CHUNK_SHIFT);
       dc->bypass_num_pages = DIV_ROUND_UP(chunks, BCH_BYPASS_PAGE_COUNTERS);
       dc->bypass_pages = kvcalloc(dc->bypass_num_pages,
                                   sizeof(struct bch_bypass_page),
                                   GFP_KERNEL);
       if (!dc->bypass_pages)
               return -ENOMEM;

       for (i = 0; i < dc->bypass_num_pages; i++)
               spin_lock_init(&dc->bypass_pages[i].lock);

       if (mempool_init_kmalloc_pool(&dc->bypass_mempool, 16, PAGE_SIZE)) {
               kvfree(dc->bypass_pages);
               dc->bypass_pages = NULL;
               return -ENOMEM;
       }

       return 0;
}

> +
>  static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  {
>  	int ret;
> @@ -1447,6 +1482,10 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  	/* default to auto */
>  	dc->stop_when_cache_set_failed = BCH_CACHED_DEV_STOP_AUTO;
>  
> +	ret = bch_cached_dev_bypass_init(dc, bdev_nr_sectors(dc->bdev));
> +	if (ret)
> +		return ret;
> +
>  	bch_cached_dev_request_init(dc);
>  	bch_cached_dev_writeback_init(dc);
>  	return 0;

The init and exit code should be called in bcache device attach/detach time.
Allocating the mempool of slab cache for bcache device not attached to a cache
set is a waste of memory.

Maybe the code can be look in the following shape.

1, Add a helper to free counter pages and the bypass_mempool.

static void bch_cached_dev_bypass_exit(struct cached_dev *dc)
{
       unsigned long i;

       if (!dc->bypass_pages)
               return;

       for (i = 0; i < dc->bypass_num_pages; i++) {
               if (dc->bypass_pages[i].counts)
                       mempool_free(dc->bypass_pages[i].counts,
                                    &dc->bypass_mempool);
       }
       kvfree(dc->bypass_pages);
       dc->bypass_pages = NULL;
       dc->bypass_num_pages = 0;
       mempool_exit(&dc->bypass_mempool);
}


2, Call bch_cached_dev_bypass_exit() when detach or stop the bcache
   device. If the bcache device is stopping, bch_cached_dev_bypass_exit()
   might be called twice, therefore if (!dc->bypass_pages) is neccessary.

 static void cached_dev_detach_finish(struct work_struct *w)
 {
        struct cached_dev *dc = container_of(w, struct cached_dev, detach);
        struct cache_set *c = dc->disk.c;

        BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
        BUG_ON(refcount_read(&dc->count));

+       bch_cached_dev_bypass_exit(dc);

        if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
                cancel_writeback_rate_update_dwork(dc);

        if (!IS_ERR_OR_NULL(dc->writeback_thread)) {



int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 /* when dc->disk.kobj released */
 void bch_cached_dev_release(struct kobject *kobj)
 {
        struct cached_dev *dc = container_of(kobj, struct cached_dev,
                                             disk.kobj);

+       bch_cached_dev_bypass_exit(dc);
        kfree(dc);
        module_put(THIS_MODULE);
 }


3, Initialize the mempool at attachtime, not in cached_dev_init(),
int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
        } else {
                u->last_reg = rtime;
                bch_uuid_write(c);
        }

+       ret = bch_cached_dev_bypass_init(dc, bdev_nr_sectors(dc->bdev));
+       if (ret)
+               return ret;
+
        bcache_device_attach(&dc->disk, c, u - c->uuids);
        list_move(&dc->list, &c->cached_devs);
        calc_cached_dev_sectors(c);

        /*


By all the above changes, the second patch with RCU can be dropped, and
only this patch should work for the fix.

But the stale clean data race between bypass write and cache miss read
is still not 100% solved. The last issue is,
1, If the data of bypass write hits hard driver platter firstly.
2, There is an overlapped clean key in btree, and not invlidated yet.
3, Power failure happens.
Then the stale clean key is still in btree and new data is on hard drive.

To fix the above very very rare condition need to update the bcache
super block to mark an unclear stop. Then after boot up if this mark
detected then all clean keys will be invalidated. This fix will change
on-disk format, I will compose a patch latter.

Current patch will solve most of the situation of the addressed stale
clean key race. Because no on-disk format change, it should be much
easier to do backport for down stream kernel maintainers.

I feel for the fix it self, after you update all the suggested stuffs
in my comments, it should be good. If you want to add another patch for
the sysfs interface files, please post them in next version.

NOTE: all code in my comments are just to show my thought, they don't
pass compiling, and not test at all. You need to make them work.

Thanks.

Coly Li
