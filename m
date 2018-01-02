From: Michael Lyle <mlyle@lyle.org>
Subject: [for-416 PATCH v2] bcache: fix writeback target calculation
Date: Tue,  2 Jan 2018 11:00:49 -0800
Message-ID: <20180102190049.29237-1-mlyle@lyle.org>
References: <1514885112-12218-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35486 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbeABTBA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jan 2018 14:01:00 -0500
Received: by mail-pf0-f194.google.com with SMTP id j124so26004671pfc.2
        for <linux-bcache@vger.kernel.org>; Tue, 02 Jan 2018 11:01:00 -0800 (PST)
In-Reply-To: <1514885112-12218-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: tang.junhui@zte.com.cn, Michael Lyle <mlyle@lyle.org>

This fixes bcache writeback target calculation, for defects relating to
large cache sets and calculation errors when there are multiple backing
devices.

Bcache needs to scale the dirty data in the cache over the multiple
backing disks in order to calculate writeback rates for each.
The previous code did this by multiplying the target number of dirty
sectors by the backing device size, and expected it to fit into a
uint64_t; this blows up on relatively small backing devices.

The new approach figures out the bdev's share in 16384ths of the overall
cached data.  This is chosen to cope well when bdevs drastically vary in
size and to ensure that bcache can cross the petabyte boundary for each
backing device.

Per review, we ensure that every device gets at least 1/16384th of the
writeback share.  This also differs from v1 of the patchset in scaling
the error, which corrects previous problems with writeback rate
calculation across multiple devices.

Reported-by: Jack Douglas <jack@douglastechnology.co.uk>
Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/writeback.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 56a37884ca8b..be2840ad02d4 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -26,16 +26,28 @@ static void __update_writeback_rate(struct cached_dev *dc)
 				bcache_flash_devs_sectors_dirty(c);
 	uint64_t cache_dirty_target =
 		div_u64(cache_sectors * dc->writeback_percent, 100);
-	int64_t target = div64_u64(cache_dirty_target * bdev_sectors(dc->bdev),
-				   c->cached_dev_sectors);
+
+	/*
+	 * 16384 is chosen here as something that each backing device should
+	 * be a reasonable fraction of the share, and to not blow up until
+	 * individual backing devices are a petabyte.
+	 */
+	uint32_t bdev_share_per16k =
+		div64_u64(16384 * bdev_sectors(dc->bdev),
+				c->cached_dev_sectors);
 
 	/*
 	 * PI controller:
 	 * Figures out the amount that should be written per second.
 	 *
 	 * First, the error (number of sectors that are dirty beyond our
-	 * target) is calculated.  The error is accumulated (numerically
-	 * integrated).
+	 * target) is calculated. 
+	 *
+	 * Unfortunately we don't know the exact share of dirty data for
+	 * each backing device; therefore the error is adjusted for this
+	 * backing disk's share of the overall error based on size.
+	 *
+	 * The error is accumulated (numerically integrated).
 	 *
 	 * Then, the proportional value and integral value are scaled
 	 * based on configured values.  These are stored as inverses to
@@ -50,12 +62,22 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	 * variations in usage like the p term.
 	 */
 	int64_t dirty = bcache_dev_sectors_dirty(&dc->disk);
-	int64_t error = dirty - target;
-	int64_t proportional_scaled =
-		div_s64(error, dc->writeback_rate_p_term_inverse);
-	int64_t integral_scaled;
+	int64_t error = dirty - cache_dirty_target;
+	int64_t proportional_scaled, integral_scaled;
 	uint32_t new_rate;
 
+	/*
+	 * Ensure even with large device size disparities that we still
+	 * writeback at least some.
+	 */
+	if (bdev_share_per16k < 1)
+		bdev_share_per16k = 1;
+
+	target = div_s64(error * bdev_share_per16k, 16384)
+
+	proportional_scaled = div_s64(error,
+			dc->writeback_rate_p_term_inverse);
+
 	if ((error < 0 && dc->writeback_rate_integral > 0) ||
 	    (error > 0 && time_before64(local_clock(),
 			 dc->writeback_rate.next + NSEC_PER_MSEC))) {
-- 
2.14.1
