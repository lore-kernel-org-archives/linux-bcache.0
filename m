From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] bcache: unregister reboot notifier when bcache fails to register a block device
Date: Sat, 18 Oct 2014 21:13:58 +0800
Message-ID: <1413638038-18791-1-git-send-email-wenqing.lz@taobao.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57582 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaJRND1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 18 Oct 2014 09:03:27 -0400
Received: by mail-pa0-f47.google.com with SMTP id rd3so2407554pab.20
        for <linux-bcache@vger.kernel.org>; Sat, 18 Oct 2014 06:03:26 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

In bcache_init() function it forgot to unregister reboot notifier if
bcache fails to unregister a block device.  This commit fixes this.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 drivers/md/bcache/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d4713d0..bbb0d45 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2099,8 +2099,10 @@ static int __init bcache_init(void)
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
1.7.1
