From: Coly Li <i@coly.li>
Subject: Re: [PATCH 16/19] bcache: increase the number of open buckets
Date: Thu, 13 Jul 2017 17:56:45 +0800
Message-ID: <82ceac54-48b2-853c-a284-7161869853a7@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-16-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:32824 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751309AbdGMJ4z (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jul 2017 05:56:55 -0400
In-Reply-To: <1498855388-16990-16-git-send-email-bcache@lists.ewheeler.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: bcache@lists.ewheeler.net, linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>

On 2017/7/1 上午4:43, bcache@lists.ewheeler.net wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> In currently, we only alloc 6 open buckets for each cache set,
> but in usually, we always attach about 10 or so backend devices for
> each cache set, and the each bcache device are always accessed by
> about 10 or so threads in top application layer. So 6 open buckets
> are too few, It has led to that each of the same thread write data
> to different buckets, which would cause low efficiency write-back,
> and also cause buckets inefficient, and would be Very easy to run
> out of.
> 
> I add debug message in bch_open_buckets_alloc() to print alloc bucket
> info, and test with ten bcache devices with a cache set, and each
> bcache device is accessed by ten threads.
> 
> From the debug message, we can see that, after the modification, One
> bucket is more likely to assign to the same thread, and the data from
> the same thread are more likely to write the same bucket. Usually the
> same thread always write/read the same backend device, so it is good
> for write-back and also promote the usage efficiency of buckets.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

Nice catch for performance !

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.


> ---
>  drivers/md/bcache/alloc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index ca4abe1..cacbe2d 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -68,6 +68,8 @@
>  #include <linux/random.h>
>  #include <trace/events/bcache.h>
>  
> +#define MAX_OPEN_BUCKETS 128
> +
>  /* Bucket heap / gen */
>  
>  uint8_t bch_inc_gen(struct cache *ca, struct bucket *b)
> @@ -671,7 +673,7 @@ int bch_open_buckets_alloc(struct cache_set *c)
>  
>  	spin_lock_init(&c->data_bucket_lock);
>  
> -	for (i = 0; i < 6; i++) {
> +	for (i = 0; i < MAX_OPEN_BUCKETS; i++) {
>  		struct open_bucket *b = kzalloc(sizeof(*b), GFP_KERNEL);
>  		if (!b)
>  			return -ENOMEM;
> 


-- 
Coly Li
