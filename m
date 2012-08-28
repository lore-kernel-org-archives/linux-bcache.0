From: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: Re: Simple benchmark results
Date: Tue, 28 Aug 2012 07:53:31 -0400
Message-ID: <CAB7K1hH7kFNaikxbW4u6eJegEak+iZqNQzboJF3iwsJEcqGHJw@mail.gmail.com>
References: <CAB7K1hEWeR3DSQFFN1jqm-rgsMaZqxuVdjBVFs5MuBeQwdijSQ@mail.gmail.com>
	<CAOzFzEhjxJqyRwjstdPXwBUMQYNxT9rO1SZpjGd8Pc=n1i4YZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEhjxJqyRwjstdPXwBUMQYNxT9rO1SZpjGd8Pc=n1i4YZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Aug 26, 2012 at 2:40 PM, Joseph Glanville
<joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org> wrote:
> On 27 August 2012 03:59, David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org> wrote:
>> I've been running bcache on my devel machine, and inspired by the new
>> write-up on the bcache wiki, decided to do some simple benchmarking to
>> see if I could put some numbers to the performance benefit I see on my
>> PC.
>>
>> I decided to test the various cache modes using fio, and since I use
>> postgresql a bit, pgbench (using both postgresql 9.1 & 9.2). I have no
>> particular skill with regard to benchmarking, so perhaps I've screwed
>> something up, but I was a bit surprised by the numbers.
>>
>> With pgbench (which is primarily writes) writeback mode was the
>> decisive winner, as expected. I saw little difference between the
>> other modes, including cache mode "none".
>>
>> With fio (using the parameters specified on the wiki), cache mode None
>> produced the highest IOps & throughput.
>>
>> Does that make sense? Why would cache mode none be comparable to any
>> of the other modes?
>>
>> ## Environment ##
>>
>> Linux zapazoid 3.5.0+ #1 SMP Sat Aug 25 12:42:26 EDT 2012 x86_64 GNU/Linux
>>
>> /dev/mapper/vg0-pg_base on /var/lib/postgresql/9.1/main/base type ext4
>> (rw,relatime)
>> /dev/mapper/vg0-pg_xlog on /var/lib/postgresql/9.1/main/pg_xlog type
>> ext4 (rw,relatime)
>> /dev/mapper/vg0-home on /home type ext4 (rw,relatime)
>>
>> Hardware:
>>
>> Phenom II X6
>> 8GB RAM
>> 7200 RPM 320GB HDD
>> OCZ Vertex 3 64GB SSD
>>
>>
>> Benchmark Script:
>>
>> #!/bin/sh
>>
>> outfile=bcache_bench-results.txt
>> pg_bin=/usr/lib/postgresql/9.2/bin/
>>
>> for cm in writethrough writeback writearound none; do
>>   echo $cm > /sys/block/sda/sda2/bcache/cache_mode
>>   cat /sys/block/sda/sda2/bcache/cache_mode
>>   echo
>>   # fio benchmark
>>   echo "Running fio with bcache in mode: $cm"
>>   cat ./bcache.fio
>>   fio ./bcache.fio
>>   echo
>>
>>   # pgbench benchmark
>>   # First pg 9.1, then 9.2
>>   for p in 5432 5433; do
>>     if [ "$p" = 5432 ]; then
>>       version=9.1
>>     else
>>       version=9.2
>>     fi
>>     echo "Running pgbench against postgresql $version, with bcache in mode: $cm"
>>     su - postgres <<EOF
>>     "${pg_bin}psql" -p $p -c 'create database pg_bench_db;'
>>     "${pg_bin}pgbench" -p $p -i -s 10 -c 10 -T 300 pg_bench_db
>>     "${pg_bin}pgbench" -p $p   -s 10 -c 10 -T 300 pg_bench_db
>>     "${pg_bin}psql" -p $p -c 'drop database pg_bench_db;'
>> EOF
>>   done
>> done| tee "$outfile"
>>
>> Fio version: 2.0.8
>>
>> Fio config:
>>
>> [test]
>> randrepeat=1
>> ioengine=libaio
>> bs=4k
>> ba=4k
>> size=8G
>> direct=1
>> gtod_reduce=1
>> norandommap
>> iodepth=32
>>
>>
>>
>> ## Results ##
>>
>>
>> [writethrough] writeback writearound none
>>
>> Running fio with bcache in mode: writethrough
>> [test]
>> randrepeat=1
>> ioengine=libaio
>> bs=4k
>> ba=4k
>> size=8G
>> direct=1
>> gtod_reduce=1
>> norandommap
>> iodepth=32
>> test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
>> 2.0.8
>> Starting 1 process
>>
>> test: (groupid=0, jobs=1): err= 0: pid=12901
>>   read : io=8192.0MB, bw=31633KB/s, iops=7908 , runt=265183msec
>>   cpu          : usr=5.27%, sys=29.96%, ctx=1932374, majf=0, minf=52
>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>>      issued    : total=r=2097152/w=0/d=0, short=r=0/w=0/d=0
>>
>> Run status group 0 (all jobs):
>>    READ: io=8192.0MB, aggrb=31633KB/s, minb=31633KB/s, maxb=31633KB/s,
>> mint=265183msec, maxt=265183msec
>>
>> Disk stats (read/write):
>>     dm-3: ios=2095437/238, merge=0/0, ticks=8387259/33094,
>> in_queue=8420690, util=100.00%, aggrios=0/0, aggrmerge=0/0,
>> aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>>   bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>>
>> Running pgbench against postgresql 9.1, with bcache in mode: writethrough
>> CREATE DATABASE
>> transaction type: TPC-B (sort of)
>> scaling factor: 10
>> query mode: simple
>> number of clients: 10
>> number of threads: 1
>> duration: 300 s
>> number of transactions actually processed: 266049
>> tps = 884.810200 (including connections establishing)
>> tps = 884.964389 (excluding connections establishing)
>> DROP DATABASE
>> Running pgbench against postgresql 9.2, with bcache in mode: writethrough
>> CREATE DATABASE
>> transaction type: TPC-B (sort of)
>> scaling factor: 10
>> query mode: simple
>> number of clients: 10
>> number of threads: 1
>> duration: 300 s
>> number of transactions actually processed: 275057
>> tps = 916.809784 (including connections establishing)
>> tps = 916.991406 (excluding connections establishing)
>> DROP DATABASE
>> writethrough [writeback] writearound none
>>
>> Running fio with bcache in mode: writeback
>> [test]
>> randrepeat=1
>> ioengine=libaio
>> bs=4k
>> ba=4k
>> size=8G
>> direct=1
>> gtod_reduce=1
>> norandommap
>> iodepth=32
>> test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
>> 2.0.8
>> Starting 1 process
>>
>> test: (groupid=0, jobs=1): err= 0: pid=13069
>>   read : io=8192.0MB, bw=35757KB/s, iops=8939 , runt=234599msec
>>   cpu          : usr=5.34%, sys=29.18%, ctx=2039126, majf=0, minf=51
>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>>      issued    : total=r=2097152/w=0/d=0, short=r=0/w=0/d=0
>>
>> Run status group 0 (all jobs):
>>    READ: io=8192.0MB, aggrb=35757KB/s, minb=35757KB/s, maxb=35757KB/s,
>> mint=234599msec, maxt=234599msec
>>
>> Disk stats (read/write):
>>     dm-3: ios=2095690/75, merge=0/0, ticks=7433820/106,
>> in_queue=7434173, util=100.00%, aggrios=0/0, aggrmerge=0/0,
>> aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>>   bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>>
>> Running pgbench against postgresql 9.1, with bcache in mode: writeback
>> CREATE DATABASE
>> transaction type: TPC-B (sort of)
>> scaling factor: 10
>> query mode: simple
>> number of clients: 10
>> number of threads: 1
>> duration: 300 s
>> number of transactions actually processed: 675318
>> tps = 2250.938899 (including connections establishing)
>> tps = 2251.295253 (excluding connections establishing)
>> DROP DATABASE
>> Running pgbench against postgresql 9.2, with bcache in mode: writeback
>> CREATE DATABASE
>> transaction type: TPC-B (sort of)
>> scaling factor: 10
>> query mode: simple
>> number of clients: 10
>> number of threads: 1
>> duration: 300 s
>> number of transactions actually processed: 823609
>> tps = 2741.663194 (including connections establishing)
>> tps = 2742.135127 (excluding connections establishing)
>> DROP DATABASE
>> writethrough writeback [writearound] none
>>
>> Running fio with bcache in mode: writearound
>> [test]
>> randrepeat=1
>> ioengine=libaio
>> bs=4k
>> ba=4k
>> size=8G
>> direct=1
>> gtod_reduce=1
>> norandommap
>> iodepth=32
>> test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
>> 2.0.8
>> Starting 1 process
>>
>> test: (groupid=0, jobs=1): err= 0: pid=13226
>>   read : io=8192.0MB, bw=33949KB/s, iops=8487 , runt=247091msec
>>   cpu          : usr=5.47%, sys=32.60%, ctx=1961342, majf=0, minf=51
>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>>      issued    : total=r=2097152/w=0/d=0, short=r=0/w=0/d=0
>>
>> Run status group 0 (all jobs):
>>    READ: io=8192.0MB, aggrb=33949KB/s, minb=33949KB/s, maxb=33949KB/s,
>> mint=247091msec, maxt=247091msec
>>
>> Disk stats (read/write):
>>     dm-3: ios=2094874/58, merge=0/0, ticks=7816729/4730,
>> in_queue=7821618, util=100.00%, aggrios=0/0, aggrmerge=0/0,
>> aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>>   bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>>
>> Running pgbench against postgresql 9.1, with bcache in mode: writearound
>> CREATE DATABASE
>> transaction type: TPC-B (sort of)
>> scaling factor: 10
>> query mode: simple
>> number of clients: 10
>> number of threads: 1
>> duration: 300 s
>> number of transactions actually processed: 264464
>> tps = 881.501731 (including connections establishing)
>> tps = 881.650022 (excluding connections establishing)
>> DROP DATABASE
>> Running pgbench against postgresql 9.2, with bcache in mode: writearound
>> CREATE DATABASE
>> transaction type: TPC-B (sort of)
>> scaling factor: 10
>> query mode: simple
>> number of clients: 10
>> number of threads: 1
>> duration: 300 s
>> number of transactions actually processed: 283804
>> tps = 945.962582 (including connections establishing)
>> tps = 946.128733 (excluding connections establishing)
>> DROP DATABASE
>> writethrough writeback writearound [none]
>>
>> Running fio with bcache in mode: none
>> [test]
>> randrepeat=1
>> ioengine=libaio
>> bs=4k
>> ba=4k
>> size=8G
>> direct=1
>> gtod_reduce=1
>> norandommap
>> iodepth=32
>> test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
>> 2.0.8
>> Starting 1 process
>>
>> test: (groupid=0, jobs=1): err= 0: pid=13367
>>   read : io=8192.0MB, bw=37969KB/s, iops=9492 , runt=220931msec
>>   cpu          : usr=5.99%, sys=29.32%, ctx=1992824, majf=0, minf=51
>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>>      issued    : total=r=2097152/w=0/d=0, short=r=0/w=0/d=0
>>
>> Run status group 0 (all jobs):
>>    READ: io=8192.0MB, aggrb=37969KB/s, minb=37969KB/s, maxb=37969KB/s,
>> mint=220931msec, maxt=220931msec
>>
>> Disk stats (read/write):
>>     dm-3: ios=2096590/41, merge=0/0, ticks=6995926/4349,
>> in_queue=7000464, util=100.00%, aggrios=0/0, aggrmerge=0/0,
>> aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>>   bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>>
>> Running pgbench against postgresql 9.1, with bcache in mode: none
>> CREATE DATABASE
>> transaction type: TPC-B (sort of)
>> scaling factor: 10
>> query mode: simple
>> number of clients: 10
>> number of threads: 1
>> duration: 300 s
>> number of transactions actually processed: 265415
>> tps = 884.688970 (including connections establishing)
>> tps = 884.861368 (excluding connections establishing)
>> DROP DATABASE
>> Running pgbench against postgresql 9.2, with bcache in mode: none
>> CREATE DATABASE
>> transaction type: TPC-B (sort of)
>> scaling factor: 10
>> query mode: simple
>> number of clients: 10
>> number of threads: 1
>> duration: 300 s
>> number of transactions actually processed: 282727
>> tps = 942.373702 (including connections establishing)
>> tps = 942.546713 (excluding connections establishing)
>> DROP DATABASE
>>
>>
>>
>
> Hmm cache mode none shouldn't do that from my experiences...
>
> You could you try turning up the number of jobs?
> ie: numjobs=16 or something
> Also I find bcache prefers higher queue depths (on the order of 64 or 128)
>

Well, it seems that there are some differences between fio 1.59 (used
for the benchmark on the wiki), and 2.0.8, or the given job file is
incomplete. For one, fio 2.0.8 won't run with just a global section.
Also, it apparently doesn't do read/write by default.

I was missing the obvious fact that in my test above, only reads were
being performed. I don't know why writethrough and writearound did so
poorly, but it explains writeback.

So, I modified my benchmark a bit. My purpose is not to show the
extremes of bcache performance (high queue depths), but to capture a
more realistic picture of the performance gains it provides on my
machine, vs my standard HDD. I can't justify the cost of a large SSD,
so comparison of bcache vs SSD-only holds little practical interest
for me.

So, my modified jobfile:

[global]
# This is intended to be a VERY rough approximation of
# Anandtech's Storage bench - Heavy workload, which uses
# the following IO distribution:
#
# IO Size	 % of Total
# -------	 ----------
# 4KB	 		28%
# 16KB	 		10%
# 32KB	 		10%
# 64KB	 		4%
# Additionally: "Only 42% of all operations are sequential,
#                the rest range from pseudo to fully random
#                (with most falling in the pseudo-random
#                category). Average queue depth is 4.625 IOs,
#                with 59% of operations taking place in an IO
#                queue of 1."
#
#
ioengine=libaio
# Aggregate all job stats
group_reporting=1
iodepth=2   # Group total is iodepth * total jobs (I think)
blockalign=4k
norandommap=1
gtod_reduce=1
direct=1
rwmixread=60 # Skew toward read performance - it's a desktop.
# Same location as pgbench
directory=/var/lib/postgresql/9.1/main/base

# Sequential IO (~40% => 3/8 jobs)

[sequential-16k]
readwrite=rw
bs=16k
size=1G

[sequential-32k]
readwrite=rw
bs=32k
size=1G

[sequential-randk]
readwrite=rw
blocksize_range=64k-4096k
size=1G
direct=1

# Random IO (~%60 => 5/8 jobs)

[random-4k]
readwrite=randrw
randrepeat=1
numjobs=3
bs=4k
size=1G
direct=1

[random-randk]
readwrite=randrw
randrepeat=1
numjobs=2
blocksize_range=32k-256k
size=2G


Bench script:

#!/bin/sh

TEST_FIO=1
TEST_PGBENCH=

LOAD_LEVEL=medium  # Selects fio definition file: bcache-${LOAD_LEVEL}.fio

outfile=bcache_bench-results.txt
pg_bin=/usr/lib/postgresql/9.2/bin/

# Test all bcache cache modes
for cm in writethrough writeback writearound none; do
  echo $cm > /sys/block/sda/sda2/bcache/cache_mode
  cat /sys/block/sda/sda2/bcache/cache_mode
  echo
  if [ -n "$TEST_FIO" ]; then
    # fio benchmark
    echo "Running fio with ${LOAD_LEVEL} config, and bcache in mode: $cm"
    fio ./bcache-${LOAD_LEVEL}.fio
    echo
  fi

  if [ -n "$TEST_PGBENCH" ]; then
    # pgbench benchmark
    # First pg 9.1, then 9.2
    for p in 5432 5433; do
      if [ "$p" = 5432 ]; then
	version=9.1
      else
	version=9.2
      fi
      echo "Running pgbench against postgresql $version, with bcache
in mode: $cm"
      su - postgres <<EOF
      "${pg_bin}psql" -p $p -c 'create database pg_bench_db;'
      "${pg_bin}pgbench" -p $p -i -s 10 -c 10 -T 300 pg_bench_db
      "${pg_bin}pgbench" -p $p   -s 10 -c 10 -T 300 pg_bench_db
      "${pg_bin}psql" -p $p -c 'drop database pg_bench_db;'
EOF
    done
  fi
done| tee "$outfile"


The results:


[writethrough] writeback writearound none

Running fio with medium config, and bcache in mode: writethrough
sequential-16k: (g=0): rw=rw, bs=16K-16K/16K-16K, ioengine=libaio, iodepth=2
sequential-32k: (g=0): rw=rw, bs=32K-32K/32K-32K, ioengine=libaio, iodepth=2
sequential-randk: (g=0): rw=rw, bs=64K-4M/64K-4M, ioengine=libaio, iodepth=2
random-4k: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=2
...
random-4k: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=2
random-randk: (g=0): rw=randrw, bs=32K-256K/32K-256K, ioengine=libaio, iodepth=2
random-randk: (g=0): rw=randrw, bs=32K-256K/32K-256K, ioengine=libaio, iodepth=2
2.0.8
Starting 8 processes

sequential-16k: (groupid=0, jobs=8): err= 0: pid=29402
  read : io=6100.7MB, bw=5131.7KB/s, iops=450 , runt=1217361msec
  write: io=4139.8MB, bw=3482.3KB/s, iops=300 , runt=1217361msec
  cpu          : usr=0.16%, sys=1.02%, ctx=891597, majf=0, minf=185
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=548406/w=365978/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=6100.7MB, aggrb=5131KB/s, minb=5131KB/s, maxb=5131KB/s,
mint=1217361msec, maxt=1217361msec
  WRITE: io=4139.8MB, aggrb=3482KB/s, minb=3482KB/s, maxb=3482KB/s,
mint=1217361msec, maxt=1217361msec

Disk stats (read/write):
    dm-5: ios=549396/368061, merge=0/0, ticks=3651443/22920965,
in_queue=26572470, util=100.00%, aggrios=0/0, aggrmerge=0/0,
aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

writethrough [writeback] writearound none

Running fio with medium config, and bcache in mode: writeback
sequential-16k: (g=0): rw=rw, bs=16K-16K/16K-16K, ioengine=libaio, iodepth=2
sequential-32k: (g=0): rw=rw, bs=32K-32K/32K-32K, ioengine=libaio, iodepth=2
sequential-randk: (g=0): rw=rw, bs=64K-4M/64K-4M, ioengine=libaio, iodepth=2
random-4k: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=2
...
random-4k: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=2
random-randk: (g=0): rw=randrw, bs=32K-256K/32K-256K, ioengine=libaio, iodepth=2
random-randk: (g=0): rw=randrw, bs=32K-256K/32K-256K, ioengine=libaio, iodepth=2
2.0.8
Starting 8 processes

sequential-16k: (groupid=0, jobs=8): err= 0: pid=29508
  read : io=6198.8MB, bw=45114KB/s, iops=3903 , runt=140699msec
  write: io=4041.9MB, bw=29416KB/s, iops=2595 , runt=140699msec
  cpu          : usr=1.55%, sys=11.66%, ctx=624578, majf=0, minf=177
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=549231/w=365170/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=6198.8MB, aggrb=45113KB/s, minb=45113KB/s, maxb=45113KB/s,
mint=140699msec, maxt=140699msec
  WRITE: io=4041.9MB, aggrb=29416KB/s, minb=29416KB/s, maxb=29416KB/s,
mint=140699msec, maxt=140699msec

Disk stats (read/write):
    dm-5: ios=549994/365837, merge=0/0, ticks=744215/740408,
in_queue=1485598, util=100.00%, aggrios=0/0, aggrmerge=0/0,
aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

writethrough writeback [writearound] none

Running fio with medium config, and bcache in mode: writearound
sequential-16k: (g=0): rw=rw, bs=16K-16K/16K-16K, ioengine=libaio, iodepth=2
sequential-32k: (g=0): rw=rw, bs=32K-32K/32K-32K, ioengine=libaio, iodepth=2
sequential-randk: (g=0): rw=rw, bs=64K-4M/64K-4M, ioengine=libaio, iodepth=2
random-4k: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=2
...
random-4k: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=2
random-randk: (g=0): rw=randrw, bs=32K-256K/32K-256K, ioengine=libaio, iodepth=2
random-randk: (g=0): rw=randrw, bs=32K-256K/32K-256K, ioengine=libaio, iodepth=2
2.0.8
Starting 8 processes

sequential-16k: (groupid=0, jobs=8): err= 0: pid=29537
  read : io=6167.3MB, bw=4049.3KB/s, iops=352 , runt=1559619msec
  write: io=4073.3MB, bw=2674.4KB/s, iops=234 , runt=1559619msec
  cpu          : usr=0.17%, sys=0.97%, ctx=1032534, majf=0, minf=177
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=548996/w=365575/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=6167.3MB, aggrb=4049KB/s, minb=4049KB/s, maxb=4049KB/s,
mint=1559619msec, maxt=1559619msec
  WRITE: io=4073.3MB, aggrb=2674KB/s, minb=2674KB/s, maxb=2674KB/s,
mint=1559619msec, maxt=1559619msec

Disk stats (read/write):
    dm-5: ios=550099/368626, merge=0/0, ticks=10329502/22252863,
in_queue=32582554, util=100.00%, aggrios=0/0, aggrmerge=0/0,
aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

writethrough writeback writearound [none]

Running fio with medium config, and bcache in mode: none
sequential-16k: (g=0): rw=rw, bs=16K-16K/16K-16K, ioengine=libaio, iodepth=2
sequential-32k: (g=0): rw=rw, bs=32K-32K/32K-32K, ioengine=libaio, iodepth=2
sequential-randk: (g=0): rw=rw, bs=64K-4M/64K-4M, ioengine=libaio, iodepth=2
random-4k: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=2
...
random-4k: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=2
random-randk: (g=0): rw=randrw, bs=32K-256K/32K-256K, ioengine=libaio, iodepth=2
random-randk: (g=0): rw=randrw, bs=32K-256K/32K-256K, ioengine=libaio, iodepth=2
2.0.8
Starting 8 processes

sequential-16k: (groupid=0, jobs=8): err= 0: pid=29702
  read : io=6179.9MB, bw=2632.4KB/s, iops=227 , runt=2403969msec
  write: io=4060.5MB, bw=1729.7KB/s, iops=152 , runt=2403969msec
  cpu          : usr=0.11%, sys=0.59%, ctx=980452, majf=0, minf=177
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=547963/w=366367/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=6179.9MB, aggrb=2632KB/s, minb=2632KB/s, maxb=2632KB/s,
mint=2403969msec, maxt=2403969msec
  WRITE: io=4060.5MB, aggrb=1729KB/s, minb=1729KB/s, maxb=1729KB/s,
mint=2403969msec, maxt=2403969msec

Disk stats (read/write):
    dm-5: ios=549090/371048, merge=0/0, ticks=20085168/30835851,
in_queue=50923149, util=100.00%, aggrios=0/0, aggrmerge=0/0,
aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
