From: Marc MERLIN <marc@merlins.org>
Subject: Re: echo dev > /sys/fs/bcache/register gives page allocation failure: order:4, mode:0x2040d0
Date: Tue, 23 Feb 2016 08:32:43 -0800
Message-ID: <20160223163243.GB6467@merlins.org>
References: <20160215060410.GA30802@merlins.org> <20160215121104.GA30514@kmo-pixel> <20160215060410.GA30802@merlins.org> <20160215120255.GE18134@c203.arch.suse.de> <20160215153236.GI4115@merlins.org> <56C1F2A4.4090208@evilazrael.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47383 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcBWQco (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 23 Feb 2016 11:32:44 -0500
Content-Disposition: inline
In-Reply-To: <56C1F2A4.4090208@evilazrael.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-bcache@vger.kernel.org

On Mon, Feb 15, 2016 at 04:45:40PM +0100, Christoph Nelles wrote:
> Hello Marc,
> Am 15.02.2016 um 16:32 schrieb Marc MERLIN:
> >>>and it fails:
> >>>bash: page allocation failure: order:4, mode:0x2040d0
> >>You want CONFIG_COMPACTION=y
> >Good suggestion, but I already have it:
> >gargamel:~# grep CONFIG_COMPACTION 
> >/boot/config-4.3.3-amd64-i915-volpreempt-20150421
> >CONFIG_COMPACTION=y
> >
> >Thanks for the replies,
> >Marc
> Maybe increasing vm.min_free_kbytes helps you.

That was a good suggestion, but it didn't help.
Looks like I'm going to have to reboot, even though everything else works,
and it's not a good time to reboot that machine...

gargamel:/sys/fs/bcache# echo 256000 > /proc/sys/vm/min_free_kbytes
gargamel:/sys/fs/bcache# echo /dev/md5 >  /sys/fs/bcache/register
kernel: bash: page allocation failure: order:4, mode:0x2040d0
kernel: CPU: 4 PID: 24535 Comm: bash Not tainted 4.3.3-amd64-i915-volpreempt-20150421 #2
kernel: Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
kernel:  0000000000000000 ffff88001856ba78 ffffffff8134150e 0000000000000001
kernel:  ffff88001856bb10 ffffffff8111f6ce ffff88021f5f4e38 00000004002040d0
kernel:  0000000400000040 0000000000000000 0000000000000004 0000000000000040
kernel: Call Trace:
kernel:  [<ffffffff8134150e>] dump_stack+0x44/0x55
kernel:  [<ffffffff8111f6ce>] warn_alloc_failed+0x111/0x129
kernel:  [<ffffffff811220f8>] __alloc_pages_nodemask+0x6ae/0x70d
kernel:  [<ffffffff8115fb98>] kmem_getpages+0x6a/0x162
kernel:  [<ffffffff8115fd89>] fallback_alloc+0xf9/0x193
kernel:  [<ffffffff8115ff46>] ____cache_alloc_node+0x123/0x130
kernel:  [<ffffffff81160f1e>] __kmalloc+0xf8/0x175
kernel:  [<ffffffffc057e141>] ? kzalloc.constprop.22+0xe/0x10 [bcache]
kernel:  [<ffffffffc057e141>] kzalloc.constprop.22+0xe/0x10 [bcache]
kernel:  [<ffffffffc0580986>] register_bcache+0x61b/0x1452 [bcache]
kernel:  [<ffffffff81342ce0>] kobj_attr_store+0x10/0x1a
kernel:  [<ffffffff811d9677>] sysfs_kf_write+0x39/0x3b
kernel:  [<ffffffff811d8f79>] kernfs_fop_write+0xed/0x130
kernel:  [<ffffffff81177a05>] __vfs_write+0x26/0xa5
kernel:  [<ffffffff816c0fdd>] ? _raw_spin_lock+0xe/0x10
kernel:  [<ffffffff81179277>] ? fput+0x16/0x88
kernel:  [<ffffffff812cd113>] ? security_file_permission+0x3b/0x42
kernel:  [<ffffffff8108e79b>] ? percpu_down_read+0x14/0x46
kernel:  [<ffffffff81179ba7>] ? __sb_start_write+0x25/0x3c
kernel:  [<ffffffff81178067>] vfs_write+0xa2/0xe6
kernel:  [<ffffffff81178835>] SyS_write+0x4d/0x78
kernel:  [<ffffffff816c3962>] sysenter_dispatch+0xf/0x29
kernel: Mem-Info:
kernel: active_anon:382212 inactive_anon:207983 isolated_anon:0
kernel:  active_file:382287 inactive_file:380967 isolated_file:0
kernel:  unevictable:1682 dirty:42944 writeback:138650 unstable:0
kernel:  slab_reclaimable:74240 slab_unreclaimable:64114
kernel:  mapped:419342 shmem:410117 pagetables:5535 bounce:0
kernel:  free:294984 free_pcp:1311 free_cma:58
kernel: Node 0 DMA free:15892kB min:516kB low:644kB high:772kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
kernel: lowmem_reserve[]: 0 3203 7674 7674
kernel: Node 0 DMA32 free:797024kB min:106696kB low:133368kB high:160044kB active_anon:409972kB inactive_anon:435264kB active_file:684968kB inactive_file:679124kB unevictable:3612kB isolated(anon):0kB isolated(file):0kB present:3362068kB managed:3283400kB mlocked:3612kB dirty:136096kB writeback:33480kB mapped:698284kB shmem:663532kB slab_reclaimable:79300kB slab_unreclaimable:80900kB kernel_stack:7680kB pagetables:5920kB unstable:0kB bounce:0kB free_pcp:684kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
kernel: lowmem_reserve[]: 0 0 4471 4471
kernel: Node 0 Normal free:372484kB min:148784kB low:185980kB high:223176kB active_anon:1117868kB inactive_anon:396668kB active_file:842520kB inactive_file:842900kB unevictable:3116kB isolated(anon):0kB isolated(file):0kB present:4708352kB managed:4578508kB mlocked:3116kB dirty:37936kB writeback:521120kB mapped:979084kB shmem:976936kB slab_reclaimable:217660kB slab_unreclaimable:175556kB kernel_stack:4448kB pagetables:16220kB unstable:0kB bounce:0kB free_pcp:1864kB local_pcp:0kB free_cma:232kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
kernel: lowmem_reserve[]: 0 0 0 0
kernel: Node 0 DMA: 1*4kB (U) 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15892kB
kernel: Node 0 DMA32: 72789*4kB (UEM) 59674*8kB (UE) 1691*16kB (U) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 795604kB
kernel: Node 0 Normal: 75526*4kB (UE) 13664*8kB (U) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 411416kB
kernel: Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
kernel: 1200434 total pagecache pages
kernel: 26303 pages in swap cache
kernel: Swap cache stats: add 6374359, delete 6348056, find 1218002292/1219256059
kernel: Free swap  = 13686312kB
kernel: Total swap = 15616764kB
kernel: 2021599 pages RAM
kernel: 0 pages HighMem/MovableOnly
kernel: 52149 pages reserved
kernel: 4096 pages cma reserved
kernel: 0 pages hwpoisoned
bash: echo: write error: Invalid argument

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
