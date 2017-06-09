From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: fix issue of writeback rate at minimum 1 block
 per second
Date: Fri, 9 Jun 2017 13:02:30 +0800
Message-ID: <f1c528a9-6d43-a268-b724-3b3d0a6aa502@coly.li>
References: <1496914493-8460-1-git-send-email-tang.junhui@zte.com.cn>
 <96f83b23-bc36-55a6-2a04-236594a0abd2@coly.li>
 <alpine.LRH.2.11.1706090140250.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:44336 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751312AbdFIFCi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Jun 2017 01:02:38 -0400
In-Reply-To: <alpine.LRH.2.11.1706090140250.19359@mail.ewheeler.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: tang.junhui@zte.com.cn, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

On 2017/6/9 上午9:43, Eric Wheeler wrote:
> On Fri, 9 Jun 2017, Coly Li wrote:
> 
>> On 2017/6/8 下午5:34, tang.junhui@zte.com.cn wrote:
>>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>>
>>> When there is not enough data in writeback cache, let the writeback rate
>>> to be 0, and delay 30 seconds in read_dirty().
>>>
>>
>> I feel uncomfortable to the above idea. Is the purpose of this change is
>> to make writeback more efficient with more dirty data ? Or some other
>> reason that you want to make this change?
>>
>> When data writing back to the backing device, most of the writes are
>> random. If the backing device is a hard disk, the write back rate will
>> be very slow. Such a longer delay only makes more data accumulated in
>> writeback cache, does not help the writeback rate indeed.
>>
>> Do you observe performance improvement by this patch ? If yes, I'd like
>> to see the performance number.
> 
> Its not a performance issue, it is a power saving issue.  Laptop users 
> have reported that zero-rate writeback writes 512-bytes every second and 
> never lets the HDD spin down and several users on the list have asked for 
> such a bugfix.

Aha, I see. Thanks for the comments, I misunderstood Junhui Tang.

> 
> It would be nice if ZERO_RATE_DELAY_NS was configurable via sysfs, as some 
> might want a longer delay than 30s.
> 

Yes, nice idea.

> Also, if zero-rate has been hit, why not have a full-writeback of whatever 
> remains so we only use the ZERO_RATE_DELAY_NS when dirty_data==0?  No 
> sense in leaving it slightly dirty if there is only a block or two still 
> remaining.
> 

I agree with this point.

Coly


> 
> --
> Eric Wheeler
> 
> 
> 
>>
>> Thanks.
>>
>> Coly
>>
>>
>>> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
>>> ---
>>>  drivers/md/bcache/util.c      | 17 ++++++++++++-----
>>>  drivers/md/bcache/writeback.c |  2 +-
>>>  2 files changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
>>> index dde6172..cf750df 100644
>>> --- a/drivers/md/bcache/util.c
>>> +++ b/drivers/md/bcache/util.c
>>> @@ -15,6 +15,8 @@
>>>  
>>>  #include "util.h"
>>>  
>>> +#define ZERO_RATE_DELAY_NS	30*NSEC_PER_SEC
>>> +
>>>  #define simple_strtoint(c, end, base)	simple_strtol(c, end, base)
>>>  #define simple_strtouint(c, end, base)	simple_strtoul(c, end, base)
>>>  
>>> @@ -209,13 +211,18 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
>>>  {
>>>  	uint64_t now = local_clock();
>>>  
>>> -	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
>>> +	if (!d->rate) {
>>> +		d->next = now + ZERO_RATE_DELAY_NS;
>>> +	}
>>> +	else {
>>> +		d->next += div_u64(done * NSEC_PER_SEC, d->rate);
>>>  
>>> -	if (time_before64(now + NSEC_PER_SEC, d->next))
>>> -		d->next = now + NSEC_PER_SEC;
>>> +		if (time_before64(now + NSEC_PER_SEC, d->next))
>>> +			d->next = now + NSEC_PER_SEC;
>>>  
>>> -	if (time_after64(now - NSEC_PER_SEC * 2, d->next))
>>> -		d->next = now - NSEC_PER_SEC * 2;
>>> +		if (time_after64(now - NSEC_PER_SEC * 2, d->next))
>>> +			d->next = now - NSEC_PER_SEC * 2;
>>> +	}
>>>  
>>>  	return time_after64(d->next, now)
>>>  		? div_u64(d->next - now, NSEC_PER_SEC / HZ)
>>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>>> index 69e1ae5..8fac280 100644
>>> --- a/drivers/md/bcache/writeback.c
>>> +++ b/drivers/md/bcache/writeback.c
>>> @@ -60,7 +60,7 @@ static void __update_writeback_rate(struct cached_dev *dc)
>>>  
>>>  	dc->writeback_rate.rate =
>>>  		clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
>>> -			1, NSEC_PER_MSEC);
>>> +			0, NSEC_PER_MSEC);
>>>  
>>>  	dc->writeback_rate_proportional = proportional;
>>>  	dc->writeback_rate_derivative = derivative;
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Coly Li
