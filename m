From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v1 05/10] bcache: stop dc->writeback_rate_update if cache
 set is stopping
Date: Thu, 4 Jan 2018 11:32:47 +0800
Message-ID: <cb78a63a-a064-e13c-849e-2c6712fd2560@suse.de>
References: <1514985359-3210-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1514985359-3210-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 03/01/2018 9:15 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Hello Coly,
> 
> Thanks for this serials.
> 
>> struct delayed_work writeback_rate_update in struct cache_dev is a delayed
>> worker to call function update_writeback_rate() in period (the interval is
>> defined by dc->writeback_rate_update_seconds).
>>
>> When a metadate I/O error happens on cache device, bcache error handling
>> routine bch_cache_set_error() will call bch_cache_set_unregister() to
>> retire whole cache set. On the unregister code path, cached_dev_free()
>> calls cancel_delayed_work_sync(&dc->writeback_rate_update) to stop this
>> delayed work.
>>
>> dc->writeback_rate_update is a special delayed work from others in bcache.
>> In its routine update_writeback_rate(), this delayed work is re-armed
>> after a piece of time. That means when cancel_delayed_work_sync() returns,
>> this delayed work can still be executed after several seconds defined by
>> dc->writeback_rate_update_seconds.
>>
>> The problem is, after cancel_delayed_work_sync() returns, the cache set
>> unregister code path will eventually release memory of struct cache set.
>> Then the delayed work is scheduled to run, and inside its routine
>> update_writeback_rate() that already released cache set NULL pointer will
>> be accessed. Now a NULL pointer deference panic is triggered.
>>
> As I known that, after calling cancel_delayed_work_sync(), if the work queue
> is running, cancel_delayed_work_sync() would return only AFTER the work queue
> runs over, else if the work queue does not run yet, cancel_delayed_work_sync()
> will cancel the work queue imediately, so I think it is safe in 
> update_writeback_rate() to access the cache set resource. Point me out if I
> am wrong.
> 

Hi Junhui,

dc->writeback_rate_update is a special delayed worker, it re-arms itself
to run after several seconds by,
>>     schedule_delayed_work(&dc->writeback_rate_update,
>>                   dc->writeback_rate_update_seconds * HZ);

I check the workqueue code, it seems cancel_delayed_work_sync() does not
prevent a delayed work to re-arm itself inside worker routine. And in my
test, around 5 seconds after cancel_delayed_work_sync() called, a NULL
pointer
difference oops happens. Cache set memory is freed within 2 seconds
after __cache_set_unregister() called, so inside
__update_writeback_rate() struct cache_set is referenced and causes the
NULL pointer deference bug.

There are several delayed work in bcache code, but only
dc->writeback_rate_update is special to re-arm itself.

Coly Li

>> In order to avoid the above problem, this patch checks cache set flags in
>> delayed work routine update_writeback_rate(). If flag CACHE_SET_STOPPING
>> is set, this routine will quit without re-arm the delayed work. Then the
>> NULL pointer deference panic won't happen after cache set is released.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>> drivers/md/bcache/writeback.c | 9 +++++++++
>> 1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index 0789a9e18337..745d9b2a326f 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -91,6 +91,11 @@ static void update_writeback_rate(struct work_struct *work)
>>     struct cached_dev *dc = container_of(to_delayed_work(work),
>>                          struct cached_dev,
>>                          writeback_rate_update);
>> +    struct cache_set *c = dc->disk.c;
>> +
>> +    /* quit directly if cache set is stopping */
>> +    if (test_bit(CACHE_SET_STOPPING, &c->flags))
>> +        return;
>>
>>     down_read(&dc->writeback_lock);
>>
>> @@ -100,6 +105,10 @@ static void update_writeback_rate(struct work_struct *work)
>>
>>     up_read(&dc->writeback_lock);
>>
>> +    /* do not schedule delayed work if cache set is stopping */
>> +    if (test_bit(CACHE_SET_STOPPING, &c->flags))
>> +        return;
>> +
>>     schedule_delayed_work(&dc->writeback_rate_update,
>>                   dc->writeback_rate_update_seconds * HZ);
>> }
>> -- 
>> 2.15.1                                                             
> 
> Thanks,
> Tang Junhui
> 
