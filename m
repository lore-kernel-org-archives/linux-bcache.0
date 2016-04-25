From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Mon, 25 Apr 2016 10:19:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1604251014080.27368@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm> <alpine.LRH.2.11.1604192050290.16630@mail.ewheeler.net> <alpine.LNX.2.00.1604200021570.27368@cbobk.fhfr.pm> <alpine.LRH.2.11.1604220041230.6087@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1604220041230.6087@mail.ewheeler.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Maciej Piechotka <uzytkownik2@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On Fri, 22 Apr 2016, Eric Wheeler wrote:

> > I'll try to capture the output today.
> 
> No technical data yet, but this is the thread:  
> 
> http://comments.gmane.org/gmane.linux.kernel.bcache.devel/3820

Thanks. It's highly unlikely that this will be fixed by these three 
patches though (the code should be functionally equivalent before and 
after).

> > > What is the proper way to safely support suspend?  Assuming the 
> > > try_to_freeze() calls are in the right place, should we simply 
> > > set_freezable() on these kthreads?
> > 
> > Unfortunately, this is really a tricky question; the issue is that frezing 
> > semantics is rather undefined for kthreads. For starters, please see
> > 
> > 	https://lwn.net/Articles/662703/
> > 	http://lkml.org/lkml/2007/4/27/608
> 
> Interesting indeed.  So suspend should succeed independent of kernel 
> threads since we want to get rid of freezable kthreads? 

Basically kthreads periodically run and are scheduled out, that by itself 
doesn't interfere with suspend. Once they are all scheduled out, suspend 
happens.

> Does this also mean that IO kthreads will always break suspend?

I am afraid that "IO kthreads" isn't really exact enough expression. 
Kthreads which are essential for making sure that I/O completes, they 
actually have to obviously keep running before the whole image is written 
out.

The other threads basically keep on with their own business before they 
all end up in schedule().

> Speculation: The writeback thread can (probably) be made unrunnable at any 
> time without issue since it is (should be) fully asynchronous.  However, 
> garbage collection might deadlock if the GC thread is unrunnable while 
> hibernate (suspend?) IO is writing through bcache while bcache waits for 
> GC to complete under allocation contention.  I'm not familiar with the 
> bcache allocator details, so anyone else please chime here.
> 
> Presumably, GC is only unsafe during writes to the cache for blocks that 
> are not yet cached but would cause a cache allocation.  If so, then 
> perhaps we can hook the pending suspend, set cache_mode to "writearound"  
> to prevent btree changes, and restore the cache_mode on resume. It will be 
> interesting to see the backtrace if Maciej can get one out of the system.

That would be really helpful. Or crashdump image.

Thanks,

-- 
Jiri Kosina
SUSE Labs
