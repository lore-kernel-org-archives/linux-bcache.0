From: Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH] bcache: not exposing userspace interface until ready
Date: Wed,  5 Jul 2017 20:19:52 +0800
Message-ID: <1499257192-25673-1-git-send-email-liangchen.linux@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35426 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdGEMUN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jul 2017 08:20:13 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net, Liang Chen <liangchen.linux@gmail.com>

As Coly pointed out, bcache_exit() may not be able to handle all the
references properly, if userspace registers cache and backing devices
right before bch_debug_init and bch_debug_init failes later.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/md/bcache/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2a5c38c..c74f7d8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2104,9 +2104,9 @@ static int __init bcache_init(void)
 
 	if (!(bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0)) ||
 	    !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||
-	    sysfs_create_files(bcache_kobj, files) ||
 	    bch_request_init() ||
-	    bch_debug_init(bcache_kobj))
+	    bch_debug_init(bcache_kobj) ||
+	    sysfs_create_files(bcache_kobj, files))
 		goto err;
 
 	return 0;
-- 
1.8.3.1
