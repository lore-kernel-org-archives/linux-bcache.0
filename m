From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH v2 1/2] bcache: writeback rate shouldn't artifically clamp
Date: Mon,  9 Oct 2017 00:37:29 -0700
Message-ID: <20171009073730.8939-2-mlyle@lyle.org>
References: <20171009073730.8939-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171009073730.8939-1-mlyle@lyle.org>
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
 drivers/md/bcache/bcache.h    | 2 +-
 drivers/md/bcache/util.h      | 4 ++--
 drivers/md/bcache/writeback.c | 7 ++++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index df0b2ccfca8d..2f9c380c4692 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -363,7 +363,7 @@ struct cached_dev {
 	int64_t			writeback_rate_proportional;
 	int64_t			writeback_rate_integral;
 	int64_t			writeback_rate_integral_scaled;
-	int64_t			writeback_rate_change;
+	int32_t			writeback_rate_change;
 
 	unsigned		writeback_rate_update_seconds;
 	unsigned		writeback_rate_i_term_inverse;
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
index d63356a60001..42d087b9fb56 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -52,7 +52,8 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	int64_t error = dirty - target;
 	int64_t proportional_scaled =
 		div_s64(error, dc->writeback_rate_p_term_inverse);
-	int64_t integral_scaled, new_rate;
+	int64_t integral_scaled;
+	uint32_t new_rate;
 
 	if ((error < 0 && dc->writeback_rate_integral > 0) ||
 	    (error > 0 && time_before64(local_clock(),
@@ -74,8 +75,8 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	integral_scaled = div_s64(dc->writeback_rate_integral,
 			dc->writeback_rate_i_term_inverse);
 
-	new_rate = clamp_t(int64_t, (proportional_scaled + integral_scaled),
-			dc->writeback_rate_minimum, NSEC_PER_MSEC);
+	new_rate = clamp_t(int32_t, (proportional_scaled + integral_scaled),
+			dc->writeback_rate_minimum, NSEC_PER_SEC);
 
 	dc->writeback_rate_proportional = proportional_scaled;
 	dc->writeback_rate_integral_scaled = integral_scaled;
-- 
2.11.0
