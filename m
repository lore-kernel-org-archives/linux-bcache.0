From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: ciao set_task_state() (was Re: [PATCH -v4 6/8] locking/mutex:
 Restructure wait loop)
Date: Tue, 25 Oct 2016 09:45:58 -0800
Message-ID: <20161025174558.nuag6uodciz4xpkd@kmo-pixel>
References: <20161007145243.361481786@infradead.org>
 <20161007150211.271490994@infradead.org>
 <20161013151720.GB13138@arm.com>
 <20161019173403.GB3142@twins.programming.kicks-ass.net>
 <20161024015726.GA26130@linux-80c1.suse>
 <20161024142711.3yfr44jq57tkoirl@kmo-pixel>
 <alpine.LRH.2.11.1610250945390.24191@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1610250945390.24191@mail.ewheeler.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Oct 25, 2016 at 09:55:21AM -0700, Eric Wheeler wrote:
> Sure, I'll put it up with my -rc2 pull request to Jens.  
> 
> A couple of sanity checks (for my understanding at least):
> 
> Why does bch_data_insert_start() no longer need to call 
> set_gc_sectors(op->c) now that bch_cache_set_alloc and bch_gc_thread do?  

Before, the gc thread wasn't being explicitly signalled that it was time to run
- it was just being woken up, meaning that a spurious wakeup would cause gc to
run. At best it was sketchy and fragile, for multiple reasons - wait_event() is
a much better mechanism.

So with wait_event() gc is explicitly checking if it's time to run - the wakeup
doesn't really make anything happen by itself, it just pokes the gc thread so
it's able to notice that it should run.

When you're signalling a thread this way - we're in effect setting a global
variable that says "gc should run now", then kicking the gc thread so it can
check the "gc should run" variable. But wakeups aren't synchronous - our call to
wake_up() doesn't make the gc thread check that variable before it returns, all
we know when the wake_up() call returns is that the gc thread is going to check
that variable some point in the future. So we can't set the "gc should run"
varible, wake up the gc thread, and then set it back to "gc shouldn't run yet" -
what'll happen most of the time is that the gc thread won't run before we set
the variable back to "gc shouldn't run yet", it'll never see that it was
supposed to run and it'll go back to sleep.

So the way you make this work is you have the gc thread has to set the variable
back to "gc shouldn't run yet" _after_ it's seen it and decided to run.

> Does bch_cache_set_alloc() even need to call set_gc_sectors since 
> bch_gc_thread() does before calling bch_btree_gc?

Yes, because the gc thread only resets the counter when it's decided to run - we
don't want it to run right away at startup.

> Also I'm curious, why change invalidate_needs_gc from a bitfield? 

Bitfields are particularly unsafe for multiple threads to access - the compiler
has to emit instructions to do read/modify/write, which will clobber adjacent
data. A bare int is also not in _general_ safe for multiple threads to access
without a lock, but for what it's doing here it's fine.
