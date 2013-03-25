From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] bcache: Style/checkpatch fixes
Date: Mon, 25 Mar 2013 11:46:44 -0700
Message-ID: <1364237204-5467-2-git-send-email-koverstreet@google.com>
References: <20130325135252.GC5401@kernel.dk>
 <1364237204-5467-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364237204-5467-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Took out some nested functions, and fixed some more checkpatch
complaints.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/md/bcache/alloc.c    | 22 ++++++----------------
 drivers/md/bcache/bcache.h   | 10 +++++-----
 drivers/md/bcache/bset.c     |  9 +++++----
 drivers/md/bcache/btree.c    |  4 ++--
 drivers/md/bcache/debug.c    |  8 ++++----
 drivers/md/bcache/journal.c  |  8 ++++----
 drivers/md/bcache/movinggc.c | 24 ++++++++++++------------
 drivers/md/bcache/request.c  | 12 +++++++-----
 drivers/md/bcache/stats.c    |  3 ++-
 drivers/md/bcache/super.c    |  7 ++++---
 10 files changed, 51 insertions(+), 56 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index ed18115..2879487 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -229,24 +229,14 @@ static void invalidate_one_bucket(struct cache *ca, struct bucket *b)
 	fifo_push(&ca->free_inc, b - ca->buckets);
 }
 
-static void invalidate_buckets_lru(struct cache *ca)
-{
-	unsigned bucket_prio(struct bucket *b)
-	{
-		return ((unsigned) (b->prio - ca->set->min_prio)) *
-			GC_SECTORS_USED(b);
-	}
-
-	bool bucket_max_cmp(struct bucket *l, struct bucket *r)
-	{
-		return bucket_prio(l) < bucket_prio(r);
-	}
+#define bucket_prio(b)				\
+	(((unsigned) (b->prio - ca->set->min_prio)) * GC_SECTORS_USED(b))
 
-	bool bucket_min_cmp(struct bucket *l, struct bucket *r)
-	{
-		return bucket_prio(l) > bucket_prio(r);
-	}
+#define bucket_max_cmp(l, r)	(bucket_prio(l) < bucket_prio(r))
+#define bucket_min_cmp(l, r)	(bucket_prio(l) > bucket_prio(r))
 
+static void invalidate_buckets_lru(struct cache *ca)
+{
 	struct bucket *b;
 	ssize_t i;
 
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index d01a553..b2846e7 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -644,8 +644,8 @@ struct gc_stat {
  * we'll continue to run normally for awhile with CACHE_SET_STOPPING set (i.e.
  * flushing dirty data).
  *
- * CACHE_SET_STOPPING_2 gets set at the last phase, when it's time to shut down the
- * allocation thread.
+ * CACHE_SET_STOPPING_2 gets set at the last phase, when it's time to shut down
+ * the allocation thread.
  */
 #define CACHE_SET_UNREGISTERING		0
 #define	CACHE_SET_STOPPING		1
@@ -1012,11 +1012,11 @@ static inline struct bucket *PTR_BUCKET(struct cache_set *c,
  * searches - it told you where a key started. It's not used anymore,
  * and can probably be safely dropped.
  */
-#define KEY(dev, sector, len)	(struct bkey)				\
-{									\
+#define KEY(dev, sector, len)						\
+((struct bkey) {							\
 	.high = (1ULL << 63) | ((uint64_t) (len) << 20) | (dev),	\
 	.low = (sector)							\
-}
+})
 
 static inline void bkey_init(struct bkey *k)
 {
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 79fe1f0..4dc9cb4 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -161,9 +161,9 @@ bool bch_ptr_bad(struct btree *b, const struct bkey *k)
 #ifdef CONFIG_BCACHE_EDEBUG
 bug:
 	mutex_unlock(&b->c->bucket_lock);
-	btree_bug(b, "inconsistent pointer %s: bucket %zu pin %i "
-		  "prio %i gen %i last_gc %i mark %llu gc_gen %i", pkey(k),
-		  PTR_BUCKET_NR(b->c, k, i), atomic_read(&g->pin),
+	btree_bug(b,
+"inconsistent pointer %s: bucket %zu pin %i prio %i gen %i last_gc %i mark %llu gc_gen %i",
+		  pkey(k), PTR_BUCKET_NR(b->c, k, i), atomic_read(&g->pin),
 		  g->prio, g->gen, g->last_gc, GC_MARK(g), g->gc_gen);
 	return true;
 #endif
@@ -1049,7 +1049,8 @@ void bch_btree_sort_partial(struct btree *b, unsigned start)
 		for (i = start; i <= b->nsets; i++)
 			keys += b->sets[i].data->keys;
 
-		order = roundup_pow_of_two(__set_bytes(b->sets->data, keys)) / PAGE_SIZE;
+		order = roundup_pow_of_two(__set_bytes(b->sets->data,
+						       keys)) / PAGE_SIZE;
 		if (order)
 			order = ilog2(order);
 	}
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index af9ea4a..24b6780 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1021,8 +1021,8 @@ retry:
 		goto err_free;
 
 	if (!b) {
-		cache_bug(c, "Tried to allocate bucket"
-			  " that was in btree cache");
+		cache_bug(c,
+			"Tried to allocate bucket that was in btree cache");
 		__bkey_put(c, &k.key);
 		goto retry;
 	}
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 4b37ef2..141a5ca 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -217,8 +217,8 @@ void bch_data_verify(struct search *s)
 		if (memcmp(p1 + bv->bv_offset,
 			   p2 + bv->bv_offset,
 			   bv->bv_len))
-			printk(KERN_ERR "bcache (%s): verify failed"
-			       " at sector %llu\n",
+			printk(KERN_ERR
+			       "bcache (%s): verify failed at sector %llu\n",
 			       bdevname(dc->bdev, name),
 			       (uint64_t) s->orig_bio->bi_sector);
 
@@ -525,8 +525,8 @@ static ssize_t btree_fuzz(struct kobject *k, struct kobj_attribute *a,
 			     k = bkey_next(k), l = bkey_next(l))
 				if (bkey_cmp(k, l) ||
 				    KEY_SIZE(k) != KEY_SIZE(l))
-					pr_err("key %zi differs: %s "
-					       "!= %s", (uint64_t *) k - i->d,
+					pr_err("key %zi differs: %s != %s",
+					       (uint64_t *) k - i->d,
 					       pkey(k), pkey(l));
 
 			for (j = 0; j < 3; j++) {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index c871ffa..21fd101 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -293,9 +293,9 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list,
 		BUG_ON(i->pin && atomic_read(i->pin) != 1);
 
 		if (n != i->j.seq)
-			pr_err("journal entries %llu-%llu "
-			       "missing! (replaying %llu-%llu)\n",
-			       n, i->j.seq - 1, start, end);
+			pr_err(
+		"journal entries %llu-%llu missing! (replaying %llu-%llu)\n",
+		n, i->j.seq - 1, start, end);
 
 		for (k = i->j.start;
 		     k < end(&i->j);
@@ -439,7 +439,7 @@ static void do_journal_discard(struct cache *ca)
 
 		bio_init(bio);
 		bio->bi_sector		= bucket_to_sector(ca->set,
-							   ca->sb.d[ja->discard_idx]);
+						ca->sb.d[ja->discard_idx]);
 		bio->bi_bdev		= ca->bdev;
 		bio->bi_rw		= REQ_WRITE|REQ_DISCARD;
 		bio->bi_max_vecs	= 1;
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index c69fc92..e3ec0a5 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -183,6 +183,16 @@ err:		if (!IS_ERR_OR_NULL(w->private))
 	closure_return(cl);
 }
 
+static bool bucket_cmp(struct bucket *l, struct bucket *r)
+{
+	return GC_SECTORS_USED(l) < GC_SECTORS_USED(r);
+}
+
+static unsigned bucket_heap_top(struct cache *ca)
+{
+	return GC_SECTORS_USED(heap_peek(&ca->heap));
+}
+
 void bch_moving_gc(struct closure *cl)
 {
 	struct cache_set *c = container_of(cl, struct cache_set, gc.cl);
@@ -190,16 +200,6 @@ void bch_moving_gc(struct closure *cl)
 	struct bucket *b;
 	unsigned i;
 
-	bool bucket_cmp(struct bucket *l, struct bucket *r)
-	{
-		return GC_SECTORS_USED(l) < GC_SECTORS_USED(r);
-	}
-
-	unsigned top(struct cache *ca)
-	{
-		return GC_SECTORS_USED(heap_peek(&ca->heap));
-	}
-
 	if (!c->copy_gc_enabled)
 		closure_return(cl);
 
@@ -220,7 +220,7 @@ void bch_moving_gc(struct closure *cl)
 				sectors_to_move += GC_SECTORS_USED(b);
 				heap_add(&ca->heap, b, bucket_cmp);
 			} else if (bucket_cmp(b, heap_peek(&ca->heap))) {
-				sectors_to_move -= top(ca);
+				sectors_to_move -= bucket_heap_top(ca);
 				sectors_to_move += GC_SECTORS_USED(b);
 
 				ca->heap.data[0] = b;
@@ -233,7 +233,7 @@ void bch_moving_gc(struct closure *cl)
 			sectors_to_move -= GC_SECTORS_USED(b);
 		}
 
-		ca->gc_move_threshold = top(ca);
+		ca->gc_move_threshold = bucket_heap_top(ca);
 
 		pr_debug("threshold %u", ca->gc_move_threshold);
 	}
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 4f552de..dbda964 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1117,11 +1117,13 @@ static void add_sequential(struct task_struct *t)
 	t->sequential_io = 0;
 }
 
-static void check_should_skip(struct cached_dev *dc, struct search *s)
+static struct hlist_head *iohash(struct cached_dev *dc, uint64_t k)
 {
-	struct hlist_head *iohash(uint64_t k)
-	{ return &dc->io_hash[hash_64(k, RECENT_IO_BITS)]; }
+	return &dc->io_hash[hash_64(k, RECENT_IO_BITS)];
+}
 
+static void check_should_skip(struct cached_dev *dc, struct search *s)
+{
 	struct cache_set *c = s->op.c;
 	struct bio *bio = &s->bio.bio;
 
@@ -1162,7 +1164,7 @@ static void check_should_skip(struct cached_dev *dc, struct search *s)
 
 		spin_lock(&dc->io_lock);
 
-		hlist_for_each_entry(i, iohash(bio->bi_sector), hash)
+		hlist_for_each_entry(i, iohash(dc, bio->bi_sector), hash)
 			if (i->last == bio->bi_sector &&
 			    time_before(jiffies, i->jiffies))
 				goto found;
@@ -1180,7 +1182,7 @@ found:
 		s->task->sequential_io	 = i->sequential;
 
 		hlist_del(&i->hash);
-		hlist_add_head(&i->hash, iohash(i->last));
+		hlist_add_head(&i->hash, iohash(dc, i->last));
 		list_move_tail(&i->lru, &dc->io_lru);
 
 		spin_unlock(&dc->io_lock);
diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
index bf6cf95..64e6794 100644
--- a/drivers/md/bcache/stats.c
+++ b/drivers/md/bcache/stats.c
@@ -95,7 +95,8 @@ static KTYPE(bch_stats);
 
 static void scale_accounting(unsigned long data);
 
-void bch_cache_accounting_init(struct cache_accounting *acc, struct closure *parent)
+void bch_cache_accounting_init(struct cache_accounting *acc,
+			       struct closure *parent)
 {
 	kobject_init(&acc->total.kobj,		&bch_stats_ktype);
 	kobject_init(&acc->five_minute.kobj,	&bch_stats_ktype);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 7b8efc7..484ae6c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -526,7 +526,8 @@ void bch_prio_write(struct cache *ca)
 	for (i = prio_buckets(ca) - 1; i >= 0; --i) {
 		long bucket;
 		struct prio_set *p = ca->disk_buckets;
-		struct bucket_disk *d = p->data, *end = d + prios_per_bucket(ca);
+		struct bucket_disk *d = p->data;
+		struct bucket_disk *end = d + prios_per_bucket(ca);
 
 		for (b = ca->buckets + i * prios_per_bucket(ca);
 		     b < ca->buckets + ca->sb.nbuckets && d < end;
@@ -865,8 +866,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 
 	if (dc->sb.block_size < c->sb.block_size) {
 		/* Will die */
-		pr_err("Couldn't attach %s: block size "
-		       "less than set's block size", buf);
+		pr_err("Couldn't attach %s: block size less than set's block size",
+		       buf);
 		return -EINVAL;
 	}
 
-- 
1.8.1.3
