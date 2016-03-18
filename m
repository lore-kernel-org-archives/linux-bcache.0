From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Testing bcachefs - beginners questions
Date: Fri, 18 Mar 2016 19:02:55 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603181857450.16487@mail.ewheeler.net>
References: <20160318041551.GA7889@kmo-pixel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:34688 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750946AbcCRTDI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 18 Mar 2016 15:03:08 -0400
In-Reply-To: <20160318041551.GA7889@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>, linux-bcache@vger.kernel.org

On Thu, 17 Mar 2016, Kent Overstreet wrote:
> since the announcement. I'm gonna have to write some more documentation and do
> another announcement soon.
> 
> One thing to note if you're running benchmarks is that data checksumming is on
> by default - it doesn't hurt most stuff noticably, but small random reads where
> your read size is smaller than the checksum granularity (typically the size of
> the writes you issued) will suck because it'll have to bounce and read the
> entire chunk of data the checksum covered.
> 
> Benchmark wise, here's a dio append benchmark I ran the other day:
> 
> Summary:
> bcachefs:       1749.1 MB/s
> ext4:           513.6 MB/s
> xfs:            515.7 MB/s
> btrfs:          531.2 MB/s

Wow, that is incredible.  For an upper limit on the extX filesystem line, 
would you run a benchmark on your hardware for ext2 or ext4 without 
journal?

How do you handle sync's?  It seems like most other filesystems suffer in 
their synchronous mechanisms (fsync, fdatasync) and end up trading 
performance for integrity.

Do you have documentation on the crash recovery mechanism, too?  I am 
curious how crash recovery works with respect to sync operations.

-Eric

> 
> ******** Running benchmark /root/benches/dio-appends.sh
> 
> ******** bcache:
> dio-append: (g=0): rw=write, bs=4K-256K/4K-256K/4K-256K, ioengine=libaio, iodepth=1
> ...
> fio-2.6
> Starting 64 processes
> 
> dio-append: (groupid=0, jobs=64): err= 0: pid=3832: Mon Mar  7 19:54:34 2016
>   write: io=32761MB, bw=1749.1MB/s, iops=14317, runt= 18721msec
>     slat (usec): min=33, max=99502, avg=4453.08, stdev=2949.39
>     clat (usec): min=0, max=339, avg= 1.55, stdev= 2.01
>      lat (usec): min=34, max=99504, avg=4456.19, stdev=2949.56
>     clat percentiles (usec):
>      |  1.00th=[    1],  5.00th=[    1], 10.00th=[    1], 20.00th=[    1],
>      | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    2],
>      | 70.00th=[    2], 80.00th=[    2], 90.00th=[    2], 95.00th=[    2],
>      | 99.00th=[    3], 99.50th=[    4], 99.90th=[   11], 99.95th=[   30],
>      | 99.99th=[   96]
>     bw (KB  /s): min=21833, max=32670, per=1.57%, avg=28048.70, stdev=1457.81
>     lat (usec) : 2=54.76%, 4=44.52%, 10=0.57%, 20=0.08%, 50=0.03%
>     lat (usec) : 100=0.03%, 250=0.01%, 500=0.01%
>   cpu          : usr=0.34%, sys=1.72%, ctx=598702, majf=0, minf=880
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=268032/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>   WRITE: io=32761MB, aggrb=1749.1MB/s, minb=1749.1MB/s, maxb=1749.1MB/s, mint=18721msec, maxt=18721msec
> 
> Disk stats (read/write):
>   rssda: ios=17/582983, merge=0/105212, ticks=10/1548520, in_queue=1550910, util=97.94%
> 
> ******** ext4:
> dio-append: (g=0): rw=write, bs=4K-256K/4K-256K/4K-256K, ioengine=libaio, iodepth=1
> ...
> fio-2.6
> Starting 64 processes
> 
> dio-append: (groupid=0, jobs=64): err= 0: pid=3918: Mon Mar  7 19:55:39 2016
>   write: io=32761MB, bw=525943KB/s, iops=4202, runt= 63785msec
>     slat (usec): min=61, max=60044, avg=15209.43, stdev=5451.60
>     clat (usec): min=0, max=87, avg= 0.83, stdev= 0.58
>      lat (usec): min=62, max=60046, avg=15210.80, stdev=5451.62
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    1],
>      | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    1],
>      | 70.00th=[    1], 80.00th=[    1], 90.00th=[    1], 95.00th=[    1],
>      | 99.00th=[    2], 99.50th=[    2], 99.90th=[    8], 99.95th=[    8],
>      | 99.99th=[   11]
>     bw (KB  /s): min= 5299, max=10240, per=1.56%, avg=8228.68, stdev=565.95
>     lat (usec) : 2=98.66%, 4=1.12%, 10=0.20%, 20=0.01%, 50=0.01%
>     lat (usec) : 100=0.01%
>   cpu          : usr=0.06%, sys=0.11%, ctx=273881, majf=0, minf=754
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=268032/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>   WRITE: io=32761MB, aggrb=525942KB/s, minb=525942KB/s, maxb=525942KB/s, mint=63785msec, maxt=63785msec
> 
> Disk stats (read/write):
>   rssda: ios=206/403691, merge=0/1246, ticks=3100/6279220, in_queue=6284330, util=99.88%
> 
> ******** xfs:
> dio-append: (g=0): rw=write, bs=4K-256K/4K-256K/4K-256K, ioengine=libaio, iodepth=1
> ...
> fio-2.6
> Starting 64 processes
> 
> dio-append: (groupid=0, jobs=64): err= 0: pid=4005: Mon Mar  7 19:56:43 2016
>   write: io=32761MB, bw=528170KB/s, iops=4219, runt= 63516msec
>     slat (usec): min=12, max=398, avg=48.88, stdev=14.56
>     clat (usec): min=40, max=54468, avg=15107.79, stdev=6083.06
>      lat (usec): min=76, max=54553, avg=15156.94, stdev=6086.18
>     clat percentiles (usec):
>      |  1.00th=[ 2544],  5.00th=[ 4704], 10.00th=[ 6816], 20.00th=[ 9792],
>      | 30.00th=[11712], 40.00th=[13504], 50.00th=[15168], 60.00th=[16768],
>      | 70.00th=[18560], 80.00th=[20352], 90.00th=[23168], 95.00th=[24704],
>      | 99.00th=[28288], 99.50th=[30592], 99.90th=[35072], 99.95th=[36096],
>      | 99.99th=[42752]
>     bw (KB  /s): min= 6166, max=10827, per=1.56%, avg=8264.22, stdev=490.87
>     lat (usec) : 50=0.01%, 100=0.01%, 250=0.01%, 500=0.01%, 750=0.01%
>     lat (usec) : 1000=0.03%
>     lat (msec) : 2=0.40%, 4=3.24%, 10=17.37%, 20=56.64%, 50=22.31%
>     lat (msec) : 100=0.01%
>   cpu          : usr=0.08%, sys=0.34%, ctx=270879, majf=0, minf=776
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=268032/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>   WRITE: io=32761MB, aggrb=528170KB/s, minb=528170KB/s, maxb=528170KB/s, mint=63516msec, maxt=63516msec
> 
> Disk stats (read/write):
>   rssda: ios=64/400943, merge=0/269, ticks=860/6368640, in_queue=6380330, util=99.94%
> 
> ******** btrfs:
> dio-append: (g=0): rw=write, bs=4K-256K/4K-256K/4K-256K, ioengine=libaio, iodepth=1
> ...
> fio-2.6
> Starting 64 processes
> 
> dio-append: (groupid=0, jobs=64): err= 0: pid=4146: Mon Mar  7 19:57:45 2016
>   write: io=32761MB, bw=543980KB/s, iops=4346, runt= 61670msec
>     slat (usec): min=104, max=71886, avg=14715.33, stdev=7480.34
>     clat (usec): min=0, max=444, avg= 1.21, stdev= 2.34
>      lat (usec): min=109, max=71888, avg=14717.45, stdev=7480.33
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[    1], 10.00th=[    1], 20.00th=[    1],
>      | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    1],
>      | 70.00th=[    1], 80.00th=[    1], 90.00th=[    2], 95.00th=[    2],
>      | 99.00th=[    2], 99.50th=[    3], 99.90th=[   14], 99.95th=[   23],
>      | 99.99th=[   89]
>     bw (KB  /s): min= 5235, max=10191, per=1.56%, avg=8511.05, stdev=534.02
>     lat (usec) : 2=82.55%, 4=17.04%, 10=0.25%, 20=0.09%, 50=0.05%
>     lat (usec) : 100=0.01%, 250=0.01%, 500=0.01%
>   cpu          : usr=0.08%, sys=0.29%, ctx=289158, majf=0, minf=834
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=268032/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>   WRITE: io=32761MB, aggrb=543980KB/s, minb=543980KB/s, maxb=543980KB/s, mint=61670msec, maxt=61670msec
> 
