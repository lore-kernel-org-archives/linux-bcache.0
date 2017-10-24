From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] update bucket_in_use in real time
Date: Tue, 24 Oct 2017 21:12:15 +0800
Message-ID: <39ec4670-667b-b4ce-75dc-713d119fc458@suse.de>
References: <1508835429-6977-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1508835429-6977-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/10/24 下午4:57, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> bucket_in_use is updated in gc thread which triggered by invalidating or
> writing sectors_to_gc dirty data, It's a long interval. Therefore, when we
> use it to compare with the threshold, it is often not timely, which leads
> to inaccurate judgment and often results in bucket depletion.
> 
> We have send a patch before, by the means of updating bucket_in_use
> periodically In gc thread, which Coly thought that would lead high
> latency, In this patch, we add avail_nbuckets to record the count of
> available buckets, and we calculate bucket_in_use when alloc or free
> bucket in real time.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

Hi Junhui,

Thanks for the patch, this is a start to solve gc latency. Please check
my comments in line.


> ---
>  drivers/md/bcache/alloc.c  | 10 ++++++++++
>  drivers/md/bcache/bcache.h |  1 +
>  drivers/md/bcache/btree.c  | 17 ++++++++++-------
>  drivers/md/bcache/btree.h  |  1 +
>  4 files changed, 22 insertions(+), 7 deletions(-)
>  mode change 100644 => 100755 drivers/md/bcache/alloc.c
>  mode change 100644 => 100755 drivers/md/bcache/bcache.h
>  mode change 100644 => 100755 drivers/md/bcache/btree.c
>  mode change 100644 => 100755 drivers/md/bcache/btree.h
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> old mode 100644
> new mode 100755
> index ca4abe1..89a5e35
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -439,6 +439,11 @@ long bch_bucket_alloc(struct cache *ca, unsigned reserve, bool wait)
>  		b->prio = INITIAL_PRIO;
>  	}
>  
> +	if(ca->set->avail_nbuckets > 0) {
> +		ca->set->avail_nbuckets--;
> +		bch_update_bucket_in_use(ca->set);
> +	}
> +

ca->set->avai_nuckets-- is a read-modify-update operation, which means
concurrent update will overwrite value update, imaging,
       in-memory     thread 1             thread 2
          n = 4
v = n     n = 4       v <- 4
          n = 4                            v <- 4
v--       n = 4       v <- 3
          n = 4                            v <- 3
n = v     n = 3       n <- 3
          n = 3                            n <- 3
          n = 3

In this case a correct n value should be 2, but n value in memory is 3.
Use atomic routine atomc_dec() will solve such issue.

>  	return r;
>  }
>  
> @@ -446,6 +451,11 @@ void __bch_bucket_free(struct cache *ca, struct bucket *b)
>  {
>  	SET_GC_MARK(b, 0);
>  	SET_GC_SECTORS_USED(b, 0);
> +	
> +	if(ca->set->avail_nbuckets < ca->set->nbuckets) {
> +		ca->set->avail_nbuckets++;
> +		bch_update_bucket_in_use(ca->set);
> +	}

Here we should use atomic_inc() to avail_nbuckets, the reason is similar
to bch_bucket_alloc().


>  }
>  
>  void bch_bucket_free(struct cache_set *c, struct bkey *k)
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> old mode 100644
> new mode 100755
> index dee542f..275b29c
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -580,6 +580,7 @@ struct cache_set {
>  	uint8_t			need_gc;
>  	struct gc_stat		gc_stats;
>  	size_t			nbuckets;
> +	size_t			avail_nbuckets;
>

Here avail_nbuckets should be atomic_t.

>  	struct task_struct	*gc_thread;
>  	/* Where in the btree gc currently is */
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> old mode 100644
> new mode 100755
> index 866dcf7..1ccf0c3
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1240,6 +1240,11 @@ void bch_initial_mark_key(struct cache_set *c, int level, struct bkey *k)
>  	__bch_btree_mark_key(c, level, k);
>  }
>  
> +void bch_update_bucket_in_use(struct cache_set *c)
> +{
> +	c->gc_stats.in_use = (c->nbuckets - c->avail_nbuckets) * 100 / c->nbuckets;
> +}

Here should use atomic_read() to c->avail_nbuckets.

> +
>  static bool btree_gc_mark_node(struct btree *b, struct gc_stat *gc)
>  {
>  	uint8_t stale = 0;
> @@ -1651,9 +1656,8 @@ static void btree_gc_start(struct cache_set *c)
>  	mutex_unlock(&c->bucket_lock);
>  }
>  
> -static size_t bch_btree_gc_finish(struct cache_set *c)
> +static void bch_btree_gc_finish(struct cache_set *c)
>  {
> -	size_t available = 0;
>  	struct bucket *b;
>  	struct cache *ca;
>  	unsigned i;
> @@ -1690,6 +1694,7 @@ static size_t bch_btree_gc_finish(struct cache_set *c)
>  	}
>  	rcu_read_unlock();
>  
> +	c->avail_nbuckets = 0;
>  	for_each_cache(ca, c, i) {
>  		uint64_t *i;
>  
> @@ -1711,18 +1716,16 @@ static size_t bch_btree_gc_finish(struct cache_set *c)
>  			BUG_ON(!GC_MARK(b) && GC_SECTORS_USED(b));
>  
>  			if (!GC_MARK(b) || GC_MARK(b) == GC_MARK_RECLAIMABLE)
> -				available++;
> +				c->avail_nbuckets++;

In bch_bucket_alloc(), avail_nbuckets is decreased and
GC_MARK_RECLAIMABLE might be marked to bucket. Because c->avail_nbuckets
is updated without c->bucket_lock protect, it is possible that
c->avail_nbuckets is decreased in bch_buckets_alloc() and increased in
bch_btree_gc_finish(), which results an inaccurate available buckets value.
>  		}
>  	}
>  
>  	mutex_unlock(&c->bucket_lock);
> -	return available;


A solution is to still keep available++ in the above code, and use
atomic_set(&c->avail_nbuckets, available) at the last line of this function.

By this method, if a bucket is in a small window that just allocated
(mark reclaimable) but not written (mark dirty), and
bch_btree_gc_finish() is called, c->avail_nbuckets can be consistent by
overwritten by atomic_set(&c->avail_nbuckets, available). Other wise we
will lost 1 counter.

How do you think about it ?

>  }
>  
>  static void bch_btree_gc(struct cache_set *c)
>  {
>  	int ret;
> -	unsigned long available;
>  	struct gc_stat stats;
>  	struct closure writes;
>  	struct btree_op op;
> @@ -1745,14 +1748,14 @@ static void bch_btree_gc(struct cache_set *c)
>  			pr_warn("gc failed!");
>  	} while (ret);
>  
> -	available = bch_btree_gc_finish(c);
> +	bch_btree_gc_finish(c);
>  	wake_up_allocators(c);
>  
>  	bch_time_stats_update(&c->btree_gc_time, start_time);
>  
>  	stats.key_bytes *= sizeof(uint64_t);
>  	stats.data	<<= 9;
> -	stats.in_use	= (c->nbuckets - available) * 100 / c->nbuckets;
> +	stats.in_use	= (c->nbuckets - c->avail_nbuckets) * 100 / c->nbuckets;

atomic_read to c->avail_nbuckets should be used here.


>  	memcpy(&c->gc_stats, &stats, sizeof(struct gc_stat));
>  
>  	trace_bcache_gc_end(c);
> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> old mode 100644
> new mode 100755
> index 73da1f5..dabcde8
> --- a/drivers/md/bcache/btree.h
> +++ b/drivers/md/bcache/btree.h
> @@ -305,5 +305,6 @@ bool bch_keybuf_check_overlapping(struct keybuf *, struct bkey *,
>  struct keybuf_key *bch_keybuf_next(struct keybuf *);
>  struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *, struct keybuf *,
>  					  struct bkey *, keybuf_pred_fn *);
> +void bch_update_bucket_in_use(struct cache_set *c);
>  
>  #endif
>

Available nbuckets should be counted when a clean bucket is set to
dirty. Fortunately I find once a bucket is new allocated, it will be
dirty and no error condition happens between the bucket is allocated and
dirtied. So it works to count available bucket numbers in
bch_bucket_alloc() and bch_bucket_free(), it is ok to me at this moment.

Thanks.

Coly Li
