From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] bcache: remove unnecessary null poiner check in cache_set_free
Date: Sat, 8 Sep 2018 19:39:26 +0800
Message-ID: <1536406766-27021-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

The iterator in for_each_cache is never null, therefore, remove
the redundant null pointer check.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/md/bcache/super.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 94c756c..2d26f9e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1513,12 +1513,11 @@ static void cache_set_free(struct closure *cl)
 	bch_btree_cache_free(c);
 	bch_journal_free(c);
 
-	for_each_cache(ca, c, i)
-		if (ca) {
-			ca->set = NULL;
-			c->cache[ca->sb.nr_this_dev] = NULL;
-			kobject_put(&ca->kobj);
-		}
+	for_each_cache(ca, c, i) {
+		ca->set = NULL;
+		c->cache[ca->sb.nr_this_dev] = NULL;
+		kobject_put(&ca->kobj);
+	}
 
 	bch_bset_sort_state_free(&c->sort);
 	free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
-- 
1.7.12.4
