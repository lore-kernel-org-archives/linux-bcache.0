From: Joshua Schmid <jschmid@suse.com>
Subject: [PATCH] bcache: unregister reboot notifier when bcache fails to register a block device
Date: Tue,  3 Feb 2015 12:23:13 +0100
Message-ID: <1422962593-25813-1-git-send-email-jschmid@suse.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbbBCLXQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 3 Feb 2015 06:23:16 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

In bcache_init() function it forgot to unregister reboot notifier if
bcache fails to unregister a block device.  This commit fixes this.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Tested-by: Joshua Schmid <jschmid@suse.com>
---
 drivers/md/bcache/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f624ae8..8c2d657 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2102,8 +2102,10 @@ static int __init bcache_init(void)
 	closure_debug_init();
 
 	bcache_major = register_blkdev(0, "bcache");
-	if (bcache_major < 0)
+	if (bcache_major < 0) {
+		unregister_reboot_notifier(&reboot);
 		return bcache_major;
+	}
 
 	if (!(bcache_wq = create_workqueue("bcache")) ||
 	    !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||
-- 
2.1.2
