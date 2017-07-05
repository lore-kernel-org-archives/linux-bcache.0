From: Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH] bcache: avoid a dangerous addressing in closure_queue
Date: Wed,  5 Jul 2017 20:53:19 +0800
Message-ID: <1499259199-15161-1-git-send-email-liangchen.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net, Liang Chen <liangchen.linux@gmail.com>
List-Id: linux-bcache@vger.kernel.org

The use of the union reduces the size of closure struct by taking advantage
of the current size of its members. The offset of func in work_struct equals
the size of the first three members, so that work.work_func will just
reference the forth member - the pointer to closure_fn.

This is smart but dangerous. It can be broken if work_struct or the other
ones get changed, and can be a bit difficult to debug.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/md/bcache/closure.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 1ec84ca..665c470 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -251,8 +251,9 @@ static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
 static inline void closure_queue(struct closure *cl)
 {
 	struct workqueue_struct *wq = cl->wq;
+	closure_fn		*fn = cl->fn;
 	if (wq) {
-		INIT_WORK(&cl->work, cl->work.func);
+		INIT_WORK(&cl->work, (work_func_t)fn);
 		BUG_ON(!queue_work(wq, &cl->work));
 	} else
 		cl->fn(cl);
-- 
1.8.3.1
