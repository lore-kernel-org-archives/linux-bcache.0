From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix race in setting bdev state
Date: Tue, 10 Oct 2017 11:07:53 +0800
Message-ID: <1507604873-31352-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

cached_dev_put() is called before setting and writing bdev to
BDEV_STATE_CLEAN state, but after calling cached_dev_put(),
detach work queue works, and bdev is also set to
BDEV_STATE_NONE state in cached_dev_detach_finish(),
it may cause race condition, and the state of bdev is uncertain.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 69e1ae5..3d134cb 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -436,9 +436,9 @@ static int bch_writeback_thread(void *arg)
 		if (searched_full_index &&
 		    RB_EMPTY_ROOT(&dc->writeback_keys.keys)) {
 			atomic_set(&dc->has_dirty, 0);
-			cached_dev_put(dc);
 			SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
 			bch_write_bdev_super(dc, NULL);
+			cached_dev_put(dc);
 		}
 
 		up_write(&dc->writeback_lock);
-- 
2.8.1.windows.1
