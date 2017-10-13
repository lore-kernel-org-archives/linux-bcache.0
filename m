From: Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH v2] bcache: safeguard a dangerous addressing in closure_queue
Date: Fri, 13 Oct 2017 13:30:49 +0800
Message-ID: <20171013053049.11875-1-liangchen.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: mlyle@lyle.org, i@coly.li, kent.overstreet@gmail.com, linux-kernel@vger.kernel.org, Liang Chen <liangchen.linux@gmail.com>
List-Id: linux-bcache@vger.kernel.org

The use of the union reduces the size of closure struct by taking advantage
of the current size of its members. The offset of func in work_struct equals
the size of the first three members, so that work.work_func will just
reference the forth member - fn.

This is smart but dangerous. It can be broken if work_struct or the other
structs get changed, and can be a bit difficult to debug.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
Replacing all occurences of closure_fn to work_func_fn seems to be an option
but that would end up with a big lenghty and error prone patch.

 drivers/md/bcache/closure.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 295b7e4..00fb314 100644
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
1.8.3.1
