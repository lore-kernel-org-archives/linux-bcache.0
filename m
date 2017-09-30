From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sat, 30 Sep 2017 00:13:57 -0700
Message-ID: <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li> <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:44390 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdI3HN7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Sep 2017 03:13:59 -0400
Received: by mail-qk0-f170.google.com with SMTP id r64so1257089qkc.1
        for <linux-bcache@vger.kernel.org>; Sat, 30 Sep 2017 00:13:59 -0700 (PDT)
In-Reply-To: <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

Coly--


On Fri, Sep 29, 2017 at 11:58 PM, Coly Li <i@coly.li> wrote:
> On 2017/9/30 =E4=B8=8A=E5=8D=8811:17, Michael Lyle wrote:
> [snip]
>
> If writeback_rate is not minimum value, it means there are front end
> write requests existing.

This is wrong.  Else we'd never make it back to the target.

> In this case, backend writeback I/O should nice
> I/O throughput to front end I/O. Otherwise, application will observe
> increased I/O latency, especially when dirty percentage is not very
> high. For enterprise workload, this change hurts performance.

No, utilizing less of disk throughput for a given writeback rate
improves workload latency.  :P  The maximum that will be aggregated in
this way is constrained more strongly than the old code...

> An desired behavior for low latency enterprise workload is, when dirty
> percentage is low, once there is front end I/O, backend writeback should
> be at minimum rate. This patch will introduce unstable and unpredictable
> I/O latency.

Nope.  It lowers disk utilization overall, and the amount of disk
bandwidth any individual request chunk can use is explicitly bounded
(unlike before, where it was not).

> Unless there is performance bottleneck of writeback seeking, at least
> enterprise users will focus more on front end I/O latency ....

The less writeback seeks the disk, the more the real workload can seek
this disk!  And if you're at high writeback rates, the vast majority
of the time the disk is seeking!

> This method is helpful only when writeback I/Os is not issued
> continuously, other wise if they are issued within slice_idle,
> underlying elevator will reorder or merge the I/Os in larger request.

We have a subsystem in place to rate-limit and make sure that they are
not issued continuously!  If you want to preserve good latency for
userspace, you want to keep the system in the regime where that
control system is effective!

> Hmm, if you move the dirty IO from btree into dirty_io list, then
> perform I/O, there is risk that once machine is power down during
> writeback there might be dirty data lost. If you continuously issue
> dirty I/O and remove them from btree at same time, that means you will
> introduce more latency to front end I/O...

No... this doesn't change the consistency properties.  I am just
saying-- if we have (up to 5 contiguous things that we're going to
write back), wait till they're all read; plug; dispatch writes ;
unplug.

> And plug list will be unplugged automatically as default, when context
> switching happens. If you will performance read I/Os to the btrees, a
> context switch is probably to happen, then you won't keep a large bio
> lists ...

Thankfully we'll have 5 things to fire immediately after each other,
so we don't need to worry about automatic unplug.

> IMHO when writeback rate is low, especially when backing hard disk is
> not bottleneck, group continuous I/Os in bcache code does not help too
> much for writeback performance. The only benefit is less I/O issued when
> front end I/O is low or idle, but not most of users care about it,
> especially enterprise users.

I disagree!

>> I believe patch 4 is useful on its own, but I have this and other
>> pieces of development that depend upon it.
>
> Current bcache code works well in most of writeback loads, I just worry
> that implementing an elevator in bcache writeback logic is a big
> investment with a little return.

Bcache already implements a (one-way) elevator!  Bcache invests
**significant effort** already to do writebacks in LBA order (to
effectively short-stroke the disk), but because of different arrival
times of the read request they can end up reordered.  This is bad.
This is a bug.

Mike

>
> --
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
