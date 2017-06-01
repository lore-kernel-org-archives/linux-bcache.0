From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: Subtract dirty sectors of thin flash from cache_sectors in calculating writeback rate
Date: Thu, 1 Jun 2017 19:19:34 +0800
Message-ID: <1496315974-9648-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:46985 "EHLO out1.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751556AbdFALUz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Jun 2017 07:20:55 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Since dirty sectors of thin flash cannot be used to cache data for backend
device, so we should subtract it in calculating writeback rate.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/writeback.c |  2 +-
 drivers/md/bcache/writeback.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 69e1ae5..434c329 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -20,7 +20,7 @@
 static void __update_writeback_rate(struct cached_dev *dc)
 {
 	struct cache_set *c = dc->disk.c;
-	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size;
+	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size - bcache_flash_devs_sectors_dirty(c);
 	uint64_t cache_dirty_target =
 		div_u64(cache_sectors * dc->writeback_percent, 100);
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 629bd1a..8789b9c 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -14,6 +14,25 @@ static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
 	return ret;
 }
 
+static inline uint64_t  bcache_flash_devs_sectors_dirty(struct cache_set *c)
+{
+	uint64_t i, ret = 0;
+
+	mutex_lock(&bch_register_lock);
+
+	for (i = 0; i < c->nr_uuids; i++) {
+		struct bcache_device *d = c->devices[i];
+
+		if (!d || !UUID_FLASH_ONLY(&c->uuids[i]))
+			continue;
+	   ret += bcache_dev_sectors_dirty(d);
+	}
+
+	mutex_unlock(&bch_register_lock);
+
+	return ret;
+}
+
 static inline unsigned offset_to_stripe(struct bcache_device *d,
 					uint64_t offset)
 {
-- 
2.8.1.windows.1
