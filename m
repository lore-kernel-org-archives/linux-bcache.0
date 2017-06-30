From: bcache@lists.ewheeler.net
Subject: [PATCH 03/19] bcache: do not subtract sectors_to_gc for bypassed IO
Date: Fri, 30 Jun 2017 13:42:52 -0700
Message-ID: <1498855388-16990-3-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Since bypassed IOs use no bucket, so do not subtract sectors_to_gc to
trigger gc thread.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 958072a..4b413db 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -196,12 +196,12 @@ static void bch_data_insert_start(struct closure *cl)
 	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
 	struct bio *bio = op->bio, *n;
 
-	if (atomic_sub_return(bio_sectors(bio), &op->c->sectors_to_gc) < 0)
-		wake_up_gc(op->c);
-
 	if (op->bypass)
 		return bch_data_invalidate(cl);
 
+	if (atomic_sub_return(bio_sectors(bio), &op->c->sectors_to_gc) < 0)
+		wake_up_gc(op->c);
+
 	/*
 	 * Journal writes are marked REQ_PREFLUSH; if the original write was a
 	 * flush, it'll wait on the journal write.
-- 
1.8.3.1
