From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Testing bcachefs - beginners questions
Date: Thu, 17 Mar 2016 20:15:51 -0800
Message-ID: <20160318041551.GA7889@kmo-pixel>
References: <alpine.LRH.2.11.1603161917400.19675@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35606 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbcCREPz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 18 Mar 2016 00:15:55 -0400
Received: by mail-pf0-f181.google.com with SMTP id n5so149555844pfn.2
        for <linux-bcache@vger.kernel.org>; Thu, 17 Mar 2016 21:15:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1603161917400.19675@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>, linux-bcache@vger.kernel.org

On Wed, Mar 16, 2016 at 07:26:42PM +0000, Eric Wheeler wrote:
>=20
> On Wed, 16 Mar 2016, Marcin Miros=C5=82aw wrote:
>=20
> > Hello!
> >=20
> > I'd like to try to use and test how bcachefs works. I've found page
> > https://lkml.org/lkml/2015/8/21/22 where are described working and
> > planned features. What changed since mentioned email? Do I see corr=
ectly
> > that web page with documentation is rather outdated?
> > How can I check bcachefs without using all kernel from
> > https://evilpiepirate.org/git/linux-bcache.git ? Is it enough to co=
py
> > directory drivers/md/bcache to currently used kernel sources and co=
mpile
> > or I've to use kernel from mentioned git repo?
>=20
> I think you want this branch:
>=20
> https://evilpiepirate.org/git/linux-bcache.git/log/?h=3Dbcache-dev
>=20
> It looks like Kent's tree is up to date (4.5.0) so you could use it=20
> directly.  I wouldn't copy directory trees around to a different kern=
el=20
> unless you are ready for some backporting work.  Perhaps bcachefs can=
 be=20
> backported to earlier stable kernels when Kent is ready to call it st=
able. =20
>=20
> He was working on endianness compatability last I heard.  It would be=
 neat=20
> to hear some feedback on its status, maybe benchmarks against btrfs/z=
fs,=20
> too.

Endianness compatibility is done. There's been a _ton_ of fixes and imp=
rovements
since the announcement. I'm gonna have to write some more documentation=
 and do
another announcement soon.

One thing to note if you're running benchmarks is that data checksummin=
g is on
by default - it doesn't hurt most stuff noticably, but small random rea=
ds where
your read size is smaller than the checksum granularity (typically the =
size of
the writes you issued) will suck because it'll have to bounce and read =
the
entire chunk of data the checksum covered.

Benchmark wise, here's a dio append benchmark I ran the other day:

Summary:
bcachefs:       1749.1 MB/s
ext4:           513.6 MB/s
xfs:            515.7 MB/s
btrfs:          531.2 MB/s

******** Running benchmark /root/benches/dio-appends.sh

******** bcache:
dio-append: (g=3D0): rw=3Dwrite, bs=3D4K-256K/4K-256K/4K-256K, ioengine=
=3Dlibaio, iodepth=3D1
=2E..
fio-2.6
Starting 64 processes

dio-append: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D3832: Mon Mar  7 =
19:54:34 2016
  write: io=3D32761MB, bw=3D1749.1MB/s, iops=3D14317, runt=3D 18721msec
    slat (usec): min=3D33, max=3D99502, avg=3D4453.08, stdev=3D2949.39
    clat (usec): min=3D0, max=3D339, avg=3D 1.55, stdev=3D 2.01
     lat (usec): min=3D34, max=3D99504, avg=3D4456.19, stdev=3D2949.56
    clat percentiles (usec):
     |  1.00th=3D[    1],  5.00th=3D[    1], 10.00th=3D[    1], 20.00th=
=3D[    1],
     | 30.00th=3D[    1], 40.00th=3D[    1], 50.00th=3D[    1], 60.00th=
=3D[    2],
     | 70.00th=3D[    2], 80.00th=3D[    2], 90.00th=3D[    2], 95.00th=
=3D[    2],
     | 99.00th=3D[    3], 99.50th=3D[    4], 99.90th=3D[   11], 99.95th=
=3D[   30],
     | 99.99th=3D[   96]
    bw (KB  /s): min=3D21833, max=3D32670, per=3D1.57%, avg=3D28048.70,=
 stdev=3D1457.81
    lat (usec) : 2=3D54.76%, 4=3D44.52%, 10=3D0.57%, 20=3D0.08%, 50=3D0=
=2E03%
    lat (usec) : 100=3D0.03%, 250=3D0.01%, 500=3D0.01%
  cpu          : usr=3D0.34%, sys=3D1.72%, ctx=3D598702, majf=3D0, minf=
=3D880
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D268032/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D32761MB, aggrb=3D1749.1MB/s, minb=3D1749.1MB/s, maxb=3D17=
49.1MB/s, mint=3D18721msec, maxt=3D18721msec

Disk stats (read/write):
  rssda: ios=3D17/582983, merge=3D0/105212, ticks=3D10/1548520, in_queu=
e=3D1550910, util=3D97.94%

******** ext4:
dio-append: (g=3D0): rw=3Dwrite, bs=3D4K-256K/4K-256K/4K-256K, ioengine=
=3Dlibaio, iodepth=3D1
=2E..
fio-2.6
Starting 64 processes

dio-append: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D3918: Mon Mar  7 =
19:55:39 2016
  write: io=3D32761MB, bw=3D525943KB/s, iops=3D4202, runt=3D 63785msec
    slat (usec): min=3D61, max=3D60044, avg=3D15209.43, stdev=3D5451.60
    clat (usec): min=3D0, max=3D87, avg=3D 0.83, stdev=3D 0.58
     lat (usec): min=3D62, max=3D60046, avg=3D15210.80, stdev=3D5451.62
    clat percentiles (usec):
     |  1.00th=3D[    0],  5.00th=3D[    0], 10.00th=3D[    0], 20.00th=
=3D[    1],
     | 30.00th=3D[    1], 40.00th=3D[    1], 50.00th=3D[    1], 60.00th=
=3D[    1],
     | 70.00th=3D[    1], 80.00th=3D[    1], 90.00th=3D[    1], 95.00th=
=3D[    1],
     | 99.00th=3D[    2], 99.50th=3D[    2], 99.90th=3D[    8], 99.95th=
=3D[    8],
     | 99.99th=3D[   11]
    bw (KB  /s): min=3D 5299, max=3D10240, per=3D1.56%, avg=3D8228.68, =
stdev=3D565.95
    lat (usec) : 2=3D98.66%, 4=3D1.12%, 10=3D0.20%, 20=3D0.01%, 50=3D0.=
01%
    lat (usec) : 100=3D0.01%
  cpu          : usr=3D0.06%, sys=3D0.11%, ctx=3D273881, majf=3D0, minf=
=3D754
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D268032/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D32761MB, aggrb=3D525942KB/s, minb=3D525942KB/s, maxb=3D52=
5942KB/s, mint=3D63785msec, maxt=3D63785msec

Disk stats (read/write):
  rssda: ios=3D206/403691, merge=3D0/1246, ticks=3D3100/6279220, in_que=
ue=3D6284330, util=3D99.88%

******** xfs:
dio-append: (g=3D0): rw=3Dwrite, bs=3D4K-256K/4K-256K/4K-256K, ioengine=
=3Dlibaio, iodepth=3D1
=2E..
fio-2.6
Starting 64 processes

dio-append: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D4005: Mon Mar  7 =
19:56:43 2016
  write: io=3D32761MB, bw=3D528170KB/s, iops=3D4219, runt=3D 63516msec
    slat (usec): min=3D12, max=3D398, avg=3D48.88, stdev=3D14.56
    clat (usec): min=3D40, max=3D54468, avg=3D15107.79, stdev=3D6083.06
     lat (usec): min=3D76, max=3D54553, avg=3D15156.94, stdev=3D6086.18
    clat percentiles (usec):
     |  1.00th=3D[ 2544],  5.00th=3D[ 4704], 10.00th=3D[ 6816], 20.00th=
=3D[ 9792],
     | 30.00th=3D[11712], 40.00th=3D[13504], 50.00th=3D[15168], 60.00th=
=3D[16768],
     | 70.00th=3D[18560], 80.00th=3D[20352], 90.00th=3D[23168], 95.00th=
=3D[24704],
     | 99.00th=3D[28288], 99.50th=3D[30592], 99.90th=3D[35072], 99.95th=
=3D[36096],
     | 99.99th=3D[42752]
    bw (KB  /s): min=3D 6166, max=3D10827, per=3D1.56%, avg=3D8264.22, =
stdev=3D490.87
    lat (usec) : 50=3D0.01%, 100=3D0.01%, 250=3D0.01%, 500=3D0.01%, 750=
=3D0.01%
    lat (usec) : 1000=3D0.03%
    lat (msec) : 2=3D0.40%, 4=3D3.24%, 10=3D17.37%, 20=3D56.64%, 50=3D2=
2.31%
    lat (msec) : 100=3D0.01%
  cpu          : usr=3D0.08%, sys=3D0.34%, ctx=3D270879, majf=3D0, minf=
=3D776
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D268032/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D32761MB, aggrb=3D528170KB/s, minb=3D528170KB/s, maxb=3D52=
8170KB/s, mint=3D63516msec, maxt=3D63516msec

Disk stats (read/write):
  rssda: ios=3D64/400943, merge=3D0/269, ticks=3D860/6368640, in_queue=3D=
6380330, util=3D99.94%

******** btrfs:
dio-append: (g=3D0): rw=3Dwrite, bs=3D4K-256K/4K-256K/4K-256K, ioengine=
=3Dlibaio, iodepth=3D1
=2E..
fio-2.6
Starting 64 processes

dio-append: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D4146: Mon Mar  7 =
19:57:45 2016
  write: io=3D32761MB, bw=3D543980KB/s, iops=3D4346, runt=3D 61670msec
    slat (usec): min=3D104, max=3D71886, avg=3D14715.33, stdev=3D7480.3=
4
    clat (usec): min=3D0, max=3D444, avg=3D 1.21, stdev=3D 2.34
     lat (usec): min=3D109, max=3D71888, avg=3D14717.45, stdev=3D7480.3=
3
    clat percentiles (usec):
     |  1.00th=3D[    0],  5.00th=3D[    1], 10.00th=3D[    1], 20.00th=
=3D[    1],
     | 30.00th=3D[    1], 40.00th=3D[    1], 50.00th=3D[    1], 60.00th=
=3D[    1],
     | 70.00th=3D[    1], 80.00th=3D[    1], 90.00th=3D[    2], 95.00th=
=3D[    2],
     | 99.00th=3D[    2], 99.50th=3D[    3], 99.90th=3D[   14], 99.95th=
=3D[   23],
     | 99.99th=3D[   89]
    bw (KB  /s): min=3D 5235, max=3D10191, per=3D1.56%, avg=3D8511.05, =
stdev=3D534.02
    lat (usec) : 2=3D82.55%, 4=3D17.04%, 10=3D0.25%, 20=3D0.09%, 50=3D0=
=2E05%
    lat (usec) : 100=3D0.01%, 250=3D0.01%, 500=3D0.01%
  cpu          : usr=3D0.08%, sys=3D0.29%, ctx=3D289158, majf=3D0, minf=
=3D834
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued    : total=3Dr=3D0/w=3D268032/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
1

Run status group 0 (all jobs):
  WRITE: io=3D32761MB, aggrb=3D543980KB/s, minb=3D543980KB/s, maxb=3D54=
3980KB/s, mint=3D61670msec, maxt=3D61670msec
