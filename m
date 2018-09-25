From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 3/3] split original if condition code in function
 bch_cache_set_alloc
Date: Tue, 25 Sep 2018 20:49:38 +0800
Message-ID: <95bcd9b4-5aa3-9bfc-0619-285cac315524@suse.de>
References: <20180925084142.8764-1-cdbdyx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925084142.8764-1-cdbdyx@163.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongbo Cao <cdbdyx@163.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org


On 9/25/18 4:41 PM, Dongbo Cao wrote:
> remove bch_cache_set_unregister because we have not registerd right now
>
> Signed-off-by: Dongbo Cao <cdbdyx@163.com>

Hi Dongbo,


This patch doesn't apply to for-next branch of my tree, could you please 
to rebase it ?

(git://git.kernel.org/pub/scm/linux/kernel/git/colyli/linux-bcache.git) 
<git://git.kernel.org/pub/scm/linux/kernel/git/colyli/linux-bcache.git>

Thanks.


Coly Li


> ---
>   drivers/md/bcache/super.c | 102 ++++++++++++++++++++++++++++++--------
>   1 file changed, 82 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 47d122ed..13a128eb 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1658,9 +1658,13 @@ void bch_cache_set_unregister(struct cache_set *c)
>   struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>   {
>   	int iter_size;
> +	const char *err = NULL;
> +
>   	struct cache_set *c = kzalloc(sizeof(struct cache_set), GFP_KERNEL);
> -	if (!c)
> -		return NULL;
> +	if (!c) {
> +		err = "cache_set alloc failed";
> +		goto err_cache_set_alloc;
> +	}
>   
>   	__module_get(THIS_MODULE);
>   	closure_init(&c->cl, NULL);
> @@ -1715,22 +1719,55 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>   	iter_size = (sb->bucket_size / sb->block_size + 1) *
>   		sizeof(struct btree_iter_set);
>   
> -	if (!(c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL)) ||
> -	    mempool_init_slab_pool(&c->search, 32, bch_search_cache) ||
> -	    mempool_init_kmalloc_pool(&c->bio_meta, 2,
> -				      sizeof(struct bbio) + sizeof(struct bio_vec) *
> -				      bucket_pages(c)) ||
> -	    mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size) ||
> -	    bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
> -			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
> -	    !(c->uuids = alloc_bucket_pages(GFP_KERNEL, c)) ||
> -	    !(c->moving_gc_wq = alloc_workqueue("bcache_gc",
> -						WQ_MEM_RECLAIM, 0)) ||
> -	    bch_journal_alloc(c) ||
> -	    bch_btree_cache_alloc(c) ||
> -	    bch_open_buckets_alloc(c) ||
> -	    bch_bset_sort_state_init(&c->sort, ilog2(c->btree_pages)))
> -		goto err;
> +	if (!(c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL))) {
> +		err = "c->devices alloc failed";
> +		goto err_devices_alloc;
> +	}
> +	if (mempool_init_slab_pool(&c->search, 32, bch_search_cache)) {
> +		err = "c->search alloc failed";
> +		goto err_search_alloc;
> +	}	
> +	if (mempool_init_kmalloc_pool(&c->bio_meta, 2,
> +			sizeof(struct bbio) + sizeof(struct bio_vec) *
> +						bucket_pages(c))) {
> +		err = "c->bio_meta alloc failed";
> +		goto err_bio_meta_alloc;
> +	}
> +	if (mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size)) {
> +		err = "c->fill_iter alloc failed";
> +		goto err_fill_iter_alloc;
> +	}
> +	if (bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
> +			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER)) {
> +		err = "c->bio_split init failed";
> +		goto err_bio_split_init;
> +	}
> +	if (!(c->uuids = alloc_bucket_pages(GFP_KERNEL, c))) {
> +		err = "c->uuids alloc failed";
> +		goto err_uuids_alloc;
> +	}
> +	if (!(c->moving_gc_wq = alloc_workqueue("bcache_gc",
> +						WQ_MEM_RECLAIM, 0))) {
> +		err = "c->moving_gc_wq alloc failed";
> +		goto err_moving_gc_wq_alloc;
> +	}
> +	if (bch_journal_alloc(c)) {
> +		err = "bch_journal_alloc failed";
> +		goto err_bch_journal_alloc;
> +
> +	}
> +	if (bch_btree_cache_alloc(c)) {
> +		err = "bch_btree_cache_alloc failed";
> +		goto err_bch_btree_cache_alloc;
> +	}
> +	if (bch_open_buckets_alloc(c)) {
> +		err = "bch_open_buckets_alloc failed";
> +		goto err_bch_open_buckets_alloc;
> +	}
> +	if (bch_bset_sort_state_init(&c->sort, ilog2(c->btree_pages))) {
> +		err = "bch_bset_sort_state_init failed";
> +		goto err_bch_bset_sort_state_init;
> +	}
>   
>   	c->congested_read_threshold_us	= 2000;
>   	c->congested_write_threshold_us	= 20000;
> @@ -1738,8 +1775,33 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>   	WARN_ON(test_and_clear_bit(CACHE_SET_IO_DISABLE, &c->flags));
>   
>   	return c;
> -err:
> -	bch_cache_set_unregister(c);
> +
> +err_bch_bset_sort_state_init:
> +	bch_open_buckets_free(c);
> +err_bch_open_buckets_alloc:
> +	bch_btree_cache_free(c);
> +err_bch_btree_cache_alloc:
> +	bch_journal_free(c);
> +err_bch_journal_alloc:
> +	destroy_workqueue(c->moving_gc_wq);
> +err_moving_gc_wq_alloc:
> +	free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
> +err_uuids_alloc:
> +	bioset_exit(&c->bio_split);
> +err_bio_split_init:
> +	mempool_exit(&c->fill_iter);
> +err_fill_iter_alloc:
> +	mempool_exit(&c->bio_meta);
> +err_bio_meta_alloc:
> +	mempool_exit(&c->search);
> +err_search_alloc:
> +	kfree(c->devices);
> +err_devices_alloc:
> +	kfree(c);
> +	module_put(THIS_MODULE);
> +err_cache_set_alloc:
> +        if (err)
> +                pr_notice("error cache set %s: %s", c->sb.set_uuid, err);	
>   	return NULL;
>   }
>   
