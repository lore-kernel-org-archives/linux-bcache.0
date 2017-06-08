From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix issue of writeback rate at minimum 1 block per second
Date: Thu, 8 Jun 2017 17:28:21 +0800
Message-ID: <1496914101-10044-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:39355 "EHLO out1.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751616AbdFHJaB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 05:30:01 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

When there is not enough data in writeback cache, let the writeback rate
to be 0, and delay 30 seconds in read_dirty().

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/util.c      | 15 ++++++++++-----
 drivers/md/bcache/writeback.c |  2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index dde6172..ba40f01 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -209,13 +209,18 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
 {
 	uint64_t now = local_clock();
 
-	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
+	if (!d->rate) {
+		d->next += ZERO_RATE_DELAY_NS;
+	}
+	else {
+		d->next += div_u64(done * NSEC_PER_SEC, d->rate);
 
-	if (time_before64(now + NSEC_PER_SEC, d->next))
-		d->next = now + NSEC_PER_SEC;
+		if (time_before64(now + NSEC_PER_SEC, d->next))
+			d->next = now + NSEC_PER_SEC;
 
-	if (time_after64(now - NSEC_PER_SEC * 2, d->next))
-		d->next = now - NSEC_PER_SEC * 2;
+		if (time_after64(now - NSEC_PER_SEC * 2, d->next))
+			d->next = now - NSEC_PER_SEC * 2;
+	}
 
 	return time_after64(d->next, now)
 		? div_u64(d->next - now, NSEC_PER_SEC / HZ)
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 69e1ae5..8fac280 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -60,7 +60,7 @@ static void __update_writeback_rate(struct cached_dev *dc)
 
 	dc->writeback_rate.rate =
 		clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
-			1, NSEC_PER_MSEC);
+			0, NSEC_PER_MSEC);
 
 	dc->writeback_rate_proportional = proportional;
 	dc->writeback_rate_derivative = derivative;
-- 
2.8.1.windows.1
