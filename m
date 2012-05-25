From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 3/3] block: convert elevator to generic rb tree code
Date: Fri, 25 May 2012 13:57:41 -0700
Message-ID: <1337979461-19654-4-git-send-email-koverstreet@google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337979461-19654-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk, paul.gortmaker@windriver.com
List-Id: linux-bcache@vger.kernel.org

Change-Id: I676968e201f0de9a0d0a7813e2fcc6873343e8c3

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 block/elevator.c |   42 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index f016855..7429682 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -295,28 +295,21 @@ static struct request *elv_rqhash_find(struct request_queue *q, sector_t offset)
 	return NULL;
 }
 
+static int elv_rb_cmp(struct rb_node *l, struct rb_node *r)
+{
+	return clamp_t(int64_t,
+		       blk_rq_pos(rb_entry(l, struct request, rb_node)) -
+		       blk_rq_pos(rb_entry(r, struct request, rb_node)),
+		       -1, 1);
+}
+
 /*
  * RB-tree support functions for inserting/lookup/removal of requests
  * in a sorted RB tree.
  */
 void elv_rb_add(struct rb_root *root, struct request *rq)
 {
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct request *__rq;
-
-	while (*p) {
-		parent = *p;
-		__rq = rb_entry(parent, struct request, rb_node);
-
-		if (blk_rq_pos(rq) < blk_rq_pos(__rq))
-			p = &(*p)->rb_left;
-		else if (blk_rq_pos(rq) >= blk_rq_pos(__rq))
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&rq->rb_node, parent, p);
-	rb_insert_color(&rq->rb_node, root);
+	rb_insert_allow_dup(root, &rq->rb_node, elv_rb_cmp);
 }
 EXPORT_SYMBOL(elv_rb_add);
 
@@ -330,21 +323,10 @@ EXPORT_SYMBOL(elv_rb_del);
 
 struct request *elv_rb_find(struct rb_root *root, sector_t sector)
 {
-	struct rb_node *n = root->rb_node;
-	struct request *rq;
-
-	while (n) {
-		rq = rb_entry(n, struct request, rb_node);
+	struct request search = { .__sector = sector };
+	struct rb_node *r = _rb_search(root, &search.rb_node, elv_rb_cmp);
 
-		if (sector < blk_rq_pos(rq))
-			n = n->rb_left;
-		else if (sector > blk_rq_pos(rq))
-			n = n->rb_right;
-		else
-			return rq;
-	}
-
-	return NULL;
+	return container_of_or_null(r, struct request, rb_node);
 }
 EXPORT_SYMBOL(elv_rb_find);
 
-- 
1.7.9.3.327.g2980b
