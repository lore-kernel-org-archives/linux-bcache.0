From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v1 05/10] bcache: stop dc->writeback_rate_update if cache
 set is stopping
Date: Thu, 4 Jan 2018 16:06:47 +0800
Message-ID: <b1447aad-0912-5262-f72e-d7ae6d0508cd@suse.de>
References: <1514998071-5562-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1514998071-5562-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 04/01/2018 12:47 AM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Hello Coly,
> 
>> dc->writeback_rate_update is a special delayed worker, it re-arms itself
>> to run after several seconds by,
>>>>     schedule_delayed_work(&dc->writeback_rate_update,
>>>>                   dc->writeback_rate_update_seconds * HZ);
>>
>> I check the workqueue code, it seems cancel_delayed_work_sync() does not
>> prevent a delayed work to re-arm itself inside worker routine. And in my
>> test, around 5 seconds after cancel_delayed_work_sync() called, a NULL
>> pointer difference oops happens. 
> I think I got how this issue would be occured:
> 1)work writeback_rate_update is running;
> 2)cancel_delayed_work_sync() is called, and waiting for work 
>   writeback_rate_update to run over, and conntinue to release cche set 
>   and cached device resources.
> 3)In the end of step 1, work writeback_rate_update re-armed again, and
>   5s later, the work runs again.
> 
>> Cache set memory is freed within 2 seconds
>> after __cache_set_unregister() called, so inside
>> __update_writeback_rate() struct cache_set is referenced and causes the
>> NULL pointer deference bug.
>>
> So, if it occured like I said above, it is not safty to judged by:
>>    struct cache_set *c = dc->disk.c;
>>    if (test_bit(CACHE_SET_STOPPING, &c->flags))
>>        return;
> because cache_set, even bcache device and cache device are all released.                                             
> Is that right?

Hi Junhui,

It is about an implicit and interesting ordering, a simple patch with a
lot detail behind. Let me explain why it's safe,

- cancel_delayed_work_sync() is called in bcache_device_detach() when
dc->count is 0. But cancel_delayed_work_sync() is called before
closure_put(&d->c->caching) in bcache_device_detach().

- After closure_put(&d->c->caching) called in bcache_device_detach(),
refcount of c->caching becomes 0, and cache_set_flush() set in
__cache_set_unregister() continue to execute.

- See continue_at() and closure_put_after_sub(), after c->caching
refoucnt reaches 0, and c->caching->fn gets called, closure_put(parent)
will be called. Here the parent of c->caching is c->cl, so refcount of
c->cl will reach 0, and closure_put_after_sub() will be called again for
c->cl and call its cl->fn which is cache_set_free(). It is set in
bch_cache_set_alloc().

- So before closure_put(&d->c->caching) is called in
bcache_device_detach(), cache_set_flush() in __cache_set_unregister()
won't be executed and memory of cache_set won't be freed.

Now back to delayed worker routine update_writeback_rate(), I check
c->flags inside it, in this moment cancel_delayed_work_sync() is still
waiting for update_writeback_rate() to exit, so refcount of c->caching
is still hold and cache set memory will only be freed after
cancel_delayed_work_sync() returns and refcount of c->caching dropped.

And in cached_dev_free(), bcache_device_free() and
kobject_put(&dc->disk.kobj) are called after cancel_delayed_work_sync()
returns. Therefore when update_writeback_rate() is executing and
accessing c->flgas inside, memory of cache_set, bcache_device and
cached_dev are all there.

This is why it is safe ;-)

Coly Li
