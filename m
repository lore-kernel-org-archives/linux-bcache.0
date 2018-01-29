From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: finish incremental GC
Date: Mon, 29 Jan 2018 19:58:13 +0800
Message-ID: <1517227093-25602-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

In GC thread, we record the latest GC key in gc_done, which is expected
to be used for incremental GC, but in currently code, we didn't realize
it. When GC runs, front side IO would be blocked until the GC over, it
would be a long time if there is a lot of btree nodes.

This patch realizes incremental GC, the main ideal is that, when there
are front side I/Os, after GC some nodes (100), we stop GC, release locker
of the btree node, and go to process the front side I/Os for some times
(100 ms), then go back to GC again.

By this patch, when we doing GC, I/Os are not blocked all the time, and
there is no obvious I/Os zero jump problem any more.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/bcache.h  |  5 +++++
 drivers/md/bcache/btree.c   | 15 ++++++++++++++-
 drivers/md/bcache/request.c |  3 +++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index abd31e8..c047aff 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -445,6 +445,7 @@ struct cache {
 
 struct gc_stat {
 	size_t			nodes;
+	size_t			nodes_pre;
 	size_t			key_bytes;
 
 	size_t			nkeys;
@@ -568,6 +569,10 @@ struct cache_set {
 	 */
 	atomic_t		rescale;
 	/*
+	 * used for GC, identify if any front side I/Os is inflight
+	 */
+	atomic_t		io_inflight;
+	/*
 	 * When we invalidate buckets, we use both the priority and the amount
 	 * of good data to determine which buckets to reuse first - to weight
 	 * those together consistently we keep track of the smallest nonzero
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 658c54b..48a4d18 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -90,6 +90,9 @@
 
 #define MAX_NEED_GC		64
 #define MAX_SAVE_PRIO		72
+#define MIN_GC_NODES		100
+#define GC_SLEEP_TIME		100
+
 
 #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
 
@@ -1573,6 +1576,13 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 		memmove(r + 1, r, sizeof(r[0]) * (GC_MERGE_NODES - 1));
 		r->b = NULL;
 
+		if (atomic_read(&b->c->io_inflight) &&
+		    gc->nodes >= gc->nodes_pre + MIN_GC_NODES) {
+			gc->nodes_pre =  gc->nodes;
+			ret = -EAGAIN;
+			break;
+		}
+
 		if (need_resched()) {
 			ret = -EAGAIN;
 			break;
@@ -1742,7 +1752,10 @@ static void bch_btree_gc(struct cache_set *c)
 		closure_sync(&writes);
 		cond_resched();
 
-		if (ret && ret != -EAGAIN)
+		if (ret == -EAGAIN)
+			schedule_timeout_interruptible(msecs_to_jiffies
+						       (GC_SLEEP_TIME));
+		else if (ret)
 			pr_warn("gc failed!");
 	} while (ret);
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3475d66..a8b1226 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -628,7 +628,9 @@ static void do_bio_hook(struct search *s, struct bio *orig_bio)
 static void search_free(struct closure *cl)
 {
 	struct search *s = container_of(cl, struct search, cl);
+
 	bio_complete(s);
+	atomic_dec(&s->d->c->io_inflight);
 
 	if (s->iop.bio)
 		bio_put(s->iop.bio);
@@ -646,6 +648,7 @@ static inline struct search *search_alloc(struct bio *bio,
 
 	closure_init(&s->cl, NULL);
 	do_bio_hook(s, bio);
+	atomic_inc(&d->c->io_inflight);
 
 	s->orig_bio		= bio;
 	s->cache_miss		= NULL;
-- 
1.8.3.1
