From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix error count in memory shrink
Date: Wed, 31 Jan 2018 10:46:52 +0800
Message-ID: <1517366812-26957-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

In bch_mca_scan(), nr btree nodes are expected to shrink, so the for(;;)
loop need to satisfy the condition freed < nr.
And since c->btree_cache_used always decrease after mca_data_free() calling
in for(;;) loop,  so we need a auto variable to record c->btree_cache_used
before the for(;;) loop.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 81e8dc3..7e9ef3d 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -664,6 +664,7 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 	struct btree *b, *t;
 	unsigned long i, nr = sc->nr_to_scan;
 	unsigned long freed = 0;
+	unsigned int btree_cache_used;
 
 	if (c->shrinker_disabled)
 		return SHRINK_STOP;
@@ -700,7 +701,8 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 		}
 	}
 
-	for (i = 0; (nr--) && i < c->btree_cache_used; i++) {
+	btree_cache_used = c->btree_cache_used;
+	for (i = 0; freed < nr && i < btree_cache_used; i++) {
 		if (list_empty(&c->btree_cache))
 			goto out;
 
-- 
1.8.3.1
