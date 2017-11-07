From: Campbell Steven <casteven@gmail.com>
Subject: Re: Testing 4.14 rc8 kernel with bcache - cache device numbering
Date: Wed, 8 Nov 2017 08:53:50 +1300
Message-ID: <CAPerZE8tH9g=_FzUU2YWqbhbWuygf_7_1PebH_cot0kV_DJp6A@mail.gmail.com>
References: <CAPerZE8dmu60sksC+hkk4E+GOht1F5nExPTvv4WRS=kRGO+GZA@mail.gmail.com>
 <CAJ+L6qdMyeUHvfXx_OD=AE_DPAG7+sbXiinoeoCv1WqhktPEBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:53839 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdKGTxv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Nov 2017 14:53:51 -0500
Received: by mail-yw0-f171.google.com with SMTP id q126so346754ywq.10
        for <linux-bcache@vger.kernel.org>; Tue, 07 Nov 2017 11:53:51 -0800 (PST)
In-Reply-To: <CAJ+L6qdMyeUHvfXx_OD=AE_DPAG7+sbXiinoeoCv1WqhktPEBA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org

Thanks alot for the pointer Michael, I have applied this patch to my
4.14 rc8 tree will do some further testing.

On 8 November 2017 at 07:15, Michael Lyle <mlyle@lyle.org> wrote:
> Hi Campbell--
>
> Previously the device numbering was strange to allow for partitioning
> bcache devices before.    Coly has addressed this with his changeset
> "bcache: Rewrite multiple partition support".  Unfortunately, it did
> not make the 4.14 merge window and is in next, slated for inclusion
> with 4.15.
>
> Mike
>
> On Mon, Nov 6, 2017 at 6:37 PM, Campbell Steven <casteven@gmail.com> wrote:
>> Hi,
>>
>> I've been doing some testing so that we can move from a 4.7 kernel up
>> to 4.14 at some point in the future.
>>
>> One thing I've noticed is that the numbering of the bcache devices is
>> quite different, is there a reason it's going 0,16,32 etc.?
>>
>> [Tue Nov  7 13:41:54 2017] bcache: bch_cached_dev_attach() Caching
>> sdb1 as bcache0 on set 030a5f1b-b314-482f-ba91-be1d712a4a33
>> [Tue Nov  7 14:32:45 2017] bcache: bch_cached_dev_attach() Caching
>> sda1 as bcache16 on set 07cd8359-1427-4446-9688-d67ceb4f4b4c
>> [Tue Nov  7 14:36:36 2017] bcache: bch_cached_dev_attach() Caching
>> sdc1 as bcache32 on set 030a5f1b-b314-482f-ba91-be1d712a4a33
>>
>> Thanks
>>
>> Campbell
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
