From: Coly Li <colyli@suse.de>
Subject: [PATCH v4 11/13] bcache: add io_disable to struct cached_dev
Date: Sun, 28 Jan 2018 09:56:23 +0800
Message-ID: <20180128015625.128497-12-colyli@suse.de>
References: <20180128015625.128497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180128015625.128497-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>
List-Id: linux-bcache@vger.kernel.org

If a bcache device is configured to writeback mode, current code does not
handle write I/O errors on backing devices properly.

In writeback mode, write request is written to cache device, and
latter being flushed to backing device. If I/O failed when writing from
cache device to the backing device, bcache code just ignores the error and
upper layer code is NOT noticed that the backing device is broken.

This patch tries to handle backing device failure like how the cache device
failure is handled,
- Add a error counter 'io_errors' and error limit 'error_limit' in struct
  cached_dev. Add another io_disable to struct cached_dev to disable I/Os
  on the problematic backing device.
- When I/O error happens on backing device, increase io_errors counter. And
  if io_errors reaches error_limit, set cache_dev->io_disable to true, and
  stop the bcache device.

The result is, if backing device is broken of disconnected, and I/O errors
reach its error limit, backing device will be disabled and the associated
bcache device will be removed from system.

Changelog:
v2: indeed this is new added in v2 patch set.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/bcache.h  |  7 +++++++
 drivers/md/bcache/io.c      | 14 ++++++++++++++
 drivers/md/bcache/request.c | 14 ++++++++++++--
 drivers/md/bcache/super.c   | 22 ++++++++++++++++++++++
 drivers/md/bcache/sysfs.c   | 15 ++++++++++++++-
 5 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index c41736960045..5a811959392d 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -360,6 +360,7 @@ struct cached_dev {
 	unsigned		sequential_cutoff;
 	unsigned		readahead;
 
+	unsigned		io_disable:1;
 	unsigned		verify:1;
 	unsigned		bypass_torture_test:1;
 
@@ -379,6 +380,10 @@ struct cached_dev {
 	unsigned		writeback_rate_i_term_inverse;
 	unsigned		writeback_rate_p_term_inverse;
 	unsigned		writeback_rate_minimum;
+
+#define DEFAULT_CACHED_DEV_ERROR_LIMIT 64
+	atomic_t		io_errors;
+	unsigned		error_limit;
 };
 
 enum alloc_reserve {
@@ -882,6 +887,7 @@ static inline void closure_bio_submit(struct cache_set *c,
 
 /* Forward declarations */
 
+void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *bio);
 void bch_count_io_errors(struct cache *, blk_status_t, int, const char *);
 void bch_bbio_count_io_errors(struct cache_set *, struct bio *,
 			      blk_status_t, const char *);
@@ -909,6 +915,7 @@ int bch_bucket_alloc_set(struct cache_set *, unsigned,
 			 struct bkey *, int, bool);
 bool bch_alloc_sectors(struct cache_set *, struct bkey *, unsigned,
 		       unsigned, unsigned, bool);
+bool bch_cached_dev_error(struct cached_dev *dc);
 
 __printf(2, 3)
 bool bch_cache_set_error(struct cache_set *, const char *, ...);
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 8013ecbcdbda..7fac97ae036e 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -50,6 +50,20 @@ void bch_submit_bbio(struct bio *bio, struct cache_set *c,
 }
 
 /* IO errors */
+void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *bio)
+{
+	char buf[BDEVNAME_SIZE];
+	unsigned errors;
+
+	WARN_ONCE(!dc, "NULL pointer of struct cached_dev");
+
+	errors = atomic_add_return(1, &dc->io_errors);
+	if (errors < dc->error_limit)
+		pr_err("%s: IO error on backing device, unrecoverable",
+			bio_devname(bio, buf));
+	else
+		bch_cached_dev_error(dc);
+}
 
 void bch_count_io_errors(struct cache *ca,
 			 blk_status_t error,
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index ad4cf71f7eab..386b388ce296 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -637,6 +637,8 @@ static void backing_request_endio(struct bio *bio)
 
 	if (bio->bi_status) {
 		struct search *s = container_of(cl, struct search, cl);
+		struct cached_dev *dc = container_of(s->d,
+						     struct cached_dev, disk);
 		/*
 		 * If a bio has REQ_PREFLUSH for writeback mode, it is
 		 * speically assembled in cached_dev_write() for a non-zero
@@ -657,6 +659,7 @@ static void backing_request_endio(struct bio *bio)
 		}
 		s->recoverable = false;
 		/* should count I/O error for backing device here */
+		bch_count_backing_io_errors(dc, bio);
 	}
 
 	bio_put(bio);
@@ -1067,8 +1070,14 @@ static void detatched_dev_end_io(struct bio *bio)
 			    bio_data_dir(bio),
 			    &ddip->d->disk->part0, ddip->start_time);
 
-	kfree(ddip);
+	if (bio->bi_status) {
+		struct cached_dev *dc = container_of(ddip->d,
+						     struct cached_dev, disk);
+		/* should count I/O error for backing device here */
+		bch_count_backing_io_errors(dc, bio);
+	}
 
+	kfree(ddip);
 	bio->bi_end_io(bio);
 }
 
@@ -1107,7 +1116,8 @@ static blk_qc_t cached_dev_make_request(struct request_queue *q,
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
 	int rw = bio_data_dir(bio);
 
-	if (unlikely(d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags))) {
+	if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags)) ||
+		     dc->io_disable)) {
 		bio->bi_status = BLK_STS_IOERR;
 		bio_endio(bio);
 		return BLK_QC_T_NONE;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 08a0b541a4da..14fce3623770 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1188,6 +1188,10 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
 		max(dc->disk.disk->queue->backing_dev_info->ra_pages,
 		    q->backing_dev_info->ra_pages);
 
+	atomic_set(&dc->io_errors, 0);
+	dc->io_disable = false;
+	dc->error_limit = DEFAULT_CACHED_DEV_ERROR_LIMIT;
+
 	bch_cached_dev_request_init(dc);
 	bch_cached_dev_writeback_init(dc);
 	return 0;
@@ -1339,6 +1343,24 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 	return flash_dev_run(c, u);
 }
 
+bool bch_cached_dev_error(struct cached_dev *dc)
+{
+	char name[BDEVNAME_SIZE];
+
+	if (!dc || test_bit(BCACHE_DEV_CLOSING, &dc->disk.flags))
+		return false;
+
+	dc->io_disable = true;
+	/* make others know io_disable is true earlier */
+	smp_mb();
+
+	pr_err("bcache: stop %s: too many IO errors on backing device %s\n",
+		dc->disk.name, bdevname(dc->bdev, name));
+
+	bcache_device_stop(&dc->disk);
+	return true;
+}
+
 /* Cache set */
 
 __printf(2, 3)
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index afb051bcfca1..7288927f2a47 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -131,7 +131,9 @@ SHOW(__bch_cached_dev)
 	var_print(writeback_delay);
 	var_print(writeback_percent);
 	sysfs_hprint(writeback_rate,	dc->writeback_rate.rate << 9);
-
+	sysfs_hprint(io_errors,		atomic_read(&dc->io_errors));
+	sysfs_printf(io_error_limit,	"%i", dc->error_limit);
+	sysfs_printf(io_disable,	"%i", dc->io_disable);
 	var_print(writeback_rate_update_seconds);
 	var_print(writeback_rate_i_term_inverse);
 	var_print(writeback_rate_p_term_inverse);
@@ -223,6 +225,14 @@ STORE(__cached_dev)
 	d_strtoul(writeback_rate_i_term_inverse);
 	d_strtoul_nonzero(writeback_rate_p_term_inverse);
 
+	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
+
+	if (attr == &sysfs_io_disable) {
+		int v = strtoul_or_return(buf);
+
+		dc->io_disable = v ? 1 : 0;
+	}
+
 	d_strtoi_h(sequential_cutoff);
 	d_strtoi_h(readahead);
 
@@ -330,6 +340,9 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_writeback_rate_i_term_inverse,
 	&sysfs_writeback_rate_p_term_inverse,
 	&sysfs_writeback_rate_debug,
+	&sysfs_errors,
+	&sysfs_io_error_limit,
+	&sysfs_io_disable,
 	&sysfs_dirty_data,
 	&sysfs_stripe_size,
 	&sysfs_partial_stripes_expensive,
-- 
2.15.1
