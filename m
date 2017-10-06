From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 03:56:03 -0700
Message-ID: <CAJ+L6qfHHKT4T8y=6ygmd2e+tj=XScZ9y1fX+=iKFtXip3hrRw@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li> <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li> <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li> <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li> <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
 <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li> <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
 <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li> <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:43810 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdJFK4F (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Oct 2017 06:56:05 -0400
Received: by mail-qt0-f182.google.com with SMTP id a43so24689945qta.0
        for <linux-bcache@vger.kernel.org>; Fri, 06 Oct 2017 03:56:05 -0700 (PDT)
In-Reply-To: <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

I will write a test bench and send results soon.

Just please note-- you've crafted a test where there's not likely to
be sequential data to writeback, and chosen a block size where there
is limited difference between sequential and nonsequential writeback.
Not surprisingly, you don't see a real difference with code that is
trying to optimize sequential writeback :P

Mike

On Fri, Oct 6, 2017 at 3:42 AM, Michael Lyle <mlyle@lyle.org> wrote:
> Coly--
>
> Holy crap, I'm not surprised you don't see a difference if you're
> writing with 512K size!  The potential benefit from merging is much
> less, and the odds of missing a merge is much smaller.  512KB is 5ms
> sequential by itself on a 100MB/sec disk--- lots more time to wait to
> get the next chunks in order, and even if you fail to merge the
> potential benefit is much less-- if the difference is mostly
> rotational latency from failing to merge then we're talking 5ms vs
> 5+2ms.
>
> Do you even understand what you are trying to test?
>
> Mike
>
> On Fri, Oct 6, 2017 at 3:36 AM, Coly Li <i@coly.li> wrote:
>> On 2017/10/6 =E4=B8=8B=E5=8D=885:20, Michael Lyle wrote:
>>> Coly--
>>>
>>> I did not say the result from the changes will be random.
>>>
>>> I said the result from your test will be random, because where the
>>> writeback position is making non-contiguous holes in the data is
>>> nondeterministic-- it depends where it is on the disk at the instant
>>> that writeback begins.  There is a high degree of dispersion in the
>>> test scenario you are running that is likely to exceed the differences
>>> from my patch.
>>
>> Hi Mike,
>>
>> I did the test quite carefully. Here is how I ran the test,
>> - disable writeback by echo 0 to writeback_runing.
>> - write random data into cache to full or half size, then stop the I/O
>> immediately.
>> - echo 1 to writeback_runing to start writeback
>> - and record performance data at once
>>
>> It might be random position where the writeback starts, but there should
>> not be too much difference of statistical number of the continuous
>> blocks (on cached device). Because fio just send random 512KB blocks
>> onto cache device, the statistical number of contiguous blocks depends
>> on cache device vs. cached device size, and how full the cache device is
>> occupied.
>>
>> Indeed, I repeated some tests more than once (except the md raid5 and md
>> raid0 configurations), the results are quite sable when I see the data
>> charts, no big difference.
>>
>> If you feel the performance result I provided is problematic, it would
>> be better to let the data talk. You need to show your performance test
>> number to prove that the bio reorder patches are helpful for general
>> workloads, or at least helpful to many typical workloads.
>>
>> Let the data talk.
>>
>> Thanks.
>>
>> --
>> Coly Li
