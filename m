From: bcache@lists.ewheeler.net
Subject: [PATCH 12/19] bcache: update bucket_in_use periodically
Date: Fri, 30 Jun 2017 13:43:01 -0700
Message-ID: <1498855388-16990-12-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>
List-Id: linux-bcache@vger.kernel.org

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
index 866dcf7..77aa20b 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -90,6 +90,8 @@
 #define MAX_NEED_GC		64
 #define MAX_SAVE_PRIO		72
 
+#define GC_THREAD_TIMEOUT_MS	(30 * 1000)
+
 #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
 
 #define PTR_HASH(c, k)							\
@@ -1760,6 +1762,23 @@ static void bch_btree_gc(struct cache_set *c)
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
@@ -1778,10 +1797,16 @@ static bool gc_should_run(struct cache_set *c)
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
1.8.3.1
