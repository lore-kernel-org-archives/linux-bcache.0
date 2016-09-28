From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 1/2] bcache: introduce ioprio-based bypass/writeback
 hints
Date: Wed, 28 Sep 2016 11:21:53 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609271614340.29933@mail.ewheeler.net>
References: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>        <1610652744.20160927084309@pvgoran.name> <20160927044348.25fedb75@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:40177 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754489AbcI1SWE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Sep 2016 14:22:04 -0400
In-Reply-To: <20160927044348.25fedb75@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-bcache@vger.kernel.org, Pavel Goran <via-bcache@pvgoran.name>

On Tue, 27 Sep 2016, Kai Krakow wrote:

> Am Tue, 27 Sep 2016 08:43:09 +0700
> schrieb Pavel Goran <via-bcache@pvgoran.name>:
> 
> > Hello Eric,
> > 
> > Tuesday, September 27, 2016, 6:17:22 AM, you wrote:
> > 
> > > Add support to bcache hinting functions and sysfs to hint by the
> > > ioprio of 'current' which can be configured with `ionice`.  
> > 
> > > Cache hinting is configurable by writing 'class,level' pairs to
> > > sysfs. These are the defaults:
> > >         echo 2,7 > /sys/block/bcache0/bcache/ioprio_bypass
> > >         echo 2,0 > /sys/block/bcache0/bcache/ioprio_writeback  
> > 
> > > (-p) IO Class    (-n) Class level       Action
> > > -----------------------------------------------------
> > > (1) Realtime      0-7                           Writeback
> > > (2) Best-effort     0                           Writeback
> > > (2) Best-effort   1-6                           Original bcache
> > > logic (2) Best-effort     7                           Bypass cache
> > > (3) Idle          n/a                           Bypass cache  
> > 
> > Not sure it's a good idea, at all. If I set cache policy to, say,
> > write-through, then I expect write-back to never happen, regardless
> > of what userspace does with IO priority.

It respects policy first of course.  You can see the top of 
should_writeback() in the patch as context:
	if (cache_mode != CACHE_MODE_WRITEBACK || [...]

> > Similarly, using low IO priority (idle or best effort-7) should not
> > make IO *slow regardless of any other IO load* (which would happen if
> > cache is completely bypassed).

Perhaps I should explain my motivation for writing such a patch:

We run 10's of terabytes through bcache in writeback mode each week for 
backup verifies.  Since most verifies read snapshots, the pattern appears 
random so bcache pollutes the cache with data that it will never read 
again. Thus, we really needed an ioprio_bypass implementation to save on 
SSD wearout costs.

We have VMs that do a lot of writing, but for which IO latency is not an 
issue. Thus, ioprio_bypasss reduces the erase cycle load on the SSDs for 
those processes as well. There are a few VMs that benefit from 100% 
caching, thus ioprio_writeback can help with performance.

Unnecessary cache reads/writes cause two problems:

1. Performance degrades because the cache is polluted with unnecessary 
   data.

2. It costs real money when SSDs wear out. I have no idea how many we've 
   purchased because of the cost of caching that provides performance we 
   need.


To address your question, though, about making IO slow regardless of other 
IO:

I tested, and even if a read is in an IO class flagged to be bypass (lower 
priority than ioprio_bypass), it will read from the cache if it's already 
hot. In addition, that bypass-flagged read for a block that was in the 
cache does not get demoted---it stays in the cache for processes that need 
it.

If not already in cache, it will read from the backing device and will not 
promote into (pollute) your cache. Having idle IOs bypass the cache can 
increase performance everywhere else since you probably don't care about 
the performance of idle IOs.

> In the end, "idle" means that you don't care about the performance of 
> the process anyways.

Exactly. If an IO is idle, then chances are you've made it idle because 
you care more about other tasks' IO performance. If idle did not bypass 
the cache, then it would pollute the cache and your more important cache 
would have less room for hot data.

> I think the kernel already supports cache hinting in the sense of
> "don't pollute my cache with these file operations". It should maybe
> better hook in with that but I think this was already discussed here.
> The outcome was that mixing different cache levels is also not a good
> idea.

I believe you are referring to the page cache, and yes it supports hinting 
through fadvise and madvise. I've actually investigated this and others 
have already tried. The best route for plumbing is by fiddling page table 
bits to store ioprio bits, but everything thinks that is a bit of a hack. 

See this thread where others have tried and been rejected: 
	https://lkml.org/lkml/2014/10/29/698

As it turns out, fadvise and madvise are too granular for most cases. 
Usually system administrators are the ones making choices about cache 
hierarchy and process priority, whereas, software developers are generally 
implementing fadvise/madvise within their userspace code. The only way to 
push fadvise/madvise down from the outside of a process call is to hook 
the system call with something ugly like LD_PRELOAD; similar 
implementations have been made like libeatmydata.so to turn off 
synchronous writes on existing software without patching and recompiling.

For those of us using direct IO (O_DIRECT), page cache hints are useless 
because the memory cache is being bypassed. This is our use case. We wish 
to avoid the page cache altogether, but influence the block layer cache 
with IO priorities.


> Currently, sticking to using "ioprio_bypass" would probably the best we
> can easily get. I strongly object to enable "ioprio_writeback" to
> bypass whatever policy was assigned to the device.
>
> So, +1 for ioprio_bypass, but NACK for ioprio_writeback...
> 

As above, the policy is respected. This ioprio implementation will not 
override the cache policy and only affects writes if the cache mode is in 
writeback.


> Maybe it would make sense to have another IO class like "bulk" which
> could work like "idle" but also bypasses writing to caches and thus
> stops flushing important data out of cache (and as a side-effect also
> reduces flash wearing for bulk operations).

If you really want idle IO that can writeback, then I can set the default 
for ioprio_writeback and/or ioprio_bypass to be disabled until a user 
explicitly sets them.

Presently, they are configured the way that I would use them in our 
infrastructure. For us, most IO priorities are in the best-effort class 
(-c 2), and levels 1-6 give us plenty of room for organizing priorities. 

Very few processes are low latency (-c 1), but those that are need to 
complete as soon as possible and are thus hinted to always writeback. It 
is also nice to have a non-realtime ioprio of 2,0 for things that need to 
writeback but do not need the throughput limiting time slicing that 
happens in the realtime class in order to provide low latency guarantees.

(One of our systems has only a 13% hit ratio because of pollution. I look 
forward to seeing what this metric becomes after tuning the ioprio 
parameters.)

The block layer is being refactored right now and core changes are not 
being accepted until the legacy scheduling code has been removed or 
deprecated in favor of the blk-mq code. Adding a fourth IO class of "bulk" 
would require modifications to the existing IO schedulers that would 
certainly be rejected upstream.

For now, adding configurable tunables to bcache is our best option to 
provide a feature that has the capacity to increase performance and the 
longevity of flash devices.

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
