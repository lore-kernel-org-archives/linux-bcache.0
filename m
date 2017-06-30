From: bcache@lists.ewheeler.net
Subject: [PATCH 09/19] bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
Date: Fri, 30 Jun 2017 13:42:58 -0700
Message-ID: <1498855388-16990-9-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>
List-Id: linux-bcache@vger.kernel.org

From: Eric Wheeler <git@linux.ewheeler.net>

Bypass if:     bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND)

Writeback if:  op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)

Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
---
 drivers/md/bcache/request.c   | 3 +++
 drivers/md/bcache/writeback.h | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index a95609f..4629b0c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -386,6 +386,9 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	     op_is_write(bio_op(bio))))
 		goto skip;
 
+	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))
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
