From: Michael Lyle <mlyle@lyle.org>
Subject: [for-416 PATCH] bcache: fix writeback target calc on large devices
Date: Wed, 27 Dec 2017 16:42:30 -0800
Message-ID: <20171228004230.3295-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34785 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752024AbdL1AnH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Dec 2017 19:43:07 -0500
Received: by mail-pg0-f65.google.com with SMTP id j4so19336855pgp.1
        for <linux-bcache@vger.kernel.org>; Wed, 27 Dec 2017 16:43:07 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Michael Lyle <mlyle@lyle.org>

Bcache needs to scale the dirty data in the cache over the multiple
backing disks in order to calculate writeback rates for each.
The previous code did this by multiplying the target number of dirty
sectors by the backing device size, and expected it to fit into a
uint64_t; this blows up on relatively small backing devices.

The new approach figures out the bdev's share in 16384ths of the overall
cached data.  This is chosen to cope well when bdevs drastically vary in
size and to ensure that bcache can cross the petabyte boundary for each
backing device.

Reported-by: Jack Douglas <jack@douglastechnology.co.uk>
Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/writeback.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 56a37884ca8b..ddbbeec1f0ee 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -24,10 +24,23 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	struct cache_set *c = dc->disk.c;
 	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size -
 				bcache_flash_devs_sectors_dirty(c);
+	/*
+	 * Unfortunately we don't know the exact share of dirty data for
+	 * each backing device.  Therefore, we need to infer the writeback
+	 * for each disk based on its assumed proportion of dirty data.
+	 *
+	 * 16384 is chosen here as something that each backing device should
+	 * be a reasonable fraction of the share, and not to blow up until
+	 * individual backing devices are a petabyte.
+	 */
+	uint32_t bdev_share_per16k =
+		div64_u64(bdev_sectors(dc->bdev) << 14,
+				c->cached_dev_sectors);
+
 	uint64_t cache_dirty_target =
 		div_u64(cache_sectors * dc->writeback_percent, 100);
-	int64_t target = div64_u64(cache_dirty_target * bdev_sectors(dc->bdev),
-				   c->cached_dev_sectors);
+
+	int64_t target = (cache_dirty_target * bdev_share_per16k) >> 14;
 
 	/*
 	 * PI controller:
-- 
2.14.1
