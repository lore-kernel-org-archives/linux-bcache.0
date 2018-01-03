From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v1 02/10] bcache: set task properly in allocator_wait()
Date: Thu, 4 Jan 2018 02:29:37 +0800
Message-ID: <1515004177-6779-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

LGTM.

Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

>Kernel thread routine bch_allocator_thread() references macro
>allocator_wait() to wait for a condition or quit to do_exit()
>when kthread_should_stop() is true.
>
>Macro allocator_wait() has 2 issues in setting task state, let's
>see its code piece,
>
>284         while (1) {                                                   \
>285                 set_current_state(TASK_INTERRUPTIBLE);                \
>286                 if (cond)                                             \
>287                         break;                                        \
>288                                                                       \
>289                 mutex_unlock(&(ca)->set->bucket_lock);                \
>290                 if (kthread_should_stop())                            \
>291                         return 0;                                     \
>292                                                                       \
>293                 schedule();                                           \
>294                 mutex_lock(&(ca)->set->bucket_lock);                  \
>295         }                                                             \
>296         __set_current_state(TASK_RUNNING);                            \
>
>1) At line 285, task state is set to TASK_INTERRUPTIBLE, if at line 290
>kthread_should_stop() is true, the kernel thread will terminate and return
>to kernel/kthread.s:kthread(), then calls do_exit() with TASK_INTERRUPTIBLE
>state. This is not a suggested behavior and a warning message will be
>reported by might_sleep() in do_exit() code path: "WARNING: do not call
>blocking ops when !TASK_RUNNING; state=1 set at [xxxx]".
>
>2) Because task state is set to TASK_INTERRUPTIBLE at line 285, when break
>while-loop the task state has to be set back to TASK_RUNNING at line 296.
>Indeed it is unncessary, if task state is set to TASK_INTERRUPTIBLE before
>calling schedule() at line 293, we don't need to set the state back to
>TASK_RUNNING at line 296 anymore. The reason is, allocator kthread is only
>woken up by wake_up_process(), this routine makes sure the task state of
>allocator kthread will be TASK_RUNNING after it returns from schedule() at
>line 294 (see kernel/sched/core.c:try_to_wake_up() for more detailed
>information).
>
>This patch fixes the above 2 issues by,
>1) Setting TASK_INTERRUPTIBLE state just before calling schedule().
>2) Then setting TASK_RUNNING at line 296 is unnecessary, remove it.
>
>Signed-off-by: Coly Li <colyli@suse.de>
>---
> drivers/md/bcache/alloc.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>index a0cc1bc6d884..48c002faf08d 100644
>--- a/drivers/md/bcache/alloc.c
>+++ b/drivers/md/bcache/alloc.c
>@@ -282,7 +282,6 @@ static void invalidate_buckets(struct cache *ca)
> #define allocator_wait(ca, cond)                    \
> do {                                    \
>     while (1) {                            \
>-        set_current_state(TASK_INTERRUPTIBLE);            \
>         if (cond)                        \
>             break;                        \
>                                     \
>@@ -290,10 +289,10 @@ do {                                    \
>         if (kthread_should_stop())                \
>             return 0;                    \
>                                     \
>+        set_current_state(TASK_INTERRUPTIBLE);            \
>         schedule();                        \
>         mutex_lock(&(ca)->set->bucket_lock);            \
>     }                                \
>-    __set_current_state(TASK_RUNNING);                \
> } while (0)
> 
> static int bch_allocator_push(struct cache *ca, long bucket)
>-- 
>2.15.1

Thanks,
Tang Junhui
