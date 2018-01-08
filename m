From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 04/10] bcache: fix cached_dev->count usage for
 bch_cache_set_error()
Date: Mon, 8 Jan 2018 08:16:24 +0100
Message-ID: <b071298a-7912-f067-8b0f-54d825e2804c@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-5-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755079AbeAHHQ0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jan 2018 02:16:26 -0500
In-Reply-To: <20180103140325.63175-5-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn

On 01/03/2018 03:03 PM, Coly Li wrote:
> When bcache metadata I/O fails, bcache will call bch_cache_set_error()
> to retire the whole cache set. The expected behavior to retire a cache
> set is to unregister the cache set, and unregister all backing device
> attached to this cache set, then remove sysfs entries of the cache set
> and all attached backing devices, finally release memory of structs
> cache_set, cache, cached_dev and bcache_device.
> 
> In my testing when journal I/O failure triggered by disconnected cache
> device, sometimes the cache set cannot be retired, and its sysfs
> entry /sys/fs/bcache/<uuid> still exits and the backing device also
> references it. This is not expected behavior.
> 
> When metadata I/O failes, the call senquence to retire whole cache set is,
> 	bch_cache_set_error()
> 	bch_cache_set_unregister()
> 	bch_cache_set_stop()
> 	__cache_set_unregister()     <- called as callback by calling
> 					clousre_queue(&c->caching)
> 	cache_set_flush()            <- called as a callback when refcount
> 					of cache_set->caching is 0
> 	cache_set_free()             <- called as a callback when refcount
> 					of catch_set->cl is 0
> 	bch_cache_set_release()      <- called as a callback when refcount
> 					of catch_set->kobj is 0
> 
> I find if kernel thread bch_writeback_thread() quits while-loop when
> kthread_should_stop() is true and searched_full_index is false, clousre
> callback cache_set_flush() set by continue_at() will never be called. The
> result is, bcache fails to retire whole cache set.
> 
> cache_set_flush() will be called when refcount of closure c->caching is 0,
> and in function bcache_device_detach() refcount of closure c->caching is
> released to 0 by clousre_put(). In metadata error code path, function
> bcache_device_detach() is called by cached_dev_detach_finish(). This is a
> callback routine being called when cached_dev->count is 0. This refcount
> is decreased by cached_dev_put().
> 
> The above dependence indicates, cache_set_flush() will be called when
> refcount of cache_set->cl is 0, and refcount of cache_set->cl to be 0
> when refcount of cache_dev->count is 0.
> 
> The reason why sometimes cache_dev->count is not 0 (when metadata I/O fails
> and bch_cache_set_error() called) is, in bch_writeback_thread(), refcount
> of cache_dev is not decreased properly.
> 
> In bch_writeback_thread(), cached_dev_put() is called only when
> searched_full_index is true and cached_dev->writeback_keys is empty, a.k.a
> there is no dirty data on cache. In most of run time it is correct, but
> when bch_writeback_thread() quits the while-loop while cache is still
> dirty, current code forget to call cached_dev_put() before this kernel
> thread exits. This is why sometimes cache_set_flush() is not executed and
> cache set fails to be retired.
> 
> The reason to call cached_dev_put() in bch_writeback_rate() is, when the
> cache device changes from clean to dirty, cached_dev_get() is called, to
> make sure during writeback operatiions both backing and cache devices
> won't be released.
> 
> Adding following code in bch_writeback_thread() does not work,
>     static int bch_writeback_thread(void *arg)
>     [code snip]
> 
>     +       if (atomic_read(&dc->has_dirty))
>     +               cached_dev_put()
>     +
>         return 0;
>     [code snip]
> 
> because writeback kernel thread can be waken up and start via sysfs entry:
> 	echo 1 > /sys/block/bcache<N>/bcache/writeback_running
> It is difficult to check whether backing device is dirty without race and
> extra lock. So the above modification will introduce potential refcount
> underflow in some conditions.
> 
> The correct fix is, to take cached dev refcount when creating the kernel
> thread, and put it before the kernel thread exits. Then bcache does not
> need to take a cached dev refcount when cache turns from clean to dirty,
> or to put a cached dev refcount when cache turns from ditry to clean. The
> writeback kernel thread is alwasy safe to reference data structure from
> cache set, cache and cached device (because a refcount of cache device is
> taken for it already), and no matter the kernel thread is stopped by I/O
> errors or system reboot, cached_dev->count can always be used correctly.
> 
> The patch is simple, but understanding how it works is quite complicated.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c     |  1 -
>  drivers/md/bcache/writeback.c | 10 +++++++---
>  drivers/md/bcache/writeback.h |  2 --
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
Personally, I'm not a big fan to remove an entire device on error.
How is one supposed to do error recovery here?
Or (gasp) even error _debugging_?
All relevant structures have been removed...

But again, hardly the fault of this patch, and should be fixed in a
later patchset.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
