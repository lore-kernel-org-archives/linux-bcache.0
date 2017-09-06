From: Coly Li <colyli@suse.de>
Subject: [PATCH 11/12] bcache: Update continue_at() documentation
Date: Wed,  6 Sep 2017 14:26:01 +0800
Message-ID: <20170906062602.50497-12-colyli@suse.de>
References: <20170906062602.50497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170906062602.50497-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
Cc: bcache@lists.ewheeler.net, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-bcache@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

continue_at() doesn't have a return statement anymore.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Coly Li <colyli@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/closure.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 1ec84ca81146..295b7e43f92c 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -312,8 +312,6 @@ static inline void closure_wake_up(struct closure_waitlist *list)
  * been dropped with closure_put()), it will resume execution at @fn running out
  * of @wq (or, if @wq is NULL, @fn will be called by closure_put() directly).
  *
- * NOTE: This macro expands to a return in the calling function!
- *
  * This is because after calling continue_at() you no longer have a ref on @cl,
  * and whatever @cl owns may be freed out from under you - a running closure fn
  * has a ref on its own closure which continue_at() drops.
@@ -340,8 +338,6 @@ do {									\
  * Causes @fn to be executed out of @cl, in @wq context (or called directly if
  * @wq is NULL).
  *
- * NOTE: like continue_at(), this macro expands to a return in the caller!
- *
  * The ref the caller of continue_at_nobarrier() had on @cl is now owned by @fn,
  * thus it's not safe to touch anything protected by @cl after a
  * continue_at_nobarrier().
-- 
2.13.5
