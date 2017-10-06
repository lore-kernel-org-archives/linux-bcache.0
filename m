From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 18:36:31 +0800
Message-ID: <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li>
 <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
 <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li>
 <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li>
 <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
 <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li>
 <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:40528 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752007AbdJFKgh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Oct 2017 06:36:37 -0400
In-Reply-To: <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/10/6 下午5:20, Michael Lyle wrote:
> Coly--
> 
> I did not say the result from the changes will be random.
> 
> I said the result from your test will be random, because where the
> writeback position is making non-contiguous holes in the data is
> nondeterministic-- it depends where it is on the disk at the instant
> that writeback begins.  There is a high degree of dispersion in the
> test scenario you are running that is likely to exceed the differences
> from my patch.

Hi Mike,

I did the test quite carefully. Here is how I ran the test,
- disable writeback by echo 0 to writeback_runing.
- write random data into cache to full or half size, then stop the I/O
immediately.
- echo 1 to writeback_runing to start writeback
- and record performance data at once

It might be random position where the writeback starts, but there should
not be too much difference of statistical number of the continuous
blocks (on cached device). Because fio just send random 512KB blocks
onto cache device, the statistical number of contiguous blocks depends
on cache device vs. cached device size, and how full the cache device is
occupied.

Indeed, I repeated some tests more than once (except the md raid5 and md
raid0 configurations), the results are quite sable when I see the data
charts, no big difference.

If you feel the performance result I provided is problematic, it would
be better to let the data talk. You need to show your performance test
number to prove that the bio reorder patches are helpful for general
workloads, or at least helpful to many typical workloads.

Let the data talk.

Thanks.

-- 
Coly Li
