From: colyli@suse.de
Subject: [PATCH 04/17] bcache: properly initialize 'path' and 'err' in register_bcache()
Date: Fri, 24 Jan 2020 01:01:29 +0800
Message-ID: <20200123170142.98974-5-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730014AbgAWRCM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:12 -0500
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

From: Coly Li <colyli@suse.de>

Patch "bcache: rework error unwinding in register_bcache" from
Christoph Hellwig changes the local variables 'path' and 'err'
in undefined initial state. If the code in register_bcache() jumps
to label 'out:' or 'out_module_put:' by goto, these two variables
might be reference with undefined value by the following line,

	out_module_put:
	        module_put(THIS_MODULE);
	out:
	        pr_info("error %s: %s", path, err);
	        return ret;

Therefore this patch initializes these two local variables properly
in register_bcache() to avoid such issue.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e8013e1b0a14..ee7c87f38d0d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2376,18 +2376,20 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size)
 {
 	const char *err;
-	char *path;
+	char *path = NULL;
 	struct cache_sb *sb;
 	struct block_device *bdev = NULL;
 	struct page *sb_page;
 	ssize_t ret;
 
 	ret = -EBUSY;
+	err = "failed to reference bcache module";
 	if (!try_module_get(THIS_MODULE))
 		goto out;
 
 	/* For latest state of bcache_is_reboot */
 	smp_mb();
+	err = "bcache is in reboot";
 	if (bcache_is_reboot)
 		goto out_module_put;
 
-- 
2.16.4
