From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH 1/2] bcache: introduce ioprio-based bypass/writeback
 hints
Date: Tue, 27 Sep 2016 04:43:48 +0200
Message-ID: <20160927044348.25fedb75@jupiter.sol.kaishome.de>
References: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>
        <1610652744.20160927084309@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44423 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753492AbcI0CoH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Sep 2016 22:44:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1boiNF-0006lH-0u
        for linux-bcache@vger.kernel.org; Tue, 27 Sep 2016 04:44:01 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Tue, 27 Sep 2016 08:43:09 +0700
schrieb Pavel Goran <via-bcache@pvgoran.name>:

> Hello Eric,
> 
> Tuesday, September 27, 2016, 6:17:22 AM, you wrote:
> 
> > Add support to bcache hinting functions and sysfs to hint by the
> > ioprio of 'current' which can be configured with `ionice`.  
> 
> > Cache hinting is configurable by writing 'class,level' pairs to
> > sysfs. These are the defaults:
> >         echo 2,7 > /sys/block/bcache0/bcache/ioprio_bypass
> >         echo 2,0 > /sys/block/bcache0/bcache/ioprio_writeback  
> 
> > (-p) IO Class    (-n) Class level       Action
> > -----------------------------------------------------
> > (1) Realtime      0-7                           Writeback
> > (2) Best-effort     0                           Writeback
> > (2) Best-effort   1-6                           Original bcache
> > logic (2) Best-effort     7                           Bypass cache
> > (3) Idle          n/a                           Bypass cache  
> 
> Not sure it's a good idea, at all. If I set cache policy to, say,
> write-through, then I expect write-back to never happen, regardless
> of what userspace does with IO priority.
> 
> Similarly, using low IO priority (idle or best effort-7) should not
> make IO *slow regardless of any other IO load* (which would happen if
> cache is completely bypassed).
> 
> Right now, it looks to me as inappropriate mixing of different
> concepts. Unless I fail to understand something.

I'm also uncomfortable with mixing concepts but I like the idea of
this. In the end, "idle" means that you don't care about the
performance of the process anyways.

I think the kernel already supports cache hinting in the sense of
"don't pollute my cache with these file operations". It should maybe
better hook in with that but I think this was already discussed here.
The outcome was that mixing different cache levels is also not a good
idea.

Currently, sticking to using "ioprio_bypass" would probably the best we
can easily get. I strongly object to enable "ioprio_writeback" to
bypass whatever policy was assigned to the device.

So, +1 for ioprio_bypass, but NACK for ioprio_writeback...

Maybe it would make sense to have another IO class like "bulk" which
could work like "idle" but also bypasses writing to caches and thus
stops flushing important data out of cache (and as a side-effect also
reduces flash wearing for bulk operations).


-- 
Regards,
Kai

Replies to list-only preferred.
