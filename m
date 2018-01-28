From: Coly Li <colyli@suse.de>
Subject: [PATCH v4 01/13] bcache: set writeback_rate_update_seconds in range [1, 60] seconds
Date: Sun, 28 Jan 2018 09:56:13 +0800
Message-ID: <20180128015625.128497-2-colyli@suse.de>
References: <20180128015625.128497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180128015625.128497-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

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

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/bcache/sysfs.c     | 3 +++
 drivers/md/bcache/writeback.c | 2 +-
 drivers/md/bcache/writeback.h | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b4184092c727..a74a752c9e0f 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -215,6 +215,9 @@ STORE(__cached_dev)
 	sysfs_strtoul_clamp(writeback_rate,
 			    dc->writeback_rate.rate, 1, INT_MAX);
 
+	sysfs_strtoul_clamp(writeback_rate_update_seconds,
+			    dc->writeback_rate_update_seconds,
+			    1, WRITEBACK_RATE_UPDATE_SECS_MAX);
 	d_strtoul_nonzero(writeback_rate_update_seconds);
 	d_strtoul(writeback_rate_i_term_inverse);
 	d_strtoul_nonzero(writeback_rate_p_term_inverse);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 51306a19ab03..0ade883b6316 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -652,7 +652,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
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
2.15.1
