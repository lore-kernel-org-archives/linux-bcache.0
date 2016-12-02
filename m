From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH 1/2] bcache: Remove redundant set_capacity
Date: Fri, 2 Dec 2016 08:54:25 +0800
Message-ID: <5840C641.30904@huawei.com>
References: <1480037969-45042-1-git-send-email-wangyijing@huawei.com>
 <alpine.LRH.2.11.1611291246140.1914@mail.ewheeler.net>
 <583E32AE.5060106@huawei.com>
 <alpine.LRH.2.11.1611301030001.442@mail.ewheeler.net>
 <583FEC37.1040003@huawei.com>
 <alpine.LRH.2.11.1612011359150.22682@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([119.145.14.199]:42179 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757381AbcLBAyq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Dec 2016 19:54:46 -0500
In-Reply-To: <alpine.LRH.2.11.1612011359150.22682@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: axboe@fb.com, kent.overstreet@gmail.com, git@linux.ewheeler.net, colyli@suse.de, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

>>> I want to make sure that the set_capacity call that happens on cache 
>>> attachment is not necessary when a backing device is attached without
>>
>> Hi Eric, set_capacity() which removed in this patch is happened at cached_dev_init()
>> which is called when register a backing device, what do you mean "set_capacity call that happens on cache
>>> attachment" ?
> 
> 
> I'm sorry, you are correct.  I though this was the cache-dev attachment, 
> not the cached-dev attachment.  Looks good.
> 
> Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
> 

Thanks！

> --
> Eric Wheeler
> 
>>
>>
>>> its dirty writeback cache since bcache0 is not presented until the cache 
>>> attaches in that case.
>>
>> I found bcache0 device present once we do make-bcache -B /dev/nvme1n1. before attach the cache set.
>> So I missed something ?
>>
>>>
>>> Can you also unregister the volume, attach the backing device first, and 
>>> then the cache while the cache is dirty to make sure that the size is set 
>>> correctly?
>>
>> When I unregister the cache device, I found all the dirty data has been flushed to
>> backing device, so how can I do the test the case as you point ?
>>
>> Thanks!
>> Yijing.
>>
>>>
>>> --
>>> Eric Wheeler
>>>
>>>>
>>>>>
>>>>> -Eric
>>>>>
>>>>>>  	dc->disk.disk->queue->backing_dev_info.ra_pages =
>>>>>>  		max(dc->disk.disk->queue->backing_dev_info.ra_pages,
>>>>>>  		    q->backing_dev_info.ra_pages);
>>>>>> -- 
>>>>>> 2.5.0
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>
>>>>> .
>>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> .
> 
