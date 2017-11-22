From: Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: set task state correctly in allocator_wait()
Date: Wed, 22 Nov 2017 20:33:49 +0800
Message-ID: <20171122123349.74347-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60382 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752325AbdKVMd6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 07:33:58 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, stable@vger.kernel.org

Kthread function bch_allocator_thread() references allocator_wait(ca, cond)
and when kthread_should_stop() is true, this kthread exits.

The problem is, if kthread_should_stop() is true, macro allocator_wait()
calls "return 0" with current task state TASK_INTERRUPTIBLE. After function
bch_allocator_thread() returns to do_exit(), there are some blocking
operations are called, then a kenrel warning is popped up by __might_sleep
from kernel/sched/core.c,
  "WARNING: do not call blocking ops when !TASK_RUNNING; state=1 set at [xxxx]"

If the task is interrupted and preempted out, since its status is
TASK_INTERRUPTIBLE, it means scheduler won't pick it back to run forever,
and the allocator thread may hang in do_exit().

This patch sets allocator kthread state back to TASK_RUNNING before it
returns to do_exit(), which avoids a potential deadlock.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/alloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index a27d85232ce1..996ebbabd819 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -286,9 +286,12 @@ do {									\
 		if (cond)						\
 			break;						\
 									\
+									\
 		mutex_unlock(&(ca)->set->bucket_lock);			\
-		if (kthread_should_stop())				\
+		if (kthread_should_stop()) {				\
+			__set_current_state(TASK_RUNNING);		\
 			return 0;					\
+		}							\
 									\
 		schedule();						\
 		mutex_lock(&(ca)->set->bucket_lock);			\
-- 
2.13.6
