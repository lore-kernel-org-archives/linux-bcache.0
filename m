From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v1 06/10] bcache: stop dc->writeback_rate_update, dc->writeback_thread earlier
Date: Thu, 4 Jan 2018 01:27:13 +0800
Message-ID: <1515000433-6039-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:59252 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750770AbeADHAm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Jan 2018 02:00:42 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Coly,
Thanks for your works!

Acctually stopping write-back thread and writeback_rate_update work in 
bcache_device_detach() has already done in:
https://github.com/mlyle/linux/commit/397d02e162b8ee11940a4e9f45e16fee0650d64e

Is it nessary to add "rate_update_canceled" to identify that
whether writeback_rate_update work are already stoped or not? 
I think it is ok to call cancel_delayed_work_sync(&dc->writeback_rate_update)
twice before the memory of writeback_rate_update being released (It will return
-ENOENT).

>Delayed worker dc->writeback_rate_update and kernel thread
>dc->writeback_thread reference cache set data structure in their routine,
>Therefor, before they are stopped, cache set should not be release. Other-
>wise, NULL pointer deference will be triggered.
>
>Currenly delayed worker dc->writeback_rate_update and kernel thread
>dc->writeback_thread are stopped in cached_dev_free(). When cache set is
>retiring by too many I/O errors, cached_dev_free() is called when refcount
>of bcache device's closure (disk.cl) reaches 0. In most of cases, last
>refcount of disk.cl is dropped in last line of cached_dev_detach_finish().
>But in cached_dev_detach_finish() before calling closure_put(&dc->disk.cl),
>bcache_device_detach() is called, and inside bcache_device_detach()
>refcount of cache_set->caching is dropped by closure_put(&d->c->caching).
>
>It is very probably this is the last refcount of this closure, so routine
>cache_set_flush() will be called (it is set in __cache_set_unregister()),
>and its parent closure cache_set->cl may also drop its last refcount and
>cache_set_free() is called too. In cache_set_free() the last refcount of
>cache_set->kobj is dropped and then bch_cache_set_release() is called. Now
>in bch_cache_set_release(), the memory of struct cache_set is freeed.
>
>bch_cache_set_release() is called before cached_dev_free(), then there is a
>time window after cache set memory freed and before dc->writeback_thread
>and dc->writeback_rate_update stopped, if one of them is scheduled to run,
>a NULL pointer deference will be triggered.
>
>This patch fixes the above problem by stopping dc->writeback_thread and
>dc->writeback_rate_update earlier in bcache_device_detach() before calling
>closure_put(&d->c->caching). Because cancel_delayed_work_sync() and
>kthread_stop() are synchronized operations, we can make sure cache set
>is available when the delayed work and kthread are stopping.
>
>Because cached_dev_free() can also be called by writing 1 to sysfs file
>/sys/block/bcache<N>/bcache/stop, this code path may not call
>bcache_device_detach() if d-c is NULL. So stopping dc->writeback_thread
>and dc->writeback_rate_update in cached_dev_free() is still necessary. In
>order to avoid stop them twice, dc->rate_update_canceled is added to
>indicate dc->writeback_rate_update is canceled, and dc->writeback_thread
>is set to NULL to indicate it is stopped.
>
>Signed-off-by: Coly Li <colyli@suse.de>
>---
> drivers/md/bcache/bcache.h    |  1 +
> drivers/md/bcache/super.c     | 21 +++++++++++++++++++--
> drivers/md/bcache/writeback.c |  1 +
> 3 files changed, 21 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>index 83c569942bd0..395b87942a2f 100644
>--- a/drivers/md/bcache/bcache.h
>+++ b/drivers/md/bcache/bcache.h
>@@ -322,6 +322,7 @@ struct cached_dev {
> 
>     struct bch_ratelimit    writeback_rate;
>     struct delayed_work    writeback_rate_update;
>+    bool            rate_update_canceled;
> 
>     /*
>      * Internal to the writeback code, so read_dirty() can keep track of
>diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>index 5401d2356aa3..8912be4165c5 100644
>--- a/drivers/md/bcache/super.c
>+++ b/drivers/md/bcache/super.c
>@@ -696,8 +696,20 @@ static void bcache_device_link(struct bcache_device *d, struct cache_set *c,
> 
> static void bcache_device_detach(struct bcache_device *d)
> {
>+    struct cached_dev *dc;
>+
>     lockdep_assert_held(&bch_register_lock);
> 
>+    dc = container_of(d, struct cached_dev, disk);
>+    if (!IS_ERR_OR_NULL(dc->writeback_thread)) {
>+        kthread_stop(dc->writeback_thread);
>+        dc->writeback_thread = NULL;
>+    }
>+    if (!dc->rate_update_canceled) {
>+        cancel_delayed_work_sync(&dc->writeback_rate_update);
>+        dc->rate_update_canceled = true;
>+    }
>+
>     if (test_bit(BCACHE_DEV_DETACHING, &d->flags)) {
>         struct uuid_entry *u = d->c->uuids + d->id;
> 
>@@ -1071,9 +1083,14 @@ static void cached_dev_free(struct closure *cl)
> {
>     struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
> 
>-    cancel_delayed_work_sync(&dc->writeback_rate_update);
>-    if (!IS_ERR_OR_NULL(dc->writeback_thread))
>+    if (!dc->rate_update_canceled) {
>+        cancel_delayed_work_sync(&dc->writeback_rate_update);
>+        dc->rate_update_canceled = true;
>+    }
>+    if (!IS_ERR_OR_NULL(dc->writeback_thread)) {
>         kthread_stop(dc->writeback_thread);
>+        dc->writeback_thread = NULL;
>+    }
>     if (dc->writeback_write_wq)
>         destroy_workqueue(dc->writeback_write_wq);
> 
>diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>index 745d9b2a326f..ab2ac3d72393 100644
>--- a/drivers/md/bcache/writeback.c
>+++ b/drivers/md/bcache/writeback.c
>@@ -548,6 +548,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>     dc->writeback_rate_i_term_inverse = 10000;
> 
>     INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
>+    dc->rate_update_canceled = false;
> }
 

Thanks,
Tang Junhui
