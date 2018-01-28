From: Coly Li <colyli@suse.de>
Subject: [PATCH v4 04/13] bcache: quit dc->writeback_thread when BCACHE_DEV_DETACHING is set
Date: Sun, 28 Jan 2018 09:56:16 +0800
Message-ID: <20180128015625.128497-5-colyli@suse.de>
References: <20180128015625.128497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180128015625.128497-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>, Hannes Reinecke <hare@suse.com>, Huijun Tang <tang.junhui@zte.com.cn>
List-Id: linux-bcache@vger.kernel.org

In patch "bcache: fix cached_dev->count usage for bch_cache_set_error()",
cached_dev_get() is called when creating dc->writeback_thread, and
cached_dev_put() is called when exiting dc->writeback_thread. This
modification works well unless people detach the bcache device manually by
    'echo 1 > /sys/block/bcache<N>/bcache/detach'
Because this sysfs interface only calls bch_cached_dev_detach() which wakes
up dc->writeback_thread but does not stop it. The reason is, before patch
"bcache: fix cached_dev->count usage for bch_cache_set_error()", inside
bch_writeback_thread(), if cache is not dirty after writeback,
cached_dev_put() will be called here. And in cached_dev_make_request() when
a new write request makes cache from clean to dirty, cached_dev_get() will
be called there. Since we don't operate dc->count in these locations,
refcount d->count cannot be dropped after cache becomes clean, and
cached_dev_detach_finish() won't be called to detach bcache device.

This patch fixes the issue by checking whether BCACHE_DEV_DETACHING is
set inside bch_writeback_thread(). If this bit is set and cache is clean
(no existing writeback_keys), break the while-loop, call cached_dev_put()
and quit the writeback thread.

Please note if cache is still dirty, even BCACHE_DEV_DETACHING is set the
writeback thread should continue to perform writeback, this is the original
design of manually detach.

I compose a separte patch because that patch "bcache: fix cached_dev->count
usage for bch_cache_set_error()" already gets a "Reviewed-by:" from Hannes
Reinecke. Also this fix is not trivial and good for a separate patch.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Huijun Tang <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/writeback.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index b280c134dd4d..4dbeaaa575bf 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -565,9 +565,15 @@ static int bch_writeback_thread(void *arg)
 	while (!kthread_should_stop()) {
 		down_write(&dc->writeback_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (!atomic_read(&dc->has_dirty) ||
-		    (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
-		     !dc->writeback_running)) {
+		/*
+		 * If the bache device is detaching, skip here and continue
+		 * to perform writeback. Otherwise, if no dirty data on cache,
+		 * or there is dirty data on cache but writeback is disabled,
+		 * the writeback thread should sleep here and wait for others
+		 * to wake up it.
+		 */
+		if (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
+		    (!atomic_read(&dc->has_dirty) || !dc->writeback_running)) {
 			up_write(&dc->writeback_lock);
 
 			if (kthread_should_stop()) {
@@ -587,6 +593,14 @@ static int bch_writeback_thread(void *arg)
 			atomic_set(&dc->has_dirty, 0);
 			SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
 			bch_write_bdev_super(dc, NULL);
+			/*
+			 * If bcache device is detaching via sysfs interface,
+			 * writeback thread should stop after there is no dirty
+			 * data on cache. BCACHE_DEV_DETACHING flag is set in
+			 * bch_cached_dev_detach().
+			 */
+			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
+				break;
 		}
 
 		up_write(&dc->writeback_lock);
-- 
2.15.1
