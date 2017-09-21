From: Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: fix a comments typo in bch_alloc_sectors()
Date: Fri, 22 Sep 2017 04:01:14 +0800
Message-ID: <20170921200114.54014-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751636AbdIUUBS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Sep 2017 16:01:18 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Coly Li <colyli@suse.de>

Code comments in alloc.c:bch_alloc_sectors() mentions a function
name find_data_bucket(), the correct function name should be
pick_data_bucket() indeed. bch_alloc_sectors() is a quite important
function in bcache allocation code, fixing the typo may help
other people to have less confusion.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index cacbe2dbd5c3..071ff28be912 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -600,7 +600,7 @@ bool bch_alloc_sectors(struct cache_set *c, struct bkey *k, unsigned sectors,
 
 	/*
 	 * If we had to allocate, we might race and not need to allocate the
-	 * second time we call find_data_bucket(). If we allocated a bucket but
+	 * second time we call pick_data_bucket(). If we allocated a bucket but
 	 * didn't use it, drop the refcount bch_bucket_alloc_set() took:
 	 */
 	if (KEY_PTRS(&alloc.key))
-- 
2.13.5
