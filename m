From: Coly Li <i@coly.li>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 16:45:25 +0200
Message-ID: <ad61e116-e69b-d62e-b4de-f20198d7a3fe@coly.li>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
 <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
 <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:37014 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbdINOpc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 10:45:32 -0400
In-Reply-To: <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>, linux-bcache@vger.kernel.org

On 2017/9/14 下午3:10, FERNANDO FREDIANI wrote:
> Hello Coly.
> 
> If the users reads a piece of data that is just writen to SSD (unlikely)
> it should first and in any condition be commited to the permanent
> storage and then read from there and cached in another area of the SSD.
> Writaback cache is very volatile and lasts only a few seconds while the
> data is not yet committed to permanent storage.
> 
> In fact multiple device suport is not implemented yet, that's why I am
> asking it and comparing with other well technology as ZFS.
> 

Hi Fernando,

Do you have some performance number to compare combined and separated
configurations on ZFS ? If the performance improvement is not from
adding one more SSD device, I don't why dedicate read/write SSDs may
help for performance. In my understanding, if any of the SSD has spared
throughput capability for read or write, mixed them together on both
SSDs may have better performance number.


Coly Li


> 
> On 14/09/2017 04:58, Coly Li wrote:
>> On 2017/9/11 下午4:04, FERNANDO FREDIANI wrote:
>>> Hi folks
>>>
>>> In Bcache people normally use a single SSD for both Read and Write
>>> cache. This seems to work pretty well, at least for the load we have
>>> been using here.
>>>
>>> However in other environments, specially on ZFS people tend to suggest
>>> to use dedicated SSDs for Write (ZIL) and for Read (L2ARC). Some say
>>> that performance will be much better in this way and mainly say they
>>> have different wearing levels.
>>> The issue now a days is that SSDs for Write Cache (or Writeback) don't
>>> need to have much space available (8GB normally is more than enough),
>>> just enough for the time until data is committed to the pool (or
>>> slower disks) so it is hard to find a suitable SSD to dedicate to this
>>> propose only without overprovisioning that part.
>>> On the top of that newer SSDs have changed a lot in recent times using
>>> different types of memory technologies which tend to be much durable.
>>>
>>> Given that I personally see that using a single SSD for both Write and
>>> Read cache, in any scenarios doesn't impose any significant loss to
>>> the storage, given you use new technology SSDs and that you will
>>> hardly saturate it most of the time. Does anyone agree or disagree
>>> with that ?
>> Hi Fernando,
>>
>> If there is any real performance number, it will be much easier to
>> response this idea. What confuses me is, if user reads a data block
>> which is just written to SSD, what is the benefit for the separated SSDs.
>>
>> Yes I agree with you that some times a single SSD as cache device is
>> inefficient. Multiple cache device on bcache is a not-implemented yet
>> feature as I know.
>>
>> Thanks.
