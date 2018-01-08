From: Michael Lyle <mlyle@lyle.org>
Subject: [416 PATCH 12/13] bcache: fix misleading error message in bch_count_io_errors()
Date: Mon,  8 Jan 2018 12:21:29 -0800
Message-ID: <20180108202130.31303-13-mlyle@lyle.org>
References: <20180108202130.31303-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33238 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932936AbeAHUVz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jan 2018 15:21:55 -0500
Received: by mail-pg0-f67.google.com with SMTP id i196so6309533pgd.0
        for <linux-bcache@vger.kernel.org>; Mon, 08 Jan 2018 12:21:55 -0800 (PST)
In-Reply-To: <20180108202130.31303-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Coly Li <colyli@suse.de>

From: Coly Li <colyli@suse.de>

Bcache only does recoverable I/O for read operations by calling
cached_dev_read_error(). For write opertions there is no I/O recovery for
failed requests.

But in bch_count_io_errors() no matter read or write I/Os, before errors
counter reaches io error limit, pr_err() always prints "IO error on %,
recoverying". For write requests this information is misleading, because
there is no I/O recovery at all.

This patch adds a parameter 'is_read' to bch_count_io_errors(), and only
prints "recovering" by pr_err() when the bio direction is READ.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/bcache.h    |  2 +-
 drivers/md/bcache/io.c        | 13 +++++++++----
 drivers/md/bcache/super.c     |  4 +++-
 drivers/md/bcache/writeback.c |  4 +++-
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9117da5f494b..5e2d4e80198e 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -862,7 +862,7 @@ static inline void wake_up_allocators(struct cache_set *c)
 
 /* Forward declarations */
 
-void bch_count_io_errors(struct cache *, blk_status_t, const char *);
+void bch_count_io_errors(struct cache *, blk_status_t, int, const char *);
 void bch_bbio_count_io_errors(struct cache_set *, struct bio *,
 			      blk_status_t, const char *);
 void bch_bbio_endio(struct cache_set *, struct bio *, blk_status_t,
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index fac97ec2d0e2..a783c5a41ff1 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -51,7 +51,10 @@ void bch_submit_bbio(struct bio *bio, struct cache_set *c,
 
 /* IO errors */
 
-void bch_count_io_errors(struct cache *ca, blk_status_t error, const char *m)
+void bch_count_io_errors(struct cache *ca,
+			 blk_status_t error,
+			 int is_read,
+			 const char *m)
 {
 	/*
 	 * The halflife of an error is:
@@ -94,8 +97,9 @@ void bch_count_io_errors(struct cache *ca, blk_status_t error, const char *m)
 		errors >>= IO_ERROR_SHIFT;
 
 		if (errors < ca->set->error_limit)
-			pr_err("%s: IO error on %s, recovering",
-			       bdevname(ca->bdev, buf), m);
+			pr_err("%s: IO error on %s%s",
+			       bdevname(ca->bdev, buf), m,
+			       is_read ? ", recovering." : ".");
 		else
 			bch_cache_set_error(ca->set,
 					    "%s: too many IO errors %s",
@@ -108,6 +112,7 @@ void bch_bbio_count_io_errors(struct cache_set *c, struct bio *bio,
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct cache *ca = PTR_CACHE(c, &b->key, 0);
+	int is_read = (bio_data_dir(bio) == READ ? 1 : 0);
 
 	unsigned threshold = op_is_write(bio_op(bio))
 		? c->congested_write_threshold_us
@@ -129,7 +134,7 @@ void bch_bbio_count_io_errors(struct cache_set *c, struct bio *bio,
 			atomic_inc(&c->congested);
 	}
 
-	bch_count_io_errors(ca, error, m);
+	bch_count_io_errors(ca, error, is_read, m);
 }
 
 void bch_bbio_endio(struct cache_set *c, struct bio *bio,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d13e4ccb30a0..133b81225ea9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -274,7 +274,9 @@ static void write_super_endio(struct bio *bio)
 {
 	struct cache *ca = bio->bi_private;
 
-	bch_count_io_errors(ca, bio->bi_status, "writing superblock");
+	/* is_read = 0 */
+	bch_count_io_errors(ca, bio->bi_status, 0,
+			    "writing superblock");
 	closure_put(&ca->set->sb_write);
 }
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index f82ffb2e9b9b..31b0a292a619 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -244,8 +244,10 @@ static void read_dirty_endio(struct bio *bio)
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
 
+	/* is_read = 1 */
 	bch_count_io_errors(PTR_CACHE(io->dc->disk.c, &w->key, 0),
-			    bio->bi_status, "reading dirty data from cache");
+			    bio->bi_status, 1,
+			    "reading dirty data from cache");
 
 	dirty_endio(bio);
 }
-- 
2.14.1
