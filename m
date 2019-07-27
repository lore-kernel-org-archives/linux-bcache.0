From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 2/3] bcache: use allocator reserves instead of watermarks
Date: Sat, 27 Jul 2019 22:13:22 +0800
Message-ID: <4bc32702-9d83-1ac5-4c79-2d9e45123da8@suse.de>
References: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
 <1564222799-10603-2-git-send-email-baiyaowei@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1564222799-10603-2-git-send-email-baiyaowei@cmss.chinamobile.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yaowei Bai <baiyaowei@cmss.chinamobile.com>, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/7/27 6:19 下午, Yaowei Bai wrote:
> Commit 78365411b344 ("bcache: Rework allocator reserves") introduced
> allocator reserves and dropped watermarks, let's keep this consistent
> to avoid confusing.
> 
> Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>

It is OK to me, I will add it to my for-test.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index c22c260..609df38 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -622,13 +622,13 @@ bool bch_alloc_sectors(struct cache_set *c,
>  	spin_lock(&c->data_bucket_lock);
>  
>  	while (!(b = pick_data_bucket(c, k, write_point, &alloc.key))) {
> -		unsigned int watermark = write_prio
> +		unsigned int reserve = write_prio
>  			? RESERVE_MOVINGGC
>  			: RESERVE_NONE;
>  
>  		spin_unlock(&c->data_bucket_lock);
>  
> -		if (bch_bucket_alloc_set(c, watermark, &alloc.key, 1, wait))
> +		if (bch_bucket_alloc_set(c, reserve, &alloc.key, 1, wait))
>  			return false;
>  
>  		spin_lock(&c->data_bucket_lock);
> 
