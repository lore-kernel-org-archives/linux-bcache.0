From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix wrong return value in bch_debug_init()
Date: Mon, 25 Dec 2017 19:39:40 +0800
Message-ID: <1514201980-30595-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:55446 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdLYLil (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Dec 2017 06:38:41 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

in bch_debug_init(), ret is always 0, and the return value is useless,
change it to return 0 if be success after calling debugfs_create_dir(),
else return a non-zero value.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/debug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index c7a02c4..2bb0b28
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -251,8 +251,7 @@ void bch_debug_exit(void)
 
 int __init bch_debug_init(struct kobject *kobj)
 {
-	int ret = 0;
-
 	debug = debugfs_create_dir("bcache", NULL);
-	return ret;
+
+	return IS_ERR_OR_NULL(debug);
 }
-- 
1.8.3.1
