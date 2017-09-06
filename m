From: Coly Li <colyli@suse.de>
Subject: [PATCH 05/12] bcache: gc does not work when triggering by manual command
Date: Wed,  6 Sep 2017 14:25:55 +0800
Message-ID: <20170906062602.50497-6-colyli@suse.de>
References: <20170906062602.50497-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42309 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751737AbdIFG0t (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Sep 2017 02:26:49 -0400
In-Reply-To: <20170906062602.50497-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
Cc: bcache@lists.ewheeler.net, Tang Junhui <tang.junhui@zte.com.cn>

From: Tang Junhui <tang.junhui@zte.com.cn>

I try to execute the following command to trigger gc thread:
[root@localhost internal]# echo 1 > trigger_gc
But it does not work, I debug the code in gc_should_run(), It works only
if in invalidating or sectors_to_gc < 0. So set sectors_to_gc to -1 to
meet the condition when we trigger gc by manual command.

(Code comments aded by Coly Li)

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Reviewed-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/sysfs.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index f90f13616980..09295c07ea88 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -615,8 +615,21 @@ STORE(__bch_cache_set)
 		bch_cache_accounting_clear(&c->accounting);
 	}
 
-	if (attr == &sysfs_trigger_gc)
+	if (attr == &sysfs_trigger_gc) {
+		/*
+		 * Garbage collection thread only works when sectors_to_gc < 0,
+		 * when users write to sysfs entry trigger_gc, most of time
+		 * they want to forcibly triger gargage collection. Here -1 is
+		 * set to c->sectors_to_gc, to make gc_should_run() give a
+		 * chance to permit gc thread to run. "give a chance" means
+		 * before going into gc_should_run(), there is still chance
+		 * that c->sectors_to_gc being set to other positive value. So
+		 * writing sysfs entry trigger_gc won't always make sure gc
+		 * thread takes effect.
+		 */
+		atomic_set(&c->sectors_to_gc, -1);
 		wake_up_gc(c);
+	}
 
 	if (attr == &sysfs_prune_cache) {
 		struct shrink_control sc;
-- 
2.13.5
