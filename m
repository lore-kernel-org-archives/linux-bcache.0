From: Wu Bo <wubo40@huawei.com>
Subject: Re: [PATCH] bcache:cleanup resources when bcache device init failed
Date: Fri, 10 Apr 2020 15:04:07 +0800
Message-ID: <320c4ebc-f195-3076-5ce7-68b513055442@huawei.com>
References: <80a757d9-011b-6a58-f6ec-744f02153c74@huawei.com>
 <9d236938-9071-66cc-0874-7afe65651764@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:12637 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgDJHES (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Apr 2020 03:04:18 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8983991F229B0CB14C26
        for <linux-bcache@vger.kernel.org>; Fri, 10 Apr 2020 15:04:15 +0800 (CST)
In-Reply-To: <9d236938-9071-66cc-0874-7afe65651764@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, liuzhiqiang26@huawei.com, linfeilong@huawei.com

On 2020/4/9 23:13, Coly Li wrote:
> On 2020/4/8 6:02 下午, Wu Bo wrote:
>> From: Wu Bo <wubo40@huawei.com>
>>
>> Cleanup resources when device init failed on bcache_device_init function
>>
>> Signed-off-by: Wu Bo <wubo40@huawei.com>
> 
> Hi Wu Bo,
> 
> Do you test this patch ? I am not sure whether it may work properly,
> because all the resources will be released in bcache_device_stop() from
> register_bdev(). Your patch makes them being released twice.
> 
> If bcache_device_init() fails, cached_dev_init() will fail, then the
> caller register_bdev() will fail and jump to err label to call
> bcache_device_stop().
> 
> If this is a cached device, in bcache_device_stop(),
> closure_queue(&d->cl) will call the callback routine cached_dev_flush().
> Then in cached_dev_flush() the continue_at() callback cached_dev_free()
> will be called. In cached_dev_free() you will see these resources are
> freed properly.
> 
> 
> Coly Li
> 
Hi Coly Li,

Thank you for your detailed reply. I am sorry for my lack of rigor. 
Please ignore this patch.

Regards,
Wu Bo

>> ---
>>   drivers/md/bcache/super.c | 27 +++++++++++++++++++--------
>>   1 file changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index d98354f..b4e3d0e 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -823,6 +823,7 @@ static int bcache_device_init(struct bcache_device
>> *d, unsigned int block_size,
>>                                           SIZE_MAX / sizeof(atomic_t));
>>          size_t n;
>>          int idx;
>> +       int rtn = -ENOMEM;
>>
>>          if (!d->stripe_size)
>>                  d->stripe_size = 1 << 31;
>> @@ -843,20 +844,22 @@ static int bcache_device_init(struct bcache_device
>> *d, unsigned int block_size,
>>          n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
>>          d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
>>          if (!d->full_dirty_stripes)
>> -               return -ENOMEM;
>> +               goto out_free_sectors_dirty;
>>
>>          idx = ida_simple_get(&bcache_device_idx, 0,
>>                                  BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
>> -       if (idx < 0)
>> -               return idx;
>> +       if (idx < 0) {
>> +               rtn = idx;
>> +               goto out_free_dirty_stripes;
>> +       }
>>
>>          if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
>>                          BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>> -               goto err;
>> +               goto out_free_idx;
>>
>>          d->disk = alloc_disk(BCACHE_MINORS);
>>          if (!d->disk)
>> -               goto err;
>> +               goto out_bioset_exit;
>>
>>          set_capacity(d->disk, sectors);
>>          snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
>> @@ -868,7 +871,7 @@ static int bcache_device_init(struct bcache_device
>> *d, unsigned int block_size,
>>
>>          q = blk_alloc_queue(make_request_fn, NUMA_NO_NODE);
>>          if (!q)
>> -               return -ENOMEM;
>> +               goto out_free_disk;
>>
>>          d->disk->queue                  = q;
>>          q->queuedata                    = d;
>> @@ -890,9 +893,17 @@ static int bcache_device_init(struct bcache_device
>> *d, unsigned int block_size,
>>
>>          return 0;
>>
>> -err:
>> +out_free_disk:
>> +       put_disk(d->disk);
>> +out_bioset_exit:
>> +       bioset_exit(&d->bio_split);
>> +out_free_idx:
>>          ida_simple_remove(&bcache_device_idx, idx);
>> -       return -ENOMEM;
>> +out_free_dirty_stripes:
>> +       kvfree(d->full_dirty_stripes);
>> +out_free_sectors_dirty:
>> +       kvfree(d->stripe_sectors_dirty);
>> +       return rtn;
>>
>>   }
> 
> .
> 
