From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] bcache: set task state correctly in allocator_wait()
Date: Wed, 22 Nov 2017 15:55:22 +0100
Message-ID: <20171122145522.GB2788@linutronix.de>
References: <20171122123349.74347-1-colyli@suse.de>
 <0c8e78ab-e369-a40c-ee02-6a6c8f3a5cdd@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0c8e78ab-e369-a40c-ee02-6a6c8f3a5cdd@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017-11-22 15:10:51 [+0100], Hannes Reinecke wrote:
> On 11/22/2017 01:33 PM, Coly Li wrote:
> > Kthread function bch_allocator_thread() references allocator_wait(ca, cond)
> > and when kthread_should_stop() is true, this kthread exits.
> > 
> > The problem is, if kthread_should_stop() is true, macro allocator_wait()
> > calls "return 0" with current task state TASK_INTERRUPTIBLE. After function
> > bch_allocator_thread() returns to do_exit(), there are some blocking
> > operations are called, then a kenrel warning is popped up by __might_sleep
> > from kernel/sched/core.c,
> >   "WARNING: do not call blocking ops when !TASK_RUNNING; state=1 set at [xxxx]"
> > 
> > If the task is interrupted and preempted out, since its status is
> > TASK_INTERRUPTIBLE, it means scheduler won't pick it back to run forever,
> > and the allocator thread may hang in do_exit().
> > 
> > This patch sets allocator kthread state back to TASK_RUNNING before it
> > returns to do_exit(), which avoids a potential deadlock.
> > 
> > Signed-off-by: Coly Li <colyli@suse.de>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/md/bcache/alloc.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> > index a27d85232ce1..996ebbabd819 100644
> > --- a/drivers/md/bcache/alloc.c
> > +++ b/drivers/md/bcache/alloc.c
> > @@ -286,9 +286,12 @@ do {									\
> >  		if (cond)						\
> >  			break;						\
> >  									\
> > +									\
> >  		mutex_unlock(&(ca)->set->bucket_lock);			\
> > -		if (kthread_should_stop())				\
> > +		if (kthread_should_stop()) {				\
> > +			__set_current_state(TASK_RUNNING);		\
> >  			return 0;					\
> > +		}							\
> >  									\
> >  		schedule();						\
> >  		mutex_lock(&(ca)->set->bucket_lock);			\
> > 
> _Actually_ there is a push to remove all kthreads in the kernel, as they
> don't play nice together with RT.

with RT? If RT as in PREEMPT-RT then this is news to me. The reason why
I removed the per-CPU kthreads in the scsi driver(s) was because it was
nonsense in regards to CPU-hotplug and workqueue infrastructure is way
nicer for that. Not to mention that it made the code simpler.

> So while you're at it, do you think it'd be possible to convert it to a
> workqueue? Sebastian will be happy to help you here, right, Sebastian?
If commit 4b9bc86d5a99 ("fcoe: convert to kworker") does not explain I
can try to assist.

> Cheers,
> 
> Hannes

Sebastian
