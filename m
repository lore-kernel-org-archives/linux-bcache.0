From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] Revert "blkdev: check for valid request queue before issuing flush"
Date: Fri, 27 Mar 2020 09:30:12 +0100
Message-ID: <20200327083012.1618778-6-hch@lst.de>
References: <20200327083012.1618778-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200327083012.1618778-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

This reverts commit f10d9f617a65905c556c3b37c9b9646ae7d04ed7.

We can't have queues without a make_request_fn any more (and the
loop device uses blk-mq these days anyway..).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 843d25683691..c7f396e3d5e2 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -454,15 +454,6 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	if (!q)
 		return -ENXIO;
 
-	/*
-	 * some block devices may not have their queue correctly set up here
-	 * (e.g. loop device without a backing file) and so issuing a flush
-	 * here will panic. Ensure there is a request function before issuing
-	 * the flush.
-	 */
-	if (!q->make_request_fn)
-		return -ENXIO;
-
 	bio = bio_alloc(gfp_mask, 0);
 	bio_set_dev(bio, bdev);
 	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-- 
2.25.1
