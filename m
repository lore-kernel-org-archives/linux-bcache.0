From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: [PATCH 1/2] bcache: introduce ioprio-based bypass/writeback hints
Date: Tue, 27 Sep 2016 08:43:09 +0700
Message-ID: <1610652744.20160927084309@pvgoran.name>
References: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:39388 "EHLO
        v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933318AbcI0BsP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Sep 2016 21:48:15 -0400
In-Reply-To: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <linux-bcache@vger.kernel.org>

Hello Eric,

Tuesday, September 27, 2016, 6:17:22 AM, you wrote:

> Add support to bcache hinting functions and sysfs to hint by the ioprio of
> 'current' which can be configured with `ionice`.

> Cache hinting is configurable by writing 'class,level' pairs to sysfs.
> These are the defaults:
>         echo 2,7 > /sys/block/bcache0/bcache/ioprio_bypass
>         echo 2,0 > /sys/block/bcache0/bcache/ioprio_writeback

> (-p) IO Class    (-n) Class level       Action
> -----------------------------------------------------
> (1) Realtime      0-7                           Writeback
> (2) Best-effort     0                           Writeback
> (2) Best-effort   1-6                           Original bcache logic
> (2) Best-effort     7                           Bypass cache
> (3) Idle          n/a                           Bypass cache

Not sure it's a good idea, at all. If I set cache policy to, say,
write-through, then I expect write-back to never happen, regardless of what
userspace does with IO priority.

Similarly, using low IO priority (idle or best effort-7) should not make IO
*slow regardless of any other IO load* (which would happen if cache is
completely bypassed).

Right now, it looks to me as inappropriate mixing of different concepts.
Unless I fail to understand something.

Pavel Goran
  
