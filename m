From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 4/3] rtmutex: Avoid barrier in rt_mutex_handle_deadlock
Date: Thu, 24 Mar 2016 19:30:10 -0700
Message-ID: <20160325023010.GA16256@linux-uzut.site>
References: <1457461223-4301-1-git-send-email-dave@stgolabs.net>
 <20160308220539.GB4404@linux-uzut.site>
 <20160314134038.GZ6356@twins.programming.kicks-ass.net>
 <20160321181622.GB32012@linux-uzut.site>
 <20160322102153.GL6344@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbcCYCaf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 24 Mar 2016 22:30:35 -0400
Content-Disposition: inline
In-Reply-To: <20160322102153.GL6344@twins.programming.kicks-ass.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: tglx@linutronix.de, mingo@kernel.org, bigeasy@linutronix.de, umgwanakikbuti@gmail.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, kmo@daterainc.com, heiko.carstens@de.ibm.com, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

Adding a few more Cc's for bcache.

On Tue, 22 Mar 2016, Peter Zijlstra wrote:

>On Mon, Mar 21, 2016 at 11:16:22AM -0700, Davidlohr Bueso wrote:
>
>> +/*
>> + * Helpers for modifying the state of either the current task, or a foreign
>> + * task. Each of these calls come in both full barrier and weak flavors:
>> + *
>> + *                                           Weak
>> + *     set_task_state()           __set_task_state()
>> + *     set_current_state()        __set_current_state()
>> + *
>> + * Where set_current_state() and set_task_state() includes a full smp barrier
>> + * -after- the write of ->state is correctly serialized with the later test
>> + * of whether to actually sleep:
>> + *
>> + *	for (;;) {
>> + *		set_current_state(TASK_UNINTERRUPTIBLE);
>> + *		if (event_indicated)
>> + *			break;
>> + *		schedule();
>> + *	}
>> + *
>> + * This is commonly necessary for processes sleeping and waking through flag
>> + * based events. If the caller does not need such serialization, then use
>> + * weaker counterparts, which simply writes the state.
>> + *
>> + * Refer to Documentation/memory-barriers.txt
>> + */
>
>I would prefer to pretend set_task_state() does not exist, using it on
>anything other than task==current is very very tricky.
>
>With the below patch; we're only left with:
>
>arch/s390/mm/fault.c:			__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>arch/s390/mm/fault.c:			__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>drivers/md/bcache/btree.c:	set_task_state(c->gc_thread, TASK_INTERRUPTIBLE);
>kernel/exit.c:			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>kernel/exit.c:		__set_task_state(tsk, TASK_RUNNING);
>
>exit most probably also has tsk==current, but I didn't check.

Right, and only user is do_exit -> exit_mm() which is always current.

>
>bacache seems to rely on the fact that the task is not running after
>kthread_create() to change the state. But I've no idea why; the only
>think I can come up with is because load accounting, a new thread blocks
>in UNINTERRUPTIBLE which adds to load. But by setting it to
>INTERRUPTIBLE before waking up it can actually mess that up. This really
>should be fixed.

No idea why either.

>
>And s390 does something entirely vile, no idea what.

So this is solved.

I'll send an updated patch based on this one that removes set_task_state 
iff we get rid of the bcache situation obviously.

Thanks,
Davidlohr

>
>---
> arch/um/drivers/random.c                                 |  2 +-
> drivers/md/dm-bufio.c                                    |  2 +-
> drivers/md/persistent-data/dm-block-manager.c            |  4 ++--
> drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c |  6 ++++--
> drivers/tty/tty_ldsem.c                                  | 10 +++++-----
> kernel/locking/mutex.c                                   |  4 ++--
> kernel/locking/rwsem-spinlock.c                          | 12 +++++-------
> kernel/locking/rwsem-xadd.c                              |  4 ++--
> kernel/locking/semaphore.c                               |  2 +-
> 9 files changed, 23 insertions(+), 23 deletions(-)
>
>diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
>index dd16c902ff70..19d41a583288 100644
>--- a/arch/um/drivers/random.c
>+++ b/arch/um/drivers/random.c
>@@ -76,7 +76,7 @@ static ssize_t rng_dev_read (struct file *filp, char __user *buf, size_t size,
> 			add_sigio_fd(random_fd);
>
> 			add_wait_queue(&host_read_wait, &wait);
>-			set_task_state(current, TASK_INTERRUPTIBLE);
>+			set_current_state(TASK_INTERRUPTIBLE);
>
> 			schedule();
> 			remove_wait_queue(&host_read_wait, &wait);
>diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
>index cd77216beff1..c5e89f358d98 100644
>--- a/drivers/md/dm-bufio.c
>+++ b/drivers/md/dm-bufio.c
>@@ -807,7 +807,7 @@ static void __wait_for_free_buffer(struct dm_bufio_client *c)
> 	DECLARE_WAITQUEUE(wait, current);
>
> 	add_wait_queue(&c->free_buffer_wait, &wait);
>-	set_task_state(current, TASK_UNINTERRUPTIBLE);
>+	set_current_state(TASK_UNINTERRUPTIBLE);
> 	dm_bufio_unlock(c);
>
> 	io_schedule();
>diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
>index 1e33dd51c21f..821a26b934c2 100644
>--- a/drivers/md/persistent-data/dm-block-manager.c
>+++ b/drivers/md/persistent-data/dm-block-manager.c
>@@ -118,7 +118,7 @@ static int __check_holder(struct block_lock *lock)
> static void __wait(struct waiter *w)
> {
> 	for (;;) {
>-		set_task_state(current, TASK_UNINTERRUPTIBLE);
>+		set_current_state(TASK_UNINTERRUPTIBLE);
>
> 		if (!w->task)
> 			break;
>@@ -126,7 +126,7 @@ static void __wait(struct waiter *w)
> 		schedule();
> 	}
>
>-	set_task_state(current, TASK_RUNNING);
>+	set_current_state(TASK_RUNNING);
> }
>
> static void __wake_waiter(struct waiter *w)
>diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>index 59c7bf3cbc1f..087d7e49cf3e 100644
>--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
>@@ -162,9 +162,11 @@ void __noreturn lbug_with_loc(struct libcfs_debug_msg_data *msgdata)
> 	libcfs_run_lbug_upcall(msgdata);
> 	if (libcfs_panic_on_lbug)
> 		panic("LBUG");
>-	set_task_state(current, TASK_UNINTERRUPTIBLE);
>-	while (1)
>+
>+	while (1) {
>+		set_current_state(TASK_UNINTERRUPTIBLE);
> 		schedule();
>+	}
> }
>
> static int panic_notifier(struct notifier_block *self, unsigned long unused1,
>diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
>index 1bf8ed13f827..c94bc0eef85d 100644
>--- a/drivers/tty/tty_ldsem.c
>+++ b/drivers/tty/tty_ldsem.c
>@@ -232,7 +232,7 @@ down_read_failed(struct ld_semaphore *sem, long count, long timeout)
>
> 	/* wait to be given the lock */
> 	for (;;) {
>-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>+		set_current_state(TASK_UNINTERRUPTIBLE);
>
> 		if (!waiter.task)
> 			break;
>@@ -241,7 +241,7 @@ down_read_failed(struct ld_semaphore *sem, long count, long timeout)
> 		timeout = schedule_timeout(timeout);
> 	}
>
>-	__set_task_state(tsk, TASK_RUNNING);
>+	__set_current_state(TASK_RUNNING);
>
> 	if (!timeout) {
> 		/* lock timed out but check if this task was just
>@@ -291,14 +291,14 @@ down_write_failed(struct ld_semaphore *sem, long count, long timeout)
>
> 	waiter.task = tsk;
>
>-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>+	set_current_state(TASK_UNINTERRUPTIBLE);
> 	for (;;) {
> 		if (!timeout)
> 			break;
> 		raw_spin_unlock_irq(&sem->wait_lock);
> 		timeout = schedule_timeout(timeout);
> 		raw_spin_lock_irq(&sem->wait_lock);
>-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>+		set_current_state(TASK_UNINTERRUPTIBLE);
> 		locked = writer_trylock(sem);
> 		if (locked)
> 			break;
>@@ -309,7 +309,7 @@ down_write_failed(struct ld_semaphore *sem, long count, long timeout)
> 	list_del(&waiter.list);
> 	raw_spin_unlock_irq(&sem->wait_lock);
>
>-	__set_task_state(tsk, TASK_RUNNING);
>+	__set_current_state(TASK_RUNNING);
>
> 	/* lock wait may have timed out */
> 	if (!locked)
>diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
>index e364b424b019..c10fe056c34a 100644
>--- a/kernel/locking/mutex.c
>+++ b/kernel/locking/mutex.c
>@@ -572,14 +572,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> 				goto err;
> 		}
>
>-		__set_task_state(task, state);
>+		__set_current_state(state);
>
> 		/* didn't get the lock, go to sleep: */
> 		spin_unlock_mutex(&lock->wait_lock, flags);
> 		schedule_preempt_disabled();
> 		spin_lock_mutex(&lock->wait_lock, flags);
> 	}
>-	__set_task_state(task, TASK_RUNNING);
>+	__set_current_state(TASK_RUNNING);
>
> 	mutex_remove_waiter(lock, &waiter, current_thread_info());
> 	/* set it to 0 if there are no waiters left: */
>diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
>index 3a5048572065..dfe5ea3736a8 100644
>--- a/kernel/locking/rwsem-spinlock.c
>+++ b/kernel/locking/rwsem-spinlock.c
>@@ -141,7 +141,7 @@ void __sched __down_read(struct rw_semaphore *sem)
> 	}
>
> 	tsk = current;
>-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>+	set_current_state(TASK_UNINTERRUPTIBLE);
>
> 	/* set up my own style of waitqueue */
> 	waiter.task = tsk;
>@@ -158,10 +158,10 @@ void __sched __down_read(struct rw_semaphore *sem)
> 		if (!waiter.task)
> 			break;
> 		schedule();
>-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>+		set_current_state(TASK_UNINTERRUPTIBLE);
> 	}
>
>-	__set_task_state(tsk, TASK_RUNNING);
>+	__set_current_state(TASK_RUNNING);
>  out:
> 	;
> }
>@@ -194,14 +194,12 @@ int __down_read_trylock(struct rw_semaphore *sem)
> void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
> {
> 	struct rwsem_waiter waiter;
>-	struct task_struct *tsk;
> 	unsigned long flags;
>
> 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
>
> 	/* set up my own style of waitqueue */
>-	tsk = current;
>-	waiter.task = tsk;
>+	waiter.task = current;
> 	waiter.type = RWSEM_WAITING_FOR_WRITE;
> 	list_add_tail(&waiter.list, &sem->wait_list);
>
>@@ -215,7 +213,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
> 		 */
> 		if (sem->count == 0)
> 			break;
>-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>+		set_current_state(TASK_UNINTERRUPTIBLE);
> 		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
> 		schedule();
> 		raw_spin_lock_irqsave(&sem->wait_lock, flags);
>diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
>index a4d4de05b2d1..a33ffc2ee236 100644
>--- a/kernel/locking/rwsem-xadd.c
>+++ b/kernel/locking/rwsem-xadd.c
>@@ -244,13 +244,13 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
>
> 	/* wait to be given the lock */
> 	while (true) {
>-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>+		set_current_state(TASK_UNINTERRUPTIBLE);
> 		if (!waiter.task)
> 			break;
> 		schedule();
> 	}
>
>-	__set_task_state(tsk, TASK_RUNNING);
>+	__set_current_state(TASK_RUNNING);
> 	return sem;
> }
> EXPORT_SYMBOL(rwsem_down_read_failed);
>diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
>index b8120abe594b..2f8cdb712b63 100644
>--- a/kernel/locking/semaphore.c
>+++ b/kernel/locking/semaphore.c
>@@ -216,7 +216,7 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
> 			goto interrupted;
> 		if (unlikely(timeout <= 0))
> 			goto timed_out;
>-		__set_task_state(task, state);
>+		__set_current_state(state);
> 		raw_spin_unlock_irq(&sem->lock);
> 		timeout = schedule_timeout(timeout);
> 		raw_spin_lock_irq(&sem->lock);
