From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix error return value in memory shrink
Date: Wed, 31 Jan 2018 11:30:53 +0800
Message-ID: <1517369453-28193-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:59524 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753044AbeAaD22 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Jan 2018 22:28:28 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

In bch_mca_scan(), the return value should not be the number of freed btree
nodes, but the number of pages of freed btree nodes.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 81e8dc3..a5fbccc 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -718,7 +718,7 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 	}
 out:
 	mutex_unlock(&c->bucket_lock);
-	return freed;
+	return freed * c->btree_pages;
 }
 
 static unsigned long bch_mca_count(struct shrinker *shrink,
-- 
1.8.3.1
