From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 16:27:06 +0800
Message-ID: <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li>
 <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
 <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li>
 <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li>
 <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:40100 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbdJFI1T (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Oct 2017 04:27:19 -0400
In-Reply-To: <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/10/6 上午6:59, Michael Lyle wrote:
> I think one of the problems here is that there is no consistent
> requirements or figure of merit for performance.

Hi Mike,

I agree with you. Yes, exactly it is. Performance optimization is always
perfectly for specific workload, it is almost no why to make everyone
happy. To me, most of time it is a trade off: if I want to have this, I
know there must be something I should pay or lose.

The decision is dependent on which kind of work load people cares about,
obviously we cannot get an agreement so far. For our discussion, it is
not just about correct or mistake, it is mainly about making choice.

> You've argued against changes because of A) perceived impact to
> front-end I/O latency, B) writeback rate at idle, C) peak
> instantaneous writeback rate, D) time to writeback the entire amount.
> These are all, to some extent, contradictory.
> 
> I was trying to make changes in writeback to improve **efficiency**--
> the amount of writeback that is done per the amount of time the
> backing device is tied up.  We could have added tunables for A/B/C to
> pick any operating along there.  In addition, the changes I was trying
> to make were **on the path to further improvement**-- submitting
> sequential I/O together with plugging is known to improve merge.
> 
> Users on #bcache IRC on oftc.net constantly talk about writeback
> performance and writeback use cases-- it's probably the most common
> topic of discussion about bcache.  These changes would have improved
> that and laid the groundwork for further improvement.

I assume that if the bio reorder patches work better in above tests,
then maybe they will perform better with more complicated workloads as
well. This assumption might not be correct, but at least I can have
reproducible performance numbers to make decision.

This is not the first time I encounter such discussion like we have this
time. My rule is, let the data talk to each other.

You explain what your idea very well, it is clear to me. But if you
don't have reproducible performance data to support the idea, and tell
people the performance optimization result might be random, it will be
quite hard to help people to understand it and make decision for the
trade off.

> I've retired, but a year ago I was running a bcache environment with
> about 40 computers running development environments  and continuous
> integration test rigs; we would provision and tear down hundreds of
> VMs per day; machines had 256-512GB of RAM, 1TB SATA RAID1 cache
> volumes and RAID10 sets 6-8 drives wide.  The use case was enterprise
> DB-- so I think I know a thing or two about enterprise use cases ;)
> 
> Writeback did obviously bad things in that environment, which is why I
> wanted to fix it.  I also see obviously bad behavior on my small home
> test rig of RAID1 480GB NVMe + RAID1 6TB disks.

Aha, I see why I felt so enjoyed when I read your patch (commit
9276717b9e29 ("bcache: fix bch_hprint crash and improve output")), you
are very experienced engineer. Your bio reorder patches work correctly
as you described, the problem is from me, I won't support this idea
because it may hurt performance of the workloads I care about.

It is rare to meet an experienced people like you, I do hope you may
stay here, continue to help us on patch review and code improvement.

Thanks.

-- 
Coly Li
