From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 20:20:32 +0800
Message-ID: <8c7574ae-f520-bb7b-a974-ad747f9555cf@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
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
 <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li>
 <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/10/6 下午6:42, Michael Lyle wrote:
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

Hi Mike,

This is how wars happend LOL :-)

> Do you even understand what you are trying to test?

When I read patch 4/5, I saw you mentioned 4KB writes:
"e.g. at "background" writeback of target rate = 8, it would not combine
two adjacent 4k writes and would instead seek the disk twice."

And when we talked about patch 5/5, you mentioned 1MB writes:
"- When writeback rate is medium, it does I/O more efficiently.  e.g.
if the current writeback rate is 10MB/sec, and there are two
contiguous 1MB segments, they would not presently be combined.  A 1MB
write would occur, then we would increase the delay counter by 100ms,
and then the next write would wait; this new code would issue 2 1MB
writes one after the other, and then sleep 200ms.  On a disk that does
150MB/sec sequential, and has a 7ms seek time, this uses the disk for
13ms + 7ms, compared to the old code that does 13ms + 7ms * 2.  This
is the difference between using 10% of the disk's I/O throughput and
13% of the disk's throughput to do the same work."

Then I assume the bio reorder patches should work well for write size
from 4KB to 1MB. Also I think "hmm, if the write size is smaller, there
will be less chance for dirty blocks to be contiguous on cached device",
then I choose 512KB.

Here is my command line to setup the bcache:

make-bcache -B <cached device> -C <cache device>
echo <cache device> > /sys/fs/bcache/register
echo <cached device> > /sys/fs/bcache/register
sleep 1
echo 0 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us
echo 0 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
echo writeback > /sys/block/bcache0/bcache/cache_mode
echo 0 > /sys/block/bcache0/bcache/writeback_running

Now writeback is disabled, I start to use fio to write dirty data on
cache device. The following is fio job file.
[global]
direct=1
thread=1
ioengine=libaio

[job]
filename=/dev/bcache0
readwrite=randwrite
numjobs=8
;blocksize=64k
blocksize=512k
;blocksize=1M
iodepth=128
size=3000G
time_based=1
;runtime=10m
ramp_time=4
gtod_reduce=1
randrepeat=1

ramp_time, gtod_reduce and randrepeat are what I copied from your fio
example.

Then I watch the dirty data amount, when the dirty increases to a target
number (half full example), I kill fio process.

Then I start writeback by
echo 1 > /sys/block/bcache0/bcache/writeback_running

and immediately run 2 bash scripts to collect performance data:
1) writeback_rate.sh
  while [ 1 ];do
        cat /sys/block/bcache0/bcache/writeback_rate_debug
        echo -e "\n\n"
        sleep 60
  done
2) iostat command line
  iostat -x 1 <cache device> <cached device> <more disks compose md
device> | tee iostat.log

The writeback rate debug information is collected every 1 minute, iostat
information is collected every 1 seconds. They are all dedicated disks
for testing, just raw disks without any file system.

Thanks.

Coly


> On Fri, Oct 6, 2017 at 3:36 AM, Coly Li <i@coly.li> wrote:
>> On 2017/10/6 下午5:20, Michael Lyle wrote:
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
