From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 13/15] bcache: safeguard a dangerous addressing in closure_queue
Date: Fri, 13 Oct 2017 16:35:40 -0700
Message-ID: <20171013233542.20938-14-mlyle@lyle.org>
References: <20171013233542.20938-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171013233542.20938-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Liang Chen <liangchen.linux@gmail.com>
List-Id: linux-bcache@vger.kernel.org

From: Liang Chen <liangchen.linux@gmail.com>

The use of the union reduces the size of closure struct by taking advantage
of the current size of its members. The offset of func in work_struct
equals the size of the first three members, so that work.work_func will
just reference the forth member - fn.

This is smart but dangerous. It can be broken if work_struct or the other
structs get changed, and can be a bit difficult to debug.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/closure.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 295b7e43f92c..00fb314cce57 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -251,6 +251,12 @@ static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
 static inline void closure_queue(struct closure *cl)
 {
 	struct workqueue_struct *wq = cl->wq;
+	/**
+	 * Changes made to closure, work_struct, or a couple of other structs
+	 * may cause work.func not pointing to the right location.
+	 */
+	BUILD_BUG_ON(offsetof(struct closure, fn)
+		     != offsetof(struct work_struct, func));
 	if (wq) {
 		INIT_WORK(&cl->work, cl->work.func);
 		BUG_ON(!queue_work(wq, &cl->work));
-- 
2.11.0
