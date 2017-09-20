From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: smooth writeback rate control
Date: Wed, 20 Sep 2017 08:28:04 -0700
Message-ID: <CAJ+L6qdoZKtnrVZSjC_HC00sHs=vCLa-TrJ6qEqjjaxn8BUjXg@mail.gmail.com>
References: <20170920071517.30505-1-mlyle@lyle.org> <8a4425d9-2b86-e7d0-f332-3a7ad6b3f706@coly.li>
 <CAJ+L6qcZVE0hkiN0xe00fFt4ndmha+uOi9x4UpO-7DRD=vh_mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:55107 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdITP2G (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Sep 2017 11:28:06 -0400
Received: by mail-qt0-f180.google.com with SMTP id i13so3133038qtc.11
        for <linux-bcache@vger.kernel.org>; Wed, 20 Sep 2017 08:28:05 -0700 (PDT)
In-Reply-To: <CAJ+L6qcZVE0hkiN0xe00fFt4ndmha+uOi9x4UpO-7DRD=vh_mQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On Wed, Sep 20, 2017 at 3:13 AM Coly Li <i@coly.li> wrote:
>
> So my question is, do you observe 8-120 times more real writeback
> throughput in period of every 10 seconds ?

 In real world workloads I end up with no keys of length less than
4096.  Do you?

I would like the minimum writeback rate to be a realistic value that
may actually be attained.  Right now, in practice, bcache writes
**much faster**.  Previously, you were concerned that setting the
target for number of writes would result in increased backing disk
workload--- the new values are based on measurement that in all cases
this code writes back slower and loads the disk less than the old
code, so it should mitigate your concern.

> Again, I'd like to see exact data here, because this patch is about
> performance tuning.

OK.  Run iostat 1 on any workload.  See if you ever see a write rate
of less than 4k/sec to the backing disk.  I've run a variety of
workloads and never have.  I can send you very long iostat 1 logs if
it would help ;)

When the system is writing much more than the control system is asking
for, the control system is effectively disengaged.  This patch
increases the range of control authority by allowing the minimal
interval to be 2.5x slower.

> I just see the minimum rate increases from 1 to 8 sectors, and minimum
> delay increase from 1 to 2.5 seconds. I don't see an exact problem this
> patch wants to solve. Is it to write back dirty data faster, or save
> more power from cached device ?

So one thing that's really bad that's happening currently is that when
the disk is idle, is that the disk is repeatedly undergoing
load/unload cycles (very long seeks).  The disks I have-- Seagate
ST6000VN0041 Ironwolf NAS 6TB-- seek off the active portion of the
platter when idle for 750ms.  So the disks are making a very loud
clunk at one second intervals during idle writeback, which is not good
for the drives.  When writing back faster, they are quieter.  This
will at least do it 2.5x less often.

In a subsequent patch, there's additional things I'd like to do-- like
be willing to do no write after a wakeup if we are very far ahead.
That is, to allow the effective value to be much larger than 2.5
seconds.  This would potentially allow spindown on laptops, etc.  But
this change is still worthwhile on its own.

Another thing that would be helpful would be to issue more than 1
write at a time, so that queue depth doesn't always equal 1.  Queue
depth=4 has about 40-50% more throughput--- that is, it completes the
4 IOPs in about 2.5x the time of one-- when writes are clustered to
the same region of the disk/short-stroked.  However this has a
potential cost in latency, so it needs to be carefully traded off.

> [snipped some]
>
> I post a proposal patch to linux-bcache@vger.kernel.org, (see
> https://www.spinics.net/lists/linux-bcache/msg04837.html), which sets
> the writeback rate to maximum value if there is no front end I/O request
> for a while (normally it might means more idle time in future). Then the
> dirty data on cache can be cleaned up ASAP. And if there is frond end
> request coming, set the writeback rate to minimum value, and let the PD
> (now it is PI) controller to adjust its value. By this method, if there
> is no front end I/O, dirty data can be cleaned much faster and hard disk
> also has much more chance to spin down.

While this could clear out dirty data sooner, I'm not sure this is
always a good idea.  For intermittent, write-heavy workloads it's
good, but it substantially increases the chance that occasional random
reads have to write a long time-- which is usually the opposite from
what an IO scheduler tries to achieve.

>
> Thanks.
>
> --
> Coly Li

Mike
