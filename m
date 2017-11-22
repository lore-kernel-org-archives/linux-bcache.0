From: tang.junhui@zte.com.cn
Subject: [PATCH] [PATCH v2] bcache: segregate flash only volume write streams from cached devices
Date: Wed, 22 Nov 2017 11:25:29 +0800
Message-ID: <1511321129-20778-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: kent.overstreet@gmail.com, colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

In such scenario that there are some flash only volumes
, and some cached devices, when many tasks request these devices in
writeback mode, the write IOs may fall to the same bucket as bellow:
| cached data | flash data | cached data | cached data| flash data|
then after writeback of these cached devices, the bucket would
be like bellow bucket:
| free | flash data | free | free | flash data |

So, there are many free space in this bucket, but since data of flash
only volumes still exists, so this bucket cannot be reclaimable,
which would cause waste of bucket space.

In this patch, we segregate flash only volume write streams from
cached devices, so data from flash only volumes and cached devices
can store in different buckets.

Compare to v1 patch, this patch do not add a additionally open bucket
list, and it is try best to segregate flash only volume write streams
from cached devices, sectors of flash only volumes may still be mixed
with dirty sectors of cached device, but the number is very small.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/alloc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)
 mode change 100644 => 100755 drivers/md/bcache/alloc.c

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
old mode 100644
new mode 100755
index 0803563..4302922
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -514,15 +514,21 @@ struct open_bucket {
 
 /*
  * We keep multiple buckets open for writes, and try to segregate different
- * write streams for better cache utilization: first we look for a bucket where
- * the last write to it was sequential with the current write, and failing that
- * we look for a bucket that was last used by the same task.
+ * write streams for better cache utilization: first we try to segregate flash
+ * only volume write streams from cached devices, secondly we look for a bucket
+ * where the last write to it was sequential with the current write, and
+ * failing that we look for a bucket that was last used by the same task.
  *
  * The ideas is if you've got multiple tasks pulling data into the cache at the
  * same time, you'll get better cache utilization if you try to segregate their
  * data and preserve locality.
  *
- * For example, say you've starting Firefox at the same time you're copying a
+ * For example, dirty sectors of flash only volume is not reclaimable, if their
+ * dirty sectors mixed with dirty sectors of cached device, such buckets will 
+ * be marked as dirty and won't be reclaimed, though the dirty data of cached 
+ * device have been written back to backend device.
+ *
+ * And say you've starting Firefox at the same time you're copying a
  * bunch of files. Firefox will likely end up being fairly hot and stay in the
  * cache awhile, but the data you copied might not be; if you wrote all that
  * data to the same buckets it'd get invalidated at the same time.
@@ -539,7 +545,10 @@ static struct open_bucket *pick_data_bucket(struct cache_set *c,
 	struct open_bucket *ret, *ret_task = NULL;
 
 	list_for_each_entry_reverse(ret, &c->data_buckets, list)
-		if (!bkey_cmp(&ret->key, search))
+		if (UUID_FLASH_ONLY(&c->uuids[KEY_INODE(&ret->key)]) != 
+		    UUID_FLASH_ONLY(&c->uuids[KEY_INODE(search)]))
+			continue;
+		else if (!bkey_cmp(&ret->key, search))
 			goto found;
 		else if (ret->last_write_point == write_point)
 			ret_task = ret;
-- 
1.8.3.1
