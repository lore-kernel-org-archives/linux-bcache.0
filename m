From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: gc does not work when triggering by manual
 command
Date: Thu, 8 Jun 2017 23:53:37 +0800
Message-ID: <d6bfd83b-2f90-b091-c4b3-e3dcfdbf3444@coly.li>
References: <1496903963-11068-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:42162 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751629AbdFHPxv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 11:53:51 -0400
In-Reply-To: <1496903963-11068-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, kent.overstreet@gmail.com, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org

On 2017/6/8 下午2:39, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> I try to execute the following command to trigger gc thread:
> [root@localhost internal]# echo 1 > trigger_gc
> But it does not work, I debug the code in gc_should_run(), It works only
> if in invalidating or sectors_to_gc < 0. So set sectors_to_gc to -1 to
> meet the condition when we trigger gc by manual command.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

This fix may make things more complicated. First we need to know why
when writeback cashe is full but sectors_to_gc < 0 ? If we don't find
out the root reason, this fix is not convinced.

Thanks.

Coly


> ---
>  drivers/md/bcache/btree.h | 6 ++++++
>  drivers/md/bcache/sysfs.c | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> index 9b80417..bab07d4 100644
> --- a/drivers/md/bcache/btree.h
> +++ b/drivers/md/bcache/btree.h
> @@ -263,6 +263,12 @@ static inline void wake_up_gc(struct cache_set *c)
>  	wake_up(&c->gc_wait);
>  }
>  
> +static inline void wake_up_gc_force(struct cache_set *c)
> +{
> +	atomic_set(&c->sectors_to_gc, -1);
> +	wake_up(&c->gc_wait);
> +}
> +
>  #define MAP_DONE	0
>  #define MAP_CONTINUE	1
>  
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index b3ff57d..5fdb86c 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -615,7 +615,7 @@ STORE(__bch_cache_set)
>  	}
>  
>  	if (attr == &sysfs_trigger_gc)
> -		wake_up_gc(c);
> +		wake_up_gc_force(c);
>  
>  	if (attr == &sysfs_prune_cache) {
>  		struct shrink_control sc;
> 
