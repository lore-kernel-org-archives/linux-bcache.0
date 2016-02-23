From: Marc MERLIN <marc@merlins.org>
Subject: Re: echo dev > /sys/fs/bcache/register gives page allocation
 failure: order:4, mode:0x2040d0
Date: Tue, 23 Feb 2016 12:57:30 -0800
Message-ID: <20160223205730.GT22487@merlins.org>
References: <20160215060410.GA30802@merlins.org>
 <20160215121104.GA30514@kmo-pixel>
 <20160215060410.GA30802@merlins.org>
 <20160215120255.GE18134@c203.arch.suse.de>
 <20160215153236.GI4115@merlins.org>
 <56C1F2A4.4090208@evilazrael.de>
 <20160223163243.GB6467@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50058 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbcBWU54 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 23 Feb 2016 15:57:56 -0500
Content-Disposition: inline
In-Reply-To: <20160223163243.GB6467@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-bcache@vger.kernel.org

On Tue, Feb 23, 2016 at 08:32:43AM -0800, Marc MERLIN wrote:
> On Mon, Feb 15, 2016 at 04:45:40PM +0100, Christoph Nelles wrote:
> > Hello Marc,
> > Am 15.02.2016 um 16:32 schrieb Marc MERLIN:
> > >>>and it fails:
> > >>>bash: page allocation failure: order:4, mode:0x2040d0
> > >>You want CONFIG_COMPACTION=y
> > >Good suggestion, but I already have it:
> > >gargamel:~# grep CONFIG_COMPACTION 
> > >/boot/config-4.3.3-amd64-i915-volpreempt-20150421
> > >CONFIG_COMPACTION=y
> > >
> > >Thanks for the replies,
> > >Marc
> > Maybe increasing vm.min_free_kbytes helps you.
> 
> That was a good suggestion, but it didn't help.
> Looks like I'm going to have to reboot, even though everything else works,
> and it's not a good time to reboot that machine...
> 
> gargamel:/sys/fs/bcache# echo 256000 > /proc/sys/vm/min_free_kbytes
> gargamel:/sys/fs/bcache# echo /dev/md5 >  /sys/fs/bcache/register

So, I rebooted, this worked, and then adding the cache failed similarly:
gargamel:/sys/block/dm-4/bcache# echo /dev/sdh2  > /sys/fs/bcache/register

Dump below. I had to reboot a 2nd time and register the cache device
quickly enough after boot, and then things worked.

I don't seem to have other memory issues on that (busy) server. Would
there be a way for bcache to allocate memory in a different way?
Either way, I'm set now, but the reboots were not great.

bash: page allocation failure: order:7, mode:0x24080c0
CPU: 3 PID: 20478 Comm: bash Not tainted 4.4.2-amd64-i915-volpreempt-20160213 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
 0000000000000000 ffff88001a987b38 ffffffff8134ae0a 0000000000000001
 ffff88001a987bd0 ffffffff81124ab6 024080c01a987c74 024080c000000040
 0000000700000001 0000000000000007 0000000000000007 0000000000000040
Call Trace:
 [<ffffffff8134ae0a>] dump_stack+0x44/0x55
 [<ffffffff81124ab6>] warn_alloc_failed+0x114/0x12c
 [<ffffffff811274b8>] __alloc_pages_nodemask+0x7cb/0x84c
 [<ffffffff8115f6d7>] alloc_pages_current+0xa9/0xcd
 [<ffffffff8112377e>] __get_free_pages+0xe/0x3c
 [<ffffffffc0514315>] register_bcache+0xf98/0x1452 [bcache]
 [<ffffffff8134c853>] kobj_attr_store+0x10/0x1a
 [<ffffffff811df9df>] sysfs_kf_write+0x39/0x3b
 [<ffffffff811df2e1>] kernfs_fop_write+0xed/0x130
 [<ffffffff8117d97d>] __vfs_write+0x26/0xa5
 [<ffffffff8117f228>] ? fput+0x16/0x88
 [<ffffffff810b2969>] ? current_kernel_time64+0x10/0x36
 [<ffffffff812d6050>] ? security_file_permission+0x3b/0x42
 [<ffffffff810915ea>] ? percpu_down_read+0x12/0x41
 [<ffffffff8117fb61>] ? __sb_start_write+0x2b/0x48
 [<ffffffff8117dfe8>] vfs_write+0x9d/0xe8
 [<ffffffff8117e7bd>] SyS_write+0x4d/0x78
 [<ffffffff810039c3>] do_fast_syscall_32+0xb3/0xf3
 [<ffffffff816e3e32>] sysenter_flags_fixed+0x8/0x12
Mem-Info:
active_anon:518645 inactive_anon:178721 isolated_anon:0
 active_file:447391 inactive_file:384565 isolated_file:0
 unevictable:1224 dirty:47288 writeback:32 unstable:0
 slab_reclaimable:60271 slab_unreclaimable:63130
 mapped:420136 shmem:411469 pagetables:4548 bounce:0
 free:23747 free_pcp:1820 free_cma:1140
Node 0 DMA free:15888kB min:20kB low:24kB high:28kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
IN=eth2 OUT= MAC=00:0e:c6:88:7c:ae:20:e5:2a:b7:f5:3f:08:00 SRC=186.188.43.126 DST=173.11.111.146 LEN=60 TOS=0x00 PREC=0x20 TTL=48 ID=15654 DF PROTO=TCP SPT=39231 DPT=23 WINDOW=5840 RES=0x00 SYN URGP=0 
IN=eth2 OUT= MAC=00:0e:c6:88:7c:ae:20:e5:2a:b7:f5:3f:08:00 SRC=186.188.43.126 DST=173.11.111.147 LEN=60 TOS=0x00 PREC=0x20 TTL=50 ID=62914 DF PROTO=TCP SPT=39232 DPT=23 WINDOW=5840 RES=0x00 SYN URGP=0   
lowmem_reserve[]: 0 3201 7672 7672  
Node 0 DMA32 free:56180kB min:4640kB low:5800kB high:6960kB active_anon:826344kB inactive_anon:284052kB active_file:880532kB inactive_file:596332kB unevictable:1564kB isolated(anon):0kB isolated(file):0kB present:3362068kB managed:3283032kB mlocked:1564kB dirty:26784kB writeback:48kB mapped:701412kB shmem:683748kB slab_reclaimable:86248kB slab_unreclaimable:99064kB kernel_stack:4912kB pagetables:6712kB unstable:0kB bounce:0kB free_pcp:3668kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
IN=eth2 OUT= MAC=00:0e:c6:88:7c:ae:20:e5:2a:b7:f5:3f:08:00 SRC=186.188.43.126 DST=173.11.111.149 LEN=60 TOS=0x00 PREC=0x20 TTL=50 ID=31705 DF PROTO=TCP SPT=39234 DPT=23 WINDOW=5840 RES=0x00 SYN URGP=0   
lowmem_reserve[]: 0 0 4471 4471  
Node 0 Normal free:18320kB min:6480kB low:8100kB high:9720kB active_anon:1248180kB inactive_anon:430832kB active_file:909944kB inactive_file:945776kB unevictable:3332kB isolated(anon):0kB isolated(file):0kB present:4708352kB managed:4578512kB mlocked:68719480068kB dirty:164332kB writeback:80kB mapped:979132kB shmem:962128kB slab_reclaimable:154832kB slab_unreclaimable:153456kB kernel_stack:6608kB pagetables:11484kB unstable:0kB bounce:0kB free_pcp:3744kB local_pcp:356kB free_cma:4560kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no  
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15888kB
Node 0 DMA32: 12*4kB (UME) 5672*8kB (UME) 577*16kB (UM) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 54656kB
Node 0 Normal: 691*4kB (UMEC) 276*8kB (UMEC) 131*16kB (UMEC) 88*32kB (UMEC) 75*64kB (UM) 11*128kB (UM) 2*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 16604kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
1246159 total pagecache pages
18 pages in swap cache
Swap cache stats: add 536, delete 518, find 1/1
Free swap  = 15614620kB
Total swap = 15616764kB
2021599 pages RAM
0 pages HighMem/MovableOnly
52240 pages reserved
4096 pages cma reserved
0 pages hwpoisoned
bcache: register_cache() error opening sdh2: cannot allocate memory


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
