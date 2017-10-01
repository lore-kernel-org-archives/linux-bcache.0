From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Mon, 2 Oct 2017 01:23:56 +0800
Message-ID: <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li>
 <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li>
 <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
 <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li>
 <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
 <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li>
 <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/10/2 上午12:56, Michael Lyle wrote:
> That's strange-- are you doing the same test scenario?  How much
> random I/O did you ask for?
> 
> My tests took 6-7 minutes to do the 30G of 8k not-repeating I/Os in a
> 30G file (about 9k IOPs for me-- it's actually significantly faster
> but then starves every few seconds-- not new with these patches)..
> your cache device if 3.8T, so to have a similar 12-13% of the cache
> you'd need to do 15x as much (90 mins if you're the same speed--- but
> your I/O subsystem is also much faster...)
> 
> If you're doing more like 3.8T of writes--  note that's not the same
> test.  (It will result in less contiguous stuff in the cache and it
> will be less repeatable / more volatile).

Hi Mike,

Your data set is too small. Normally bcache users I talk with, they use
bcache for distributed storage cluster or commercial data base, their
catch device is large and fast. It is possible we see different I/O
behaviors because we use different configurations.

I use a 3.8T cache, and test two conditions,
1, dirty data is around 2.1TB, stop front end write and observe
background writeback.
2, dirty data is around dirty target (in my test it was 305GB), then
stop front end writing and observe bacm ground writeback.

It spent a lot of time to get the dirty data ready, and then record
writeback rate and iostat output for hours. At the very beginning I can
see write merge number is high (even more then 110 wrqm/s as peak value
on single disk) but a few minutes later there is almost no write merge.

When there is write merge, bcache with/without your patch 4,5 both work
well. But when there is no write merge, bcache with/without your patch
4,5 both work badly. Even writback_rate_debug displays rate: 488.2M/sec,
real write throughput is 10MB/sec in total, that's 2~3MB/sec on each
hard disk, obviously the bottleneck is not on hard disk.

Right now I am collecting the last group data about bcache without your
patche 4,5 and has 2.1TB dirty data, then observe how background
writeback works.

The progress is slower than I expected, tomorrow morning I will get the
data. Hope 2 days later I may have an benchmark analysis to share.

I will update the result then, if I didn't do anything wrong during my
performance testing.

Coly Li

> On Sat, Sep 30, 2017 at 9:51 PM, Coly Li <i@coly.li> wrote:
>> On 2017/10/1 上午6:49, Michael Lyle wrote:
>>> One final attempt to resend, because gmail has been giving me trouble
>>> sending plain text mail.
>>>
>>> Two instances of this.  Tested as above, with a big set of random I/Os
>>> that ultimately cover every block in a file (e.g. allowing sequential
>>> writeback).
>>>
>>> With the 5 patches, samsung 940 SSD cache + crummy 5400 RPM USB hard drive:
>>>
>>> Typical seconds look like:
>>>
>>> Reading 38232K from cache in 4809 IO.  38232/4809=7.95k per cache device IO.
>>>
>>> Writing 38112k to cache in 400 I/O = 95.28k -- or we are combining
>>> about 11.9 extents to a contiguous writeback.  Tracing, there are
>>> still contiguous things that are not getting merged well, but it's OK.
>>> (I'm hoping plugging makes this better).
>>>
>>> sda            4809.00     38232.00       446.00      38232        446
>>> sdb             400.00         0.00     38112.00          0      38112
>>>
>>> Without the 5 patches, a typical second--
>>>
>>> sda            2509.00     19968.00       316.00      19968        316
>>> sdb             502.00         0.00     19648.00          0      38112
>>>
>>> or we are combining about 4.9 extents to a contiguous writeback, and
>>> writing back at about half the rate.  All of these numbers are +/- 10%
>>> and obtained by eyeballing and grabbing representative seconds.
>>>
>>> Mike


-- 
Coly Li
