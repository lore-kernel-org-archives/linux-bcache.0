From: tang.junhui@zte.com.cn
Subject: Re: Re: [PATCH v1 05/10] bcache: stop dc->writeback_rate_update if cache set is stopping
Date: Thu, 4 Jan 2018 02:54:53 +0800
Message-ID: <1515005693-7113-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:50348 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751625AbeADI1s (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Jan 2018 03:27:48 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hi Coly,

>It is about an implicit and interesting ordering, a simple patch with a
>lot detail behind. Let me explain why it's safe,
>
>- cancel_delayed_work_sync() is called in bcache_device_detach() when
>dc->count is 0. But cancel_delayed_work_sync() is called before
>closure_put(&d->c->caching) in bcache_device_detach().
>
>- After closure_put(&d->c->caching) called in bcache_device_detach(),
>refcount of c->caching becomes 0, and cache_set_flush() set in
>__cache_set_unregister() continue to execute.
>
>- See continue_at() and closure_put_after_sub(), after c->caching
>refoucnt reaches 0, and c->caching->fn gets called, closure_put(parent)
>will be called. Here the parent of c->caching is c->cl, so refcount of
>c->cl will reach 0, and closure_put_after_sub() will be called again for
>c->cl and call its cl->fn which is cache_set_free(). It is set in
>bch_cache_set_alloc().
>
>- So before closure_put(&d->c->caching) is called in
>bcache_device_detach(), cache_set_flush() in __cache_set_unregister()
>won't be executed and memory of cache_set won't be freed.
>
>Now back to delayed worker routine update_writeback_rate(), I check
>c->flags inside it, in this moment cancel_delayed_work_sync() is still
>waiting for update_writeback_rate() to exit, so refcount of c->caching
>is still hold and cache set memory will only be freed after
>cancel_delayed_work_sync() returns and refcount of c->caching dropped.
>
>And in cached_dev_free(), bcache_device_free() and
>kobject_put(&dc->disk.kobj) are called after cancel_delayed_work_sync()
>returns. Therefore when update_writeback_rate() is executing and
>accessing c->flgas inside, memory of cache_set, bcache_device and
>cached_dev are all there.

OK, I got your mean. It is safe run work update_writeback_rate when 
cancel_delayed_work_sync() is called, but it is not safe to re-arm itself
to workqueue again.

So, the first judgement  "if (test_bit(CACHE_SET_STOPPING, &c->flags))"
is not very nessary, we only need the second one to prevent the work 
from re-arming itself to workqueue.


Thanks,
Tang Junhui
