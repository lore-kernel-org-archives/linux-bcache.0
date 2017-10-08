From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH] bcache: writeback rate shouldn't artifically clamp
Date: Sat,  7 Oct 2017 22:25:20 -0700
Message-ID: <20171008052520.17068-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: colyli@suse.de, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

The previous code artificially limited writeback rate to 1000000
blocks/second (NSEC_PER_MSEC), which is a rate that can be met on fast
hardware.  The rate limiting code works fine (though with decreased
precision) up to 3 orders of magnitude faster, so use NSEC_PER_SEC.

Additionally, ensure that uint32_t is used as a type for rate throughout
the rate management so that type checking/clamp_t can work properly.

bch_next_delay should be rewritten for increased precision and better
handling of high rates and long sleep periods, but this is adequate for
now.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
Reported-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/util.h      | 4 ++--
 drivers/md/bcache/writeback.c | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index cb8d2ccbb6c6..8f509290bb02 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -441,10 +441,10 @@ struct bch_ratelimit {
 	uint64_t		next;
 
 	/*
-	 * Rate at which we want to do work, in units per nanosecond
+	 * Rate at which we want to do work, in units per second
 	 * The units here correspond to the units passed to bch_next_delay()
 	 */
-	unsigned		rate;
+	uint32_t		rate;
 };
 
 static inline void bch_ratelimit_reset(struct bch_ratelimit *d)
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3f8c4c6bee03..a1608c45bb12 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -46,7 +46,8 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	int64_t error = dirty - target;
 	int64_t proportional_scaled =
 		div_s64(error, dc->writeback_rate_p_term_inverse);
-	int64_t integral_scaled, new_rate;
+	int64_t integral_scaled;
+	uint32_t new_rate;
 
 	if ((error < 0 && dc->writeback_rate_integral > 0) ||
 	    time_before64(local_clock(),
@@ -67,8 +68,8 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	integral_scaled = div_s64(dc->writeback_rate_integral,
 			dc->writeback_rate_i_term_inverse);
 
-	new_rate = clamp_t(int64_t, (proportional_scaled + integral_scaled),
-			dc->writeback_rate_minimum, NSEC_PER_MSEC);
+	new_rate = clamp_t(uint32_t, (proportional_scaled + integral_scaled),
+			dc->writeback_rate_minimum, NSEC_PER_SEC);
 
 	dc->writeback_rate_proportional = proportional_scaled;
 	dc->writeback_rate_integral_scaled = integral_scaled;
-- 
2.11.0
