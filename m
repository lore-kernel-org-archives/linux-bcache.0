From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: delete redundant calling set_gc_sectors()
Date: Thu, 8 Jun 2017 14:06:16 +0800
Message-ID: <1496901976-10908-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:31093 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdFHGID (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 02:08:03 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

set_gc_sectors() has been called in bch_gc_thread(), and it was called
again in bch_btree_gc_finish() . The following call is unnecessary, so
delete it.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/btree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index a43eedd..c80e64e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1657,7 +1657,6 @@ static size_t bch_btree_gc_finish(struct cache_set *c)
 
 	mutex_lock(&c->bucket_lock);
 
-	set_gc_sectors(c);
 	c->gc_mark_valid = 1;
 	c->need_gc	= 0;
 
-- 
2.8.1.windows.1
