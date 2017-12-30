From: Michael Lyle <mlyle@lyle.org>
Subject: [for-416 PATCH 1/2] bcache: Fix, improve efficiency of closure_sync()
Date: Sat, 30 Dec 2017 15:09:33 -0800
Message-ID: <20171230230934.910-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:40804 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdL3XJq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Dec 2017 18:09:46 -0500
Received: by mail-pl0-f65.google.com with SMTP id 62so23508885pld.7
        for <linux-bcache@vger.kernel.org>; Sat, 30 Dec 2017 15:09:46 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Michael Lyle <mlyle@lyle.org>

From: Kent Overstreet <kent.overstreet@gmail.com>

Eliminates cases where sync can race and fail to complete / get stuck.
Removes many status flags and simplifies entering-and-exiting closure
sleeping behaviors.

[mlyle: fixed conflicts due to changed return behavior in mainline.
extended commit comment, and squashed down two commits that were mostly
contradictory to get to this state]

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Michael Lyle <mlyle@lyle.org>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/closure.c | 47 ++++++++++++++++++-----------------
 drivers/md/bcache/closure.h | 60 +++++++++++++++++----------------------------
 2 files changed, 47 insertions(+), 60 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 1841d0359bac..8a4f4e4f5537 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -18,10 +18,6 @@ static inline void closure_put_after_sub(struct closure *cl, int flags)
 	BUG_ON(flags & CLOSURE_GUARD_MASK);
 	BUG_ON(!r && (flags & ~CLOSURE_DESTRUCTOR));
 
-	/* Must deliver precisely one wakeup */
-	if (r == 1 && (flags & CLOSURE_SLEEPING))
-		wake_up_process(cl->task);
-
 	if (!r) {
 		if (cl->fn && !(flags & CLOSURE_DESTRUCTOR)) {
 			atomic_set(&cl->remaining,
@@ -100,28 +96,35 @@ bool closure_wait(struct closure_waitlist *waitlist, struct closure *cl)
 }
 EXPORT_SYMBOL(closure_wait);
 
-/**
- * closure_sync - sleep until a closure has nothing left to wait on
- *
- * Sleeps until the refcount hits 1 - the thread that's running the closure owns
- * the last refcount.
- */
-void closure_sync(struct closure *cl)
+struct closure_syncer {
+	struct task_struct	*task;
+	int			done;
+};
+
+static void closure_sync_fn(struct closure *cl)
 {
-	while (1) {
-		__closure_start_sleep(cl);
-		closure_set_ret_ip(cl);
+	cl->s->done = 1;
+	wake_up_process(cl->s->task);
+}
 
-		if ((atomic_read(&cl->remaining) &
-		     CLOSURE_REMAINING_MASK) == 1)
-			break;
+void __closure_sync(struct closure *cl)
+{
+	struct closure_syncer s = { .task = current };
 
+	cl->s = &s;
+	continue_at(cl, closure_sync_fn, NULL);
+
+	while (1) {
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		smp_mb(); /* Ensure task state set before load of done flag */
+		if (s.done)
+			break;
 		schedule();
 	}
 
-	__closure_end_sleep(cl);
+	__set_current_state(TASK_RUNNING);
 }
-EXPORT_SYMBOL(closure_sync);
+EXPORT_SYMBOL(__closure_sync);
 
 #ifdef CONFIG_BCACHE_CLOSURES_DEBUG
 
@@ -168,12 +171,10 @@ static int debug_seq_show(struct seq_file *f, void *data)
 			   cl, (void *) cl->ip, cl->fn, cl->parent,
 			   r & CLOSURE_REMAINING_MASK);
 
-		seq_printf(f, "%s%s%s%s\n",
+		seq_printf(f, "%s%s\n",
 			   test_bit(WORK_STRUCT_PENDING_BIT,
 				    work_data_bits(&cl->work)) ? "Q" : "",
-			   r & CLOSURE_RUNNING	? "R" : "",
-			   r & CLOSURE_STACK	? "S" : "",
-			   r & CLOSURE_SLEEPING	? "Sl" : "");
+			   r & CLOSURE_RUNNING	? "R" : "");
 
 		if (r & CLOSURE_WAITING)
 			seq_printf(f, " W %pF\n",
diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index ccfbea6f9f6b..392a87cf1b92 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -103,6 +103,7 @@
  */
 
 struct closure;
+struct closure_syncer;
 typedef void (closure_fn) (struct closure *);
 
 struct closure_waitlist {
@@ -115,10 +116,6 @@ enum closure_state {
 	 * the thread that owns the closure, and cleared by the thread that's
 	 * waking up the closure.
 	 *
-	 * CLOSURE_SLEEPING: Must be set before a thread uses a closure to sleep
-	 * - indicates that cl->task is valid and closure_put() may wake it up.
-	 * Only set or cleared by the thread that owns the closure.
-	 *
 	 * The rest are for debugging and don't affect behaviour:
 	 *
 	 * CLOSURE_RUNNING: Set when a closure is running (i.e. by
@@ -128,22 +125,16 @@ enum closure_state {
 	 * continue_at() and closure_return() clear it for you, if you're doing
 	 * something unusual you can use closure_set_dead() which also helps
 	 * annotate where references are being transferred.
-	 *
-	 * CLOSURE_STACK: Sanity check - remaining should never hit 0 on a
-	 * closure with this flag set
 	 */
 
-	CLOSURE_BITS_START	= (1 << 23),
-	CLOSURE_DESTRUCTOR	= (1 << 23),
-	CLOSURE_WAITING		= (1 << 25),
-	CLOSURE_SLEEPING	= (1 << 27),
-	CLOSURE_RUNNING		= (1 << 29),
-	CLOSURE_STACK		= (1 << 31),
+	CLOSURE_BITS_START	= (1U << 27),
+	CLOSURE_DESTRUCTOR	= (1U << 27),
+	CLOSURE_WAITING		= (1U << 29),
+	CLOSURE_RUNNING		= (1U << 31),
 };
 
 #define CLOSURE_GUARD_MASK					\
-	((CLOSURE_DESTRUCTOR|CLOSURE_WAITING|CLOSURE_SLEEPING|	\
-	  CLOSURE_RUNNING|CLOSURE_STACK) << 1)
+	((CLOSURE_DESTRUCTOR|CLOSURE_WAITING|CLOSURE_RUNNING) << 1)
 
 #define CLOSURE_REMAINING_MASK		(CLOSURE_BITS_START - 1)
 #define CLOSURE_REMAINING_INITIALIZER	(1|CLOSURE_RUNNING)
@@ -152,7 +143,7 @@ struct closure {
 	union {
 		struct {
 			struct workqueue_struct *wq;
-			struct task_struct	*task;
+			struct closure_syncer	*s;
 			struct llist_node	list;
 			closure_fn		*fn;
 		};
@@ -178,7 +169,19 @@ void closure_sub(struct closure *cl, int v);
 void closure_put(struct closure *cl);
 void __closure_wake_up(struct closure_waitlist *list);
 bool closure_wait(struct closure_waitlist *list, struct closure *cl);
-void closure_sync(struct closure *cl);
+void __closure_sync(struct closure *cl);
+
+/**
+ * closure_sync - sleep until a closure a closure has nothing left to wait on
+ *
+ * Sleeps until the refcount hits 1 - the thread that's running the closure owns
+ * the last refcount.
+ */
+static inline void closure_sync(struct closure *cl)
+{
+	if ((atomic_read(&cl->remaining) & CLOSURE_REMAINING_MASK) != 1)
+		__closure_sync(cl);
+}
 
 #ifdef CONFIG_BCACHE_CLOSURES_DEBUG
 
@@ -215,24 +218,6 @@ static inline void closure_set_waiting(struct closure *cl, unsigned long f)
 #endif
 }
 
-static inline void __closure_end_sleep(struct closure *cl)
-{
-	__set_current_state(TASK_RUNNING);
-
-	if (atomic_read(&cl->remaining) & CLOSURE_SLEEPING)
-		atomic_sub(CLOSURE_SLEEPING, &cl->remaining);
-}
-
-static inline void __closure_start_sleep(struct closure *cl)
-{
-	closure_set_ip(cl);
-	cl->task = current;
-	set_current_state(TASK_UNINTERRUPTIBLE);
-
-	if (!(atomic_read(&cl->remaining) & CLOSURE_SLEEPING))
-		atomic_add(CLOSURE_SLEEPING, &cl->remaining);
-}
-
 static inline void closure_set_stopped(struct closure *cl)
 {
 	atomic_sub(CLOSURE_RUNNING, &cl->remaining);
@@ -241,7 +226,6 @@ static inline void closure_set_stopped(struct closure *cl)
 static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
 				  struct workqueue_struct *wq)
 {
-	BUG_ON(object_is_on_stack(cl));
 	closure_set_ip(cl);
 	cl->fn = fn;
 	cl->wq = wq;
@@ -300,7 +284,7 @@ static inline void closure_init(struct closure *cl, struct closure *parent)
 static inline void closure_init_stack(struct closure *cl)
 {
 	memset(cl, 0, sizeof(struct closure));
-	atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER|CLOSURE_STACK);
+	atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER);
 }
 
 /**
@@ -322,6 +306,8 @@ static inline void closure_wake_up(struct closure_waitlist *list)
  * This is because after calling continue_at() you no longer have a ref on @cl,
  * and whatever @cl owns may be freed out from under you - a running closure fn
  * has a ref on its own closure which continue_at() drops.
+ *
+ * Note you are expected to immediately return after using this macro.
  */
 #define continue_at(_cl, _fn, _wq)					\
 do {									\
-- 
2.14.1
