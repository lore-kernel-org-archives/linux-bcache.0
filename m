From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v1 02/10] bcache: set task properly in allocator_wait()
Date: Sat, 6 Jan 2018 01:11:33 +0800
Message-ID: <ab84344f-8471-f0da-90e5-4defc4c2a6b3@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-3-colyli@suse.de>
 <1e2bc858-d94b-879d-fe27-a35a65109bf3@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40315 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752577AbeAERLo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Jan 2018 12:11:44 -0500
In-Reply-To: <1e2bc858-d94b-879d-fe27-a35a65109bf3@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, tang.junhui@zte.com.cn

On 04/01/2018 1:09 AM, Michael Lyle wrote:
> On 01/03/2018 06:03 AM, Coly Li wrote:
>> Kernel thread routine bch_allocator_thread() references macro
>> allocator_wait() to wait for a condition or quit to do_exit()
>> when kthread_should_stop() is true.
>>
>> Macro allocator_wait() has 2 issues in setting task state, let's
>> see its code piece,
>>
>> 284         while (1) {                                                   \
>> 285                 set_current_state(TASK_INTERRUPTIBLE);                \
>> 286                 if (cond)                                             \
>> 287                         break;                                        \
>> 288                                                                       \
>> 289                 mutex_unlock(&(ca)->set->bucket_lock);                \
>> 290                 if (kthread_should_stop())                            \
>> 291                         return 0;                                     \
>> 292                                                                       \
>> 293                 schedule();                                           \
>> 294                 mutex_lock(&(ca)->set->bucket_lock);                  \
>> 295         }                                                             \
>> 296         __set_current_state(TASK_RUNNING);                            \
>>
>> 1) At line 285, task state is set to TASK_INTERRUPTIBLE, if at line 290
>> kthread_should_stop() is true, the kernel thread will terminate and return
>> to kernel/kthread.s:kthread(), then calls do_exit() with TASK_INTERRUPTIBLE
>> state. This is not a suggested behavior and a warning message will be
>> reported by might_sleep() in do_exit() code path: "WARNING: do not call
>> blocking ops when !TASK_RUNNING; state=1 set at [xxxx]".
>>
>> 2) Because task state is set to TASK_INTERRUPTIBLE at line 285, when break
>> while-loop the task state has to be set back to TASK_RUNNING at line 296.
>> Indeed it is unncessary, if task state is set to TASK_INTERRUPTIBLE before
>> calling schedule() at line 293, we don't need to set the state back to
>> TASK_RUNNING at line 296 anymore. The reason is, allocator kthread is only
>> woken up by wake_up_process(), this routine makes sure the task state of
>> allocator kthread will be TASK_RUNNING after it returns from schedule() at
>> line 294 (see kernel/sched/core.c:try_to_wake_up() for more detailed
>> information).
>>
>> This patch fixes the above 2 issues by,
>> 1) Setting TASK_INTERRUPTIBLE state just before calling schedule().
>> 2) Then setting TASK_RUNNING at line 296 is unnecessary, remove it.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>

Hi Mike,

I also feel I made mistake here. set_current_state(TASK_INTERRUPTIBLE)
must be called before the condition check, other wise there will be a
race window on task state setting. A correct fix should be setting task
state to TASK_RUNNING before calling 'return 0', or before calling
mutex_unlock(&(ca)->set->bucket_lock).

When I review the new closure_sync() patches, I feel I make mistake
here. It will be fixed in v2 patch set.

Thanks.

Coly Li
