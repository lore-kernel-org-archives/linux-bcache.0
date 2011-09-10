From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: [PATCH 4/7] Don't require linkage against closure_lock
Date: Sat, 10 Sep 2011 14:45:36 +0100
Message-ID: <1315662339-3115-4-git-send-email-mark@pogo.org.uk>
References: <1109101110320.2733@stax.localdomain>
 <1315662339-3115-1-git-send-email-mark@pogo.org.uk>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315662339-3115-1-git-send-email-mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Allow building as a module with CONFIG_BCACHE_CLOSURE_DEBUG.
Previously bcache.o required access to closure_lock. Instead
of exposing this symbol move the affected function.
---
 block/bcache_util.c |   11 +++++++++++
 block/bcache_util.h |   17 +----------------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/block/bcache_util.c b/block/bcache_util.c
index 8e147de..19846fb 100644
--- a/block/bcache_util.c
+++ b/block/bcache_util.c
@@ -476,6 +476,17 @@ void closure_sync(struct closure *c)
 }
 EXPORT_SYMBOL_GPL(closure_sync);
 
+void closure_del(struct closure *c)
+{
+#ifdef CONFIG_BCACHE_CLOSURE_DEBUG
+	unsigned long flags;
+	spin_lock_irqsave(&closure_lock, flags);
+	list_del(&c->all);
+	spin_unlock_irqrestore(&closure_lock, flags);
+#endif
+}
+EXPORT_SYMBOL_GPL(closure_del);
+
 #ifdef CONFIG_BCACHE_CLOSURE_DEBUG
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/block/bcache_util.h b/block/bcache_util.h
index d208131..872ca56 100644
--- a/block/bcache_util.h
+++ b/block/bcache_util.h
@@ -474,22 +474,7 @@ void closure_run_wait(closure_list_t *list, struct workqueue_struct *wq);
 bool closure_wait(closure_list_t *list, struct closure *c);
 void closure_sync(struct closure *c);
 void __closure_sleep(struct closure *c);
-
-#ifdef CONFIG_BCACHE_CLOSURE_DEBUG
-extern struct list_head closures;
-extern spinlock_t closure_lock;
-
-static inline void closure_del(struct closure *c)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&closure_lock, flags);
-	list_del(&c->all);
-	spin_unlock_irqrestore(&closure_lock, flags);
-}
-
-#else
-static inline void closure_del(struct closure *c) {}
-#endif
+void closure_del(struct closure *c);
 
 static inline void closure_init(struct closure *c, struct closure *parent)
 {
-- 
1.7.4.4
