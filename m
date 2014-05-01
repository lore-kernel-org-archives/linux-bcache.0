From: Slava Pestov <sp@datera.io>
Subject: [PATCH] bcache: fix uninterruptible sleep in writeback thread
Date: Thu,  1 May 2014 14:52:30 -0700
Message-ID: <1398981150-27765-1-git-send-email-sp@daterainc.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42540 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaEAVwg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 1 May 2014 17:52:36 -0400
Received: by mail-pa0-f46.google.com with SMTP id kx10so1561279pab.33
        for <linux-bcache@vger.kernel.org>; Thu, 01 May 2014 14:52:35 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Slava Pestov <sp@daterainc.com>

There were two issues here:

- writeback thread did not start until the device first became dirty
- writeback thread used uninterruptible sleep once running

Without this patch I see kernel warnings printed and a load average of
1.52 after booting my test VM. With this patch the warnings are gone and
the load average is near 0.00 as expected.
---
 drivers/md/bcache/super.c     |  3 +++
 drivers/md/bcache/writeback.c | 13 +++++++++----
 drivers/md/bcache/writeback.h |  3 ++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 926ded8..3ebe829 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1041,6 +1041,9 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	 */
 	atomic_set(&dc->count, 1);
 
+	if (bch_cached_dev_writeback_start(dc))
+		return -ENOMEM;
+
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
 		bch_sectors_dirty_init(dc);
 		atomic_set(&dc->has_dirty, 1);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index f4300e4..08c1abb 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -239,7 +239,7 @@ static void read_dirty(struct cached_dev *dc)
 		if (KEY_START(&w->key) != dc->last_read ||
 		    jiffies_to_msecs(delay) > 50)
 			while (!kthread_should_stop() && delay)
-				delay = schedule_timeout_uninterruptible(delay);
+				delay = schedule_timeout_interruptible(delay);
 
 		dc->last_read	= KEY_OFFSET(&w->key);
 
@@ -436,7 +436,7 @@ static int bch_writeback_thread(void *arg)
 			while (delay &&
 			       !kthread_should_stop() &&
 			       !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
-				delay = schedule_timeout_uninterruptible(delay);
+				delay = schedule_timeout_interruptible(delay);
 		}
 	}
 
@@ -478,7 +478,7 @@ void bch_sectors_dirty_init(struct cached_dev *dc)
 	dc->disk.sectors_dirty_last = bcache_dev_sectors_dirty(&dc->disk);
 }
 
-int bch_cached_dev_writeback_init(struct cached_dev *dc)
+void bch_cached_dev_writeback_init(struct cached_dev *dc)
 {
 	sema_init(&dc->in_flight, 64);
 	init_rwsem(&dc->writeback_lock);
@@ -494,14 +494,19 @@ int bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate_d_term	= 30;
 	dc->writeback_rate_p_term_inverse = 6000;
 
+	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
+}
+
+int bch_cached_dev_writeback_start(struct cached_dev *dc)
+{
 	dc->writeback_thread = kthread_create(bch_writeback_thread, dc,
 					      "bcache_writeback");
 	if (IS_ERR(dc->writeback_thread))
 		return PTR_ERR(dc->writeback_thread);
 
-	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
 	schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
+	bch_writeback_queue(dc);
 
 	return 0;
 }
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index e2f8598..0a9dab1 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -85,6 +85,7 @@ static inline void bch_writeback_add(struct cached_dev *dc)
 void bcache_dev_sectors_dirty_add(struct cache_set *, unsigned, uint64_t, int);
 
 void bch_sectors_dirty_init(struct cached_dev *dc);
-int bch_cached_dev_writeback_init(struct cached_dev *);
+void bch_cached_dev_writeback_init(struct cached_dev *);
+int bch_cached_dev_writeback_start(struct cached_dev *);
 
 #endif
-- 
2.0.0.rc0
