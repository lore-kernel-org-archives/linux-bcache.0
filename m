From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: set task state correctly in allocator_wait()
Date: Thu, 23 Nov 2017 00:44:22 +0800
Message-ID: <04592484-da30-8708-080c-3f2f896fb7d3@suse.de>
References: <20171122123349.74347-1-colyli@suse.de>
 <0c8e78ab-e369-a40c-ee02-6a6c8f3a5cdd@suse.de>
 <20171122145522.GB2788@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59073 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751546AbdKVQoa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 11:44:30 -0500
In-Reply-To: <20171122145522.GB2788@linutronix.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Hannes Reinecke <hare@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 22/11/2017 10:55 PM, Sebastian Andrzej Siewior wrote:
> On 2017-11-22 15:10:51 [+0100], Hannes Reinecke wrote:
>> On 11/22/2017 01:33 PM, Coly Li wrote:
>>> Kthread function bch_allocator_thread() references allocator_wait(ca, cond)
>>> and when kthread_should_stop() is true, this kthread exits.
>>>
>>> The problem is, if kthread_should_stop() is true, macro allocator_wait()
>>> calls "return 0" with current task state TASK_INTERRUPTIBLE. After function
>>> bch_allocator_thread() returns to do_exit(), there are some blocking
>>> operations are called, then a kenrel warning is popped up by __might_sleep
>>> from kernel/sched/core.c,
>>>   "WARNING: do not call blocking ops when !TASK_RUNNING; state=1 set at [xxxx]"
>>>
>>> If the task is interrupted and preempted out, since its status is
>>> TASK_INTERRUPTIBLE, it means scheduler won't pick it back to run forever,
>>> and the allocator thread may hang in do_exit().
>>>
>>> This patch sets allocator kthread state back to TASK_RUNNING before it
>>> returns to do_exit(), which avoids a potential deadlock.
>>>
>>> Signed-off-by: Coly Li <colyli@suse.de>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>  drivers/md/bcache/alloc.c | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>>> index a27d85232ce1..996ebbabd819 100644
>>> --- a/drivers/md/bcache/alloc.c
>>> +++ b/drivers/md/bcache/alloc.c
>>> @@ -286,9 +286,12 @@ do {									\
>>>  		if (cond)						\
>>>  			break;						\
>>>  									\
>>> +									\
>>>  		mutex_unlock(&(ca)->set->bucket_lock);			\
>>> -		if (kthread_should_stop())				\
>>> +		if (kthread_should_stop()) {				\
>>> +			__set_current_state(TASK_RUNNING);		\
>>>  			return 0;					\
>>> +		}							\
>>>  									\
>>>  		schedule();						\
>>>  		mutex_lock(&(ca)->set->bucket_lock);			\
>>>
>> _Actually_ there is a push to remove all kthreads in the kernel, as they
>> don't play nice together with RT.
> 
> with RT? If RT as in PREEMPT-RT then this is news to me. The reason why
> I removed the per-CPU kthreads in the scsi driver(s) was because it was
> nonsense in regards to CPU-hotplug and workqueue infrastructure is way
> nicer for that. Not to mention that it made the code simpler.
> 
>> So while you're at it, do you think it'd be possible to convert it to a
>> workqueue? Sebastian will be happy to help you here, right, Sebastian?
> If commit 4b9bc86d5a99 ("fcoe: convert to kworker") does not explain I
> can try to assist.

Hi Hannes and Sebastian,

Thanks for the informative input. I see the point why convert from
kthread to per-cpu kworker. Bucket allocation is not a very hot code
path to deserve per-cpu work queue, a per-cached device work queue is
enough, as other places where kworker is used in bcache code. Bcache
used to have circular dependency issue on kworker queue, unless I attach
the kworker to a new and separate workqueue, there might be potential
possibility to introduce a new circular locking on global workqueues.

It is better to make less modification for now, and later after Michael
finishes all locking clean up, we can come to see the kthread to kworker
conversion.

Thanks.

Coly Li
