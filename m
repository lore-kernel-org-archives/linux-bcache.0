From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix sequential large write IO bypass
Date: Tue, 25 Apr 2017 14:36:38 +0800
Message-ID: <1493102198-4308-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx7.zte.com.cn ([202.103.147.169]:41706 "EHLO mx7.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941348AbdDYGiM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Apr 2017 02:38:12 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, "tang.junhui" <tang.junhui@zte.com.cn>

From: "tang.junhui" <tang.junhui@zte.com.cn>

Sequential write IOs were tested with bs=1M by FIO in writeback cache
mode, these IOs were expected to be bypassed, but actually they did not.
We debug the code, and find in check_should_bypass():
    if (!congested &&
        mode == CACHE_MODE_WRITEBACK &&
        op_is_write(bio_op(bio)) &&
        (bio-＞bi_opf & REQ_SYNC))
        goto rescale
that means, If in writeback mode, a write IO with REQ_SYNC flag will not
be bypassed though it is a sequential large IO, It's not a correct thing
to do actually, so this patch remove these codes.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/request.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 76d2087..a9bbd03 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -400,12 +400,6 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	if (!congested && !dc->sequential_cutoff)
 		goto rescale;
 
-	if (!congested &&
-	    mode == CACHE_MODE_WRITEBACK &&
-	    op_is_write(bio->bi_opf) &&
-	    op_is_sync(bio->bi_opf))
-		goto rescale;
-
 	spin_lock(&dc->io_lock);
 
 	hlist_for_each_entry(i, iohash(dc, bio->bi_iter.bi_sector), hash)
-- 
2.8.1.windows.1
