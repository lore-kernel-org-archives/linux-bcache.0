From: tang.junhui@zte.com.cn
Subject: [PATCH] [PATCH v3] bcache: gc does not work when triggering by manual
Date: Tue, 10 Oct 2017 10:44:49 +0800
Message-ID: <1507603489-30999-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

I try to execute the following command to trigger gc thread:
[root@localhost internal]# echo 1 > trigger_gc
But it does not work, I debug the code in gc_should_run(), It works only
if in invalidating or sectors_to_gc < 0. So set sectors_to_gc to -1 to
meet the condition when we trigger gc by manual command.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/sysfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b3ff57d..bef776d 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -614,8 +614,16 @@ STORE(__bch_cache_set)
 		bch_cache_accounting_clear(&c->accounting);
 	}
 
-	if (attr == &sysfs_trigger_gc)
+	if (attr == &sysfs_trigger_gc) {
+		/* 
+		  * Satisfy the gc condition by setting sectors_to_gc under 0,
+		  * sectors_to_gc may also be decreased under 0 in 
+		  * bch_data_insert_start() and gc would be triggered again,
+		  * but the race is rare, and harmless, so we can ignore it
+		  */
+		atomic_set(&c->sectors_to_gc, -1);
 		wake_up_gc(c);
+	}
 
 	if (attr == &sysfs_prune_cache) {
 		struct shrink_control sc;
-- 
2.8.1.windows.1
