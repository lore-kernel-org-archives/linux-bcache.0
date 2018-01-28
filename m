From: Coly Li <colyli@suse.de>
Subject: [PATCH v4 02/13] bcache: properly set task state in bch_writeback_thread()
Date: Sun, 28 Jan 2018 09:56:14 +0800
Message-ID: <20180128015625.128497-3-colyli@suse.de>
References: <20180128015625.128497-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751832AbeA1CEK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 27 Jan 2018 21:04:10 -0500
In-Reply-To: <20180128015625.128497-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>

Kernel thread routine bch_writeback_thread() has the following code block,

447         down_write(&dc->writeback_lock);
448~450     if (check conditions) {
451                 up_write(&dc->writeback_lock);
452                 set_current_state(TASK_INTERRUPTIBLE);
453
454                 if (kthread_should_stop())
455                         return 0;
456
457                 schedule();
458                 continue;
459         }

If condition check is true, its task state is set to TASK_INTERRUPTIBLE
and call schedule() to wait for others to wake up it.

There are 2 issues in current code,
1, Task state is set to TASK_INTERRUPTIBLE after the condition checks, if
   another process changes the condition and call wake_up_process(dc->
   writeback_thread), then at line 452 task state is set back to
   TASK_INTERRUPTIBLE, the writeback kernel thread will lose a chance to be
   waken up.
2, At line 454 if kthread_should_stop() is true, writeback kernel thread
   will return to kernel/kthread.c:kthread() with TASK_INTERRUPTIBLE and
   call do_exit(). It is not good to enter do_exit() with task state
   TASK_INTERRUPTIBLE, in following code path might_sleep() is called and a
   warning message is reported by __might_sleep(): "WARNING: do not call
   blocking ops when !TASK_RUNNING; state=1 set at [xxxx]".

For the first issue, task state should be set before condition checks.
Ineed because dc->writeback_lock is required when modifying all the
conditions, calling set_current_state() inside code block where dc->
writeback_lock is hold is safe. But this is quite implicit, so I still move
set_current_state() before all the condition checks.

For the second issue, frankley speaking it does not hurt when kernel thread
exits with TASK_INTERRUPTIBLE state, but this warning message scares users,
makes them feel there might be something risky with bcache and hurt their
data.  Setting task state to TASK_RUNNING before returning fixes this
problem.

In alloc.c:allocator_wait(), there is also a similar issue, and is also
fixed in this patch.

Changelog:
v3: merge two similar fixes into one patch
v2: fix the race issue in v1 patch.
v1: initial buggy fix.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/alloc.c     | 4 +++-
 drivers/md/bcache/writeback.c | 7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

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
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0ade883b6316..f1d2fc15abcc 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -564,18 +564,21 @@ static int bch_writeback_thread(void *arg)
 
 	while (!kthread_should_stop()) {
 		down_write(&dc->writeback_lock);
+		set_current_state(TASK_INTERRUPTIBLE);
 		if (!atomic_read(&dc->has_dirty) ||
 		    (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
 		     !dc->writeback_running)) {
 			up_write(&dc->writeback_lock);
-			set_current_state(TASK_INTERRUPTIBLE);
 
-			if (kthread_should_stop())
+			if (kthread_should_stop()) {
+				set_current_state(TASK_RUNNING);
 				return 0;
+			}
 
 			schedule();
 			continue;
 		}
+		set_current_state(TASK_RUNNING);
 
 		searched_full_index = refill_dirty(dc);
 
-- 
2.15.1
