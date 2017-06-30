From: bcache@lists.ewheeler.net
Subject: [PATCH 11/19] bcache: Subtract dirty sectors of thin flash from cache_sectors in calculating writeback rate
Date: Fri, 30 Jun 2017 13:43:00 -0700
Message-ID: <1498855388-16990-11-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:43890 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752725AbdF3Un5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Jun 2017 16:43:57 -0400
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Since dirty sectors of thin flash cannot be used to cache data for backend
device, so we should subtract it in calculating writeback rate.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/writeback.c |  2 +-
 drivers/md/bcache/writeback.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4ac8b13..25289e4 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -21,7 +21,7 @@
 static void __update_writeback_rate(struct cached_dev *dc)
 {
 	struct cache_set *c = dc->disk.c;
-	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size;
+	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size - bcache_flash_devs_sectors_dirty(c);
 	uint64_t cache_dirty_target =
 		div_u64(cache_sectors * dc->writeback_percent, 100);
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index c2ab4b4..24ff589 100644
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
1.8.3.1
