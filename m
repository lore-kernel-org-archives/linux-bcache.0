From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v1 01/10] bcache: exit bch_writeback_thread() with proper
 task state
Date: Sat, 6 Jan 2018 01:05:11 +0800
Message-ID: <1fcdcfe6-9fa0-a853-6b86-6049953815f6@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-2-colyli@suse.de>
 <5cd9f028-366a-ba94-3bdf-0aefd5028c21@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39549 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752108AbeAERFW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Jan 2018 12:05:22 -0500
In-Reply-To: <5cd9f028-366a-ba94-3bdf-0aefd5028c21@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, tang.junhui@zte.com.cn

On 04/01/2018 1:08 AM, Michael Lyle wrote:
> On 01/03/2018 06:03 AM, Coly Li wrote:
>> Kernel thread routine bch_writeback_thread() has the following code block,
>>
>> 452                         set_current_state(TASK_INTERRUPTIBLE);
>> 453
>> 454                         if (kthread_should_stop())
>> 455                                 return 0;
>> 456
>> 457                         schedule();
>> 458                         continue;
>>
>> At line 452, its status is set to TASK_INTERRUPTIBLE, and at line 454 if
>> kthread_should_stop() is true, a "return 0" at line 455 will to function
>> kernel/kthread.c:kthread() and call do_exit().
>>
>> It is not good to enter do_exit() with task state TASK_INTERRUPTIBLE, in
>> following code path might_sleep() is called and a warning message is
>> reported by __might_sleep(): "WARNING: do not call blocking ops when
>> !TASK_RUNNING; state=1 set at [xxxx]".
>>
>> Indeed it does not hurt when kernel thread exits with TASK_INTERRUPTIBLE
>> state, but this warning message scares users, makes them feel there might
>> be something risky with bcache and hurt their data.
>>
>> In this patch, TASK_INTERRUPTIBLE is set after kthread_should_stop(),
>> so writeback kernel thread can exist and enter do_exit() with
>> TASK_RUNNING state. Warning message from might_sleep() is removed.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>

Hi Mike,

I feel uncomfortable with this patch, can you help me to double check ?

In my patch, I set task state to TASK_INTERRUPTIBLE after checking the
following conditions,
469	if (!atomic_read(&dc->has_dirty) ||
470	    (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
471	     !dc->writeback_running)) {

And set_current_state(TASK_INTERRUPTIBLE) is after
up_write(&dc->writeback_lock), there should be a potential race window
between up_write() and set_current_state() in my patch. If
wake_up_process(dc->writeback_thread) is called in this window, and then
current state is set to TASK_INTERRUPTIBLE again, writeback thread will
lose a chance to be waken up.

It seems I need to call set_current_state(TASK_INTERRUPTIBLE) before
up_write(&dc->writeback_lock), then dc->writeback_lock will protect and
avoid the race. Or move set_current_state(TASK_INTERRUPTIBLE) to the
location before the condition checks in line 469-471.

This race window is very small but I believe it exists, I will fix it in
v2 patch set.

Thanks.

Coly Li
