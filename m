From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Quick bcache benchmark
Date: Tue, 6 Dec 2011 03:56:17 -0800
Message-ID: <20111206115617.GA32759@moria>
References: <20111206082233.GA19390@moria>
 <CAEp_DRCHQo1JyPZk6dKYZjJvxtaR7yxpEDtGE+uYK9n2dNb2Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAEp_DRCHQo1JyPZk6dKYZjJvxtaR7yxpEDtGE+uYK9n2dNb2Pw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bostjan Skufca <bostjan-CKT3X4mPfYE@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Dec 06, 2011 at 11:39:57AM +0100, Bostjan Skufca wrote:
> Random write test?

Sure.

That corsair was giving me /terrible/ write performance, pulled the
intel SSD out of my other machine (unregistered the cache from the
backing device and attached the new SSD all without unmounting the
filesystem :)

Write performance with the intel is not /awesome/, but much more
reasonable:

root@utumno:/mnt# perf record -afg fio ~/rw4k 
randwrite: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio 1.59
Starting 1 process
Jobs: 1 (f=1): [w] [100.0% done] [0K/98365K /s] [0 /24.2K iops] [eta 00m:00s]
randwrite: (groupid=0, jobs=1): err= 0: pid=1560
  write: io=16384MB, bw=89547KB/s, iops=22386 , runt=187359msec
  cpu          : usr=3.94%, sys=14.82%, ctx=300435, majf=0, minf=19
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=0/4194367/0, short=0/0/0



Run status group 0 (all jobs):
  WRITE: io=16384MB, aggrb=89547KB/s, minb=91696KB/s, maxb=91696KB/s, mint=187359msec, maxt=187359msec

Disk stats (read/write):
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

8.97%             fio  fio                 [.] 0xd1b2
1.64%             fio  [kernel.kallsyms]   [k] bio_insert		<- first bcache function
1.56%             fio  [kernel.kallsyms]   [k] __blockdev_direct_IO
1.24%     kworker/1:2  [kernel.kallsyms]   [k] __bset_search
1.24%     kworker/0:0  [kernel.kallsyms]   [k] __bset_search
1.19%         swapper  [kernel.kallsyms]   [k] ahci_interrupt
1.17%     kworker/0:1  [kernel.kallsyms]   [k] __bset_search
1.17%     kworker/1:0  [kernel.kallsyms]   [k] __bset_search
1.09%             fio  [kernel.kallsyms]   [k] system_call
1.06%     kworker/0:2  [kernel.kallsyms]   [k] __bset_search
1.06%     kworker/1:1  [kernel.kallsyms]   [k] __bset_search
1.04%             fio  [kernel.kallsyms]   [k] ext4_ext_find_extent
0.96%             fio  [kernel.kallsyms]   [k] _raw_spin_lock_irq
0.92%             fio  [kernel.kallsyms]   [k] bcache_make_request
0.87%         swapper  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
0.85%         swapper  [kernel.kallsyms]   [k] mwait_idle
0.83%             fio  [kernel.kallsyms]   [k] do_io_submit
0.77%             fio  [kernel.kallsyms]   [k] memset
0.70%             fio  [kernel.kallsyms]   [k] kmem_cache_alloc
0.65%             fio  [kernel.kallsyms]   [k] md5_transform
0.63%             fio  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
0.61%             fio  [kernel.kallsyms]   [k] _raw_spin_lock
0.58%             fio  [kernel.kallsyms]   [k] generic_make_request
0.57%             fio  libaio.so.1.0.1     [.] 0x6b7
0.50%             fio  [kernel.kallsyms]   [k] gup_pte_range

haven't seen bio_insert() show up that high in a profile before, wonder
what's up with that..

Reran the random read benchmark with the intel:

root@utumno:/mnt# perf record -afg fio ~/rw4k 
randwrite: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=64
fio 1.59
Starting 1 process
Jobs: 1 (f=1): [r] [100.0% done] [190.9M/0K /s] [47.7K/0  iops] [eta 00m:00s]
randwrite: (groupid=0, jobs=1): err= 0: pid=1575
  read : io=16384MB, bw=153120KB/s, iops=38279 , runt=109571msec
  cpu          : usr=7.22%, sys=52.15%, ctx=678086, majf=0, minf=85
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued r/w/d: total=4194367/0/0, short=0/0/0



Run status group 0 (all jobs):
   READ: io=16384MB, aggrb=153119KB/s, minb=156794KB/s, maxb=156794KB/s, mint=109571msec, maxt=109571msec

Disk stats (read/write):
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Basically, whatever hardware you have bcache will easily max it out.
