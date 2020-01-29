From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH] bcache: optimize barrier usage for Rmw atomic bitops
Date: Wed, 29 Jan 2020 10:08:02 -0800
Message-ID: <20200129180802.24626-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-bcache@vger.kernel.org

We can avoid the unnecessary barrier on non LL/SC architectures,
such as x86. Instead, use the smp_mb__after_atomic().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/md/bcache/writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4a40f9eadeaf..284ff10f480f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -183,7 +183,7 @@ static void update_writeback_rate(struct work_struct *work)
 	 */
 	set_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
 	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
-	smp_mb();
+	smp_mb__after_atomic();
 
 	/*
 	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
@@ -193,7 +193,7 @@ static void update_writeback_rate(struct work_struct *work)
 	    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
 		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
 		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
-		smp_mb();
+		smp_mb__after_atomic();
 		return;
 	}
 
@@ -229,7 +229,7 @@ static void update_writeback_rate(struct work_struct *work)
 	 */
 	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
 	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
-	smp_mb();
+	smp_mb__after_atomic();
 }
 
 static unsigned int writeback_delay(struct cached_dev *dc,
-- 
2.16.4
