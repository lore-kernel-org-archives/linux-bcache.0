From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: hang
Date: Sun, 2 Sep 2012 17:41:13 -0700
Message-ID: <20120903004113.GB20060@moria.home.lan>
References: <6035A0D088A63A46850C3988ED045A4B29A7F38D@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B29A7F38D-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Sat, Sep 01, 2012 at 01:00:05AM +0000, James Harper wrote:
> I'm getting a freeze and instability (see logs following this email) on my system using bcache, and I suspect it might be due to lvm snapshots.
> 
> Basically, I'm doing a restore of windows machines using Backup Exec inside Xen (customer test restore), and it has been giving me trouble (for reasons unrelated to bcache) and instead of rebuilding the restore machine every time I attempt the restore I wanted to build it up then take a snapshot so I could roll it back easily.
> 
> My setup is:
> sd[ab]
> md (RAID1)
> bcache
> lvm
> lvm snapshot
> 
> with my Xen DomU using the snapshot. Before I started using the snapshot it appeared to be working just fine in terms of problems at the Dom0 level. I guess I'll have to run it not using the snapshot to prove it, but there is a bit of effort required to get the DomU to the point where it is now so I'd like to find a solution.
> 
> On one occasion the Dom0 was still kind of usable and I could log in and force a reboot using sysrq-trigger. This time it has just hung completely.
> 
> Any suggestions? Anything in the following logs to suggest that bcache isn't involved and I'm chasing the wrong problem?

Hmm.

If it's related to lvm snapshots, there's a workaround I just added to
the bcache-3.2 branch - I'd give that a try, looks plausible from your
log.

> 
> Thanks
> 
> James
> 
> [ 2044.256047] INFO: task kworker/u:5:186 blocked for more than 120 seconds.
> [ 2044.256080] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2044.256112] kworker/u:5     D ffff8803ebc13740     0   186      2 0x00000000
> [ 2044.256116]  ffff88038e6df0e0 0000000000000246 ffff88030acfe7c8 ffff8803bb3ee870
> [ 2044.256120]  0000000000013740 ffff8803bbb71fd8 ffff8803bbb71fd8 ffff8803bb3ee870
> [ 2044.256123]  0000000000000000 ffffffff81070283 ffffffff81348743 ffff8803b9510ab0
> [ 2044.256127] Call Trace:
> [ 2044.256134]  [<ffffffff81070283>] ? arch_local_irq_disable+0x7/0x8
> [ 2044.256139]  [<ffffffff81348743>] ? _raw_spin_lock_irqsave+0x14/0x35
> [ 2044.256143]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2044.256147]  [<ffffffff81191747>] ? elv_merged_request+0x1f/0x43
> [ 2044.256152]  [<ffffffff811b1103>] ? call_rwsem_down_write_failed+0x13/0x20
> [ 2044.256155]  [<ffffffff81347ee9>] ? down_write+0x25/0x27
> [ 2044.256168]  [<ffffffffa01919e9>] ? refill_dirty+0x5d/0x1e6 [bcache]
> [ 2044.256174]  [<ffffffffa0191e81>] ? read_dirty+0x30f/0x35b [bcache]
> [ 2044.256178]  [<ffffffff810e8a23>] ? arch_local_irq_restore+0x7/0x8
> [ 2044.256184]  [<ffffffffa0191b72>] ? refill_dirty+0x1e6/0x1e6 [bcache]
> [ 2044.256187]  [<ffffffff8105abc9>] ? process_one_work+0x125/0x296
> [ 2044.256190]  [<ffffffff8105b995>] ? worker_thread+0xc4/0x164
> [ 2044.256193]  [<ffffffff8105b8d1>] ? manage_workers.isra.22+0x160/0x160
> [ 2044.256196]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2044.256199]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2044.256202]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2044.256205]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2044.256208]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2044.256213] INFO: task flush-252:0:881 blocked for more than 120 seconds.
> [ 2044.256236] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2044.256265] flush-252:0     D ffff8803ebc93740     0   881      2 0x00000000
> [ 2044.256268]  ffff8803d4830080 0000000000000246 000000000000000f ffff8803d4830e60
> [ 2044.256271]  0000000000013740 ffff8803ceba9fd8 ffff8803ceba9fd8 ffff8803d4830e60
> [ 2044.256274]  0000000000000008 ffff8803bae9f858 ffffffff810ea17f ffff8803b9510ab0
> [ 2044.256277] Call Trace:
> [ 2044.256281]  [<ffffffff810ea17f>] ? ____cache_alloc+0xb1/0x1f7
> [ 2044.256284]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2044.256287]  [<ffffffff811b10d4>] ? call_rwsem_down_read_failed+0x14/0x30
> [ 2044.256290]  [<ffffffff81347ec2>] ? down_read+0x17/0x19
> [ 2044.256296]  [<ffffffffa0194924>] ? request_write+0x7c/0x2a9 [bcache]
> [ 2044.256299]  [<ffffffff81196c93>] ? generic_make_request+0x14e/0x19e
> [ 2044.256302]  [<ffffffff81196db7>] ? submit_bio+0xd4/0x100
> [ 2044.256305]  [<ffffffff8111ea89>] ? bio_alloc_bioset+0x45/0xc7
> [ 2044.256309]  [<ffffffff8111b40f>] ? submit_bh+0xde/0xf9
> [ 2044.256313]  [<ffffffff8111d47b>] ? __block_write_full_page+0x1f7/0x2ed
> [ 2044.256315]  [<ffffffff8111b6a0>] ? drop_buffers+0x8f/0x8f
> [ 2044.256318]  [<ffffffff811203e5>] ? blkdev_get_blocks+0x85/0x85
> [ 2044.256322]  [<ffffffff810ba39d>] ? __writepage+0xa/0x21
> [ 2044.256325]  [<ffffffff810bac73>] ? write_cache_pages+0x1d3/0x2e4
> [ 2044.256328]  [<ffffffff810ba393>] ? page_index+0x14/0x14
> [ 2044.256331]  [<ffffffff810badbc>] ? generic_writepages+0x38/0x54
> [ 2044.256334]  [<ffffffff8111602b>] ? writeback_single_inode+0x119/0x2c7
> [ 2044.256339]  [<ffffffff81007241>] ? get_phys_to_machine+0x12/0x5d
> [ 2044.256341]  [<ffffffff81116499>] ? writeback_sb_inodes+0x14e/0x200
> [ 2044.256344]  [<ffffffff810040fa>] ? xen_mc_flush+0x11d/0x160
> [ 2044.256347]  [<ffffffff811165b4>] ? __writeback_inodes_wb+0x69/0xab
> [ 2044.256349]  [<ffffffff8111670a>] ? wb_writeback+0x114/0x24f
> [ 2044.256352]  [<ffffffff81348743>] ? _raw_spin_lock_irqsave+0x14/0x35
> [ 2044.256355]  [<ffffffff81116b60>] ? wb_do_writeback+0x146/0x1bb
> [ 2044.256359]  [<ffffffff81051acc>] ? del_timer_sync+0x32/0x3c
> [ 2044.256361]  [<ffffffff81116c74>] ? bdi_writeback_thread+0x9f/0x1ee
> [ 2044.256364]  [<ffffffff81116bd5>] ? wb_do_writeback+0x1bb/0x1bb
> [ 2044.256367]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2044.256369]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2044.256372]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2044.256374]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2044.256377]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2044.256388] INFO: task blkback.2.hda:5686 blocked for more than 120 seconds.
> [ 2044.256412] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2044.256441] blkback.2.hda   D ffff8803ebc13740     0  5686      2 0x00000000
> [ 2044.256444]  ffff8803d6752340 0000000000000246 ffffffff8103b30f ffff88038e6de9f0
> [ 2044.256447]  0000000000013740 ffff8803c1759fd8 ffff8803c1759fd8 ffff88038e6de9f0
> [ 2044.256450]  ffffffff8103f12c ffff8803ebc1b900 ffff8803bbfa9540 ffff8803b9510ab0
> [ 2044.256453] Call Trace:
> [ 2044.256457]  [<ffffffff8103b30f>] ? ttwu_do_wakeup+0x2d/0xd2
> [ 2044.256461]  [<ffffffff8103f12c>] ? try_to_wake_up+0x171/0x181
> [ 2044.256464]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2044.256467]  [<ffffffff811b10d4>] ? call_rwsem_down_read_failed+0x14/0x30
> [ 2044.256470]  [<ffffffff81347ec2>] ? down_read+0x17/0x19
> [ 2044.256476]  [<ffffffffa0194924>] ? request_write+0x7c/0x2a9 [bcache]
> [ 2044.256478]  [<ffffffff81196c93>] ? generic_make_request+0x14e/0x19e
> [ 2044.256481]  [<ffffffff81196db7>] ? submit_bio+0xd4/0x100
> [ 2044.256484]  [<ffffffffa03a3a46>] ? dispatch_rw_block_io+0x48a/0x525 [xen_blkback]
> [ 2044.256488]  [<ffffffff81007241>] ? get_phys_to_machine+0x12/0x5d
> [ 2044.256490]  [<ffffffff810047ad>] ? pfn_to_mfn+0x13/0x29
> [ 2044.256493]  [<ffffffff81003125>] ? xen_end_context_switch+0xe/0x1c
> [ 2044.256496]  [<ffffffff810037cd>] ? xen_mc_issue.constprop.23+0x10/0x4d
> [ 2044.256499]  [<ffffffff8100d02f>] ? load_TLS+0x7/0xa
> [ 2044.256502]  [<ffffffff8100d68f>] ? __switch_to+0x141/0x25e
> [ 2044.256505]  [<ffffffff8103bc3c>] ? pick_next_task_fair+0xfd/0x111
> [ 2044.256508]  [<ffffffffa03a3cea>] ? __do_block_io_op+0x209/0x236 [xen_blkback]
> [ 2044.256512]  [<ffffffffa03a4021>] ? xen_blkif_schedule+0x2e2/0x3d9 [xen_blkback]
> [ 2044.256515]  [<ffffffff8105f187>] ? abort_exclusive_wait+0x79/0x79
> [ 2044.256518]  [<ffffffffa03a3d3f>] ? xen_blkif_be_int+0x28/0x28 [xen_blkback]
> [ 2044.256521]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2044.256523]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2044.256526]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2044.256529]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2044.256532]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2044.256535] INFO: task blkback.3.hda:6241 blocked for more than 120 seconds.
> [ 2044.256559] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2044.256587] blkback.3.hda   D ffff8803ebc13740     0  6241      2 0x00000000
> [ 2044.256590]  ffffffff8160d020 0000000000000246 000000000000000f ffff88038e17aa70
> [ 2044.256594]  0000000000013740 ffff880309891fd8 ffff880309891fd8 ffff88038e17aa70
> [ 2044.256597]  0000000000000008 ffff8803bae9f858 0000000000000000 ffff8803b9510ab0
> [ 2044.256600] Call Trace:
> [ 2044.256603]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2044.256606]  [<ffffffff811b10d4>] ? call_rwsem_down_read_failed+0x14/0x30
> [ 2044.256609]  [<ffffffff81347ec2>] ? down_read+0x17/0x19
> [ 2044.256615]  [<ffffffffa0194924>] ? request_write+0x7c/0x2a9 [bcache]
> [ 2044.256618]  [<ffffffff81196c93>] ? generic_make_request+0x14e/0x19e
> [ 2044.256620]  [<ffffffff81196db7>] ? submit_bio+0xd4/0x100
> [ 2044.256623]  [<ffffffffa03a3a46>] ? dispatch_rw_block_io+0x48a/0x525 [xen_blkback]
> [ 2044.256627]  [<ffffffff81007241>] ? get_phys_to_machine+0x12/0x5d
> [ 2044.256629]  [<ffffffff810047ad>] ? pfn_to_mfn+0x13/0x29
> [ 2044.256632]  [<ffffffff81003f5f>] ? arch_local_irq_restore+0x7/0x8
> [ 2044.256634]  [<ffffffff810040fa>] ? xen_mc_flush+0x11d/0x160
> [ 2044.256637]  [<ffffffff81003125>] ? xen_end_context_switch+0xe/0x1c
> [ 2044.256639]  [<ffffffff810037cd>] ? xen_mc_issue.constprop.23+0x10/0x4d
> [ 2044.256642]  [<ffffffff8100d02f>] ? load_TLS+0x7/0xa
> [ 2044.256645]  [<ffffffff8100d68f>] ? __switch_to+0x141/0x25e
> [ 2044.256647]  [<ffffffff8103bc3c>] ? pick_next_task_fair+0xfd/0x111
> [ 2044.256651]  [<ffffffffa03a3cea>] ? __do_block_io_op+0x209/0x236 [xen_blkback]
> [ 2044.256654]  [<ffffffffa03a4021>] ? xen_blkif_schedule+0x2e2/0x3d9 [xen_blkback]
> [ 2044.256657]  [<ffffffff8105f187>] ? abort_exclusive_wait+0x79/0x79
> [ 2044.256660]  [<ffffffffa03a3d3f>] ? xen_blkif_be_int+0x28/0x28 [xen_blkback]
> [ 2044.256663]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2044.256665]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2044.256668]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2044.256671]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2044.256673]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2044.256676] INFO: task kworker/0:1:6250 blocked for more than 120 seconds.
> [ 2044.256699] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2044.256728] kworker/0:1     D ffff8803ebc13740     0  6250      2 0x00000000
> [ 2044.256731]  ffff8803d6752340 0000000000000246 000000000000000f ffff8803bbadca30
> [ 2044.256734]  0000000000013740 ffff8803d74f7fd8 ffff8803d74f7fd8 ffff8803bbadca30
> [ 2044.256737]  0000000000000008 ffff8803bae9f858 0000000000000000 ffff8803b9510ab0
> [ 2044.256740] Call Trace:
> [ 2044.256743]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2044.256747]  [<ffffffff811b10d4>] ? call_rwsem_down_read_failed+0x14/0x30
> [ 2044.256750]  [<ffffffff81347ec2>] ? down_read+0x17/0x19
> [ 2044.256755]  [<ffffffffa0194924>] ? request_write+0x7c/0x2a9 [bcache]
> [ 2044.256758]  [<ffffffff81196c93>] ? generic_make_request+0x14e/0x19e
> [ 2044.256761]  [<ffffffff81196db7>] ? submit_bio+0xd4/0x100
> [ 2044.256766]  [<ffffffffa01bc4e0>] ? dispatch_io+0x1b3/0x1ee [dm_mod]
> [ 2044.256771]  [<ffffffffa01bc22a>] ? km_next_page+0x17/0x17 [dm_mod]
> [ 2044.256776]  [<ffffffffa01bc1fc>] ? bvec_next_page+0x6/0x6 [dm_mod]
> [ 2044.256781]  [<ffffffffa01bc5b1>] ? sync_io+0x96/0x117 [dm_mod]
> [ 2044.256786]  [<ffffffff811a7bd7>] ? cpumask_next_and+0x2a/0x36
> [ 2044.256791]  [<ffffffffa01bc720>] ? dm_io+0xee/0x1b0 [dm_mod]
> [ 2044.256795]  [<ffffffffa01bc22a>] ? km_next_page+0x17/0x17 [dm_mod]
> [ 2044.256800]  [<ffffffffa01bc1fc>] ? bvec_next_page+0x6/0x6 [dm_mod]
> [ 2044.256805]  [<ffffffffa028f863>] ? chunk_io+0x8d/0xf0 [dm_snapshot]
> [ 2044.256808]  [<ffffffff810b8008>] ? get_pageblock_flags_group+0x3e/0x72
> [ 2044.256811]  [<ffffffffa028f029>] ? copy_callback+0x38/0x38 [dm_snapshot]
> [ 2044.256815]  [<ffffffffa028fcf8>] ? persistent_commit_exception+0xaa/0x107 [dm_snapshot]
> [ 2044.256819]  [<ffffffffa028eff1>] ? pending_complete+0x1c4/0x1c4 [dm_snapshot]
> [ 2044.256825]  [<ffffffffa01bd20a>] ? run_complete_job+0x66/0x95 [dm_mod]
> [ 2044.256830]  [<ffffffffa01bd1a4>] ? do_work+0x5d/0x5d [dm_mod]
> [ 2044.256834]  [<ffffffffa01bd07b>] ? process_jobs+0x24/0xf0 [dm_mod]
> [ 2044.256839]  [<ffffffffa01bd147>] ? process_jobs+0xf0/0xf0 [dm_mod]
> [ 2044.256844]  [<ffffffffa01bd16f>] ? do_work+0x28/0x5d [dm_mod]
> [ 2044.256847]  [<ffffffff81070283>] ? arch_local_irq_disable+0x7/0x8
> [ 2044.256849]  [<ffffffff8105abc9>] ? process_one_work+0x125/0x296
> [ 2044.256852]  [<ffffffff8105b995>] ? worker_thread+0xc4/0x164
> [ 2044.256854]  [<ffffffff8105b8d1>] ? manage_workers.isra.22+0x160/0x160
> [ 2044.256857]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2044.256860]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2044.256863]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2044.256865]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2044.256868]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2164.256009] INFO: task kworker/u:5:186 blocked for more than 120 seconds.
> [ 2164.256037] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2164.256066] kworker/u:5     D ffff8803ebc13740     0   186      2 0x00000000
> [ 2164.256070]  ffff88038e6df0e0 0000000000000246 ffff88030acfe7c8 ffff8803bb3ee870
> [ 2164.256074]  0000000000013740 ffff8803bbb71fd8 ffff8803bbb71fd8 ffff8803bb3ee870
> [ 2164.256077]  0000000000000000 ffffffff81070283 ffffffff81348743 ffff8803b9510ab0
> [ 2164.256081] Call Trace:
> [ 2164.256088]  [<ffffffff81070283>] ? arch_local_irq_disable+0x7/0x8
> [ 2164.256094]  [<ffffffff81348743>] ? _raw_spin_lock_irqsave+0x14/0x35
> [ 2164.256097]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2164.256102]  [<ffffffff81191747>] ? elv_merged_request+0x1f/0x43
> [ 2164.256106]  [<ffffffff811b1103>] ? call_rwsem_down_write_failed+0x13/0x20
> [ 2164.256109]  [<ffffffff81347ee9>] ? down_write+0x25/0x27
> [ 2164.256123]  [<ffffffffa01919e9>] ? refill_dirty+0x5d/0x1e6 [bcache]
> [ 2164.256129]  [<ffffffffa0191e81>] ? read_dirty+0x30f/0x35b [bcache]
> [ 2164.256132]  [<ffffffff810e8a23>] ? arch_local_irq_restore+0x7/0x8
> [ 2164.256138]  [<ffffffffa0191b72>] ? refill_dirty+0x1e6/0x1e6 [bcache]
> [ 2164.256142]  [<ffffffff8105abc9>] ? process_one_work+0x125/0x296
> [ 2164.256144]  [<ffffffff8105b995>] ? worker_thread+0xc4/0x164
> [ 2164.256147]  [<ffffffff8105b8d1>] ? manage_workers.isra.22+0x160/0x160
> [ 2164.256150]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2164.256153]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2164.256157]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2164.256159]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2164.256162]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2164.256167] INFO: task kjournald:314 blocked for more than 120 seconds.
> [ 2164.256189] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2164.256250] kjournald       D ffff8803ebc13740     0   314      2 0x00000000
> [ 2164.256253]  ffffffff8160d020 0000000000000246 ffff8803bbd02ea8 ffff8803bbd02af0
> [ 2164.256256]  0000000000013740 ffff8803b7c0dfd8 ffff8803b7c0dfd8 ffff8803bbd02af0
> [ 2164.256259]  ffffffff81348743 0000000000000200 ffffffff8107027b ffff8803099082c0
> [ 2164.256262] Call Trace:
> [ 2164.256265]  [<ffffffff81348743>] ? _raw_spin_lock_irqsave+0x14/0x35
> [ 2164.256268]  [<ffffffff8107027b>] ? arch_local_irq_restore+0x7/0x8
> [ 2164.256273]  [<ffffffffa01d2d26>] ? journal_commit_transaction+0x148/0xe4e [jbd]
> [ 2164.256277]  [<ffffffff8100d02f>] ? load_TLS+0x7/0xa
> [ 2164.256281]  [<ffffffff8103bc3c>] ? pick_next_task_fair+0xfd/0x111
> [ 2164.256284]  [<ffffffff81038470>] ? mmdrop+0xd/0x1c
> [ 2164.256287]  [<ffffffff8103a5cf>] ? finish_task_switch+0x7e/0xad
> [ 2164.256290]  [<ffffffff8105f187>] ? abort_exclusive_wait+0x79/0x79
> [ 2164.256293]  [<ffffffff8107027b>] ? arch_local_irq_restore+0x7/0x8
> [ 2164.256296]  [<ffffffff81348743>] ? _raw_spin_lock_irqsave+0x14/0x35
> [ 2164.256301]  [<ffffffffa01d6bf2>] ? kjournald+0xe1/0x235 [jbd]
> [ 2164.256304]  [<ffffffff8105f187>] ? abort_exclusive_wait+0x79/0x79
> [ 2164.256309]  [<ffffffffa01d6b11>] ? journal_init_dev+0xef/0xef [jbd]
> [ 2164.256312]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2164.256314]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2164.256317]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2164.256319]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2164.256322]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2164.256324] INFO: task flush-252:0:881 blocked for more than 120 seconds.
> [ 2164.256379] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2164.256464] flush-252:0     D ffff8803ebc93740     0   881      2 0x00000000
> [ 2164.256467]  ffff8803d4830080 0000000000000246 000000000000000f ffff8803d4830e60
> [ 2164.256470]  0000000000013740 ffff8803ceba9fd8 ffff8803ceba9fd8 ffff8803d4830e60
> [ 2164.256473]  0000000000000008 ffff8803bae9f858 ffffffff810ea17f ffff8803b9510ab0
> [ 2164.256476] Call Trace:
> [ 2164.256479]  [<ffffffff810ea17f>] ? ____cache_alloc+0xb1/0x1f7
> [ 2164.256482]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2164.256486]  [<ffffffff811b10d4>] ? call_rwsem_down_read_failed+0x14/0x30
> [ 2164.256489]  [<ffffffff81347ec2>] ? down_read+0x17/0x19
> [ 2164.256496]  [<ffffffffa0194924>] ? request_write+0x7c/0x2a9 [bcache]
> [ 2164.256504]  [<ffffffff81196c93>] ? generic_make_request+0x14e/0x19e
> [ 2164.256507]  [<ffffffff81196db7>] ? submit_bio+0xd4/0x100
> [ 2164.256510]  [<ffffffff8111ea89>] ? bio_alloc_bioset+0x45/0xc7
> [ 2164.256515]  [<ffffffff8111b40f>] ? submit_bh+0xde/0xf9
> [ 2164.256518]  [<ffffffff8111d47b>] ? __block_write_full_page+0x1f7/0x2ed
> [ 2164.256521]  [<ffffffff8111b6a0>] ? drop_buffers+0x8f/0x8f
> [ 2164.256523]  [<ffffffff811203e5>] ? blkdev_get_blocks+0x85/0x85
> [ 2164.256527]  [<ffffffff810ba39d>] ? __writepage+0xa/0x21
> [ 2164.256530]  [<ffffffff810bac73>] ? write_cache_pages+0x1d3/0x2e4
> [ 2164.256533]  [<ffffffff810ba393>] ? page_index+0x14/0x14
> [ 2164.256536]  [<ffffffff810badbc>] ? generic_writepages+0x38/0x54
> [ 2164.256539]  [<ffffffff8111602b>] ? writeback_single_inode+0x119/0x2c7
> [ 2164.256543]  [<ffffffff81007241>] ? get_phys_to_machine+0x12/0x5d
> [ 2164.256546]  [<ffffffff81116499>] ? writeback_sb_inodes+0x14e/0x200
> [ 2164.256548]  [<ffffffff810040fa>] ? xen_mc_flush+0x11d/0x160
> [ 2164.256551]  [<ffffffff811165b4>] ? __writeback_inodes_wb+0x69/0xab
> [ 2164.256554]  [<ffffffff8111670a>] ? wb_writeback+0x114/0x24f
> [ 2164.256557]  [<ffffffff81348743>] ? _raw_spin_lock_irqsave+0x14/0x35
> [ 2164.256559]  [<ffffffff81116b60>] ? wb_do_writeback+0x146/0x1bb
> [ 2164.256563]  [<ffffffff81051acc>] ? del_timer_sync+0x32/0x3c
> [ 2164.256565]  [<ffffffff81116c74>] ? bdi_writeback_thread+0x9f/0x1ee
> [ 2164.256568]  [<ffffffff81116bd5>] ? wb_do_writeback+0x1bb/0x1bb
> [ 2164.256571]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2164.256573]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2164.256576]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2164.256578]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2164.256581]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2164.256591] INFO: task blkback.2.hda:5686 blocked for more than 120 seconds.
> [ 2164.256647] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2164.256732] blkback.2.hda   D ffff8803ebc13740     0  5686      2 0x00000000
> [ 2164.256735]  ffff8803d6752340 0000000000000246 ffffffff8103b30f ffff88038e6de9f0
> [ 2164.256738]  0000000000013740 ffff8803c1759fd8 ffff8803c1759fd8 ffff88038e6de9f0
> [ 2164.256741]  ffffffff8103f12c ffff8803ebc1b900 ffff8803bbfa9540 ffff8803b9510ab0
> [ 2164.256744] Call Trace:
> [ 2164.256747]  [<ffffffff8103b30f>] ? ttwu_do_wakeup+0x2d/0xd2
> [ 2164.256750]  [<ffffffff8103f12c>] ? try_to_wake_up+0x171/0x181
> [ 2164.256753]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2164.256757]  [<ffffffff811b10d4>] ? call_rwsem_down_read_failed+0x14/0x30
> [ 2164.256760]  [<ffffffff81347ec2>] ? down_read+0x17/0x19
> [ 2164.256766]  [<ffffffffa0194924>] ? request_write+0x7c/0x2a9 [bcache]
> [ 2164.256768]  [<ffffffff81196c93>] ? generic_make_request+0x14e/0x19e
> [ 2164.256771]  [<ffffffff81196db7>] ? submit_bio+0xd4/0x100
> [ 2164.256774]  [<ffffffffa03a3a46>] ? dispatch_rw_block_io+0x48a/0x525 [xen_blkback]
> [ 2164.256778]  [<ffffffff81007241>] ? get_phys_to_machine+0x12/0x5d
> [ 2164.256781]  [<ffffffff810047ad>] ? pfn_to_mfn+0x13/0x29
> [ 2164.256784]  [<ffffffff81003125>] ? xen_end_context_switch+0xe/0x1c
> [ 2164.256786]  [<ffffffff810037cd>] ? xen_mc_issue.constprop.23+0x10/0x4d
> [ 2164.256789]  [<ffffffff8100d02f>] ? load_TLS+0x7/0xa
> [ 2164.256792]  [<ffffffff8100d68f>] ? __switch_to+0x141/0x25e
> [ 2164.256795]  [<ffffffff8103bc3c>] ? pick_next_task_fair+0xfd/0x111
> [ 2164.256798]  [<ffffffffa03a3cea>] ? __do_block_io_op+0x209/0x236 [xen_blkback]
> [ 2164.256801]  [<ffffffffa03a4021>] ? xen_blkif_schedule+0x2e2/0x3d9 [xen_blkback]
> [ 2164.256804]  [<ffffffff8105f187>] ? abort_exclusive_wait+0x79/0x79
> [ 2164.256807]  [<ffffffffa03a3d3f>] ? xen_blkif_be_int+0x28/0x28 [xen_blkback]
> [ 2164.256810]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2164.256813]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2164.256816]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2164.256818]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2164.256821]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> [ 2164.256824] INFO: task blkback.3.hda:6241 blocked for more than 120 seconds.
> [ 2164.256880] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2164.256965] blkback.3.hda   D ffff8803ebc13740     0  6241      2 0x00000000
> [ 2164.256968]  ffffffff8160d020 0000000000000246 000000000000000f ffff88038e17aa70
> [ 2164.256971]  0000000000013740 ffff880309891fd8 ffff880309891fd8 ffff88038e17aa70
> [ 2164.256974]  0000000000000008 ffff8803bae9f858 0000000000000000 ffff8803b9510ab0
> [ 2164.256977] Call Trace:
> [ 2164.256980]  [<ffffffff8134853c>] ? rwsem_down_failed_common+0xdc/0x110
> [ 2164.256984]  [<ffffffff811b10d4>] ? call_rwsem_down_read_failed+0x14/0x30
> [ 2164.256987]  [<ffffffff81347ec2>] ? down_read+0x17/0x19
> [ 2164.256993]  [<ffffffffa0194924>] ? request_write+0x7c/0x2a9 [bcache]
> [ 2164.256995]  [<ffffffff81196c93>] ? generic_make_request+0x14e/0x19e
> [ 2164.256998]  [<ffffffff81196db7>] ? submit_bio+0xd4/0x100
> [ 2164.257001]  [<ffffffffa03a3a46>] ? dispatch_rw_block_io+0x48a/0x525 [xen_blkback]
> [ 2164.257004]  [<ffffffff81007241>] ? get_phys_to_machine+0x12/0x5d
> [ 2164.257007]  [<ffffffff810047ad>] ? pfn_to_mfn+0x13/0x29
> [ 2164.257009]  [<ffffffff81003f5f>] ? arch_local_irq_restore+0x7/0x8
> [ 2164.257012]  [<ffffffff810040fa>] ? xen_mc_flush+0x11d/0x160
> [ 2164.257015]  [<ffffffff81003125>] ? xen_end_context_switch+0xe/0x1c
> [ 2164.257017]  [<ffffffff810037cd>] ? xen_mc_issue.constprop.23+0x10/0x4d
> [ 2164.257020]  [<ffffffff8100d02f>] ? load_TLS+0x7/0xa
> [ 2164.257022]  [<ffffffff8100d68f>] ? __switch_to+0x141/0x25e
> [ 2164.257025]  [<ffffffff8103bc3c>] ? pick_next_task_fair+0xfd/0x111
> [ 2164.257028]  [<ffffffffa03a3cea>] ? __do_block_io_op+0x209/0x236 [xen_blkback]
> [ 2164.257032]  [<ffffffffa03a4021>] ? xen_blkif_schedule+0x2e2/0x3d9 [xen_blkback]
> [ 2164.257035]  [<ffffffff8105f187>] ? abort_exclusive_wait+0x79/0x79
> [ 2164.257038]  [<ffffffffa03a3d3f>] ? xen_blkif_be_int+0x28/0x28 [xen_blkback]
> [ 2164.257041]  [<ffffffff8105ec54>] ? kthread+0x76/0x7e
> [ 2164.257043]  [<ffffffff8134f834>] ? kernel_thread_helper+0x4/0x10
> [ 2164.257046]  [<ffffffff8134d8f3>] ? int_ret_from_sys_call+0x7/0x1b
> [ 2164.257048]  [<ffffffff813488fc>] ? retint_restore_args+0x5/0x6
> [ 2164.257051]  [<ffffffff8134f830>] ? gs_change+0x13/0x13
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
