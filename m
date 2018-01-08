From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v3] bcache: fix writeback target calc on large devices
Date: Mon, 8 Jan 2018 10:46:27 +0800
Message-ID: <1515379587-21540-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

>On Fri, Jan 5, 2018 at 11:29 PM,  <tang.junhui@zte.com.cn> wrote:
>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>
>> Hello Mike,
>>
>> I thought twice, and feel this patch is a little complex and still not very accurate for
>> small backend devices. I think we can resolve it like this:
>>
>>      uint64_t cache_dirty_target =
>>          div_u64(cache_sectors * dc->writeback_percent, 100);
>>
>> -    int64_t target = div64_u64(cache_dirty_target * bdev_sectors(dc->bdev),
>> -                   c->cached_dev_sectors);
>> +    int64_t target = div64_u64(cache_dirty_target,
>> +                    div64_u64(c->cached_dev_sectors, bdev_sectors(dc->bdev)));
>>
>> c->cached_dev_sectors is always bigger than bdev_sectors(dc->bdev), so
>> div64_u64(c->cached_dev_sectors, bdev_sectors(dc->bdev) would be never smaller than 1,
>> and this expression has no multiplication operation, so we do not need to worry
>> about overflows.
>
>I thought about this, but as I think you've noticed below it's very
>inaccurate for typical cases.  e.g. if you have 1TB and 750GB backing
>volumes, you get (1750/1000) vs (1750/750) and the 750GB is allowed
>half as much dirty space, and you end up storing 150% of the desired
>info.  Other rounding approaches aren't good, either.
>
>> we also can multiply a value(2^10) to avoid loss of accuracy in division like bellow:
>> (it would support all device smaller than 2^54 BYTE).
>> +    int64_t target = div64_u64(cache_dirty_target<<10,
>> +                    div64_u64(c->cached_dev_sectors<<10, bdev_sectors(dc->bdev)));
>>
>> How do you think about?
>
>This is a bit better.  It trades a per-backing-volume limit of 1PB in
>my code for a total of 9PB cached limit.
>
>Really all of these approaches are "wrong" because they don't allow
>the total amount of dirty to be used if you have quiet volumes and
>should be replaced with something better.  I am just trying to get
>something temporary in to 4.16 because this is a real bug that is
>preventing real users from using bcache.  I'm pretty sure the new code
>works in all the cases the old code failed.
>

OK, please replace 16384 with macro, and replease 16384 * bdev_sectors(dc->bdev)
with bit shift operation, eg: bdev_sectors(dc->bdev)<<MACRO.

Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

>Simultaneously having a 1GB and 16TB cached volume is a bit of a silly
>case, and what the code does in this silly case isn't completely
>stupid, so...
>
>We're running out of time to get a fix into the package for 4.16, and
>I've tested the current version a fair bit.
>
>Mike
>--
>To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Tang Junhui
