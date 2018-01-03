From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v1 05/10] bcache: stop dc->writeback_rate_update if cache set is stopping
Date: Thu, 4 Jan 2018 00:47:51 +0800
Message-ID: <1514998071-5562-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Coly,

>dc->writeback_rate_update is a special delayed worker, it re-arms itself
>to run after several seconds by,
>>>     schedule_delayed_work(&dc->writeback_rate_update,
>>>                   dc->writeback_rate_update_seconds * HZ);
>
>I check the workqueue code, it seems cancel_delayed_work_sync() does not
>prevent a delayed work to re-arm itself inside worker routine. And in my
>test, around 5 seconds after cancel_delayed_work_sync() called, a NULL
>pointer difference oops happens. 
I think I got how this issue would be occured:
1)work writeback_rate_update is running;
2)cancel_delayed_work_sync() is called, and waiting for work 
  writeback_rate_update to run over, and conntinue to release cche set 
  and cached device resources.
3)In the end of step 1, work writeback_rate_update re-armed again, and
  5s later, the work runs again.

>Cache set memory is freed within 2 seconds
>after __cache_set_unregister() called, so inside
>__update_writeback_rate() struct cache_set is referenced and causes the
>NULL pointer deference bug.
>
So, if it occured like I said above, it is not safty to judged by:
>    struct cache_set *c = dc->disk.c;
>    if (test_bit(CACHE_SET_STOPPING, &c->flags))
>        return;
because cache_set, even bcache device and cache device are all released.                                             
Is that right?

Thanks,
Tang Junhui
