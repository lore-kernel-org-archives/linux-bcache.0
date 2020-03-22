From: Coly Li <colyli@suse.de>
Subject: [PATCH 6/7] bcache: optimize barrier usage for Rmw atomic bitops
Date: Sun, 22 Mar 2020 14:03:04 +0800
Message-ID: <20200322060305.70637-7-colyli@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200322060305.70637-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

We can avoid the unnecessary barrier on non LL/SC architectures,
such as x86. Instead, use the smp_mb__after_atomic().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 6673a37c8bd2..72ba6d015786 100644
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
2.25.0
