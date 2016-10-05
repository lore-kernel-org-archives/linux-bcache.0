From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Wed, 5 Oct 2016 14:51:55 +0200
Message-ID: <00730b22-fc04-1d3e-5526-dfe3a4586415@mejor.pl>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
 <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
 <20160909090049.o45khhwy5t52icch@kmo-pixel>
 <9c9e7ab6-a654-635f-a695-033221093dd0@mejor.pl>
 <20160913023514.j5kcmiz3kn6iw53l@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:57114 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbcJEMw2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Oct 2016 08:52:28 -0400
In-Reply-To: <20160913023514.j5kcmiz3kn6iw53l@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 13.09.2016 o 04:35, Kent Overstreet pisze:
[...]
Hi!
I'm picking thread with mention about allocation problem.

> Sorry I forgot to reply to your email about the OOMs - those messages are
> actually nothing to worry about, we have a mempool we use if that allocation
> fails (I'll change it to not print out that message now, just got sidetracked).

Today I tried to mount freshly formated filesystem (with lz4 enabled at
format time). Mount failed with message in dmesg:


[16950.860251] mount: page allocation failure: order:8,
mode:0x24040c0(GFP_KERNEL|__GFP_COMP)
[16950.860257] CPU: 3 PID: 22020 Comm: mount Tainted: P           O
4.7.0-bcache+ #9
[16950.860259] Hardware name: .   .  /IP35 Pro XE(Intel P35-ICH9R), BIOS
6.00 PG 09/09/2008
[16950.860262]  0000000000000286 0000000095952302 ffff88012d84fa48
ffffffff812cb37d
[16950.860266]  0000000000000000 0000000000000008 ffff88012d84fad8
ffffffff8113207c
[16950.860270]  024040c095952302 0000000000000040 0000000000000008
ffff88014158d1c0
[16950.860274] Call Trace:
[16950.860281]  [<ffffffff812cb37d>] dump_stack+0x4f/0x72
[16950.860285]  [<ffffffff8113207c>] warn_alloc_failed+0xfc/0x160
[16950.860289]  [<ffffffff81131c71>] ?
__alloc_pages_direct_compact+0x51/0x120
[16950.860291]  [<ffffffff811325cf>] __alloc_pages_nodemask+0x4ef/0xed0
[16950.860295]  [<ffffffff812e096a>] ? find_next_zero_bit+0x1a/0x20
[16950.860298]  [<ffffffff8113328d>] alloc_kmem_pages+0x1d/0x90
[16950.860301]  [<ffffffff8114e3b9>] kmalloc_order_trace+0x29/0xf0
[16950.860306]  [<ffffffff8146b05a>] bch_journal_alloc+0x1aa/0x210
[16950.860309]  [<ffffffff81475e28>] bch_cache_set_alloc+0x928/0xae0
[16950.860312]  [<ffffffff814796c4>] bch_register_cache_set+0x1a4/0x2e0
[16950.860315]  [<ffffffff8117d71c>] ? __kmalloc+0x22c/0x240
[16950.860319]  [<ffffffff8145aafa>] ? bch_mount+0x1ca/0x500
[16950.860321]  [<ffffffff8145ab62>] bch_mount+0x232/0x500
[16950.860323]  [<ffffffff8114c67a>] ? pcpu_alloc+0x37a/0x630
[16950.860327]  [<ffffffff81192d33>] mount_fs+0x33/0x160
[16950.860329]  [<ffffffff8114c950>] ? __alloc_percpu+0x10/0x20
[16950.860333]  [<ffffffff811aeac2>] vfs_kern_mount+0x62/0x100
[16950.860335]  [<ffffffff811b1127>] do_mount+0x247/0xda0
[16950.860338]  [<ffffffff8117fe3c>] ? __kmalloc_track_caller+0x2c/0x240
[16950.860342]  [<ffffffff811476fd>] ? memdup_user+0x3d/0x70
[16950.860345]  [<ffffffff811b1fb0>] SyS_mount+0x90/0xd0
[16950.860349]  [<ffffffff815d0c1f>] entry_SYSCALL_64_fastpath+0x17/0x93
[16950.860351] Mem-Info:
[16950.860356] active_anon:223041 inactive_anon:132461 isolated_anon:0
                active_file:297709 inactive_file:198481 isolated_file:0
                unevictable:1907 dirty:6 writeback:0 unstable:0
                slab_reclaimable:49896 slab_unreclaimable:48418
                mapped:70677 shmem:3674 pagetables:6279 bounce:0
                free:99893 free_pcp:12 free_cma:0
[16950.860365] DMA free:15896kB min:28kB low:40kB high:52kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15988kB
managed:15904kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[16950.860367] lowmem_reserve[]: 0 3224 4419 4419
[16950.860378] DMA32 free:289904kB min:6196kB low:9496kB high:12796kB
active_anon:682936kB inactive_anon:382700kB active_file:893856kB
inactive_file:551472kB unevictable:6536kB isolated(anon):0kB
isolated(file):0kB present:3390336kB managed:3314508kB mlocked:6536kB
dirty:20kB writeback:0kB mapped:207052kB shmem:10704kB
slab_reclaimable:129808kB slab_unreclaimable:130716kB
kernel_stack:5712kB pagetables:18720kB unstable:0kB bounce:0kB
free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[16950.860380] lowmem_reserve[]: 0 0 1194 1194
[16950.860390] Normal free:93564kB min:2296kB low:3516kB high:4736kB
active_anon:209228kB inactive_anon:147144kB active_file:296980kB
inactive_file:242452kB unevictable:1092kB isolated(anon):0kB
isolated(file):0kB present:1310720kB managed:1223572kB mlocked:1092kB
dirty:4kB writeback:0kB mapped:75656kB shmem:3992kB
slab_reclaimable:69776kB slab_unreclaimable:62948kB kernel_stack:2656kB
pagetables:6396kB unstable:0kB bounce:0kB free_pcp:160kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[16950.860392] lowmem_reserve[]: 0 0 0 0
[16950.860397] DMA: 0*4kB 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB
(U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15896kB
[16950.860418] DMA32: 13608*4kB (UMEH) 5636*8kB (UMEH) 8677*16kB (UMEH)
1376*32kB (UMEH) 72*64kB (UMH) 22*128kB (MH) 1*256kB (H) 0*512kB
0*1024kB 0*2048kB 0*4096kB = 290064kB
[16950.860436] Normal: 4269*4kB (UMEH) 1945*8kB (UMEH) 2056*16kB (UMEH)
760*32kB (UMH) 32*64kB (MH) 9*128kB (MH) 0*256kB 1*512kB (H) 0*1024kB
0*2048kB 0*4096kB = 93564kB
[16950.860457] Node 0 hugepages_total=30 hugepages_free=30
hugepages_surp=0 hugepages_size=2048kB
[16950.860459] 511914 total pagecache pages
[16950.860462] 10528 pages in swap cache
[16950.860464] Swap cache stats: add 329149, delete 318621, find
120080/177708
[16950.860466] Free swap  = 752636kB
[16950.860468] Total swap = 1048572kB
[16950.860469] 1179261 pages RAM
[16950.860471] 0 pages HighMem/MovableOnly
[16950.860472] 40765 pages reserved
[16950.860584] mount: page allocation failure: order:6,
mode:0x24000c0(GFP_KERNEL)
[16950.860588] CPU: 3 PID: 22020 Comm: mount Tainted: P           O
4.7.0-bcache+ #9
[16950.860591] Hardware name: .   .  /IP35 Pro XE(Intel P35-ICH9R), BIOS
6.00 PG 09/09/2008
[16950.860593]  0000000000000286 0000000095952302 ffff88012d84faa0
ffffffff812cb37d
[16950.860597]  0000000000000000 0000000000000006 ffff88012d84fb30
ffffffff8113207c
[16950.860601]  024000c095952302 0000000000000040 0000000000000006
ffff88014158d1c0
[16950.860607] Call Trace:
[16950.860611]  [<ffffffff812cb37d>] dump_stack+0x4f/0x72
[16950.860613]  [<ffffffff8113207c>] warn_alloc_failed+0xfc/0x160
[16950.860616]  [<ffffffff81131c71>] ?
__alloc_pages_direct_compact+0x51/0x120
[16950.860619]  [<ffffffff811325cf>] __alloc_pages_nodemask+0x4ef/0xed0
[16950.860623]  [<ffffffff81132fc2>] __get_free_pages+0x12/0x40
[16950.860625]  [<ffffffff8146b075>] bch_journal_alloc+0x1c5/0x210
[16950.860627]  [<ffffffff81475e28>] bch_cache_set_alloc+0x928/0xae0
[16950.860630]  [<ffffffff814796c4>] bch_register_cache_set+0x1a4/0x2e0
[16950.860633]  [<ffffffff8117d71c>] ? __kmalloc+0x22c/0x240
[16950.860636]  [<ffffffff8145aafa>] ? bch_mount+0x1ca/0x500
[16950.860639]  [<ffffffff8145ab62>] bch_mount+0x232/0x500
[16950.860641]  [<ffffffff8114c67a>] ? pcpu_alloc+0x37a/0x630
[16950.860644]  [<ffffffff81192d33>] mount_fs+0x33/0x160
[16950.860646]  [<ffffffff8114c950>] ? __alloc_percpu+0x10/0x20
[16950.860649]  [<ffffffff811aeac2>] vfs_kern_mount+0x62/0x100
[16950.860651]  [<ffffffff811b1127>] do_mount+0x247/0xda0
[16950.860655]  [<ffffffff8117fe3c>] ? __kmalloc_track_caller+0x2c/0x240
[16950.860658]  [<ffffffff811476fd>] ? memdup_user+0x3d/0x70
[16950.860661]  [<ffffffff811b1fb0>] SyS_mount+0x90/0xd0
[16950.860665]  [<ffffffff815d0c1f>] entry_SYSCALL_64_fastpath+0x17/0x93
[16950.860667] Mem-Info:
[16950.860672] active_anon:222994 inactive_anon:132492 isolated_anon:0
                active_file:297709 inactive_file:198481 isolated_file:0
                unevictable:1907 dirty:6 writeback:0 unstable:0
                slab_reclaimable:49896 slab_unreclaimable:48418
                mapped:70677 shmem:3674 pagetables:6294 bounce:0
                free:99616 free_pcp:0 free_cma:0
[16950.860680] DMA free:15896kB min:28kB low:40kB high:52kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15988kB
managed:15904kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[16950.860682] lowmem_reserve[]: 0 3224 4419 4419
[16950.860692] DMA32 free:289956kB min:6196kB low:9496kB high:12796kB
active_anon:682936kB inactive_anon:382700kB active_file:893856kB
inactive_file:551472kB unevictable:6536kB isolated(anon):0kB
isolated(file):0kB present:3390336kB managed:3314508kB mlocked:6536kB
dirty:20kB writeback:0kB mapped:207052kB shmem:10704kB
slab_reclaimable:129808kB slab_unreclaimable:130716kB
kernel_stack:5712kB pagetables:18720kB unstable:0kB bounce:0kB
free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[16950.860694] lowmem_reserve[]: 0 0 1194 1194
[16950.860704] Normal free:92612kB min:2296kB low:3516kB high:4736kB
active_anon:209040kB inactive_anon:147268kB active_file:296980kB
inactive_file:242452kB unevictable:1092kB isolated(anon):0kB
isolated(file):0kB present:1310720kB managed:1223572kB mlocked:1092kB
dirty:4kB writeback:0kB mapped:75656kB shmem:3992kB
slab_reclaimable:69776kB slab_unreclaimable:62948kB kernel_stack:2672kB
pagetables:6456kB unstable:0kB bounce:0kB free_pcp:116kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[16950.860706] lowmem_reserve[]: 0 0 0 0
[16950.860712] DMA: 0*4kB 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB
(U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15896kB
[16950.860729] DMA32: 13608*4kB (UMEH) 5636*8kB (UMEH) 8677*16kB (UMEH)
1376*32kB (UMEH) 72*64kB (UMH) 22*128kB (MH) 1*256kB (H) 0*512kB
0*1024kB 0*2048kB 0*4096kB = 290064kB
[16950.860746] Normal: 4088*4kB (UMEH) 1945*8kB (UMEH) 2056*16kB (UMEH)
760*32kB (UMH) 32*64kB (MH) 9*128kB (MH) 0*256kB 1*512kB (H) 0*1024kB
0*2048kB 0*4096kB = 92840kB
[16950.860764] Node 0 hugepages_total=30 hugepages_free=30
hugepages_surp=0 hugepages_size=2048kB
[16950.860766] 511914 total pagecache pages
[16950.860768] 10528 pages in swap cache
[16950.860771] Swap cache stats: add 329149, delete 318621, find
120086/177714
[16950.860773] Free swap  = 752636kB
[16950.860774] Total swap = 1048572kB
[16950.860776] 1179261 pages RAM
[16950.860777] 0 pages HighMem/MovableOnly
[16950.860780] 40765 pages reserved
[16950.861354] bcache: bch_open_as_blockdevs() register_cache_set err
cannot allocate memory




Marcin
