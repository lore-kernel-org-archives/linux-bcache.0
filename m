From: bcache@lists.ewheeler.net
Subject: [PATCH 15/19] bcache: fix issue of writeback rate at minimum 1 key per second
Date: Fri, 30 Jun 2017 13:43:04 -0700
Message-ID: <1498855388-16990-15-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>
List-Id: linux-bcache@vger.kernel.org

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
index 8c3a938..49dcf09 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -210,7 +210,14 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
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
index 25289e4..4104eaa 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -16,6 +16,8 @@
 #include <linux/sched/clock.h>
 #include <trace/events/bcache.h>
 
+#define WRITE_BACK_WAIT_CYCLE		10 * HZ
+
 /* Rate limiting */
 
 static void __update_writeback_rate(struct cached_dev *dc)
@@ -55,13 +57,14 @@ static void __update_writeback_rate(struct cached_dev *dc)
 
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
@@ -420,15 +423,15 @@ static int bch_writeback_thread(void *arg)
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
1.8.3.1
