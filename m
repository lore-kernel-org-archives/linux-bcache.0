From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: ciao set_task_state() (was Re: [PATCH -v4 6/8] locking/mutex:
 Restructure wait loop)
Date: Mon, 24 Oct 2016 05:26:39 -0800
Message-ID: <20161024132639.vrbcfrnorbovmkaj@kmo-pixel>
References: <20161007145243.361481786@infradead.org>
 <20161007150211.271490994@infradead.org>
 <20161013151720.GB13138@arm.com>
 <20161019173403.GB3142@twins.programming.kicks-ass.net>
 <20161024015726.GA26130@linux-80c1.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33578 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934917AbcJXN0n (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Oct 2016 09:26:43 -0400
Content-Disposition: inline
In-Reply-To: <20161024015726.GA26130@linux-80c1.suse>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Waiman Long <waiman.long@hpe.com>, Jason Low <jason.low2@hpe.com>, Ding Tianhong <dingtianhong@huawei.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Imre Deak <imre.deak@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>, Terry Rudd <terry.rudd@hpe.com>, "Paul E. McKenney" <paulmck@us.ibm.com>, Jason Low <jason.low2@hp.com>, Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel.vetter@ffwll.ch>, axboe@fb.com, linux-bcache@vger.kernel.org

On Sun, Oct 23, 2016 at 06:57:26PM -0700, Davidlohr Bueso wrote:
> On Wed, 19 Oct 2016, Peter Zijlstra wrote:
> 
> > Subject: sched: Better explain sleep/wakeup
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Wed Oct 19 15:45:27 CEST 2016
> > 
> > There were a few questions wrt how sleep-wakeup works. Try and explain
> > it more.
> > 
> > Requested-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> > include/linux/sched.h |   52 ++++++++++++++++++++++++++++++++++----------------
> > kernel/sched/core.c   |   15 +++++++-------
> > 2 files changed, 44 insertions(+), 23 deletions(-)
> > 
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -262,20 +262,9 @@ extern char ___assert_task_state[1 - 2*!
> > #define set_task_state(tsk, state_value)			\
> > 	do {							\
> > 		(tsk)->task_state_change = _THIS_IP_;		\
> > -		smp_store_mb((tsk)->state, (state_value));		\
> > +		smp_store_mb((tsk)->state, (state_value));	\
> > 	} while (0)
> > 
> > -/*
> > - * set_current_state() includes a barrier so that the write of current->state
> > - * is correctly serialised wrt the caller's subsequent test of whether to
> > - * actually sleep:
> > - *
> > - *	set_current_state(TASK_UNINTERRUPTIBLE);
> > - *	if (do_i_need_to_sleep())
> > - *		schedule();
> > - *
> > - * If the caller does not need such serialisation then use __set_current_state()
> > - */
> > #define __set_current_state(state_value)			\
> > 	do {							\
> > 		current->task_state_change = _THIS_IP_;		\
> > @@ -284,11 +273,19 @@ extern char ___assert_task_state[1 - 2*!
> > #define set_current_state(state_value)				\
> > 	do {							\
> > 		current->task_state_change = _THIS_IP_;		\
> > -		smp_store_mb(current->state, (state_value));		\
> > +		smp_store_mb(current->state, (state_value));	\
> > 	} while (0)
> > 
> > #else
> > 
> > +/*
> > + * @tsk had better be current, or you get to keep the pieces.
> 
> That reminds me we were getting rid of the set_task_state() calls. Bcache was
> pending, being only user in the kernel that doesn't actually use current; but
> instead breaks newly (yet blocked/uninterruptible) created garbage collection
> kthread. I cannot figure out why this is done (ie purposely accounting the
> load avg. Furthermore gc kicks in in very specific scenarios obviously, such
> as as by the allocator task, so I don't see why bcache gc should want to be
> interruptible.
> 
> Kent, Jens, can we get rid of this?
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 76f7534d1dd1..6e3c358b5759 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1798,7 +1798,6 @@ int bch_gc_thread_start(struct cache_set *c)
>        if (IS_ERR(c->gc_thread))
>                return PTR_ERR(c->gc_thread);
> 
> -       set_task_state(c->gc_thread, TASK_INTERRUPTIBLE);
>        return 0;
> }

Actually, that code looks broken, or at least stupid. Let me do a proper fix...
