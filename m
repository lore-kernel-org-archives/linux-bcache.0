From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] bcache: Don't export utility code, prefix with bch_
Date: Tue, 26 Mar 2013 15:21:28 -0700
Message-ID: <1364336488-11219-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/md/bcache/bcache.h    |  2 +-
 drivers/md/bcache/bset.c      |  4 ++--
 drivers/md/bcache/btree.c     | 18 +++++++--------
 drivers/md/bcache/debug.c     |  2 +-
 drivers/md/bcache/journal.c   |  4 ++--
 drivers/md/bcache/movinggc.c  |  4 ++--
 drivers/md/bcache/request.c   | 14 +++++------
 drivers/md/bcache/super.c     | 18 +++++++--------
 drivers/md/bcache/sysfs.c     | 24 +++++++++----------
 drivers/md/bcache/sysfs.h     |  2 +-
 drivers/md/bcache/util.c      | 38 +++++++++++-------------------
 drivers/md/bcache/util.h      | 54 +++++++++++++++++++++----------------------
 drivers/md/bcache/writeback.c |  6 ++---
 13 files changed, 89 insertions(+), 101 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index b2846e7..f057235 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1033,7 +1033,7 @@ static inline void bkey_init(struct bkey *k)
  * jset: The checksum is _always_ the first 8 bytes of these structs
  */
 #define csum_set(i)							\
-	crc64(((void *) (i)) + sizeof(uint64_t),			\
+	bch_crc64(((void *) (i)) + sizeof(uint64_t),			\
 	      ((void *) end(i)) - (((void *) (i)) + sizeof(uint64_t)))
 
 /* Error handling macros */
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 4dc9cb4..0b33aac 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -1026,7 +1026,7 @@ static void __btree_sort(struct btree *b, struct btree_iter *iter,
 
 	if (!start) {
 		spin_lock(&b->c->sort_time_lock);
-		time_stats_update(&b->c->sort_time, start_time);
+		bch_time_stats_update(&b->c->sort_time, start_time);
 		spin_unlock(&b->c->sort_time_lock);
 	}
 }
@@ -1076,7 +1076,7 @@ void bch_btree_sort_into(struct btree *b, struct btree *new)
 	btree_mergesort(b, new->sets->data, &iter, false, true);
 
 	spin_lock(&b->c->sort_time_lock);
-	time_stats_update(&b->c->sort_time, start_time);
+	bch_time_stats_update(&b->c->sort_time, start_time);
 	spin_unlock(&b->c->sort_time_lock);
 
 	bkey_copy_key(&new->key, &b->key);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 24b6780..f2b2c65 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -129,7 +129,7 @@ static uint64_t btree_csum_set(struct btree *b, struct bset *i)
 	uint64_t crc = b->key.ptr[0];
 	void *data = (void *) i + 8, *end = end(i);
 
-	crc = crc64_update(crc, data, end - data);
+	crc = bch_crc64_update(crc, data, end - data);
 	return crc ^ 0xffffffffffffffff;
 }
 
@@ -231,7 +231,7 @@ out:
 	mutex_unlock(&b->c->fill_lock);
 
 	spin_lock(&b->c->btree_read_time_lock);
-	time_stats_update(&b->c->btree_read_time, b->io_start_time);
+	bch_time_stats_update(&b->c->btree_read_time, b->io_start_time);
 	spin_unlock(&b->c->btree_read_time_lock);
 
 	smp_wmb(); /* read_done is our write lock */
@@ -259,7 +259,7 @@ void bch_btree_read(struct btree *b)
 	b->bio->bi_rw	= REQ_META|READ_SYNC;
 	b->bio->bi_size	= KEY_SIZE(&b->key) << 9;
 
-	bio_map(b->bio, b->sets[0].data);
+	bch_bio_map(b->bio, b->sets[0].data);
 
 	pr_debug("%s", pbtree(b));
 	trace_bcache_btree_read(b->bio);
@@ -327,12 +327,12 @@ static void do_btree_write(struct btree *b)
 	btree_bio_init(b);
 	b->bio->bi_rw	= REQ_META|WRITE_SYNC;
 	b->bio->bi_size	= set_blocks(i, b->c) * block_bytes(b->c);
-	bio_map(b->bio, i);
+	bch_bio_map(b->bio, i);
 
 	bkey_copy(&k.key, &b->key);
 	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) + bset_offset(b, i));
 
-	if (!bio_alloc_pages(b->bio, GFP_NOIO)) {
+	if (!bch_bio_alloc_pages(b->bio, GFP_NOIO)) {
 		int j;
 		struct bio_vec *bv;
 		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
@@ -347,7 +347,7 @@ static void do_btree_write(struct btree *b)
 		continue_at(cl, btree_write_done, NULL);
 	} else {
 		b->bio->bi_vcnt = 0;
-		bio_map(b->bio, i);
+		bch_bio_map(b->bio, i);
 
 		trace_bcache_btree_write(b->bio);
 		bch_submit_bbio(b->bio, b->c, &k.key, 0);
@@ -815,7 +815,7 @@ retry:
 void bch_cannibalize_unlock(struct cache_set *c, struct closure *cl)
 {
 	if (c->try_harder == cl) {
-		time_stats_update(&c->try_harder_time, c->try_harder_start);
+		bch_time_stats_update(&c->try_harder_time, c->try_harder_start);
 		c->try_harder = NULL;
 		__closure_wake_up(&c->try_wait);
 	}
@@ -1536,7 +1536,7 @@ static void bch_btree_gc(struct closure *cl)
 
 	available = bch_btree_gc_finish(c);
 
-	time_stats_update(&c->btree_gc_time, start_time);
+	bch_time_stats_update(&c->btree_gc_time, start_time);
 
 	stats.key_bytes *= sizeof(uint64_t);
 	stats.dirty	<<= 9;
@@ -2007,7 +2007,7 @@ static int btree_split(struct btree *b, struct btree_op *op)
 	rw_unlock(true, n1);
 	btree_node_free(b, op);
 
-	time_stats_update(&b->c->btree_split_time, start_time);
+	bch_time_stats_update(&b->c->btree_split_time, start_time);
 
 	return 0;
 err_free2:
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 141a5ca..732234d 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -200,7 +200,7 @@ void bch_data_verify(struct search *s)
 	if (!check)
 		return;
 
-	if (bio_alloc_pages(check, GFP_NOIO))
+	if (bch_bio_alloc_pages(check, GFP_NOIO))
 		goto out_put;
 
 	check->bi_rw		= READ_SYNC;
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 21fd101..b0a3d05 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -54,7 +54,7 @@ reread:		left = ca->sb.bucket_size - offset;
 
 		bio->bi_end_io	= journal_read_endio;
 		bio->bi_private = &op->cl;
-		bio_map(bio, data);
+		bch_bio_map(bio, data);
 
 		closure_bio_submit(bio, &op->cl, ca);
 		closure_sync(&op->cl);
@@ -621,7 +621,7 @@ static void journal_write_unlocked(struct closure *cl)
 
 		bio->bi_end_io	= journal_write_endio;
 		bio->bi_private = w;
-		bio_map(bio, w->data);
+		bch_bio_map(bio, w->data);
 
 		trace_bcache_journal_write(bio);
 		bio_list_add(&list, bio);
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index e3ec0a5..8589512 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -85,7 +85,7 @@ static void moving_init(struct moving_io *io)
 					       PAGE_SECTORS);
 	bio->bi_private		= &io->s.cl;
 	bio->bi_io_vec		= bio->bi_inline_vecs;
-	bio_map(bio, NULL);
+	bch_bio_map(bio, NULL);
 }
 
 static void write_moving(struct closure *cl)
@@ -159,7 +159,7 @@ static void read_moving(struct closure *cl)
 		bio->bi_rw	= READ;
 		bio->bi_end_io	= read_moving_endio;
 
-		if (bio_alloc_pages(bio, GFP_KERNEL))
+		if (bch_bio_alloc_pages(bio, GFP_KERNEL))
 			goto err;
 
 		pr_debug("%s", pkey(&w->key));
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index dbda964..83731dc 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -58,8 +58,8 @@ static ssize_t cache_mode_read(struct cgroup *cgrp, struct cftype *cft,
 			char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	char tmp[1024];
-	int len = snprint_string_list(tmp, PAGE_SIZE, bch_cache_modes,
-				      cgroup_to_bcache(cgrp)->cache_mode + 1);
+	int len = bch_snprint_string_list(tmp, PAGE_SIZE, bch_cache_modes,
+					  cgroup_to_bcache(cgrp)->cache_mode + 1);
 
 	if (len < 0)
 		return len;
@@ -70,7 +70,7 @@ static ssize_t cache_mode_read(struct cgroup *cgrp, struct cftype *cft,
 static int cache_mode_write(struct cgroup *cgrp, struct cftype *cft,
 			    const char *buf)
 {
-	int v = read_string_list(buf, bch_cache_modes);
+	int v = bch_read_string_list(buf, bch_cache_modes);
 	if (v < 0)
 		return v;
 
@@ -205,7 +205,7 @@ static void bio_csum(struct bio *bio, struct bkey *k)
 
 	bio_for_each_segment(bv, bio, i) {
 		void *d = kmap(bv->bv_page) + bv->bv_offset;
-		csum = crc64_update(csum, d, bv->bv_len);
+		csum = bch_crc64_update(csum, d, bv->bv_len);
 		kunmap(bv->bv_page);
 	}
 
@@ -835,7 +835,7 @@ static void request_read_done(struct closure *cl)
 		s->op.cache_bio->bi_sector	= s->cache_miss->bi_sector;
 		s->op.cache_bio->bi_bdev	= s->cache_miss->bi_bdev;
 		s->op.cache_bio->bi_size	= s->cache_bio_sectors << 9;
-		bio_map(s->op.cache_bio, NULL);
+		bch_bio_map(s->op.cache_bio, NULL);
 
 		src = bio_iovec(s->op.cache_bio);
 		dst = bio_iovec(s->cache_miss);
@@ -962,8 +962,8 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	if (!bch_btree_insert_check_key(b, &s->op, s->op.cache_bio))
 		goto out_put;
 
-	bio_map(s->op.cache_bio, NULL);
-	if (bio_alloc_pages(s->op.cache_bio, __GFP_NOWARN|GFP_NOIO))
+	bch_bio_map(s->op.cache_bio, NULL);
+	if (bch_bio_alloc_pages(s->op.cache_bio, __GFP_NOWARN|GFP_NOIO))
 		goto out_put;
 
 	s->cache_miss = miss;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 484ae6c..f47ecb5 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -142,7 +142,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 		goto err;
 
 	err = "Bad UUID";
-	if (is_zero(sb->uuid, 16))
+	if (bch_is_zero(sb->uuid, 16))
 		goto err;
 
 	err = "Unsupported superblock version";
@@ -170,7 +170,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 		goto out;
 
 	err = "Bad UUID";
-	if (is_zero(sb->set_uuid, 16))
+	if (bch_is_zero(sb->set_uuid, 16))
 		goto err;
 
 	err = "Bad cache device number in set";
@@ -218,7 +218,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	bio->bi_sector	= SB_SECTOR;
 	bio->bi_rw	= REQ_SYNC|REQ_META;
 	bio->bi_size	= SB_SIZE;
-	bio_map(bio, NULL);
+	bch_bio_map(bio, NULL);
 
 	out->offset		= cpu_to_le64(sb->offset);
 	out->version		= cpu_to_le64(sb->version);
@@ -332,7 +332,7 @@ static void uuid_io(struct cache_set *c, unsigned long rw,
 
 		bio->bi_end_io	= uuid_endio;
 		bio->bi_private = cl;
-		bio_map(bio, c->uuids);
+		bch_bio_map(bio, c->uuids);
 
 		bch_submit_bbio(bio, c, k, i);
 
@@ -344,7 +344,7 @@ static void uuid_io(struct cache_set *c, unsigned long rw,
 		 pkey(&c->uuid_bucket));
 
 	for (u = c->uuids; u < c->uuids + c->nr_uuids; u++)
-		if (!is_zero(u->uuid, 16))
+		if (!bch_is_zero(u->uuid, 16))
 			pr_debug("Slot %zi: %pU: %s: 1st: %u last: %u inv: %u",
 				 u - c->uuids, u->uuid, u->label,
 				 u->first_reg, u->last_reg, u->invalidated);
@@ -491,7 +491,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, unsigned long rw)
 
 	bio->bi_end_io	= prio_endio;
 	bio->bi_private = ca;
-	bio_map(bio, ca->disk_buckets);
+	bch_bio_map(bio, ca->disk_buckets);
 
 	closure_bio_submit(bio, &ca->prio, ca);
 	closure_sync(cl);
@@ -538,7 +538,7 @@ void bch_prio_write(struct cache *ca)
 
 		p->next_bucket	= ca->prio_buckets[i + 1];
 		p->magic	= pset_magic(ca);
-		p->csum		= crc64(&p->magic, bucket_bytes(ca) - 8);
+		p->csum		= bch_crc64(&p->magic, bucket_bytes(ca) - 8);
 
 		bucket = bch_bucket_alloc(ca, WATERMARK_PRIO, &cl);
 		BUG_ON(bucket == -1);
@@ -585,7 +585,7 @@ static void prio_read(struct cache *ca, uint64_t bucket)
 
 			prio_io(ca, bucket, READ_SYNC);
 
-			if (p->csum != crc64(&p->magic, bucket_bytes(ca) - 8))
+			if (p->csum != bch_crc64(&p->magic, bucket_bytes(ca) - 8))
 				pr_warn("bad csum reading priorities");
 
 			if (p->magic != pset_magic(ca))
@@ -898,7 +898,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	sysfs_remove_file(&dc->kobj, &sysfs_attach);
 	 */
 
-	if (is_zero(u->uuid, 16)) {
+	if (bch_is_zero(u->uuid, 16)) {
 		struct closure cl;
 		closure_init_stack(&cl);
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 5c7e770..4d9cca4 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -105,9 +105,9 @@ SHOW(__bch_cached_dev)
 #define var(stat)		(dc->stat)
 
 	if (attr == &sysfs_cache_mode)
-		return snprint_string_list(buf, PAGE_SIZE,
-					   bch_cache_modes + 1,
-					   BDEV_CACHE_MODE(&dc->sb));
+		return bch_snprint_string_list(buf, PAGE_SIZE,
+					       bch_cache_modes + 1,
+					       BDEV_CACHE_MODE(&dc->sb));
 
 	sysfs_printf(data_csum,		"%i", dc->disk.data_csum);
 	var_printf(verify,		"%i");
@@ -126,10 +126,10 @@ SHOW(__bch_cached_dev)
 		char dirty[20];
 		char derivative[20];
 		char target[20];
-		hprint(dirty,
+		bch_hprint(dirty,
 		       atomic_long_read(&dc->disk.sectors_dirty) << 9);
-		hprint(derivative,	dc->writeback_rate_derivative << 9);
-		hprint(target,		dc->writeback_rate_target << 9);
+		bch_hprint(derivative,	dc->writeback_rate_derivative << 9);
+		bch_hprint(target,	dc->writeback_rate_target << 9);
 
 		return sprintf(buf,
 			       "rate:\t\t%u\n"
@@ -202,7 +202,7 @@ STORE(__cached_dev)
 		bch_cached_dev_run(dc);
 
 	if (attr == &sysfs_cache_mode) {
-		ssize_t v = read_string_list(buf, bch_cache_modes + 1);
+		ssize_t v = bch_read_string_list(buf, bch_cache_modes + 1);
 
 		if (v < 0)
 			return v;
@@ -224,7 +224,7 @@ STORE(__cached_dev)
 	}
 
 	if (attr == &sysfs_attach) {
-		if (parse_uuid(buf, dc->sb.set_uuid) < 16)
+		if (bch_parse_uuid(buf, dc->sb.set_uuid) < 16)
 			return -EINVAL;
 
 		list_for_each_entry(c, &bch_cache_sets, list) {
@@ -657,9 +657,9 @@ SHOW(__bch_cache)
 		    ((size_t) ca->sb.nbuckets));
 
 	if (attr == &sysfs_cache_replacement_policy)
-		return snprint_string_list(buf, PAGE_SIZE,
-					   cache_replacement_policies,
-					   CACHE_REPLACEMENT(&ca->sb));
+		return bch_snprint_string_list(buf, PAGE_SIZE,
+					       cache_replacement_policies,
+					       CACHE_REPLACEMENT(&ca->sb));
 
 	if (attr == &sysfs_priority_stats) {
 		int cmp(const void *l, const void *r)
@@ -747,7 +747,7 @@ STORE(__bch_cache)
 	}
 
 	if (attr == &sysfs_cache_replacement_policy) {
-		ssize_t v = read_string_list(buf, cache_replacement_policies);
+		ssize_t v = bch_read_string_list(buf, cache_replacement_policies);
 
 		if (v < 0)
 			return v;
diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index 34e4ba1..0526fe9 100644
--- a/drivers/md/bcache/sysfs.h
+++ b/drivers/md/bcache/sysfs.h
@@ -62,7 +62,7 @@ do {									\
 #define sysfs_hprint(file, val)						\
 do {									\
 	if (attr == &sysfs_ ## file) {					\
-		ssize_t ret = hprint(buf, val);				\
+		ssize_t ret = bch_hprint(buf, val);			\
 		strcat(buf, "\n");					\
 		return ret + 1;						\
 	}								\
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index dcec2e4..22324d8 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -19,7 +19,7 @@
 #define simple_strtouint(c, end, base)	simple_strtoul(c, end, base)
 
 #define STRTO_H(name, type)					\
-int name ## _h(const char *cp, type *res)		        \
+int bch_ ## name ## _h(const char *cp, type *res)		\
 {								\
 	int u = 0;						\
 	char *e;						\
@@ -67,14 +67,13 @@ int name ## _h(const char *cp, type *res)		        \
 	*res = i;						\
 	return 0;						\
 }								\
-EXPORT_SYMBOL_GPL(name ## _h);
 
 STRTO_H(strtoint, int)
 STRTO_H(strtouint, unsigned int)
 STRTO_H(strtoll, long long)
 STRTO_H(strtoull, unsigned long long)
 
-ssize_t hprint(char *buf, int64_t v)
+ssize_t bch_hprint(char *buf, int64_t v)
 {
 	static const char units[] = "?kMGTPEZY";
 	char dec[3] = "";
@@ -93,9 +92,8 @@ ssize_t hprint(char *buf, int64_t v)
 
 	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
 }
-EXPORT_SYMBOL_GPL(hprint);
 
-ssize_t snprint_string_list(char *buf, size_t size, const char * const list[],
+ssize_t bch_snprint_string_list(char *buf, size_t size, const char * const list[],
 			    size_t selected)
 {
 	char *out = buf;
@@ -108,9 +106,8 @@ ssize_t snprint_string_list(char *buf, size_t size, const char * const list[],
 	out[-1] = '\n';
 	return out - buf;
 }
-EXPORT_SYMBOL_GPL(snprint_string_list);
 
-ssize_t read_string_list(const char *buf, const char * const list[])
+ssize_t bch_read_string_list(const char *buf, const char * const list[])
 {
 	size_t i;
 	char *s, *d = kstrndup(buf, PAGE_SIZE - 1, GFP_KERNEL);
@@ -130,9 +127,8 @@ ssize_t read_string_list(const char *buf, const char * const list[])
 
 	return i;
 }
-EXPORT_SYMBOL_GPL(read_string_list);
 
-bool is_zero(const char *p, size_t n)
+bool bch_is_zero(const char *p, size_t n)
 {
 	size_t i;
 
@@ -141,9 +137,8 @@ bool is_zero(const char *p, size_t n)
 			return false;
 	return true;
 }
-EXPORT_SYMBOL_GPL(is_zero);
 
-int parse_uuid(const char *s, char *uuid)
+int bch_parse_uuid(const char *s, char *uuid)
 {
 	size_t i, j, x;
 	memset(uuid, 0, 16);
@@ -170,9 +165,8 @@ int parse_uuid(const char *s, char *uuid)
 	}
 	return i;
 }
-EXPORT_SYMBOL_GPL(parse_uuid);
 
-void time_stats_update(struct time_stats *stats, uint64_t start_time)
+void bch_time_stats_update(struct time_stats *stats, uint64_t start_time)
 {
 	uint64_t now		= local_clock();
 	uint64_t duration	= time_after64(now, start_time)
@@ -195,9 +189,8 @@ void time_stats_update(struct time_stats *stats, uint64_t start_time)
 
 	stats->last = now ?: 1;
 }
-EXPORT_SYMBOL_GPL(time_stats_update);
 
-unsigned next_delay(struct ratelimit *d, uint64_t done)
+unsigned bch_next_delay(struct ratelimit *d, uint64_t done)
 {
 	uint64_t now = local_clock();
 
@@ -207,9 +200,8 @@ unsigned next_delay(struct ratelimit *d, uint64_t done)
 		? div_u64(d->next - now, NSEC_PER_SEC / HZ)
 		: 0;
 }
-EXPORT_SYMBOL_GPL(next_delay);
 
-void bio_map(struct bio *bio, void *base)
+void bch_bio_map(struct bio *bio, void *base)
 {
 	size_t size = bio->bi_size;
 	struct bio_vec *bv = bio->bi_io_vec;
@@ -235,9 +227,8 @@ start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
 		size -= bv->bv_len;
 	}
 }
-EXPORT_SYMBOL_GPL(bio_map);
 
-int bio_alloc_pages(struct bio *bio, gfp_t gfp)
+int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp)
 {
 	int i;
 	struct bio_vec *bv;
@@ -253,7 +244,6 @@ int bio_alloc_pages(struct bio *bio, gfp_t gfp)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(bio_alloc_pages);
 
 /*
  * Portions Copyright (c) 1996-2001, PostgreSQL Global Development Group (Any
@@ -365,7 +355,7 @@ static const uint64_t crc_table[256] = {
 	0x9AFCE626CE85B507
 };
 
-uint64_t crc64_update(uint64_t crc, const void *_data, size_t len)
+uint64_t bch_crc64_update(uint64_t crc, const void *_data, size_t len)
 {
 	const unsigned char *data = _data;
 
@@ -376,14 +366,12 @@ uint64_t crc64_update(uint64_t crc, const void *_data, size_t len)
 
 	return crc;
 }
-EXPORT_SYMBOL(crc64_update);
 
-uint64_t crc64(const void *data, size_t len)
+uint64_t bch_crc64(const void *data, size_t len)
 {
 	uint64_t crc = 0xffffffffffffffff;
 
-	crc = crc64_update(crc, data, len);
+	crc = bch_crc64_update(crc, data, len);
 
 	return crc ^ 0xffffffffffffffff;
 }
-EXPORT_SYMBOL(crc64);
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 56705fd..577393e 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -307,42 +307,42 @@ do {									\
 #define ANYSINT_MAX(t)							\
 	((((t) 1 << (sizeof(t) * 8 - 2)) - (t) 1) * (t) 2 + (t) 1)
 
-int strtoint_h(const char *, int *);
-int strtouint_h(const char *, unsigned int *);
-int strtoll_h(const char *, long long *);
-int strtoull_h(const char *, unsigned long long *);
+int bch_strtoint_h(const char *, int *);
+int bch_strtouint_h(const char *, unsigned int *);
+int bch_strtoll_h(const char *, long long *);
+int bch_strtoull_h(const char *, unsigned long long *);
 
-static inline int strtol_h(const char *cp, long *res)
+static inline int bch_strtol_h(const char *cp, long *res)
 {
 #if BITS_PER_LONG == 32
-	return strtoint_h(cp, (int *) res);
+	return bch_strtoint_h(cp, (int *) res);
 #else
-	return strtoll_h(cp, (long long *) res);
+	return bch_strtoll_h(cp, (long long *) res);
 #endif
 }
 
-static inline int strtoul_h(const char *cp, long *res)
+static inline int bch_strtoul_h(const char *cp, long *res)
 {
 #if BITS_PER_LONG == 32
-	return strtouint_h(cp, (unsigned int *) res);
+	return bch_strtouint_h(cp, (unsigned int *) res);
 #else
-	return strtoull_h(cp, (unsigned long long *) res);
+	return bch_strtoull_h(cp, (unsigned long long *) res);
 #endif
 }
 
 #define strtoi_h(cp, res)						\
 	(__builtin_types_compatible_p(typeof(*res), int)		\
-	? strtoint_h(cp, (void *) res)					\
+	? bch_strtoint_h(cp, (void *) res)				\
 	: __builtin_types_compatible_p(typeof(*res), long)		\
-	? strtol_h(cp, (void *) res)					\
+	? bch_strtol_h(cp, (void *) res)				\
 	: __builtin_types_compatible_p(typeof(*res), long long)		\
-	? strtoll_h(cp, (void *) res)					\
+	? bch_strtoll_h(cp, (void *) res)				\
 	: __builtin_types_compatible_p(typeof(*res), unsigned int)	\
-	? strtouint_h(cp, (void *) res)					\
+	? bch_strtouint_h(cp, (void *) res)				\
 	: __builtin_types_compatible_p(typeof(*res), unsigned long)	\
-	? strtoul_h(cp, (void *) res)					\
+	? bch_strtoul_h(cp, (void *) res)				\
 	: __builtin_types_compatible_p(typeof(*res), unsigned long long)\
-	? strtoull_h(cp, (void *) res) : -EINVAL)
+	? bch_strtoull_h(cp, (void *) res) : -EINVAL)
 
 #define strtoul_safe(cp, var)						\
 ({									\
@@ -379,15 +379,15 @@ static inline int strtoul_h(const char *cp, long *res)
 		__builtin_types_compatible_p(typeof(var), const char *)	\
 		     ? "%s\n" : "%i\n", var)
 
-ssize_t hprint(char *buf, int64_t v);
+ssize_t bch_hprint(char *buf, int64_t v);
 
-bool is_zero(const char *p, size_t n);
-int parse_uuid(const char *s, char *uuid);
+bool bch_is_zero(const char *p, size_t n);
+int bch_parse_uuid(const char *s, char *uuid);
 
-ssize_t snprint_string_list(char *buf, size_t size, const char * const list[],
+ssize_t bch_snprint_string_list(char *buf, size_t size, const char * const list[],
 			    size_t selected);
 
-ssize_t read_string_list(const char *buf, const char * const list[]);
+ssize_t bch_read_string_list(const char *buf, const char * const list[]);
 
 struct time_stats {
 	/*
@@ -400,7 +400,7 @@ struct time_stats {
 	uint64_t	last;
 };
 
-void time_stats_update(struct time_stats *stats, uint64_t time);
+void bch_time_stats_update(struct time_stats *stats, uint64_t time);
 
 #define NSEC_PER_ns			1L
 #define NSEC_PER_us			NSEC_PER_USEC
@@ -462,7 +462,7 @@ static inline void ratelimit_reset(struct ratelimit *d)
 	d->next = local_clock();
 }
 
-unsigned next_delay(struct ratelimit *d, uint64_t done);
+unsigned bch_next_delay(struct ratelimit *d, uint64_t done);
 
 #define __DIV_SAFE(n, d, zero)						\
 ({									\
@@ -568,9 +568,9 @@ static inline unsigned fract_exp_two(unsigned x, unsigned fract_bits)
 
 #define bio_end(bio)	((bio)->bi_sector + bio_sectors(bio))
 
-void bio_map(struct bio *bio, void *base);
+void bch_bio_map(struct bio *bio, void *base);
 
-int bio_alloc_pages(struct bio *bio, gfp_t gfp);
+int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp);
 
 static inline sector_t bdev_sectors(struct block_device *bdev)
 {
@@ -583,7 +583,7 @@ do {									\
 	bch_generic_make_request(bio, &(dev)->bio_split_hook);		\
 } while (0)
 
-uint64_t crc64_update(uint64_t, const void *, size_t);
-uint64_t crc64(const void *, size_t);
+uint64_t bch_crc64_update(uint64_t, const void *, size_t);
+uint64_t bch_crc64(const void *, size_t);
 
 #endif /* _BCACHE_UTIL_H */
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index a80ee53..93e7e31 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -95,7 +95,7 @@ static unsigned writeback_delay(struct cached_dev *dc, unsigned sectors)
 	    !dc->writeback_percent)
 		return 0;
 
-	return next_delay(&dc->writeback_rate, sectors * 10000000ULL);
+	return bch_next_delay(&dc->writeback_rate, sectors * 10000000ULL);
 }
 
 /* Background writeback */
@@ -118,7 +118,7 @@ static void dirty_init(struct keybuf_key *w)
 	bio->bi_max_vecs	= DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS);
 	bio->bi_private		= w;
 	bio->bi_io_vec		= bio->bi_inline_vecs;
-	bio_map(bio, NULL);
+	bch_bio_map(bio, NULL);
 }
 
 static void refill_dirty(struct closure *cl)
@@ -349,7 +349,7 @@ static void read_dirty(struct closure *cl)
 		io->bio.bi_rw		= READ;
 		io->bio.bi_end_io	= read_dirty_endio;
 
-		if (bio_alloc_pages(&io->bio, GFP_KERNEL))
+		if (bch_bio_alloc_pages(&io->bio, GFP_KERNEL))
 			goto err_free;
 
 		pr_debug("%s", pkey(&w->key));
-- 
1.8.1.3
