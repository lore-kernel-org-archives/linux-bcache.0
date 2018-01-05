From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH v3] bcache: fix writeback target calc on large devices
Date: Fri,  5 Jan 2018 13:17:39 -0800
Message-ID: <20180105211739.27305-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:43819 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752964AbeAEVRp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Jan 2018 16:17:45 -0500
Received: by mail-pf0-f194.google.com with SMTP id e3so2666098pfi.10
        for <linux-bcache@vger.kernel.org>; Fri, 05 Jan 2018 13:17:45 -0800 (PST)
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

This has been improved based on Tang Junhui's feedback to ensure that
every device gets a share of dirty data, no matter how small it is
compared to the total backing pool.

Reported-by: Jack Douglas <jack@douglastechnology.co.uk>
Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/writeback.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 61f24c04cebd..c7e35180091e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -18,17 +18,43 @@
 #include <trace/events/bcache.h>
 
 /* Rate limiting */
-
-static void __update_writeback_rate(struct cached_dev *dc)
+static uint64_t __calc_target_rate(struct cached_dev *dc)
 {
 	struct cache_set *c = dc->disk.c;
+
+	/*
+	 * This is the size of the cache, minus the amount used for
+	 * flash-only devices
+	 */
 	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size -
 				bcache_flash_devs_sectors_dirty(c);
+
+	/*
+	 * Unfortunately there is no control of global dirty data.  If the
+	 * user states that they want 10% dirty data in the cache, and has,
+	 * e.g., 5 backing volumes of equal size, we try and ensure each
+	 * backing volume uses about 2% of the cache.
+	 *
+	 * 16384 is chosen here as something that each backing device should
+	 * be a reasonable fraction of the share, and not to blow up until
+	 * individual backing devices are a petabyte.
+	 */
+	uint32_t bdev_share_per16k =
+		div64_u64(16384 * bdev_sectors(dc->bdev),
+				c->cached_dev_sectors);
+
 	uint64_t cache_dirty_target =
 		div_u64(cache_sectors * dc->writeback_percent, 100);
-	int64_t target = div64_u64(cache_dirty_target * bdev_sectors(dc->bdev),
-				   c->cached_dev_sectors);
 
+	/* Ensure each backing dev gets at least 1/16384th dirty share */
+	if (bdev_share_per16k < 1)
+		bdev_share_per16k = 1;
+
+	return div_u64(cache_dirty_target * bdev_share_per16k, 16384);
+}
+
+static void __update_writeback_rate(struct cached_dev *dc)
+{
 	/*
 	 * PI controller:
 	 * Figures out the amount that should be written per second.
@@ -49,6 +75,7 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	 * This acts as a slow, long-term average that is not subject to
 	 * variations in usage like the p term.
 	 */
+	int64_t target = __calc_target_rate(dc);
 	int64_t dirty = bcache_dev_sectors_dirty(&dc->disk);
 	int64_t error = dirty - target;
 	int64_t proportional_scaled =
-- 
2.14.1
