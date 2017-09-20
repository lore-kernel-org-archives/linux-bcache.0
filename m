From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: smooth writeback rate control
Date: Wed, 20 Sep 2017 22:24:31 +0200
Message-ID: <1137d210-2fc8-5c23-1498-036aee0c19f2@coly.li>
References: <20170920071517.30505-1-mlyle@lyle.org>
 <8a4425d9-2b86-e7d0-f332-3a7ad6b3f706@coly.li>
 <20170920145038.aq2ogavqufuackgd@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:32828 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751529AbdITUYj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Sep 2017 16:24:39 -0400
In-Reply-To: <20170920145038.aq2ogavqufuackgd@kmo-pixel>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org

On 2017/9/20 下午4:50, Kent Overstreet wrote:
> On Wed, Sep 20, 2017 at 12:13:50PM +0200, Coly Li wrote:
>> On 2017/9/20 上午9:15, Michael Lyle wrote:
>>> This works in conjunction with the new PI controller.  Currently, in
>>> real-world workloads, the rate controller attempts to write back 1
>>> sector per second.  In practice, these minimum-rate writebacks are
>>> between 4k and 60k in test scenarios, since bcache aggregates and
>>> attempts to do contiguous writes and because filesystems on top of
>>> bcachefs typically write 4k or more.
>>>
>>> Previously, bcache used to guarantee to write at least once per second.
>>> This means that the actual writeback rate would exceed the configured
>>> amount by a factor of 8-120 or more.
>>>
>>
>> There is no guarantee, bcache just tries to writeback 1 key per second
>> when it reaches the minimum writeback rate. And it try to calculate a
>> delay time to make the average writeback throughput is around minimum
>> writeback rate in a longer time period.
>>
>> So my question is, do you observe 8-120 times more real writeback
>> throughput in period of every 10 seconds ?
>>
>>
>>> This patch adjusts to be willing to sleep up to 2.5 seconds, and to
>>> target writing 4k/second.  On the smallest writes, it will sleep 1
>>> second like before, but many times it will sleep longer and load the
>>> backing device less.  This keeps the loading on the cache and backing
>>> device related to writeback more consistent when writing back at low
>>> rates.
>>>
>>
>> Again, I'd like to see exact data here, because this patch is about
>> performance tuning.
> 
> Well, it's not just performance tuning. My PD controller code was always, to be
> honest, crap; I'd been hoping someone who actually knew what they were doing on
> this subject would rewrite that code for years, and Michael actually does know
> what he's doing with PID controllers.
> 

Hi Kent,

The whole P.I.D controller stuff is about performance tuning, isn't it ?

Before we make a change relative to performance, we should know the
exact benchmark result for real workload, not emulator. This is the
reason why I did the latency distribution test myself. And good to know
there is no latency regression and writeback rate decreases to minimum
rate smoothly when dirty data gets close to dirty target.

It is not difficult to write a P.I.D controller code, it is difficult to
implement it in a better way. From my test I feel Mike's P.I controller
is good, but we need one more people to understand it. This is why I ask
many questions, and some of the questions are quite basic. If we have
one more people understand why this P.I controller is better, there will
be more people come to understand it.

> That said, your point that this is a behavioural change as well is a valid one.
> It might be worth trying to tune the new controller to mimic the behaviour of
> the old code as much as possible, and _then_ separately possibly change the
> default tuning. However, due to the crappyness of the old code and the
> difficulty in understanding what it's actually going to do in any given
> situation that might not be practical or worthwhile.
> 

My point is, we should have exact real data to approve this change makes
things better. Better means a problem gets solved. For this single
patch, I see description on how the change is made, I don't see what
exact problem to be solved.


> Anyways, I wouldn't look at this patch so much as performance tuning (and I
> wouldn't aim for changing behavior any more than is necessary in this patch); I
> would view it as a path towards getting something more understandable that
> people can actually tune and understand wtf it's going to do.
> 

The P.I controller patch makes sense. But for this single patch, change
minimum writeback rate from 1 to 8, and next delay timeout from 1 to 2.5
seconds, I don't see this modification is path towards getting things
more understandable, before we see real data to approve it.

This is why I said: again, I'd like to see exact data here. Let me
discuss with Micheal for more details.

Anyway, my first rule is, if you add Reviewed-by or Acked-by to a patch,
I just shut up immediately :-)

Thanks.

-- 
Coly Li
