From: colyli@suse.de
Subject: [PATCH 15/17] bcache: remove member accessed from struct btree
Date: Fri, 24 Jan 2020 01:01:40 +0800
Message-ID: <20200123170142.98974-16-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

The member 'accessed' of struct btree is used in bch_mca_scan() when
shrinking btree node caches. The original idea is, if b->accessed is
set, clean it and look at next btree node cache from c->btree_cache
list, and only shrink the caches whose b->accessed is cleaned. Then
only cold btree node cache will be shrunk.

But when I/O pressure is high, it is very probably that b->accessed
of a btree node cache will be set again in bch_btree_node_get()
before bch_mca_scan() selects it again. Then there is no chance for
bch_mca_scan() to shrink enough memory back to slub or slab system.

This patch removes member accessed from struct btree, then once a
btree node ache is selected, it will be immediately shunk. By this
change, bch_mca_scan() may release btree node cahce more efficiently.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 8 ++------
 drivers/md/bcache/btree.h | 2 --
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 14d6c33b0957..357535a5c89c 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -754,14 +754,12 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 		b = list_first_entry(&c->btree_cache, struct btree, list);
 		list_rotate_left(&c->btree_cache);
 
-		if (!b->accessed &&
-		    !mca_reap(b, 0, false)) {
+		if (!mca_reap(b, 0, false)) {
 			mca_bucket_free(b);
 			mca_data_free(b);
 			rw_unlock(true, b);
 			freed++;
-		} else
-			b->accessed = 0;
+		}
 	}
 out:
 	mutex_unlock(&c->bucket_lock);
@@ -1069,7 +1067,6 @@ struct btree *bch_btree_node_get(struct cache_set *c, struct btree_op *op,
 	BUG_ON(!b->written);
 
 	b->parent = parent;
-	b->accessed = 1;
 
 	for (; i <= b->keys.nsets && b->keys.set[i].size; i++) {
 		prefetch(b->keys.set[i].tree);
@@ -1160,7 +1157,6 @@ struct btree *__bch_btree_node_alloc(struct cache_set *c, struct btree_op *op,
 		goto retry;
 	}
 
-	b->accessed = 1;
 	b->parent = parent;
 	bch_bset_init_next(&b->keys, b->keys.set->data, bset_magic(&b->c->sb));
 
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 76cfd121a486..f4dcca449391 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -121,8 +121,6 @@ struct btree {
 	/* Key/pointer for this btree node */
 	BKEY_PADDED(key);
 
-	/* Single bit - set when accessed, cleared by shrinker */
-	unsigned long		accessed;
 	unsigned long		seq;
 	struct rw_semaphore	lock;
 	struct cache_set	*c;
-- 
2.16.4
