From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v6 03/11] bcache: remove driver private bio splitting code
Date: Wed, 12 Aug 2015 00:07:13 -0700
Message-ID: <1439363241-31772-4-git-send-email-mlin@kernel.org>
References: <1439363241-31772-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439363241-31772-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lin <mlin@kernel.org>, linux-bcache@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>
List-Id: linux-bcache@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>

The bcache driver has always accepted arbitrarily large bios and split
them internally.  Now that every driver must accept arbitrarily large
bios this code isn't nessecary anymore.

Cc: linux-bcache@vger.kernel.org
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dpark@posteo.net>
Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 drivers/md/bcache/bcache.h    |  18 --------
 drivers/md/bcache/io.c        | 101 +-----------------------------------------
 drivers/md/bcache/journal.c   |   4 +-
 drivers/md/bcache/request.c   |  16 +++----
 drivers/md/bcache/super.c     |  32 +------------
 drivers/md/bcache/util.h      |   5 ++-
 drivers/md/bcache/writeback.c |   4 +-
 7 files changed, 18 insertions(+), 162 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 04f7bc2..6b420a5 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -243,19 +243,6 @@ struct keybuf {
 	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
 };
 
-struct bio_split_pool {
-	struct bio_set		*bio_split;
-	mempool_t		*bio_split_hook;
-};
-
-struct bio_split_hook {
-	struct closure		cl;
-	struct bio_split_pool	*p;
-	struct bio		*bio;
-	bio_end_io_t		*bi_end_io;
-	void			*bi_private;
-};
-
 struct bcache_device {
 	struct closure		cl;
 
@@ -288,8 +275,6 @@ struct bcache_device {
 	int (*cache_miss)(struct btree *, struct search *,
 			  struct bio *, unsigned);
 	int (*ioctl) (struct bcache_device *, fmode_t, unsigned, unsigned long);
-
-	struct bio_split_pool	bio_split_hook;
 };
 
 struct io {
@@ -454,8 +439,6 @@ struct cache {
 	atomic_long_t		meta_sectors_written;
 	atomic_long_t		btree_sectors_written;
 	atomic_long_t		sectors_written;
-
-	struct bio_split_pool	bio_split_hook;
 };
 
 struct gc_stat {
@@ -873,7 +856,6 @@ void bch_bbio_endio(struct cache_set *, struct bio *, int, const char *);
 void bch_bbio_free(struct bio *, struct cache_set *);
 struct bio *bch_bbio_alloc(struct cache_set *);
 
-void bch_generic_make_request(struct bio *, struct bio_split_pool *);
 void __bch_submit_bbio(struct bio *, struct cache_set *);
 void bch_submit_bbio(struct bio *, struct cache_set *, struct bkey *, unsigned);
 
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index bf6a9ca..86a0bb8 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -11,105 +11,6 @@
 
 #include <linux/blkdev.h>
 
-static unsigned bch_bio_max_sectors(struct bio *bio)
-{
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	struct bio_vec bv;
-	struct bvec_iter iter;
-	unsigned ret = 0, seg = 0;
-
-	if (bio->bi_rw & REQ_DISCARD)
-		return min(bio_sectors(bio), q->limits.max_discard_sectors);
-
-	bio_for_each_segment(bv, bio, iter) {
-		struct bvec_merge_data bvm = {
-			.bi_bdev	= bio->bi_bdev,
-			.bi_sector	= bio->bi_iter.bi_sector,
-			.bi_size	= ret << 9,
-			.bi_rw		= bio->bi_rw,
-		};
-
-		if (seg == min_t(unsigned, BIO_MAX_PAGES,
-				 queue_max_segments(q)))
-			break;
-
-		if (q->merge_bvec_fn &&
-		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
-			break;
-
-		seg++;
-		ret += bv.bv_len >> 9;
-	}
-
-	ret = min(ret, queue_max_sectors(q));
-
-	WARN_ON(!ret);
-	ret = max_t(int, ret, bio_iovec(bio).bv_len >> 9);
-
-	return ret;
-}
-
-static void bch_bio_submit_split_done(struct closure *cl)
-{
-	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
-
-	s->bio->bi_end_io = s->bi_end_io;
-	s->bio->bi_private = s->bi_private;
-	bio_endio(s->bio, 0);
-
-	closure_debug_destroy(&s->cl);
-	mempool_free(s, s->p->bio_split_hook);
-}
-
-static void bch_bio_submit_split_endio(struct bio *bio, int error)
-{
-	struct closure *cl = bio->bi_private;
-	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
-
-	if (error)
-		clear_bit(BIO_UPTODATE, &s->bio->bi_flags);
-
-	bio_put(bio);
-	closure_put(cl);
-}
-
-void bch_generic_make_request(struct bio *bio, struct bio_split_pool *p)
-{
-	struct bio_split_hook *s;
-	struct bio *n;
-
-	if (!bio_has_data(bio) && !(bio->bi_rw & REQ_DISCARD))
-		goto submit;
-
-	if (bio_sectors(bio) <= bch_bio_max_sectors(bio))
-		goto submit;
-
-	s = mempool_alloc(p->bio_split_hook, GFP_NOIO);
-	closure_init(&s->cl, NULL);
-
-	s->bio		= bio;
-	s->p		= p;
-	s->bi_end_io	= bio->bi_end_io;
-	s->bi_private	= bio->bi_private;
-	bio_get(bio);
-
-	do {
-		n = bio_next_split(bio, bch_bio_max_sectors(bio),
-				   GFP_NOIO, s->p->bio_split);
-
-		n->bi_end_io	= bch_bio_submit_split_endio;
-		n->bi_private	= &s->cl;
-
-		closure_get(&s->cl);
-		generic_make_request(n);
-	} while (n != bio);
-
-	continue_at(&s->cl, bch_bio_submit_split_done, NULL);
-	return;
-submit:
-	generic_make_request(bio);
-}
-
 /* Bios with headers */
 
 void bch_bbio_free(struct bio *bio, struct cache_set *c)
@@ -139,7 +40,7 @@ void __bch_submit_bbio(struct bio *bio, struct cache_set *c)
 	bio->bi_bdev		= PTR_CACHE(c, &b->key, 0)->bdev;
 
 	b->submit_time_us = local_clock_us();
-	closure_bio_submit(bio, bio->bi_private, PTR_CACHE(c, &b->key, 0));
+	closure_bio_submit(bio, bio->bi_private);
 }
 
 void bch_submit_bbio(struct bio *bio, struct cache_set *c,
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 418607a..727ca9b 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -61,7 +61,7 @@ reread:		left = ca->sb.bucket_size - offset;
 		bio->bi_private = &cl;
 		bch_bio_map(bio, data);
 
-		closure_bio_submit(bio, &cl, ca);
+		closure_bio_submit(bio, &cl);
 		closure_sync(&cl);
 
 		/* This function could be simpler now since we no longer write
@@ -648,7 +648,7 @@ static void journal_write_unlocked(struct closure *cl)
 	spin_unlock(&c->journal.lock);
 
 	while ((bio = bio_list_pop(&list)))
-		closure_bio_submit(bio, cl, c->cache[0]);
+		closure_bio_submit(bio, cl);
 
 	continue_at(cl, journal_write_done, NULL);
 }
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index f292790..ab093a8 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -718,7 +718,7 @@ static void cached_dev_read_error(struct closure *cl)
 
 		/* XXX: invalidate cache */
 
-		closure_bio_submit(bio, cl, s->d);
+		closure_bio_submit(bio, cl);
 	}
 
 	continue_at(cl, cached_dev_cache_miss_done, NULL);
@@ -841,7 +841,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	s->cache_miss	= miss;
 	s->iop.bio	= cache_bio;
 	bio_get(cache_bio);
-	closure_bio_submit(cache_bio, &s->cl, s->d);
+	closure_bio_submit(cache_bio, &s->cl);
 
 	return ret;
 out_put:
@@ -849,7 +849,7 @@ out_put:
 out_submit:
 	miss->bi_end_io		= request_endio;
 	miss->bi_private	= &s->cl;
-	closure_bio_submit(miss, &s->cl, s->d);
+	closure_bio_submit(miss, &s->cl);
 	return ret;
 }
 
@@ -914,7 +914,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 
 		if (!(bio->bi_rw & REQ_DISCARD) ||
 		    blk_queue_discard(bdev_get_queue(dc->bdev)))
-			closure_bio_submit(bio, cl, s->d);
+			closure_bio_submit(bio, cl);
 	} else if (s->iop.writeback) {
 		bch_writeback_add(dc);
 		s->iop.bio = bio;
@@ -929,12 +929,12 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 			flush->bi_end_io = request_endio;
 			flush->bi_private = cl;
 
-			closure_bio_submit(flush, cl, s->d);
+			closure_bio_submit(flush, cl);
 		}
 	} else {
 		s->iop.bio = bio_clone_fast(bio, GFP_NOIO, dc->disk.bio_split);
 
-		closure_bio_submit(bio, cl, s->d);
+		closure_bio_submit(bio, cl);
 	}
 
 	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
@@ -950,7 +950,7 @@ static void cached_dev_nodata(struct closure *cl)
 		bch_journal_meta(s->iop.c, cl);
 
 	/* If it's a flush, we send the flush to the backing device too */
-	closure_bio_submit(bio, cl, s->d);
+	closure_bio_submit(bio, cl);
 
 	continue_at(cl, cached_dev_bio_complete, NULL);
 }
@@ -994,7 +994,7 @@ static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
 		    !blk_queue_discard(bdev_get_queue(dc->bdev)))
 			bio_endio(bio, 0);
 		else
-			bch_generic_make_request(bio, &d->bio_split_hook);
+			generic_make_request(bio);
 	}
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 94980bf..db70c9e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -59,29 +59,6 @@ struct workqueue_struct *bcache_wq;
 
 #define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
 
-static void bio_split_pool_free(struct bio_split_pool *p)
-{
-	if (p->bio_split_hook)
-		mempool_destroy(p->bio_split_hook);
-
-	if (p->bio_split)
-		bioset_free(p->bio_split);
-}
-
-static int bio_split_pool_init(struct bio_split_pool *p)
-{
-	p->bio_split = bioset_create(4, 0);
-	if (!p->bio_split)
-		return -ENOMEM;
-
-	p->bio_split_hook = mempool_create_kmalloc_pool(4,
-				sizeof(struct bio_split_hook));
-	if (!p->bio_split_hook)
-		return -ENOMEM;
-
-	return 0;
-}
-
 /* Superblock */
 
 static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
@@ -537,7 +514,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, unsigned long rw)
 	bio->bi_private = ca;
 	bch_bio_map(bio, ca->disk_buckets);
 
-	closure_bio_submit(bio, &ca->prio, ca);
+	closure_bio_submit(bio, &ca->prio);
 	closure_sync(cl);
 }
 
@@ -757,7 +734,6 @@ static void bcache_device_free(struct bcache_device *d)
 		put_disk(d->disk);
 	}
 
-	bio_split_pool_free(&d->bio_split_hook);
 	if (d->bio_split)
 		bioset_free(d->bio_split);
 	kvfree(d->full_dirty_stripes);
@@ -804,7 +780,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 		return minor;
 
 	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
-	    bio_split_pool_init(&d->bio_split_hook) ||
 	    !(d->disk = alloc_disk(1))) {
 		ida_simple_remove(&bcache_minor, minor);
 		return -ENOMEM;
@@ -1793,8 +1768,6 @@ void bch_cache_release(struct kobject *kobj)
 		ca->set->cache[ca->sb.nr_this_dev] = NULL;
 	}
 
-	bio_split_pool_free(&ca->bio_split_hook);
-
 	free_pages((unsigned long) ca->disk_buckets, ilog2(bucket_pages(ca)));
 	kfree(ca->prio_buckets);
 	vfree(ca->buckets);
@@ -1839,8 +1812,7 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 					  ca->sb.nbuckets)) ||
 	    !(ca->prio_buckets	= kzalloc(sizeof(uint64_t) * prio_buckets(ca) *
 					  2, GFP_KERNEL)) ||
-	    !(ca->disk_buckets	= alloc_bucket_pages(GFP_KERNEL, ca)) ||
-	    bio_split_pool_init(&ca->bio_split_hook))
+	    !(ca->disk_buckets	= alloc_bucket_pages(GFP_KERNEL, ca)))
 		return -ENOMEM;
 
 	ca->prio_last_buckets = ca->prio_buckets + prio_buckets(ca);
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 1d04c48..cf2cbc2 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -4,6 +4,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/errno.h>
+#include <linux/blkdev.h>
 #include <linux/kernel.h>
 #include <linux/llist.h>
 #include <linux/ratelimit.h>
@@ -570,10 +571,10 @@ static inline sector_t bdev_sectors(struct block_device *bdev)
 	return bdev->bd_inode->i_size >> 9;
 }
 
-#define closure_bio_submit(bio, cl, dev)				\
+#define closure_bio_submit(bio, cl)					\
 do {									\
 	closure_get(cl);						\
-	bch_generic_make_request(bio, &(dev)->bio_split_hook);		\
+	generic_make_request(bio);					\
 } while (0)
 
 uint64_t bch_crc64_update(uint64_t, const void *, size_t);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index f1986bc..ca38362 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -188,7 +188,7 @@ static void write_dirty(struct closure *cl)
 	io->bio.bi_bdev		= io->dc->bdev;
 	io->bio.bi_end_io	= dirty_endio;
 
-	closure_bio_submit(&io->bio, cl, &io->dc->disk);
+	closure_bio_submit(&io->bio, cl);
 
 	continue_at(cl, write_dirty_finish, system_wq);
 }
@@ -208,7 +208,7 @@ static void read_dirty_submit(struct closure *cl)
 {
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
 
-	closure_bio_submit(&io->bio, cl, &io->dc->disk);
+	closure_bio_submit(&io->bio, cl);
 
 	continue_at(cl, write_dirty, system_wq);
 }
-- 
2.1.4
