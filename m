From: Eric Wheeler <linux-bcache@vger.kernel.org>
Subject: Re[2]: [PATCH 1/2] bcache: introduce ioprio-based bypass/writeback
 hints
Date: Thu, 29 Sep 2016 11:31:44 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609291125260.5355@mail.ewheeler.net>
References: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>        <1610652744.20160927084309@pvgoran.name> <20160927044348.25fedb75@jupiter.sol.kaishome.de> <alpine.LRH.2.11.1609271614340.29933@mail.ewheeler.net>
 <1515763256.20160929135700@pvgoran.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:48986 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932987AbcI2Sbt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 14:31:49 -0400
In-Reply-To: <1515763256.20160929135700@pvgoran.name>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pavel Goran <via-bcache@pvgoran.name>
Cc: linux-bcache@vger.kernel.org

> Hello Eric,
> 
> Thursday, September 29, 2016, 1:21:53 AM, you wrote:
> 
> > It respects policy first of course.  You can see the top of
> > should_writeback() in the patch as context:
> >         if (cache_mode != CACHE_MODE_WRITEBACK || [...]
> 
> So the priority-dependent logic is only applied when cache mode is
> "writeback", right? 

Correct. It might be better to say that the new priority-dependent logic 
_for writes_ is only applied when cache mode is "writeback" via the new 
syfs entry ioprio_writeback.

For reads, ioprio_bypass is hinted in both writeback and writethrough 
modes.

> Then, what does "Original bcache logic" from the table in the original 
> patch description mean? That is, how does it differ from "Writeback" 
> from the same table?

There are two hints in `struct data_insert_op`:
	iop.bypass, iop.writeback

bcache has an existing function `should_writeback()` which is a hint on 
the cached_dev_write() path.  I've added the writeback portion of the 
ioprio logic there, so if it doesn't match the ioprio set in 
ioprio_writeback, it continues as if my code hadn't been added.

> Does "Writeback" there mean that bcache would write data to the cache
> *always*, even in case of linear write, or in other situations where the
> original writeback logic would bypass cache? If so, the table should perhaps
> be adjusted to say "Always writeback" instead of "Writeback", and "Original
> writeback logic" instead of "Original bcache logic".

Similarly, the function `should_bypass()` sets the iop.bypass hint.  This 
is where the logic as to whether or not the write looks "sequential" is 
held.

The IO is then passed to cached_dev_write() which checks 
should_writeback().  If should_writeback() returns true, it overrides the 
bypass flag.  Thus, iop.bypass is weaker than iop.writeback.  Bcache makes 
other decisions which may override bypass, too, like overlapping of dirty 
data and perhaps other reasons.  

Keep in mind that SSDs are still better at seq-writes than random writes 
because of erase block rewrites handled by the SSD's FTL.  For realtime 
applications 100% writeback might still be preferred, even if the IOs are 
sequential.  This will wear your SSD faster, of course, so set your 
io priorities appropriately.

Pseudo-code call-stack:
	cached_dev_make_request():
	   s->iop.bypass = check_should_bypass()
	   cached_dev_write():
	         if (should_writeback()) {
                    s->iop.bypass = false;
                    s->iop.writeback = true;
                 }
		 submit-based-on-hint( s )

> > If not already in cache, it will read from the backing device and will not
> > promote into (pollute) your cache. Having idle IOs bypass the cache can 
> > increase performance everywhere else since you probably don't care about 
> > the performance of idle IOs.
> 
> Ok, this sounds convincing.
> 
> Ideally this would be handled by some kind of priority semantics within the
> cache, so that "high-priority" data would always replace "low-priority" data,
> and "low-priority" data would only replace "high-priority" data if it's really
> old. It's entirely feasible to implement within bcache, but probably it
> wouldn't be easy, and might even mean changing cache data format.
> 
> Your SSD wearout problem would (again, ideally) be handled by some kind of
> custom process attribute (no idea if the kernel even has this kind of concept,
> probably not) that would signal bcache to bypass caching for IO that
> originates from this process. The additional "bulk" priority class proposed by
> Kai would also be a good solution.

Some SSDs have a SMART attribute for LBAs written---which is a good idea 
to monitor if your SSD supports it---but its not consistent enough to 
build a framework around.  It varies from mfg to mfg.
 
> However, given that these two approaches are supposedly unavailable, using
> existing IO priorities looks like an acceptable solution.

Agreed.  

> > If you really want idle IO that can writeback, then I can set the default
> > for ioprio_writeback and/or ioprio_bypass to be disabled until a user 
> > explicitly sets them.
> 
> Are you talking about bcache options available via sysfs? It would be good to
> have control over the priority-dependent logic in this way (or it's already
> implemented?). 

This patch. It just adds sysfs files to configure ioprio_bypass and 
ioprio_writeback with flags that hook into the existing 
should_bypass()/should_writeback() functions.  

I'm planning a v2 patch to update documentation and allow 0,0 to disable 
either or both features.

> Not sure what the defaults should be, though. :) 

Does anyone else have a suggestion on best defaults? As currently written, 
it is like so:
	writeback for higher priority than `ionice -c2 -n0`
	bypass    for lower  priority than `ionice -c2 -n7`

Users who do not use `ionice` are unaffected by this default since 
unprioritized pids are either "ioprio_invalid()" or have an ioprio of '-c2 -n4'.

> It would be even better to have the possibility to save these flags to 
> the superblock, if it's something that can be easily implemented.

Thats definitely a neat idea.  It would be great to put other flags like 
sequential_cutoff, writeback_*, and perhaps a few other sysfs 
configurations into the superblock so I needn't set them at boot time.  
A superblock patch for another time :)

--
Eric Wheeler
