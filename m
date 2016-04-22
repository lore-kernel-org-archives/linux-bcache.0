From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Fri, 22 Apr 2016 01:19:19 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604220041230.6087@mail.ewheeler.net>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm> <alpine.LRH.2.11.1604192050290.16630@mail.ewheeler.net> <alpine.LNX.2.00.1604200021570.27368@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:47494 "EHLO mail.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752681AbcDVBTu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 21 Apr 2016 21:19:50 -0400
In-Reply-To: <alpine.LNX.2.00.1604200021570.27368@cbobk.fhfr.pm>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Maciej Piechotka <uzytkownik2@gmail.com>

On Wed, 20 Apr 2016, Jiri Kosina wrote:
> On Tue, 19 Apr 2016, Eric Wheeler wrote:
> 
> > > bch_writeback_thread() is calling try_to_freeze(), but that's just an 
> > > expensive no-op given the fact that the thread is not marked freezable.
> > > 
> > > I/O helper kthreads, exactly such as the bcache writeback thread, actually 
> > > shouldn't be freezable, because they are potentially necessary for 
> > > finalizing the image write-out.
> > 
> > This is good timing, as Maciej Piechotka just reported a hang when 
> > suspending his system.
> 
> Could you please point me to the actual report? Thanks.
>
> On Tue, 19 Apr 2016, Maciej Piechotka wrote:
> Eric Wheeler <bcache <at> lists.ewheeler.net> writes:
> > Interesting.  Can you collect the dmesg output as it suspends/resumes via
> > serial or something other means?
>
> I'll try to capture the output today.

No technical data yet, but this is the thread:  

http://comments.gmane.org/gmane.linux.kernel.bcache.devel/3820

> > What is the proper way to safely support suspend?  Assuming the 
> > try_to_freeze() calls are in the right place, should we simply 
> > set_freezable() on these kthreads?
> 
> Unfortunately, this is really a tricky question; the issue is that frezing 
> semantics is rather undefined for kthreads. For starters, please see
> 
> 	https://lwn.net/Articles/662703/
> 	http://lkml.org/lkml/2007/4/27/608

Interesting indeed.  So suspend should succeed independent of kernel 
threads since we want to get rid of freezable kthreads? 

Does this also mean that IO kthreads will always break suspend?

> I don't belive in freezable kthreads which serve as I/O helpers. Such 
> threads simply have to keep going until the image is written out and 
> machine powered down.
> 
> So I'd like to start with understanding how bcache is preventning suspend. 
> Maciej?

We await backtraces from Maciej, but I can say that bcache uses only two 
kthreads, one for garbage collection and another for writeback.  

Speculation: The writeback thread can (probably) be made unrunnable at any 
time without issue since it is (should be) fully asynchronous.  However, 
garbage collection might deadlock if the GC thread is unrunnable while 
hibernate (suspend?) IO is writing through bcache while bcache waits for 
GC to complete under allocation contention.  I'm not familiar with the 
bcache allocator details, so anyone else please chime here.

Presumably, GC is only unsafe during writes to the cache for blocks that 
are not yet cached but would cause a cache allocation.  If so, then 
perhaps we can hook the pending suspend, set cache_mode to "writearound"  
to prevent btree changes, and restore the cache_mode on resume. It will be 
interesting to see the backtrace if Maciej can get one out of the system.


--
Eric Wheeler
