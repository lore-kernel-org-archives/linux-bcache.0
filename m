From: Shile Zhang <shile.zhang@linux.alibaba.com>
Subject: Re: [PATCH] bcache: add cond_resched() in __bch_cache_cmp()
Date: Thu, 7 Mar 2019 23:06:47 +0800
Message-ID: <3640cd7f-f32a-1509-dbef-6000b6e14e75@linux.alibaba.com>
References: <1551935728-243664-1-git-send-email-shile.zhang@linux.alibaba.com>
 <24916a71-39ff-7324-ad12-9d79cc68d0da@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <24916a71-39ff-7324-ad12-9d79cc68d0da@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org


On 2019/3/7 18:34, Coly Li wrote:
> On 2019/3/7 1:15 下午, shile.zhang@linux.alibaba.com wrote:
>> From: Shile Zhang <shile.zhang@linux.alibaba.com>
>>
>> Read /sys/fs/bcache/<uuid>/cacheN/priority_stats can take very long
>> time with huge cache after long run.
>>
>> Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
> Hi Shile,
>
> Do you test your change ? It will be helpful with more performance data
> (what problem that you improved).

In case of 960GB SSD cache device, once read of the 'priority_stats' 
costs about 600ms in our test environment.

The perf tool shown that near 50% CPU time consumed by 'sort()', this 
means once sort will hold the CPU near 300ms.

In our case, the statistics collector reads the 'priority_stats' 
periodically, it will trigger the schedule latency jitters of the

task which shared same CPU core.

>
> Thanks.
>
> Coly Li
>
>> ---
>>   drivers/md/bcache/sysfs.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
>> index 557a8a3..028fea1 100644
>> --- a/drivers/md/bcache/sysfs.c
>> +++ b/drivers/md/bcache/sysfs.c
>> @@ -897,6 +897,7 @@ static void bch_cache_set_internal_release(struct kobject *k)
>>   
>>   static int __bch_cache_cmp(const void *l, const void *r)
>>   {
>> +	cond_resched();
>>   	return *((uint16_t *)r) - *((uint16_t *)l);
>>   }
>>   
>>
>
