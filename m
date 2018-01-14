From: Coly Li <colyli@suse.de>
Subject: [PATCH v3 08/13] bcache: add CACHE_SET_IO_DISABLE to struct cache_set flags
Date: Sun, 14 Jan 2018 22:42:31 +0800
Message-ID: <20180114144236.28213-9-colyli@suse.de>
References: <20180114144236.28213-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751709AbeANOoG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 Jan 2018 09:44:06 -0500
In-Reply-To: <20180114144236.28213-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>, Michael Lyle <mlyle@lyle.org>, Pavel Vazharov <freakpv@gmail.com>

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
threads and self-armed kernel worker can stop very fast when flags bit
CACHE_SET_IO_DISABLE is set.

Because bcache also do internal I/Os for writeback, garbage collection,
bucket allocation, journaling, this kind of I/O should be disabled after
bch_cache_set_error() is called. So closure_bio_submit() is modified to
check whether CACHE_SET_IO_DISABLE is set on cache_set->flags. If set,
closure_bio_submit() will set bio->bi_status to BLK_STS_IOERR and
return, generic_make_request() won't be called.

A sysfs interface is also added to set or clear CACHE_SET_IO_DISABLE bit
from cache_set->flags, to disable or enable cache set I/O for debugging. It
is helpful to trigger more corner case issues for failed cache device.

Changelog
v2, more changes by previous review,
- Use CACHE_SET_IO_DISABLE of cache_set->flags, suggested by Junhui.
- Check CACHE_SET_IO_DISABLE in bch_btree_gc() to stop a while-loop, this
  is reported and inspired from origal patch of Pavel Vazharov.
v1, initial version.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Pavel Vazharov <freakpv@gmail.com>
---
 drivers/md/bcache/alloc.c     |  3 ++-
 drivers/md/bcache/bcache.h    | 18 ++++++++++++++++++
 drivers/md/bcache/btree.c     | 10 +++++++---
 drivers/md/bcache/io.c        |  2 +-
 drivers/md/bcache/journal.c   |  4 ++--
 drivers/md/bcache/request.c   | 26 +++++++++++++++++++-------
 drivers/md/bcache/super.c     |  6 +++++-
 drivers/md/bcache/sysfs.c     | 20 ++++++++++++++++++++
 drivers/md/bcache/util.h      |  6 ------
 drivers/md/bcache/writeback.c | 35 +++++++++++++++++++++++++++--------
 10 files changed, 101 insertions(+), 29 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 458e1d38577d..004cc3cc6123 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -287,7 +287,8 @@ do {									\
 			break;						\
 									\
 		mutex_unlock(&(ca)->set->bucket_lock);			\
-		if (kthread_should_stop()) {				\
+		if (kthread_should_stop() ||				\
+		    test_bit(CACHE_SET_IO_DISABLE, &ca->set->flags)) {	\
 			set_current_state(TASK_RUNNING);		\
 			return 0;					\
 		}							\
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 7d7512fa4f09..c41736960045 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -475,10 +475,15 @@ struct gc_stat {
  *
  * CACHE_SET_RUNNING means all cache devices have been registered and journal
  * replay is complete.
+ *
+ * CACHE_SET_IO_DISABLE is set when bcache is stopping the whold cache set, all
+ * external and internal I/O should be denied when this flag is set.
+ *
  */
 #define CACHE_SET_UNREGISTERING		0
 #define	CACHE_SET_STOPPING		1
 #define	CACHE_SET_RUNNING		2
+#define CACHE_SET_IO_DISABLE		4
 
 struct cache_set {
 	struct closure		cl;
@@ -862,6 +867,19 @@ static inline void wake_up_allocators(struct cache_set *c)
 		wake_up_process(ca->alloc_thread);
 }
 
+static inline void closure_bio_submit(struct cache_set *c,
+				      struct bio *bio,
+				      struct closure *cl)
+{
+	closure_get(cl);
+	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
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
index bf3a48aa9a9a..0a0bc63011b4 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1744,6 +1744,7 @@ static void bch_btree_gc(struct cache_set *c)
 
 	btree_gc_start(c);
 
+	/* if CACHE_SET_IO_DISABLE set, gc thread should stop too */
 	do {
 		ret = btree_root(gc_root, c, &op, &writes, &stats);
 		closure_sync(&writes);
@@ -1751,7 +1752,7 @@ static void bch_btree_gc(struct cache_set *c)
 
 		if (ret && ret != -EAGAIN)
 			pr_warn("gc failed!");
-	} while (ret);
+	} while (ret && !test_bit(CACHE_SET_IO_DISABLE, &c->flags));
 
 	bch_btree_gc_finish(c);
 	wake_up_allocators(c);
@@ -1789,9 +1790,12 @@ static int bch_gc_thread(void *arg)
 
 	while (1) {
 		wait_event_interruptible(c->gc_wait,
-			   kthread_should_stop() || gc_should_run(c));
+			   kthread_should_stop() ||
+			   test_bit(CACHE_SET_IO_DISABLE, &c->flags) ||
+			   gc_should_run(c));
 
-		if (kthread_should_stop())
+		if (kthread_should_stop() ||
+		    test_bit(CACHE_SET_IO_DISABLE, &c->flags))
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
index 1a46b41dac70..02296bda6384 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -747,7 +747,7 @@ static void cached_dev_read_error(struct closure *cl)
 
 		/* XXX: invalidate cache */
 
-		closure_bio_submit(bio, cl);
+		closure_bio_submit(s->iop.c, bio, cl);
 	}
 
 	continue_at(cl, cached_dev_cache_miss_done, NULL);
@@ -872,7 +872,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	s->cache_miss	= miss;
 	s->iop.bio	= cache_bio;
 	bio_get(cache_bio);
-	closure_bio_submit(cache_bio, &s->cl);
+	closure_bio_submit(s->iop.c, cache_bio, &s->cl);
 
 	return ret;
 out_put:
@@ -880,7 +880,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 out_submit:
 	miss->bi_end_io		= request_endio;
 	miss->bi_private	= &s->cl;
-	closure_bio_submit(miss, &s->cl);
+	closure_bio_submit(s->iop.c, miss, &s->cl);
 	return ret;
 }
 
@@ -945,7 +945,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 
 		if ((bio_op(bio) != REQ_OP_DISCARD) ||
 		    blk_queue_discard(bdev_get_queue(dc->bdev)))
-			closure_bio_submit(bio, cl);
+			closure_bio_submit(s->iop.c, bio, cl);
 	} else if (s->iop.writeback) {
 		bch_writeback_add(dc);
 		s->iop.bio = bio;
@@ -960,12 +960,12 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
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
@@ -981,7 +981,7 @@ static void cached_dev_nodata(struct closure *cl)
 		bch_journal_meta(s->iop.c, cl);
 
 	/* If it's a flush, we send the flush to the backing device too */
-	closure_bio_submit(bio, cl);
+	closure_bio_submit(s->iop.c, bio, cl);
 
 	continue_at(cl, cached_dev_bio_complete, NULL);
 }
@@ -996,6 +996,12 @@ static blk_qc_t cached_dev_make_request(struct request_queue *q,
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
 	int rw = bio_data_dir(bio);
 
+	if (unlikely(d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags))) {
+		bio->bi_status = BLK_STS_IOERR;
+		bio_endio(bio);
+		return BLK_QC_T_NONE;
+	}
+
 	atomic_set(&dc->backing_idle, 0);
 	generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
 
@@ -1112,6 +1118,12 @@ static blk_qc_t flash_dev_make_request(struct request_queue *q,
 	struct bcache_device *d = bio->bi_disk->private_data;
 	int rw = bio_data_dir(bio);
 
+	if (unlikely(d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags))) {
+		bio->bi_status = BLK_STS_IOERR;
+		bio_endio(bio);
+		return BLK_QC_T_NONE;
+	}
+
 	generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
 
 	s = search_alloc(bio, d);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a373648b5d4b..4204d75aee7b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -521,7 +521,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, int op,
 	bio_set_op_attrs(bio, op, REQ_SYNC|REQ_META|op_flags);
 	bch_bio_map(bio, ca->disk_buckets);
 
-	closure_bio_submit(bio, &ca->prio);
+	closure_bio_submit(ca->set, bio, &ca->prio);
 	closure_sync(cl);
 }
 
@@ -1349,6 +1349,9 @@ bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...)
 	    test_bit(CACHE_SET_STOPPING, &c->flags))
 		return false;
 
+	if (test_and_set_bit(CACHE_SET_IO_DISABLE, &c->flags))
+		pr_warn("bcache: CACHE_SET_IO_DISABLE already set");
+
 	/* XXX: we can be called from atomic context
 	acquire_console_sem();
 	*/
@@ -1584,6 +1587,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	c->congested_read_threshold_us	= 2000;
 	c->congested_write_threshold_us	= 20000;
 	c->error_limit	= DEFAULT_IO_ERROR_LIMIT;
+	WARN_ON(test_and_clear_bit(CACHE_SET_IO_DISABLE, &c->flags));
 
 	return c;
 err:
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index ba62e987b503..afb051bcfca1 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -92,6 +92,7 @@ read_attribute(partial_stripes_expensive);
 
 rw_attribute(synchronous);
 rw_attribute(journal_delay_ms);
+rw_attribute(io_disable);
 rw_attribute(discard);
 rw_attribute(running);
 rw_attribute(label);
@@ -577,6 +578,8 @@ SHOW(__bch_cache_set)
 	sysfs_printf(gc_always_rewrite,		"%i", c->gc_always_rewrite);
 	sysfs_printf(btree_shrinker_disabled,	"%i", c->shrinker_disabled);
 	sysfs_printf(copy_gc_enabled,		"%i", c->copy_gc_enabled);
+	sysfs_printf(io_disable,		"%i",
+		     test_bit(CACHE_SET_IO_DISABLE, &c->flags));
 
 	if (attr == &sysfs_bset_tree_stats)
 		return bch_bset_print_stats(c, buf);
@@ -666,6 +669,22 @@ STORE(__bch_cache_set)
 	if (attr == &sysfs_io_error_halflife)
 		c->error_decay = strtoul_or_return(buf) / 88;
 
+	if (attr == &sysfs_io_disable) {
+		int v = strtoul_or_return(buf);
+
+		if (v) {
+			if (test_and_set_bit(CACHE_SET_IO_DISABLE,
+					     &c->flags))
+				pr_warn("bcache: CACHE_SET_IO_DISABLE"
+					" already set");
+		} else {
+			if (!test_and_clear_bit(CACHE_SET_IO_DISABLE,
+						&c->flags))
+				pr_warn("bcache: CACHE_SET_IO_DISABLE"
+					" already cleared");
+		}
+	}
+
 	sysfs_strtoul(journal_delay_ms,		c->journal_delay_ms);
 	sysfs_strtoul(verify,			c->verify);
 	sysfs_strtoul(key_merging_disabled,	c->key_merging_disabled);
@@ -748,6 +767,7 @@ static struct attribute *bch_cache_set_internal_files[] = {
 	&sysfs_gc_always_rewrite,
 	&sysfs_btree_shrinker_disabled,
 	&sysfs_copy_gc_enabled,
+	&sysfs_io_disable,
 	NULL
 };
 KTYPE(bch_cache_set_internal);
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 4df4c5c1cab2..7944eea54fa9 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -565,12 +565,6 @@ static inline sector_t bdev_sectors(struct block_device *bdev)
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
index 8f98ef1038d3..3d7d8452e0de 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -114,6 +114,7 @@ static void update_writeback_rate(struct work_struct *work)
 	struct cached_dev *dc = container_of(to_delayed_work(work),
 					     struct cached_dev,
 					     writeback_rate_update);
+	struct cache_set *c = dc->disk.c;
 
 	/*
 	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
@@ -123,7 +124,12 @@ static void update_writeback_rate(struct work_struct *work)
 	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
 	smp_mb();
 
-	if (!test_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags)) {
+	/*
+	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
+	 * check it here too.
+	 */
+	if (!test_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags) ||
+	    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
 		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
 		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
 		smp_mb();
@@ -138,7 +144,12 @@ static void update_writeback_rate(struct work_struct *work)
 
 	up_read(&dc->writeback_lock);
 
-	if (test_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags)) {
+	/*
+	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
+	 * check it here too.
+	 */
+	if (test_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags) &&
+	    !test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
 		schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
 	}
@@ -278,7 +289,7 @@ static void write_dirty(struct closure *cl)
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
 
-		closure_bio_submit(&io->bio, cl);
+		closure_bio_submit(io->dc->disk.c, &io->bio, cl);
 	}
 
 	atomic_set(&dc->writeback_sequence_next, next_sequence);
@@ -304,7 +315,7 @@ static void read_dirty_submit(struct closure *cl)
 {
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
 
-	closure_bio_submit(&io->bio, cl);
+	closure_bio_submit(io->dc->disk.c, &io->bio, cl);
 
 	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
 }
@@ -330,7 +341,9 @@ static void read_dirty(struct cached_dev *dc)
 
 	next = bch_keybuf_next(&dc->writeback_keys);
 
-	while (!kthread_should_stop() && next) {
+	while (!kthread_should_stop() &&
+	       !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
+	       next) {
 		size = 0;
 		nk = 0;
 
@@ -427,7 +440,9 @@ static void read_dirty(struct cached_dev *dc)
 			}
 		}
 
-		while (!kthread_should_stop() && delay) {
+		while (!kthread_should_stop() &&
+		       !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
+		       delay) {
 			schedule_timeout_interruptible(delay);
 			delay = writeback_delay(dc, 0);
 		}
@@ -583,11 +598,13 @@ static bool refill_dirty(struct cached_dev *dc)
 static int bch_writeback_thread(void *arg)
 {
 	struct cached_dev *dc = arg;
+	struct cache_set *c = dc->disk.c;
 	bool searched_full_index;
 
 	bch_ratelimit_reset(&dc->writeback_rate);
 
-	while (!kthread_should_stop()) {
+	while (!kthread_should_stop() &&
+	       !test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
 		down_write(&dc->writeback_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
 		/*
@@ -601,7 +618,8 @@ static int bch_writeback_thread(void *arg)
 		    (!atomic_read(&dc->has_dirty) || !dc->writeback_running)) {
 			up_write(&dc->writeback_lock);
 
-			if (kthread_should_stop()) {
+			if (kthread_should_stop() ||
+			    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
 				set_current_state(TASK_RUNNING);
 				break;
 			}
@@ -637,6 +655,7 @@ static int bch_writeback_thread(void *arg)
 
 			while (delay &&
 			       !kthread_should_stop() &&
+			       !test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
 			       !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
 				delay = schedule_timeout_interruptible(delay);
 
-- 
2.15.1
