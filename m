From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sat, 30 Sep 2017 16:03:55 +0800
Message-ID: <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li>
 <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li>
 <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/9/30 下午3:13, Michael Lyle wrote:
> Coly--
> 
> 
> On Fri, Sep 29, 2017 at 11:58 PM, Coly Li <i@coly.li> wrote:
>> On 2017/9/30 上午11:17, Michael Lyle wrote:
>> [snip]
>>
>> If writeback_rate is not minimum value, it means there are front end
>> write requests existing.
> 
> This is wrong.  Else we'd never make it back to the target.
> 

Of cause we can :-) When dirty data is far beyond dirty percent,
writeback rate is quite high, in that case dc->last_read takes effect.
But this is not the situation which your patch handles better.


>> In this case, backend writeback I/O should nice
>> I/O throughput to front end I/O. Otherwise, application will observe
>> increased I/O latency, especially when dirty percentage is not very
>> high. For enterprise workload, this change hurts performance.
> 
> No, utilizing less of disk throughput for a given writeback rate
> improves workload latency.  :P  The maximum that will be aggregated in
> this way is constrained more strongly than the old code...
> 

Could you please show exact latency comparison data ? Imagine that by
code is too hard to me ...


>> An desired behavior for low latency enterprise workload is, when dirty
>> percentage is low, once there is front end I/O, backend writeback should
>> be at minimum rate. This patch will introduce unstable and unpredictable
>> I/O latency.
> 
> Nope.  It lowers disk utilization overall, and the amount of disk
> bandwidth any individual request chunk can use is explicitly bounded
> (unlike before, where it was not).
> 

It will be great if we can see performance data here.

>> Unless there is performance bottleneck of writeback seeking, at least
>> enterprise users will focus more on front end I/O latency ....
> 
> The less writeback seeks the disk, the more the real workload can seek
> this disk!  And if you're at high writeback rates, the vast majority
> of the time the disk is seeking!
> 

You are right. But when writeback rate is high, dc->last_read can solve
the seeking problem as your patch does.


>> This method is helpful only when writeback I/Os is not issued
>> continuously, other wise if they are issued within slice_idle,
>> underlying elevator will reorder or merge the I/Os in larger request.
>> We have a subsystem in place to rate-limit and make sure that they are
> not issued continuously!  If you want to preserve good latency for
> userspace, you want to keep the system in the regime where that
> control system is effective!
> 


Do you mean write I/O cannot be issued within slice_idle, or they are
issued within slice_idle but underlying elevator does not merge the
continuous request ?


>> Hmm, if you move the dirty IO from btree into dirty_io list, then
>> perform I/O, there is risk that once machine is power down during
>> writeback there might be dirty data lost. If you continuously issue
>> dirty I/O and remove them from btree at same time, that means you will
>> introduce more latency to front end I/O...
> 
> No... this doesn't change the consistency properties.  I am just
> saying-- if we have (up to 5 contiguous things that we're going to
> write back), wait till they're all read; plug; dispatch writes ;
> unplug.
> 

I meant the dirty_io list in your future patch, not current 5 bios
patch. Hmm, maybe you can ignore my noise here, I just jumped off the topic.


>> And plug list will be unplugged automatically as default, when context
>> switching happens. If you will performance read I/Os to the btrees, a
>> context switch is probably to happen, then you won't keep a large bio
>> lists ...
> 
> Thankfully we'll have 5 things to fire immediately after each other,
> so we don't need to worry about automatic unplug.
> 

Forgive me, again I meant dirty_io list stuffs, not this patch...


>> IMHO when writeback rate is low, especially when backing hard disk is
>> not bottleneck, group continuous I/Os in bcache code does not help too
>> much for writeback performance. The only benefit is less I/O issued when
>> front end I/O is low or idle, but not most of users care about it,
>> especially enterprise users.
> 
> I disagree!
> 
>>> I believe patch 4 is useful on its own, but I have this and other
>>> pieces of development that depend upon it.
>>
>> Current bcache code works well in most of writeback loads, I just worry
>> that implementing an elevator in bcache writeback logic is a big
>> investment with a little return.
> 
> Bcache already implements a (one-way) elevator!  Bcache invests
> **significant effort** already to do writebacks in LBA order (to
> effectively short-stroke the disk), but because of different arrival
> times of the read request they can end up reordered.  This is bad.
> This is a bug.

Could you please show exact benchmark result ? Then it will be easier to
change my mind. I only know if writeback I/O is not continuously issued
within slice_idle, mostly it is because read dirty delayed in line 238
of read_dirty(),
235	if (KEY_START(&w->key) != dc->last_read ||
236         jiffies_to_msecs(delay) > 50)
237		while (!kthread_should_stop() && delay)
238			delay = schedule_timeout_interruptible(delay);

If writeback rate is high and writeback I/O is continuous, read I/O will
be issued without delay. Then writeback I/O will be issued by
write_dirty() in very short time.

Therefore without a real performance comparison, I cannot image why
adjacent write requests cannot merged in elevator... Unless I do the
test myself.


-- 
Coly Li
