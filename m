From: bcache@lists.ewheeler.net
Subject: [PATCH 09/19 v2] bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
Date: Mon,  3 Jul 2017 15:51:24 -0700
Message-ID: <1499122284-11016-1-git-send-email-bcache@lists.ewheeler.net>
References: <a4f5a7e5-97aa-4245-5f96-2df2045fb2a4@coly.li>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35394 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750803AbdGCWwB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 3 Jul 2017 18:52:01 -0400
In-Reply-To: <a4f5a7e5-97aa-4245-5f96-2df2045fb2a4@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, i@coly.li, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>

From: Eric Wheeler <git@linux.ewheeler.net>

Flag for bypass if the IO is for read-ahead or background, unless the
read-ahead request is for metadata (eg, from gfs2).
	Bypass if:
		bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) && !(bio->bi_opf & REQ_META))

	Writeback if:
		op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)

Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
---
 drivers/md/bcache/request.c   | 7 +++++++
 drivers/md/bcache/writeback.h | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index a95609f..859d08d 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -386,6 +386,13 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	     op_is_write(bio_op(bio))))
 		goto skip;
 
+	/* Flag for bypass if the IO is for read-ahead or background,
+	 * unless the read-ahead request is for metadata (eg, for gfs2).
+	 */
+	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
+		!(bio->bi_opf & REQ_META))
+		goto skip;
+
 	/* If the ioprio already exists on the bio, use that.  We assume that
 	 * the upper layer properly assigned the calling process's ioprio to
 	 * the bio being passed to bcache. Otherwise, use current's ioc. */
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index cd82fe8..ea2f92e 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -81,7 +81,8 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 		return true;
 	}
 
-	return op_is_sync(bio->bi_opf) || in_use <= CUTOFF_WRITEBACK;
+	return op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)
+		|| in_use <= CUTOFF_WRITEBACK;
 }
 
 static inline void bch_writeback_queue(struct cached_dev *dc)
-- 
1.8.3.1
