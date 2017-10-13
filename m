From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 10/15] bcache: smooth writeback rate control
Date: Fri, 13 Oct 2017 16:35:37 -0700
Message-ID: <20171013233542.20938-11-mlyle@lyle.org>
References: <20171013233542.20938-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:53889 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753238AbdJMXgL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 19:36:11 -0400
Received: by mail-pg0-f65.google.com with SMTP id s2so2339540pge.10
        for <linux-bcache@vger.kernel.org>; Fri, 13 Oct 2017 16:36:10 -0700 (PDT)
In-Reply-To: <20171013233542.20938-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Michael Lyle <mlyle@lyle.org>

This works in conjunction with the new PI controller.  Currently, in
real-world workloads, the rate controller attempts to write back 1
sector per second.  In practice, these minimum-rate writebacks are
between 4k and 60k in test scenarios, since bcache aggregates and
attempts to do contiguous writes and because filesystems on top of
bcachefs typically write 4k or more.

Previously, bcache used to guarantee to write at least once per second.
This means that the actual writeback rate would exceed the configured
amount by a factor of 8-120 or more.

This patch adjusts to be willing to sleep up to 2.5 seconds, and to
target writing 4k/second.  On the smallest writes, it will sleep 1
second like before, but many times it will sleep longer and load the
backing device less.  This keeps the loading on the cache and backing
device related to writeback more consistent when writing back at low
rates.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
Reviewed-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/util.c      | 10 ++++++++--
 drivers/md/bcache/writeback.c |  2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 176d3c2ef5f5..4dbe37e82877 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -232,8 +232,14 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
 
 	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
 
-	if (time_before64(now + NSEC_PER_SEC, d->next))
-		d->next = now + NSEC_PER_SEC;
+	/* Bound the time.  Don't let us fall further than 2 seconds behind
+	 * (this prevents unnecessary backlog that would make it impossible
+	 * to catch up).  If we're ahead of the desired writeback rate,
+	 * don't let us sleep more than 2.5 seconds (so we can notice/respond
+	 * if the control system tells us to speed up!).
+	 */
+	if (time_before64(now + NSEC_PER_SEC * 5 / 2, d->next))
+		d->next = now + NSEC_PER_SEC * 5 / 2;
 
 	if (time_after64(now - NSEC_PER_SEC * 2, d->next))
 		d->next = now - NSEC_PER_SEC * 2;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index cac8678da5d0..8deb721c355e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -526,7 +526,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_percent		= 10;
 	dc->writeback_delay		= 30;
 	dc->writeback_rate.rate		= 1024;
-	dc->writeback_rate_minimum	= 1;
+	dc->writeback_rate_minimum	= 8;
 
 	dc->writeback_rate_update_seconds = 5;
 	dc->writeback_rate_p_term_inverse = 40;
-- 
2.11.0
