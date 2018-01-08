From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 06/10] bcache: stop dc->writeback_rate_update,
 dc->writeback_thread earlier
Date: Mon, 8 Jan 2018 08:25:17 +0100
Message-ID: <a9b94a34-d74e-881b-4dfd-d0a007eb64f9@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-7-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180103140325.63175-7-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

On 01/03/2018 03:03 PM, Coly Li wrote:
> Delayed worker dc->writeback_rate_update and kernel thread
> dc->writeback_thread reference cache set data structure in their routine,
> Therefor, before they are stopped, cache set should not be release. Other-
> wise, NULL pointer deference will be triggered.
> 
> Currenly delayed worker dc->writeback_rate_update and kernel thread
> dc->writeback_thread are stopped in cached_dev_free(). When cache set is
> retiring by too many I/O errors, cached_dev_free() is called when refcount
> of bcache device's closure (disk.cl) reaches 0. In most of cases, last
> refcount of disk.cl is dropped in last line of cached_dev_detach_finish().
> But in cached_dev_detach_finish() before calling closure_put(&dc->disk.cl),
> bcache_device_detach() is called, and inside bcache_device_detach()
> refcount of cache_set->caching is dropped by closure_put(&d->c->caching).
> 
> It is very probably this is the last refcount of this closure, so routine
> cache_set_flush() will be called (it is set in __cache_set_unregister()),
> and its parent closure cache_set->cl may also drop its last refcount and
> cache_set_free() is called too. In cache_set_free() the last refcount of
> cache_set->kobj is dropped and then bch_cache_set_release() is called. Now
> in bch_cache_set_release(), the memory of struct cache_set is freeed.
> 
> bch_cache_set_release() is called before cached_dev_free(), then there is a
> time window after cache set memory freed and before dc->writeback_thread
> and dc->writeback_rate_update stopped, if one of them is scheduled to run,
> a NULL pointer deference will be triggered.
> 
> This patch fixes the above problem by stopping dc->writeback_thread and
> dc->writeback_rate_update earlier in bcache_device_detach() before calling
> closure_put(&d->c->caching). Because cancel_delayed_work_sync() and
> kthread_stop() are synchronized operations, we can make sure cache set
> is available when the delayed work and kthread are stopping.
> 
> Because cached_dev_free() can also be called by writing 1 to sysfs file
> /sys/block/bcache<N>/bcache/stop, this code path may not call
> bcache_device_detach() if d-c is NULL. So stopping dc->writeback_thread
> and dc->writeback_rate_update in cached_dev_free() is still necessary. In
> order to avoid stop them twice, dc->rate_update_canceled is added to
> indicate dc->writeback_rate_update is canceled, and dc->writeback_thread
> is set to NULL to indicate it is stopped.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/bcache.h    |  1 +
>  drivers/md/bcache/super.c     | 21 +++++++++++++++++++--
>  drivers/md/bcache/writeback.c |  1 +
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 83c569942bd0..395b87942a2f 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -322,6 +322,7 @@ struct cached_dev {
>  
>  	struct bch_ratelimit	writeback_rate;
>  	struct delayed_work	writeback_rate_update;
> +	bool			rate_update_canceled;
>  
>  	/*
>  	 * Internal to the writeback code, so read_dirty() can keep track of
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 5401d2356aa3..8912be4165c5 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -696,8 +696,20 @@ static void bcache_device_link(struct bcache_device *d, struct cache_set *c,
>  
>  static void bcache_device_detach(struct bcache_device *d)
>  {
> +	struct cached_dev *dc;
> +
>  	lockdep_assert_held(&bch_register_lock);
>  
> +	dc = container_of(d, struct cached_dev, disk);
> +	if (!IS_ERR_OR_NULL(dc->writeback_thread)) {
> +		kthread_stop(dc->writeback_thread);
> +		dc->writeback_thread = NULL;
> +	}
> +	if (!dc->rate_update_canceled) {
> +		cancel_delayed_work_sync(&dc->writeback_rate_update);
> +		dc->rate_update_canceled = true;
> +	}
> +
>  	if (test_bit(BCACHE_DEV_DETACHING, &d->flags)) {
>  		struct uuid_entry *u = d->c->uuids + d->id;
>  
> @@ -1071,9 +1083,14 @@ static void cached_dev_free(struct closure *cl)
>  {
>  	struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
>  
> -	cancel_delayed_work_sync(&dc->writeback_rate_update);
> -	if (!IS_ERR_OR_NULL(dc->writeback_thread))
> +	if (!dc->rate_update_canceled) {
> +		cancel_delayed_work_sync(&dc->writeback_rate_update);
> +		dc->rate_update_canceled = true;
> +	}
> +	if (!IS_ERR_OR_NULL(dc->writeback_thread)) {
>  		kthread_stop(dc->writeback_thread);
> +		dc->writeback_thread = NULL;
> +	}
>  	if (dc->writeback_write_wq)
>  		destroy_workqueue(dc->writeback_write_wq);
>  
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 745d9b2a326f..ab2ac3d72393 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -548,6 +548,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>  	dc->writeback_rate_i_term_inverse = 10000;
>  
>  	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
> +	dc->rate_update_canceled = false;
>  }
>  
>  int bch_cached_dev_writeback_start(struct cached_dev *dc)
> 
Hehe. Just as I said in the comment to the previous patch.
I would suggest merge this and the previous patch :-)

But in general, I don't think you need 'rate_update_canceled'.
cancel_delayed_work_sync() will be a no-op if no work item has been
scheduled.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
