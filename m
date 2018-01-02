From: tang.junhui@zte.com.cn
Subject: Re: Re: [for-416 PATCH] bcache: fix writeback target calc on large devices
Date: Tue, 2 Jan 2018 17:25:12 +0800
Message-ID: <1514885112-12218-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>


>Thank you for the feedback.
>
>On Mon, Jan 1, 2018 at 10:33 PM,  <tang.junhui@zte.com.cn> wrote:
>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>
>> This patch is useful for preventing the overflow of the expression
>> (cache_dirty_target * bdev_sectors(dc->bdev)), but it also
>> lead into a calc error, for example, when there is a 1G and
>> 100*164G cached device, it would cause the "target" value to
>> be aways zero of the 1G device, which would cause write-back
>> threshold losing efficacy.
>>
>> Maybe at first we can judge if it overflows or not of the expression
>> (cache_dirty_target * bdev_sectors(dc->bdev)), if it overflows,
>> We can calc the value of target as the patch, otherwise,
>> we calc it as old way.
>
>Maybe it'd be preferable just to ensure that share always >=1. 
Yes, this is a good and simple way.
 
>It
>seems like a pretty narrow set of cases where the current math works
>and the new math doesn't work, though, as I expect that it's
>relatively rare to have such a variation in sizes, and even so 16.4TB
>uses up 35 bits of the 64 bit quantity.
>
Truely, this issue is rare. But as we known, cache set is a sharable pool,
we may attach various devices on it, such as petabyte big device or gigabyte
small device. We would better to make them all works well in the same 
cache set.

>I don't really like special cases or trying two different ways to do
>the math, because then it's very difficult to test.
>
>What do you think?
Ha, I don't think it is difficult to do, actually you have provided a 
simple and effective way above, and we can use a small partition device
and a big partition device to test (such as a 100M device and a 2T device). 
I believe you can do it better.

Thanks,
Tang Junhui
