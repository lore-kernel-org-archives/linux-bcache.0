From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 29 Sep 2017 20:17:00 -0700
Message-ID: <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn> <477dc501-bbb3-f864-c637-1f19f787448a@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:47877 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752664AbdI3DRB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Sep 2017 23:17:01 -0400
Received: by mail-qk0-f170.google.com with SMTP id b82so1336722qkc.4
        for <linux-bcache@vger.kernel.org>; Fri, 29 Sep 2017 20:17:01 -0700 (PDT)
In-Reply-To: <477dc501-bbb3-f864-c637-1f19f787448a@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Coly--

What you say is correct-- it has a few changes from current behavior.

- When writeback rate is low, it is more willing to do contiguous
I/Os.  This provides an opportunity for the IO scheduler to combine
operations together.  The cost of doing 5 contiguous I/Os and 1 I/O is
usually about the same on spinning disks, because most of the cost is
seeking and rotational latency-- the actual sequential I/O bandwidth
is very high.  This is a benefit.
- When writeback rate is medium, it does I/O more efficiently.  e.g.
if the current writeback rate is 10MB/sec, and there are two
contiguous 1MB segments, they would not presently be combined.  A 1MB
write would occur, then we would increase the delay counter by 100ms,
and then the next write would wait; this new code would issue 2 1MB
writes one after the other, and then sleep 200ms.  On a disk that does
150MB/sec sequential, and has a 7ms seek time, this uses the disk for
13ms + 7ms, compared to the old code that does 13ms + 7ms * 2.  This
is the difference between using 10% of the disk's I/O throughput and
13% of the disk's throughput to do the same work.
- When writeback rate is very high (e.g. can't be obtained), there is
not much difference currently, BUT:

Patch 5 is very important.  Right now, if there are many writebacks
happening at once, the cached blocks can be read in any order.  This
means that if we want to writeback blocks 1,2,3,4,5 we could actually
end up issuing the write I/Os to the backing device as 3,1,4,2,5, with
delays between them.  This is likely to make the disk seek a lot.
Patch 5 provides an ordering property to ensure that the writes get
issued in LBA order to the backing device.

***The next step in this line of development (patch 6 ;) is to link
groups of contiguous I/Os into a list in the dirty_io structure.  To
know whether the "next I/Os" will be contiguous, we need to scan ahead
like the new code in patch 4 does.  Then, in turn, we can plug the
block device, and issue the contiguous writes together.  This allows
us to guarantee that the I/Os will be properly merged and optimized by
the underlying block IO scheduler.   Even with patch 5, currently the
I/Os end up imperfectly combined, and the block layer ends up issuing
writes 1, then 2,3, then 4,5.  This is great that things are combined
some, but it could be combined into one big request.***  To get this
benefit, it requires something like what was done in patch 4.

I believe patch 4 is useful on its own, but I have this and other
pieces of development that depend upon it.
Thanks,

Mike
