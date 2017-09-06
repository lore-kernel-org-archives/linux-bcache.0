From: Coly Li <colyli@suse.de>
Subject: [PATCH 03/12] bcache: do not subtract sectors_to_gc for bypassed IO
Date: Wed,  6 Sep 2017 14:25:53 +0800
Message-ID: <20170906062602.50497-4-colyli@suse.de>
References: <20170906062602.50497-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170906062602.50497-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
Cc: bcache@lists.ewheeler.net, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Since bypassed IOs use no bucket, so do not subtract sectors_to_gc to
trigger gc thread.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
Acked-by: Coly Li <colyli@suse.de>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 958072a11347..4b413db99276 100644
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
2.13.5
