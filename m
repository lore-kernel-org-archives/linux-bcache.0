From: tang.junhui@zte.com.cn
Subject: [PATCH] [PATCH v4] bcache: fix issue of writeback rate at minimum 1 key per second
Date: Fri, 23 Jun 2017 14:23:35 +0800
Message-ID: <1498199015-5652-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:42660 "EHLO out1.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754282AbdFWGZs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 23 Jun 2017 02:25:48 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

When there is not enough dirty data in writeback cache,
writeback rate is at minimum 1 key per second
util all dirty data to be cleaned, it is inefficiency,
and also causes waste of energy;

in this patch, When there is not enough dirty data,
let the writeback rate to be 0, and writeback re-schedule
in bch_writeback_thread() periodically with schedule_timeout(),
the behaviors are as follows :

1) If no dirty data have been read into dc->writeback_keys,
goto step 2), otherwise keep writing these dirty data to
back-end device at 1 key per second, until all these dirty data
write over, then goto step 2).

2) Loop in bch_writeback_thread() to check if there is enough
dirty data for writeback. if there is not enough diry data for
writing, then sleep 10 seconds, otherwise, write dirty data to
back-end device.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/util.c      |  9 ++++++++-
 drivers/md/bcache/writeback.c | 11 +++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index dde6172..d398f09 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -209,7 +209,14 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
 {
 	uint64_t now = local_clock();
 
-	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
+	/* 
+	  if d->rate is zero, write the left dirty data
+	  at the speed of one key per second 
+	*/
+	if(!d->rate)
+		d->next = now + NSEC_PER_SEC;
+	else
+		d->next += div_u64(done * NSEC_PER_SEC, d->rate);
 
 	if (time_before64(now + NSEC_PER_SEC, d->next))
 		d->next = now + NSEC_PER_SEC;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 69e1ae5..7313643 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -15,6 +15,8 @@
 #include <linux/kthread.h>
 #include <trace/events/bcache.h>
 
+#define WRITE_BACK_WAIT_CYCLE		10 * HZ
+
 /* Rate limiting */
 
 static void __update_writeback_rate(struct cached_dev *dc)
@@ -54,13 +56,14 @@ static void __update_writeback_rate(struct cached_dev *dc)
 
 	/* Don't increase writeback rate if the device isn't keeping up */
 	if (change > 0 &&
+	    dc->writeback_rate.rate >0 &&
 	    time_after64(local_clock(),
 			 dc->writeback_rate.next + NSEC_PER_MSEC))
 		change = 0;
 
 	dc->writeback_rate.rate =
 		clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
-			1, NSEC_PER_MSEC);
+			0, NSEC_PER_MSEC);
 
 	dc->writeback_rate_proportional = proportional;
 	dc->writeback_rate_derivative = derivative;
@@ -419,15 +422,15 @@ static int bch_writeback_thread(void *arg)
 	while (!kthread_should_stop()) {
 		down_write(&dc->writeback_lock);
 		if (!atomic_read(&dc->has_dirty) ||
-		    (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
-		     !dc->writeback_running)) {
+		    ((!dc->writeback_rate.rate || !dc->writeback_running) &&
+		      !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))) {
 			up_write(&dc->writeback_lock);
 			set_current_state(TASK_INTERRUPTIBLE);
 
 			if (kthread_should_stop())
 				return 0;
 
-			schedule();
+			schedule_timeout(WRITE_BACK_WAIT_CYCLE);
 			continue;
 		}
 
-- 
2.8.1.windows.1
