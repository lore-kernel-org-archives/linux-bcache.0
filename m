From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: [PATCH 1/2] md: bcache: Replace get_seconds with
 ktime_get_seconds
Date: Tue, 22 Dec 2015 14:26:15 +0100
Message-ID: <20151222132615.GA25410@suse.cz>
References: <1450789379-31062-1-git-send-email-shraddha.6596@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbbLVN0R (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Dec 2015 08:26:17 -0500
Content-Disposition: inline
In-Reply-To: <1450789379-31062-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: shraddha.6596@gmail.com
Cc: Neil Brown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>

Hello Shraddha,

I don't think you can use ktime_get_seconds() for last_mount in the
superblock, since the superblock is persistent between reboots and the
monotonic time value doesn't make any sense on next reboot.

Vojtech


On Tue, Dec 22, 2015 at 06:32:59PM +0530, shraddha.6596@gmail.com wrote:
> From: Shraddha Barke <shraddha.6596@gmail.com>
> 
> 32-bit systems using function get_seconds will break in the year 2038,
> in order to avoid that replace the code with more appropriate
> function ktime_get_seconds which is y2038 safe.
> Function ktime_get_seconds is used since it uses monotonic instead of
> real time and thus will not cause overflow.
> 
> Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
> ---
>  drivers/md/bcache/super.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 679a093..f4bd17d 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -188,7 +188,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>  		goto err;
>  	}
>  
> -	sb->last_mount = get_seconds();
> +	sb->last_mount = ktime_get_seconds();
>  	err = NULL;
>  
>  	get_page(bh->b_page);
> @@ -696,7 +696,7 @@ static void bcache_device_detach(struct bcache_device *d)
>  
>  		SET_UUID_FLASH_ONLY(u, 0);
>  		memcpy(u->uuid, invalid_uuid, 16);
> -		u->invalidated = cpu_to_le32(get_seconds());
> +		u->invalidated = cpu_to_le32(ktime_get_seconds());
>  		bch_uuid_write(d->c);
>  	}
>  
> @@ -927,7 +927,7 @@ void bch_cached_dev_detach(struct cached_dev *dc)
>  
>  int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
>  {
> -	uint32_t rtime = cpu_to_le32(get_seconds());
> +	uint32_t rtime = cpu_to_le32(ktime_get_seconds());
>  	struct uuid_entry *u;
>  	char buf[BDEVNAME_SIZE];
>  
> @@ -959,7 +959,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
>  	    (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
>  	     BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
>  		memcpy(u->uuid, invalid_uuid, 16);
> -		u->invalidated = cpu_to_le32(get_seconds());
> +		u->invalidated = cpu_to_le32(ktime_get_seconds());
>  		u = NULL;
>  	}
>  
> @@ -1261,7 +1261,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
>  
>  	get_random_bytes(u->uuid, 16);
>  	memset(u->label, 0, 32);
> -	u->first_reg = u->last_reg = cpu_to_le32(get_seconds());
> +	u->first_reg = u->last_reg = cpu_to_le32(ktime_get_seconds());
>  
>  	SET_UUID_FLASH_ONLY(u, 1);
>  	u->sectors = size >> 9;
> @@ -1670,7 +1670,7 @@ static void run_cache_set(struct cache_set *c)
>  		goto err;
>  
>  	closure_sync(&cl);
> -	c->sb.last_mount = get_seconds();
> +	c->sb.last_mount = ktime_get_seconds();
>  	bcache_write_super(c);
>  
>  	list_for_each_entry_safe(dc, t, &uncached_devices, list)
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Vojtech Pavlik
Director SUSE Labs
