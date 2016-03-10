From: Marc MERLIN <marc@merlins.org>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Thu, 10 Mar 2016 07:29:58 -0800
Message-ID: <20160310152958.GR14112@merlins.org>
References: <CA+nZN+i0fmEc0Uz1X5k0DJaNB_sNu2EP0dEUy32_ipsW66MFmA@mail.gmail.com>
 <alpine.LRH.2.11.1603090344040.15354@mail.ewheeler.net>
 <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net>
 <20160310021516.GM14112@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58940 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbcCJPaI (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 10 Mar 2016 10:30:08 -0500
Content-Disposition: inline
In-Reply-To: <20160310021516.GM14112@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Richard Bade <hitrich@gmail.com>, linux-bcache@vger.kernel.org

On Wed, Mar 09, 2016 at 06:15:16PM -0800, Marc MERLIN wrote:
> On Thu, Mar 10, 2016 at 01:34:56AM +0000, Eric Wheeler wrote:
> > Hi Richard, Marc,
> > 
> > >>> [290623.673871] bcache-register: page allocation failure: order:7, mode:0x24080c0
> > 
> > Do you still have the backtraces that show the function call stack for 
> > errors that look like this?
> > 	%s: page allocation failure: order:%d, mode:0x%x 
> > 
> > Please send as many relevant OOM failure traces that you can.  I would 
> > like to see which memory allocation(s) are failing and if they are always 
> > the same stack trace.
>  
> It's the same one I already sent you, just from syslog instead of serial
> console (I was looking for other relevant cronjobs or errors per your
> request)
 
Ok, here's a new one with your patches installed. Good thing is that
kernel didn't crash. But adding caching device still failed.

I can probably fix this by rebooting and re-registering my device at boot, but 
before I do this, an idea why I'm still getting memory issues?

gargamel:~# cat /proc/sys/vm/min_free_kbytes
262144

gargamel:/sys/block/md5/bcache# echo /dev/sdl2 > /sys/fs/bcache/register
bash: echo: write error: Invalid argument

[34688.183049] bash: page allocation failure: order:7, mode:0x24080c0
[34688.203133] CPU: 0 PID: 25275 Comm: bash Not tainted 4.4.2-amd64-i915-volpreempt-20160214bc4 #6
[34688.230667] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[34688.259444]  0000000000000000 ffff88043e58bb30 ffffffff8134ae0a 0000000000000001
[34688.284107]  ffff88043e58bbc8 ffffffff81124ab6 024080c03e58bc6c 024080c000000040
[34688.308281]  0000000700000001 0000000000000007 0000000000000007 0000000000000040
[34688.332378] Call Trace:
[34688.341070]  [<ffffffff8134ae0a>] dump_stack+0x44/0x55
[34688.358078]  [<ffffffff81124ab6>] warn_alloc_failed+0x114/0x12c
[34688.377326]  [<ffffffff811274b8>] __alloc_pages_nodemask+0x7cb/0x84c
[34688.397732]  [<ffffffff8115f6d7>] alloc_pages_current+0xa9/0xcd
[34688.417080]  [<ffffffff8112377e>] __get_free_pages+0xe/0x3c
[34688.435374]  [<ffffffffc05a631f>] register_bcache+0xf62/0x143c [bcache]
[34688.456857]  [<ffffffff8134c853>] kobj_attr_store+0x10/0x1a
[34688.475189]  [<ffffffff811df9df>] sysfs_kf_write+0x39/0x3b
[34688.493102]  [<ffffffff811df2e1>] kernfs_fop_write+0xed/0x130
[34688.511850]  [<ffffffff8117d97d>] __vfs_write+0x26/0xa5
[34688.528864]  [<ffffffff8117f228>] ? fput+0x16/0x88
[34688.545066]  [<ffffffff810b2969>] ? current_kernel_time64+0x10/0x36
[34688.565037]  [<ffffffff812d6050>] ? security_file_permission+0x3b/0x42
[34688.585872]  [<ffffffff810915ea>] ? percpu_down_read+0x12/0x41
[34688.604737]  [<ffffffff8117fb61>] ? __sb_start_write+0x2b/0x48
[34688.623560]  [<ffffffff8117dfe8>] vfs_write+0x9d/0xe8
[34688.640019]  [<ffffffff8117e7bd>] SyS_write+0x4d/0x78
[34688.656471]  [<ffffffff810039c3>] do_fast_syscall_32+0xb3/0xf3
[34688.675266]  [<ffffffff816e3e32>] sysenter_flags_fixed+0x8/0x12
[34688.694310] Mem-Info:
[34688.702368] active_anon:565495 inactive_anon:189125 isolated_anon:0
[34688.702368]  active_file:1996870 inactive_file:2265222 isolated_file:0
[34688.702368]  unevictable:1279 dirty:54238 writeback:0 unstable:0
[34688.702368]  slab_reclaimable:406092 slab_unreclaimable:66680
[34688.702368]  mapped:426230 shmem:411337 pagetables:5114 bounce:0
[34688.702368]  free:299621 free_pcp:762 free_cma:67
[34688.813209] Node 0 DMA free:15876kB min:168kB low:208kB high:252kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[34688.941523] lowmem_reserve[]: 0 3201 23800 23800
[34688.957205] Node 0 DMA32 free:425612kB min:35280kB low:44100kB high:52920kB active_anon:194436kB inactive_anon:205776kB active_file:718524kB inactive_file:1408480kB unevictable:584kB isolated(anon):0kB isolated(file):0kB present:3362068kB managed:3283032kB mlocked:68719477320kB dirty:2440kB writeback:0kB mapped:253824kB shmem:248508kB slab_reclaimable:118200kB slab_unreclaimable:34760kB kernel_stack:2304kB pagetables:1944kB unstable:0kB bounce:0kB free_pcp:1804kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[34689.105915] lowmem_reserve[]: 0 0 20599 20599
[34689.120492] Node 0 Normal free:755312kB min:226688kB low:283360kB high:340032kB active_anon:2068316kB inactive_anon:550724kB active_file:7268956kB inactive_file:7653284kB unevictable:4532kB isolated(anon):0kB isolated(file):0kB present:21485568kB managed:21093516kB mlocked:51539612084kB dirty:215820kB writeback:0kB mapped:1451096kB shmem:1396840kB slab_reclaimable:1506168kB slab_unreclaimable:231960kB kernel_stack:9248kB pagetables:18512kB unstable:0kB bounce:0kB free_pcp:1940kB local_pcp:92kB free_cma:268kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[34689.274142] lowmem_reserve[]: 0 0 0 0
[34689.286213] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15876kB
[34689.328035] Node 0 DMA32: 42110*4kB (UME) 31724*8kB (UME) 79*16kB (UME) 5*32kB (UM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 423656kB
[34689.371488] Node 0 Normal: 154990*4kB (UMEC) 16220*8kB (UMEC) 356*16kB (UME) 3*32kB (U) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 755512kB
[34689.416083] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[34689.442305] 4676126 total pagecache pages
[34689.455229] 1342 pages in swap cache
[34689.466865] Swap cache stats: add 7173, delete 5831, find 3279/3833
[34689.486591] Free swap  = 15592768kB
[34689.497974] Total swap = 15616764kB
[34689.509335] 6215903 pages RAM
[34689.519147] 0 pages HighMem/MovableOnly
[34689.531592] 117793 pages reserved
[34689.542475] 4096 pages cma reserved
[34689.553954] 0 pages hwpoisoned
[34689.564116] bcache: register_bcache() error opening /dev/sdl2: (null)

gargamel:~# cat /proc/meminfo 
MemTotal:       24392440 kB
MemFree:         1345756 kB
MemAvailable:   18880940 kB
Buffers:           15068 kB
Cached:         18575392 kB
SwapCached:         5356 kB
Active:         10383364 kB
Inactive:        9582652 kB
Active(anon):    2264292 kB
Inactive(anon):   759480 kB
Active(file):    8119072 kB
Inactive(file):  8823172 kB
Unevictable:        5116 kB
Mlocked:        120259089404 kB
SwapTotal:      15616764 kB
SwapFree:       15592168 kB
Dirty:            237576 kB
Writeback:             4 kB
AnonPages:       1375628 kB
Mapped:          1705744 kB
Shmem:           1645364 kB
Slab:            1842444 kB
SReclaimable:    1575944 kB
SUnreclaim:       266500 kB
KernelStack:       11488 kB
PageTables:        20376 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    27812984 kB
Committed_AS:    7463904 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
CmaTotal:          16384 kB
CmaFree:             540 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      394516 kB
DirectMap2M:    24469504 kB

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
