From: tang.junhui@zte.com.cn
Subject: [PATCH] [PATCH v2] bcache: gc does not work when triggering by manual command
Date: Fri, 9 Jun 2017 15:11:41 +0800
Message-ID: <1496992301-10448-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:49493 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbdFIHNS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Jun 2017 03:13:18 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

I try to execute the following command to trigger gc thread:
[root@localhost internal]# echo 1 > trigger_gc
But it does not work, I debug the code in gc_should_run(), It works only
if in invalidating or sectors_to_gc < 0. So set sectors_to_gc to -1 to
meet the condition when we trigger gc by manual command.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b3ff57d..f5bb93a 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -614,8 +614,10 @@ STORE(__bch_cache_set)
 		bch_cache_accounting_clear(&c->accounting);
 	}
 
-	if (attr == &sysfs_trigger_gc)
+	if (attr == &sysfs_trigger_gc) {
+		atomic_set(&c->sectors_to_gc, -1);
 		wake_up_gc(c);
+	}
 
 	if (attr == &sysfs_prune_cache) {
 		struct shrink_control sc;
-- 
2.8.1.windows.1
