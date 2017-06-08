From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: gc does not work when triggering by manual command
Date: Thu, 8 Jun 2017 14:39:23 +0800
Message-ID: <1496903963-11068-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:49265 "EHLO out1.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdFHGlG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 02:41:06 -0400
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
 drivers/md/bcache/btree.h | 6 ++++++
 drivers/md/bcache/sysfs.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 9b80417..bab07d4 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -263,6 +263,12 @@ static inline void wake_up_gc(struct cache_set *c)
 	wake_up(&c->gc_wait);
 }
 
+static inline void wake_up_gc_force(struct cache_set *c)
+{
+	atomic_set(&c->sectors_to_gc, -1);
+	wake_up(&c->gc_wait);
+}
+
 #define MAP_DONE	0
 #define MAP_CONTINUE	1
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b3ff57d..5fdb86c 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -615,7 +615,7 @@ STORE(__bch_cache_set)
 	}
 
 	if (attr == &sysfs_trigger_gc)
-		wake_up_gc(c);
+		wake_up_gc_force(c);
 
 	if (attr == &sysfs_prune_cache) {
 		struct shrink_control sc;
-- 
2.8.1.windows.1
