From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH] bcache: PI controller for writeback rate V2
Date: Thu,  7 Sep 2017 20:17:19 -0700
Message-ID: <20170908031719.23988-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34606 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753991AbdIHDR0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Sep 2017 23:17:26 -0400
Received: by mail-pg0-f66.google.com with SMTP id v82so743910pgb.1
        for <linux-bcache@vger.kernel.org>; Thu, 07 Sep 2017 20:17:26 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: colyli@suse.de, kent.overstreet@gmail.com, Michael Lyle <mlyle@lyle.org>

bcache uses a control system to attempt to keep the amount of dirty data
in cache at a user-configured level, while not responding excessively to
transients and variations in write rate.  Previously, the system was a
PD controller; but the output from it was integrated, turning the
Proportional term into an Integral term, and turning the Derivative term
into a crude Proportional term.  Performance of the controller has been
uneven in production, and it has tended to respond slowly, oscillate,
and overshoot.

This patch set replaces the current control system with an explicit PI
controller and tuning that should be correct for most hardware.  By
default, it attempts to write at a rate that would retire 1/40th of the
current excess blocks per second.  An integral term in turn works to
remove steady state errors.

IMO, this yields benefits in simplicity (removing weighted average
filtering, etc) and system performance.

Another small change is a tunable parameter is introduced to allow the
user to specify a minimum rate at which dirty blocks are retired.
Ideally one would set this writeback_rate_minimum to a small percentage
of disk bandwidth, allowing the dirty data to be slowly cleaned out when
the system is inactive.  The old behavior would try and retire 1
sector/second, and the new default is 5 sectors/second.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/bcache.h    |  9 +++--
 drivers/md/bcache/sysfs.c     | 20 ++++++-----
 drivers/md/bcache/writeback.c | 84 +++++++++++++++++++++++--------------------
 3 files changed, 61 insertions(+), 52 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 2ed9bd231d84..eb83be693d60 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -265,9 +265,6 @@ struct bcache_device {
 	atomic_t		*stripe_sectors_dirty;
 	unsigned long		*full_dirty_stripes;
 
-	unsigned long		sectors_dirty_last;
-	long			sectors_dirty_derivative;
-
 	struct bio_set		*bio_split;
 
 	unsigned		data_csum:1;
@@ -362,12 +359,14 @@ struct cached_dev {
 
 	uint64_t		writeback_rate_target;
 	int64_t			writeback_rate_proportional;
-	int64_t			writeback_rate_derivative;
+	int64_t			writeback_rate_integral;
+	int64_t			writeback_rate_integral_scaled;
 	int64_t			writeback_rate_change;
 
 	unsigned		writeback_rate_update_seconds;
-	unsigned		writeback_rate_d_term;
+	unsigned		writeback_rate_i_term_inverse;
 	unsigned		writeback_rate_p_term_inverse;
+	unsigned		writeback_rate_minimum;
 };
 
 enum alloc_reserve {
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 104c57cd666c..c27e95cc7067 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -81,8 +81,9 @@ rw_attribute(writeback_delay);
 rw_attribute(writeback_rate);
 
 rw_attribute(writeback_rate_update_seconds);
-rw_attribute(writeback_rate_d_term);
+rw_attribute(writeback_rate_i_term_inverse);
 rw_attribute(writeback_rate_p_term_inverse);
+rw_attribute(writeback_rate_minimum);
 read_attribute(writeback_rate_debug);
 
 read_attribute(stripe_size);
@@ -130,15 +131,16 @@ SHOW(__bch_cached_dev)
 	sysfs_hprint(writeback_rate,	dc->writeback_rate.rate << 9);
 
 	var_print(writeback_rate_update_seconds);
-	var_print(writeback_rate_d_term);
+	var_print(writeback_rate_i_term_inverse);
 	var_print(writeback_rate_p_term_inverse);
+	var_print(writeback_rate_minimum);
 
 	if (attr == &sysfs_writeback_rate_debug) {
 		char rate[20];
 		char dirty[20];
 		char target[20];
 		char proportional[20];
-		char derivative[20];
+		char integral[20];
 		char change[20];
 		s64 next_io;
 
@@ -146,7 +148,7 @@ SHOW(__bch_cached_dev)
 		bch_hprint(dirty,	bcache_dev_sectors_dirty(&dc->disk) << 9);
 		bch_hprint(target,	dc->writeback_rate_target << 9);
 		bch_hprint(proportional,dc->writeback_rate_proportional << 9);
-		bch_hprint(derivative,	dc->writeback_rate_derivative << 9);
+		bch_hprint(integral,	dc->writeback_rate_integral_scaled << 9);
 		bch_hprint(change,	dc->writeback_rate_change << 9);
 
 		next_io = div64_s64(dc->writeback_rate.next - local_clock(),
@@ -157,11 +159,11 @@ SHOW(__bch_cached_dev)
 			       "dirty:\t\t%s\n"
 			       "target:\t\t%s\n"
 			       "proportional:\t%s\n"
-			       "derivative:\t%s\n"
+			       "integral:\t%s\n"
 			       "change:\t\t%s/sec\n"
 			       "next io:\t%llims\n",
 			       rate, dirty, target, proportional,
-			       derivative, change, next_io);
+			       integral, change, next_io);
 	}
 
 	sysfs_hprint(dirty_data,
@@ -213,8 +215,9 @@ STORE(__cached_dev)
 			    dc->writeback_rate.rate, 1, INT_MAX);
 
 	d_strtoul_nonzero(writeback_rate_update_seconds);
-	d_strtoul(writeback_rate_d_term);
+	d_strtoul(writeback_rate_i_term_inverse);
 	d_strtoul_nonzero(writeback_rate_p_term_inverse);
+	d_strtoul_nonzero(writeback_rate_minimum);
 
 	d_strtoi_h(sequential_cutoff);
 	d_strtoi_h(readahead);
@@ -319,8 +322,9 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_writeback_percent,
 	&sysfs_writeback_rate,
 	&sysfs_writeback_rate_update_seconds,
-	&sysfs_writeback_rate_d_term,
+	&sysfs_writeback_rate_i_term_inverse,
 	&sysfs_writeback_rate_p_term_inverse,
+	&sysfs_writeback_rate_minimum,
 	&sysfs_writeback_rate_debug,
 	&sysfs_dirty_data,
 	&sysfs_stripe_size,
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 323551f7cb28..f797c844a4b8 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -25,48 +25,55 @@ static void __update_writeback_rate(struct cached_dev *dc)
 				bcache_flash_devs_sectors_dirty(c);
 	uint64_t cache_dirty_target =
 		div_u64(cache_sectors * dc->writeback_percent, 100);
-
 	int64_t target = div64_u64(cache_dirty_target * bdev_sectors(dc->bdev),
 				   c->cached_dev_sectors);
 
-	/* PD controller */
-
+	/* PI controller:
+	 * Figures out the amount that should be written per second.
+	 *
+	 * First, the error (number of sectors that are dirty beyond our
+	 * target) is calculated.  The error is accumulated (numerically
+	 * integrated).
+	 *
+	 * Then, the proportional value and integral value are scaled
+	 * based on configured values.  These are stored as inverses to
+	 * avoid fixed point math and to make configuration easy-- e.g.
+	 * the default value of 40 for writeback_rate_p_term_inverse
+	 * attempts to write at a rate that would retire all the excess
+	 * dirty blocks in 40 seconds.
+	 */
 	int64_t dirty = bcache_dev_sectors_dirty(&dc->disk);
-	int64_t derivative = dirty - dc->disk.sectors_dirty_last;
-	int64_t proportional = dirty - target;
-	int64_t change;
-
-	dc->disk.sectors_dirty_last = dirty;
-
-	/* Scale to sectors per second */
-
-	proportional *= dc->writeback_rate_update_seconds;
-	proportional = div_s64(proportional, dc->writeback_rate_p_term_inverse);
-
-	derivative = div_s64(derivative, dc->writeback_rate_update_seconds);
-
-	derivative = ewma_add(dc->disk.sectors_dirty_derivative, derivative,
-			      (dc->writeback_rate_d_term /
-			       dc->writeback_rate_update_seconds) ?: 1, 0);
-
-	derivative *= dc->writeback_rate_d_term;
-	derivative = div_s64(derivative, dc->writeback_rate_p_term_inverse);
-
-	change = proportional + derivative;
+	int64_t error = dirty - target;
+	int64_t proportional_scaled =
+		div_s64(error, dc->writeback_rate_p_term_inverse);
+	int64_t integral_scaled, new_rate;
+
+	if ((error < 0 && dc->writeback_rate_integral > 0) ||
+	    (error > 0 && time_before64(local_clock(),
+			 dc->writeback_rate.next + NSEC_PER_MSEC))) {
+		/* Only decrease the integral term if it's more than
+		 * zero.  Only increase the integral term if the device
+		 * is keeping up.  (Don't wind up the integral
+		 * ineffectively in either case).
+		 *
+		 * It's necessary to scale this by
+		 * writeback_rate_update_seconds to keep the integral
+		 * term dimensioned properly.
+		 */
+		dc->writeback_rate_integral += error *
+			dc->writeback_rate_update_seconds;
+	}
 
-	/* Don't increase writeback rate if the device isn't keeping up */
-	if (change > 0 &&
-	    time_after64(local_clock(),
-			 dc->writeback_rate.next + NSEC_PER_MSEC))
-		change = 0;
+	integral_scaled = div_s64(dc->writeback_rate_integral,
+			dc->writeback_rate_i_term_inverse);
 
-	dc->writeback_rate.rate =
-		clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
-			1, NSEC_PER_MSEC);
+	new_rate = clamp_t(int64_t, (proportional_scaled + integral_scaled),
+			dc->writeback_rate_minimum, NSEC_PER_MSEC);
 
-	dc->writeback_rate_proportional = proportional;
-	dc->writeback_rate_derivative = derivative;
-	dc->writeback_rate_change = change;
+	dc->writeback_rate_proportional = proportional_scaled;
+	dc->writeback_rate_integral_scaled = integral_scaled;
+	dc->writeback_rate_change = new_rate - dc->writeback_rate.rate;
+	dc->writeback_rate.rate = new_rate;
 	dc->writeback_rate_target = target;
 }
 
@@ -492,8 +499,6 @@ void bch_sectors_dirty_init(struct cached_dev *dc)
 
 	bch_btree_map_keys(&op.op, dc->disk.c, &KEY(op.inode, 0, 0),
 			   sectors_dirty_init_fn, 0);
-
-	dc->disk.sectors_dirty_last = bcache_dev_sectors_dirty(&dc->disk);
 }
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
@@ -507,10 +512,11 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_percent		= 10;
 	dc->writeback_delay		= 30;
 	dc->writeback_rate.rate		= 1024;
+	dc->writeback_rate_minimum	= 5;
 
 	dc->writeback_rate_update_seconds = 5;
-	dc->writeback_rate_d_term	= 30;
-	dc->writeback_rate_p_term_inverse = 6000;
+	dc->writeback_rate_p_term_inverse = 40;
+	dc->writeback_rate_i_term_inverse = 10000;
 
 	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
 }
-- 
2.11.0
