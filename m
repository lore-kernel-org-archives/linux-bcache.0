From: Coly Li <i@coly.li>
Subject: Re: Reasoning of exposing queue/rotational=0
Date: Sat, 6 May 2017 00:11:13 +0800
Message-ID: <f99de33e-f90e-1492-7561-5a63d6814a9e@coly.li>
References: <20170504232457.13c269c0@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:45098 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdEEQL1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 May 2017 12:11:27 -0400
In-Reply-To: <20170504232457.13c269c0@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>, linux-bcache@vger.kernel.org

On 2017/5/5 上午5:24, Kai Krakow wrote:
> Hello!
> 
> What's the reasoning for exposing bcache devices as being
> non-rotational? Currently, it fools btrfs into using ssd allocation
> scheme on the underlying harddisks which isn't really what I expected
> to get. So I used a udev rule to change this:
> 
> ACTION=="add|change", KERNEL=="bcache*", ATTR{queue/rotational}="1"
> 
> Wouldn't it make more sense to set this to the same value as the
> underlying backing device by default?
> 
> Because in reality, the bcache is still what the backing device is: A
> rotational medium. A cache doesn't make this non-rotational.
> 
> Thoughts?

It depends on hit ration. If a non-rotational device used as cache, and
hit ration is high enough, the cached device just responses as
non-rotational device.

But yes, I feel your opinion makes sense, in the btrfs case. How about a
policy like this:


cache-device-rotational   backing-device-rotational   export-rotational
         Y                            Y                      Y
         Y                            N                      N
         N                            Y                      N
         N                            N                      N

That is, a bcache device is exposed as non-rotational device only when
all devices of cache devices and backing devices are all rotational.

Thanks.

-- 
Coly Li
