From: tang.junhui@zte.com.cn
Subject: [PATCH v2] bcache: stop writeback thread after detaching
Date: Wed, 22 Nov 2017 14:20:13 +0800
Message-ID: <1511331613-23140-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:40250 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751368AbdKVGUj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 01:20:39 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Currently, when a cached device detaching from cache, writeback thread is
not stopped, and writeback_rate_update work is not canceled. For example,
after bellow command:
echo 1 >/sys/block/sdb/bcache/detach
you can still see the writeback thread. Then you attach the device to the
cache again, bcache will create another writeback thread, for example,
after bellow command:
echo  ba0fb5cd-658a-4533-9806-6ce166d883b9 > /sys/block/sdb/bcache/attach
then you will see 2 writeback threads.
This patch stops writeback thread and cancels writeback_rate_update work
when cached device detaching from cache.

Compare with patch v1, this v2 patch moves code down into the register
lock for safety in case of any future changes as Coly and mike suggested.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/super.c | 6 ++++++
 1 file changed, 6 insertions(+)
 mode change 100644 => 100755 drivers/md/bcache/super.c

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
old mode 100644
new mode 100755
index 8352fad..1c5136e
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -893,6 +893,12 @@ static void cached_dev_detach_finish(struct work_struct *w)
 
 	mutex_lock(&bch_register_lock);
 
+	cancel_delayed_work_sync(&dc->writeback_rate_update);
+	if (!IS_ERR_OR_NULL(dc->writeback_thread)) {
+		kthread_stop(dc->writeback_thread);
+		dc->writeback_thread = NULL;
+	}
+
 	memset(&dc->sb.set_uuid, 0, 16);
 	SET_BDEV_STATE(&dc->sb, BDEV_STATE_NONE);
 
-- 
1.8.3.1
