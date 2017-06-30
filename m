From: bcache@lists.ewheeler.net
Subject: [PATCH 19/19] bcache: Update continue_at() documentation
Date: Fri, 30 Jun 2017 13:43:08 -0700
Message-ID: <1498855388-16990-19-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:43922 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752899AbdF3Un7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Jun 2017 16:43:59 -0400
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Dan Carpenter <dan.carpenter@oracle.com>

From: Dan Carpenter <dan.carpenter@oracle.com>

continue_at() doesn't have a return statement anymore.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/md/bcache/closure.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 1ec84ca..295b7e4 100644
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
1.8.3.1
