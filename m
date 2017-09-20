From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: smooth writeback rate control
Date: Wed, 20 Sep 2017 12:13:50 +0200
Message-ID: <8a4425d9-2b86-e7d0-f332-3a7ad6b3f706@coly.li>
References: <20170920071517.30505-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:59506 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751523AbdITKN5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Sep 2017 06:13:57 -0400
In-Reply-To: <20170920071517.30505-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, kent.overstreet@gmail.com

On 2017/9/20 上午9:15, Michael Lyle wrote:
> This works in conjunction with the new PI controller.  Currently, in
> real-world workloads, the rate controller attempts to write back 1
> sector per second.  In practice, these minimum-rate writebacks are
> between 4k and 60k in test scenarios, since bcache aggregates and
> attempts to do contiguous writes and because filesystems on top of
> bcachefs typically write 4k or more.
> 
> Previously, bcache used to guarantee to write at least once per second.
> This means that the actual writeback rate would exceed the configured
> amount by a factor of 8-120 or more.
> 

There is no guarantee, bcache just tries to writeback 1 key per second
when it reaches the minimum writeback rate. And it try to calculate a
delay time to make the average writeback throughput is around minimum
writeback rate in a longer time period.

So my question is, do you observe 8-120 times more real writeback
throughput in period of every 10 seconds ?


> This patch adjusts to be willing to sleep up to 2.5 seconds, and to
> target writing 4k/second.  On the smallest writes, it will sleep 1
> second like before, but many times it will sleep longer and load the
> backing device less.  This keeps the loading on the cache and backing
> device related to writeback more consistent when writing back at low
> rates.
> 

Again, I'd like to see exact data here, because this patch is about
performance tuning.

I just see the minimum rate increases from 1 to 8 sectors, and minimum
delay increase from 1 to 2.5 seconds. I don't see an exact problem this
patch wants to solve. Is it to write back dirty data faster, or save
more power from cached device ?


Your PI controller perfectly controls writeback rate to minimum value
when dirty data reaches target. At this moment, normally there still is
quite a lot dirty data on cache, increases idle time writeback rate from
1 to 8 sectors does not help too much, it still needs hours to clean the
dirty data.

And normally a hard disk will spin down in minutes, typically from 10
minutes to 30 minutes. So increase the delay time from 1 to 2.5 seconds
won't help hard disk to save power.

I post a proposal patch to linux-bcache@vger.kernel.org, (see
https://www.spinics.net/lists/linux-bcache/msg04837.html), which sets
the writeback rate to maximum value if there is no front end I/O request
for a while (normally it might means more idle time in future). Then the
dirty data on cache can be cleaned up ASAP. And if there is frond end
request coming, set the writeback rate to minimum value, and let the PD
(now it is PI) controller to adjust its value. By this method, if there
is no front end I/O, dirty data can be cleaned much faster and hard disk
also has much more chance to spin down.

Thanks.

-- 
Coly Li
