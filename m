From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sat, 30 Sep 2017 01:31:33 -0700
Message-ID: <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li> <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li> <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
 <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li> <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:54807 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbdI3Ibf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Sep 2017 04:31:35 -0400
Received: by mail-qk0-f170.google.com with SMTP id d70so1571004qkc.11
        for <linux-bcache@vger.kernel.org>; Sat, 30 Sep 2017 01:31:35 -0700 (PDT)
In-Reply-To: <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

Just one more note---

IO merging is not happening properly right now.

It's easy to get a case together where basically all the writeback is
sequential.  E.g. if your writeback dirty data target is 15GB, do
something like:

$ sync;fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1
--name=test --filename=test --bs=8k --iodepth=256 --size=30G
--readwrite=randwrite --ramp_time=4

This creates a situation where bcache has lots of 8K segments and
they're almost all sequential.

Wait for the test to complete, then watch iostat 1 .  You'll see that
the writeback KB written / tps == just a little more than 8, despite
the spinning disks doing IO at maximum rate.  You can feel the disk
and tell it is seeking tons.  The IOs are not being merged properly.

Mike

On Sat, Sep 30, 2017 at 1:23 AM, Michael Lyle <mlyle@lyle.org> wrote:
> On Sat, Sep 30, 2017 at 1:03 AM, Coly Li <i@coly.li> wrote:
>>>> If writeback_rate is not minimum value, it means there are front end
>>>> write requests existing.
>>>
>>> This is wrong.  Else we'd never make it back to the target.
>>>
>>
>> Of cause we can :-) When dirty data is far beyond dirty percent,
>> writeback rate is quite high, in that case dc->last_read takes effect.
>> But this is not the situation which your patch handles better.
>
> ... and dirty data can be beyond dirty percent without front-end write
> requests happening, right?  dirty data being significantly beyond
> dirty percent means that we fell far behind at some point in the past,
> because the spinning disk couldn't keep up with the writeback rate...
>
> I really don't even understand what you're saying.  Front-end write
> exists existing that will make their way to the backing disk will only
> happen if writeback is bypassed or if they're judged to be sequential.
> The point of writeback is to eat these front-end write requests.
>
>> You are right. But when writeback rate is high, dc->last_read can solve
>> the seeking problem as your patch does.
>
> Sure, but it doesn't lay the ground work for plugging..
>
>> Do you mean write I/O cannot be issued within slice_idle, or they are
>> issued within slice_idle but underlying elevator does not merge the
>> continuous request ?
>
> I mean this:  imagine the writeback rate is high with the current
> code, and the writeback code issues read requests for backing
> locations 1,2,3,4,5,6, which are noncontiguous on the SSD.
>
> 1, 3, 4, 5 are read quickly and the underlying elevator merges 3, 4, and 5.
>
> 2 & 6 arrive 2ms later.
>
> What happens?
>
>> I meant the dirty_io list in your future patch, not current 5 bios
>> patch. Hmm, maybe you can ignore my noise here, I just jumped off the topic.
>
> Keeping the set of dirty_io objects that are being issued in a list so
> that it's easy to iterate contiguous ones doesn't change the
> commitment behavior.
>
>>>> And plug list will be unplugged automatically as default, when context
>>>> switching happens. If you will performance read I/Os to the btrees, a
>>>> context switch is probably to happen, then you won't keep a large bio
>>>> lists ...
>>>
>>> Thankfully we'll have 5 things to fire immediately after each other,
>>> so we don't need to worry about automatic unplug.
>>>
>>
>> Forgive me, again I meant dirty_io list stuffs, not this patch...
>
> The idea is this: the group of up-to-5 IOs that the current patch
> gathers, are put in a list.  When all 5 have been read, then the
> device is plugged, and the writes are issued together, and then the
> device is unplugged.  Kent suggested this to me on IRC.
>
>> Could you please show exact benchmark result ? Then it will be easier to
>> change my mind. I only know if writeback I/O is not continuously issued
>> within slice_idle, mostly it is because read dirty delayed in line 238
>> of read_dirty(),
>> 235     if (KEY_START(&w->key) != dc->last_read ||
>> 236         jiffies_to_msecs(delay) > 50)
>> 237             while (!kthread_should_stop() && delay)
>> 238                     delay = schedule_timeout_interruptible(delay);
>>
>> If writeback rate is high and writeback I/O is continuous, read I/O will
>> be issued without delay. Then writeback I/O will be issued by
>> write_dirty() in very short time.
>
> What this code says is, you're willing to get up to 50ms "ahead" on
> the writeback for contiguous I/O.
>
> This is bad, because: A) there is no bounds on how much you are
> willing to aggregate.  If the writeback rate is high, 50ms could be a
> lot of data, and a lot of IOPs to the cache device.  The new code
> bounds this.  B) Even if a single I/O could put you 50ms ahead, it
> still could be advantageous to do multiple writes.
>
>> Therefore without a real performance comparison, I cannot image why
>> adjacent write requests cannot merged in elevator... Unless I do the
>> test myself.
>
> See the above example with the lack of write-ordering-enforcement.
>
> Mike
>
>>
>>
>> --
>> Coly Li
