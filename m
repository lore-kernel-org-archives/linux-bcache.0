From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: [PATCH] bcache: fix uninterruptible sleep in writeback thread
Date: Thu, 15 May 2014 10:02:33 +0200
Message-ID: <53747499.3070000@gmail.com>
References: <1398981150-27765-1-git-send-email-sp@daterainc.com> <CA+waHKU1Kaz4Bf=AogB_bXHLZ03tOYp2N5LL=JYH--Y3Yq4qow@mail.gmail.com> <537112A5.6040709@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43903 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaEOIA5 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 15 May 2014 04:00:57 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so2996722wgh.23
        for <linux-bcache@vger.kernel.org>; Thu, 15 May 2014 01:00:56 -0700 (PDT)
In-Reply-To: <537112A5.6040709@kieser.ca>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
Cc: Peter Kieser <peter@kieser.ca>, kmo@daterainc.com, linux-bcache@vger.kernel.org, axboe@kernel.dk

Hello Jens,

On 05/12/2014 08:27 PM, Peter Kieser wrote:
> 
> On 2014-05-05 3:30 PM, Nikolay Amiantov wrote:
>> 2014-05-02 1:52 GMT+04:00 Slava Pestov <sp@datera.io>:
>>> There were two issues here:
>>>
>>> - writeback thread did not start until the device first became dirty
>>> - writeback thread used uninterruptible sleep once running
>>>
>>> Without this patch I see kernel warnings printed and a load average of
>>> 1.52 after booting my test VM. With this patch the warnings are gone and
>>> the load average is near 0.00 as expected.
>> I've tried this patch and it has indeed fixed [1]! Thanks!
>>
>> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=69471
> 
> Kent,
> 
> Could you please review this patch, and have it pushed upstream?
> 

Would it be possible to merge this patch directly before 3.15 is being
released since kent don't seem to care about bugs in bcache or maybe he
does but very selectively ?

Also it would be great that stable trees will be fixed.

Eventually I would suggest to mark bcache as an experimental thing since
it's really not ready for production, just take a look at the bcache
mailing list to see why. At least people won't be disappointed when
they'll use bcache and see ton of koops.

Thanks.
