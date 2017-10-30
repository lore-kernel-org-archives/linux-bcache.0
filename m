From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 5/5] bcache: explicitly destroy mutex while exiting
Date: Mon, 30 Oct 2017 14:46:35 -0700
Message-ID: <20171030214635.29888-6-mlyle@lyle.org>
References: <20171030214635.29888-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46821 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933128AbdJ3VrC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Oct 2017 17:47:02 -0400
Received: by mail-pf0-f195.google.com with SMTP id p87so12072926pfj.3
        for <linux-bcache@vger.kernel.org>; Mon, 30 Oct 2017 14:47:02 -0700 (PDT)
In-Reply-To: <20171030214635.29888-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Liang Chen <liangchen.linux@gmail.com>

From: Liang Chen <liangchen.linux@gmail.com>

mutex_destroy does nothing most of time, but it's better to call
it to make the code future proof and it also has some meaning
for like mutex debug.

As Coly pointed out in a previous review, bcache_exit() may not be
able to handle all the references properly if userspace registers
cache and backing devices right before bch_debug_init runs and
bch_debug_init failes later. So not exposing userspace interface
until everything is ready to avoid that issue.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
Reviewed-by: Coly Li <colyli@suse.de>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
---
 drivers/md/bcache/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 46134c45c6f6..b4d28928dec5 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2095,6 +2095,7 @@ static void bcache_exit(void)
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
+	mutex_destroy(&bch_register_lock);
 }
 
 static int __init bcache_init(void)
@@ -2113,14 +2114,15 @@ static int __init bcache_init(void)
 	bcache_major = register_blkdev(0, "bcache");
 	if (bcache_major < 0) {
 		unregister_reboot_notifier(&reboot);
+		mutex_destroy(&bch_register_lock);
 		return bcache_major;
 	}
 
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
2.11.0
