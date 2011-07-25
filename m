From: i- <itooo-xVucS5mfmt0AvxtiuMwx3w@public.gmane.org>
Subject: Re: Not a bcache superblock
Date: Mon, 25 Jul 2011 18:43:40 +0200
Message-ID: <4E2D9D3C.5020807@itooo.com>
References: <loom.20110725T180931-69@post.gmane.org> <4E2D96E3.8050709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E2D96E3.8050709-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Le 25/07/2011 18:16, Kent Overstreet a =E9crit :
> On 07/25/11 09:14, i- wrote:
>> Hi all,
>>
>> When trying to register a device with bcache, I have the following=20
>> error message
>> : "bcache: error opening /dev/sdb1: Not a bcache superblock"
>>
>> Digging around showed me the magic number could not be matched,=20
>> digging a bit
>> more I found out that the cache_sb structures are different in the=20
>> tools code
>> and in the kernel code.
>>
>> There are 3 fields before the magic in the tools' bcache.h but the=20
>> magic is the
>> first field in bcache.c in the linux module code...
>>
>> Am I out of sync between repos ? (I cloned them both today)
>
> Yeah, I just uploaded a new version of the tools and the matching=20
> version of bcache isn't up yet.
>
> Do a "git checkout HEAD^" in the bcache-tools repo to get a version=20
> that'll work.

Thanks for your very fast reply.

I could register devices and attach them to the bcache instance, but as=
=20
soon as I try to access /dev/bcache0 the kernel hangs.
ls after having mounted it (backing device not yet attached) or just=20
mounting it after reboot (the attachement is done automatically right?)=
=2E

I'lll try to figure this out tomorrow or maybe you will have uploaded=20
new code before that.

Regards,

Trace, for your records:

Unable to handle kernel NULL pointer dereference at virtual address 000=
00130
pgd =3D c0004000
[00000130] *pgd=3D00000000
Internal error: Oops: 17 [#1] SMP
last sysfs file: /sys/devices/virtual/block/bcache0/removable
Modules linked in:
CPU: 0    Not tainted  (2.6.35.9 #4)
PC is at bio_insert+0x56c/0x8b4
LR is at bio_insert+0x568/0x8b4
pc : [<c0403abc>]    lr : [<c0403ab8>]    psr: 80000013
sp : e094de60  ip : 00000000  fp : e094df3c
r10: e1b54640  r9 : e1927000  r8 : e1b9eb28
r7 : e1a8be60  r6 : 00000000  r5 : e1b545e8  r4 : e1b9eb20
r3 : ffffffe8  r2 : 00000008  r1 : 00000192  r0 : 7598001e
=46lags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 00c5387d  Table: 218a401a  DAC: 00000017
Process bcache/0 (pid: 244, stack limit =3D 0xe094c270)
Stack: (0xe094de60 to 0xe094e000)
de60: e1b9eb30 00000000 e00eeea0 e1ae1da0 e094de8c e094de80 c01dc298=20
c02012d8
de80: 00000000 e1b54640 00000009 00000000 e1ae1da0 e00ea840 e1b54638=20
e1b546c0
dea0: e0147680 c16605a0 c018d068 00000002 00000000 e094c000 00000000=20
e0224000
dec0: 98001e00 00e19275 c00467ec c018d074 ffffffff e022401c e0147680=20
00000017
dee0: 00000000 00000001 00000000 00000000 c05e5498 e1b546e0 00000001=20
00000000
df00: 00000000 80000000 00000010 00000000 e094c000 e1b545e8 e1a8be60=20
00000000
df20: e094df50 c1664584 00000000 e1b545e8 e094df6c e094df40 c0404394=20
c040355c
df40: e094df6c e094df50 c0404324 c03f44e8 c1664580 e094c000 c0404440=20
c166458c
df60: e094df7c e094df70 c0404464 c0404300 e094dfbc e094df80 c01af220=20
c040444c
df80: 00000000 00000000 e0147680 c01b2b14 e094df90 e094df90 e002dee4=20
e094dfc8
dfa0: c01af110 c1664580 00000000 00000000 e094dff4 e094dfc0 c01b2718=20
c01af11c
dfc0: e002dee4 00000000 00000000 00000000 e094dfd0 e094dfd0 e002dee4=20
c01b2694
dfe0: c019fdb8 00000013 00000000 e094dff8 c019fdb8 c01b26a0 c4c3a0c4=20
cc580454
Backtrace:
[<c0403550>] (bio_insert+0x0/0x8b4) from [<c0404394>]=20
(cache_request+0xa0/0xd0)
[<c04042f4>] (cache_request+0x0/0xd0) from [<c0404464>]=20
(closure_wq+0x24/0x28)
  r7:c166458c r6:c0404440 r5:e094c000 r4:c1664580
[<c0404440>] (closure_wq+0x0/0x28) from [<c01af220>]=20
(worker_thread+0x110/0x19c)
[<c01af110>] (worker_thread+0x0/0x19c) from [<c01b2718>] (kthread+0x84/=
0x8c)
[<c01b2694>] (kthread+0x0/0x8c) from [<c019fdb8>] (do_exit+0x0/0x63c)
  r7:00000013 r6:c019fdb8 r5:c01b2694 r4:e002dee4
Code: e5992510 e50bc0bc ebf0d2e8 e51bc0bc (e59c2130)
---[ end trace b51d7895bb4c8b9a ]---
