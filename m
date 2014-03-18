From: john.sheu@gmail.com
Subject: [PATCH] bcache: remove nested function usage
Date: Mon, 17 Mar 2014 23:13:56 -0700
Message-ID: <1395123236-25114-1-git-send-email-john.sheu@gmail.com>
References: <1395121859-23501-1-git-send-email-john.sheu@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f74.google.com ([209.85.160.74]:47012 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaCRGjU (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 18 Mar 2014 02:39:20 -0400
Received: by mail-pb0-f74.google.com with SMTP id md12so840059pbc.3
        for <linux-bcache@vger.kernel.org>; Mon, 17 Mar 2014 23:39:19 -0700 (PDT)
In-Reply-To: <1395121859-23501-1-git-send-email-john.sheu@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, kmo@daterainc.com
Cc: John Sheu <john.sheu@gmail.com>

From: John Sheu <john.sheu@gmail.com>

Uninlined nested functions can cause crashes when using ftrace, as they don't
follow the normal calling convention and confuse the ftrace function graph
tracer as it examines the stack.

Also, nested functions are supported as a gcc extension, but may fail on other
compilers (e.g. llvm).

Signed-off-by: John Sheu <john.sheu@gmail.com>
---
 drivers/md/bcache/extents.c |  21 ++++----
 drivers/md/bcache/sysfs.c   | 122 ++++++++++++++++++++++----------------------
 2 files changed, 74 insertions(+), 69 deletions(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index 1a87d2bd..785345ac 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -468,6 +468,15 @@ static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 	return NULL;
 }
 
+static void subtract_dirty(struct bkey *k,
+			   struct cache_set *c,
+			   uint64_t offset,
+			   int sectors)
+{
+	if (KEY_CACHED(k) && bch_extent_ptrs(k))
+		bcache_dev_sectors_dirty_add(c, KEY_INODE(k), offset, -sectors);
+}
+
 static bool bch_extent_insert_fixup(struct btree_keys *b,
 				    struct bkey *insert,
 				    struct btree_iter *iter,
@@ -475,13 +484,6 @@ static bool bch_extent_insert_fixup(struct btree_keys *b,
 {
 	struct cache_set *c = container_of(b, struct btree, keys)->c;
 
-	void subtract_dirty(struct bkey *k, uint64_t offset, int sectors)
-	{
-		if (!KEY_CACHED(k) && bch_extent_ptrs(k))
-			bcache_dev_sectors_dirty_add(c, KEY_INODE(k),
-						     offset, -sectors);
-	}
-
 	uint64_t old_offset;
 	unsigned old_size, sectors_found = 0;
 
@@ -558,7 +560,8 @@ static bool bch_extent_insert_fixup(struct btree_keys *b,
 
 			struct bkey *top;
 
-			subtract_dirty(k, KEY_START(insert), KEY_SIZE(insert));
+			subtract_dirty(k, c, KEY_START(insert),
+				       KEY_SIZE(insert));
 
 			if (bkey_written(b, k)) {
 				/*
@@ -608,7 +611,7 @@ static bool bch_extent_insert_fixup(struct btree_keys *b,
 			}
 		}
 
-		subtract_dirty(k, old_offset, old_size - KEY_SIZE(k));
+		subtract_dirty(k, c, old_offset, old_size - KEY_SIZE(k));
 	}
 
 check_failed:
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 9d85958e..30158f45 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -422,81 +422,81 @@ static unsigned cache_available_percent(struct cache_set *c)
 	return div64_u64((u64) buckets_available(c) * 100, c->nbuckets);
 }
 
-SHOW(__bch_cache_set)
+static unsigned root_usage(struct cache_set *c)
 {
-	unsigned root_usage(struct cache_set *c)
-	{
-		unsigned bytes = 0;
-		struct bkey *k;
-		struct btree *b;
-		struct btree_iter iter;
+	unsigned bytes = 0;
+	struct bkey *k;
+	struct btree *b;
+	struct btree_iter iter;
 
-		goto lock_root;
+	goto lock_root;
 
-		do {
-			rw_unlock(false, b);
+	do {
+		rw_unlock(false, b);
 lock_root:
-			b = c->btree_roots[BTREE_ID_EXTENTS];
-			rw_lock(false, b, b->level);
-		} while (b != c->btree_roots[BTREE_ID_EXTENTS]);
+		b = c->btree_roots[BTREE_ID_EXTENTS];
+		rw_lock(false, b, b->level);
+	} while (b != c->btree_roots[BTREE_ID_EXTENTS]);
 
-		for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
-			bytes += bkey_bytes(k);
+	for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
+		bytes += bkey_bytes(k);
 
-		rw_unlock(false, b);
+	rw_unlock(false, b);
 
-		return (bytes * 100) / btree_bytes(c);
-	}
-
-	size_t cache_size(struct cache_set *c)
-	{
-		size_t ret = 0;
-		struct btree *b;
+	return (bytes * 100) / btree_bytes(c);
+}
 
-		mutex_lock(&c->bucket_lock);
-		list_for_each_entry(b, &c->btree_cache, list)
-			ret += 1 << (b->keys.page_order + PAGE_SHIFT);
+static size_t cache_size(struct cache_set *c)
+{
+	size_t ret = 0;
+	struct btree *b;
 
-		mutex_unlock(&c->bucket_lock);
-		return ret;
-	}
+	mutex_lock(&c->bucket_lock);
+	list_for_each_entry(b, &c->btree_cache, list)
+		ret += 1 << (b->keys.page_order + PAGE_SHIFT);
 
-	unsigned cache_max_chain(struct cache_set *c)
-	{
-		unsigned ret = 0;
-		struct hlist_head *h;
+	mutex_unlock(&c->bucket_lock);
+	return ret;
+}
 
-		mutex_lock(&c->bucket_lock);
+static unsigned cache_max_chain(struct cache_set *c)
+{
+	unsigned ret = 0;
+	struct hlist_head *h;
 
-		for (h = c->bucket_hash;
-		     h < c->bucket_hash + (1 << BUCKET_HASH_BITS);
-		     h++) {
-			unsigned i = 0;
-			struct hlist_node *p;
+	mutex_lock(&c->bucket_lock);
 
-			hlist_for_each(p, h)
-				i++;
+	for (h = c->bucket_hash;
+	     h < c->bucket_hash + (1 << BUCKET_HASH_BITS);
+	     h++) {
+		unsigned i = 0;
+		struct hlist_node *p;
 
-			ret = max(ret, i);
-		}
+		hlist_for_each(p, h)
+			i++;
 
-		mutex_unlock(&c->bucket_lock);
-		return ret;
+		ret = max(ret, i);
 	}
 
-	unsigned btree_used(struct cache_set *c)
-	{
-		return div64_u64(c->gc_stats.key_bytes * 100,
-				 (c->gc_stats.nodes ?: 1) * btree_bytes(c));
-	}
+	mutex_unlock(&c->bucket_lock);
+	return ret;
+}
 
-	unsigned average_key_size(struct cache_set *c)
-	{
-		return c->gc_stats.nkeys
-			? div64_u64(c->gc_stats.data, c->gc_stats.nkeys)
-			: 0;
-	}
+static unsigned btree_used(struct cache_set *c)
+{
+	return div64_u64(c->gc_stats.key_bytes * 100,
+			 (c->gc_stats.nodes ?: 1) * btree_bytes(c));
+}
+
+static unsigned average_key_size(struct cache_set *c)
+{
+	return c->gc_stats.nkeys
+		? div64_u64(c->gc_stats.data, c->gc_stats.nkeys)
+		: 0;
+}
 
+SHOW(__bch_cache_set)
+{
 	struct cache_set *c = container_of(kobj, struct cache_set, kobj);
 
 	sysfs_print(synchronous,		CACHE_SYNC(&c->sb));
@@ -740,6 +740,11 @@ static struct attribute *bch_cache_set_internal_files[] = {
 };
 KTYPE(bch_cache_set_internal);
 
+static int prio_cmp(const void *l, const void *r)
+{
+	return *((uint16_t *) r) - *((uint16_t *) l);
+}
+
 SHOW(__bch_cache)
 {
 	struct cache *ca = container_of(kobj, struct cache, kobj);
@@ -766,9 +771,6 @@ SHOW(__bch_cache)
 	sysfs_print(tier,		CACHE_TIER(&ca->sb));
 
 	if (attr == &sysfs_priority_stats) {
-		int cmp(const void *l, const void *r)
-		{	return *((uint16_t *) r) - *((uint16_t *) l); }
-
 		struct bucket *b;
 		size_t n = ca->sb.nbuckets, i;
 		size_t unused = 0, available = 0, dirty = 0, meta = 0;
@@ -797,7 +799,7 @@ SHOW(__bch_cache)
 			p[i] = ca->buckets[i].read_prio;
 		mutex_unlock(&ca->set->bucket_lock);
 
-		sort(p, n, sizeof(uint16_t), cmp, NULL);
+		sort(p, n, sizeof(uint16_t), prio_cmp, NULL);
 
 		while (n &&
 		       !cached[n - 1])
-- 
1.9.0.279.gdc9e3eb
