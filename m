From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix incorrect sysfs output value of strip size
Date: Sun, 11 Feb 2018 10:30:00 +0800
Message-ID: <1518316200-31550-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Stripe size is shown as zero when no strip in back end device:
[root@ceph132 ~]# cat /sys/block/sdd/bcache/stripe_size
0.0k

Actually it should be 1T Bytes (1 << 31 sectors), but in sysfs
interface, stripe_size was changed from sectors to bytes, and move
9 bits left, so the 32 bits variable overflows.

This patch change the variable to a 64 bits type before moving bits.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b418409..240cbec 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -170,7 +170,7 @@
 	sysfs_hprint(dirty_data,
 		     bcache_dev_sectors_dirty(&dc->disk) << 9);
 
-	sysfs_hprint(stripe_size,	dc->disk.stripe_size << 9);
+	sysfs_hprint(stripe_size,	 ((uint64_t)dc->disk.stripe_size) << 9);
 	var_printf(partial_stripes_expensive,	"%u");
 
 	var_hprint(sequential_cutoff);
-- 
1.8.3.1
