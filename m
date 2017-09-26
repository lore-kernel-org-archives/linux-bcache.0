From: Michael Lyle <mlyle@lyle.org>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Tue, 26 Sep 2017 12:51:15 -0700
Message-ID: <CAJ+L6qf7xrcYDXGzs9RqdbmSFH5svt=QbFxEfNw=P2O+ACWznA@mail.gmail.com>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
 <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li> <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
 <ad61e116-e69b-d62e-b4de-f20198d7a3fe@coly.li> <CAD7b65LwYmNA1=oSrYGcYkG3HtjCm7wK2BT+rc97bnKSW=Etiw@mail.gmail.com>
 <55d3cd06-e239-9374-be38-32514fd9089c@coly.li> <CAD7b65+2poC-gr6F6Z5EoNG3hvyxE=ugTsuKmUPTtMBbgfGr-A@mail.gmail.com>
 <5c279bfe-4f43-476e-efbf-ed6267670750@upx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:52700 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965209AbdIZTvR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 15:51:17 -0400
Received: by mail-qt0-f174.google.com with SMTP id o52so11556548qtc.9
        for <linux-bcache@vger.kernel.org>; Tue, 26 Sep 2017 12:51:16 -0700 (PDT)
In-Reply-To: <5c279bfe-4f43-476e-efbf-ed6267670750@upx.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: FERNANDO FREDIANI <fernando.frediani@upx.com>
Cc: linux-bcache@vger.kernel.org

Fernando--

I don't think it really matters.  Before, when capacities of SSD were
really small and endurance was a big concern it made sense to have a
separate write cache made out of SLC flash-- now, being able to
wear-level over an entire large MLC device is where the longevity
comes from.  So I understand why ZFS made the tradeoffs they did (also
the read path / write path functionality were added at different times
by different people)-- but I don't think you'd make the same choices
in implementation today.

As Coly points out, there's a small benefit to having different
redundancy policies-- you don't need RAID-1 for read cache because
it's not too big of a deal if you lose it.  But handling this
properly-- having multiple cache devices and ensuring that not-dirty
data has only one copy and dirty data has multiple copies-- is fairly
complicated for various reasons.  And having separate devices IMO is
not a good idea today-- it's both complicated to deploy and means that
you concentrate most of the writes to one disk (e.g. you don't
wear-level over all of the disk capacity).

Mike

On Tue, Sep 26, 2017 at 12:28 PM, FERNANDO FREDIANI
<fernando.frediani@upx.com> wrote:
> Hello
>
> Has anyone had any consideration about the usage of a single SSD for both
> read and write and how that impacts the overall performance and drive's
> endurance ?
>
> I am interested to find out more in order to adjust the necessary stuff a=
nd
> monitor it accordingly.
>
> Fernando
>
>
>
> On 14/09/2017 12:14, FERNANDO FREDIANI wrote:
>>
>> Hello Coly
>>
>> I didn't start this thread to provide numbers but to ask people view
>> on the concept and compare how flash technology works compared to how
>> it used to be a few years ago and I used ZFS case as an example
>> because people used to recommend to have separate devices until
>> sometime ago. My aim is to understand why this is not the
>> recommendation for bcache, if it already took in consideration newer
>> technology or if has anything else different on the way it deals with
>> write and read cache.
>>
>> Regards,
>> Fernando
>>
>>
>> On 14/09/2017 12:04, Coly Li wrote:
>>
>> On 2017/9/14 =E4=B8=8B=E5=8D=884:54, FERNANDO FREDIANI wrote:
>>
>> It depends on every scenario. SSDs generally have a max throughput and
>> a max IOPS for read and write, but when you mix them it becomes more
>> difficult to measure. A typical SSDs caching device used for both
>> tasks will have the normal writing for doing the writeback caching,
>> have writes coming from the permanent storage to cache content more
>> popular (so to populate the cache) and will have reads to serve
>> content already cache to the user who requested.
>>
>> Another point perhaps even more important than that is how the SSD in
>> question will stand for wearing. Now a days SSDs are much more
>> durable, specially those with higher DWPD. I read recently that newer
>> memory technology will do well compared to previous ones.
>>
>> Hi Fernando,
>>
>> It will be great if you may provide some performance numbers on ZFS (I
>> assume it should be ZFS since you mentioned it). I can understand the
>> concept, but real performance number should be more attractive for this
>> discussion :-)
>>
>> Thanks in advance.
>>
>> Coly Li
>>
>> On 14/09/2017 11:45, Coly Li wrote:
>>
>> On 2017/9/14 =E4=B8=8B=E5=8D=883:10, FERNANDO FREDIANI wrote:
>>
>> Hello Coly.
>>
>> If the users reads a piece of data that is just writen to SSD (unlikely)
>> it should first and in any condition be commited to the permanent
>> storage and then read from there and cached in another area of the SSD.
>> Writaback cache is very volatile and lasts only a few seconds while the
>> data is not yet committed to permanent storage.
>>
>> In fact multiple device suport is not implemented yet, that's why I am
>> asking it and comparing with other well technology as ZFS.
>>
>> Hi Fernando,
>>
>> Do you have some performance number to compare combined and separated
>> configurations on ZFS ? If the performance improvement is not from
>> adding one more SSD device, I don't why dedicate read/write SSDs may
>> help for performance. In my understanding, if any of the SSD has spared
>> throughput capability for read or write, mixed them together on both
>> SSDs may have better performance number.
>>
>>
>> Coly Li
>>
>>
>> On 14/09/2017 04:58, Coly Li wrote:
>>
>> On 2017/9/11 =E4=B8=8B=E5=8D=884:04, FERNANDO FREDIANI wrote:
>>
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
>>
>> Hi Fernando,
>>
>> If there is any real performance number, it will be much easier to
>> response this idea. What confuses me is, if user reads a data block
>> which is just written to SSD, what is the benefit for the separated SSDs=
.
>>
>> Yes I agree with you that some times a single SSD as cache device is
>> inefficient. Multiple cache device on bcache is a not-implemented yet
>> feature as I know.
>>
>> Thanks.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
