From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: add a separate open bucket list for flash devices
Date: Tue, 21 Nov 2017 05:57:52 -0500
Message-ID: <20171121105752.yy7krolo4dx75bte@moria.home.lan>
References: <1511261432-8578-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511261432-8578-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: colyli@suse.de, mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Nov 21, 2017 at 06:50:32PM +0800, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Currently in pick_data_bucket(), though we keep multiple buckets open
> for writes, and try to segregate different write streams for better
> cache utilization: first we look for a bucket where the last write to
> it was sequential with the current write, and failing that we look
> for a bucket that was last usedby the same task.
> 
> But actually, in such scenario that there are some flash devices
> , and some backend bcache devices, when many tasks request these
> flash devices and backend bcache devices, the write IOs may still
> fall to the same bucket as bellow bucket:
> | bcache data | flash data | bcache data | bcache data| flash data|
> then after writeback of these backend bcache devices, the bucket would
> be like bellow bucket:
> | free | flash data | free | free | flash data |

This patch doesn't make any sense - open_buckets are only for allocations and
writes to the SSD.

> 
> So, there are many free space in this bucket, but since flash data
> still exists, so this bucket cannot reused, which would cause waste of
> bucket space.
> 
> In this patch, we add a separate open bucket list for flash devices,
> and write all flash data to these buckets, so data from flash devices
> and backend bcache devices can store in different buckets.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/alloc.c  | 40 +++++++++++++++++++++++++++++++---------
>  drivers/md/bcache/bcache.h |  1 +
>  drivers/md/bcache/super.c  |  1 +
>  3 files changed, 33 insertions(+), 9 deletions(-)
>  mode change 100644 => 100755 drivers/md/bcache/alloc.c
>  mode change 100644 => 100755 drivers/md/bcache/bcache.h
>  mode change 100644 => 100755 drivers/md/bcache/super.c
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> old mode 100644
> new mode 100755
> index 0803563..add00a3
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -69,7 +69,8 @@
>  #include <linux/random.h>
>  #include <trace/events/bcache.h>
>  
> -#define MAX_OPEN_BUCKETS 128
> +#define MAX_OPEN_DATA_BUCKETS 	96
> +#define MAX_OPEN_FLASH_BUCKETS 	32
>  
>  /* Bucket heap / gen */
>  
> @@ -532,19 +533,19 @@ struct open_bucket {
>   * should be a sane heuristic.
>   */
>  static struct open_bucket *pick_data_bucket(struct cache_set *c,
> +					    struct list_head *open_buckets,
>  					    const struct bkey *search,
>  					    unsigned write_point,
>  					    struct bkey *alloc)
>  {
>  	struct open_bucket *ret, *ret_task = NULL;
>  
> -	list_for_each_entry_reverse(ret, &c->data_buckets, list)
> +	list_for_each_entry_reverse(ret, open_buckets, list)
>  		if (!bkey_cmp(&ret->key, search))
>  			goto found;
>  		else if (ret->last_write_point == write_point)
>  			ret_task = ret;
> -
> -	ret = ret_task ?: list_first_entry(&c->data_buckets,
> +	ret = ret_task ?: list_first_entry(open_buckets,
>  					   struct open_bucket, list);
>  found:
>  	if (!ret->sectors_free && KEY_PTRS(alloc)) {
> @@ -575,7 +576,7 @@ bool bch_alloc_sectors(struct cache_set *c, struct bkey *k, unsigned sectors,
>  	struct open_bucket *b;
>  	BKEY_PADDED(key) alloc;
>  	unsigned i;
> -
> +	struct list_head *open_buckets;
>  	/*
>  	 * We might have to allocate a new bucket, which we can't do with a
>  	 * spinlock held. So if we have to allocate, we drop the lock, allocate
> @@ -586,7 +587,9 @@ bool bch_alloc_sectors(struct cache_set *c, struct bkey *k, unsigned sectors,
>  	bkey_init(&alloc.key);
>  	spin_lock(&c->data_bucket_lock);
>  
> -	while (!(b = pick_data_bucket(c, k, write_point, &alloc.key))) {
> +	open_buckets = UUID_FLASH_ONLY(&c->uuids[KEY_INODE(k)]) ? &c->flash_buckets : &c->data_buckets;
> +
> +	while (!(b = pick_data_bucket(c, open_buckets, k, write_point, &alloc.key))) {
>  		unsigned watermark = write_prio
>  			? RESERVE_MOVINGGC
>  			: RESERVE_NONE;
> @@ -625,7 +628,8 @@ bool bch_alloc_sectors(struct cache_set *c, struct bkey *k, unsigned sectors,
>  	 * Move b to the end of the lru, and keep track of what this bucket was
>  	 * last used for:
>  	 */
> -	list_move_tail(&b->list, &c->data_buckets);
> +	list_move_tail(&b->list, open_buckets);
> +
>  	bkey_copy_key(&b->key, k);
>  	b->last_write_point = write_point;
>  
> @@ -666,22 +670,40 @@ void bch_open_buckets_free(struct cache_set *c)
>  		list_del(&b->list);
>  		kfree(b);
>  	}
> +
> +	while (!list_empty(&c->flash_buckets)) {
> +		b = list_first_entry(&c->flash_buckets,
> +				     struct open_bucket, list);
> +		list_del(&b->list);
> +		kfree(b);
> +	}
> +
>  }
>  
>  int bch_open_buckets_alloc(struct cache_set *c)
>  {
>  	int i;
> +	struct open_bucket *b;
>  
>  	spin_lock_init(&c->data_bucket_lock);
>  
> -	for (i = 0; i < MAX_OPEN_BUCKETS; i++) {
> -		struct open_bucket *b = kzalloc(sizeof(*b), GFP_KERNEL);
> +	for (i = 0; i < MAX_OPEN_DATA_BUCKETS; i++) {
> +		b = kzalloc(sizeof(*b), GFP_KERNEL);
>  		if (!b)
>  			return -ENOMEM;
>  
>  		list_add(&b->list, &c->data_buckets);
>  	}
>  
> +	for (i = 0; i < MAX_OPEN_FLASH_BUCKETS; i++) {
> +		b = kzalloc(sizeof(*b), GFP_KERNEL);
> +		if (!b)
> +			return -ENOMEM;
> +
> +		list_add(&b->list, &c->flash_buckets);
> +	}
> +
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> old mode 100644
> new mode 100755
> index abd31e8..0233548
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -627,6 +627,7 @@ struct cache_set {
>  
>  	/* List of buckets we're currently writing data to */
>  	struct list_head	data_buckets;
> +	struct list_head	flash_buckets;
>  	spinlock_t		data_bucket_lock;
>  
>  	struct journal		journal;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> old mode 100644
> new mode 100755
> index fc0a31b..af64b8c
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1505,6 +1505,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  	INIT_LIST_HEAD(&c->btree_cache_freeable);
>  	INIT_LIST_HEAD(&c->btree_cache_freed);
>  	INIT_LIST_HEAD(&c->data_buckets);
> +	INIT_LIST_HEAD(&c->flash_buckets);
>  
>  	c->search = mempool_create_slab_pool(32, bch_search_cache);
>  	if (!c->search)
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
