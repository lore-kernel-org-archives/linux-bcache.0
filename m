From: Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: remove problematic code block from register_bcache()
Date: Tue,  5 Sep 2017 15:10:49 +0800
Message-ID: <20170905071049.20273-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33364 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751148AbdIEHLI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Sep 2017 03:11:08 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>

There is a leak of bdev reference in register_bcache(), and Jan Kara
posted a patch to fix it. Discussion happened on bcache mailing list,
Christoph Hellwig pointed out that whole chunk of code where the bdev
reference leak lied was problematic,

	"adding a lookup_bdev and resulting mess just for a
	 slightly different error message is just insane"

This patch jsut removes whole chunk of the problematic code, of cause
the leak of bdev reference is removed too.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
---
 drivers/md/bcache/super.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8352fad765f6..85262f2628fb 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1955,20 +1955,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	bdev = blkdev_get_by_path(strim(path),
 				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
 				  sb);
-	if (IS_ERR(bdev)) {
-		if (bdev == ERR_PTR(-EBUSY)) {
-			bdev = lookup_bdev(strim(path));
-			mutex_lock(&bch_register_lock);
-			if (!IS_ERR(bdev) && bch_is_open(bdev))
-				err = "device already registered";
-			else
-				err = "device busy";
-			mutex_unlock(&bch_register_lock);
-			if (attr == &ksysfs_register_quiet)
-				goto out;
-		}
+	if (IS_ERR(bdev))
 		goto err;
-	}
 
 	err = "failed to set blocksize";
 	if (set_blocksize(bdev, 4096))
-- 
2.13.5
