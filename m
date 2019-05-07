From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 38/95] bcache: correct dirty data statistics
Date: Tue,  7 May 2019 01:37:27 -0400
Message-ID: <20190507053826.31622-38-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tang Junhui <tang.junhui.linux@gmail.com>, Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <alexander.levin@microsoft.com>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui.linux@gmail.com>

[ Upstream commit 2e17a262a2371d38d2ec03614a2675a32cef9912 ]

When bcache device is clean, dirty keys may still exist after
journal replay, so we need to count these dirty keys even
device in clean status, otherwise after writeback, the amount
of dirty data would be incorrect.

Signed-off-by: Tang Junhui <tang.junhui.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fe6e4c319b7c..9e875aba41b9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1045,12 +1045,13 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	}
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
-		bch_sectors_dirty_init(&dc->disk);
 		atomic_set(&dc->has_dirty, 1);
 		atomic_inc(&dc->count);
 		bch_writeback_queue(dc);
 	}
 
+	bch_sectors_dirty_init(&dc->disk);
+
 	bch_cached_dev_run(dc);
 	bcache_device_link(&dc->disk, c, "bdev");
 
-- 
2.20.1
