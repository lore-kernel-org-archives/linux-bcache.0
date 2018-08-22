From: Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: release dc->writeback_lock properly in bch_writeback_thread()
Date: Thu, 23 Aug 2018 01:46:14 +0800
Message-ID: <20180822174614.15483-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Shan Hai <shan.hai@oracle.com>, Coly Li <colyli@suse.de>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Shan Hai <shan.hai@oracle.com>

The writeback thread would exit with a lock held when the cache device is
detached via sysfs interface, fix it by releasing the held lock before exiting
the while-loop.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
Signed-off-by: Coly Li <colyli@suse.de>
Tested-by: Shenghui Wang <shhuiw@foxmail.com>
Cc: stable@vger.kernel.org #4.17+
---
 drivers/md/bcache/writeback.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 6be05bd7ca67..08c3a9f9676c 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -685,8 +685,10 @@ static int bch_writeback_thread(void *arg)
 			 * data on cache. BCACHE_DEV_DETACHING flag is set in
 			 * bch_cached_dev_detach().
 			 */
-			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
+			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags)) {
+				up_write(&dc->writeback_lock);
 				break;
+			}
 		}
 
 		up_write(&dc->writeback_lock);
-- 
2.18.0
