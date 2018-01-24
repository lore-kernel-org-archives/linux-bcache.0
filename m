From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH] bcache: lock in btree_flush_write() to avoid races
Date: Wed, 24 Jan 2018 12:30:48 +0200
Message-ID: <280d3162-8af0-a404-e481-5e2052f6309b@suse.com>
References: <1516776864-26993-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1516776864-26993-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org



On 24.01.2018 08:54, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> In btree_flush_write(), two places need to take a locker to
> avoid races:
> 
> Firstly, we need take rcu read locker to protect the bucket_hash
> traverse, since hlist_for_each_entry_rcu() must be called under
> the protection of rcu read locker.
> 
> Secondly, we need take b->write_lock locker to protect journal
> of the btree node, otherwise, the btree node may have been
> written, and the journal have been assign to NULL.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/journal.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 02a98dd..505f9f3 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -375,7 +375,9 @@ static void btree_flush_write(struct cache_set *c)
>  retry:
>  	best = NULL;
>  
> -	for_each_cached_btree(b, c, i)
> +	rcu_read_lock();
> +	for_each_cached_btree(b, c, i) {
> +		mutex_lock(&b->write_lock);


You can't sleep in rcu read critical section, yet here you take mutex
which can sleep under rcu_read_lock.

>  		if (btree_current_write(b)->journal) {
>  			if (!best)
>  				best = b;
> @@ -385,6 +387,9 @@ static void btree_flush_write(struct cache_set *c)
>  				best = b;
>  			}
>  		}
> +		mutex_unlock(&b->write_lock);
> +	}
> +	rcu_read_unlock();
>  
>  	b = best;
>  	if (b) {
> 
