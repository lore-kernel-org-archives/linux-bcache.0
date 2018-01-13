From: Coly Li <colyli@suse.de>
Subject: [PATCH v2 03/12] bcache: set task properly in allocator_wait()
Date: Sun, 14 Jan 2018 01:10:41 +0800
Message-ID: <20180113171050.22467-4-colyli@suse.de>
References: <20180113171050.22467-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180113171050.22467-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>, Hannes Reinecke <hare@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>
List-Id: linux-bcache@vger.kernel.org

Kernel thread routine bch_allocator_thread() references macro
allocator_wait() to wait for a condition or quit to do_exit()
when kthread_should_stop() is true. Here is the code block,

284         while (1) {                                                   \
285                 set_current_state(TASK_INTERRUPTIBLE);                \
286                 if (cond)                                             \
287                         break;                                        \
288                                                                       \
289                 mutex_unlock(&(ca)->set->bucket_lock);                \
290                 if (kthread_should_stop())                            \
291                         return 0;                                     \
292                                                                       \
293                 schedule();                                           \
294                 mutex_lock(&(ca)->set->bucket_lock);                  \
295         }                                                             \
296         __set_current_state(TASK_RUNNING);                            \

At line 285, task state is set to TASK_INTERRUPTIBLE, if at line 290
kthread_should_stop() is true, the kernel thread will terminate and return
to kernel/kthread.s:kthread(), then calls do_exit() with TASK_INTERRUPTIBLE
state. This is not a suggested behavior and a warning message will be
reported by might_sleep() in do_exit() code path: "WARNING: do not call
blocking ops when !TASK_RUNNING; state=1 set at [xxxx]".

This patch fixes this problem by setting task state to TASK_RUNNING if
kthread_should_stop() is true and before kernel thread returns back to
kernel/kthread.s:kthread().

Changelog:
v2: fix the race issue in v1 patch.
v1: initial buggy fix.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 6cc6c0f9c3a9..458e1d38577d 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -287,8 +287,10 @@ do {									\
 			break;						\
 									\
 		mutex_unlock(&(ca)->set->bucket_lock);			\
-		if (kthread_should_stop())				\
+		if (kthread_should_stop()) {				\
+			set_current_state(TASK_RUNNING);		\
 			return 0;					\
+		}							\
 									\
 		schedule();						\
 		mutex_lock(&(ca)->set->bucket_lock);			\
-- 
2.15.1
