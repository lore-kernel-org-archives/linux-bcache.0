From: Coly Li <colyli@suse.de>
Subject: [PATCH v1 04/10] bcache: fix cached_dev->count usage for bch_cache_set_error()
Date: Wed,  3 Jan 2018 22:03:19 +0800
Message-ID: <20180103140325.63175-5-colyli@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180103140325.63175-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

When bcache metadata I/O fails, bcache will call bch_cache_set_error()
to retire the whole cache set. The expected behavior to retire a cache
set is to unregister the cache set, and unregister all backing device
attached to this cache set, then remove sysfs entries of the cache set
and all attached backing devices, finally release memory of structs
cache_set, cache, cached_dev and bcache_device.

In my testing when journal I/O failure triggered by disconnected cache
device, sometimes the cache set cannot be retired, and its sysfs
entry /sys/fs/bcache/<uuid> still exits and the backing device also
references it. This is not expected behavior.

When metadata I/O failes, the call senquence to retire whole cache set is,
	bch_cache_set_error()
	bch_cache_set_unregister()
	bch_cache_set_stop()
	__cache_set_unregister()     <- called as callback by calling
					clousre_queue(&c->caching)
	cache_set_flush()            <- called as a callback when refcount
					of cache_set->caching is 0
	cache_set_free()             <- called as a callback when refcount
					of catch_set->cl is 0
	bch_cache_set_release()      <- called as a callback when refcount
					of catch_set->kobj is 0

I find if kernel thread bch_writeback_thread() quits while-loop when
kthread_should_stop() is true and searched_full_index is false, clousre
callback cache_set_flush() set by continue_at() will never be called. The
result is, bcache fails to retire whole cache set.

cache_set_flush() will be called when refcount of closure c->caching is 0,
and in function bcache_device_detach() refcount of closure c->caching is
released to 0 by clousre_put(). In metadata error code path, function
bcache_device_detach() is called by cached_dev_detach_finish(). This is a
callback routine being called when cached_dev->count is 0. This refcount
is decreased by cached_dev_put().

The above dependence indicates, cache_set_flush() will be called when
refcount of cache_set->cl is 0, and refcount of cache_set->cl to be 0
when refcount of cache_dev->count is 0.

The reason why sometimes cache_dev->count is not 0 (when metadata I/O fails
and bch_cache_set_error() called) is, in bch_writeback_thread(), refcount
of cache_dev is not decreased properly.

In bch_writeback_thread(), cached_dev_put() is called only when
searched_full_index is true and cached_dev->writeback_keys is empty, a.k.a
there is no dirty data on cache. In most of run time it is correct, but
when bch_writeback_thread() quits the while-loop while cache is still
dirty, current code forget to call cached_dev_put() before this kernel
thread exits. This is why sometimes cache_set_flush() is not executed and
cache set fails to be retired.

The reason to call cached_dev_put() in bch_writeback_rate() is, when the
cache device changes from clean to dirty, cached_dev_get() is called, to
make sure during writeback operatiions both backing and cache devices
won't be released.

Adding following code in bch_writeback_thread() does not work,
    static int bch_writeback_thread(void *arg)
    [code snip]

    +       if (atomic_read(&dc->has_dirty))
    +               cached_dev_put()
    +
        return 0;
    [code snip]

because writeback kernel thread can be waken up and start via sysfs entry:
	echo 1 > /sys/block/bcache<N>/bcache/writeback_running
It is difficult to check whether backing device is dirty without race and
extra lock. So the above modification will introduce potential refcount
underflow in some conditions.

The correct fix is, to take cached dev refcount when creating the kernel
thread, and put it before the kernel thread exits. Then bcache does not
need to take a cached dev refcount when cache turns from clean to dirty,
or to put a cached dev refcount when cache turns from ditry to clean. The
writeback kernel thread is alwasy safe to reference data structure from
cache set, cache and cached device (because a refcount of cache device is
taken for it already), and no matter the kernel thread is stopped by I/O
errors or system reboot, cached_dev->count can always be used correctly.

The patch is simple, but understanding how it works is quite complicated.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c     |  1 -
 drivers/md/bcache/writeback.c | 10 +++++++---
 drivers/md/bcache/writeback.h |  2 --
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 064efd869017..5401d2356aa3 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1044,7 +1044,6 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
 		bch_sectors_dirty_init(&dc->disk);
 		atomic_set(&dc->has_dirty, 1);
-		refcount_inc(&dc->count);
 		bch_writeback_queue(dc);
 	}
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index a57149803df6..0789a9e18337 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -451,7 +451,7 @@ static int bch_writeback_thread(void *arg)
 			up_write(&dc->writeback_lock);
 
 			if (kthread_should_stop())
-				return 0;
+				break;
 
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
@@ -463,7 +463,6 @@ static int bch_writeback_thread(void *arg)
 		if (searched_full_index &&
 		    RB_EMPTY_ROOT(&dc->writeback_keys.keys)) {
 			atomic_set(&dc->has_dirty, 0);
-			cached_dev_put(dc);
 			SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
 			bch_write_bdev_super(dc, NULL);
 		}
@@ -484,6 +483,8 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
+	cached_dev_put(dc);
+
 	return 0;
 }
 
@@ -547,10 +548,13 @@ int bch_cached_dev_writeback_start(struct cached_dev *dc)
 	if (!dc->writeback_write_wq)
 		return -ENOMEM;
 
+	cached_dev_get(dc);
 	dc->writeback_thread = kthread_create(bch_writeback_thread, dc,
 					      "bcache_writeback");
-	if (IS_ERR(dc->writeback_thread))
+	if (IS_ERR(dc->writeback_thread)) {
+		cached_dev_put(dc);
 		return PTR_ERR(dc->writeback_thread);
+	}
 
 	schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 1d284f3d0363..aab21afe49cf 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -92,8 +92,6 @@ static inline void bch_writeback_add(struct cached_dev *dc)
 {
 	if (!atomic_read(&dc->has_dirty) &&
 	    !atomic_xchg(&dc->has_dirty, 1)) {
-		refcount_inc(&dc->count);
-
 		if (BDEV_STATE(&dc->sb) != BDEV_STATE_DIRTY) {
 			SET_BDEV_STATE(&dc->sb, BDEV_STATE_DIRTY);
 			/* XXX: should do this synchronously */
-- 
2.15.1
