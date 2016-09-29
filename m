From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 1/2] bcache: introduce ioprio-based bypass/writeback
 hints
Date: Thu, 29 Sep 2016 15:50:47 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609291543490.15199@mail.ewheeler.net>
References: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>        <1610652744.20160927084309@pvgoran.name>        <20160927044348.25fedb75@jupiter.sol.kaishome.de>        <alpine.LRH.2.11.1609271614340.29933@mail.ewheeler.net>       
 <1515763256.20160929135700@pvgoran.name> <20160929203439.40814f41@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:50400 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935220AbcI2Wut (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 18:50:49 -0400
In-Reply-To: <20160929203439.40814f41@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Thu, 29 Sep 2016, Kai Krakow wrote:
> Am Thu, 29 Sep 2016 13:57:00 +0700
> schrieb Pavel Goran <via-bcache@pvgoran.name>:
> 
> > Hello Eric,
> > 
> > Thursday, September 29, 2016, 1:21:53 AM, you wrote:
> > 
> > > It respects policy first of course.  You can see the top of
> > > should_writeback() in the patch as context:
> > >         if (cache_mode != CACHE_MODE_WRITEBACK || [...]  
> > 
> > So the priority-dependent logic is only applied when cache mode is
> > "writeback", right? Then, what does "Original bcache logic" from the
> > table in the original patch description mean? That is, how does it
> > differ from "Writeback" from the same table?
> 
> I understand that when bcache heuristics decide to skip writeback
> caching and write directly to the backing device, this would override
> it and still force writeback.
> 
> OTOH, if you don't use the writeback policy, this will simply not apply.

Correct.


> > Does "Writeback" there mean that bcache would write data to the cache
> > *always*, even in case of linear write, or in other situations where
> > the original writeback logic would bypass cache?
> 
> That's what I understood now.

I'm certainly setting the should_writeback hint, but I don't know that 
this necessarily means always. While I've not seen one (nor have I 
looked), there could be an exception to the should_writeback hint that 
would cause a bypass anyway.


> > If so, the table
> > should perhaps be adjusted to say "Always writeback" instead of
> > "Writeback", and "Original writeback logic" instead of "Original
> > bcache logic".
> 
> Makes sense.
> 
> > > If not already in cache, it will read from the backing device and
> > > will not promote into (pollute) your cache. Having idle IOs bypass
> > > the cache can increase performance everywhere else since you
> > > probably don't care about the performance of idle IOs.  
> > 
> > Ok, this sounds convincing.
> 
> And it seems to be true, my real-workload tests today showed
> consistently higher hit-rates.

Yay!


> > Your SSD wearout problem would (again, ideally) be handled by some
> > kind of custom process attribute (no idea if the kernel even has this
> > kind of concept, probably not) that would signal bcache to bypass
> > caching for IO that originates from this process. The additional
> > "bulk" priority class proposed by Kai would also be a good solution.
> 
> That was my thinking behind suggesting a bulk class... To reduce
> wearout. I've killed my first SSD within 12 months due to this and
> using bcache. Well, I didn't actually kill it, I replaced it when the
> lifetime prognosis reached 97%. It was spec'ed for 85 TB data written.
> And the usual 5 GB per day pattern just didn't apply due to untuned
> btrfs maintenance running in the background (scrubbing,
> defragmentation, balancing) via cron.

fwiw, I set my btrfs-transaction PID to high priority and set the cleaner 
threads to low priority. I suppose there's the possibility of a 
priority-inversion deadlock, but I've not run into one.


> > However, given that these two approaches are supposedly unavailable,
> > using existing IO priorities looks like an acceptable solution.
> 
> ACK.
> 
> > > If you really want idle IO that can writeback, then I can set the
> > > default for ioprio_writeback and/or ioprio_bypass to be disabled
> > > until a user explicitly sets them.  
> > 
> > Are you talking about bcache options available via sysfs? It would be
> > good to have control over the priority-dependent logic in this way
> > (or it's already implemented?). Not sure what the defaults should be,
> > though. :) It would be even better to have the possibility to save
> > these flags to the superblock, if it's something that can be easily
> > implemented.
> 
> I think saving to superblock would be a cool feature. I think the
> defaults are very sane. And there should be a flip-switch to turn
> on/off this login, default being off probably. Just to fulfill
> principle of least surprise. I'd probably always turn it on at the first
> opportunity. :-)

I think the default will be 0,0 for writeback and 2,7 for bypass. The best 
surprise that a user could have is better hit rates and less wearout.


> It probably allows me to turn off writearound and instead use writeback
> for my backup storage.

This was an unintended surprise, I'm glad to hear that too!


> Still, I need to know if this logic works with the deadline scheduler
> (which is not supposed to adhere to IO priorities, but still I guess
> bcache will still see them).

I've tested with noop, deadline, cfq, and bfq. They all work great in 
terms of bcache respecting the priority flags. Note that schedulers are 
only applied to the devices below bcache.

--
Eric Wheeler

> 
> 
> -- 
> Regards,
> Kai
> 
> Replies to list-only preferred.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
