From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Tue, 10 Oct 2017 02:58:26 +0800
Message-ID: <058dc73f-a36f-c3c2-8dc3-833545979693@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li>
 <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
 <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li>
 <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
 <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li>
 <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
 <b654ae09-b9f1-295f-b45a-6688c7fa4e0d@suse.de>
 <CAJ+L6qf7NtkqKFbKsEjr8noqG94nPQnj1z3doMh10DYH-vMniw@mail.gmail.com>
 <CAJ+L6qdQG27JpDTPxPrgYgeVC8qq-hYHq85U1zHQJDUneT8trA@mail.gmail.com>
 <dca3c016-bb3f-7d8c-1509-f042628d7fd6@coly.li>
 <CAJ+L6qcY=_vTaqZDLvif_3pqwujo24NUZhGG9ebp6z5+uWqwQQ@mail.gmail.com>
 <33e52793-251d-ed58-fb59-5432946efb56@coly.li>
 <CAJ+L6qdnzocZRvcExwFBJPmVJnHWNJXY8j3NioUaekAp06QzXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:53892 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbdJIS6q (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Oct 2017 14:58:46 -0400
In-Reply-To: <CAJ+L6qdnzocZRvcExwFBJPmVJnHWNJXY8j3NioUaekAp06QzXg@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Hannes Reinecke <hare@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/10/7 上午2:36, Michael Lyle wrote:
> Sorry I missed this question:
> 
>> Is it the time from writeback starts to dirty reaches dirty target, or
>> the time from writeback starts to dirty reaches 0 ?
> 
> Not quite either.  I monitor the machine with zabbix; it's the time to
> when the backing disk reaches its background rate of activity / when
> writeback hits its minimum rate (writeback with the PI controller
> writes a little past the target because of the integral term).
> 
> Viewed one way: 5/80 is just a few percent of difference (6%).  But:
> I'm hopeful that further improvement can be made along this patch
> series, and in any event it's 5 minutes earlier that I/O will have an
> unencumbered response time after a pulse of load.

Hi Mike,

Finally, finally I finish all my test in the ideal situation which you
suggested to make dirty blocks to be contiguous better.

And it come to be clear why we had such a big difference in opinion: we
just looked at different part of a cow, you looked at tail, I looked at
head.

Here is the configurations I covered,
fio blocksize: 8kB, 16kB, 32kB, 64kB, 128kB, 256kB, 512kB, 1024kB
dirty data size:, 110GB, 500GB, 700GB
cache device size: 220GB, 1TB, 1.5TB, 1.8TB
cached device size: 1.8TB, 4TB, 7.2TB

(md linear is used to combine large device with multiple hard drives, so
large bio won't be split unless it goes across hard drive size boundary )

I don't test all the above combinations, my test cases are very limited
(still spent me several days), but most important ones are covered.

I use the following items to measure writeback performance:
- decreased dirty data amount (a.k.a throughput)
- writeback write requests per-second
- writeback write request merge numbers per-second

It turns out, in the ideal situation, bio reorder patches performance
drops if: 1) write I/O size increased 2) amount of dirty data increased

I do observe the perfect side of your patches, when I/O blocksize
<=256kB, I see great advantage of writeback performance when bio
reordered. Especially when blocksiz is 8K, writeback performance is 3x
at least (because without your patch the writeback is too slow and I
gave up after hours).

The performance regression happens when fio blocksize increased to 512K
and dirty data increased to 900GB. And when fio blocksize increased to
1MB and dirty data on cache increased to 900, writeback performance
regression becomes easily recognized.

An interesting behavior I observed is, for large blocksize and dirty
data, without bio reorder patches, writeback performance is much higher
than the bio reorder one. An example is,
http://blog.coly.li/wp-content/uploads/2017/10/writeback_throughput_on_linear_900_1800G_cache_half.png

The first 15 minutes, bcache without bio reorder performs much higher
than the reorder one. 15 minutes later, all the writeback rate decreased
to a similar level. That's said, most of the performance regression
happens at the beginning when writeback starts.

All the tests are under ideal situations, no writeback happens when fio
writes dirty data onto cache device. If in more generic situations when
less LBA contiguous dirty blocks on cache, I guess the writeback
regression might be more obvious.

When dirty blocks are not LBA contiguous on cache device, for small
dirty block size, I don't worry. Because you explained in previous
emails clearly, the worst case is the performance backing to the numbers
which has no bio reorder patch. But for large blocksize and large dirty
data, that's the common case when bcache is used for distributed
computing/storage systems like Ceph or Hadoop (multiple hard drives
attached to a large SSD cache, normally object file sizes are from 4MB
to 128MB).

Here is the command line I used to initialize bcache device:
#ake-bcache -B /dev/md0 -C /dev/nvme1n1p1
echo /dev/nvme1n1p1 > /sys/fs/bcache/register
echo /dev/md0 > /sys/fs/bcache/register
sleep 1
echo 0 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us
echo 0 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
echo writeback > /sys/block/bcache0/bcache/cache_mode
echo 0 > /sys/block/bcache0/bcache/writeback_running

After fio writes enough dirty data onto cache device, I write 1 into
writeback_runing.

Here is the fio job file I used,
[global]
direct=1
thread=1
ioengine=libaio

[job]
filename=/dev/bcache0
readwrite=randwrite
numjobs=1
blocksize=<test block size>
iodepth=256
size=<dirty data amount>

I see the writeback performance advantage in ideal situation, it is
desired :-) But I also worry about the performance regression for large
dirty block size and dirty data.

I raise a green flag to your bio reorder patches :-) I do hope I could
have seen such performance data at first time :P

*Last one question*: Could you please to consider an option to
enable/disable the bio reorder code in sysfs? It can be enabled as
default. When people cares about large dirty data size writeback, they
can choose to disable the bio reorder policy.

I hope we can get an agreement and make this patch move forward.

Thanks for your patience, and continuous following up the discussion.

-- 
Coly Li
