From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Fri, 25 Mar 2016 03:52:11 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603250350580.13440@mail.ewheeler.net>
References: <CA+nZN+i0fmEc0Uz1X5k0DJaNB_sNu2EP0dEUy32_ipsW66MFmA@mail.gmail.com> <alpine.LRH.2.11.1603090344040.15354@mail.ewheeler.net> <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net> <20160310021516.GM14112@merlins.org> <20160310152958.GR14112@merlins.org>
 <20160324212553.GS27494@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:34807 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750797AbcCYDwX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 24 Mar 2016 23:52:23 -0400
In-Reply-To: <20160324212553.GS27494@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Richard Bade <hitrich@gmail.com>, linux-bcache@vger.kernel.org

On Thu, 24 Mar 2016, Marc MERLIN wrote:

> On Thu, Mar 10, 2016 at 07:29:58AM -0800, Marc MERLIN wrote:
> > On Wed, Mar 09, 2016 at 06:15:16PM -0800, Marc MERLIN wrote:
> > > On Thu, Mar 10, 2016 at 01:34:56AM +0000, Eric Wheeler wrote:
> > > > Hi Richard, Marc,
> > > > 
> > > > >>> [290623.673871] bcache-register: page allocation failure: order:7, mode:0x24080c0
> > > > 
> > > > Do you still have the backtraces that show the function call stack for 
> > > > errors that look like this?
> > > > 	%s: page allocation failure: order:%d, mode:0x%x 
> > > > 
> > > > Please send as many relevant OOM failure traces that you can.  I would 
> > > > like to see which memory allocation(s) are failing and if they are always 
> > > > the same stack trace.
> > >  
> > > It's the same one I already sent you, just from syslog instead of serial
> > > console (I was looking for other relevant cronjobs or errors per your
> > > request)
> >  
> > Ok, here's a new one with your patches installed. Good thing is that
> > kernel didn't crash. But adding caching device still failed.
> 
> Mmmh, so I just stopped a bcache, made another one with make-bcache, and my machine died.
> 
> Sadly, the actual crash wasn't captured due to my serial console server having failed.
> I got this below from remote syslog, the real crash happened later and wasn't logged.
> 
> Hope this helps.
> 
> bcache-register: page allocation failure: order:7, mode:0x24080c0

Unfortunately it only shows me that you're out of memory and that the 
kernel can't find 512k of contiguous memory to allocate.  The crash might 
be related to high memory pressure, or it could be something else---but 
without the crash trace I can only speculate.

-Eric

> CPU: 0 PID: 13517 Comm: bcache-register Not tainted 4.4.2-amd64-i915-volpreempt-sysrq-20160214bc5 #8
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>  0000000000000000 ffff88037cb4fb00 ffffffff8134ae4a 0000000000000001
>  ffff88037cb4fb98 ffffffff81124b00 024080c07cb4fc3c 024080c000000040
>  0000000700000001 0000000000000007 0000000000000007 0000000000000040
> Call Trace:
>  [<ffffffff8134ae4a>] dump_stack+0x44/0x55
>  [<ffffffff81124b00>] warn_alloc_failed+0x114/0x12c
>  [<ffffffff81127502>] __alloc_pages_nodemask+0x7cb/0x84c
>  [<ffffffff8107dfca>] ? try_to_wake_up+0x1d9/0x1eb
>  [<ffffffff8115f721>] alloc_pages_current+0xa9/0xcd
>  [<ffffffff811237c8>] __get_free_pages+0xe/0x3c
>  [<ffffffffc059530b>] bch_cache_set_alloc+0x3c7/0x479 [bcache]
>  [<ffffffffc05965ea>] register_bcache+0x122d/0x143c [bcache]
>  [<ffffffff8134c893>] kobj_attr_store+0x10/0x1a
>  [<ffffffff811dfa29>] sysfs_kf_write+0x39/0x3b
>  [<ffffffff811df32b>] kernfs_fop_write+0xed/0x130
>  [<ffffffff8117d9c7>] __vfs_write+0x26/0xa5
>  [<ffffffff810b29b3>] ? current_kernel_time64+0x10/0x36
>  [<ffffffff812d609a>] ? security_file_permission+0x3b/0x42
>  [<ffffffff81091634>] ? percpu_down_read+0x12/0x41
>  [<ffffffff8117fbab>] ? __sb_start_write+0x2b/0x48
>  [<ffffffff8117e032>] vfs_write+0x9d/0xe8
>  [<ffffffff8117e807>] SyS_write+0x4d/0x78
>  [<ffffffff810039c3>] do_fast_syscall_32+0xb3/0xf3
>  [<ffffffff816e3e72>] sysenter_flags_fixed+0x8/0x12
> Mem-Info:
> active_anon:468787 inactive_anon:167077 isolated_anon:0
>  active_file:1380425 inactive_file:1192252 isolated_file:0
>  unevictable:1474 dirty:39397 writeback:3372 unstable:0
>  slab_reclaimable:164804 slab_unreclaimable:70389
>  mapped:416857 shmem:409963 pagetables:4551 bounce:0
>  free:302751 free_pcp:1140 free_cma:384
> Node 0 DMA free:15892kB min:256kB low:320kB high:384kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB ilowmem_reserve[]: 0 3201 15736 15736
> Node 0 DMA32 free:554388kB min:53336kB low:66668kB high:80004kB active_anon:185968kB inactive_anon:196384kB active_file:1429216kB inactive_flowmem_reserve[]: 0 0 12535 12535
> Node 0 Normal free:651784kB min:208544kB low:260680kB high:312816kB active_anon:1688260kB inactive_anon:471920kB active_file:4092556kB inact lowmem_reserve[]: 0 0 0 0
> Node 0 DMA: 1*4kB (U) 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15892kB
> Node 0 DMA32: 20169*4kB (UME) 59104*8kB (UME) 46*16kB (UM) 4*32kB (UM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 554372kB
> Node 0 Normal: 58345*4kB (UMEC) 40698*8kB (UMEC) 4028*16kB (UMEC) 430*32kB (UMEC) 160*64kB (UM) 35*128kB (UM) 10*256kB (M) 0*512kB 0*1024kB 
> Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
> 2991157 total pagecache pages
> 7348 pages in swap cache
> Swap cache stats: add 516663, delete 509315, find 10110495/10164991
> Free swap  = 14686944kB
> Total swap = 15616764kB
> 4118751 pages RAM
> 0 pages HighMem/MovableOnly
> 85016 pages reserved
> 4096 pages cma reserved
> 0 pages hwpoisoned
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
