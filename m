From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 2/2] panic fix for making cache device
Date: Tue, 25 Sep 2018 20:41:36 +0800
Message-ID: <e588a1a7-2fa7-a84a-2c74-11f503005dbd@suse.de>
References: <20180925060945.6731-1-cdbdyx@163.com>
 <20180925060945.6731-2-cdbdyx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925060945.6731-2-cdbdyx@163.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongbo Cao <cdbdyx@163.com>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org


On 9/25/18 2:09 PM, Dongbo Cao wrote:
> when the nbuckets of cache device is smaller than 1024, making cache device will trigger BUG_ON in kernel, add a condition to avoid this.
>
> Signed-off-by: Dongbo Cao <cdbdyx@163.com>

This patch added to my for-next, with minor change to fix checkpatch.pl 
warning.

Thanks.


Coly Li


> ---
>   drivers/md/bcache/super.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 0c0f6d8f..47d122ed 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2036,7 +2036,12 @@ static int cache_alloc(struct cache *ca)
>   	 */
>   	btree_buckets = ca->sb.njournal_buckets ?: 8;
>   	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
> -	
> +	if (!free) {
> +		ret = -EPERM;
> +		err = "ca->sb.nbuckets is too small";
> +		goto err_free;
> +	}
> +
>   	if (!init_fifo(&ca->free[RESERVE_BTREE], btree_buckets,
>   						GFP_KERNEL)) {
>   		err = "ca->free[RESERVE_BTREE] alloc failed";
> @@ -2102,6 +2107,7 @@ static int cache_alloc(struct cache *ca)
>   err_prio_alloc:
>   	free_fifo(&ca->free[RESERVE_BTREE]);
>   err_btree_alloc:
> +err_free:
>   	module_put(THIS_MODULE);
>   	if (err)
>   		pr_notice("error %s: %s", ca->cache_dev_name, err);
> @@ -2131,6 +2137,8 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
>   		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>   		if (ret == -ENOMEM)
>   			err = "cache_alloc(): -ENOMEM";
> +		else if (ret == -EPERM)
> +			err = "cache_alloc(): cache device is too small";
>   		else
>   			err = "cache_alloc(): unknown error";
>   		goto err;
