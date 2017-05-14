From: Marc MERLIN <marc@merlins.org>
Subject: Still have a problem registering cache devices without rebooting :(
Date: Sun, 14 May 2017 11:12:07 -0700
Message-ID: <20170514181207.2mhkrhgwfim4rwyf@merlins.org>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
 <20170514180126.yk7oip3d5yrddjie@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33198 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759220AbdENSMN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 May 2017 14:12:13 -0400
Content-Disposition: inline
In-Reply-To: <20170514180126.yk7oip3d5yrddjie@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Sun, May 14, 2017 at 11:01:26AM -0700, Marc MERLIN wrote:
> On Sun, May 14, 2017 at 10:58:40AM -0700, Marc MERLIN wrote:
> > bcache-tools (1.0.8-2+b1)
> > 
> > gargamel:~# make-bcache  -C /dev/sde2
> > Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
> > gargamel:~# make-bcache  --wipe-bcache -C /dev/sde2 
> > Device /dev/sde2 already has a non-bcache superblock, remove it using wipefs and wipefs -a
> > 
> > /dev/sde2 is an old bcache I'm reformatting.
> > The first message is correct
> > The 2nd one is not "/dev/sde2 already has a non-bcache superblock"
> > 
> > Clearly it can't have a bcache and not a bcache superblock, right?
>  
> Interesting, same problem/bug with -B:
> gargamel:~# make-bcache -B /dev/md8 
> Already a bcache device on /dev/md8, overwrite with --wipe-bcache
> gargamel:~# make-bcache --wipe-bcache -B /dev/md8 
> Device /dev/md8 already has a non-bcache superblock, remove it using wipefs and wipefs -a
 
Ok, sorry for the string of messages, now I see this, which is somewhat
related?

bcache: register_cache() error opening sde2: cache_alloc(): -ENOMEM
bcache: register_bcache() error opening /dev/sde2: (null)
bcache-register: page allocation failure: order:7, mode:0x14080c0(GFP_KERNEL|__GFP_ZERO), nodemask=(null)
bcache-register cpuset=/ mems_allowed=0
CPU: 2 PID: 3121 Comm: bcache-register Tainted: G     U  W       4.11.0-amd64-preempt-sysrq-20170406 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
Call Trace:
 dump_stack+0x61/0x7d
 warn_alloc+0xfc/0x18c
 __alloc_pages_slowpath+0xa7e/0xb31
 ? get_page_from_freelist+0x505/0x6a8
 __alloc_pages_nodemask+0x12c/0x1e0
 alloc_pages_current+0x9b/0xbd
 __get_free_pages+0xe/0x35
 register_bcache+0xf0a/0x13d1 [bcache]
 ? alloc_set_pte+0x2e6/0x380
 ? slab_pre_alloc_hook+0x1a/0x44
 kobj_attr_store+0x10/0x1c
 ? kobj_attr_store+0x10/0x1c
 sysfs_kf_write+0x3b/0x3d
 kernfs_fop_write+0xfd/0x144
 __vfs_write+0x35/0xc8
 ? security_file_permission+0x3b/0x42
 vfs_write+0xaf/0xf7
 SyS_write+0x5c/0x9f
 do_fast_syscall_32+0xb7/0xfe
 entry_SYSENTER_compat+0x4c/0x5b
RIP: 0023:0xf7737b39
RSP: 002b:00000000ffca57c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000583e6008
RDX: 000000000000000a RSI: 00000000ffca5894 RDI: 000000000000000a
RBP: 00000000583e6008 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Mem-Info:
active_anon:102432 inactive_anon:140679 isolated_anon:0
 active_file:2482347 inactive_file:329482 isolated_file:0
 unevictable:1522 dirty:1487 writeback:0 unstable:0
 slab_reclaimable:2289907 slab_unreclaimable:180271
 mapped:32166 shmem:919 pagetables:3727 bounce:0
 free:350647 free_pcp:552 free_cma:0
Node 0 active_anon:408268kB inactive_anon:562716kB active_file:9929388kB inactive_file:1317928kB unevictable:6088kB isolated(anon):0kB isolated(file):0kB mapped:128956kB dirty:5948kB writeback:0kB shmem:3384kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:0 all_unreclaimable? no
Node 0 DMA free:15876kB min:168kB low:208kB high:248kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15972kB managed:15888kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:12kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 3185 23768 23768 23768
Node 0 DMA32 free:979656kB min:35280kB low:44100kB high:52920kB active_anon:43200kB inactive_anon:86100kB active_file:631884kB inactive_file:358364kB unevictable:88kB writepending:4kB present:3362068kB managed:3283056kB mlocked:88kB slab_reclaimable:1061952kB slab_unreclaimable:80680kB kernel_stack:768kB pagetables:1512kB bounce:0kB free_pcp:232kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 0 20583 20583 20583
Node 0 Normal free:404000kB min:226688kB low:283360kB high:340032kB active_anon:365652kB inactive_anon:476616kB active_file:9297504kB inactive_file:959564kB unevictable:6000kB writepending:6380kB present:21485568kB managed:21093656kB mlocked:6000kB slab_reclaimable:8097676kB slab_unreclaimable:640392kB kernel_stack:11360kB pagetables:13396kB bounce:0kB free_pcp:5332kB local_pcp:736kB free_cma:0kB
lowmem_reserve[]: 0 0 0 0 0
Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15876kB
Node 0 DMA32: 55994*4kB (UME) 23984*8kB (UME) 11042*16kB (UME) 5401*32kB (UME) 1986*64kB (UME) 512*128kB (UM) 85*256kB (UME) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 979752kB
Node 0 Normal: 93707*4kB (UMEH) 3508*8kB (UMEH) 19*16kB (UMH) 13*32kB (H) 5*64kB (H) 6*128kB (H) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 404700kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
2833531 total pagecache pages
20198 pages in swap cache
Swap cache stats: add 5746713, delete 5727095, find 41192018/42153913
Free swap  = 15283452kB
Total swap = 15616764kB
6215902 pages RAM
0 pages HighMem/MovableOnly
117752 pages reserved
4096 pages cma reserved
0 pages hwpoisoned


That seems like the same old bug again that I'm not able to register a
bcache cache on a running system without rebooting it :(

argamel:/sys/block/bcache32# echo /dev/sde2  > /sys/fs/bcache/register
bash: page allocation failure: order:7, mode:0x14080c0(GFP_KERNEL|__GFP_ZERO), nodemask=(null)
bash cpuset=/ mems_allowed=0
CPU: 5 PID: 17222 Comm: bash Tainted: G     U  W       4.11.0-amd64-preempt-sysrq-20170406 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
Call Trace:
 dump_stack+0x61/0x7d
 warn_alloc+0xfc/0x18c
 __alloc_pages_slowpath+0xa7e/0xb31
 ? get_page_from_freelist+0x505/0x6a8
 __alloc_pages_nodemask+0x12c/0x1e0
 alloc_pages_current+0x9b/0xbd
 __get_free_pages+0xe/0x35
 register_bcache+0xf0a/0x13d1 [bcache]
 ? slab_pre_alloc_hook+0x1a/0x44
 kobj_attr_store+0x10/0x1c
 ? kobj_attr_store+0x10/0x1c
 sysfs_kf_write+0x3b/0x3d
 kernfs_fop_write+0xfd/0x144
 __vfs_write+0x35/0xc8
 ? fput+0x16/0x8a
 ? filp_close+0x67/0x71
 ? security_file_permission+0x3b/0x42
 vfs_write+0xaf/0xf7
 SyS_write+0x5c/0x9f
 do_fast_syscall_32+0xb7/0xfe
 entry_SYSENTER_compat+0x4c/0x5b
RIP: 0023:0xf7754b39
RSP: 002b:00000000ffe5a688 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00000000092fc408
RDX: 000000000000000a RSI: 00000000f76d7d60 RDI: 000000000000000a
RBP: 00000000092fc408 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Mem-Info:
active_anon:99187 inactive_anon:140700 isolated_anon:0
 active_file:2489556 inactive_file:328139 isolated_file:0
 unevictable:1530 dirty:31 writeback:7600 unstable:0
 slab_reclaimable:2288880 slab_unreclaimable:184331
 mapped:19547 shmem:978 pagetables:3872 bounce:0
 free:297980 free_pcp:1168 free_cma:0
Node 0 active_anon:396748kB inactive_anon:562800kB active_file:9958224kB inactive_file:1312556kB unevictable:6120kB isolated(anon):0kB isolated(file):0kB mapped:78188kB dirty:124kB writeback:30400kB shmem:3912kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB pages_scanned:1 all_unreclaimable? no
Node 0 DMA free:15876kB min:168kB low:208kB high:248kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15972kB managed:15888kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:12kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 3185 23768 23768 23768
Node 0 DMA32 free:892512kB min:35280kB low:44100kB high:52920kB active_anon:52468kB inactive_anon:86248kB active_file:632908kB inactive_file:361632kB unevictable:88kB writepending:1144kB present:3362068kB managed:3283056kB mlocked:88kB slab_reclaimable:1060108kB slab_unreclaimable:98556kB kernel_stack:1680kB pagetables:2860kB bounce:0kB free_pcp:3584kB local_pcp:60kB free_cma:0kB
lowmem_reserve[]: 0 0 20583 20583 20583
Node 0 Normal free:290224kB min:226688kB low:283360kB high:340032kB active_anon:344280kB inactive_anon:476552kB active_file:9325316kB inactive_file:951240kB unevictable:6032kB writepending:29380kB present:21485568kB managed:21093656kB mlocked:6032kB slab_reclaimable:8095412kB slab_unreclaimable:638756kB kernel_stack:11104kB pagetables:12628kB bounce:0kB free_pcp:2232kB local_pcp:252kB free_cma:0kB
lowmem_reserve[]: 0 0 0 0 0
Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15876kB
Node 0 DMA32: 51574*4kB (UME) 20985*8kB (UME) 8562*16kB (UME) 5364*32kB (UME) 1952*64kB (UME) 503*128kB (UM) 86*256kB (UME) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 894144kB
Node 0 Normal: 66404*4kB (EH) 2053*8kB (UMEH) 124*16kB (UMEH) 128*32kB (UMEH) 11*64kB (MEH) 7*128kB (MH) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 289720kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
2839584 total pagecache pages
20209 pages in swap cache
Swap cache stats: add 5746727, delete 5727098, find 41222108/42184007
Free swap  = 15283452kB
Total swap = 15616764kB
6215902 pages RAM
0 pages HighMem/MovableOnly
117752 pages reserved
4096 pages cma reserved
0 pages hwpoisoned
bcache: register_cache() error opening sde2: cache_alloc(): -ENOMEM
bcache: register_bcache() error opening /dev/sde2: (null)


Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
