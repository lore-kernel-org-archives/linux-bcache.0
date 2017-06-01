From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: update bucket_in_use periodically
Date: Thu, 1 Jun 2017 19:49:16 +0800
Message-ID: <1496317756-10480-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:52476 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbdFALue (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Jun 2017 07:50:34 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

bucket_in_use is updated in gc thread which triggered by invalidating or
writing sectors_to_gc dirty data, It's been too long, Therefore, when we
use it to compare with the threshold, it is often not timely, which leads
to inaccurate judgment and often results in bucket depletion.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/btree.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index a43eedd..44a2563 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -87,6 +87,8 @@
 #define MAX_NEED_GC		64
 #define MAX_SAVE_PRIO		72
 
+#define GC_THREAD_TIMEOUT_MS	(30 * 1000)
+
 #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
 
 #define PTR_HASH(c, k)							\
@@ -1757,6 +1759,23 @@ static void bch_btree_gc(struct cache_set *c)
 	bch_moving_gc(c);
 }
 
+void bch_update_bucket_in_use(struct cache_set *c)
+{
+	struct cache *ca;
+	struct bucket *b;
+	unsigned i;
+	size_t available = 0;
+
+	for_each_cache(ca, c, i) {
+		for_each_bucket(b, ca) {
+			if (!GC_MARK(b) || GC_MARK(b) == GC_MARK_RECLAIMABLE)
+				available++;
+		}
+	}
+
+	c->gc_stats.in_use = (c->nbuckets - available) * 100 / c->nbuckets;
+}
+
 static bool gc_should_run(struct cache_set *c)
 {
 	struct cache *ca;
@@ -1775,10 +1794,16 @@ static bool gc_should_run(struct cache_set *c)
 static int bch_gc_thread(void *arg)
 {
 	struct cache_set *c = arg;
+	long  ret;
+	unsigned long timeout = msecs_to_jiffies(GC_THREAD_TIMEOUT_MS);
 
 	while (1) {
-		wait_event_interruptible(c->gc_wait,
-			   kthread_should_stop() || gc_should_run(c));
+		ret = wait_event_interruptible_timeout(c->gc_wait,
+			   kthread_should_stop() || gc_should_run(c), timeout);
+		if (!ret) {
+			bch_update_bucket_in_use(c);
+			continue;
+		}
 
 		if (kthread_should_stop())
 			break;
-- 
2.8.1.windows.1
