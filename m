From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v4 05/13] bcache: stop dc->writeback_rate_update properly
Date: Mon, 29 Jan 2018 20:57:29 +0800
Message-ID: <ee3a7638-abe2-232f-e919-c713fc34485b@suse.de>
References: <1517228557-26030-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517228557-26030-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 29/01/2018 8:22 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Hello Coly:
> 
> There are some differences,
> Using variable of atomic_t type can not guarantee the atomicity of transaction.
> for example:
> A thread runs in update_writeback_rate()
> update_writeback_rate(){
> 	....
> +	if (test_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags)) {
> +		schedule_delayed_work(&dc->writeback_rate_update,
>  			      dc->writeback_rate_update_seconds * HZ);
> +	}
> 
> Then another thread executes in cached_dev_detach_finish():
> 	if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
> 		cancel_writeback_rate_update_dwork(dc);
> 
> +
> +	/*
> +	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
> +	 * cancel_delayed_work_sync().
> +	 */
> +	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
> +	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> +	smp_mb();
> 
> Race still exists.
>  

Hi Junhui,

Check super.c:cancel_writeback_rate_update_dwork(),
BCACHE_DEV_RATE_DW_RUNNING is checked there.

You may see in cached_dev_detach_finish() and update_writeback_rate(),
the orders to check BCACHE_DEV_RATE_DW_RUNNING and BCACHE_DEV_WB_RUNNING
are different.

cached_dev_detach_finish()		update_writeback_rate()

test_and_clear_bit			set_bit
BCACHE_DEV_WB_RUNNING			BCACHE_DEV_RATE_DW_RUNNING

(implicit smp_mb())			smp_mb()

test_bit				test_bit
BCACHE_DEV_RATE_DW_RUNNING		BCACHE_DEV_WB_RUNNING

					clear_bit()
					BCACHE_DEV_RATE_DW_RUNNING

					smp_mb()


This two flags are accessed in reversed order in different locations,
there is a smp_mb() between accessing two flags to serialize the access
order.

By the above reserve ordering accessing, it is sure that
- in cached_dev_detach_finish(), before
test_bit(BCACHE_DEV_RATE_DW_RUNNING) bit BCACHE_DEV_WB_RUNNING must be
cleared already.
- in update_writeback_rate(), before test_bit(BCACHE_DEV_WB_RUNNING),
BCACHE_DEV_RATE_DW_RUNNING must be set already.

Therefore in your example, if a thread is testing BCACHE_DEV_WB_RUNNING
in update_writeback_rate(), it means BCACHE_DEV_RATE_DW_RUNNING must be
set already. So in cancel_writeback_rate_update_dwork() another thread
must wait until BCACHE_DEV_RATE_DW_RUNNING is cleared then
cancel_delayed_work_sync() can be called. And in update_writeback_rate()
the bit BCACHE_DEV_RATE_DW_RUNNING is cleared after
schedule_delayed_work() returns, so the race is killed.

A mutex lock indicates an implicit memory barrier, and in your
suggestion up_read(&dc->writeback_lock) is after schedule_delayed_work()
too. This is why I said they are almost same.

Thanks.

Coly Li

>>
>> On 29/01/2018 3:35 PM, tang.junhui@zte.com.cn wrote:
>>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>>
>>> Hello Coly:
>>>
>>> This patch is somewhat difficult for me,
>>> I think we can resolve it in a simple way.
>>>
>>> We can take the schedule_delayed_work() under the protection of 
>>> dc->writeback_lock, and judge if we need re-arm this work to queue.
>>>
>>> static void update_writeback_rate(struct work_struct *work)
>>> {
>>>     struct cached_dev *dc = container_of(to_delayed_work(work),
>>>                          struct cached_dev,
>>>                          writeback_rate_update);
>>>
>>>     down_read(&dc->writeback_lock);
>>>
>>>     if (atomic_read(&dc->has_dirty) &&
>>>         dc->writeback_percent)
>>>         __update_writeback_rate(dc);
>>>
>>> -    up_read(&dc->writeback_lock);
>>> +    if (NEED_RE-AEMING)    
>>>         schedule_delayed_work(&dc->writeback_rate_update,
>>>                   dc->writeback_rate_update_seconds * HZ);
>>> +    up_read(&dc->writeback_lock);
>>> }
>>>
>>> In cached_dev_detach_finish() and cached_dev_free() we can set the no need
>>> flag under the protection of dc->writeback_lock, for example:
>>>
>>> static void cached_dev_detach_finish(struct work_struct *w)
>>> {
>>>     ...
>>> +    down_write(&dc->writeback_lock);
>>> +    SET NO NEED RE-ARM FLAG
>>> +    up_write(&dc->writeback_lock);
>>>     cancel_delayed_work_sync(&dc->writeback_rate_update);
>>> }
>>>
>>> I think this way is more simple and readable.
>>>
>>
>> Hi Junhui,
>>
>> Your suggest is essentially almost same to my patch,
>> - clear BCACHE_DEV_DETACHING bit acts as SET NO NEED RE-ARM FLAG.
>> - cancel_writeback_rate_update_dwork acts as some kind of locking with a
>> timeout.
>>
>> The difference is I don't use dc->writeback_lock, and replace it by
>> BCACHE_DEV_RATE_DW_RUNNING.
>>
>> The reason is my following development. I plan to implement a real-time
>> update stripe_sectors_dirty of bcache device and cache set, then
>> bcache_flash_devs_sectors_dirty() can be very fast and bch_register_lock
>> can be removed here. And then I also plan to remove reference of
>> dc->writeback_lock in update_writeback_rate() because indeed it is
>> unnecessary here (the patch is held by Mike's locking resort work).
>>
>> Since I plan to remove dc->writeback_lock from update_writeback_rate(),
>> I don't want to reference dc->writeback in the delayed work.
>>
>> The basic idea behind your suggestion and this patch, is almost
>> identical. The only difference might be the timeout in
>> cancel_writeback_rate_update_dwork().
>>
>> Thanks.
>>
>> Coly Li
> 
> Thanks.
> Tang Junhui
> 
