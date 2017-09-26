From: tang.junhui@zte.com.cn
Subject: Re: [PATCH] bcache: fix a comments typo in bch_alloc_sectors()
Date: Tue, 26 Sep 2017 19:20:23 +0800
Message-ID: <1506424823-11603-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: 10074136 <tang.junhui@zte.com.cn>
List-Id: linux-bcache@vger.kernel.org

From: 10074136 <tang.junhui@zte.com.cn>

> Code comments in alloc.c:bch_alloc_sectors() mentions a function
> name find_data_bucket(), the correct function name should be
> pick_data_bucket() indeed. bch_alloc_sectors() is a quite important
> function in bcache allocation code, fixing the typo may help
> other people to have less confusion.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index cacbe2dbd5c3..071ff28be912 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -600,7 +600,7 @@ bool bch_alloc_sectors(struct cache_set *c, struct bkey *k, unsigned sectors,
>  
>  		 /*
>  		  * If we had to allocate, we might race and not need to allocate the
> -		  * second time we call find_data_bucket(). If we allocated a bucket but
> +		  * second time we call pick_data_bucket(). If we allocated a bucket but
>  		  * didn't use it, drop the refcount bch_bucket_alloc_set() took:
>  		  */
>  		 if (KEY_PTRS(&alloc.key))

Yes, It's useful for code reading, Thanks.

Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>
