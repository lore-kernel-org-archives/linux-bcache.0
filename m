From: Coly Li <colyli@suse.de>
Subject: [PATCH v1 09/10] bcache: add io_disable to struct cache_set
Date: Wed,  3 Jan 2018 22:03:24 +0800
Message-ID: <20180103140325.63175-10-colyli@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180103140325.63175-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

When too many I/Os failed on cache device, bch_cache_set_error() is called
in the error handling code path to retire whole problematic cache set. If
new I/O requests continue to come and take refcount dc->count, the cache
set won't be retired immediately, this is a problem.

Further more, there are several kernel thread and self-armed kernel work
may still running after bch_cache_set_error() is called. It needs to wait
quite a while for them to stop, or they won't stop at all. They also
prevent the cache set from being retired.

The solution in this patch is, to add per cache set flag to disable I/O
request on this cache and all attached backing devices. Then new coming I/O
requests can be rejected in *_make_request() before taking refcount, kernel
threads and self-armed kernel worker can stop very fast when io_disable is
true.

Because bcache also do internal I/Os for writeback, garbage collection,
bucket allocation, journaling, this kind of I/O should be disabled after
bch_cache_set_error() is called. So closure_bio_submit() is modified to
check whether cache_set->io_disable is true. If cache_set->io_disable is
true, closure_bio_submit() will set bio->bi_status to BLK_STS_IOERR and
return, generic_make_request() won't be called.

A sysfs interface is also added for cache_set->io_disable, to read and set
io_disable value for debugging. It is helpful to trigger more corner case
issues for failed cache device.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/alloc.c     |  2 +-
 drivers/md/bcache/bcache.h    | 14 ++++++++++++++
 drivers/md/bcache/btree.c     |  6 ++++--
 drivers/md/bcache/io.c        |  2 +-
 drivers/md/bcache/journal.c   |  4 ++--
 drivers/md/bcache/request.c   | 26 +++++++++++++++++++-------
 drivers/md/bcache/super.c     |  7 ++++++-
 drivers/md/bcache/sysfs.c     |  4 ++++
 drivers/md/bcache/util.h      |  6 ------
 drivers/md/bcache/writeback.c | 34 ++++++++++++++++++++++------------
 10 files changed, 73 insertions(+), 32 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 48c002faf08d..3be737582f27 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -286,7 +286,7 @@ do {									\
 			break;						\
 									\
 		mutex_unlock(&(ca)->set->bucket_lock);			\
-		if (kthread_should_stop())				\
+		if (kthread_should_stop() || ca->set->io_disable)	\
 			return 0;					\
 									\
 		set_current_state(TASK_INTERRUPTIBLE);			\
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index c53f312b2216..9c7f9b1cb791 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -481,6 +481,7 @@ struct cache_set {
 	struct cache_accounting accounting;
 
 	unsigned long		flags;
+	bool			io_disable;
 
 	struct cache_sb		sb;
 
@@ -853,6 +854,19 @@ static inline void wake_up_allocators(struct cache_set *c)
 		wake_up_process(ca->alloc_thread);
 }
 
+static inline void closure_bio_submit(struct cache_set *c,
+				      struct bio *bio,
+				      struct closure *cl)
+{
+	closure_get(cl);
+	if (unlikely(c->io_disable)) {
+		bio->bi_status = BLK_STS_IOERR;
+		bio_endio(bio);
+		return;
+	}
+	generic_make_request(bio);
+}
+
 /* Forward declarations */
 
 void bch_count_io_errors(struct cache *, blk_status_t, int, const char *);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index bf0d7978bc3d..75470cce1177 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1788,9 +1788,11 @@ static int bch_gc_thread(void *arg)
 
 	while (1) {
 		wait_event_interruptible(c->gc_wait,
-			   kthread_should_stop() || gc_should_run(c));
+					kthread_should_stop() ||
+					c->io_disable ||
+					gc_should_run(c));
 
-		if (kthread_should_stop())
+		if (kthread_should_stop() || c->io_disable)
 			break;
 
 		set_gc_sectors(c);
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index a783c5a41ff1..8013ecbcdbda 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -38,7 +38,7 @@ void __bch_submit_bbio(struct bio *bio, struct cache_set *c)
 	bio_set_dev(bio, PTR_CACHE(c, &b->key, 0)->bdev);
 
 	b->submit_time_us = local_clock_us();
-	closure_bio_submit(bio, bio->bi_private);
+	closure_bio_submit(c, bio, bio->bi_private);
 }
 
 void bch_submit_bbio(struct bio *bio, struct cache_set *c,
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index a87165c1d8e5..979873641030 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -62,7 +62,7 @@ reread:		left = ca->sb.bucket_size - offset;
 		bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		bch_bio_map(bio, data);
 
-		closure_bio_submit(bio, &cl);
+		closure_bio_submit(ca->set, bio, &cl);
 		closure_sync(&cl);
 
 		/* This function could be simpler now since we no longer write
@@ -653,7 +653,7 @@ static void journal_write_unlocked(struct closure *cl)
 	spin_unlock(&c->journal.lock);
 
 	while ((bio = bio_list_pop(&list)))
-		closure_bio_submit(bio, cl);
+		closure_bio_submit(c, bio, cl);
 
 	continue_at(cl, journal_write_done, NULL);
 }
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 643c3021624f..a85d6a605a8e 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -725,7 +725,7 @@ static void cached_dev_read_error(struct closure *cl)
 
 		/* XXX: invalidate cache */
 
-		closure_bio_submit(bio, cl);
+		closure_bio_submit(s->iop.c, bio, cl);
 	}
 
 	continue_at(cl, cached_dev_cache_miss_done, NULL);
@@ -850,7 +850,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	s->cache_miss	= miss;
 	s->iop.bio	= cache_bio;
 	bio_get(cache_bio);
-	closure_bio_submit(cache_bio, &s->cl);
+	closure_bio_submit(s->iop.c, cache_bio, &s->cl);
 
 	return ret;
 out_put:
@@ -858,7 +858,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 out_submit:
 	miss->bi_end_io		= request_endio;
 	miss->bi_private	= &s->cl;
-	closure_bio_submit(miss, &s->cl);
+	closure_bio_submit(s->iop.c, miss, &s->cl);
 	return ret;
 }
 
@@ -923,7 +923,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 
 		if ((bio_op(bio) != REQ_OP_DISCARD) ||
 		    blk_queue_discard(bdev_get_queue(dc->bdev)))
-			closure_bio_submit(bio, cl);
+			closure_bio_submit(s->iop.c, bio, cl);
 	} else if (s->iop.writeback) {
 		bch_writeback_add(dc);
 		s->iop.bio = bio;
@@ -938,12 +938,12 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 			flush->bi_private = cl;
 			flush->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 
-			closure_bio_submit(flush, cl);
+			closure_bio_submit(s->iop.c, flush, cl);
 		}
 	} else {
 		s->iop.bio = bio_clone_fast(bio, GFP_NOIO, dc->disk.bio_split);
 
-		closure_bio_submit(bio, cl);
+		closure_bio_submit(s->iop.c, bio, cl);
 	}
 
 	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
@@ -959,7 +959,7 @@ static void cached_dev_nodata(struct closure *cl)
 		bch_journal_meta(s->iop.c, cl);
 
 	/* If it's a flush, we send the flush to the backing device too */
-	closure_bio_submit(bio, cl);
+	closure_bio_submit(s->iop.c, bio, cl);
 
 	continue_at(cl, cached_dev_bio_complete, NULL);
 }
@@ -974,6 +974,12 @@ static blk_qc_t cached_dev_make_request(struct request_queue *q,
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
 	int rw = bio_data_dir(bio);
 
+	if (unlikely(d->c && d->c->io_disable)) {
+		bio->bi_status = BLK_STS_IOERR;
+		bio_endio(bio);
+		return BLK_QC_T_NONE;
+	}
+
 	generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
 
 	bio_set_dev(bio, dc->bdev);
@@ -1089,6 +1095,12 @@ static blk_qc_t flash_dev_make_request(struct request_queue *q,
 	struct bcache_device *d = bio->bi_disk->private_data;
 	int rw = bio_data_dir(bio);
 
+	if (unlikely(d->c->io_disable)) {
+		bio->bi_status = BLK_STS_IOERR;
+		bio_endio(bio);
+		return BLK_QC_T_NONE;
+	}
+
 	generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
 
 	s = search_alloc(bio, d);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index bbe911847eea..7aa76c3e3556 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -521,7 +521,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, int op,
 	bio_set_op_attrs(bio, op, REQ_SYNC|REQ_META|op_flags);
 	bch_bio_map(bio, ca->disk_buckets);
 
-	closure_bio_submit(bio, &ca->prio);
+	closure_bio_submit(ca->set, bio, &ca->prio);
 	closure_sync(cl);
 }
 
@@ -1333,6 +1333,10 @@ bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...)
 	acquire_console_sem();
 	*/
 
+	c->io_disable = true;
+	/* make others know io_disable is true earlier */
+	smp_mb();
+
 	printk(KERN_ERR "bcache: error on %pU: ", c->sb.set_uuid);
 
 	va_start(args, fmt);
@@ -1564,6 +1568,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	c->congested_read_threshold_us	= 2000;
 	c->congested_write_threshold_us	= 20000;
 	c->error_limit	= DEFAULT_IO_ERROR_LIMIT;
+	c->io_disable = false;
 
 	return c;
 err:
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index d7ce9a05b304..acce7c82e111 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -92,6 +92,7 @@ read_attribute(partial_stripes_expensive);
 
 rw_attribute(synchronous);
 rw_attribute(journal_delay_ms);
+rw_attribute(io_disable);
 rw_attribute(discard);
 rw_attribute(running);
 rw_attribute(label);
@@ -573,6 +574,7 @@ SHOW(__bch_cache_set)
 	sysfs_printf(gc_always_rewrite,		"%i", c->gc_always_rewrite);
 	sysfs_printf(btree_shrinker_disabled,	"%i", c->shrinker_disabled);
 	sysfs_printf(copy_gc_enabled,		"%i", c->copy_gc_enabled);
+	sysfs_printf(io_disable,		"%i", c->io_disable);
 
 	if (attr == &sysfs_bset_tree_stats)
 		return bch_bset_print_stats(c, buf);
@@ -663,6 +665,7 @@ STORE(__bch_cache_set)
 		c->error_decay = strtoul_or_return(buf) / 88;
 
 	sysfs_strtoul(journal_delay_ms,		c->journal_delay_ms);
+	sysfs_strtoul_clamp(io_disable,		c->io_disable, 0, 1);
 	sysfs_strtoul(verify,			c->verify);
 	sysfs_strtoul(key_merging_disabled,	c->key_merging_disabled);
 	sysfs_strtoul(expensive_debug_checks,	c->expensive_debug_checks);
@@ -744,6 +747,7 @@ static struct attribute *bch_cache_set_internal_files[] = {
 	&sysfs_gc_always_rewrite,
 	&sysfs_btree_shrinker_disabled,
 	&sysfs_copy_gc_enabled,
+	&sysfs_io_disable,
 	NULL
 };
 KTYPE(bch_cache_set_internal);
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index ed5e8a412eb8..03e533631798 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -564,12 +564,6 @@ static inline sector_t bdev_sectors(struct block_device *bdev)
 	return bdev->bd_inode->i_size >> 9;
 }
 
-#define closure_bio_submit(bio, cl)					\
-do {									\
-	closure_get(cl);						\
-	generic_make_request(bio);					\
-} while (0)
-
 uint64_t bch_crc64_update(uint64_t, const void *, size_t);
 uint64_t bch_crc64(const void *, size_t);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index e58f9be5ae43..54add41d2569 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -93,8 +93,11 @@ static void update_writeback_rate(struct work_struct *work)
 					     writeback_rate_update);
 	struct cache_set *c = dc->disk.c;
 
-	/* quit directly if cache set is stopping */
-	if (test_bit(CACHE_SET_STOPPING, &c->flags))
+	/*
+	 * quit directly if cache set is stopping. c->io_disable
+	 * can be set via sysfs, check it here too.
+	 */
+	if (test_bit(CACHE_SET_STOPPING, &c->flags) || c->io_disable)
 		return;
 
 	down_read(&dc->writeback_lock);
@@ -105,8 +108,11 @@ static void update_writeback_rate(struct work_struct *work)
 
 	up_read(&dc->writeback_lock);
 
-	/* do not schedule delayed work if cache set is stopping */
-	if (test_bit(CACHE_SET_STOPPING, &c->flags))
+	/*
+	 * do not schedule delayed work if cache set is stopping,
+	 * c->io_disable can be set via sysfs, check it here too.
+	 */
+	if (test_bit(CACHE_SET_STOPPING, &c->flags) || c->io_disable)
 		return;
 
 	schedule_delayed_work(&dc->writeback_rate_update,
@@ -217,7 +223,7 @@ static void write_dirty(struct closure *cl)
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
 
-		closure_bio_submit(&io->bio, cl);
+		closure_bio_submit(io->dc->disk.c, &io->bio, cl);
 	}
 
 	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
@@ -240,7 +246,7 @@ static void read_dirty_submit(struct closure *cl)
 {
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
 
-	closure_bio_submit(&io->bio, cl);
+	closure_bio_submit(io->dc->disk.c, &io->bio, cl);
 
 	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
 }
@@ -259,7 +265,7 @@ static void read_dirty(struct cached_dev *dc)
 	 * mempools.
 	 */
 
-	while (!kthread_should_stop()) {
+	while (!(kthread_should_stop() || dc->disk.c->io_disable)) {
 
 		w = bch_keybuf_next(&dc->writeback_keys);
 		if (!w)
@@ -269,7 +275,9 @@ static void read_dirty(struct cached_dev *dc)
 
 		if (KEY_START(&w->key) != dc->last_read ||
 		    jiffies_to_msecs(delay) > 50)
-			while (!kthread_should_stop() && delay)
+			while (!kthread_should_stop() &&
+			       !dc->disk.c->io_disable &&
+			       delay)
 				delay = schedule_timeout_interruptible(delay);
 
 		dc->last_read	= KEY_OFFSET(&w->key);
@@ -450,18 +458,19 @@ static bool refill_dirty(struct cached_dev *dc)
 static int bch_writeback_thread(void *arg)
 {
 	struct cached_dev *dc = arg;
+	struct cache_set *c = dc->disk.c;
 	bool searched_full_index;
 
 	bch_ratelimit_reset(&dc->writeback_rate);
 
-	while (!kthread_should_stop()) {
+	while (!(kthread_should_stop() || c->io_disable)) {
 		down_write(&dc->writeback_lock);
 		if (!atomic_read(&dc->has_dirty) ||
 		    (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
 		     !dc->writeback_running)) {
 			up_write(&dc->writeback_lock);
 
-			if (kthread_should_stop())
+			if (kthread_should_stop() || c->io_disable)
 				break;
 
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -485,8 +494,8 @@ static int bch_writeback_thread(void *arg)
 		if (searched_full_index) {
 			unsigned delay = dc->writeback_delay * HZ;
 
-			while (delay &&
-			       !kthread_should_stop() &&
+			while (delay && !kthread_should_stop() &&
+			       !c->io_disable &&
 			       !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
 				delay = schedule_timeout_interruptible(delay);
 
@@ -494,6 +503,7 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
+	dc->writeback_thread = NULL;
 	cached_dev_put(dc);
 
 	return 0;
-- 
2.15.1
