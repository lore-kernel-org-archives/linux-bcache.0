From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 03/15] bcache: fix a comments typo in bch_alloc_sectors()
Date: Fri, 13 Oct 2017 16:35:30 -0700
Message-ID: <20171013233542.20938-4-mlyle@lyle.org>
References: <20171013233542.20938-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171013233542.20938-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

Code comments in alloc.c:bch_alloc_sectors() mentions a function
name find_data_bucket(), the correct function name should be
pick_data_bucket() indeed. bch_alloc_sectors() is a quite important
function in bcache allocation code, fixing the typo may help
other people to have less confusion.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index e1a4205caa2e..4c40870e99f5 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -601,7 +601,7 @@ bool bch_alloc_sectors(struct cache_set *c, struct bkey *k, unsigned sectors,
 
 	/*
 	 * If we had to allocate, we might race and not need to allocate the
-	 * second time we call find_data_bucket(). If we allocated a bucket but
+	 * second time we call pick_data_bucket(). If we allocated a bucket but
 	 * didn't use it, drop the refcount bch_bucket_alloc_set() took:
 	 */
 	if (KEY_PTRS(&alloc.key))
-- 
2.11.0
