From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re[2]: [PATCH 1/2] bcache: introduce ioprio-based bypass/writeback hints
Date: Thu, 29 Sep 2016 13:57:00 +0700
Message-ID: <1515763256.20160929135700@pvgoran.name>
References: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>        <1610652744.20160927084309@pvgoran.name> <20160927044348.25fedb75@jupiter.sol.kaishome.de> <alpine.LRH.2.11.1609271614340.29933@mail.ewheeler.net>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:39780 "EHLO
        v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753963AbcI2G5E (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 02:57:04 -0400
In-Reply-To: <alpine.LRH.2.11.1609271614340.29933@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <linux-bcache@vger.kernel.org>

Hello Eric,

Thursday, September 29, 2016, 1:21:53 AM, you wrote:

> It respects policy first of course.  You can see the top of
> should_writeback() in the patch as context:
>         if (cache_mode != CACHE_MODE_WRITEBACK || [...]

So the priority-dependent logic is only applied when cache mode is
"writeback", right? Then, what does "Original bcache logic" from the table in
the original patch description mean? That is, how does it differ from
"Writeback" from the same table?

Does "Writeback" there mean that bcache would write data to the cache
*always*, even in case of linear write, or in other situations where the
original writeback logic would bypass cache? If so, the table should perhaps
be adjusted to say "Always writeback" instead of "Writeback", and "Original
writeback logic" instead of "Original bcache logic".

> If not already in cache, it will read from the backing device and will not
> promote into (pollute) your cache. Having idle IOs bypass the cache can 
> increase performance everywhere else since you probably don't care about 
> the performance of idle IOs.

Ok, this sounds convincing.

Ideally this would be handled by some kind of priority semantics within the
cache, so that "high-priority" data would always replace "low-priority" data,
and "low-priority" data would only replace "high-priority" data if it's really
old. It's entirely feasible to implement within bcache, but probably it
wouldn't be easy, and might even mean changing cache data format.

Your SSD wearout problem would (again, ideally) be handled by some kind of
custom process attribute (no idea if the kernel even has this kind of concept,
probably not) that would signal bcache to bypass caching for IO that
originates from this process. The additional "bulk" priority class proposed by
Kai would also be a good solution.

However, given that these two approaches are supposedly unavailable, using
existing IO priorities looks like an acceptable solution.

> If you really want idle IO that can writeback, then I can set the default
> for ioprio_writeback and/or ioprio_bypass to be disabled until a user 
> explicitly sets them.

Are you talking about bcache options available via sysfs? It would be good to
have control over the priority-dependent logic in this way (or it's already
implemented?). Not sure what the defaults should be, though. :) It would be
even better to have the possibility to save these flags to the superblock, if
it's something that can be easily implemented.

Pavel Goran
  
