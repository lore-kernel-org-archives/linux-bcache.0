From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v5 06/10] bcache: add stop_when_cache_set_failed option to
 backing device
Date: Wed, 7 Feb 2018 09:36:59 -0800
Message-ID: <38be8e23-2193-0373-8159-527a527ce813@lyle.org>
References: <20180206042100.65021-1-colyli@suse.de>
 <20180206042100.65021-7-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180206042100.65021-7-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Nix <nix@esperi.org.uk>, Pavel Goran <via-bcache@pvgoran.name>, Junhui Tang <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>
List-Id: linux-bcache@vger.kernel.org

I agree about the typos-- after they're fixed,

Reviewed-by: Michael Lyle <mlyle@lyle.org>

On 02/05/2018 08:20 PM, Coly Li wrote:
> When there are too many I/O errors on cache device, current bcache code
> will retire the whole cache set, and detach all bcache devices. But the
> detached bcache devices are not stopped, which is problematic when bcache
> is in writeback mode.
> 
> If the retired cache set has dirty data of backing devices, continue
> writing to bcache device will write to backing device directly. If the
> LBA of write request has a dirty version cached on cache device, next time
> when the cache device is re-registered and backing device re-attached to
> it again, the stale dirty data on cache device will be written to backing
> device, and overwrite latest directly written data. This situation causes
> a quite data corruption.
> 
> But we cannot simply stop all attached bcache devices when the cache set is
> broken or disconnected. For example, use bcache to accelerate performance
> of an email service. In such workload, if cache device is broken but no
> dirty data lost, keep the bcache device alive and permit email service
> continue to access user data might be a better solution for the cache
> device failure.
> 
> Nix <nix@esperi.org.uk> points out the issue and provides the above example
> to explain why it might be necessary to not stop bcache device for broken
> cache device. Pavel Goran <via-bcache@pvgoran.name> provides a brilliant
> suggestion to provide "always" and "auto" options to per-cached device
> sysfs file stop_when_cache_set_failed. If cache set is retiring and the
> backing device has no dirty data on cache, it should be safe to keep the
> bcache device alive. In this case, if stop_when_cache_set_failed is set to
> "auto", the device failure handling code will not stop this bcache device
> and permit application to access the backing device with a unattached
> bcache device.
> 
> Changelog:
> v2: change option values of stop_when_cache_set_failed from 1/0 to
>     "auto"/"always".
> v1: initial version, stop_when_cache_set_failed can be 0 (not stop) or 1
>     (always stop).
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Nix <nix@esperi.org.uk>
> Cc: Pavel Goran <via-bcache@pvgoran.name>
> Cc: Michael Lyle <mlyle@lyle.org>
> Cc: Junhui Tang <tang.junhui@zte.com.cn>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/bcache/bcache.h |  9 +++++
>  drivers/md/bcache/super.c  | 82 ++++++++++++++++++++++++++++++++++++++++------
>  drivers/md/bcache/sysfs.c  | 17 ++++++++++
>  3 files changed, 98 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 7917b3820dd5..263164490833 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -287,6 +287,12 @@ struct io {
>  	sector_t		last;
>  };
>  
> +enum stop_on_faliure {
> +	BCH_CACHED_DEV_STOP_ATUO = 0,
> +	BCH_CACHED_DEV_STOP_ALWAYS,
> +	BCH_CACHED_DEV_STOP_MODE_MAX,
> +};
> +
>  struct cached_dev {
>  	struct list_head	list;
>  	struct bcache_device	disk;
> @@ -379,6 +385,8 @@ struct cached_dev {
>  	unsigned		writeback_rate_i_term_inverse;
>  	unsigned		writeback_rate_p_term_inverse;
>  	unsigned		writeback_rate_minimum;
> +
> +	enum stop_on_faliure	stop_when_cache_set_failed;
>  };
>  
>  enum alloc_reserve {
> @@ -924,6 +932,7 @@ void bch_write_bdev_super(struct cached_dev *, struct closure *);
>  
>  extern struct workqueue_struct *bcache_wq;
>  extern const char * const bch_cache_modes[];
> +extern const char * const bch_stop_on_failure_modes[];
>  extern struct mutex bch_register_lock;
>  extern struct list_head bch_cache_sets;
>  
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f8b0d1196c12..e335433bdfb7 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -47,6 +47,14 @@ const char * const bch_cache_modes[] = {
>  	NULL
>  };
>  
> +/* Default is -1; we skip past it for stop_when_cache_set_failed */
> +const char * const bch_stop_on_failure_modes[] = {
> +	"default",
> +	"auto",
> +	"always",
> +	NULL
> +};
> +
>  static struct kobject *bcache_kobj;
>  struct mutex bch_register_lock;
>  LIST_HEAD(bch_cache_sets);
> @@ -1187,6 +1195,9 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
>  		max(dc->disk.disk->queue->backing_dev_info->ra_pages,
>  		    q->backing_dev_info->ra_pages);
>  
> +	/* default to auto */
> +	dc->stop_when_cache_set_failed = BCH_CACHED_DEV_STOP_ATUO;
> +
>  	bch_cached_dev_request_init(dc);
>  	bch_cached_dev_writeback_init(dc);
>  	return 0;
> @@ -1463,25 +1474,76 @@ static void cache_set_flush(struct closure *cl)
>  	closure_return(cl);
>  }
>  
> +/*
> + * This function is only called when CACHE_SET_IO_DISABLE is set, which means
> + * cache set is unregistering due to too many I/O errors. In this condition,
> + * the bcache device might be stopped, it depends on stop_when_cache_set_failed
> + * value and whether the broken cache has dirty data:
> + *
> + * dc->stop_when_cache_set_failed    dc->has_dirty   stop bcache device
> + *  BCH_CACHED_STOP_ATUO               0               NO
> + *  BCH_CACHED_STOP_ATUO               1               YES
> + *  BCH_CACHED_DEV_STOP_ALWAYS         0               YES
> + *  BCH_CACHED_DEV_STOP_ALWAYS         1               YES
> + *
> + * The expected behavior is, if stop_when_cache_set_failed is configured to
> + * "auto" via sysfs interface, the bcache device will not be stopped if the
> + * backing device is clean on the broken cache device.
> + */
> +static void conditional_stop_bcache_device(struct cache_set *c,
> +					   struct bcache_device *d,
> +					   struct cached_dev *dc)
> +{
> +	if (dc->stop_when_cache_set_failed == BCH_CACHED_DEV_STOP_ALWAYS) {
> +		pr_warn("stop_when_cache_set_failed of %s is \"always\", stop"
> +			" it for failed cache set %pU.",
> +			d->disk->disk_name, c->sb.set_uuid);
> +		bcache_device_stop(d);
> +	} else if (atomic_read(&dc->has_dirty)) {
> +		/*
> +		 * dc->stop_when_cache_set_failed == BCH_CACHED_STOP_ATUO
> +		 * and dc->has_dirty == 1
> +		 */
> +		pr_warn("stop_when_cache_set_failed of %s is \"auto\" and "
> +			"cache is dirty, stop it to avoid potential data "
> +			"corruption.",
> +			d->disk->disk_name);
> +			bcache_device_stop(d);
> +	} else {
> +		/*
> +		 * dc->stop_when_cache_set_failed == BCH_CACHED_STOP_ATUO
> +		 * and dc->has_dirty == 0
> +		 */
> +		pr_warn("stop_when_cache_set_failed of %s is \"auto\" and "
> +			"cache is clean, keep it alive.",
> +			d->disk->disk_name);
> +	}
> +}
> +
>  static void __cache_set_unregister(struct closure *cl)
>  {
>  	struct cache_set *c = container_of(cl, struct cache_set, caching);
>  	struct cached_dev *dc;
> +	struct bcache_device *d;
>  	size_t i;
>  
>  	mutex_lock(&bch_register_lock);
>  
> -	for (i = 0; i < c->devices_max_used; i++)
> -		if (c->devices[i]) {
> -			if (!UUID_FLASH_ONLY(&c->uuids[i]) &&
> -			    test_bit(CACHE_SET_UNREGISTERING, &c->flags)) {
> -				dc = container_of(c->devices[i],
> -						  struct cached_dev, disk);
> -				bch_cached_dev_detach(dc);
> -			} else {
> -				bcache_device_stop(c->devices[i]);
> -			}
> +	for (i = 0; i < c->devices_max_used; i++) {
> +		d = c->devices[i];
> +		if (!d)
> +			continue;
> +
> +		if (!UUID_FLASH_ONLY(&c->uuids[i]) &&
> +		    test_bit(CACHE_SET_UNREGISTERING, &c->flags)) {
> +			dc = container_of(d, struct cached_dev, disk);
> +			bch_cached_dev_detach(dc);
> +			if (test_bit(CACHE_SET_IO_DISABLE, &c->flags))
> +				conditional_stop_bcache_device(c, d, dc);
> +		} else {
> +			bcache_device_stop(d);
>  		}
> +	}
>  
>  	mutex_unlock(&bch_register_lock);
>  
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index cf973c07c856..91d859a54575 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -78,6 +78,7 @@ rw_attribute(congested_write_threshold_us);
>  rw_attribute(sequential_cutoff);
>  rw_attribute(data_csum);
>  rw_attribute(cache_mode);
> +rw_attribute(stop_when_cache_set_failed);
>  rw_attribute(writeback_metadata);
>  rw_attribute(writeback_running);
>  rw_attribute(writeback_percent);
> @@ -126,6 +127,12 @@ SHOW(__bch_cached_dev)
>  					       bch_cache_modes + 1,
>  					       BDEV_CACHE_MODE(&dc->sb));
>  
> +	if (attr == &sysfs_stop_when_cache_set_failed)
> +		return bch_snprint_string_list(buf, PAGE_SIZE,
> +					       bch_stop_on_failure_modes + 1,
> +					       dc->stop_when_cache_set_failed);
> +
> +
>  	sysfs_printf(data_csum,		"%i", dc->disk.data_csum);
>  	var_printf(verify,		"%i");
>  	var_printf(bypass_torture_test,	"%i");
> @@ -247,6 +254,15 @@ STORE(__cached_dev)
>  		}
>  	}
>  
> +	if (attr == &sysfs_stop_when_cache_set_failed) {
> +		v = bch_read_string_list(buf, bch_stop_on_failure_modes + 1);
> +
> +		if (v < 0)
> +			return v;
> +
> +		dc->stop_when_cache_set_failed = v;
> +	}
> +
>  	if (attr == &sysfs_label) {
>  		if (size > SB_LABEL_SIZE)
>  			return -EINVAL;
> @@ -323,6 +339,7 @@ static struct attribute *bch_cached_dev_files[] = {
>  	&sysfs_data_csum,
>  #endif
>  	&sysfs_cache_mode,
> +	&sysfs_stop_when_cache_set_failed,
>  	&sysfs_writeback_metadata,
>  	&sysfs_writeback_running,
>  	&sysfs_writeback_delay,
> 
I
