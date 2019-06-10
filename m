From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 09/12] bcache: optimize continue_at_nobarrier()
Date: Mon, 10 Jun 2019 15:14:17 -0400
Message-ID: <20190610191420.27007-10-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/bcache/closure.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index c88cdc4ae4..376c5e659c 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -245,7 +245,7 @@ static inline void closure_queue(struct closure *cl)
 		     != offsetof(struct work_struct, func));
 	if (wq) {
 		INIT_WORK(&cl->work, cl->work.func);
-		BUG_ON(!queue_work(wq, &cl->work));
+		queue_work(wq, &cl->work);
 	} else
 		cl->fn(cl);
 }
@@ -340,8 +340,13 @@ do {									\
  */
 #define continue_at_nobarrier(_cl, _fn, _wq)				\
 do {									\
-	set_closure_fn(_cl, _fn, _wq);					\
-	closure_queue(_cl);						\
+	closure_set_ip(_cl);						\
+	if (_wq) {							\
+		INIT_WORK(&(_cl)->work, (void *) _fn);			\
+		queue_work((_wq), &(_cl)->work);			\
+	} else {							\
+		(_fn)(_cl);						\
+	}								\
 } while (0)
 
 /**
-- 
2.20.1
