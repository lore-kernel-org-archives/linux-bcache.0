From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Preliminary performance benchmarks.
Date: Sat, 3 Mar 2012 12:35:12 +1100
Message-ID: <CAOzFzEhvs_PwHf35VfF9vdKKmJCNmhd_7aSTJzCHjY2kEJmj7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Carrying out some scalability tests on high I/O systems. More tests to
come using the Phoronix Test Suite.

=46io summary:
24 jobs
Direct IO
Randwrite test
Total of about 80k IOPs at 3.5k IOPS per thread.

Test rig specs:
2x Intel(R) Xeon(R) CPU X5650  @ 2.67GHz (12 physical cores, 24 logical=
)
12x 2TB Seagate nearline-SAS in RAID6 on LSI Logic / Symbios Logic LSI
MegaSAS 9260
2x Intel 520 SSDs 120GB in RAID0

The 2 520s are striped with md raid as /dev/md0 whch is formatted as a
bcache cache device using 1M buckets and 8k hard block size
Backing device is the big old raid6.

Random IO performance of the native raid0 is about 96K IOPs, backing
device in the realm of 1600ish.
However the backing device has a sequential IO performance of about 1.5=
GB/s.

Below are some quick findings using fio - showing very good
scalability of bcache even with very very fast SSDs.
*Note: The SSDs are connected via a SATA2 interface being somewhat of
a bottleneck.

dev05 ~ # fio --filename=3D/dev/bcache0 --direct=3D1 --rw=3Drandwrite
--bs=3D4096 --size=3D10001078620 --runtime=3D60 --name=3Dfile1 --iodept=
h=3D32
--numjobs=3D24 --ioengine=3Dlibaio
file1: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, io=
depth=3D32
=2E..
file1: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, io=
depth=3D32
fio 2.0.3
Starting 24 processes
Jobs: 10 (f=3D10): [______ww_wwww__E__www_w_] [7.8% done] [0K/322.4M /s=
]
[0 /78.7K iops] [eta 12m:15s]
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3993
  write: io=3D821604KB, bw=3D13645KB/s, iops=3D3411 , runt=3D 60214msec
    slat (usec): min=3D4 , max=3D113487 , avg=3D114.47, stdev=3D2376.82
    clat (usec): min=3D460 , max=3D1617.5K, avg=3D9223.06, stdev=3D1973=
6.65
     lat (usec): min=3D476 , max=3D1617.5K, avg=3D9337.33, stdev=3D2051=
4.45
    clat percentiles (usec):
     |  1.00th=3D[ 1288],  5.00th=3D[ 1896], 10.00th=3D[ 2416], 20.00th=
=3D[ 3120],
     | 30.00th=3D[ 3728], 40.00th=3D[ 4384], 50.00th=3D[ 5088], 60.00th=
=3D[ 5728],
     | 70.00th=3D[ 6432], 80.00th=3D[ 7264], 90.00th=3D[ 9152], 95.00th=
=3D[37120],
     | 99.00th=3D[94720], 99.50th=3D[138240], 99.90th=3D[216064]
    bw (KB/s)  : min=3D 5769, max=3D50211, per=3D4.33%, avg=3D13718.03,=
 stdev=3D5147.65
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.16%
    lat (msec) : 2=3D5.69%, 4=3D28.76%, 10=3D56.24%, 20=3D1.62%, 50=3D3=
=2E89%
    lat (msec) : 100=3D2.72%, 250=3D0.87%, 500=3D0.02%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.94%, sys=3D3.05%, ctx=3D39039, majf=3D0, minf=3D=
23
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D205401/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3994
  write: io=3D773564KB, bw=3D12864KB/s, iops=3D3216 , runt=3D 60134msec
    slat (usec): min=3D4 , max=3D121438 , avg=3D123.82, stdev=3D2487.05
    clat (usec): min=3D473 , max=3D1676.1K, avg=3D9799.12, stdev=3D2255=
3.15
     lat (usec): min=3D489 , max=3D1760.2K, avg=3D9922.61, stdev=3D2334=
5.78
    clat percentiles (usec):
     |  1.00th=3D[ 1448],  5.00th=3D[ 2160], 10.00th=3D[ 2672], 20.00th=
=3D[ 3280],
     | 30.00th=3D[ 3856], 40.00th=3D[ 4576], 50.00th=3D[ 5280], 60.00th=
=3D[ 5856],
     | 70.00th=3D[ 6560], 80.00th=3D[ 7392], 90.00th=3D[ 9408], 95.00th=
=3D[38656],
     | 99.00th=3D[99840], 99.50th=3D[156672], 99.90th=3D[228352]
    bw (KB/s)  : min=3D 5158, max=3D37016, per=3D4.07%, avg=3D12898.20,=
 stdev=3D4203.06
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.12%
    lat (msec) : 2=3D3.54%, 4=3D28.30%, 10=3D58.52%, 20=3D1.64%, 50=3D4=
=2E03%
    lat (msec) : 100=3D2.84%, 250=3D0.95%, 500=3D0.03%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.89%, sys=3D2.95%, ctx=3D38309, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D193391/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3995
  write: io=3D783660KB, bw=3D13060KB/s, iops=3D3265 , runt=3D 60004msec
    slat (usec): min=3D4 , max=3D118055 , avg=3D120.56, stdev=3D2423.94
    clat (usec): min=3D530 , max=3D1082.8K, avg=3D9675.59, stdev=3D2022=
8.23
     lat (usec): min=3D551 , max=3D1142.8K, avg=3D9796.35, stdev=3D2104=
5.95
    clat percentiles (usec):
     |  1.00th=3D[ 1480],  5.00th=3D[ 2256], 10.00th=3D[ 2736], 20.00th=
=3D[ 3408],
     | 30.00th=3D[ 3952], 40.00th=3D[ 4640], 50.00th=3D[ 5280], 60.00th=
=3D[ 5856],
     | 70.00th=3D[ 6560], 80.00th=3D[ 7392], 90.00th=3D[ 9536], 95.00th=
=3D[38144],
     | 99.00th=3D[94720], 99.50th=3D[150528], 99.90th=3D[222208]
    bw (KB/s)  : min=3D 4756, max=3D21700, per=3D4.11%, avg=3D13022.62,=
 stdev=3D3325.00
    lat (usec) : 750=3D0.01%, 1000=3D0.10%
    lat (msec) : 2=3D3.14%, 4=3D27.40%, 10=3D59.65%, 20=3D1.81%, 50=3D4=
=2E03%
    lat (msec) : 100=3D2.92%, 250=3D0.90%, 500=3D0.03%, 750=3D0.01%, 20=
00=3D0.01%
  cpu          : usr=3D0.91%, sys=3D3.06%, ctx=3D38590, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D195915/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3996
  write: io=3D799344KB, bw=3D13233KB/s, iops=3D3308 , runt=3D 60405msec
    slat (usec): min=3D4 , max=3D113409 , avg=3D115.84, stdev=3D2365.77
    clat (usec): min=3D648 , max=3D1313.9K, avg=3D9487.45, stdev=3D2136=
0.00
     lat (usec): min=3D661 , max=3D1313.9K, avg=3D9603.37, stdev=3D2211=
6.87
    clat percentiles (usec):
     |  1.00th=3D[ 1464],  5.00th=3D[ 2096], 10.00th=3D[ 2544], 20.00th=
=3D[ 3184],
     | 30.00th=3D[ 3792], 40.00th=3D[ 4448], 50.00th=3D[ 5152], 60.00th=
=3D[ 5792],
     | 70.00th=3D[ 6432], 80.00th=3D[ 7328], 90.00th=3D[ 9280], 95.00th=
=3D[37120],
     | 99.00th=3D[96768], 99.50th=3D[152576], 99.90th=3D[222208]
    bw (KB/s)  : min=3D 5483, max=3D34091, per=3D4.20%, avg=3D13305.74,=
 stdev=3D3850.52
    lat (usec) : 750=3D0.01%, 1000=3D0.07%
    lat (msec) : 2=3D4.13%, 4=3D29.36%, 10=3D57.07%, 20=3D1.78%, 50=3D4=
=2E05%
    lat (msec) : 100=3D2.56%, 250=3D0.93%, 500=3D0.03%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.94%, sys=3D2.95%, ctx=3D38593, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D199836/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3997
  write: io=3D821316KB, bw=3D13643KB/s, iops=3D3410 , runt=3D 60200msec
    slat (usec): min=3D4 , max=3D117990 , avg=3D110.12, stdev=3D2280.98
    clat (usec): min=3D568 , max=3D1796.8K, avg=3D9237.17, stdev=3D2045=
2.93
     lat (usec): min=3D585 , max=3D1796.8K, avg=3D9347.04, stdev=3D2119=
1.36
    clat percentiles (usec):
     |  1.00th=3D[ 1416],  5.00th=3D[ 2128], 10.00th=3D[ 2544], 20.00th=
=3D[ 3152],
     | 30.00th=3D[ 3728], 40.00th=3D[ 4384], 50.00th=3D[ 5152], 60.00th=
=3D[ 5728],
     | 70.00th=3D[ 6432], 80.00th=3D[ 7264], 90.00th=3D[ 9024], 95.00th=
=3D[36608],
     | 99.00th=3D[94720], 99.50th=3D[148480], 99.90th=3D[214016]
    bw (KB/s)  : min=3D 5928, max=3D43330, per=3D4.31%, avg=3D13668.87,=
 stdev=3D4570.80
    lat (usec) : 750=3D0.01%, 1000=3D0.17%
    lat (msec) : 2=3D3.79%, 4=3D30.50%, 10=3D56.62%, 20=3D1.52%, 50=3D4=
=2E01%
    lat (msec) : 100=3D2.45%, 250=3D0.90%, 500=3D0.02%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.97%, sys=3D3.02%, ctx=3D39689, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D205329/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3999
  write: io=3D849880KB, bw=3D14154KB/s, iops=3D3538 , runt=3D 60047msec
    slat (usec): min=3D4 , max=3D123486 , avg=3D105.83, stdev=3D2216.28
    clat (usec): min=3D446 , max=3D1383.1K, avg=3D8926.80, stdev=3D1969=
2.96
     lat (usec): min=3D461 , max=3D1384.2K, avg=3D9032.43, stdev=3D2044=
5.23
    clat percentiles (usec):
     |  1.00th=3D[ 1368],  5.00th=3D[ 1944], 10.00th=3D[ 2352], 20.00th=
=3D[ 3024],
     | 30.00th=3D[ 3632], 40.00th=3D[ 4256], 50.00th=3D[ 5024], 60.00th=
=3D[ 5664],
     | 70.00th=3D[ 6368], 80.00th=3D[ 7264], 90.00th=3D[ 9024], 95.00th=
=3D[33536],
     | 99.00th=3D[91648], 99.50th=3D[146432], 99.90th=3D[220160]
    bw (KB/s)  : min=3D 5807, max=3D48232, per=3D4.48%, avg=3D14192.07,=
 stdev=3D5047.52
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.18%
    lat (msec) : 2=3D5.43%, 4=3D30.44%, 10=3D55.07%, 20=3D1.70%, 50=3D3=
=2E99%
    lat (msec) : 100=3D2.27%, 250=3D0.86%, 500=3D0.02%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D1.03%, sys=3D3.21%, ctx=3D40302, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D212470/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4000
  write: io=3D773688KB, bw=3D12894KB/s, iops=3D3223 , runt=3D 60003msec
    slat (usec): min=3D4 , max=3D126488 , avg=3D119.41, stdev=3D2415.30
    clat (usec): min=3D694 , max=3D949429 , avg=3D9803.35, stdev=3D2071=
3.09
     lat (usec): min=3D721 , max=3D949436 , avg=3D9922.96, stdev=3D2149=
7.37
    clat percentiles (usec):
     |  1.00th=3D[ 1496],  5.00th=3D[ 2256], 10.00th=3D[ 2736], 20.00th=
=3D[ 3408],
     | 30.00th=3D[ 3984], 40.00th=3D[ 4640], 50.00th=3D[ 5280], 60.00th=
=3D[ 5856],
     | 70.00th=3D[ 6560], 80.00th=3D[ 7392], 90.00th=3D[ 9536], 95.00th=
=3D[38656],
     | 99.00th=3D[104960], 99.50th=3D[154624], 99.90th=3D[228352]
    bw (KB/s)  : min=3D 5880, max=3D19437, per=3D4.04%, avg=3D12796.90,=
 stdev=3D3142.95
    lat (usec) : 750=3D0.01%, 1000=3D0.09%
    lat (msec) : 2=3D2.99%, 4=3D26.97%, 10=3D60.34%, 20=3D1.76%, 50=3D4=
=2E06%
    lat (msec) : 100=3D2.70%, 250=3D1.04%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
  cpu          : usr=3D0.89%, sys=3D2.93%, ctx=3D39334, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D193422/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4001
  write: io=3D769892KB, bw=3D12831KB/s, iops=3D3207 , runt=3D 60004msec
    slat (usec): min=3D4 , max=3D128937 , avg=3D125.40, stdev=3D2497.02
    clat (usec): min=3D543 , max=3D1641.2K, avg=3D9845.70, stdev=3D2151=
7.57
     lat (usec): min=3D557 , max=3D1641.2K, avg=3D9971.31, stdev=3D2229=
1.20
    clat percentiles (usec):
     |  1.00th=3D[ 1432],  5.00th=3D[ 2096], 10.00th=3D[ 2576], 20.00th=
=3D[ 3280],
     | 30.00th=3D[ 3888], 40.00th=3D[ 4576], 50.00th=3D[ 5280], 60.00th=
=3D[ 5856],
     | 70.00th=3D[ 6560], 80.00th=3D[ 7392], 90.00th=3D[ 9920], 95.00th=
=3D[38144],
     | 99.00th=3D[104960], 99.50th=3D[154624], 99.90th=3D[232448]
    bw (KB/s)  : min=3D 6854, max=3D23338, per=3D4.03%, avg=3D12774.62,=
 stdev=3D3244.76
    lat (usec) : 750=3D0.01%, 1000=3D0.17%
    lat (msec) : 2=3D3.97%, 4=3D27.74%, 10=3D58.14%, 20=3D1.71%, 50=3D4=
=2E53%
    lat (msec) : 100=3D2.68%, 250=3D1.00%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.89%, sys=3D3.00%, ctx=3D38235, majf=3D0, minf=3D=
26
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D192473/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4002
  write: io=3D828440KB, bw=3D13807KB/s, iops=3D3451 , runt=3D 60003msec
    slat (usec): min=3D4 , max=3D113456 , avg=3D107.59, stdev=3D2251.36
    clat (usec): min=3D717 , max=3D1012.1K, avg=3D9159.59, stdev=3D1997=
2.65
     lat (usec): min=3D731 , max=3D1013.3K, avg=3D9267.38, stdev=3D2070=
4.40
    clat percentiles (usec):
     |  1.00th=3D[ 1416],  5.00th=3D[ 2024], 10.00th=3D[ 2480], 20.00th=
=3D[ 3120],
     | 30.00th=3D[ 3696], 40.00th=3D[ 4384], 50.00th=3D[ 5088], 60.00th=
=3D[ 5664],
     | 70.00th=3D[ 6432], 80.00th=3D[ 7264], 90.00th=3D[ 9024], 95.00th=
=3D[35584],
     | 99.00th=3D[98816], 99.50th=3D[154624], 99.90th=3D[226304]
    bw (KB/s)  : min=3D 4280, max=3D25462, per=3D4.35%, avg=3D13769.89,=
 stdev=3D4158.74
    lat (usec) : 750=3D0.01%, 1000=3D0.12%
    lat (msec) : 2=3D4.67%, 4=3D29.90%, 10=3D56.57%, 20=3D1.58%, 50=3D3=
=2E82%
    lat (msec) : 100=3D2.35%, 250=3D0.94%, 500=3D0.03%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.99%, sys=3D3.13%, ctx=3D40961, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D207110/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4003
  write: io=3D788452KB, bw=3D13090KB/s, iops=3D3272 , runt=3D 60231msec
    slat (usec): min=3D4 , max=3D135424 , avg=3D119.03, stdev=3D2426.72
    clat (usec): min=3D514 , max=3D1681.9K, avg=3D9614.94, stdev=3D2124=
3.36
     lat (usec): min=3D527 , max=3D1681.9K, avg=3D9734.19, stdev=3D2201=
6.46
    clat percentiles (usec):
     |  1.00th=3D[ 1336],  5.00th=3D[ 2064], 10.00th=3D[ 2512], 20.00th=
=3D[ 3216],
     | 30.00th=3D[ 3792], 40.00th=3D[ 4448], 50.00th=3D[ 5152], 60.00th=
=3D[ 5728],
     | 70.00th=3D[ 6432], 80.00th=3D[ 7328], 90.00th=3D[ 9280], 95.00th=
=3D[38144],
     | 99.00th=3D[104960], 99.50th=3D[158720], 99.90th=3D[228352]
    bw (KB/s)  : min=3D 4976, max=3D27612, per=3D4.13%, avg=3D13082.37,=
 stdev=3D3858.63
    lat (usec) : 750=3D0.01%, 1000=3D0.14%
    lat (msec) : 2=3D4.44%, 4=3D28.95%, 10=3D57.10%, 20=3D1.67%, 50=3D3=
=2E93%
    lat (msec) : 100=3D2.66%, 250=3D1.04%, 500=3D0.05%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.96%, sys=3D3.04%, ctx=3D39625, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D197113/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4004
  write: io=3D790536KB, bw=3D13175KB/s, iops=3D3293 , runt=3D 60002msec
    slat (usec): min=3D4 , max=3D114963 , avg=3D119.88, stdev=3D2419.63
    clat (usec): min=3D537 , max=3D1023.4K, avg=3D9591.03, stdev=3D2088=
3.64
     lat (usec): min=3D552 , max=3D1023.4K, avg=3D9711.11, stdev=3D2166=
1.57
    clat percentiles (usec):
     |  1.00th=3D[ 1400],  5.00th=3D[ 2024], 10.00th=3D[ 2480], 20.00th=
=3D[ 3216],
     | 30.00th=3D[ 3824], 40.00th=3D[ 4512], 50.00th=3D[ 5216], 60.00th=
=3D[ 5792],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7328], 90.00th=3D[ 9280], 95.00th=
=3D[38144],
     | 99.00th=3D[101888], 99.50th=3D[158720], 99.90th=3D[228352]
    bw (KB/s)  : min=3D 4088, max=3D30406, per=3D4.13%, avg=3D13071.40,=
 stdev=3D4094.62
    lat (usec) : 750=3D0.01%, 1000=3D0.13%
    lat (msec) : 2=3D4.63%, 4=3D28.15%, 10=3D57.73%, 20=3D1.64%, 50=3D4=
=2E03%
    lat (msec) : 100=3D2.63%, 250=3D0.99%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.97%, sys=3D2.95%, ctx=3D39111, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D197634/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4005
  write: io=3D877548KB, bw=3D14626KB/s, iops=3D3656 , runt=3D 60001msec
    slat (usec): min=3D4 , max=3D113739 , avg=3D101.26, stdev=3D2181.30
    clat (usec): min=3D500 , max=3D1509.9K, avg=3D8646.60, stdev=3D1885=
3.03
     lat (usec): min=3D517 , max=3D1509.9K, avg=3D8748.06, stdev=3D1957=
5.58
    clat percentiles (usec):
     |  1.00th=3D[ 1272],  5.00th=3D[ 1848], 10.00th=3D[ 2288], 20.00th=
=3D[ 2992],
     | 30.00th=3D[ 3568], 40.00th=3D[ 4192], 50.00th=3D[ 4896], 60.00th=
=3D[ 5536],
     | 70.00th=3D[ 6240], 80.00th=3D[ 7136], 90.00th=3D[ 8640], 95.00th=
=3D[34048],
     | 99.00th=3D[87552], 99.50th=3D[132096], 99.90th=3D[218112]
    bw (KB/s)  : min=3D 6671, max=3D30083, per=3D4.54%, avg=3D14369.59,=
 stdev=3D4168.17
    lat (usec) : 750=3D0.01%, 1000=3D0.16%
    lat (msec) : 2=3D6.39%, 4=3D30.90%, 10=3D54.36%, 20=3D1.32%, 50=3D3=
=2E77%
    lat (msec) : 100=3D2.31%, 250=3D0.73%, 500=3D0.03%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.99%, sys=3D3.31%, ctx=3D40531, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D219387/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4006
  write: io=3D770940KB, bw=3D12849KB/s, iops=3D3212 , runt=3D 60002msec
    slat (usec): min=3D4 , max=3D117996 , avg=3D124.61, stdev=3D2459.97
    clat (usec): min=3D446 , max=3D1537.3K, avg=3D9834.30, stdev=3D2202=
2.92
     lat (usec): min=3D458 , max=3D1537.7K, avg=3D9959.11, stdev=3D2280=
0.07
    clat percentiles (usec):
     |  1.00th=3D[ 1304],  5.00th=3D[ 1880], 10.00th=3D[ 2320], 20.00th=
=3D[ 3088],
     | 30.00th=3D[ 3728], 40.00th=3D[ 4384], 50.00th=3D[ 5152], 60.00th=
=3D[ 5728],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7392], 90.00th=3D[ 9792], 95.00th=
=3D[39168],
     | 99.00th=3D[115200], 99.50th=3D[164864], 99.90th=3D[228352]
    bw (KB/s)  : min=3D 3659, max=3D40632, per=3D4.00%, avg=3D12683.36,=
 stdev=3D4691.41
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.21%
    lat (msec) : 2=3D6.05%, 4=3D28.06%, 10=3D55.83%, 20=3D1.69%, 50=3D4=
=2E23%
    lat (msec) : 100=3D2.72%, 250=3D1.12%, 500=3D0.05%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.93%, sys=3D2.93%, ctx=3D38130, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D192735/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4007
  write: io=3D784360KB, bw=3D13005KB/s, iops=3D3251 , runt=3D 60314msec
    slat (usec): min=3D4 , max=3D128950 , avg=3D119.95, stdev=3D2394.53
    clat (usec): min=3D527 , max=3D1082.5K, avg=3D9666.92, stdev=3D2083=
5.35
     lat (usec): min=3D553 , max=3D1082.5K, avg=3D9787.07, stdev=3D2161=
6.62
    clat percentiles (usec):
     |  1.00th=3D[ 1368],  5.00th=3D[ 2040], 10.00th=3D[ 2480], 20.00th=
=3D[ 3248],
     | 30.00th=3D[ 3856], 40.00th=3D[ 4512], 50.00th=3D[ 5216], 60.00th=
=3D[ 5856],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7328], 90.00th=3D[ 9536], 95.00th=
=3D[37632],
     | 99.00th=3D[101888], 99.50th=3D[156672], 99.90th=3D[226304]
    bw (KB/s)  : min=3D 4433, max=3D26743, per=3D4.13%, avg=3D13096.11,=
 stdev=3D3884.65
    lat (usec) : 750=3D0.01%, 1000=3D0.17%
    lat (msec) : 2=3D4.41%, 4=3D27.75%, 10=3D58.12%, 20=3D1.63%, 50=3D4=
=2E21%
    lat (msec) : 100=3D2.66%, 250=3D0.99%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.89%, sys=3D3.05%, ctx=3D39152, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D196090/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4008
  write: io=3D784736KB, bw=3D13061KB/s, iops=3D3265 , runt=3D 60084msec
    slat (usec): min=3D4 , max=3D112108 , avg=3D121.25, stdev=3D2421.10
    clat (usec): min=3D583 , max=3D1580.3K, avg=3D9660.47, stdev=3D2140=
4.93
     lat (usec): min=3D595 , max=3D1603.4K, avg=3D9781.91, stdev=3D2217=
5.06
    clat percentiles (usec):
     |  1.00th=3D[ 1464],  5.00th=3D[ 2064], 10.00th=3D[ 2512], 20.00th=
=3D[ 3216],
     | 30.00th=3D[ 3856], 40.00th=3D[ 4576], 50.00th=3D[ 5280], 60.00th=
=3D[ 5856],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7392], 90.00th=3D[ 9408], 95.00th=
=3D[38144],
     | 99.00th=3D[95744], 99.50th=3D[152576], 99.90th=3D[226304]
    bw (KB/s)  : min=3D 6019, max=3D31992, per=3D4.13%, avg=3D13095.62,=
 stdev=3D4157.33
    lat (usec) : 750=3D0.01%, 1000=3D0.12%
    lat (msec) : 2=3D4.19%, 4=3D27.99%, 10=3D58.12%, 20=3D1.54%, 50=3D4=
=2E28%
    lat (msec) : 100=3D2.79%, 250=3D0.90%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.94%, sys=3D2.99%, ctx=3D38544, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D196184/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4010
  write: io=3D815684KB, bw=3D13594KB/s, iops=3D3398 , runt=3D 60003msec
    slat (usec): min=3D4 , max=3D141599 , avg=3D111.80, stdev=3D2314.86
    clat (usec): min=3D600 , max=3D1217.5K, avg=3D9300.28, stdev=3D2027=
5.17
     lat (usec): min=3D610 , max=3D1217.5K, avg=3D9412.28, stdev=3D2100=
8.51
    clat percentiles (usec):
     |  1.00th=3D[ 1480],  5.00th=3D[ 2128], 10.00th=3D[ 2544], 20.00th=
=3D[ 3152],
     | 30.00th=3D[ 3760], 40.00th=3D[ 4448], 50.00th=3D[ 5152], 60.00th=
=3D[ 5728],
     | 70.00th=3D[ 6432], 80.00th=3D[ 7264], 90.00th=3D[ 8896], 95.00th=
=3D[36096],
     | 99.00th=3D[97792], 99.50th=3D[152576], 99.90th=3D[222208]
    bw (KB/s)  : min=3D 5160, max=3D24846, per=3D4.29%, avg=3D13584.51,=
 stdev=3D3625.42
    lat (usec) : 750=3D0.01%, 1000=3D0.09%
    lat (msec) : 2=3D3.81%, 4=3D29.84%, 10=3D57.34%, 20=3D1.53%, 50=3D3=
=2E84%
    lat (msec) : 100=3D2.57%, 250=3D0.93%, 500=3D0.03%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.92%, sys=3D3.20%, ctx=3D39886, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D203921/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4011
  write: io=3D784100KB, bw=3D13055KB/s, iops=3D3263 , runt=3D 60062msec
    slat (usec): min=3D4 , max=3D99300 , avg=3D116.71, stdev=3D2345.60
    clat (usec): min=3D591 , max=3D838633 , avg=3D9673.18, stdev=3D2123=
9.11
     lat (usec): min=3D605 , max=3D838655 , avg=3D9789.84, stdev=3D2199=
7.58
    clat percentiles (usec):
     |  1.00th=3D[ 1384],  5.00th=3D[ 1960], 10.00th=3D[ 2448], 20.00th=
=3D[ 3216],
     | 30.00th=3D[ 3792], 40.00th=3D[ 4512], 50.00th=3D[ 5216], 60.00th=
=3D[ 5792],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7328], 90.00th=3D[ 9408], 95.00th=
=3D[37120],
     | 99.00th=3D[108032], 99.50th=3D[162816], 99.90th=3D[230400]
    bw (KB/s)  : min=3D 5988, max=3D28728, per=3D4.13%, avg=3D13098.09,=
 stdev=3D3959.17
    lat (usec) : 750=3D0.01%, 1000=3D0.11%
    lat (msec) : 2=3D5.19%, 4=3D27.85%, 10=3D57.38%, 20=3D1.66%, 50=3D4=
=2E18%
    lat (msec) : 100=3D2.52%, 250=3D1.05%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
  cpu          : usr=3D0.97%, sys=3D2.94%, ctx=3D40022, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D196025/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4012
  write: io=3D784720KB, bw=3D13078KB/s, iops=3D3269 , runt=3D 60005msec
    slat (usec): min=3D4 , max=3D112089 , avg=3D118.79, stdev=3D2392.98
    clat (usec): min=3D451 , max=3D1475.5K, avg=3D9663.55, stdev=3D2120=
6.38
     lat (usec): min=3D464 , max=3D1475.6K, avg=3D9782.54, stdev=3D2198=
3.94
    clat percentiles (usec):
     |  1.00th=3D[ 1288],  5.00th=3D[ 1992], 10.00th=3D[ 2480], 20.00th=
=3D[ 3248],
     | 30.00th=3D[ 3888], 40.00th=3D[ 4576], 50.00th=3D[ 5280], 60.00th=
=3D[ 5856],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7392], 90.00th=3D[ 9408], 95.00th=
=3D[37120],
     | 99.00th=3D[100864], 99.50th=3D[158720], 99.90th=3D[224256]
    bw (KB/s)  : min=3D 5946, max=3D23496, per=3D4.12%, avg=3D13059.17,=
 stdev=3D3462.91
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.18%
    lat (msec) : 2=3D4.84%, 4=3D26.82%, 10=3D58.59%, 20=3D1.76%, 50=3D4=
=2E07%
    lat (msec) : 100=3D2.70%, 250=3D0.98%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.95%, sys=3D2.99%, ctx=3D39607, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D196180/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4013
  write: io=3D793884KB, bw=3D13231KB/s, iops=3D3307 , runt=3D 60003msec
    slat (usec): min=3D4 , max=3D115547 , avg=3D116.91, stdev=3D2359.21
    clat (usec): min=3D628 , max=3D1535.7K, avg=3D9553.22, stdev=3D2074=
7.17
     lat (usec): min=3D634 , max=3D1535.8K, avg=3D9670.33, stdev=3D2153=
3.58
    clat percentiles (usec):
     |  1.00th=3D[ 1512],  5.00th=3D[ 2160], 10.00th=3D[ 2640], 20.00th=
=3D[ 3280],
     | 30.00th=3D[ 3856], 40.00th=3D[ 4512], 50.00th=3D[ 5216], 60.00th=
=3D[ 5792],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7328], 90.00th=3D[ 9536], 95.00th=
=3D[37632],
     | 99.00th=3D[99840], 99.50th=3D[152576], 99.90th=3D[224256]
    bw (KB/s)  : min=3D 6772, max=3D27640, per=3D4.15%, avg=3D13157.26,=
 stdev=3D3657.51
    lat (usec) : 750=3D0.01%, 1000=3D0.07%
    lat (msec) : 2=3D3.52%, 4=3D28.95%, 10=3D57.77%, 20=3D1.86%, 50=3D4=
=2E24%
    lat (msec) : 100=3D2.57%, 250=3D0.96%, 500=3D0.03%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.95%, sys=3D2.97%, ctx=3D38933, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D198471/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4014
  write: io=3D826984KB, bw=3D13782KB/s, iops=3D3445 , runt=3D 60003msec
    slat (usec): min=3D4 , max=3D126500 , avg=3D110.53, stdev=3D2316.49
    clat (usec): min=3D605 , max=3D1631.9K, avg=3D9172.40, stdev=3D2056=
0.58
     lat (usec): min=3D619 , max=3D1653.4K, avg=3D9283.13, stdev=3D2129=
3.23
    clat percentiles (usec):
     |  1.00th=3D[ 1352],  5.00th=3D[ 2040], 10.00th=3D[ 2480], 20.00th=
=3D[ 3120],
     | 30.00th=3D[ 3696], 40.00th=3D[ 4320], 50.00th=3D[ 5024], 60.00th=
=3D[ 5664],
     | 70.00th=3D[ 6368], 80.00th=3D[ 7264], 90.00th=3D[ 9024], 95.00th=
=3D[36096],
     | 99.00th=3D[93696], 99.50th=3D[148480], 99.90th=3D[222208]
    bw (KB/s)  : min=3D 4413, max=3D27808, per=3D4.28%, avg=3D13551.74,=
 stdev=3D3870.91
    lat (usec) : 750=3D0.01%, 1000=3D0.12%
    lat (msec) : 2=3D4.57%, 4=3D30.57%, 10=3D55.76%, 20=3D1.70%, 50=3D3=
=2E95%
    lat (msec) : 100=3D2.39%, 250=3D0.90%, 500=3D0.03%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D1.01%, sys=3D3.06%, ctx=3D39314, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D206746/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4015
  write: io=3D826752KB, bw=3D13779KB/s, iops=3D3444 , runt=3D 60003msec
    slat (usec): min=3D4 , max=3D116274 , avg=3D108.34, stdev=3D2274.99
    clat (usec): min=3D610 , max=3D1268.9K, avg=3D9177.07, stdev=3D2018=
1.03
     lat (usec): min=3D622 , max=3D1268.9K, avg=3D9285.61, stdev=3D2089=
5.62
    clat percentiles (usec):
     |  1.00th=3D[ 1416],  5.00th=3D[ 2128], 10.00th=3D[ 2608], 20.00th=
=3D[ 3248],
     | 30.00th=3D[ 3792], 40.00th=3D[ 4448], 50.00th=3D[ 5152], 60.00th=
=3D[ 5728],
     | 70.00th=3D[ 6432], 80.00th=3D[ 7264], 90.00th=3D[ 9024], 95.00th=
=3D[35072],
     | 99.00th=3D[94720], 99.50th=3D[144384], 99.90th=3D[224256]
    bw (KB/s)  : min=3D 6374, max=3D30040, per=3D4.35%, avg=3D13772.31,=
 stdev=3D4065.37
    lat (usec) : 750=3D0.01%, 1000=3D0.12%
    lat (msec) : 2=3D3.91%, 4=3D29.33%, 10=3D57.75%, 20=3D1.68%, 50=3D3=
=2E86%
    lat (msec) : 100=3D2.45%, 250=3D0.84%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.91%, sys=3D3.16%, ctx=3D40150, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D206688/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4016
  write: io=3D774808KB, bw=3D12899KB/s, iops=3D3224 , runt=3D 60066msec
    slat (usec): min=3D4 , max=3D116276 , avg=3D122.45, stdev=3D2450.71
    clat (usec): min=3D492 , max=3D1488.5K, avg=3D9785.13, stdev=3D2169=
8.70
     lat (usec): min=3D505 , max=3D1488.5K, avg=3D9907.78, stdev=3D2247=
1.59
    clat percentiles (usec):
     |  1.00th=3D[ 1400],  5.00th=3D[ 2096], 10.00th=3D[ 2544], 20.00th=
=3D[ 3280],
     | 30.00th=3D[ 3888], 40.00th=3D[ 4576], 50.00th=3D[ 5280], 60.00th=
=3D[ 5856],
     | 70.00th=3D[ 6560], 80.00th=3D[ 7392], 90.00th=3D[ 9664], 95.00th=
=3D[38144],
     | 99.00th=3D[101888], 99.50th=3D[154624], 99.90th=3D[228352]
    bw (KB/s)  : min=3D 5100, max=3D24714, per=3D4.08%, avg=3D12937.68,=
 stdev=3D3431.60
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.13%
    lat (msec) : 2=3D4.14%, 4=3D27.53%, 10=3D58.41%, 20=3D1.78%, 50=3D4=
=2E26%
    lat (msec) : 100=3D2.68%, 250=3D0.97%, 500=3D0.05%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.95%, sys=3D2.97%, ctx=3D39454, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D193702/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4018
  write: io=3D802892KB, bw=3D13245KB/s, iops=3D3311 , runt=3D 60617msec
    slat (usec): min=3D4 , max=3D115549 , avg=3D114.45, stdev=3D2351.84
    clat (usec): min=3D443 , max=3D1541.4K, avg=3D9448.96, stdev=3D2078=
8.49
     lat (usec): min=3D460 , max=3D1596.1K, avg=3D9563.61, stdev=3D2156=
0.78
    clat percentiles (usec):
     |  1.00th=3D[ 1240],  5.00th=3D[ 2008], 10.00th=3D[ 2544], 20.00th=
=3D[ 3248],
     | 30.00th=3D[ 3856], 40.00th=3D[ 4512], 50.00th=3D[ 5216], 60.00th=
=3D[ 5792],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7328], 90.00th=3D[ 9152], 95.00th=
=3D[36608],
     | 99.00th=3D[98816], 99.50th=3D[152576], 99.90th=3D[224256]
    bw (KB/s)  : min=3D 1731, max=3D24256, per=3D4.20%, avg=3D13307.98,=
 stdev=3D3643.41
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.25%
    lat (msec) : 2=3D4.71%, 4=3D27.47%, 10=3D58.34%, 20=3D1.62%, 50=3D4=
=2E11%
    lat (msec) : 100=3D2.48%, 250=3D0.95%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.94%, sys=3D3.06%, ctx=3D40190, majf=3D0, minf=3D=
24
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D200723/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0
file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4019
  write: io=3D778136KB, bw=3D12945KB/s, iops=3D3236 , runt=3D 60111msec
    slat (usec): min=3D4 , max=3D135424 , avg=3D117.66, stdev=3D2386.05
    clat (usec): min=3D452 , max=3D1677.3K, avg=3D9747.29, stdev=3D2204=
9.42
     lat (usec): min=3D469 , max=3D1677.4K, avg=3D9864.91, stdev=3D2278=
7.60
    clat percentiles (usec):
     |  1.00th=3D[ 1384],  5.00th=3D[ 2128], 10.00th=3D[ 2576], 20.00th=
=3D[ 3248],
     | 30.00th=3D[ 3824], 40.00th=3D[ 4512], 50.00th=3D[ 5216], 60.00th=
=3D[ 5792],
     | 70.00th=3D[ 6496], 80.00th=3D[ 7328], 90.00th=3D[ 9408], 95.00th=
=3D[37120],
     | 99.00th=3D[113152], 99.50th=3D[162816], 99.90th=3D[224256]
    bw (KB/s)  : min=3D 6296, max=3D38856, per=3D4.10%, avg=3D12994.39,=
 stdev=3D4142.39
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.14%
    lat (msec) : 2=3D3.85%, 4=3D28.97%, 10=3D57.45%, 20=3D1.83%, 50=3D4=
=2E00%
    lat (msec) : 100=3D2.63%, 250=3D1.06%, 500=3D0.04%, 750=3D0.01%, 10=
00=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.85%, sys=3D3.06%, ctx=3D40263, majf=3D0, minf=3D=
25
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
100.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.1%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D194534/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0

Run status group 0 (all jobs):
  WRITE: io=3D18756MB, aggrb=3D316840KB/s, minb=3D13138KB/s, maxb=3D149=
76KB/s,
mint=3D60001msec, maxt=3D60617msec

Disk stats (read/write):
  bcache0: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.=
00%

--=20
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846
