From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 06/15] bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
Date: Fri, 13 Oct 2017 16:35:33 -0700
Message-ID: <20171013233542.20938-7-mlyle@lyle.org>
References: <20171013233542.20938-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171013233542.20938-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Eric Wheeler <bcache@linux.ewheeler.net>
List-Id: linux-bcache@vger.kernel.org

From: Eric Wheeler <bcache@linux.ewheeler.net>

Flag for bypass if the IO is for read-ahead or background, unless the
read-ahead request is for metadata (eg, from gfs2).
        Bypass if:
                bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
			!(bio->bi_opf & REQ_META))

        Writeback if:
                op_is_sync(bio->bi_opf) ||
			bio->bi_opf & (REQ_META|REQ_PRIO)

Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
Reviewed-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/request.c   | 8 ++++++++
 drivers/md/bcache/writeback.h | 4 +++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 681b4f12b05a..9ee137e8d387 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -384,6 +384,14 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	     op_is_write(bio_op(bio))))
 		goto skip;
 
+	/*
+	 * Flag for bypass if the IO is for read-ahead or background,
+	 * unless the read-ahead request is for metadata (eg, for gfs2).
+	 */
+	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
+	    !(bio->bi_opf & REQ_META))
+		goto skip;
+
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
 	    bio_sectors(bio) & (c->sb.block_size - 1)) {
 		pr_debug("skipping unaligned io");
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index e35421d20d2e..34bcf49d737b 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -76,7 +76,9 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 	if (would_skip)
 		return false;
 
-	return op_is_sync(bio->bi_opf) || in_use <= CUTOFF_WRITEBACK;
+	return (op_is_sync(bio->bi_opf) ||
+		bio->bi_opf & (REQ_META|REQ_PRIO) ||
+		in_use <= CUTOFF_WRITEBACK);
 }
 
 static inline void bch_writeback_queue(struct cached_dev *dc)
-- 
2.11.0
