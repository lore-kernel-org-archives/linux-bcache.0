From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v1 01/10] bcache: exit bch_writeback_thread() with proper
 task state
Date: Mon, 8 Jan 2018 21:50:21 +0800
Message-ID: <38691a4b-afaf-963a-ac40-2a8a1bee3995@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-2-colyli@suse.de>
 <c4183dae-0381-f510-1929-410b9a7a2b9d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35383 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757447AbeAHNue (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jan 2018 08:50:34 -0500
In-Reply-To: <c4183dae-0381-f510-1929-410b9a7a2b9d@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn

On 08/01/2018 3:09 PM, Hannes Reinecke wrote:
> On 01/03/2018 03:03 PM, Coly Li wrote:
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
>> ---
>>  drivers/md/bcache/writeback.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index 56a37884ca8b..a57149803df6 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -449,11 +449,11 @@ static int bch_writeback_thread(void *arg)
>>  		    (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
>>  		     !dc->writeback_running)) {
>>  			up_write(&dc->writeback_lock);
>> -			set_current_state(TASK_INTERRUPTIBLE);
>>  
>>  			if (kthread_should_stop())
>>  				return 0;
>>  
>> +			set_current_state(TASK_INTERRUPTIBLE);
>>  			schedule();
>>  			continue;
>>  		}
>>
> Actually, TASK_INTERRUPTIBLE is okay for kthread_should_stop(); you just
> need to set it to 'TASK_RUNNING' before calling 'return 0'.
> 
> So I think a fix like
> 
> set_current_state(TASK_INTERRUPTIBLE);
> 
> if (kthread_should_stop()) {
>     set_current_state(TASK_RUNNING);
>     return 0;
> }
> 
> schedule();
> 
> would be better.

Hi Hannes,

Yes, this is same as v2 patch does. Thanks.

Coly Li
