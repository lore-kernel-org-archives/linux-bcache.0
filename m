From: Coly Li <colyli@suse.de>
Subject: [PATCH v5 01/10] bcache: set writeback_rate_update_seconds in range [1, 60] seconds
Date: Tue,  6 Feb 2018 12:20:51 +0800
Message-ID: <20180206042100.65021-2-colyli@suse.de>
References: <20180206042100.65021-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37707 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752141AbeBFEVW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Feb 2018 23:21:22 -0500
In-Reply-To: <20180206042100.65021-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>

dc->writeback_rate_update_seconds can be set via sysfs and its value can
be set to [1, ULONG_MAX].  It does not make sense to set such a large
value, 60 seconds is long enough value considering the default 5 seconds
works well for long time.

Because dc->writeback_rate_update is a special delayed work, it re-arms
itself inside the delayed work routine update_writeback_rate(). When
stopping it by cancel_delayed_work_sync(), there should be a timeout to
wait and make sure the re-armed delayed work is stopped too. A small max
value of dc->writeback_rate_update_seconds is also helpful to decide a
reasonable small timeout.

This patch limits sysfs interface to set dc->writeback_rate_update_seconds
in range of [1, 60] seconds, and replaces the hand-coded number by macros.

Changelog:
v2: fix a rebase typo in v4, which is pointed out by Michael Lyle.
v1: initial version.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/sysfs.c     | 4 +++-
 drivers/md/bcache/writeback.c | 2 +-
 drivers/md/bcache/writeback.h | 3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index c524305cc9a7..4a6a697e1680 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -218,7 +218,9 @@ STORE(__cached_dev)
 	sysfs_strtoul_clamp(writeback_rate,
 			    dc->writeback_rate.rate, 1, INT_MAX);
 
-	d_strtoul_nonzero(writeback_rate_update_seconds);
+	sysfs_strtoul_clamp(writeback_rate_update_seconds,
+			    dc->writeback_rate_update_seconds,
+			    1, WRITEBACK_RATE_UPDATE_SECS_MAX);
 	d_strtoul(writeback_rate_i_term_inverse);
 	d_strtoul_nonzero(writeback_rate_p_term_inverse);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 58218f7e77c3..f1d2fc15abcc 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -655,7 +655,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate.rate		= 1024;
 	dc->writeback_rate_minimum	= 8;
 
-	dc->writeback_rate_update_seconds = 5;
+	dc->writeback_rate_update_seconds = WRITEBACK_RATE_UPDATE_SECS_DEFAULT;
 	dc->writeback_rate_p_term_inverse = 40;
 	dc->writeback_rate_i_term_inverse = 10000;
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 66f1c527fa24..587b25599856 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -8,6 +8,9 @@
 #define MAX_WRITEBACKS_IN_PASS  5
 #define MAX_WRITESIZE_IN_PASS   5000	/* *512b */
 
+#define WRITEBACK_RATE_UPDATE_SECS_MAX		60
+#define WRITEBACK_RATE_UPDATE_SECS_DEFAULT	5
+
 /*
  * 14 (16384ths) is chosen here as something that each backing device
  * should be a reasonable fraction of the share, and not to blow up
-- 
2.16.1
