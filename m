From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: optimize barrier usage for Rmw atomic bitops
Date: Fri, 20 Mar 2020 23:24:45 +0800
Message-ID: <877a5349-3133-404a-86ea-02309080a520@suse.de>
References: <20200129180802.24626-1-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200129180802.24626-1-dave@stgolabs.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-bcache@vger.kernel.org

On 2020/1/30 2:08 上午, Davidlohr Bueso wrote:
> We can avoid the unnecessary barrier on non LL/SC architectures,
> such as x86. Instead, use the smp_mb__after_atomic().
> 

Hi Davidlohr,

> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Sorry for replying late. Indeed we don't need to worry about the extra
smp_mb() because the code patch gets called every 5 seconds by default,
which is very infrequent. But I like this more accurate patch, it is in
my testing already.

And by your inspiration, I also fix some other locations to use
smp_mb__before/after_atomic().

Thank you.

Coly Li

> ---
>  drivers/md/bcache/writeback.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 4a40f9eadeaf..284ff10f480f 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -183,7 +183,7 @@ static void update_writeback_rate(struct work_struct *work)
>  	 */
>  	set_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>  	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -	smp_mb();
> +	smp_mb__after_atomic();
>  
>  	/*
>  	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
> @@ -193,7 +193,7 @@ static void update_writeback_rate(struct work_struct *work)
>  	    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
>  		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>  		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -		smp_mb();
> +		smp_mb__after_atomic();
>  		return;
>  	}
>  
> @@ -229,7 +229,7 @@ static void update_writeback_rate(struct work_struct *work)
>  	 */
>  	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>  	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -	smp_mb();
> +	smp_mb__after_atomic();
>  }
>  
>  static unsigned int writeback_delay(struct cached_dev *dc,
> 


-- 

Coly Li
