From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Reasoning of exposing queue/rotational=0
Date: Fri, 5 May 2017 21:01:41 +0200
Message-ID: <20170505210141.12f9f34d@jupiter.sol.kaishome.de>
References: <20170504232457.13c269c0@jupiter.sol.kaishome.de>
        <f99de33e-f90e-1492-7561-5a63d6814a9e@coly.li>
        <20170505174438.GA22811@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51704 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdEETBu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 May 2017 15:01:50 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1d6iU2-0002qp-Re
        for linux-bcache@vger.kernel.org; Fri, 05 May 2017 21:01:42 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Fri, 5 May 2017 19:44:39 +0200
schrieb Vojtech Pavlik <vojtech@suse.com>:

> On Sat, May 06, 2017 at 12:11:13AM +0800, Coly Li wrote:
> > On 2017/5/5 上午5:24, Kai Krakow wrote:  
> > > Hello!
> > > 
> > > What's the reasoning for exposing bcache devices as being
> > > non-rotational? Currently, it fools btrfs into using ssd
> > > allocation scheme on the underlying harddisks which isn't really
> > > what I expected to get. So I used a udev rule to change this:
> > > 
> > > ACTION=="add|change", KERNEL=="bcache*",
> > > ATTR{queue/rotational}="1"
> > > 
> > > Wouldn't it make more sense to set this to the same value as the
> > > underlying backing device by default?
> > > 
> > > Because in reality, the bcache is still what the backing device
> > > is: A rotational medium. A cache doesn't make this non-rotational.
> > > 
> > > Thoughts?  
> > 
> > It depends on hit ration. If a non-rotational device used as cache,
> > and hit ration is high enough, the cached device just responses as
> > non-rotational device.
> > 
> > But yes, I feel your opinion makes sense, in the btrfs case. How
> > about a policy like this:
> > 
> > 
> > cache-device-rotational   backing-device-rotational
> > export-rotational Y
> > Y                      Y Y
> > N                      N N
> > Y                      N N
> > N                      N
> > 
> > That is, a bcache device is exposed as non-rotational device only
> > when all devices of cache devices and backing devices are all
> > rotational.  
> 
> I don't think that makes much sense either - the cache device will not
> be used in the pattern that the exposed bcache device is, so any
> choice of access patterns by a higher level based on
> rotational/non-rotational will be messed up anyway.

BTW: Exactly that would be the reasoning for me to not set it
statically to 0, but instead to the value of the backing device. For
example, turning it from 1 into 0 up the layers already messes up with
decisions btrfs takes.

In the end, bcache doesn't magically turn my storage into
non-rotational. It is more about turning random IO into sequential IO.
That you get higher throughput also and almost 0 seek time for cache
hits, is just a by-product (tho, a very welcome one).

Given the case that write-caching is set to write-around, or
write-through, your application would still see rotational behavior but
the flag tells it "non-rotational". That seems wrong. Only write-back
caching gives you non-rotational write behavior as seen from the
application. And when bcache passes the sequential cutoff, it doesn't
matter anyway. But now a wrong assumption about revolution can come
into play: An application could try to do sequential IO if seeing
rotational media - but now it doesn't care: It will waste wear-leveling
and discard data that really should belong into the cache.

And when reading, it behaves more like a big, permanent block cache: If
the cache is hit, that's more comparable to a hit in the page/block
cache of the kernel. If it's a miss, it still looks like rotational
access to the application.

So what's the deal?

> I think the current behavior (rotational=0) is correct in most cases.

Currently I don't see why. What defines "most cases"?


-- 
Regards,
Kai

Replies to list-only preferred.
