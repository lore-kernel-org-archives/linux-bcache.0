From: Karl Tomlinson <karlt@karlt.net>
Subject: hang during suspend to RAM when bcache cache device is attached
Date: Wed, 17 May 2017 19:01:00 +1200
Message-ID: <87pof8rmqb.fsf@karlt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx1.scl3.mozilla.com ([63.245.214.155]:42267 "EHLO
        smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753223AbdEQHJb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 May 2017 03:09:31 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I'm reproducing the same bug as reported in
http://comments.gmane.org/gmane.linux.kernel.bcache.devel/3820

Attempts to suspend are hanging before reaching suspended state.
This is reproducible when writing to the filesystem on the bcache
device during suspend.  I've had several successful suspends while
actively reading from a clean bcache.

The hangs happen even with cache_mode none, but not when the cache
device is detached.

The hang happens even with pm_async=0.

Below is kernel logging in efi vars pstore from
BOOTPARAM_HUNG_TASK_PANIC with
"echo processors > pm_test; echo mem > state"
first without writing to bcache filesystem and second during write

<6>[  593.528983] PM: Syncing filesystems ... done.
<7>[  593.529176] PM: Preparing system for sleep (mem)
<6>[  593.534593] Freezing user space processes ... (elapsed 0.001 seconds) done.
<6>[  593.535802] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
<7>[  593.535803] PM: Suspending system (mem)
Panic#1 Part8
<5>[  593.536453] sd 3:0:0:0: [sda] Synchronizing SCSI cache
<5>[  593.536542] sd 3:0:0:0: [sda] Stopping disk
<6>[  593.544311] ACPI : EC: event blocked
<6>[  594.720138] PM: suspend of devices complete after 1183.841 msecs
<6>[  594.726528] PM: late suspend of devices complete after 0.642 msecs
<6>[  594.729983] ACPI : EC: interrupt blocked
<6>[  594.730816] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
<6>[  594.876383] PM: noirq suspend of devices complete after 146.923 msecs
<6>[  594.883276] ACPI: Preparing to enter system sleep state S3
<6>[  594.897724] ACPI : EC: EC stopped
<6>[  594.903503] PM: Saving platform NVS memory
<6>[  594.909243] Disabling non-boot CPUs ...
<6>[  594.940892] smpboot: CPU 1 is now offline
<6>[  594.980876] smpboot: CPU 2 is now offline
<6>[  595.034401] smpboot: CPU 3 is now offline
<6>[  595.088590] smpboot: CPU 4 is now offline
<6>[  595.140995] smpboot: CPU 5 is now offline
<6>[  595.194274] smpboot: CPU 6 is now offline
<6>[  595.244280] smpboot: CPU 7 is now offline
<6>[  595.267167] suspend debug: Waiting for 5 second(s).
<6>[  600.273077] Enabling non-boot CPUs ...
<6>[  600.282830] x86: Booting SMP configuration:
<6>[  600.285372] smpboot: Booting Node 0 Processor 1 APIC 0x2
<4>[  600.290403]  cache: parent cpu1 should not be sleeping
<6>[  600.293228] CPU1 is up
<6>[  600.306196] smpboot: Booting Node 0 Processor 2 APIC 0x4
<4>[  600.311466]  cache: parent cpu2 should not be sleeping
<6>[  600.314370] CPU2 is up
<6>[  600.339551] smpboot: Booting Node 0 Processor 3 APIC 0x6
<4>[  600.344976]  cache: parent cpu3 should not be sleeping
<6>[  600.348031] CPU3 is up
<6>[  600.393065] smpboot: Booting Node 0 Processor 4 APIC 0x1
<4>[  600.400233]  cache: parent cpu4 should not be sleeping
<6>[  600.404696] CPU4 is up
Panic#1 Part7
<6>[  600.449772] smpboot: Booting Node 0 Processor 5 APIC 0x3
<4>[  600.456729]  cache: parent cpu5 should not be sleeping
<6>[  600.461185] CPU5 is up
<6>[  600.506488] smpboot: Booting Node 0 Processor 6 APIC 0x5
<4>[  600.513501]  cache: parent cpu6 should not be sleeping
<6>[  600.517901] CPU6 is up
<6>[  600.543196] smpboot: Booting Node 0 Processor 7 APIC 0x7
<4>[  600.550184]  cache: parent cpu7 should not be sleeping
<6>[  600.554647] CPU7 is up
<6>[  600.570474] ACPI : EC: EC started
<6>[  600.574349] ACPI: Waking up from system sleep state S3
<6>[  600.599959] ACPI : EC: interrupt unblocked
<6>[  600.616229] pcieport 0000:00:1c.0: Intel SPT PCH root port ACS workaround enabled
<6>[  600.616232] pcieport 0000:00:1c.4: Intel SPT PCH root port ACS workaround enabled
<6>[  600.616477] pcieport 0000:00:1c.2: Intel SPT PCH root port ACS workaround enabled
<6>[  600.616615] pcieport 0000:00:1d.0: Intel SPT PCH root port ACS workaround enabled
<6>[  600.619494] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
<6>[  601.080037] PM: noirq resume of devices complete after 480.233 msecs
<6>[  601.085143] PM: early resume of devices complete after 0.790 msecs
<6>[  601.087966] ACPI : EC: event unblocked
<6>[  601.091263] rtc_cmos 00:02: System wakeup disabled by ACPI
<5>[  601.097913] sd 3:0:0:0: [sda] Starting disk
<6>[  601.145656] PM: resume of devices complete after 57.866 msecs
<7>[  601.151057] PM: Finishing wakeup.
<6>[  601.151058] Restarting tasks ... done.
<4>[  601.152286] acpi PNP0401:00: Already enumerated
<4>[  601.158854] acpi PNP0501:00: Still not present
<6>[  601.418577] ata2: SATA link down (SStatus 0 SControl 300)
<6>[  601.418737] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
<6>[  601.432814] ata4.00: configured for UDMA/133
Panic#1 Part6
<6>[  679.637779] PM: Syncing filesystems ... done.
<7>[  680.724401] PM: Preparing system for sleep (mem)
<6>[  680.727590] Freezing user space processes ... (elapsed 0.001 seconds) done.
<6>[  680.728801] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
<7>[  680.728802] PM: Suspending system (mem)
<5>[  680.729361] sd 3:0:0:0: [sda] Synchronizing SCSI cache
<6>[  680.731985] ACPI : EC: event blocked
<5>[  680.756131] sd 3:0:0:0: [sda] Stopping disk
<6>[  681.923526] PM: suspend of devices complete after 1194.294 msecs
<6>[  681.926873] PM: late suspend of devices complete after 0.646 msecs
<6>[  681.930111] ACPI : EC: interrupt blocked
<6>[  681.931360] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
<6>[  682.076153] PM: noirq suspend of devices complete after 146.571 msecs
<6>[  682.079208] ACPI: Preparing to enter system sleep state S3
<6>[  682.085631] ACPI : EC: EC stopped
<6>[  682.088298] PM: Saving platform NVS memory
<6>[  682.090938] Disabling non-boot CPUs ...
<6>[  682.120654] smpboot: CPU 1 is now offline
<3>[  874.812721] INFO: task kworker/0:0:4 blocked for more than 120 seconds.
<3>[  874.815493]       Tainted: G        W       4.9.25-gentoo #33
<3>[  874.818282] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
<6>[  874.821137] kworker/0:0     D    0     4      2 0x00000000
<6>[  874.823962] Workqueue: events vmstat_shepherd
<4>[  874.826700]  ffff8808660fad00 ffff880865092540 000000000000bd64 ffff88086a298000
<4>[  874.829583]  ffff88088dc17418 ffffc90000067ca0 ffffffff8173934b 00000000000026ab
<4>[  874.832456]  ffff880800000000 ffff88086a2985d0 ffff88088dc17418 ffff88086a298000
<4>[  874.835311] Call Trace:
<4>[  874.838007]  [<ffffffff8173934b>] ? __schedule+0x27b/0x7a0
Panic#1 Part5
<4>[  874.840782]  [<ffffffff817398ab>] schedule+0x3b/0x90
<4>[  874.843466]  [<ffffffff81739ba3>] schedule_preempt_disabled+0x13/0x20
<4>[  874.846182]  [<ffffffff8173af03>] mutex_lock_nested+0x133/0x350
<4>[  874.848911]  [<ffffffff810711de>] ? get_online_cpus+0x4e/0x70
<4>[  874.851639]  [<ffffffff810711de>] get_online_cpus+0x4e/0x70
<4>[  874.854336]  [<ffffffff810711a2>] ? get_online_cpus+0x12/0x70
<4>[  874.857035]  [<ffffffff8115a91c>] vmstat_shepherd+0x1c/0xb0
<4>[  874.859742]  [<ffffffff81088a07>] process_one_work+0x1a7/0x420
<4>[  874.862474]  [<ffffffff810889a8>] ? process_one_work+0x148/0x420
<4>[  874.865213]  [<ffffffff81089009>] worker_thread+0x49/0x480
<4>[  874.867920]  [<ffffffff81088fc0>] ? rescuer_thread+0x340/0x340
<4>[  874.870639]  [<ffffffff8108e36d>] kthread+0xed/0x110
<4>[  874.873327]  [<ffffffff8108e280>] ? kthread_create_on_node+0x40/0x40
<4>[  874.876074]  [<ffffffff8173fc12>] ret_from_fork+0x22/0x30
<4>[  874.878798] 
<4>[  874.878798] Showing all locks held in the system:
<4>[  874.884120] 4 locks held by kworker/0:0/4:
<4>[  874.886782]  #0:  ("events"){......}, at: [<ffffffff810889a8>] process_one_work+0x148/0x420
<4>[  874.889732]  #1:  ((shepherd).work){......}, at: [<ffffffff810889a8>] process_one_work+0x148/0x420
<4>[  874.892772]  #2:  (cpu_hotplug.dep_map){......}, at: [<ffffffff810711a2>] get_online_cpus+0x12/0x70
<4>[  874.895787]  #3:  (cpu_hotplug.lock){......}, at: [<ffffffff810711de>] get_online_cpus+0x4e/0x70
<4>[  874.898768] 2 locks held by khungtaskd/58:
<4>[  874.901634]  #0:  (rcu_read_lock){......}, at: [<ffffffff811142fe>] watchdog+0x9e/0x360
<4>[  874.904668]  #1:  (tasklist_lock){......}, at: [<ffffffff810b70ff>] debug_show_all_locks+0x3f/0x1b0
<4>[  874.907659] 3 locks held by kworker/0:1/66:
Panic#1 Part4
<4>[  874.910499]  #0:  ("events"){......}, at: [<ffffffff810889a8>] process_one_work+0x148/0x420
<4>[  874.913544]  #1:  ((&(&b->work)->work)){......}, at: [<ffffffff810889a8>] process_one_work+0x148/0x420
<4>[  874.916633]  #2:  (&dev->mutex){......}, at: [<ffffffff815e0564>] btree_node_write_work+0x24/0x50
<4>[  874.919737] 9 locks held by sh/728:
<4>[  874.922638]  #0:  (sb_writers#4){......}, at: [<ffffffff811a05bc>] vfs_write+0x15c/0x180
<4>[  874.925708]  #1:  (&of->mutex){......}, at: [<ffffffff8121191a>] kernfs_fop_write+0xea/0x1a0
<4>[  874.928753]  #2:  (s_active#122){......}, at: [<ffffffff81211922>] kernfs_fop_write+0xf2/0x1a0
<4>[  874.931801]  #3:  (pm_mutex){......}, at: [<ffffffff810bcb6e>] pm_suspend+0xae/0x2b0
<4>[  874.934846]  #4:  (acpi_scan_lock){......}, at: [<ffffffff813c10f2>] acpi_scan_lock_acquire+0x12/0x20
<4>[  874.937961]  #5:  (cpu_add_remove_lock){......}, at: [<ffffffff810727cc>] freeze_secondary_cpus+0x1c/0x130
<4>[  874.941138]  #6:  (cpu_hotplug.dep_map){......}, at: [<ffffffff81072120>] cpu_hotplug_begin+0x0/0xc0
<4>[  874.944225]  #7:  (cpu_hotplug.lock){......}, at: [<ffffffff8107218d>] cpu_hotplug_begin+0x6d/0xc0
<4>[  874.947297]  #8:  (all_q_mutex){......}, at: [<ffffffff813112f3>] blk_mq_queue_reinit_work+0x13/0x110
<4>[  874.950463] 
<4>[  874.953358] =============================================
<4>[  874.953358] 
<4>[  874.959041] NMI backtrace for cpu 2
<4>[  874.961803] CPU: 2 PID: 58 Comm: khungtaskd Tainted: G        W       4.9.25-gentoo #33
<4>[  874.964763] Hardware name: Dell Inc. Precision 7710/0PMJX2, BIOS 1.10.7 02/09/2017
<4>[  874.967791]  ffffc9000024fda0 ffffffff8132898d 0000000000000000 ffffffff810320e0
<4>[  874.970865]  ffffc9000024fdc8 ffffffff8132d0ba 0000000000000000 ffffffff810320e0
Panic#1 Part3
<4>[  874.973812]  ffffffff81caf458 ffffc9000024fdf8 ffffffff8132d189 ffff88086a298000
<4>[  874.976747] Call Trace:
<4>[  874.979604]  [<ffffffff8132898d>] dump_stack+0x4f/0x72
<4>[  874.982517]  [<ffffffff810320e0>] ? irq_force_complete_move+0xf0/0xf0
<4>[  874.985428]  [<ffffffff8132d0ba>] nmi_cpu_backtrace+0x9a/0xa0
<4>[  874.988306]  [<ffffffff810320e0>] ? irq_force_complete_move+0xf0/0xf0
<4>[  874.991200]  [<ffffffff8132d189>] nmi_trigger_cpumask_backtrace+0xc9/0x100
<4>[  874.994114]  [<ffffffff81032154>] arch_trigger_cpumask_backtrace+0x14/0x20
<4>[  874.997042]  [<ffffffff811145a0>] watchdog+0x340/0x360
<4>[  874.999909]  [<ffffffff811142fe>] ? watchdog+0x9e/0x360
<4>[  875.002754]  [<ffffffff81114260>] ? hung_task_panic+0x20/0x20
<4>[  875.005575]  [<ffffffff8108e36d>] kthread+0xed/0x110
<4>[  875.008379]  [<ffffffff8108e280>] ? kthread_create_on_node+0x40/0x40
<4>[  875.011244]  [<ffffffff8173fc12>] ret_from_fork+0x22/0x30
<6>[  875.014096] Sending NMI from CPU 2 to CPUs 0,3-7:
<4>[  875.016983] NMI backtrace for cpu 5 skipped: idling at pc 0xffffffff8173ebcb
<4>[  875.019938] NMI backtrace for cpu 4 skipped: idling at pc 0xffffffff8173ebcb
<4>[  875.023513] NMI backtrace for cpu 0
<4>[  875.026290] CPU: 0 PID: 309 Comm: kworker/0:1H Tainted: G        W       4.9.25-gentoo #33
<4>[  875.029304] Hardware name: Dell Inc. Precision 7710/0PMJX2, BIOS 1.10.7 02/09/2017
<4>[  875.032387] Workqueue: kblockd blk_mq_run_work_fn
<4>[  875.035417] task: ffff880865092540 task.stack: ffffc900007b8000
<4>[  875.038418] RIP: 0010:[<ffffffff810b8229>]  [<ffffffff810b8229>] lock_release+0x289/0x380
<4>[  875.041511] RSP: 0018:ffffc900007bbcb8  EFLAGS: 00000282
<4>[  875.044553] RAX: ffff880865092540 RBX: ffff880869009c00 RCX: ffff88086945ea00
Panic#1 Part2
<4>[  875.047608] RDX: ffff880865092d70 RSI: 0000000000000000 RDI: 0000000000000000
<4>[  875.050616] RBP: ffffc900007bbcd8 R08: 0000000000000000 R09: 0000000000000000
<4>[  875.053520] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880869009c18
<4>[  875.056428] R13: ffff880865092d70 R14: 0000000000000002 R15: 0000000000000003
<4>[  875.059386] FS:  0000000000000000(0000) GS:ffff88088dc00000(0000) knlGS:0000000000000000
<4>[  875.062467] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  875.065514] CR2: 000000000181a078 CR3: 000000086186e000 CR4: 00000000003406f0
<4>[  875.068598] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[  875.071595] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
<4>[  875.074518] Stack:
<4>[  875.077359]  ffff880866cd5b80 ffffc900007bbd18 0000000000000000 ffff88088dc16ec0
<4>[  875.080492]  ffffc900007bbcf0 ffffffff8173f16a ffff880869009c00 ffffc900007bbd78
<4>[  875.083610]  ffffffff813109a9 ffff880866460000 ffff880869009c38 0000000000000000
<4>[  875.086618] Call Trace:
<4>[  875.089545]  [<ffffffff8173f16a>] _raw_spin_unlock+0x1a/0x50
<4>[  875.092586]  [<ffffffff813109a9>] __blk_mq_run_hw_queue+0x1b9/0x3a0
<4>[  875.095559]  [<ffffffff81310bbd>] blk_mq_run_work_fn+0xd/0x10
<4>[  875.098486]  [<ffffffff81088a07>] process_one_work+0x1a7/0x420
<4>[  875.101436]  [<ffffffff810889a8>] ? process_one_work+0x148/0x420
<4>[  875.104375]  [<ffffffff81089009>] worker_thread+0x49/0x480
<4>[  875.107288]  [<ffffffff81088fc0>] ? rescuer_thread+0x340/0x340
<4>[  875.110206]  [<ffffffff8108e36d>] kthread+0xed/0x110
<4>[  875.113094]  [<ffffffff8108e280>] ? kthread_create_on_node+0x40/0x40
<4>[  875.116049]  [<ffffffff8173fc12>] ret_from_fork+0x22/0x30
Panic#1 Part1
<4>[  875.119019] Code: 00 48 c7 c7 f5 27 9e 81 31 c0 e8 e3 8c fb ff 65 48 8b 04 25 00 c6 00 00 c7 80 dc 07 00 00 00 00 00 00 ff 75 c0 9d 48 83 c4 50 5b <41> 5c 41 5d 41 5e 41 5f 5d c3 e8 f8 de 27 00 85 c0 74 2d 44 8b 
<4>[  875.123386] NMI backtrace for cpu 3 skipped: idling at pc 0xffffffff8173ebcb
<4>[  875.128371] NMI backtrace for cpu 6 skipped: idling at pc 0xffffffff8173ebcb
<4>[  875.132606] NMI backtrace for cpu 7 skipped: idling at pc 0xffffffff8173ebcb
<0>[  875.135564] Kernel panic - not syncing: hung_task: blocked tasks
<4>[  875.139498] CPU: 2 PID: 58 Comm: khungtaskd Tainted: G        W       4.9.25-gentoo #33
<4>[  875.143587] Hardware name: Dell Inc. Precision 7710/0PMJX2, BIOS 1.10.7 02/09/2017
<4>[  875.147693]  ffffc9000024fd88 ffffffff8132898d ffff88086a298000 ffffffff819e5835
<4>[  875.151859]  ffffc9000024fe08 ffffffff8113aa51 0000000000000008 ffffc9000024fe18
<4>[  875.155937]  ffffc9000024fdb0 ffffffff810c70b2 0000000000000008 0000000080000001
<4>[  875.159949] Call Trace:
<4>[  875.163842]  [<ffffffff8132898d>] dump_stack+0x4f/0x72
<4>[  875.167844]  [<ffffffff8113aa51>] panic+0xce/0x204
<4>[  875.171750]  [<ffffffff810c70b2>] ? printk_nmi_flush+0x42/0x60
<4>[  875.175665]  [<ffffffff811145ae>] watchdog+0x34e/0x360
<4>[  875.179554]  [<ffffffff811142fe>] ? watchdog+0x9e/0x360
<4>[  875.183471]  [<ffffffff81114260>] ? hung_task_panic+0x20/0x20
<4>[  875.187358]  [<ffffffff8108e36d>] kthread+0xed/0x110
<4>[  875.191217]  [<ffffffff8108e280>] ? kthread_create_on_node+0x40/0x40
<4>[  875.195133]  [<ffffffff8173fc12>] ret_from_fork+0x22/0x30
<0>[  875.199042] Kernel Offset: disabled

Some discussion at https://patchwork.kernel.org/patch/8879681/ may
perhaps be relevant.
