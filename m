From: Coly Li <colyli@suse.de>
Subject: [PATCH 1/3] bcache: ignore pending signals when creating gc and allocator thread
Date: Thu, 13 Feb 2020 22:12:05 +0800
Message-ID: <20200213141207.77219-2-colyli@suse.de>
References: <20200213141207.77219-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200213141207.77219-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

When run a cache set, all the bcache btree node of this cache set will
be checked by bch_btree_check(). If the bcache btree is very large,
iterating all the btree nodes will occupy too much system memory and
the bcache registering process might be selected and killed by system
OOM killer. kthread_run() will fail if current process has pending
signal, therefore the kthread creating in run_cache_set() for gc and
allocator kernel threads are very probably failed for a very large
bcache btree.

Indeed such OOM is safe and the registering process will exit after
the registration done. Therefore this patch flushes pending signals
during the cache set start up, specificly in bch_cache_allocator_start()
and bch_gc_thread_start(), to make sure run_cache_set() won't fail for
large cahced data set.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/alloc.c | 18 ++++++++++++++++--
 drivers/md/bcache/btree.c | 13 +++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index a1df0d95151c..8bc1faf71ff2 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -67,6 +67,7 @@
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/random.h>
+#include <linux/sched/signal.h>
 #include <trace/events/bcache.h>
 
 #define MAX_OPEN_BUCKETS 128
@@ -733,8 +734,21 @@ int bch_open_buckets_alloc(struct cache_set *c)
 
 int bch_cache_allocator_start(struct cache *ca)
 {
-	struct task_struct *k = kthread_run(bch_allocator_thread,
-					    ca, "bcache_allocator");
+	struct task_struct *k;
+
+	/*
+	 * In case previous btree check operation occupies too many
+	 * system memory for bcache btree node cache, and the
+	 * registering process is selected by OOM killer. Here just
+	 * ignore the SIGKILL sent by OOM killer if there is, to
+	 * avoid kthread_run() being failed by pending signals. The
+	 * bcache registering process will exit after the registration
+	 * done.
+	 */
+	if (signal_pending(current))
+		flush_signals(current);
+
+	k = kthread_run(bch_allocator_thread, ca, "bcache_allocator");
 	if (IS_ERR(k))
 		return PTR_ERR(k);
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 1e020bd7f5ac..4009023305a3 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -34,6 +34,7 @@
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/clock.h>
+#include <linux/sched/signal.h>
 #include <linux/rculist.h>
 #include <linux/delay.h>
 #include <trace/events/bcache.h>
@@ -1913,6 +1914,18 @@ static int bch_gc_thread(void *arg)
 
 int bch_gc_thread_start(struct cache_set *c)
 {
+	/*
+	 * In case previous btree check operation occupies too many
+	 * system memory for bcache btree node cache, and the
+	 * registering process is selected by OOM killer. Here just
+	 * ignore the SIGKILL sent by OOM killer if there is, to
+	 * avoid kthread_run() being failed by pending signals. The
+	 * bcache registering process will exit after the registration
+	 * done.
+	 */
+	if (signal_pending(current))
+		flush_signals(current);
+
 	c->gc_thread = kthread_run(bch_gc_thread, c, "bcache_gc");
 	return PTR_ERR_OR_ZERO(c->gc_thread);
 }
-- 
2.16.4
