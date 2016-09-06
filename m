From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] BUG: soft lockup - CPU#0 stuck for 22s!
 [bch_copygc_read:5328]
Date: Tue, 6 Sep 2016 13:08:57 +0200
Message-ID: <bfc629b3-6f12-a658-d609-bbc1e764dddb@mejor.pl>
References: <5e794b2230e3af7ec0a06eaceaf7a6fc@mejor.pl>
 <20160904001729.r3qjqpin62i6d4so@kmo-pixel>
 <c3e7064966b0449f5107bf3cb637c308@mejor.pl>
 <20160906022407.vukmxltjiyq3hn5s@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:65508 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754927AbcIFLJw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Sep 2016 07:09:52 -0400
In-Reply-To: <20160906022407.vukmxltjiyq3hn5s@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 06.09.2016 o 04:24, Kent Overstreet pisze:
Hi!

> On Sun, Sep 04, 2016 at 08:21:17PM +0200, Marcin wrote:
>> W dniu 2016-09-04 02:17, Kent Overstreet napisał(a):
>>
>> Hi!
>>
>>> On Sat, Sep 03, 2016 at 11:29:49PM +0200, Marcin wrote:
>>>> Hi!
>>>> Kernel at commit c820493652e830dc050e1418301e1bdec5691a1e
>>>>
>>>> I createt to devices, fast has size
>>>> # blockdev --getsz /dev/sde1
>>>> 20971520
>>>> and slower device:
>>>> # blockdev --getsz /dev/sdd1
>>>> 2930209551
>>>>
>>>> I was copying files from one disk to bcache, after some time I got:
>>>>  BUG: soft lockup - CPU#0 stuck for 22s! [bch_copygc_read:5328]
>>>
>>> Thanks for the report - can you run addr2line with your vmlinux file,
>>> and the
>>> RIP?
>>>
>>> addr2line -i -e vmlinux ffffffffc028795b
>>
>> It returned:
>> ??:0
>>
>> Probably due to I'm using bcache as module.
>> <long story>
>> As I mentioned before I wasn't sure which branch I used to test.
> 
> In case I didn't mention before - bcache-dev. This bug in the bcache-encryption
> branch is a bit disconcerting though since my tests never hit it, but don't
> worry about it - I'll chase it down.

I think that bug "BUG: soft lockup" is due to problem with bucket size.
I saw many random, different bugs when second tiered device had bucket
size equal to 768.

>> Please look at line with "bucket size":
>> bucket_size:            768
>> If bucket size is higher than (probably) 512 then I can't mount simple
>> (without tiering) bcachefs filesystem. If I use such big device in tiered
>> bcachefs I'm expieriencing random problems with stability of box.
>> I think that bug in mail's subject is only random symptom of problem when
>> device is formated with bucket size >512.
>> What is going inside kernel in this case, is overwittem memory of other
>> processes?
> 
> Whoops - that one is a bug in bcache-tools, non power of two bucket sizes aren't
> supported (might be someday, but aren't currently). I just pushed a fix for that
> to bcache-tools.
One mor thing, when I tested tiering with one device formated with
unsupported bucket sizethis command worked:
# mount /dev/sde1:/dev/sdd1 /mnt/test
but this one didn't:
# mount /dev/sdd1:/dev/sde1 /mnt/test

so:
<low priority wish>
it could be good to check if on disk format of every device is correct
and supported.

Thank you,
Marcin
