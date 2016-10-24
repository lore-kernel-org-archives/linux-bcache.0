From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ciao set_task_state() (was Re: [PATCH -v4 6/8] locking/mutex:
 Restructure wait loop)
Date: Sun, 23 Oct 2016 18:57:26 -0700
Message-ID: <20161024015726.GA26130@linux-80c1.suse>
References: <20161007145243.361481786@infradead.org>
 <20161007150211.271490994@infradead.org>
 <20161013151720.GB13138@arm.com>
 <20161019173403.GB3142@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54106 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754066AbcJXB5m (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 23 Oct 2016 21:57:42 -0400
Content-Disposition: inline
In-Reply-To: <20161019173403.GB3142@twins.programming.kicks-ass.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Waiman Long <waiman.long@hpe.com>, Jason Low <jason.low2@hpe.com>, Ding Tianhong <dingtianhong@huawei.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Imre Deak <imre.deak@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>, Terry Rudd <terry.rudd@hpe.com>, "Paul E. McKenney" <paulmck@us.ibm.com>, Jason Low <jason.low2@hp.com>, Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel.vetter@ffwll.ch>, kent.overstreet@gmail.com, axboe@fb.com, linux-bcache@vger.kernel.org

On Wed, 19 Oct 2016, Peter Zijlstra wrote:

>Subject: sched: Better explain sleep/wakeup
>From: Peter Zijlstra <peterz@infradead.org>
>Date: Wed Oct 19 15:45:27 CEST 2016
>
>There were a few questions wrt how sleep-wakeup works. Try and explain
>it more.
>
>Requested-by: Will Deacon <will.deacon@arm.com>
>Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>---
> include/linux/sched.h |   52 ++++++++++++++++++++++++++++++++++----------------
> kernel/sched/core.c   |   15 +++++++-------
> 2 files changed, 44 insertions(+), 23 deletions(-)
>
>--- a/include/linux/sched.h
>+++ b/include/linux/sched.h
>@@ -262,20 +262,9 @@ extern char ___assert_task_state[1 - 2*!
> #define set_task_state(tsk, state_value)			\
> 	do {							\
> 		(tsk)->task_state_change = _THIS_IP_;		\
>-		smp_store_mb((tsk)->state, (state_value));		\
>+		smp_store_mb((tsk)->state, (state_value));	\
> 	} while (0)
>
>-/*
>- * set_current_state() includes a barrier so that the write of current->state
>- * is correctly serialised wrt the caller's subsequent test of whether to
>- * actually sleep:
>- *
>- *	set_current_state(TASK_UNINTERRUPTIBLE);
>- *	if (do_i_need_to_sleep())
>- *		schedule();
>- *
>- * If the caller does not need such serialisation then use __set_current_state()
>- */
> #define __set_current_state(state_value)			\
> 	do {							\
> 		current->task_state_change = _THIS_IP_;		\
>@@ -284,11 +273,19 @@ extern char ___assert_task_state[1 - 2*!
> #define set_current_state(state_value)				\
> 	do {							\
> 		current->task_state_change = _THIS_IP_;		\
>-		smp_store_mb(current->state, (state_value));		\
>+		smp_store_mb(current->state, (state_value));	\
> 	} while (0)
>
> #else
>
>+/*
>+ * @tsk had better be current, or you get to keep the pieces.

That reminds me we were getting rid of the set_task_state() calls. Bcache was
pending, being only user in the kernel that doesn't actually use current; but
instead breaks newly (yet blocked/uninterruptible) created garbage collection
kthread. I cannot figure out why this is done (ie purposely accounting the
load avg. Furthermore gc kicks in in very specific scenarios obviously, such
as as by the allocator task, so I don't see why bcache gc should want to be
interruptible.

Kent, Jens, can we get rid of this?

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 76f7534d1dd1..6e3c358b5759 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1798,7 +1798,6 @@ int bch_gc_thread_start(struct cache_set *c)
        if (IS_ERR(c->gc_thread))
                return PTR_ERR(c->gc_thread);
 
-       set_task_state(c->gc_thread, TASK_INTERRUPTIBLE);
        return 0;
 }

Thanks,
Davidlohr

>+ *
>+ * The only reason is that computing current can be more expensive than
>+ * using a pointer that's already available.
>+ *
>+ * Therefore, see set_current_state().
>+ */
> #define __set_task_state(tsk, state_value)		\
> 	do { (tsk)->state = (state_value); } while (0)
> #define set_task_state(tsk, state_value)		\
>@@ -299,11 +296,34 @@ extern char ___assert_task_state[1 - 2*!
>  * is correctly serialised wrt the caller's subsequent test of whether to
>  * actually sleep:
>  *
>+ *   for (;;) {
>  *	set_current_state(TASK_UNINTERRUPTIBLE);
>- *	if (do_i_need_to_sleep())
>- *		schedule();
>+ *	if (!need_sleep)
>+ *		break;
>+ *
>+ *	schedule();
>+ *   }
>+ *   __set_current_state(TASK_RUNNING);
>+ *
>+ * If the caller does not need such serialisation (because, for instance, the
>+ * condition test and condition change and wakeup are under the same lock) then
>+ * use __set_current_state().
>+ *
>+ * The above is typically ordered against the wakeup, which does:
>+ *
>+ *	need_sleep = false;
>+ *	wake_up_state(p, TASK_UNINTERRUPTIBLE);
>+ *
>+ * Where wake_up_state() (and all other wakeup primitives) imply enough
>+ * barriers to order the store of the variable against wakeup.
>+ *
>+ * Wakeup will do: if (@state & p->state) p->state = TASK_RUNNING, that is,
>+ * once it observes the TASK_UNINTERRUPTIBLE store the waking CPU can issue a
>+ * TASK_RUNNING store which can collide with __set_current_state(TASK_RUNNING).
>+ *
>+ * This is obviously fine, since they both store the exact same value.
>  *
>- * If the caller does not need such serialisation then use __set_current_state()
>+ * Also see the comments of try_to_wake_up().
>  */
> #define __set_current_state(state_value)		\
> 	do { current->state = (state_value); } while (0)
>--- a/kernel/sched/core.c
>+++ b/kernel/sched/core.c
>@@ -2000,14 +2000,15 @@ static void ttwu_queue(struct task_struc
>  * @state: the mask of task states that can be woken
>  * @wake_flags: wake modifier flags (WF_*)
>  *
>- * Put it on the run-queue if it's not already there. The "current"
>- * thread is always on the run-queue (except when the actual
>- * re-schedule is in progress), and as such you're allowed to do
>- * the simpler "current->state = TASK_RUNNING" to mark yourself
>- * runnable without the overhead of this.
>+ * If (@state & @p->state) @p->state = TASK_RUNNING.
>  *
>- * Return: %true if @p was woken up, %false if it was already running.
>- * or @state didn't match @p's state.
>+ * If the task was not queued/runnable, also place it back on a runqueue.
>+ *
>+ * Atomic against schedule() which would dequeue a task, also see
>+ * set_current_state().
>+ *
>+ * Return: %true if @p->state changes (an actual wakeup was done),
>+ *	   %false otherwise.
>  */
> static int
> try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
