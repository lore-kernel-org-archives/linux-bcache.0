From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH 1/2] bcache: introduce ioprio-based bypass/writeback
 hints
Date: Thu, 29 Sep 2016 20:34:39 +0200
Message-ID: <20160929203439.40814f41@jupiter.sol.kaishome.de>
References: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>
        <1610652744.20160927084309@pvgoran.name>
        <20160927044348.25fedb75@jupiter.sol.kaishome.de>
        <alpine.LRH.2.11.1609271614340.29933@mail.ewheeler.net>
        <1515763256.20160929135700@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48817 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbcI2SfX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Sep 2016 14:35:23 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1bpgAe-0008Ky-H6
        for linux-bcache@vger.kernel.org; Thu, 29 Sep 2016 20:35:00 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Thu, 29 Sep 2016 13:57:00 +0700
schrieb Pavel Goran <via-bcache@pvgoran.name>:

> Hello Eric,
> 
> Thursday, September 29, 2016, 1:21:53 AM, you wrote:
> 
> > It respects policy first of course.  You can see the top of
> > should_writeback() in the patch as context:
> >         if (cache_mode != CACHE_MODE_WRITEBACK || [...]  
> 
> So the priority-dependent logic is only applied when cache mode is
> "writeback", right? Then, what does "Original bcache logic" from the
> table in the original patch description mean? That is, how does it
> differ from "Writeback" from the same table?

I understand that when bcache heuristics decide to skip writeback
caching and write directly to the backing device, this would override
it and still force writeback.

OTOH, if you don't use the writeback policy, this will simply not apply.

> Does "Writeback" there mean that bcache would write data to the cache
> *always*, even in case of linear write, or in other situations where
> the original writeback logic would bypass cache?

That's what I understood now.

> If so, the table
> should perhaps be adjusted to say "Always writeback" instead of
> "Writeback", and "Original writeback logic" instead of "Original
> bcache logic".

Makes sense.

> > If not already in cache, it will read from the backing device and
> > will not promote into (pollute) your cache. Having idle IOs bypass
> > the cache can increase performance everywhere else since you
> > probably don't care about the performance of idle IOs.  
> 
> Ok, this sounds convincing.

And it seems to be true, my real-workload tests today showed
consistently higher hit-rates.

> Ideally this would be handled by some kind of priority semantics
> within the cache, so that "high-priority" data would always replace
> "low-priority" data, and "low-priority" data would only replace
> "high-priority" data if it's really old. It's entirely feasible to
> implement within bcache, but probably it wouldn't be easy, and might
> even mean changing cache data format.

I don't think it's worth to add such a management overhead... Maybe one
better stacks multiple cache layers with different policies.

> Your SSD wearout problem would (again, ideally) be handled by some
> kind of custom process attribute (no idea if the kernel even has this
> kind of concept, probably not) that would signal bcache to bypass
> caching for IO that originates from this process. The additional
> "bulk" priority class proposed by Kai would also be a good solution.

That was my thinking behind suggesting a bulk class... To reduce
wearout. I've killed my first SSD within 12 months due to this and
using bcache. Well, I didn't actually kill it, I replaced it when the
lifetime prognosis reached 97%. It was spec'ed for 85 TB data written.
And the usual 5 GB per day pattern just didn't apply due to untuned
btrfs maintenance running in the background (scrubbing,
defragmentation, balancing) via cron.

> However, given that these two approaches are supposedly unavailable,
> using existing IO priorities looks like an acceptable solution.

ACK.

> > If you really want idle IO that can writeback, then I can set the
> > default for ioprio_writeback and/or ioprio_bypass to be disabled
> > until a user explicitly sets them.  
> 
> Are you talking about bcache options available via sysfs? It would be
> good to have control over the priority-dependent logic in this way
> (or it's already implemented?). Not sure what the defaults should be,
> though. :) It would be even better to have the possibility to save
> these flags to the superblock, if it's something that can be easily
> implemented.

I think saving to superblock would be a cool feature. I think the
defaults are very sane. And there should be a flip-switch to turn
on/off this login, default being off probably. Just to fulfill
principle of least surprise. I'd probably always turn it on at the first
opportunity. :-)

It probably allows me to turn off writearound and instead use writeback
for my backup storage.

Still, I need to know if this logic works with the deadline scheduler
(which is not supposed to adhere to IO priorities, but still I guess
bcache will still see them).


-- 
Regards,
Kai

Replies to list-only preferred.
