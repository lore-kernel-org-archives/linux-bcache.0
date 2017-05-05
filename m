From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Reasoning of exposing queue/rotational=0
Date: Fri, 5 May 2017 20:04:54 +0200
Message-ID: <20170505200454.48777837@jupiter.sol.kaishome.de>
References: <20170504232457.13c269c0@jupiter.sol.kaishome.de>
        <f99de33e-f90e-1492-7561-5a63d6814a9e@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58143 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdEESFF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 May 2017 14:05:05 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1d6hb6-0000Xb-4s
        for linux-bcache@vger.kernel.org; Fri, 05 May 2017 20:04:56 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Sat, 6 May 2017 00:11:13 +0800
schrieb Coly Li <i@coly.li>:

> On 2017/5/5 上午5:24, Kai Krakow wrote:
> > Hello!
> > 
> > What's the reasoning for exposing bcache devices as being
> > non-rotational? Currently, it fools btrfs into using ssd allocation
> > scheme on the underlying harddisks which isn't really what I
> > expected to get. So I used a udev rule to change this:
> > 
> > ACTION=="add|change", KERNEL=="bcache*", ATTR{queue/rotational}="1"
> > 
> > Wouldn't it make more sense to set this to the same value as the
> > underlying backing device by default?
> > 
> > Because in reality, the bcache is still what the backing device is:
> > A rotational medium. A cache doesn't make this non-rotational.
> > 
> > Thoughts?  
> 
> It depends on hit ration. If a non-rotational device used as cache,
> and hit ration is high enough, the cached device just responses as
> non-rotational device.
> 
> But yes, I feel your opinion makes sense, in the btrfs case. How
> about a policy like this:
> 
> 
> cache-device-rotational   backing-device-rotational export-rotational
> Y                            Y                      Y
> Y                            N                      N
> N                            Y                      N
> N                            N                      N

This probably makes most sense, although it won't fix my particular
situation... Because I have:

 cdev    bdev    bcache
  N   &&  Y   ==  N
 
But I'd like to have bcache == Y

Hit rate is around 70-85% for me (500GB cache on 2TB data). So your
particular reasoning makes sense, too: 80% of accesses hit the cache
which makes it behave like non-rotational in 80% of all accesses.

But the bcache device itself is only a transition layer, especially we
cannot set any IO scheduler for it, this is left to the lower layers.
And these correctly expose the rotational flag, and that is where I set
deadline for SSD, and cfq for HDD. I also experimented with slice_idle
= 0 on SSD with cfq but deadline gave better results.

Given that, what could the rotational flag also be used for? Currently
it's used by btrfs to select an allocation scheme. I can imagine that
other filesystems do that, too. Does the kernel depend any decision on
this flag? Or anything else other then allocation decision?

Given the case of allocation decision: It makes no sense to pretend SSD
allocation through bcache as bcache block allocation is translated to
the real device and has nothing to do with the actual physical layout
of the backing device. So why pretend it is non-rotational?

Also think of discarding the cache: Now it would be clearly rotational
until cache hit rate builds up again.

Also I don't think applications should mis-interpret the bcache as
non-rotational to optimize workloads for it, because bcache is a
caching layer. It operates exactly for the purpose of optimizing those
workloads itself. Doing otherwise could work against what bcache tries
to achieve, e.g. doing lots of random IO because we pretend to be
non-rotational would push my precious cache data out of the cache for
no reason. Bcache is there to turn random IO into sequential IO - but
not for the sake of "because it can". Applications should still
optimize for rotational media even when running through bcache.

Without further clues it makes most sense to me to set
bcache.rotational = bdev.rotational.

I almost think that bcache does not explicitly set this flag, so it
stays 0. I think the same applies to iscsi and other network block
devices which pretend to be also non-rotational although in reality
they probably aren't. Only, they should probably explicitly not use an
IO scheduler as that is best left to the host system - as in virtual
guests, and as with enterprise RAID controllers, which do their own IO
scheduling. But "rotational" is totally not a decision we would
automatically select a default IO scheduler by. This should be left to
layers that more exactly know what a device is, e.g. udev or the
administrator.

> That is, a bcache device is exposed as non-rotational device only when
> all devices of cache devices and backing devices are all rotational.

I didn't really get that sentence... Either appearance of rotational
seems to be wrong in your sentence. ;-)


-- 
Regards,
Kai

Replies to list-only preferred.
