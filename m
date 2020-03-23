From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 6/7] bcache: optimize barrier usage for Rmw atomic bitops
Date: Mon, 23 Mar 2020 16:45:29 +0800
Message-ID: <03f903b7-7d39-22e8-32ed-a1d7b6e1d091@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-7-colyli@suse.de>
 <990e3e35-bd4f-7347-9027-e7dfa5171085@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <990e3e35-bd4f-7347-9027-e7dfa5171085@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-bcache@vger.kernel.org

On 2020/3/23 3:08 下午, Hannes Reinecke wrote:
> On 3/22/20 7:03 AM, Coly Li wrote:
>> From: Davidlohr Bueso <dave@stgolabs.net>
>>
>> We can avoid the unnecessary barrier on non LL/SC architectures,
>> such as x86. Instead, use the smp_mb__after_atomic().
>>
>> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>   drivers/md/bcache/writeback.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/bcache/writeback.c
>> b/drivers/md/bcache/writeback.c
>> index 6673a37c8bd2..72ba6d015786 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -183,7 +183,7 @@ static void update_writeback_rate(struct
>> work_struct *work)
>>        */
>>       set_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>>       /* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>> -    smp_mb();
>> +    smp_mb__after_atomic();
>>         /*
>>        * CACHE_SET_IO_DISABLE might be set via sysfs interface,
>> @@ -193,7 +193,7 @@ static void update_writeback_rate(struct
>> work_struct *work)
>>           test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
>>           clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>>           /* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>> -        smp_mb();
>> +        smp_mb__after_atomic();
>>           return;
>>       }
>>   @@ -229,7 +229,7 @@ static void update_writeback_rate(struct
>> work_struct *work)
>>        */
>>       clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>>       /* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>> -    smp_mb();
>> +    smp_mb__after_atomic();
>>   }
>>     static unsigned int writeback_delay(struct cached_dev *dc,
>>
> Personally, I'd typically tend to use 'test_and_set_bit', as this not
> only implies a barrier, but also captures any errors; if you just use
> 'set_bit' you'll never know if the bit had been set already.

Copied. There are other locations may optimize with test_and_set_bit(),
for example the cannibalize_lock stuffs. I will post all the
test_and_set_bit()/test_and_clear_bit() optimization as another series
later.

Thanks.

-- 

Coly Li
