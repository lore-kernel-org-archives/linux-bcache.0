From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 3/3] bcache: count cache_available_percent accurately
Date: Sat, 27 Jul 2019 22:39:30 +0800
Message-ID: <aff72e17-a36d-4bb8-28e2-49af07dc72ad@suse.de>
References: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
 <1564222799-10603-3-git-send-email-baiyaowei@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1564222799-10603-3-git-send-email-baiyaowei@cmss.chinamobile.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/7/27 6:19 下午, Yaowei Bai wrote:
> The interface cache_available_percent is used to indicate how
> many buckets in percent are available to be used to cache data
> at a specific moment. It should include the unused and clean
> buckets which we get from bch_btree_gc_finish function:
> 
> 	if (!GC_MARK(b) || GC_MARK(b) == GC_MARK_RECLAIMABLE)
> 		 c->avail_nbuckets++;
> 
> However currently in the allocation code we didn't distinguish
> these available buckets with the metadata and dirty buckets, we
> just decrease the c->avail_nbuckets everytime we allocate a bucket,
> and correct it after a gc completes. With this, in a read-only
> scenario, you can observe that cache_available_percent bounces,
> it first go down to a number, like 95, and then bounces back to
> 100. It goes on and on, making users confused.

Hmm, I don't feel it could be confused, indeed I feel this is what is
designed for, counting both data/meta data buckets allocation. We can
document in admin-guide/bcache.rst, and notice people that even for
read-only requests, buckets can also be allocated for metadata.

Thanks.

Coly Li


> 
> This patch fixes this problem by decreasing c->avail_nbuckets
> only when allocate metadata and dirty buckets. With this patch,
> cache_available_percent will always be accurate and avoid the
> confusion.
> 
> Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
> ---
>  drivers/md/bcache/alloc.c   | 10 +++++-----
>  drivers/md/bcache/request.c |  9 ++++++++-
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 609df38..dc7f6c2 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -443,17 +443,17 @@ long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
>  		SET_GC_MARK(b, GC_MARK_METADATA);
>  		SET_GC_MOVE(b, 0);
>  		b->prio = BTREE_PRIO;
> +
> +		if (ca->set->avail_nbuckets > 0) {
> +			ca->set->avail_nbuckets--;
> +			bch_update_bucket_in_use(ca->set, &ca->set->gc_stats);
> +		}
>  	} else {
>  		SET_GC_MARK(b, GC_MARK_RECLAIMABLE);
>  		SET_GC_MOVE(b, 0);
>  		b->prio = INITIAL_PRIO;
>  	}
>  
> -	if (ca->set->avail_nbuckets > 0) {
> -		ca->set->avail_nbuckets--;
> -		bch_update_bucket_in_use(ca->set, &ca->set->gc_stats);
> -	}
> -
>  	return r;
>  }
>  
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 41adcd1..b69bd8d 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -244,9 +244,16 @@ static void bch_data_insert_start(struct closure *cl)
>  		if (op->writeback) {
>  			SET_KEY_DIRTY(k, true);
>  
> -			for (i = 0; i < KEY_PTRS(k); i++)
> +			for (i = 0; i < KEY_PTRS(k); i++) {
>  				SET_GC_MARK(PTR_BUCKET(op->c, k, i),
>  					    GC_MARK_DIRTY);
> +
> +				if (op->c->avail_nbuckets > 0) {
> +					op->c->avail_nbuckets--;
> +					bch_update_bucket_in_use(op->c,
> +								 &op->c->gc_stats);
> +				}
> +			}
>  		}
>  
>  		SET_KEY_CSUM(k, op->csum);
> 
