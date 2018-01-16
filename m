From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 02/13] bcache: properly set task state in
 bch_writeback_thread()
Date: Tue, 16 Jan 2018 10:02:27 +0100
Message-ID: <9d834b70-f35b-4ca3-017c-d923900c98a0@suse.de>
References: <20180114144236.28213-1-colyli@suse.de>
 <20180114144236.28213-3-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbeAPJC3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Jan 2018 04:02:29 -0500
In-Reply-To: <20180114144236.28213-3-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>

On 01/14/2018 03:42 PM, Coly Li wrote:
> Kernel thread routine bch_writeback_thread() has the following code block,
> 
> 447         down_write(&dc->writeback_lock);
> 448~450     if (check conditions) {
> 451                 up_write(&dc->writeback_lock);
> 452                 set_current_state(TASK_INTERRUPTIBLE);
> 453
> 454                 if (kthread_should_stop())
> 455                         return 0;
> 456
> 457                 schedule();
> 458                 continue;
> 459         }
> 
> If condition check is true, its task state is set to TASK_INTERRUPTIBLE
> and call schedule() to wait for others to wake up it.
> 
> There are 2 issues in current code,
> 1, Task state is set to TASK_INTERRUPTIBLE after the condition checks, if
>    another process changes the condition and call wake_up_process(dc->
>    writeback_thread), then at line 452 task state is set back to
>    TASK_INTERRUPTIBLE, the writeback kernel thread will lose a chance to be
>    waken up.
> 2, At line 454 if kthread_should_stop() is true, writeback kernel thread
>    will return to kernel/kthread.c:kthread() with TASK_INTERRUPTIBLE and
>    call do_exit(). It is not good to enter do_exit() with task state
>    TASK_INTERRUPTIBLE, in following code path might_sleep() is called and a
>    warning message is reported by __might_sleep(): "WARNING: do not call
>    blocking ops when !TASK_RUNNING; state=1 set at [xxxx]".
> 
> For the first issue, task state should be set before condition checks.
> Ineed because dc->writeback_lock is required when modifying all the
> conditions, calling set_current_state() inside code block where dc->
> writeback_lock is hold is safe. But this is quite implicit, so I still move
> set_current_state() before all the condition checks.
> 
> For the second issue, frankley speaking it does not hurt when kernel thread
> exits with TASK_INTERRUPTIBLE state, but this warning message scares users,
> makes them feel there might be something risky with bcache and hurt their
> data.  Setting task state to TASK_RUNNING before returning fixes this
> problem.
> 
> Changelog:
> v2: fix the race issue in v1 patch.
> v1: initial buggy fix.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Michael Lyle <mlyle@lyle.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Junhui Tang <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/writeback.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
