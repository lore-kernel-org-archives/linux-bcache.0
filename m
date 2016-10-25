From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: ciao set_task_state() (was Re: [PATCH -v4 6/8] locking/mutex:
 Restructure wait loop)
Date: Tue, 25 Oct 2016 09:55:21 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1610250945390.24191@mail.ewheeler.net>
References: <20161007145243.361481786@infradead.org> <20161007150211.271490994@infradead.org> <20161013151720.GB13138@arm.com> <20161019173403.GB3142@twins.programming.kicks-ass.net> <20161024015726.GA26130@linux-80c1.suse>
 <20161024142711.3yfr44jq57tkoirl@kmo-pixel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:58254 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932211AbcJYQzX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Oct 2016 12:55:23 -0400
In-Reply-To: <20161024142711.3yfr44jq57tkoirl@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org

On Mon, 24 Oct 2016, Kent Overstreet wrote:
> On Sun, Oct 23, 2016 at 06:57:26PM -0700, Davidlohr Bueso wrote:
> > On Wed, 19 Oct 2016, Peter Zijlstra wrote:
> > 
> > > Subject: sched: Better explain sleep/wakeup
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > Date: Wed Oct 19 15:45:27 CEST 2016
> > > 
> > > There were a few questions wrt how sleep-wakeup works. Try and explain
> > > it more.
> > > 
> > > Requested-by: Will Deacon <will.deacon@arm.com>
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > ---
> > > include/linux/sched.h |   52 ++++++++++++++++++++++++++++++++++----------------
> > > kernel/sched/core.c   |   15 +++++++-------
> > > 2 files changed, 44 insertions(+), 23 deletions(-)
> > > 
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -262,20 +262,9 @@ extern char ___assert_task_state[1 - 2*!
> > > #define set_task_state(tsk, state_value)			\
> > > 	do {							\
> > > 		(tsk)->task_state_change = _THIS_IP_;		\
> > > -		smp_store_mb((tsk)->state, (state_value));		\
> > > +		smp_store_mb((tsk)->state, (state_value));	\
> > > 	} while (0)
> > > 
> > > -/*
> > > - * set_current_state() includes a barrier so that the write of current->state
> > > - * is correctly serialised wrt the caller's subsequent test of whether to
> > > - * actually sleep:
> > > - *
> > > - *	set_current_state(TASK_UNINTERRUPTIBLE);
> > > - *	if (do_i_need_to_sleep())
> > > - *		schedule();
> > > - *
> > > - * If the caller does not need such serialisation then use __set_current_state()
> > > - */
> > > #define __set_current_state(state_value)			\
> > > 	do {							\
> > > 		current->task_state_change = _THIS_IP_;		\
> > > @@ -284,11 +273,19 @@ extern char ___assert_task_state[1 - 2*!
> > > #define set_current_state(state_value)				\
> > > 	do {							\
> > > 		current->task_state_change = _THIS_IP_;		\
> > > -		smp_store_mb(current->state, (state_value));		\
> > > +		smp_store_mb(current->state, (state_value));	\
> > > 	} while (0)
> > > 
> > > #else
> > > 
> > > +/*
> > > + * @tsk had better be current, or you get to keep the pieces.
> > 
> > That reminds me we were getting rid of the set_task_state() calls. Bcache was
> > pending, being only user in the kernel that doesn't actually use current; but
> > instead breaks newly (yet blocked/uninterruptible) created garbage collection
> > kthread. I cannot figure out why this is done (ie purposely accounting the
> > load avg. Furthermore gc kicks in in very specific scenarios obviously, such
> > as as by the allocator task, so I don't see why bcache gc should want to be
> > interruptible.
> > 
> > Kent, Jens, can we get rid of this?
> 
> Here's a patch that just fixes the way gc gets woken up. Eric, you want to take
> this?

Sure, I'll put it up with my -rc2 pull request to Jens.  

A couple of sanity checks (for my understanding at least):

Why does bch_data_insert_start() no longer need to call 
set_gc_sectors(op->c) now that bch_cache_set_alloc and bch_gc_thread do?  

Does bch_cache_set_alloc() even need to call set_gc_sectors since 
bch_gc_thread() does before calling bch_btree_gc?

Also I'm curious, why change invalidate_needs_gc from a bitfield? 

-Eric

> 
> -- >8 --
> Subject: [PATCH] bcache: Make gc wakeup saner
> 
> This lets us ditch a set_task_state() call.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  drivers/md/bcache/bcache.h  |  4 ++--
>  drivers/md/bcache/btree.c   | 39 ++++++++++++++++++++-------------------
>  drivers/md/bcache/btree.h   |  3 +--
>  drivers/md/bcache/request.c |  4 +---
>  drivers/md/bcache/super.c   |  2 ++
>  5 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 6b420a55c7..c3ea03c9a1 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -425,7 +425,7 @@ struct cache {
>  	 * until a gc finishes - otherwise we could pointlessly burn a ton of
>  	 * cpu
>  	 */
> -	unsigned		invalidate_needs_gc:1;
> +	unsigned		invalidate_needs_gc;
>  
>  	bool			discard; /* Get rid of? */
>  
> @@ -593,8 +593,8 @@ struct cache_set {
>  
>  	/* Counts how many sectors bio_insert has added to the cache */
>  	atomic_t		sectors_to_gc;
> +	wait_queue_head_t	gc_wait;
>  
> -	wait_queue_head_t	moving_gc_wait;
>  	struct keybuf		moving_gc_keys;
>  	/* Number of moving GC bios in flight */
>  	struct semaphore	moving_in_flight;
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 81d3db40cd..2efdce0724 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1757,32 +1757,34 @@ static void bch_btree_gc(struct cache_set *c)
>  	bch_moving_gc(c);
>  }
>  
> -static int bch_gc_thread(void *arg)
> +static bool gc_should_run(struct cache_set *c)
>  {
> -	struct cache_set *c = arg;
>  	struct cache *ca;
>  	unsigned i;
>  
> -	while (1) {
> -again:
> -		bch_btree_gc(c);
> +	for_each_cache(ca, c, i)
> +		if (ca->invalidate_needs_gc)
> +			return true;
>  
> -		set_current_state(TASK_INTERRUPTIBLE);
> -		if (kthread_should_stop())
> -			break;
> +	if (atomic_read(&c->sectors_to_gc) < 0)
> +		return true;
>  
> -		mutex_lock(&c->bucket_lock);
> +	return false;
> +}
>  
> -		for_each_cache(ca, c, i)
> -			if (ca->invalidate_needs_gc) {
> -				mutex_unlock(&c->bucket_lock);
> -				set_current_state(TASK_RUNNING);
> -				goto again;
> -			}
> +static int bch_gc_thread(void *arg)
> +{
> +	struct cache_set *c = arg;
>  
> -		mutex_unlock(&c->bucket_lock);
> +	while (1) {
> +		wait_event_interruptible(c->gc_wait,
> +			   kthread_should_stop() || gc_should_run(c));
>  
> -		schedule();
> +		if (kthread_should_stop())
> +			break;
> +
> +		set_gc_sectors(c);
> +		bch_btree_gc(c);
>  	}
>  
>  	return 0;
> @@ -1790,11 +1792,10 @@ static int bch_gc_thread(void *arg)
>  
>  int bch_gc_thread_start(struct cache_set *c)
>  {
> -	c->gc_thread = kthread_create(bch_gc_thread, c, "bcache_gc");
> +	c->gc_thread = kthread_run(bch_gc_thread, c, "bcache_gc");
>  	if (IS_ERR(c->gc_thread))
>  		return PTR_ERR(c->gc_thread);
>  
> -	set_task_state(c->gc_thread, TASK_INTERRUPTIBLE);
>  	return 0;
>  }
>  
> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
> index 5c391fa01b..9b80417cd5 100644
> --- a/drivers/md/bcache/btree.h
> +++ b/drivers/md/bcache/btree.h
> @@ -260,8 +260,7 @@ void bch_initial_mark_key(struct cache_set *, int, struct bkey *);
>  
>  static inline void wake_up_gc(struct cache_set *c)
>  {
> -	if (c->gc_thread)
> -		wake_up_process(c->gc_thread);
> +	wake_up(&c->gc_wait);
>  }
>  
>  #define MAP_DONE	0
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 40ffe5e424..a37c1776f2 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -196,10 +196,8 @@ static void bch_data_insert_start(struct closure *cl)
>  	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
>  	struct bio *bio = op->bio, *n;
>  
> -	if (atomic_sub_return(bio_sectors(bio), &op->c->sectors_to_gc) < 0) {
> -		set_gc_sectors(op->c);
> +	if (atomic_sub_return(bio_sectors(bio), &op->c->sectors_to_gc) < 0)
>  		wake_up_gc(op->c);
> -	}
>  
>  	if (op->bypass)
>  		return bch_data_invalidate(cl);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 849ad441cd..66669c8f41 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1491,6 +1491,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  	mutex_init(&c->bucket_lock);
>  	init_waitqueue_head(&c->btree_cache_wait);
>  	init_waitqueue_head(&c->bucket_wait);
> +	init_waitqueue_head(&c->gc_wait);
>  	sema_init(&c->uuid_write_mutex, 1);
>  
>  	spin_lock_init(&c->btree_gc_time.lock);
> @@ -1550,6 +1551,7 @@ static void run_cache_set(struct cache_set *c)
>  
>  	for_each_cache(ca, c, i)
>  		c->nbuckets += ca->sb.nbuckets;
> +	set_gc_sectors(c);
>  
>  	if (CACHE_SYNC(&c->sb)) {
>  		LIST_HEAD(journal);
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
