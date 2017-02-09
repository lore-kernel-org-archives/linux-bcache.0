From: Jan Kara <jack@suse.cz>
Subject: [PATCH] bcache: Fix leak of bdev reference
Date: Thu,  9 Feb 2017 14:19:16 +0100
Message-ID: <20170209131916.13330-1-jack@suse.cz>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36785 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdBINTx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Feb 2017 08:19:53 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Jan Kara <jack@suse.cz>

If blkdev_get_by_path() in register_bcache() fails, we try to lookup the
block device using lookup_bdev() to detect which situation we are in to
properly report error. However we never drop the reference returned to
us from lookup_bdev(). Fix that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/bcache/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3a19cbc8b230..2a6a4a0520f6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1964,6 +1964,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			else
 				err = "device busy";
 			mutex_unlock(&bch_register_lock);
+			if (!IS_ERR(bdev))
+				bdput(bdev);
 			if (attr == &ksysfs_register_quiet)
 				goto out;
 		}
-- 
2.10.2
