From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: do not subtract sectors_to_gc for bypassd IO
Date: Tue, 25 Apr 2017 19:02:03 +0800
Message-ID: <1493118123-9284-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:52291 "EHLO out1.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1172415AbdDYLDQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Apr 2017 07:03:16 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, "tang.junhui" <tang.junhui@zte.com.cn>

From: "tang.junhui" <tang.junhui@zte.com.cn>

Since bypassed IOs use no bucket, so do not subtract sectors_to_gc to
trigger gc thread.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 76d2087..fa3bfd0 100644
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
2.8.1.windows.1
