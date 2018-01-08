From: Michael Lyle <mlyle@lyle.org>
Subject: [416 PATCH 04/13] bcache: segregate flash only volume write streams
Date: Mon,  8 Jan 2018 12:21:21 -0800
Message-ID: <20180108202130.31303-5-mlyle@lyle.org>
References: <20180108202130.31303-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:46439 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757216AbeAHUVp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jan 2018 15:21:45 -0500
Received: by mail-pg0-f67.google.com with SMTP id r2so6298801pgq.13
        for <linux-bcache@vger.kernel.org>; Mon, 08 Jan 2018 12:21:45 -0800 (PST)
In-Reply-To: <20180108202130.31303-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Tang Junhui <tang.junhui@zte.com.cn>, Michael Lyle <mlyle@lyle.org>

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

[mlyle: fixed commit log formatting, permissions, line endings]

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/alloc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index a0cc1bc6d884..6cc6c0f9c3a9 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -525,15 +525,21 @@ struct open_bucket {
 
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
@@ -550,7 +556,10 @@ static struct open_bucket *pick_data_bucket(struct cache_set *c,
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
2.14.1
