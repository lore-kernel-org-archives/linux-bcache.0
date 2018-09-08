From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] bcache: remove unecessary condition check before debugfs_remove_recursive
Date: Sat, 8 Sep 2018 21:29:10 +0800
Message-ID: <1536413350-31523-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

debugfs_remove_recursive has taken IS_ERR_OR_NULL into account. So just
remove the condition check before debugfs_remove_recursive.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/md/bcache/debug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 06da66b..8c53d87 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -249,8 +249,7 @@ void bch_debug_init_cache_set(struct cache_set *c)
 
 void bch_debug_exit(void)
 {
-	if (!IS_ERR_OR_NULL(bcache_debug))
-		debugfs_remove_recursive(bcache_debug);
+	debugfs_remove_recursive(bcache_debug);
 }
 
 void __init bch_debug_init(struct kobject *kobj)
-- 
1.7.12.4
