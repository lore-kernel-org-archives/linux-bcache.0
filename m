From: Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] bcache: journel: use for_each_clear_bit() to simplify the  code
Date: Wed, 24 Jun 2020 14:52:57 +0800
Message-ID: <20200624065257.4051-1-vulab@iscas.ac.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Using for_each_clear_bit() to simplify the code.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/md/bcache/journal.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 90aac4e2333f..b01c953e214c 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -217,10 +217,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		 */
 		pr_debug("falling back to linear search\n");
 
-		for (l = find_first_zero_bit(bitmap, ca->sb.njournal_buckets);
-		     l < ca->sb.njournal_buckets;
-		     l = find_next_zero_bit(bitmap, ca->sb.njournal_buckets,
-					    l + 1))
+		for_each_clear_bit(l, bitmap, ca->sb.njournal_buckets)
 			if (read_bucket(l))
 				goto bsearch;
 
-- 
2.17.1
