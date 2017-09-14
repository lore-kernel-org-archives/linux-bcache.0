From: FERNANDO FREDIANI <fernando.frediani@upx.com>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 10:10:09 -0300
Message-ID: <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
 <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:51984 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdINNKO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 09:10:14 -0400
Received: by mail-qt0-f180.google.com with SMTP id q4so142773qtq.8
        for <linux-bcache@vger.kernel.org>; Thu, 14 Sep 2017 06:10:14 -0700 (PDT)
In-Reply-To: <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org

Hello Coly.

If the users reads a piece of data that is just writen to SSD (unlikely) 
it should first and in any condition be commited to the permanent 
storage and then read from there and cached in another area of the SSD. 
Writaback cache is very volatile and lasts only a few seconds while the 
data is not yet committed to permanent storage.

In fact multiple device suport is not implemented yet, that's why I am 
asking it and comparing with other well technology as ZFS.

Regards,
Fernando


On 14/09/2017 04:58, Coly Li wrote:
> On 2017/9/11 下午4:04, FERNANDO FREDIANI wrote:
>> Hi folks
>>
>> In Bcache people normally use a single SSD for both Read and Write
>> cache. This seems to work pretty well, at least for the load we have
>> been using here.
>>
>> However in other environments, specially on ZFS people tend to suggest
>> to use dedicated SSDs for Write (ZIL) and for Read (L2ARC). Some say
>> that performance will be much better in this way and mainly say they
>> have different wearing levels.
>> The issue now a days is that SSDs for Write Cache (or Writeback) don't
>> need to have much space available (8GB normally is more than enough),
>> just enough for the time until data is committed to the pool (or
>> slower disks) so it is hard to find a suitable SSD to dedicate to this
>> propose only without overprovisioning that part.
>> On the top of that newer SSDs have changed a lot in recent times using
>> different types of memory technologies which tend to be much durable.
>>
>> Given that I personally see that using a single SSD for both Write and
>> Read cache, in any scenarios doesn't impose any significant loss to
>> the storage, given you use new technology SSDs and that you will
>> hardly saturate it most of the time. Does anyone agree or disagree
>> with that ?
> Hi Fernando,
>
> If there is any real performance number, it will be much easier to
> response this idea. What confuses me is, if user reads a data block
> which is just written to SSD, what is the benefit for the separated SSDs.
>
> Yes I agree with you that some times a single SSD as cache device is
> inefficient. Multiple cache device on bcache is a not-implemented yet
> feature as I know.
>
> Thanks.
>
