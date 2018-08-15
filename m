From: Dongbo Cao <cdbdyx@163.com>
Subject: [PATCH 2/2] fix potential memory leak in function "register_bcache"
Date: Wed, 15 Aug 2018 14:50:06 +0800
Message-ID: <20180815065006.19856-1-cdbdyx@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Dongbo Cao <cdbdyx@163.com>
List-Id: linux-bcache@vger.kernel.org

if register_cache get error, memory pointed by ca should be released.
and also, blkdev_put should be called I think.

Signed-off-by: Dongbo Cao <cdbdyx@163.com>
---
 drivers/md/bcache/super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f98352d4..14c31e03 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2159,6 +2159,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	struct cache_sb *sb = NULL;
 	struct block_device *bdev = NULL;
 	struct page *sb_page = NULL;
+	struct cache *ca = NULL;
 
 	if (!try_module_get(THIS_MODULE))
 		return -EBUSY;
@@ -2206,12 +2207,12 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		register_bdev(sb, sb_page, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 	} else {
-		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+		ca = kzalloc(sizeof(struct cache), GFP_KERNEL);
 		if (!ca)
 			goto err_close;
 
 		if (register_cache(sb, sb_page, bdev, ca) != 0)
-			goto err;
+			goto err_register;
 	}
 out:
 	if (sb_page)
@@ -2221,6 +2222,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	module_put(THIS_MODULE);
 	return ret;
 
+err_register:
+	kfree(ca);
 err_close:
 	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 err:
-- 
2.17.1
