From: Coly Li <colyli@suse.de>
Subject: Re: Request For Suggestion: how to handle udevd timeout for bcache
 registration
Date: Fri, 24 Apr 2020 16:57:39 +0800
Message-ID: <b2cf1d0e-b710-4e11-7ea8-f01364986c4a@suse.de>
References: <7c92cd67-8e62-7d55-c520-345c30513bfa@suse.de>
 <140de6d9-b5ff-0736-ddbd-5b9e1ae70f5b@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbgDXI5p (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Apr 2020 04:57:45 -0400
In-Reply-To: <140de6d9-b5ff-0736-ddbd-5b9e1ae70f5b@kernel.dk>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: linux-block@vger.kernel.org

On 2020/4/23 23:08, Jens Axboe wrote:
> On 4/23/20 5:23 AM, Coly Li wrote:
>> Hi folk,
>>
>> I want to listen to your suggestion on how to handle the udevd timeout
>> for bcache registration.
>>
>> First of all let me introduce the background of this timeout problem.
>>
>> Now the bcache registration is synchronized, the registering process
>> will be blocked until the whole registration done. In boot up time, such
>> registration can be initiated from a bcache udev rule. Normally it won't
>> be problem, but for very large cached data size there might be a large
>> internal btree on the cache device. During the registration checking all
>> the btree nodes may take 50+ minutes as a udev task, it exceeds 180
>> seconds timeout and udevd will kill it. The killing signal will make
>> kthread_create() fail during bcache initialization, then the automatic
>> bcache registration in boot up time will fail.
>>
>> The above text describes the problem I need to solve: make boot up time
>> automatic bache registration always success no mater how long it will take.
>>
>> I know there are several solutions to solve such problem, I do
>> appreciate if you may share the solution so that I may learn good ideas
>> from them.
>>
>> Thank you in advance for the information sharing of my request of
>> suggestion.
> 
> The way I see it, you have only two choices:
> 
> 1) Make the registration async (or lazy), so that starting the device is
>    fast, but the btree verification happens on-demand or in the
>    background.
> 

Yes, this is what I plan to do now, make whole initialization to be
asynchronous.

Currently there are points not clear to me.
- During the boot up time, if a bcache device is listed in /etc/fstab.
How can I block the fs mount step before the bcache device
/dev/bcache<N> shows up. I guess it should be done in systemd, and not
sure whether there is another timeout value.
- When the bcache device registration done and /dev/bcache<N> show up,
if it is listed in /etc/fstab, how to only mount this bcache device only
and not touch other mount points.

udev rules and systemd are both magic to me at this moment. If anybody
may give a hint, or some similar example to learn and understand, it
will be very helpful.

Thanks.

Coly Li
