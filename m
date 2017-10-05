From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 01:38:38 +0800
Message-ID: <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
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
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
 <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li>
 <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/10/5 上午7:54, Michael Lyle wrote:
> Coly---
> 
> Thanks for running these tests.
> 

Hi Mike,

You provided very detailed information for the PI controller patch, make
me understand it better. As a return, I spend several days to test your
bio reorder patches, you are deserved :-)


> The change is expected to improve performance when the application
> writes to many adjacent blocks, out of order.  Many database workloads
> are like this.  My VM provisioning / installation / cleanup workloads
> have a lot of this, too.
> 

When you talk about an example of performance improvement, it can be
more easier to be understood with performance number. Like what I do for
you. We need to see the real data more than talk.

Maybe your above example is good for single VM, or database record
insert to single table. If multiple VMs installing or starting, or
multiple inserts to multiple databases or multiple tables, I don't know
whether your bio reorder patches still perform better.


> I believe that it really has nothing to do with how full the cache
> device is, or whether things are contiguous on the cache device.  It
> has to do with what proportion of the data is contiguous on the
> **backing device**.

Let me change to a more clear way to express: For a give size cache
device and cached device, more dirty data on cache device, it means more
probability for these dirty data to be contiguous on cached device. This
is another workload independent view to look at contiguous for dirty
blocks, because a randwrite fio does not generate the working data set
you specified in following example.

> 
> To get the best example of this from fio, the working set size, for
> write, needs to be less than half the size of the cache (otherwise,
> previous writebacks make "holes" in the middle of the data that will
> make things from being contiguous), but large enough to trigger
> writeback.  It may help in other circumstances, but the performance
> measurement will be much more random (it effectively depends on where
> the writeback cursor is in its cycle).
> 

Yes, I agree. But I am not able to understand a performance optimization
when its result is random. What I care about is, is your expected
working data set a common cases for bcache usage ? or will it help to
improve writeback performance in most of bcache usage ?

Current writeback percentage is in [0, 40%] and 10% as default. Then
your reorder patches might perform better when dirty data occupies
10%~50% cache device space. In my testing, writeback rate keeps maximum
number (488.2M/sec on my machine) and changes to minimum number
(4.0k/sec with PI controller) in 2 minutes when dirty number gets close
to dirty targe. I sample content of writeback_rate_debug file every 1
minute, here is the data:

rate:           488.2M/sec
dirty:          273.9G
target:         357.6G
proportional:   -2.0G
integral:       2.8G
change:         0.0k/sec
next io:        -1213ms



rate:           264.5M/sec
dirty:          271.8G
target:         357.6G
proportional:   -2.1G
integral:       2.3G
change:         -48.1M/sec
next io:        -2205ms



rate:           4.0k/sec
dirty:          270.7G
target:         357.6G
proportional:   -2.1G
integral:       1.8G
change:         0.0k/sec
next io:        1756ms

The writeback rate changes from maximum number to minimum number in 2
minutes, then wrteback rate will keep on 4.0k/sec, and from the
benchmark data there is little performance difference with/without bio
reorder patches. When cache device size is 232G, it spent 278 minutes
for dirty data decreased from full to target number. Before the 2
minutes window, writeback rate is always maximum number (delay in
read_dirty() is always 0), after the 2 minutes window, writeback rate is
always the minimum number. Therefore the ideal rate for your patch4,5
maybe only happens during the 2 minutes window. It does exist, but far
from enough as an optimization.

> I'm not surprised that peak writeback rate on very fast backing
> devices will probably be a little less-- we only try to writeback 64
> things at a time; and NCQ queue depths are 32 or so-- so across a
> parallel RAID0 installation the drives will not have their queues
> filled entirely already.  Waiting for blocks to be in order will make
> the queues even less full.  However, they'll be provided with I/O in
> LBA order, so presumably the IO utilization and latency will be better
> during this.  Plugging will magnify these effects-- it will write back
> faster when there's contiguous data and utilize the devices more
> efficiently,
> 

You need real performance data to support your opinion.

> We could add a tunable for the writeback semaphore size if it's
> desired to have more than 64 things in flight-- of course, we can't
> have too many because dirty extents are currently selected from a pool
> of maximum 500.

Maybe increases in_flight semaphore helps. But this is not what I
concerned from beginning. A typical cache device size should be around
20% of the backing cached device size, or maybe less. My concern is, in
such a configuration, is there enough contiguous dirty blocks that show
performance advantage by reordering them with a small delay before
issuing them out.

If this assumption does not exist, an optimization for such situation
does not help too much for real workload. This is why I require you to
show real performance data, not only explain the reordering idea is good
in "theory".

I do not agree with current reordering patches because I have the
following benchmark results, they tell me patch4,5 do not have
performance advantage in many cases and even there is performance
regression ...

1) When dirty data on cache device is full
1.1) cache device: 1TB NVMe SSD
     cached device: 1.8TB hard disk
- existing dirty data on cache device

http://blog.coly.li/wp-content/uploads/2017/10/existing_dirty_data_on_cache_single_disk_1T_full_cache.png
- writeback request merge number on hard disk

http://blog.coly.li/wp-content/uploads/2017/10/write_request_merge_single_disk_1T_full_cache.png
- writeback request numbers on hard disk

http://blog.coly.li/wp-content/uploads/2017/10/writeback_request_numbers_on_single_disk_1T_full_cache.png
- writeback throughput on hard disk

http://blog.coly.li/wp-content/uploads/2017/10/writeback_throughput_sampling_single_disk_1T_full_cache.png
  The above results are the best cases I observe, and they are good :-)
This is a laptop-alike configuration, I can see with bio reodering, more
writeback requests issued and merged, and it is even 2x faster than
current bcache code.

1.2) cache device: 232G NVMe SSD
     cached device: 232G SATA SSD
- existing dirty data on cache device

http://blog.coly.li/wp-content/uploads/2017/10/existing_dirty_data_on_cache_single_SATA_SSD_and_232G_full_cache.png
- writeback request merge number on SATA SSD

http://blog.coly.li/wp-content/uploads/2017/10/writeback_request_merge_numbers_on_SATA_SSD_232G_full_cache.png
- writeback request numbers on SATA SSD

http://blog.coly.li/wp-content/uploads/2017/10/writeback_request_numbers_on_SATA_SSD_232G_full_cache.png
- writeback throughput on SATA SSD

http://blog.coly.li/wp-content/uploads/2017/10/writeback_throughput_on_SATA_SSD_232G_full_cache.png
You may say in the above configuration, if backing device is fast
enough, there is almost no difference with/without the bio reordering
patches. (I still don't know the reason why with the bio reordering
patches, writeback rate decreases faster then current bcache code when
dirty percentage gets close to dirty target.)

1.3) cache device: 1T NVMe SSD
     cached device: 1T md raid5 composed by 4 hard disks
- existing dirty data on cache device

http://blog.coly.li/wp-content/uploads/2017/10/existing_dirty_data_on_SSD_raid5_as_backing_and_1T_cache_full.png
- writeback throughput on md raid5

http://blog.coly.li/wp-content/uploads/2017/10/writeback_throughput_sampling_raid5_1T_cache_full.png
  The testing is incomplete. It is very slow, dirty data decreases 150MB
in 2 hours, still far from dirty targe. It should take more than 8 hours
to reach dirty target, so I only record first 25% data and give up. It
seems at first the bio reorder patches is a little slower, but around 55
minutes later, it starts to be faster than current bcache code, and when
I stop the test on 133 minutes, bio reorder patches has 50MB less dirty
data on cache device. At least bio reorder patches are not bad :-) But
complete such testing needs 16 hours at least, I give up.
  I also observe similar performance behavior on md raid0 composed by 4
hard disks, give up after 2+ hours too.

2) when dirty data on cache device is close to dirty target
1.1) cache device: 3.4TB NVMe SSD
     cached device: 7.2TB md raid0 by 4 hard disks
- read dirty requests on NVMe SSD

http://blog.coly.li/wp-content/uploads/2017/10/read_dirty_requests_on_SSD_small_data_set.png
- read dirty throughput on NVMe SSD

http://blog.coly.li/wp-content/uploads/2017/10/read_dirty_throughput_on_SSD_small_set.png
  I mentioned these performance number in previous email, when dirty
data gets close to dirty target, writeback rate drops from maximum
number to minimum number in 2 minutes, then almost no performance
diference with/without the bio reorder patches. It is interesting that
without bio reordering patches, in my test the read dirty requests are
even faster. It only happens in several minutes, so not a big issue.

3) when dirty data on cache device occupies 50% cache space
3.1) cache device: 1.8TB NVMe SSD
     cached device: 3.6TB md linear device composed by 2 hard disks
     dirty data occupies 900G on cache before writeback starts
- existing dirty data on cache devcie

- writeback request merge number on hard disks

http://blog.coly.li/wp-content/uploads/2017/10/writeback_request_merge_number_on_linear_900_1800G_cache_half.png
- writeback request number on hard disks

http://blog.coly.li/wp-content/uploads/2017/10/writeback_request_number_on_linear_900_1800G_cache_half.png
- writeback throughput on hard disks

http://blog.coly.li/wp-content/uploads/2017/10/writeback_throughput_on_linear_900_1800G_cache_half.png
  In this test, without bio reorder patches, writeback throughput is
much faster, you may see the write request number and request merge
number are also much faster then bio reorder patches. After around 10
minutes later, there is no obvious performance difference with/without
the bio reorder patches. Therefore in this test, with bio reorder
patches, I observe a worse writeback performance result.

The above tests tell me, to get a better writeback performance with bio
reorder patches, a specific situation is required (many contiguous dirty
data on cache device), this situation can only happen in some specific
of work loads. In general writeback situations, reordering bios by
waiting does not have significant performance advantage, and even
performance regression is observed.

Maybe I am wrong, but you need to provide more positive performance
numbers of more generic workloads as evidence in further discussion.

Thanks.

-- 
Coly Li
