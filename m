From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Date: Mon, 13 Apr 2020 16:17:22 +0800
Message-ID: <8d86b345-f919-f089-245d-f227401d028d@suse.de>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
 <20200302134048.GK4380@dhcp22.suse.cz>
 <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
 <6D00F9F9-D44F-4853-AC85-22AC1455B653@bank-hlynov.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgDMIRc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Apr 2020 04:17:32 -0400
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E8FC00860B
        for <linux-bcache@vger.kernel.org>; Mon, 13 Apr 2020 01:17:31 -0700 (PDT)
In-Reply-To: <6D00F9F9-D44F-4853-AC85-22AC1455B653@bank-hlynov.ru>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?UTF-8?B?0KHQvtGA0L7QutC40L0g0JDRgNGC0LXQvCDQodC10YDQs9C10LXQstC40Yc=?= <a.sorokin@bank-hlynov.ru>
Cc: Michal Hocko <mhocko@kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "mkoutny@suse.com" <mkoutny@suse.com>, Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>

On 2020/3/3 14:58, Сорокин Артем Сергеевич wrote:
> Hello Coly,
> 
> On 2 Mar 2020, at 20:06, Coly Li <colyli@suse.de> wrote:
>>
>> I see your concern. But the udev timeout is global for all udev rules, I
>> am not sure whether change it to a very long time is good ... (indeed I
>> tried to add event_timeout=3600 but I can still see the signal received).
>>
>> Ignore the pending signal in bcache registering code is the only method
>> currently I know to avoid bcache auto-register failure in boot time. If
>> there is other way I can achieve the same goal, I'd like to try.
>>
>> BTW, by the mean time, I am still looking for the reason why
>> event_timeout=3600 in /etc/udev/udev.conf does not take effect...
> 
> In my setup, i completely moved bcache registration from udev to systemd. As a result, there is no need to change udev timeout or worry about kill signals. But this approach breaks hot-plugging bcache devices and require to modify udev rules and probe-bcache from bcache-tools.
> 
> It also helps me to manage startup dependencies to ensure that ceph-osd will start only when bcache is ready.
> 
> I can elaborate on my approach if you are interested.
> 

Yes please, I am interesting.

Now I continue to look at the timeout issue. I'd like to get many input
of different ideas, then make a proper way to fix.

Thanks.

Coly Li
