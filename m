From: Coly Li <i@coly.li>
Subject: Re: [PATCH 11/19] bcache: Subtract dirty sectors of thin flash from
 cache_sectors in calculating writeback rate
Date: Tue, 11 Jul 2017 02:11:17 +0800
Message-ID: <1f1670e4-a442-0534-6826-eefd88dfdcad@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-11-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-11-git-send-email-bcache@lists.ewheeler.net>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Tang Junhui <tang.junhui@zte.com.cn>
Cc: bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/7/1 上午4:43, bcache@lists.ewheeler.net wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Since dirty sectors of thin flash cannot be used to cache data for backend
> device, so we should subtract it in calculating writeback rate.
> 

I see you want to get ride of the noise of flash only cache device for
writeback rate calculation. It makes sense, because flash only cache
device won't have write back happen at all.


> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/bcache/writeback.c |  2 +-
>  drivers/md/bcache/writeback.h | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 4ac8b13..25289e4 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -21,7 +21,7 @@
>  static void __update_writeback_rate(struct cached_dev *dc)
>  {
>  	struct cache_set *c = dc->disk.c;
> -	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size;
> +	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size - bcache_flash_devs_sectors_dirty(c);

See flash_dev_run(), the flash volume is created per struct
bcache_device of a cache set. That means, all data allocated for the
flash volume will be from a flash only bcache device. Regular dirty data
won't mixed allocating with flash volume dirty data on identical struct
bcache device.

Based on the above implementation, non-dirty space from flash only
bcache device will mislead writeback rate calculation too. So I suggest
to subtract all buckets size from all flash only bcache devices. Then it
might be something like,

uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size -
			bcache_flash_devs_nbuckets(c);



Just FYI. Thanks.

Coly

>  	uint64_t cache_dirty_target =
>  		div_u64(cache_sectors * dc->writeback_percent, 100);
>  
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index c2ab4b4..24ff589 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -14,6 +14,25 @@ static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
>  	return ret;
>  }
>  
> +static inline uint64_t  bcache_flash_devs_sectors_dirty(struct cache_set *c)
> +{
> +	uint64_t i, ret = 0;
> +
> +	mutex_lock(&bch_register_lock);
> +
> +	for (i = 0; i < c->nr_uuids; i++) {
> +		struct bcache_device *d = c->devices[i];
> +
> +		if (!d || !UUID_FLASH_ONLY(&c->uuids[i]))
> +			continue;
> +	   ret += bcache_dev_sectors_dirty(d);
> +	}
> +
> +	mutex_unlock(&bch_register_lock);
> +
> +	return ret;
> +}
> +
>  static inline unsigned offset_to_stripe(struct bcache_device *d,
>  					uint64_t offset)
>  {
> 
