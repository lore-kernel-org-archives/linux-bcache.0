From: Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH] bcache: explicitly destory mutex while exiting
Date: Tue,  2 May 2017 16:09:55 +0800
Message-ID: <1493712595-21528-1-git-send-email-liangchen.linux@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35909 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdEBIKd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 May 2017 04:10:33 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net, Liang Chen <liangchen.linux@gmail.com>

mutex_destroy does nothing most of time, but it's better to call
it to make the code future proof and it also has some meaning
for like mutex debug.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/md/bcache/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 85e3f21..406fe03 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2083,6 +2083,7 @@ static void bcache_exit(void)
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
+	mutex_destroy(&bch_register_lock);
 }
 
 static int __init bcache_init(void)
@@ -2100,6 +2101,7 @@ static int __init bcache_init(void)
 
 	bcache_major = register_blkdev(0, "bcache");
 	if (bcache_major < 0) {
+		mutex_destroy(&bch_register_lock);
 		unregister_reboot_notifier(&reboot);
 		return bcache_major;
 	}
-- 
1.8.3.1
