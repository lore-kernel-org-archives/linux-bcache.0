From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v1 05/10] bcache: stop dc->writeback_rate_update if cache set is stopping
Date: Wed, 3 Jan 2018 21:15:59 +0800
Message-ID: <1514985359-3210-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:49252 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752005AbeADCtD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Jan 2018 21:49:03 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Coly,

Thanks for this serials.

>struct delayed_work writeback_rate_update in struct cache_dev is a delayed
>worker to call function update_writeback_rate() in period (the interval is
>defined by dc->writeback_rate_update_seconds).
>
>When a metadate I/O error happens on cache device, bcache error handling
>routine bch_cache_set_error() will call bch_cache_set_unregister() to
>retire whole cache set. On the unregister code path, cached_dev_free()
>calls cancel_delayed_work_sync(&dc->writeback_rate_update) to stop this
>delayed work.
>
>dc->writeback_rate_update is a special delayed work from others in bcache.
>In its routine update_writeback_rate(), this delayed work is re-armed
>after a piece of time. That means when cancel_delayed_work_sync() returns,
>this delayed work can still be executed after several seconds defined by
>dc->writeback_rate_update_seconds.
>
>The problem is, after cancel_delayed_work_sync() returns, the cache set
>unregister code path will eventually release memory of struct cache set.
>Then the delayed work is scheduled to run, and inside its routine
>update_writeback_rate() that already released cache set NULL pointer will
>be accessed. Now a NULL pointer deference panic is triggered.
>
As I known that, after calling cancel_delayed_work_sync(), if the work queue
is running, cancel_delayed_work_sync() would return only AFTER the work queue
runs over, else if the work queue does not run yet, cancel_delayed_work_sync()
will cancel the work queue imediately, so I think it is safe in 
update_writeback_rate() to access the cache set resource. Point me out if I
am wrong.

>In order to avoid the above problem, this patch checks cache set flags in
>delayed work routine update_writeback_rate(). If flag CACHE_SET_STOPPING
>is set, this routine will quit without re-arm the delayed work. Then the
>NULL pointer deference panic won't happen after cache set is released.
>
>Signed-off-by: Coly Li <colyli@suse.de>
>---
> drivers/md/bcache/writeback.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>
>diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>index 0789a9e18337..745d9b2a326f 100644
>--- a/drivers/md/bcache/writeback.c
>+++ b/drivers/md/bcache/writeback.c
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
>     schedule_delayed_work(&dc->writeback_rate_update,
>                   dc->writeback_rate_update_seconds * HZ);
> }
>-- 
>2.15.1                                                             

Thanks,
Tang Junhui
