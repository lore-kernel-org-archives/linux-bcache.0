From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcache: fix uninterruptible sleep in writeback thread
Date: Thu, 15 May 2014 11:30:58 -0600
Message-ID: <5374F9D2.8020209@kernel.dk>
References: <1398981150-27765-1-git-send-email-sp@daterainc.com> <CA+waHKU1Kaz4Bf=AogB_bXHLZ03tOYp2N5LL=JYH--Y3Yq4qow@mail.gmail.com> <537112A5.6040709@kieser.ca> <53747499.3070000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64678 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaEORbD (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 15 May 2014 13:31:03 -0400
Received: by mail-pb0-f54.google.com with SMTP id jt11so1380346pbb.13
        for <linux-bcache@vger.kernel.org>; Thu, 15 May 2014 10:31:02 -0700 (PDT)
In-Reply-To: <53747499.3070000@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Peter Kieser <peter@kieser.ca>, kmo@daterainc.com, linux-bcache@vger.kernel.org

On 05/15/2014 02:02 AM, Francis Moreau wrote:
> Hello Jens,
> 
> On 05/12/2014 08:27 PM, Peter Kieser wrote:
>>
>> On 2014-05-05 3:30 PM, Nikolay Amiantov wrote:
>>> 2014-05-02 1:52 GMT+04:00 Slava Pestov <sp@datera.io>:
>>>> There were two issues here:
>>>>
>>>> - writeback thread did not start until the device first became dirty
>>>> - writeback thread used uninterruptible sleep once running
>>>>
>>>> Without this patch I see kernel warnings printed and a load average of
>>>> 1.52 after booting my test VM. With this patch the warnings are gone and
>>>> the load average is near 0.00 as expected.
>>> I've tried this patch and it has indeed fixed [1]! Thanks!
>>>
>>> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=69471
>>
>> Kent,
>>
>> Could you please review this patch, and have it pushed upstream?
>>
> 
> Would it be possible to merge this patch directly before 3.15 is being
> released since kent don't seem to care about bugs in bcache or maybe he
> does but very selectively ?
> 
> Also it would be great that stable trees will be fixed.
> 
> Eventually I would suggest to mark bcache as an experimental thing since
> it's really not ready for production, just take a look at the bcache
> mailing list to see why. At least people won't be disappointed when
> they'll use bcache and see ton of koops.

I'd really like to get Kent to weigh in on this. Sometimes it appears
straightforward to switch from uninterruptible to interruptible sleep,
but then signals get in the way.

-- 
Jens Axboe
