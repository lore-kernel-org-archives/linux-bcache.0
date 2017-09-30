From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sat, 30 Sep 2017 14:58:24 +0800
Message-ID: <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li>
 <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:44102 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbdI3G6a (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Sep 2017 02:58:30 -0400
In-Reply-To: <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 2017/9/30 上午11:17, Michael Lyle wrote:
> Coly--
> 
> What you say is correct-- it has a few changes from current behavior.
> 
> - When writeback rate is low, it is more willing to do contiguous
> I/Os.  This provides an opportunity for the IO scheduler to combine
> operations together.  The cost of doing 5 contiguous I/Os and 1 I/O is
> usually about the same on spinning disks, because most of the cost is
> seeking and rotational latency-- the actual sequential I/O bandwidth
> is very high.  This is a benefit.

Hi Mike,

Yes I can see it.


> - When writeback rate is medium, it does I/O more efficiently.  e.g.
> if the current writeback rate is 10MB/sec, and there are two
> contiguous 1MB segments, they would not presently be combined.  A 1MB
> write would occur, then we would increase the delay counter by 100ms,
> and then the next write would wait; this new code would issue 2 1MB
> writes one after the other, and then sleep 200ms.  On a disk that does
> 150MB/sec sequential, and has a 7ms seek time, this uses the disk for
> 13ms + 7ms, compared to the old code that does 13ms + 7ms * 2.  This
> is the difference between using 10% of the disk's I/O throughput and
> 13% of the disk's throughput to do the same work.


If writeback_rate is not minimum value, it means there are front end
write requests existing. In this case, backend writeback I/O should nice
I/O throughput to front end I/O. Otherwise, application will observe
increased I/O latency, especially when dirty percentage is not very
high. For enterprise workload, this change hurts performance.

An desired behavior for low latency enterprise workload is, when dirty
percentage is low, once there is front end I/O, backend writeback should
be at minimum rate. This patch will introduce unstable and unpredictable
I/O latency.

Unless there is performance bottleneck of writeback seeking, at least
enterprise users will focus more on front end I/O latency ....

> - When writeback rate is very high (e.g. can't be obtained), there is
> not much difference currently, BUT:
> 
> Patch 5 is very important.  Right now, if there are many writebacks
> happening at once, the cached blocks can be read in any order.  This
> means that if we want to writeback blocks 1,2,3,4,5 we could actually
> end up issuing the write I/Os to the backing device as 3,1,4,2,5, with
> delays between them.  This is likely to make the disk seek a lot.
> Patch 5 provides an ordering property to ensure that the writes get
> issued in LBA order to the backing device.

This method is helpful only when writeback I/Os is not issued
continuously, other wise if they are issued within slice_idle,
underlying elevator will reorder or merge the I/Os in larger request.


> 
> ***The next step in this line of development (patch 6 ;) is to link
> groups of contiguous I/Os into a list in the dirty_io structure.  To
> know whether the "next I/Os" will be contiguous, we need to scan ahead
> like the new code in patch 4 does.  Then, in turn, we can plug the
> block device, and issue the contiguous writes together.  This allows
> us to guarantee that the I/Os will be properly merged and optimized by
> the underlying block IO scheduler.   Even with patch 5, currently the
> I/Os end up imperfectly combined, and the block layer ends up issuing
> writes 1, then 2,3, then 4,5.  This is great that things are combined
> some, but it could be combined into one big request.***  To get this
> benefit, it requires something like what was done in patch 4.
> 

Hmm, if you move the dirty IO from btree into dirty_io list, then
perform I/O, there is risk that once machine is power down during
writeback there might be dirty data lost. If you continuously issue
dirty I/O and remove them from btree at same time, that means you will
introduce more latency to front end I/O...

And plug list will be unplugged automatically as default, when context
switching happens. If you will performance read I/Os to the btrees, a
context switch is probably to happen, then you won't keep a large bio
lists ...

IMHO when writeback rate is low, especially when backing hard disk is
not bottleneck, group continuous I/Os in bcache code does not help too
much for writeback performance. The only benefit is less I/O issued when
front end I/O is low or idle, but not most of users care about it,
especially enterprise users.


> I believe patch 4 is useful on its own, but I have this and other
> pieces of development that depend upon it.

Current bcache code works well in most of writeback loads, I just worry
that implementing an elevator in bcache writeback logic is a big
investment with a little return.

-- 
Coly Li
