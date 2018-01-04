From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v1 05/10] bcache: stop dc->writeback_rate_update if cache set is stopping
Date: Thu, 4 Jan 2018 20:41:47 +0800
Message-ID: <1515069707-18825-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Coly,

>When cache set is stopping, calculating writeback rate is wast of time.
>This is the purpose of the first checking, to avoid unnecessary delay
>from bcache_flash_devs_sectors_dirty() inside __update_writeback_rate().

I thought twice, and found there is still a race.

work update_writeback_rate is runing:                                                                                
>@@ -91,6 +91,11 @@ static void update_writeback_rate(struct work_struct *work)
>     struct cached_dev *dc = container_of(to_delayed_work(work),
>                          struct cached_dev,
>                          writeback_rate_update);
>+    struct cache_set *c = dc->disk.c;
>+
>+    /* quit directly if cache set is stopping */
>+    if (test_bit(CACHE_SET_STOPPING, &c->flags))
>+        return;
> 
>     down_read(&dc->writeback_lock);
> 
>@@ -100,6 +105,10 @@ static void update_writeback_rate(struct work_struct *work)
> 
>     up_read(&dc->writeback_lock);
> 
>+    /* do not schedule delayed work if cache set is stopping */
>+    if (test_bit(CACHE_SET_STOPPING, &c->flags))
>+        return;
>+

and if cancel_delayed_wsrksync() runs at this moment, the code can not prevent the
work re-arming itself to workqueue. So maybe we need a locker to protect it.    

>     schedule_delayed_work(&dc->writeback_rate_update,
>                   dc->writeback_rate_update_seconds * HZ);
> }

Thanks,
Tang Junhui
