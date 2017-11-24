From: Rui Hua <huarui.dev@gmail.com>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Fri, 24 Nov 2017 20:50:07 +0800
Message-ID: <CAPGwLLO2xvVJJTDcN2865cTxX8Q_NhziHMiwRd-0sq5g1VVu6Q@mail.gmail.com>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <1c715cc2-b656-36a8-4017-55052937df82@lyle.org> <CAPGwLLNyjjxKOXA3RCFGSi4p-ZWZ5T9ADWP6EAqrfL3oUvMbFQ@mail.gmail.com>
 <CAJ+L6qen=5AVFr_q_r_F6jU8BTQ=t+7p94ucFW9HXEDD6AGEKg@mail.gmail.com>
 <8cb4231f-9b0d-3cb3-d733-b868f37daa6d@lyle.org> <5ab429e6-a376-6995-172b-9370de89fe4c@ehuk.net>
 <1c5502d2-cc45-5226-cf2d-ad9833e87728@coly.li> <17f5176f-560a-b1dd-d3fc-16623d616c5e@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35263 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753560AbdKXMu2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 07:50:28 -0500
Received: by mail-vk0-f42.google.com with SMTP id n63so13514003vkf.2
        for <linux-bcache@vger.kernel.org>; Fri, 24 Nov 2017 04:50:28 -0800 (PST)
In-Reply-To: <17f5176f-560a-b1dd-d3fc-16623d616c5e@ehuk.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eddie Chapman <eddie@ehuk.net>
Cc: Coly Li <i@coly.li>, Michael Lyle <mlyle@lyle.org>, linux-bcache <linux-bcache@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>

Hi, Eddie,

I totally agree with Coly's suggestion about how to use the two new
patches in your environment. It will be very helpful to us if you try
them.

Coly,

Thank you very much for sorting out the ins and outs about the
patches, the explanation is very helpful and necessary.

Thanks.

2017-11-24 2:08 GMT+08:00 Eddie Chapman <eddie@ehuk.net>:
> Hi Coly,
>
>
> On 23/11/17 16:31, Coly Li wrote:
>>
>> On 23/11/2017 11:09 PM, Eddie Chapman wrote:
>>>
>>> On 22/11/17 05:13, Michael Lyle wrote:
>>>>
>>>> Reviewed-by: Michael Lyle <mlyle@lyle.org>
>>>
>>>
>>> <snip>
>>>
>>> I have a little dilemma now related to this patch and I wonder if I
>>> could ask you guys for your opinion?
>>>
>>
>> Hi Eddie,
>>
>> As author of  "only permit to recovery read error" patch, let me try to
>> response your question.
>>
>>> I have been hit and am being hit by the bug this patch fixes every few
>>> days at the moment, on writeback bcache resources. When it hits it
>>> causes a failure in the layer above, and this leads to other problems
>>> that can and has led to loss of data (not in bcache, just that the read
>>> failure causes a chain of events in upper layer, separate issue, won't
>>> clutter this mail with that). So, I am very keen to resolve this
>>> urgently in my environment.
>>>
>>> I am running stable 4.9, and I have cherry picked several recent bcache
>>> patches, including "bcache: only permit to recovery read error
>>> when cache device is clean", which I understand causes this issue.
>>>
>>> I have a dilemma now whether I should apply the new patch in this
>>> thread, which should fix the issue, or revert "only permit to recovery
>>> read error" patch.
>>>
>>
>> I suggest you to take one of the 2 actions,
>> - apply "bcache: recover data from backing device when read request hit
>> clean" patch, or
>> - revert "only permit to recovery read error" patch, and add the
>> modification as "bcache: recover data from backing device when read
>> request hit clean" does.
>
>
> Thanks for clarifying what the 2 best options are.
>
>>> The dilemma is because I don't like the idea of reverting the "only
>>> permit to recovery read error" patch since it appears to fix an
>>> important problem.  Or am I overestimating the problem (maybe that's why
>>> the original patch has not been backported to stable kernels, maybe the
>>> original issue quite rare)?
>>>
>>
>> "only permit to recovery read error" patch fixes a real data corruption
>> issue with broken cache device (SSD), which was reported from production
>> environment. If you don't have all these 2 patches, your data may be
>> corrupted in silence when SSD is broken.
>
>
> OK, I think that confirms to me then that I'm definitely keeping the "only
> permit to recovery read error" patch :-)
>
> That sounds like a very significant bug fix. I'm wondering, shouldn't "only
> permit to recovery read error" patch be backported to the stable kernels
> like 4.9, 4.4? Or maybe it doesn't fully meet the stable inclusion criteria.
> I know the patch was CC'd to stable but it has not been picked up. Maybe
> because it was not in Linus' tree yet when it was originally CC'd.
>
>>> But I am also wary of applying the new patch as Michael only just added
>>> to his tree so hasn't had much baking time.
>>>
>>
>> The new one "bcache: recover data from backing device when read request
>> hit clean" can be treated as an improvement of my patch. Because when I
>> wrote that patch, I didn't notice metadata and data failure on cache
>> device were in different code path, I have to only check ds->has_dirty.
>
>
> OK, thanks, that makes me feel a little better about applying it.
>
>> Rui points out the metadata failure is in another code pathm and buggy
>> too. He posts another patch to fix it, and you may find it in
>> linux-bcache mailing list.
>
>
> Yes, I noticed that patch and was thinking whether to apply that one too.
>
>> When I wrote the "only permit to recovery read error" patch, I didn't
>> notice the read race existed neither, until Junhui and Rui noticed me.
>> The read race only happens on clean data (because its bucket is clean
>> and re-allocated to different write request), so the new patch permits
>> data recovery from backing device if a read failed on clean data.
>>
>> The result for this new fix is, less I/O error may returns to upper
>> layer code, especially the bogus I/O error generated by btree read race.
>
>
> Thanks for explaining and the detail, it is much appreciated :-) And I hope
> I don't come across as complaining about this patch in any way :-) I know
> this is difficult work, and, hey, even with the new bug introduced, the new
> bug is a *lot* less painful than the original bug you fixed :-)
>
>>> I wondered what is the opinion of you guys which of these two I should
>>> choose?
>>
>>
>> If you only do patching, you need to have both of them. If you only want
>> one patch, you may rebase this patch to 4.9 kernel and ignore the first
>> one.
>>
>>>
>>> (BTW, please don't say "just don't cherry pick onto 4.9". I am aware of
>>> the risks of cherry picking, as discussed recently on this list. I am
>>> happy with the level of risk and I am being very careful in what I pick.
>>> In this case I have not been "burnt" by cherry picking since I would
>>> have hit the same issue if I would have just upgraded to 4.14 which
>>> contains the original "only permit to recovery read error" patch.)
>>>
>>> ( N.B. I understand that any opinion/advice I receive is just that. I
>>> take complete responsibility for what I decide :-) )
>>
>>
>> One more comment, when you apply both patches, I/O failure on broken
>> cache device (SSD) is still risky. As Rui points out in his patch,
>> "The read request might meet error when searching the btree, but the
>> error was not handled in cache_lookup(), and this kind of metadata
>> failure will not go into cached_dev_read_error(), finally, the upper
>> layer will receive bi_status=0."
>>
>> Rui's patch "bcache: return IOERR to upper layer when read request meet
>> metadata error" is also added inti Mike's tree, if you may consider
>> testing it, that will be very helpful to us.
>
>
> You have convinced me that the best way forward is to keep "only permit to
> recovery read error", and also apply both of the new patches.   I think I
> will wait a few more days to give a little more "baking" time for the new
> patches, then will try them and report back.
>
>>
>> Thank you for asking great question :-)
>>
>
> Thanks!
> Eddie
