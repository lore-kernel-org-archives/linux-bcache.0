From: Jianjian Huo <samuel.huo@gmail.com>
Subject: [PATCH] bcache: block shutdown if cached_dev detaching still ongoing
Date: Sun, 13 Jul 2014 09:08:58 -0700
Message-ID: <1405267739-5063-1-git-send-email-samuel.huo@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53211 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaGMQJX (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 13 Jul 2014 12:09:23 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so104445pab.29
        for <linux-bcache@vger.kernel.org>; Sun, 13 Jul 2014 09:09:22 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: kmo@daterainc.com, Jianjian Huo <samuel.huo@gmail.com>

Backing device detaching will write back dirty data and update super block when it's finished, but won't set any flag to superblock after detaching starts. If system shuts down before detaching finishs, later cache set would never know detaching ever started before; what's worse, if users think detaching is done after shutdown and remove SSD which still contains dirty data, user would have a difficult time to bring up backing device again.

This patch will block bcache_reboot, if any cached_dev is still detaching, to guarantee detaching is done before shutdown. Another way will be adding a flag to superblock, then next bootup will continue unfinished detaching, but this won't solve the above worse case scenario.

This patch has been verified ay my setup for several test cases. And below is the new screen printout during shutdown, in case writeback is still ongoing.

bcache: bcache_reboot() Stopping all devices:
bcache: bcache_reboot() Backing device detaching hasn't been finished yet, please wait.
bcache: cached_dev_detach_finish() Caching disabled for loop1
bcache: cache_set_free() Cache set 69f2e475-3afc-42bf-b94d-8beb40030f59 unregistered
bcache: bcache_reboot() Timeout waiting for devices to be closed
reboot: System halted

Signed-off-by: Jianjian Huo <samuel.huo@gmail.com>
---
 drivers/md/bcache/super.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 5a78df8..92dcbfd 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1981,6 +1981,22 @@ err:
 	goto out;
 }
 
+static bool should_block_reboot(void)
+{
+	struct cache_set *c, *tc;
+	struct cached_dev *dc, *t;
+
+	lockdep_assert_held(&bch_register_lock);
+
+	/*block reboot if any cached_dev is detaching*/
+	list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
+		list_for_each_entry_safe(dc, t, &c->cached_devs, list)
+			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
+				return true;
+
+	return false;
+}
+
 static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 {
 	if (code == SYS_DOWN ||
@@ -2010,18 +2026,27 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		/* What's a condition variable? */
 		while (1) {
 			long timeout = start + 2 * HZ - jiffies;
+			bool blocking =  false;
 
 			stopped = list_empty(&bch_cache_sets) &&
 				list_empty(&uncached_devices);
 
-			if (timeout < 0 || stopped)
+			blocking = should_block_reboot();
+
+			if ((timeout < 0 && !blocking) || stopped)
 				break;
 
 			prepare_to_wait(&unregister_wait, &wait,
 					TASK_UNINTERRUPTIBLE);
 
 			mutex_unlock(&bch_register_lock);
-			schedule_timeout(timeout);
+			if (blocking) {
+				pr_notice("Backing device detaching hasn't "
+					"been finished yet, please wait.");
+				schedule();
+			} else {
+				schedule_timeout(timeout);
+			}
 			mutex_lock(&bch_register_lock);
 		}
 
-- 
1.7.9.5
