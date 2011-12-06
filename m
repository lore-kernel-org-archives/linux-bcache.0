From: Bostjan Skufca <bostjan-CKT3X4mPfYE@public.gmane.org>
Subject: Re: Quick bcache benchmark
Date: Tue, 6 Dec 2011 15:10:40 +0100
Message-ID: <CAEp_DRDEQLSkJ3arx81qM1M4iSJ5Wy0dwZhsrYD=94682qw8JQ@mail.gmail.com>
References: <20111206082233.GA19390@moria>
	<CAEp_DRCHQo1JyPZk6dKYZjJvxtaR7yxpEDtGE+uYK9n2dNb2Pw@mail.gmail.com>
	<20111206115617.GA32759@moria>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111206115617.GA32759@moria>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Nice, 22k iops for random write is not bad at all (especially compared
to spinning disks:)
I have a couple of questions, can you please confirm that I am
understanding bcache correctly:
1. When you issue that many random write requests, they get written to
SSD first. Then they are slowly propagated from SSD to spinning disk,
right? In original order or is the order optimized?2. What about when
I unregister bcache from a device? Does it flush changes from SSD to
platter?3. Same question (2) for unmounting a drive?4. If machine
crashes, will bcache replay changes from SSD to platter at mount
time?5. Does it export a number of writes that are pending on SSD, via
some /proc or /sys interface?6. Is read cache hot or cold at boot
time?
I know that is an overkill for wording "couple of questions", sorry:)

b.


On 6 December 2011 12:56, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>
> On Tue, Dec 06, 2011 at 11:39:57AM +0100, Bostjan Skufca wrote:
> > Random write test?
>
> Sure.
>
> That corsair was giving me /terrible/ write performance, pulled the
> intel SSD out of my other machine (unregistered the cache from the
> backing device and attached the new SSD all without unmounting the
> filesystem :)
>
> Write performance with the intel is not /awesome/, but much more
> reasonable:
>
> root@utumno:/mnt# perf record -afg fio ~/rw4k
> randwrite: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dliba=
io, iodepth=3D64
> fio 1.59
> Starting 1 process
> Jobs: 1 (f=3D1): [w] [100.0% done] [0K/98365K /s] [0 /24.2K iops] [et=
a 00m:00s]
> randwrite: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1560
> =A0write: io=3D16384MB, bw=3D89547KB/s, iops=3D22386 , runt=3D187359m=
sec
> =A0cpu =A0 =A0 =A0 =A0 =A0: usr=3D3.94%, sys=3D14.82%, ctx=3D300435, =
majf=3D0, minf=3D19
> =A0IO depths =A0 =A0: 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.=
1%, 32=3D0.1%, >=3D64=3D100.0%
> =A0 =A0 submit =A0 =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
> =A0 =A0 complete =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.1%, >=3D64=3D0.0%
> =A0 =A0 issued r/w/d: total=3D0/4194367/0, short=3D0/0/0
>
>
>
> Run status group 0 (all jobs):
> =A0WRITE: io=3D16384MB, aggrb=3D89547KB/s, minb=3D91696KB/s, maxb=3D9=
1696KB/s, mint=3D187359msec, maxt=3D187359msec
>
> Disk stats (read/write):
> =A0bcache0: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D=
0.00%
>
> 8.97% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0fio =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 [.] 0xd1b2
> 1.64% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] bio_in=
sert =A0 =A0 =A0 =A0 =A0 =A0 =A0 <- first bcache function
> 1.56% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] __bloc=
kdev_direct_IO
> 1.24% =A0 =A0 kworker/1:2 =A0[kernel.kallsyms] =A0 [k] __bset_search
> 1.24% =A0 =A0 kworker/0:0 =A0[kernel.kallsyms] =A0 [k] __bset_search
> 1.19% =A0 =A0 =A0 =A0 swapper =A0[kernel.kallsyms] =A0 [k] ahci_inter=
rupt
> 1.17% =A0 =A0 kworker/0:1 =A0[kernel.kallsyms] =A0 [k] __bset_search
> 1.17% =A0 =A0 kworker/1:0 =A0[kernel.kallsyms] =A0 [k] __bset_search
> 1.09% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] system=
_call
> 1.06% =A0 =A0 kworker/0:2 =A0[kernel.kallsyms] =A0 [k] __bset_search
> 1.06% =A0 =A0 kworker/1:1 =A0[kernel.kallsyms] =A0 [k] __bset_search
> 1.04% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] ext4_e=
xt_find_extent
> 0.96% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] _raw_s=
pin_lock_irq
> 0.92% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] bcache=
_make_request
> 0.87% =A0 =A0 =A0 =A0 swapper =A0[kernel.kallsyms] =A0 [k] _raw_spin_=
lock_irqsave
> 0.85% =A0 =A0 =A0 =A0 swapper =A0[kernel.kallsyms] =A0 [k] mwait_idle
> 0.83% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] do_io_=
submit
> 0.77% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] memset
> 0.70% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] kmem_c=
ache_alloc
> 0.65% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] md5_tr=
ansform
> 0.63% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] _raw_s=
pin_lock_irqsave
> 0.61% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] _raw_s=
pin_lock
> 0.58% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] generi=
c_make_request
> 0.57% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0libaio.so.1.0.1 =A0 =A0 [.] 0x6b=
7
> 0.50% =A0 =A0 =A0 =A0 =A0 =A0 fio =A0[kernel.kallsyms] =A0 [k] gup_pt=
e_range
>
> haven't seen bio_insert() show up that high in a profile before, wond=
er
> what's up with that..
>
> Reran the random read benchmark with the intel:
>
> root@utumno:/mnt# perf record -afg fio ~/rw4k
> randwrite: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dlibai=
o, iodepth=3D64
> fio 1.59
> Starting 1 process
> Jobs: 1 (f=3D1): [r] [100.0% done] [190.9M/0K /s] [47.7K/0 =A0iops] [=
eta 00m:00s]
> randwrite: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1575
> =A0read : io=3D16384MB, bw=3D153120KB/s, iops=3D38279 , runt=3D109571=
msec
> =A0cpu =A0 =A0 =A0 =A0 =A0: usr=3D7.22%, sys=3D52.15%, ctx=3D678086, =
majf=3D0, minf=3D85
> =A0IO depths =A0 =A0: 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.=
1%, 32=3D0.1%, >=3D64=3D100.0%
> =A0 =A0 submit =A0 =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
> =A0 =A0 complete =A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.1%, >=3D64=3D0.0%
> =A0 =A0 issued r/w/d: total=3D4194367/0/0, short=3D0/0/0
>
>
>
> Run status group 0 (all jobs):
> =A0 READ: io=3D16384MB, aggrb=3D153119KB/s, minb=3D156794KB/s, maxb=3D=
156794KB/s, mint=3D109571msec, maxt=3D109571msec
>
> Disk stats (read/write):
> =A0bcache0: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D=
0.00%
>
> Basically, whatever hardware you have bcache will easily max it out.
