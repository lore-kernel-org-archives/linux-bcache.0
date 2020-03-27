From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] null_blk: use blk_mq_init_queue_data
Date: Fri, 27 Mar 2020 09:30:09 +0100
Message-ID: <20200327083012.1618778-3-hch@lst.de>
References: <20200327083012.1618778-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200327083012.1618778-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Use the new blk_mq_init_queue_data instead of open coding the queue
allocation and initialization.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/null_blk_main.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 89bb16a99007..2f864782550d 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1698,27 +1698,6 @@ static bool null_setup_fault(void)
 	return true;
 }
 
-/*
- * This function is identical to blk_mq_init_queue() except that it sets
- * queuedata before .init_hctx is called.
- */
-static struct request_queue *nullb_alloc_queue(struct nullb *nullb)
-{
-	struct request_queue *uninit_q, *q;
-	struct blk_mq_tag_set *set = nullb->tag_set;
-
-	uninit_q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
-	if (!uninit_q)
-		return ERR_PTR(-ENOMEM);
-
-	uninit_q->queuedata = nullb;
-	q = blk_mq_init_allocated_queue(set, uninit_q, false);
-	if (IS_ERR(q))
-		blk_cleanup_queue(uninit_q);
-
-	return q;
-}
-
 static int null_add_dev(struct nullb_device *dev)
 {
 	struct nullb *nullb;
@@ -1758,7 +1737,7 @@ static int null_add_dev(struct nullb_device *dev)
 			goto out_cleanup_queues;
 
 		nullb->tag_set->timeout = 5 * HZ;
-		nullb->q = nullb_alloc_queue(nullb);
+		nullb->q = blk_mq_init_queue_data(nullb->tag_set, nullb);
 		if (IS_ERR(nullb->q)) {
 			rv = -ENOMEM;
 			goto out_cleanup_tags;
-- 
2.25.1
