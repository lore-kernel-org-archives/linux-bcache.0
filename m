From: Coly Li <colyli@suse.de>
Subject: [PATCH 06/15] bcache: correct dirty data statistics
Date: Mon,  8 Oct 2018 20:41:12 +0800
Message-ID: <20181008124121.20192-7-colyli@suse.de>
References: <20181008124121.20192-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181008124121.20192-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Tang Junhui <tang.junhui.linux@gmail.com>, stable@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui.linux@gmail.com>

When bcache device is clean, dirty keys may still exist after
journal replay, so we need to count these dirty keys even
device in clean status, otherwise after writeback, the amount
of dirty data would be incorrect.

Signed-off-by: Tang Junhui <tang.junhui.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a99af19d2f91..4989c7d4d4d0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1152,11 +1152,12 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	}
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
-		bch_sectors_dirty_init(&dc->disk);
 		atomic_set(&dc->has_dirty, 1);
 		bch_writeback_queue(dc);
 	}
 
+	bch_sectors_dirty_init(&dc->disk);
+
 	bch_cached_dev_run(dc);
 	bcache_device_link(&dc->disk, c, "bdev");
 	atomic_inc(&c->attached_dev_nr);
-- 
2.19.0
