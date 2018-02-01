From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: calculate the number of incremental GC nodes according to the total of btree nodes
Date: Thu, 1 Feb 2018 16:14:45 +0800
Message-ID: <1517472886-4240-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:52698 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbeBAIMW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Feb 2018 03:12:22 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

This patch base on "[PATCH] bcache: finish incremental GC".

Since incremental GC would stop 100ms when front side I/O comes, so when
there are many btree nodes, if GC only processes constant (100) nodes each
time, GC would last a long time, and the front I/Os would run out of the
buckets (since no new bucket can be allocated during GC), and I/Os be
blocked again.

So GC should not process constant nodes, but varied nodes according to the
number of btree nodes. In this patch, GC is divided into constant (100)
times, so when there are many btree nodes, GC can process more nodes each
time, otherwise GC will process less nodes each time (but not less than
MIN_GC_NODES).

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/btree.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 48a4d18..d8a5d31 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -90,10 +90,10 @@
 
 #define MAX_NEED_GC		64
 #define MAX_SAVE_PRIO		72
+#define MAX_GC_TIMES		100
 #define MIN_GC_NODES		100
 #define GC_SLEEP_TIME		100
 
-
 #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
 
 #define PTR_HASH(c, k)							\
@@ -1511,6 +1511,31 @@ static unsigned btree_gc_count_keys(struct btree *b)
 	return ret;
 }
 
+static size_t btree_gc_min_nodes(struct cache_set *c)
+{
+	size_t			min_nodes;
+
+	/*
+	 * Since incremental GC would stop 100ms when front
+	 * side I/O comes, so when there are many btree nodes,
+	 * if GC only processes constant (100) nodes each time,
+	 * GC would last a long time, and the front I/Os
+	 * would run out of the buckets (since no new bucket
+	 * can be allocated during GC), and be blocked again.
+	 * So GC should not process constant nodes, but varied
+	 * nodes according to the number of btree nodes, which
+	 * realized by dividing GC into constant(100) times,
+	 * so when there are many btree nodes, GC can process
+	 * more nodes each time, otherwise, GC will process less
+	 * nodes each time (but not less than MIN_GC_NODES)
+	 */
+	min_nodes = c->gc_stats.nodes / MAX_GC_TIMES;
+	if (min_nodes < MIN_GC_NODES)
+		min_nodes = MIN_GC_NODES;
+
+	return min_nodes;
+}
+
 static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 			    struct closure *writes, struct gc_stat *gc)
 {
@@ -1577,7 +1602,7 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 		r->b = NULL;
 
 		if (atomic_read(&b->c->io_inflight) &&
-		    gc->nodes >= gc->nodes_pre + MIN_GC_NODES) {
+		    gc->nodes >= gc->nodes_pre + btree_gc_min_nodes(b->c)) {
 			gc->nodes_pre =  gc->nodes;
 			ret = -EAGAIN;
 			break;
@@ -1835,8 +1860,14 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 		do {
 			k = bch_btree_iter_next_filter(&iter, &b->keys,
 						       bch_ptr_bad);
-			if (k)
+			if (k) {
 				btree_node_prefetch(b, k);
+				/*
+				 * initiallize c->gc_stats.nodes
+				 * for incremental GC
+				 */
+				b->c->gc_stats.nodes++;
+			}
 
 			if (p)
 				ret = btree(check_recurse, p, b, op);
-- 
1.8.3.1
