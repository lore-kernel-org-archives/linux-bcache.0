From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: echo dev > /sys/fs/bcache/register gives page allocation
 failure: order:4, mode:0x2040d0
Date: Mon, 15 Feb 2016 13:02:55 +0100
Message-ID: <20160215120255.GE18134@c203.arch.suse.de>
References: <20160215060410.GA30802@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbcBOMC6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 15 Feb 2016 07:02:58 -0500
Content-Disposition: inline
In-Reply-To: <20160215060410.GA30802@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Sun, Feb 14, 2016 at 10:04:10PM -0800, Marc MERLIN wrote:
> I was able to make one bcache ok, but when trying to make a 2nd one
> where I only have a backing device, I'm getting repeated page allocat=
ion
> failures.
>=20
> Just to be clear, this is what I want to do: every new HD backed devi=
ce
> will have bcache on top even if I don't have a cache device for it, s=
o
> that I can add bcache later.
> Is it something reasonable to do? Setup partitions as bcache backing
> devices without a cache device for them?
>=20
> So right now, I'm trying to do
> md5 - bcache - dmcrypt - btrfs
>=20
> So I did
> make-bcache -B /dev/md5
> echo /dev/md5 > /sys/fs/bcache/register
>=20
> and it fails:
> bash: page allocation failure: order:4, mode:0x2040d0

Is this system under some kind of memory preassure? Did this happen rig=
ht
after boot or when the system was already running for quite some time?

> CPU: 2 PID: 28043 Comm: bash Not tainted 4.3.3-amd64-i915-volpreempt-=
20150421 #2
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, B=
IOS 3904 04/27/2013
>  0000000000000000 ffff88006f65ba78 ffffffff8134150e 0000000000000001
>  ffff88006f65bb10 ffffffff8111f6ce ffff88021f5f4e38 00000004002040d0
>  0000000400000040 0000000000000286 0000000000000004 0000000000000040
> Call Trace:
>  [<ffffffff8134150e>] dump_stack+0x44/0x55
>  [<ffffffff8111f6ce>] warn_alloc_failed+0x111/0x129
>  [<ffffffff811220f8>] __alloc_pages_nodemask+0x6ae/0x70d
>  [<ffffffff8115fb98>] kmem_getpages+0x6a/0x162
>  [<ffffffff8115fd89>] fallback_alloc+0xf9/0x193
>  [<ffffffff8115ff46>] ____cache_alloc_node+0x123/0x130
>  [<ffffffff81160f1e>] __kmalloc+0xf8/0x175
>  [<ffffffffc057e141>] ? kzalloc.constprop.22+0xe/0x10 [bcache]
>  [<ffffffffc057e141>] kzalloc.constprop.22+0xe/0x10 [bcache]
>  [<ffffffffc0580986>] register_bcache+0x61b/0x1452 [bcache]
>  [<ffffffff81342ce0>] kobj_attr_store+0x10/0x1a
>  [<ffffffff811d9677>] sysfs_kf_write+0x39/0x3b
>  [<ffffffff811d8f79>] kernfs_fop_write+0xed/0x130
>  [<ffffffff81177a05>] __vfs_write+0x26/0xa5
>  [<ffffffff816c0fdd>] ? _raw_spin_lock+0xe/0x10
>  [<ffffffff81179277>] ? fput+0x16/0x88
>  [<ffffffff812cd113>] ? security_file_permission+0x3b/0x42
>  [<ffffffff8108e79b>] ? percpu_down_read+0x14/0x46
>  [<ffffffff81179ba7>] ? __sb_start_write+0x25/0x3c
>  [<ffffffff81178067>] vfs_write+0xa2/0xe6
>  [<ffffffff81178835>] SyS_write+0x4d/0x78
>  [<ffffffff816c3962>] sysenter_dispatch+0xf/0x29
> Mem-Info:
> active_anon:412014 inactive_anon:222645 isolated_anon:0
>  active_file:461209 inactive_file:499016 isolated_file:0
>  unevictable:1166 dirty:28999 writeback:712 unstable:0
>  slab_reclaimable:69514 slab_unreclaimable:47678
>  mapped:420280 shmem:410182 pagetables:5369 bounce:0
>  free:131404 free_pcp:1088 free_cma:0
> Node 0 DMA free:15888kB min:20kB low:24kB high:28kB active_anon:0kB i=
nactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isol=
ated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlock=
ed:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0k=
B slab_unreclaimable:4kB kernel_stack:0kB pagetables:0kB unstable:0kB b=
ounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pag=
es_scanned:0 all_unreclaimable? yes
> lowmem_reserve[]: 0 3203 7674 7674
> Node 0 DMA32 free:462160kB min:4644kB low:5804kB high:6964kB active_a=
non:443844kB inactive_anon:470452kB active_file:755044kB inactive_file:=
897988kB unevictable:1488kB isolated(anon):0kB isolated(file):0kB prese=
nt:3362068kB managed:3283400kB mlocked:1488kB dirty:21656kB writeback:2=
912kB mapped:703428kB shmem:665604kB slab_reclaimable:71416kB slab_unre=
claimable:69108kB kernel_stack:7056kB pagetables:6732kB unstable:0kB bo=
unce:0kB free_pcp:3008kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB p=
ages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 4471 4471
> Node 0 Normal free:26576kB min:6480kB low:8100kB high:9720kB active_a=
non:1199644kB inactive_anon:420120kB active_file:1091280kB inactive_fil=
e:1101072kB unevictable:3176kB isolated(anon):0kB isolated(file):0kB pr=
esent:4708352kB managed:4578508kB mlocked:3176kB dirty:78692kB writebac=
k:8900kB mapped:977740kB shmem:975112kB slab_reclaimable:206628kB slab_=
unreclaimable:124308kB kernel_stack:5120kB pagetables:14888kB unstable:=
0kB bounce:0kB free_pcp:3364kB local_pcp:0kB free_cma:0kB writeback_tmp=
:0kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0 0
> Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*25=
6kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) =3D 15888kB
> Node 0 DMA32: 79732*4kB (UEM) 17590*8kB (UEM) 151*16kB (UM) 1*32kB (U=
) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 462096k=
B
> Node 0 Normal: 4435*4kB (UEM) 5*8kB (UE) 0*16kB 0*32kB 0*64kB 0*128kB=
 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 17780kB
> Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=3D0 huge=
pages_size=3D2048kB
> 1387415 total pagecache pages
> 11051 pages in swap cache
> Swap cache stats: add 4480800, delete 4469749, find 1201429612/120224=
0702
> Free swap  =3D 14096744kB
> Total swap =3D 15616764kB
> 2021599 pages RAM
> 0 pages HighMem/MovableOnly
> 52149 pages reserved
> 4096 pages cma reserved
> 0 pages hwpoisoned
> bcache: register_bcache() error opening /dev/md5: (null)
>=20
> Any idea what's going on?
>=20
> gargamel:~# free
>              total       used       free     shared    buffers     ca=
ched
> Mem:       7877800    6065272    1812528          0        224    419=
3616
> -/+ buffers/cache:    1871432    6006368
> Swap:     15616764    1519056   14097708
> gargamel:~# cat /proc/meminfo=20
> MemTotal:        7877800 kB
> MemFree:         1799936 kB
> MemAvailable:    4602768 kB
> Buffers:             224 kB
> Cached:          4208328 kB
> SwapCached:        44472 kB
> Active:          3595380 kB
> Inactive:        1508064 kB
> Active(anon):    1647420 kB
> Inactive(anon):   891972 kB
> Active(file):    1947960 kB
> Inactive(file):   616092 kB
> Unevictable:        4664 kB
> Mlocked:            4664 kB
> SwapTotal:      15616764 kB
> SwapFree:       14097712 kB
> Dirty:            104932 kB
> Writeback:             0 kB
> AnonPages:        876480 kB
> Mapped:          1679836 kB
> Shmem:           1640716 kB
> Slab:             469492 kB
> SReclaimable:     280564 kB
> SUnreclaim:       188928 kB
> KernelStack:       12288 kB
> PageTables:        21264 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    19555664 kB
> Committed_AS:    7995116 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      409412 kB
> VmallocChunk:   34358947836 kB
> HardwareCorrupted:     0 kB
> AnonHugePages:         0 kB
> CmaTotal:          16384 kB
> CmaFree:             232 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:      740628 kB
> DirectMap2M:     7346176 kB
>=20
> Thanks,
> Marc
> --=20
> "A mouse is a device used to point at the xterm you want to type in" =
- A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourm=
et cooking
> Home page: http://marc.merlins.org/                         | PGP 102=
4R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
