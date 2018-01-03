From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v1 01/10] bcache: exit bch_writeback_thread() with proper task state
Date: Thu, 4 Jan 2018 02:30:47 +0800
Message-ID: <1515004247-6831-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

LGTM.

Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

>Kernel thread routine bch_writeback_thread() has the following code block,
>
>452                         set_current_state(TASK_INTERRUPTIBLE);
>453
>454                         if (kthread_should_stop())
>455                                 return 0;
>456
>457                         schedule();
>458                         continue;
>
>At line 452, its status is set to TASK_INTERRUPTIBLE, and at line 454 if
>kthread_should_stop() is true, a "return 0" at line 455 will to function
>kernel/kthread.c:kthread() and call do_exit().
>
>It is not good to enter do_exit() with task state TASK_INTERRUPTIBLE, in
>following code path might_sleep() is called and a warning message is
>reported by __might_sleep(): "WARNING: do not call blocking ops when
>!TASK_RUNNING; state=1 set at [xxxx]".
>
>Indeed it does not hurt when kernel thread exits with TASK_INTERRUPTIBLE
>state, but this warning message scares users, makes them feel there might
>be something risky with bcache and hurt their data.
>
>In this patch, TASK_INTERRUPTIBLE is set after kthread_should_stop(),
>so writeback kernel thread can exist and enter do_exit() with
>TASK_RUNNING state. Warning message from might_sleep() is removed.
>
>Signed-off-by: Coly Li <colyli@suse.de>
>---
> drivers/md/bcache/writeback.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>index 56a37884ca8b..a57149803df6 100644
>--- a/drivers/md/bcache/writeback.c
>+++ b/drivers/md/bcache/writeback.c
>@@ -449,11 +449,11 @@ static int bch_writeback_thread(void *arg)
>             (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
>              !dc->writeback_running)) {
>             up_write(&dc->writeback_lock);
>-            set_current_state(TASK_INTERRUPTIBLE);
> 
>             if (kthread_should_stop())
>                 return 0;
> 
>+            set_current_state(TASK_INTERRUPTIBLE);
>             schedule();
>             continue;
>         }
>-- 
>2.15.1

Thanks,
Tang Junhui
