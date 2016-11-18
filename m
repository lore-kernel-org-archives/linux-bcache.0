From: Marc MERLIN <marc@merlins.org>
Subject: 4.8.8, bcache deadlock and hard lockup
Date: Fri, 18 Nov 2016 08:46:43 -0800
Message-ID: <20161118164643.g7ttuzgsj74d6fbz@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46811 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753848AbcKRRCb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 18 Nov 2016 12:02:31 -0500
Received: from svh-gw.merlins.org ([173.11.111.145]:42770 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1c7mJI-0001IQ-EA
        for <linux-bcache@vger.kernel.org>; Fri, 18 Nov 2016 08:46:50 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1c7mJH-0004ar-VV
        for linux-bcache@vger.kernel.org; Fri, 18 Nov 2016 08:46:43 -0800
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I created a new array as bcache and tried to copy a bunch of data to it.
A few hours later, the kenrel died with
[36403.763610] BUG: workqueue lockup - pool cpus=5 node=0 flags=0x0 nice=0 stuck for 31s!
[36403.789660] BUG: workqueue lockup - pool cpus=7 node=0 flags=0x0 nice=0 stuck for 31s!
[36403.815675] Showing busy workqueues and worker pools:
[36403.832862] workqueue events: flags=0x0
[36403.846370]   pwq 14: cpus=7 node=0 flags=0x0 nice=0 active=5/256
[36403.866827]     pending: vmpressure_work_fn, drm_fb_helper_dirty_work, cache_reap, do_cache_clean [sunrpc], write_dirty [bcache]
[36403.905727]   pwq 10: cpus=5 node=0 flags=0x0 nice=0 active=5/256
[36403.926137]     pending: journal_write_work [bcache], write_dirty [bcache], cache_reap, btree_node_write_work [bcache], btree_node_write_work [bcache]
[36403.970745]   pwq 8: cpus=4 node=0 flags=0x0 nice=0 active=1/256
[36403.990880]     in-flight: 8141:write_dirty_finish [bcache]
[36404.009607]   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=2/256
[36404.029708]     in-flight: 25326:write_dirty_finish [bcache]
[36404.048649]     pending: cache_reap
[36404.061031]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=49/256
[36404.081293]     in-flight: 8082:write_dirty_finish [bcache], 29134:write_dirty_finish [bcache], 29144:write_dirty_finish [bcache], 29316:write_dirty_finish [bcache], 1153:write_dirty_finish [bcache], 29150:write_dirty_finish [bcache], 29239:write_dirty_finish [bcache], 14064:write_dirty_finish [bcache], 15612:write_dirty_finish [bcache]
[36404.176733]     pending: kernfs_notify_workfn, write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], write_dirty_finish [bcache], cache_reap, write_dirty [bcache], btree_node_write_work [bcache], update_writeback_rate [bcache], update_writeback_rate [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bca
 che], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], btree_node_write_work [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache], write_dirty [bcache]
[36404.464686] workqueue events_unbound: flags=0x2
[36404.480072]   pwq 16: cpus=0-7 flags=0x4 nice=0 active=1/512
[36404.498937]     in-flight: 25187:call_usermodehelper_exec_work
[36404.518259] workqueue writeback: flags=0x4e
[36404.532531] workqueue vmstat: flags=0xc
[36404.545716]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256
[36404.565589]     pending: vmstat_update
[36404.578593] workqueue bcache: flags=0x8
[36404.591714]   pwq 14: cpus=7 node=0 flags=0x0 nice=0 active=256/256 MAYDAY
[36404.614102]     in-flight: 26082:bch_data_insert_keys [bcache], 26036:bch_data_insert_keys [bcache], 26015:bch_data_insert_keys [bcache], 26076:bch_data_insert_keys [bcache], 26048:bch_data_insert_keys [bcache], 26063:bch_data_insert_keys [bcache], 26019:bch_data_insert_keys [bcache], 26033:bch_data_insert_keys [bcache], 15710:bch_data_insert_keys [bcache], 26090:bch_data_insert_keys [bcache], 15714:bch_data_insert_keys [bcache], 26011:bch_data_insert_keys [bcache], 15711:bch_data_insert_keys [bcache], 26087:bch_data_insert_keys [bcache], 26081:bch_data_insert_keys [bcache], 26031:bch_data_insert_keys [bcache], 26006:bch_data_insert_keys [bcache], 26089:bch_data_insert_keys [bcache], 26084:bch_data_insert_keys [bcache], 26073:bch_data_insert_keys [bcache], 26047:bch_data_insert_keys [bc
 ache], 15706:bch_data_insert_keys [bcache], 26017:bch_data_insert_keys [bcache], 26043:bch_data_insert_keys [bcache], 26037:bch_data_insert_keys [bcache], 25339:bch_data_insert_keys [bcache], 15715:bch_data_insert_keys [bcache], 26088:bch_data_insert_keys [bcache], 26077:bch_data_insert_keys (many deleted)
[36405.826991]     pending: bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache], bch_data_insert_keys [bcache] (many deleted)
[36420.315213] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G     U          4.8.8-amd64-volpreempt-sysrq-20161108 #7
[36420.315214] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[36420.315214] task: ffff9b6f02f96100 task.stack: ffff9b6f02f98000
[36420.315214] RIP: 0010:[<ffffffff8857a128>]  [<ffffffff8857a128>] cpuidle_enter_state+0x119/0x171
[36420.315215] RSP: 0018:ffff9b6f02f9bea0  EFLAGS: 00200246
[36420.315215] RAX: ffff9b6f1e3590c0 RBX: 0000000000000002 RCX: 000000000000001f
[36420.315215] RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000000
[36420.315216] RBP: ffff9b6f02f9bed0 R08: 0000000000000f94 R09: 0000000000000f89
[36420.315216] R10: ffff9b6f02f9be50 R11: 071c71c71c71c71c R12: ffffd6657fd4b200
[36420.315216] R13: 0000211cbb6f6cf7 R14: 0000000000000002 R15: 0000211cbb3291c0
[36420.315217] FS:  0000000000000000(0000) GS:ffff9b6f1e340000(0000) knlGS:0000000000000000
[36420.315217] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[36420.315217] CR2: 00000000f5901024 CR3: 0000000306432000 CR4: 00000000001406e0
[36420.315218] Stack:
[36420.315218]  0000000000000ef6 ffffd6657fd4b200 ffffffff88ccc060 ffff9b6f02f9c000
[36420.315218]  ffff9b6f02f98000 ffff9b6f02f9c000 ffff9b6f02f9bee0 ffffffff8857a1ac
[36420.315219]  ffff9b6f02f9bf30 ffffffff8809238d ffff9b6f02f98000 0000000500000002
[36420.315219] Call Trace:
[36420.315219]  [<ffffffff8857a1ac>] cpuidle_enter+0x17/0x19
[36420.315220]  [<ffffffff8809238d>] cpu_startup_entry+0x210/0x28b
[36420.315220]  [<ffffffff8803de22>] start_secondary+0x13e/0x140
[36420.315221] Code: 00 00 00 48 c7 c7 cd ae b2 88 c6 05 4b 8e 7a 00 01 e8 17 6c ae ff fa 66 0f 1f 44 00 00 31 ff e8 75 60 b4 ff fb 66 0f 1f 44 00 00 <4c> 89 e8 b9 e8 03 00 00 4c 29 f8 48 99 48 f7 f9 ba ff ff ff 7f
[36420.315221] Kernel panic - not syncing: Hard LOCKUP
[36420.315221] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G     U          4.8.8-amd64-volpreempt-sysrq-20161108 #7
[36420.315222] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[36420.315222]  0000000000000000 ffff9b6f1e345b00 ffffffff8836a05b ffff9b6f02f9bd00
[36420.315223]  ffffffff88ab1d54 ffff9b6f1e345b80 ffffffff8812d1f0 ffff9b6f00000010
[36420.315223]  ffff9b6f1e345b90 ffff9b6f1e345b28 ffffffff88b37748 ffffffff88ab1575
[36420.315223] Call Trace:
[36420.315223]  <NMI>  [<ffffffff8836a05b>] dump_stack+0x61/0x7d
[36420.315224]  [<ffffffff8812d1f0>] panic+0xd8/0x21a
[36420.315224]  [<ffffffff88060a9b>] nmi_panic+0x2c/0x37
[36420.315224]  [<ffffffff880ea3c7>] watchdog_overflow_callback+0xc1/0xcc
[36420.315225]


A bit before that, I had an OOM event, but I'm not certain if it's related, especially as I had plenty of RAM left.

Fri Nov 18 03:55:01 PST 2016
             total       used       free     shared    buffers     cached
Mem:      24393028   22588352    1804676          0         96   20150652
-/+ buffers/cache:    2437604   21955424
Swap:     15616764    1412392   14204372

[33987.869396] Purging GPU memory, 0 pages freed, 774 pages still pinned.
[33987.891118] 96 and 0 pages still available in the bound and unbound GPU page lists.
[33987.916534] kthreadd invoked oom-killer: gfp_mask=0x27000c0(GFP_KERNEL_ACCOUNT|__GFP_NOTRACK), order=2, oom_score_adj=0
[33987.950979] kthreadd cpuset=/ mems_allowed=0
[33987.966007] CPU: 7 PID: 2 Comm: kthreadd Tainted: G     U          4.8.8-amd64-volpreempt-sysrq-20161108 #7
[33987.997320] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[33988.027020]  0000000000000000 ffff9b6f02f23b98 ffffffff8836a05b ffff9b6f02f23d38
[33988.051780]  ffff9b6e50380140 ffff9b6f02f23c00 ffffffff88195ffe 0000000000000000
[33988.076325]  ffff9b6f02f23c78 0000000000000000 0000000000000206 ffff9b6f02f23bd8
[33988.100833] Call Trace:
[33988.110385]  [<ffffffff8836a05b>] dump_stack+0x61/0x7d
[33988.127954]  [<ffffffff88195ffe>] dump_header+0x5c/0x1d3
[33988.146034]  [<ffffffff8869773b>] ? _raw_spin_unlock_irqrestore+0x14/0x16
[33988.167763]  [<ffffffff8813204e>] oom_kill_process+0x83/0x31f
[33988.186343]  [<ffffffff88068604>] ? has_ns_capability_noaudit+0x15/0x1c
[33988.207943]  [<ffffffff88068622>] ? has_capability_noaudit+0x17/0x19
[33988.228879]  [<ffffffff881326a0>] out_of_memory+0x367/0x382
[33988.247419]  [<ffffffff88136434>] __alloc_pages_nodemask+0x9d7/0xa9f
[33988.268293]  [<ffffffff8805ebae>] copy_process+0x18a/0x1725
[33988.286165]  [<ffffffff88079f4d>] ? init_completion+0x24/0x24
[33988.304579]  [<ffffffff8808849f>] ? set_next_entity+0x5b/0xbc
[33988.323293]  [<ffffffff8808c6f6>] ? pick_next_task_fair+0x12c/0x348
[33988.343785]  [<ffffffff880602b8>] _do_fork+0x81/0x223
[33988.360590]  [<ffffffff88694d2d>] ? __schedule+0x3c3/0x574
[33988.378662]  [<ffffffff88060483>] kernel_thread+0x29/0x2b
[33988.396581]  [<ffffffff8807a712>] kthreadd+0x131/0x16b
[33988.413586]  [<ffffffff88697a9f>] ret_from_fork+0x1f/0x40
[33988.431333]  [<ffffffff8807a5e1>] ? kthread_create_on_cpu+0x5e/0x5e
[33988.451701] Mem-Info:
[33988.460014] active_anon:551103 inactive_anon:166870 isolated_anon:32
33988.460014]  active_file:3638356 inactive_file:571701 isolated_file:0
[33988.460014]  unevictable:1985 dirty:2406 writeback:570591 unstable:0
[33988.460014]  slab_reclaimable:62971 slab_unreclaimable:124630
[33988.460014]  mapped:571906 shmem:622799 pagetables:5534 bounce:0
[33988.460014]  free:92854 free_pcp:812 free_cma:3110
[33988.575035] Node 0 active_anon:2204184kB inactive_anon:663764kB active_file:14553496kB inactive_file:2301244kB unevictable:7940kB isolated(anon):0kB isolated(file):128kB mapped:2287484kB dirty:9676kB writeback:2291708kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 2491072kB writeback_tmp:0kB unstable:0kB pages_scanned:26435 all_unreclaimable? no
[33988.673542] Node 0 DMA free:15884kB min:168kB low:208kB high:248kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15976kB managed:15892kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[33988.766919] lowmem_reserve[]: 0 3200 23767 23767 23767
[33988.783939] Node 0 DMA32 free:117664kB min:35424kB low:44280kB high:53136kB active_anon:64468kB inactive_anon:11928kB active_file:2253948kB inactive_file:348364kB unevictable:64kB writepending:349392kB present:3362068kB managed:3296500kB mlocked:64kB slab_reclaimable:57132kB slab_unreclaimable:33292kB kernel_stack:1552kB pagetables:2432kB bounce:0kB free_pcp:136kB local_pcp:0kB free_cma:0kB
[33988.892817] lowmem_reserve[]: 0 0 20567 20567 20567
[33988.909007] Node 0 Normal free:238580kB min:226544kB low:283180kB high:339816kB active_anon:2145316kB inactive_anon:639248kB active_file:12300184kB inactive_file:1948300kB unevictable:7876kB writepending:1962392kB present:21485568kB managed:21080636kB mlocked:7876kB slab_reclaimable:194656kB slab_unreclaimable:464164kB kernel_stack:22720kB pagetables:19672kB bounce:0kB free_pcp:944kB local_pcp:0kB free_cma:12440kB
[33989.024095] lowmem_reserve[]: 0 0 0 0 0
[33989.037169] Node 0 DMA: 1*4kB (U) 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15884kB
[33989.080920] Node 0 DMA32: 17507*4kB (UME) 5928*8kB (UM) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 117452kB
[33989.121604] Node 0 Normal: 35622*4kB (UMEHC) 10360*8kB (UMHC) 80*16kB (HC) 74*32kB (HC) 63*64kB (HC) 31*128kB (HC) 3*256kB (C) 2*512kB (HC) 0*1024kB 0*2048kB 0*4096kB = 238808kB
[33989.172906] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[33989.199648] 4855832 total pagecache pages
[33989.213115] 22430 pages in swap cache
[33989.225565] Swap cache stats: add 4289109, delete 4266743, find 2271598/2744355
[33989.248937] Free swap  = 14581328kB
[33989.260873] Total swap = 15616764kB
[33989.272779] 6215903 pages RAM
[33989.283138] 0 pages HighMem/MovableOnly
[33989.296160] 117646 pages reserved
[33989.307581] 4096 pages cma reserved
[33989.319493] 0 pages hwpoisoned
(...)
[33996.018149] Out of memory: Kill process 23119 (chrome) score 200 or sacrifice child
[33996.041502] Killed process 23119 (chrome) total-vm:181928kB, anon-rss:2376kB, file-rss:13824kB, shmem-rss:0kB
[33996.079371] oom_reaper: reaped process 23119 (chrome), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

The BUG: workqueue lockup happened 40mn later...

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
