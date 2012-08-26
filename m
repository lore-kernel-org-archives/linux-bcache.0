From: David Rhodes Clymer <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: Simple benchmark results
Date: Sun, 26 Aug 2012 13:59:38 -0400
Message-ID: <CAB7K1hEWeR3DSQFFN1jqm-rgsMaZqxuVdjBVFs5MuBeQwdijSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I've been running bcache on my devel machine, and inspired by the new
write-up on the bcache wiki, decided to do some simple benchmarking to
see if I could put some numbers to the performance benefit I see on my
PC.

I decided to test the various cache modes using fio, and since I use
postgresql a bit, pgbench (using both postgresql 9.1 & 9.2). I have no
particular skill with regard to benchmarking, so perhaps I've screwed
something up, but I was a bit surprised by the numbers.

With pgbench (which is primarily writes) writeback mode was the
decisive winner, as expected. I saw little difference between the
other modes, including cache mode "none".

With fio (using the parameters specified on the wiki), cache mode None
produced the highest IOps & throughput.

Does that make sense? Why would cache mode none be comparable to any
of the other modes?

## Environment ##

Linux zapazoid 3.5.0+ #1 SMP Sat Aug 25 12:42:26 EDT 2012 x86_64 GNU/Linux

/dev/mapper/vg0-pg_base on /var/lib/postgresql/9.1/main/base type ext4
(rw,relatime)
/dev/mapper/vg0-pg_xlog on /var/lib/postgresql/9.1/main/pg_xlog type
ext4 (rw,relatime)
/dev/mapper/vg0-home on /home type ext4 (rw,relatime)

Hardware:

Phenom II X6
8GB RAM
7200 RPM 320GB HDD
OCZ Vertex 3 64GB SSD


Benchmark Script:

#!/bin/sh

outfile=bcache_bench-results.txt
pg_bin=/usr/lib/postgresql/9.2/bin/

for cm in writethrough writeback writearound none; do
  echo $cm > /sys/block/sda/sda2/bcache/cache_mode
  cat /sys/block/sda/sda2/bcache/cache_mode
  echo
  # fio benchmark
  echo "Running fio with bcache in mode: $cm"
  cat ./bcache.fio
  fio ./bcache.fio
  echo

  # pgbench benchmark
  # First pg 9.1, then 9.2
  for p in 5432 5433; do
    if [ "$p" = 5432 ]; then
      version=9.1
    else
      version=9.2
    fi
    echo "Running pgbench against postgresql $version, with bcache in mode: $cm"
    su - postgres <<EOF
    "${pg_bin}psql" -p $p -c 'create database pg_bench_db;'
    "${pg_bin}pgbench" -p $p -i -s 10 -c 10 -T 300 pg_bench_db
    "${pg_bin}pgbench" -p $p   -s 10 -c 10 -T 300 pg_bench_db
    "${pg_bin}psql" -p $p -c 'drop database pg_bench_db;'
EOF
  done
done| tee "$outfile"

Fio version: 2.0.8

Fio config:

[test]
randrepeat=1
ioengine=libaio
bs=4k
ba=4k
size=8G
direct=1
gtod_reduce=1
norandommap
iodepth=32



## Results ##


[writethrough] writeback writearound none

Running fio with bcache in mode: writethrough
[test]
randrepeat=1
ioengine=libaio
bs=4k
ba=4k
size=8G
direct=1
gtod_reduce=1
norandommap
iodepth=32
test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
2.0.8
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=12901
  read : io=8192.0MB, bw=31633KB/s, iops=7908 , runt=265183msec
  cpu          : usr=5.27%, sys=29.96%, ctx=1932374, majf=0, minf=52
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=2097152/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=8192.0MB, aggrb=31633KB/s, minb=31633KB/s, maxb=31633KB/s,
mint=265183msec, maxt=265183msec

Disk stats (read/write):
    dm-3: ios=2095437/238, merge=0/0, ticks=8387259/33094,
in_queue=8420690, util=100.00%, aggrios=0/0, aggrmerge=0/0,
aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Running pgbench against postgresql 9.1, with bcache in mode: writethrough
CREATE DATABASE
transaction type: TPC-B (sort of)
scaling factor: 10
query mode: simple
number of clients: 10
number of threads: 1
duration: 300 s
number of transactions actually processed: 266049
tps = 884.810200 (including connections establishing)
tps = 884.964389 (excluding connections establishing)
DROP DATABASE
Running pgbench against postgresql 9.2, with bcache in mode: writethrough
CREATE DATABASE
transaction type: TPC-B (sort of)
scaling factor: 10
query mode: simple
number of clients: 10
number of threads: 1
duration: 300 s
number of transactions actually processed: 275057
tps = 916.809784 (including connections establishing)
tps = 916.991406 (excluding connections establishing)
DROP DATABASE
writethrough [writeback] writearound none

Running fio with bcache in mode: writeback
[test]
randrepeat=1
ioengine=libaio
bs=4k
ba=4k
size=8G
direct=1
gtod_reduce=1
norandommap
iodepth=32
test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
2.0.8
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=13069
  read : io=8192.0MB, bw=35757KB/s, iops=8939 , runt=234599msec
  cpu          : usr=5.34%, sys=29.18%, ctx=2039126, majf=0, minf=51
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=2097152/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=8192.0MB, aggrb=35757KB/s, minb=35757KB/s, maxb=35757KB/s,
mint=234599msec, maxt=234599msec

Disk stats (read/write):
    dm-3: ios=2095690/75, merge=0/0, ticks=7433820/106,
in_queue=7434173, util=100.00%, aggrios=0/0, aggrmerge=0/0,
aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Running pgbench against postgresql 9.1, with bcache in mode: writeback
CREATE DATABASE
transaction type: TPC-B (sort of)
scaling factor: 10
query mode: simple
number of clients: 10
number of threads: 1
duration: 300 s
number of transactions actually processed: 675318
tps = 2250.938899 (including connections establishing)
tps = 2251.295253 (excluding connections establishing)
DROP DATABASE
Running pgbench against postgresql 9.2, with bcache in mode: writeback
CREATE DATABASE
transaction type: TPC-B (sort of)
scaling factor: 10
query mode: simple
number of clients: 10
number of threads: 1
duration: 300 s
number of transactions actually processed: 823609
tps = 2741.663194 (including connections establishing)
tps = 2742.135127 (excluding connections establishing)
DROP DATABASE
writethrough writeback [writearound] none

Running fio with bcache in mode: writearound
[test]
randrepeat=1
ioengine=libaio
bs=4k
ba=4k
size=8G
direct=1
gtod_reduce=1
norandommap
iodepth=32
test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
2.0.8
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=13226
  read : io=8192.0MB, bw=33949KB/s, iops=8487 , runt=247091msec
  cpu          : usr=5.47%, sys=32.60%, ctx=1961342, majf=0, minf=51
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=2097152/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=8192.0MB, aggrb=33949KB/s, minb=33949KB/s, maxb=33949KB/s,
mint=247091msec, maxt=247091msec

Disk stats (read/write):
    dm-3: ios=2094874/58, merge=0/0, ticks=7816729/4730,
in_queue=7821618, util=100.00%, aggrios=0/0, aggrmerge=0/0,
aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Running pgbench against postgresql 9.1, with bcache in mode: writearound
CREATE DATABASE
transaction type: TPC-B (sort of)
scaling factor: 10
query mode: simple
number of clients: 10
number of threads: 1
duration: 300 s
number of transactions actually processed: 264464
tps = 881.501731 (including connections establishing)
tps = 881.650022 (excluding connections establishing)
DROP DATABASE
Running pgbench against postgresql 9.2, with bcache in mode: writearound
CREATE DATABASE
transaction type: TPC-B (sort of)
scaling factor: 10
query mode: simple
number of clients: 10
number of threads: 1
duration: 300 s
number of transactions actually processed: 283804
tps = 945.962582 (including connections establishing)
tps = 946.128733 (excluding connections establishing)
DROP DATABASE
writethrough writeback writearound [none]

Running fio with bcache in mode: none
[test]
randrepeat=1
ioengine=libaio
bs=4k
ba=4k
size=8G
direct=1
gtod_reduce=1
norandommap
iodepth=32
test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=32
2.0.8
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=13367
  read : io=8192.0MB, bw=37969KB/s, iops=9492 , runt=220931msec
  cpu          : usr=5.99%, sys=29.32%, ctx=1992824, majf=0, minf=51
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=2097152/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=8192.0MB, aggrb=37969KB/s, minb=37969KB/s, maxb=37969KB/s,
mint=220931msec, maxt=220931msec

Disk stats (read/write):
    dm-3: ios=2096590/41, merge=0/0, ticks=6995926/4349,
in_queue=7000464, util=100.00%, aggrios=0/0, aggrmerge=0/0,
aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  bcache0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

Running pgbench against postgresql 9.1, with bcache in mode: none
CREATE DATABASE
transaction type: TPC-B (sort of)
scaling factor: 10
query mode: simple
number of clients: 10
number of threads: 1
duration: 300 s
number of transactions actually processed: 265415
tps = 884.688970 (including connections establishing)
tps = 884.861368 (excluding connections establishing)
DROP DATABASE
Running pgbench against postgresql 9.2, with bcache in mode: none
CREATE DATABASE
transaction type: TPC-B (sort of)
scaling factor: 10
query mode: simple
number of clients: 10
number of threads: 1
duration: 300 s
number of transactions actually processed: 282727
tps = 942.373702 (including connections establishing)
tps = 942.546713 (excluding connections establishing)
DROP DATABASE



-davidc
