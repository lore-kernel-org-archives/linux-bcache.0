From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: release the allocated id, not its multiple of
 BCACHE_MINORS
Date: Fri, 23 Jun 2017 15:30:12 +0800
Message-ID: <f4e62698-95f7-c471-40ba-0f27f34c6d45@coly.li>
References: <1498202111-30469-1-git-send-email-liangchen.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:45124 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753350AbdFWHaS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 23 Jun 2017 03:30:18 -0400
In-Reply-To: <1498202111-30469-1-git-send-email-liangchen.linux@gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net

On 2017/6/23 下午3:15, Liang Chen wrote:
> The id passed to ida_simple_remove has to be the one originally
> allocated with ida_simple_get, not the one after multipling by
> BCACHE_MINORS.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  drivers/md/bcache/super.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e57353e..9f64477 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -734,7 +734,8 @@ static void bcache_device_free(struct bcache_device *d)
>  	if (d->disk && d->disk->queue)
>  		blk_cleanup_queue(d->disk->queue);
>  	if (d->disk) {
> -		ida_simple_remove(&bcache_minor, d->disk->first_minor);
> +		ida_simple_remove(&bcache_minor,
> +				d->disk->first_minor / BCACHE_MINORS);
>  		put_disk(d->disk);
>  	}
>  
> @@ -784,7 +785,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  
>  	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
>  	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
> -		ida_simple_remove(&bcache_minor, minor);
> +		ida_simple_remove(&bcache_minor, minor / BCACHE_MINORS);
>  		return -ENOMEM;
>  	}
>  
> 

Hi Liang,

Junhui fixes it already, the patch is submitted to Jens Axboe already.
Maybe the patch will show up in next merge window.


-- 
Coly Li
