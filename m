From: Jan Wiele <jan@wiele.org>
Subject: Hang in bcache/qemu
Date: Wed, 11 Jan 2017 18:34:17 +0100
Message-ID: <2059985.veGUll5WnS@j-t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from fabrik17.de ([78.47.224.236]:55861 "EHLO mail.fabrik17.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030963AbdAKRjq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Jan 2017 12:39:46 -0500
Received: from j-t460p.localnet (unknown [134.147.202.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.fabrik17.de (Postfix) with ESMTPSA id 60E6761AAF
        for <linux-bcache@vger.kernel.org>; Wed, 11 Jan 2017 18:34:07 +0100 (CET)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,
I'm experiencing a possible bcache-hang in my setup. 

Mainboard: Asrock Rack EP2C602
CPU: 2x Intel Xeon E5-2670
Linux: 4.8.13-1-ARCH
Cache-device: Partition on Samsung SSD 850 EVO 500GB
Backing-device: 500GB Western Digital Black


Bcache is running in writeback mode. On top of bcache, I'm running LVM, which provides a Games-LV for a Qemu Windows-10 VM (Games-HD with drive letter 'D'. Drive C is hosted on a non-bcache block device. Each VM has its own GPU via passthrough). 
For a second/third VM, I create snapshots of the Games-LV.

When playing the game Overwatch, the first VM suddenly stops to respond (after about >20min), some seconds later the second VM, too.

Currently I'm not near the machine with the problem, but I'm appending as much information as possible.


Regards,
Jan



$ bcache-super-show /dev/sdb6
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 617AC6C2ABF15A0D [match]
sb.version              3 [cache device]

dev.label               (empty)
dev.uuid                73ec71d1-1353-4cc0-8b06-d798b44d593e
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 204692480
dev.cache.total_sectors 204693504
dev.cache.ordered       yes
dev.cache.discard       no
dev.cache.pos           0
dev.cache.replacement   0 [lru]

cset.uuid               025ec95a-c03b-481f-97e4-d6dab92ba6b1

$ dmesg
[...]
[ 3945.367318] INFO: task kworker/22:0:146 blocked for more than 120 seconds.
[ 3945.369245]       Not tainted 4.8.13-1-ARCH #1
[ 3945.371113] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3945.372970] kworker/22:0    D ffff88046d2c3cd8     0   146      2 0x00000000
[ 3945.372982] Workqueue: events update_writeback_rate [bcache]
[ 3945.372983]  ffff88046d2c3cd8 00ff88046d2c3cd0 ffff88046148e3c0 ffff88046d270e40
[ 3945.372986]  ffff88046fd97ff0 ffff88046d2c4000 ffff8804696f0ad8 ffff88046d2c3d10
[ 3945.372988]  ffff8804696f0af0 ffff8804696f0b18 ffff88046d2c3cf0 ffffffff815f40ec
[ 3945.372990] Call Trace:
[ 3945.372995]  [<ffffffff815f40ec>] schedule+0x3c/0x90
[ 3945.372997]  [<ffffffff815f6669>] rwsem_down_read_failed+0xf9/0x150
[ 3945.372999]  [<ffffffff8130bb08>] call_rwsem_down_read_failed+0x18/0x30
[ 3945.373000]  [<ffffffff815f5f07>] down_read+0x17/0x30
[ 3945.373004]  [<ffffffffa0056dc5>] update_writeback_rate+0x25/0x210 [bcache]
[ 3945.373006]  [<ffffffff81095ef5>] process_one_work+0x1e5/0x470
[ 3945.373008]  [<ffffffff810961c8>] worker_thread+0x48/0x4e0
[ 3945.373009]  [<ffffffff81096180>] ? process_one_work+0x470/0x470
[ 3945.373011]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[ 3945.373014]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[ 3945.373016]  [<ffffffff815f823f>] ret_from_fork+0x1f/0x40
[ 3945.373018]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[ 3945.373031] INFO: task bcache_writebac:343 blocked for more than 120 seconds.
[ 3945.374945]       Not tainted 4.8.13-1-ARCH #1
[ 3945.376837] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3945.378724] bcache_writebac D ffff88046975fcb8     0   343      2 0x00000000
[ 3945.378735]  ffff88046975fcb8 00ff88046fa17f80 ffffffff81a0d500 ffff88046978d580
[ 3945.378737]  ffff88046978d500 ffff880469760000 ffff8804696f0ad8 ffff8804696f0ad8
[ 3945.378740]  ffff8804696f0af0 ffffffff00000001 ffff88046975fcd0 ffffffff815f40ec
[ 3945.378742] Call Trace:
[ 3945.378744]  [<ffffffff815f40ec>] schedule+0x3c/0x90
[ 3945.378746]  [<ffffffff815f67f2>] rwsem_down_write_failed+0x132/0x2b0
[ 3945.378748]  [<ffffffff8130bb37>] call_rwsem_down_write_failed+0x17/0x30
[ 3945.378750]  [<ffffffff815f5f44>] down_write+0x24/0x40
[ 3945.378754]  [<ffffffffa005747b>] bch_writeback_thread+0x6b/0x7f0 [bcache]
[ 3945.378758]  [<ffffffffa0057410>] ? write_dirty+0xb0/0xb0 [bcache]
[ 3945.378762]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[ 3945.378763]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[ 3945.378765]  [<ffffffff815f823f>] ret_from_fork+0x1f/0x40
[ 3945.378767]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[ 3945.378777] INFO: task qemu-system-x86:829 blocked for more than 120 seconds.
[ 3945.380619]       Not tainted 4.8.13-1-ARCH #1
[ 3945.382501] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3945.385458] qemu-system-x86 D ffff88046933b7a8     0   829      1 0x00000000
[ 3945.385461]  ffff88046933b7a8 00ff88046933b7b0 ffff8808650faac0 ffff88086ab52ac0
[ 3945.385463]  8000000000000000 ffff88046933c000 ffff8804696f0ad8 ffff88046933b7e0
[ 3945.385465]  ffff8804696f0af0 ffff8804696f0000 ffff88046933b7c0 ffffffff815f40ec
[ 3945.385467] Call Trace:
[ 3945.385470]  [<ffffffff815f40ec>] schedule+0x3c/0x90
[ 3945.385471]  [<ffffffff815f6669>] rwsem_down_read_failed+0xf9/0x150
[ 3945.385475]  [<ffffffffa00457db>] ? bch_submit_bbio+0x2b/0x30 [bcache]
[ 3945.385477]  [<ffffffff8130bb08>] call_rwsem_down_read_failed+0x18/0x30
[ 3945.385478]  [<ffffffff815f5f07>] down_read+0x17/0x30
[ 3945.385482]  [<ffffffffa004ab9b>] cached_dev_make_request+0x63b/0xcb0 [bcache]
[ 3945.385485]  [<ffffffff812cd0e2>] generic_make_request+0xf2/0x1a0
[ 3945.385487]  [<ffffffff812cd20d>] submit_bio+0x7d/0x150
[ 3945.385490]  [<ffffffff8124a1e3>] __blockdev_direct_IO+0x31a3/0x4040
[ 3945.385493]  [<ffffffff8121d2dd>] ? poll_freewait+0x8d/0xb0
[ 3945.385495]  [<ffffffff81244520>] ? I_BDEV+0x20/0x20
[ 3945.385497]  [<ffffffff81244e43>] blkdev_direct_IO+0x43/0x50
[ 3945.385500]  [<ffffffff81179b04>] generic_file_direct_write+0xb4/0x170
[ 3945.385502]  [<ffffffff81179c7b>] __generic_file_write_iter+0xbb/0x1d0
[ 3945.385504]  [<ffffffff81205d34>] ? __check_object_size+0x54/0x1d6
[ 3945.385506]  [<ffffffff81245fb0>] ? bd_acquire+0xb0/0xb0
[ 3945.385508]  [<ffffffff8124603b>] blkdev_write_iter+0x8b/0x100
[ 3945.385509]  [<ffffffff81245fb0>] ? bd_acquire+0xb0/0xb0
[ 3945.385511]  [<ffffffff8131235a>] ? import_iovec+0x3a/0xe0
[ 3945.385514]  [<ffffffff81259407>] aio_run_iocb+0x247/0x2c0
[ 3945.385516]  [<ffffffff81256586>] ? eventfd_ctx_read+0x166/0x1e0
[ 3945.385518]  [<ffffffff8121d4c0>] ? poll_select_copy_remaining+0x150/0x150
[ 3945.385519]  [<ffffffff810a6c00>] ? wake_up_q+0x80/0x80
[ 3945.385521]  [<ffffffff81227567>] ? __fget+0x77/0xb0
[ 3945.385522]  [<ffffffff81227605>] ? __fget_light+0x25/0x60
[ 3945.385524]  [<ffffffff81227653>] ? __fdget+0x13/0x20
[ 3945.385526]  [<ffffffff8125ade4>] do_io_submit+0x364/0x590
[ 3945.385528]  [<ffffffff8125b020>] SyS_io_submit+0x10/0x20
[ 3945.385530]  [<ffffffff815f8032>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[ 4068.241562] INFO: task kworker/22:0:146 blocked for more than 120 seconds.
[ 4068.243485]       Not tainted 4.8.13-1-ARCH #1
[ 4068.245395] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4068.247346] kworker/22:0    D ffff88046d2c3cd8     0   146      2 0x00000000
[ 4068.247354] Workqueue: events update_writeback_rate [bcache]
[ 4068.247355]  ffff88046d2c3cd8 00ff88046d2c3cd0 ffff88046148e3c0 ffff88046d270e40
[ 4068.247358]  ffff88046fd97ff0 ffff88046d2c4000 ffff8804696f0ad8 ffff88046d2c3d10
[ 4068.247360]  ffff8804696f0af0 ffff8804696f0b18 ffff88046d2c3cf0 ffffffff815f40ec
[ 4068.247406] Call Trace:
[ 4068.247409]  [<ffffffff815f40ec>] schedule+0x3c/0x90
[ 4068.247411]  [<ffffffff815f6669>] rwsem_down_read_failed+0xf9/0x150
[ 4068.247413]  [<ffffffff8130bb08>] call_rwsem_down_read_failed+0x18/0x30
[ 4068.247415]  [<ffffffff815f5f07>] down_read+0x17/0x30
[ 4068.247418]  [<ffffffffa0056dc5>] update_writeback_rate+0x25/0x210 [bcache]
[ 4068.247421]  [<ffffffff81095ef5>] process_one_work+0x1e5/0x470
[ 4068.247422]  [<ffffffff810961c8>] worker_thread+0x48/0x4e0
[ 4068.247424]  [<ffffffff81096180>] ? process_one_work+0x470/0x470
[ 4068.247426]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[ 4068.247427]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[ 4068.247429]  [<ffffffff815f823f>] ret_from_fork+0x1f/0x40
[ 4068.247432]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[ 4068.247439] INFO: task bcache_writebac:343 blocked for more than 120 seconds.
[ 4068.249394]       Not tainted 4.8.13-1-ARCH #1
[ 4068.251285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4068.253194] bcache_writebac D ffff88046975fcb8     0   343      2 0x00000000
[ 4068.253196]  ffff88046975fcb8 00ff88046fa17f80 ffffffff81a0d500 ffff88046978d580
[ 4068.253199]  ffff88046978d500 ffff880469760000 ffff8804696f0ad8 ffff8804696f0ad8
[ 4068.253201]  ffff8804696f0af0 ffffffff00000001 ffff88046975fcd0 ffffffff815f40ec
[ 4068.253203] Call Trace:
[ 4068.253205]  [<ffffffff815f40ec>] schedule+0x3c/0x90
[ 4068.253207]  [<ffffffff815f67f2>] rwsem_down_write_failed+0x132/0x2b0
[ 4068.253209]  [<ffffffff8130bb37>] call_rwsem_down_write_failed+0x17/0x30
[ 4068.253211]  [<ffffffff815f5f44>] down_write+0x24/0x40
[ 4068.253214]  [<ffffffffa005747b>] bch_writeback_thread+0x6b/0x7f0 [bcache]
[ 4068.253218]  [<ffffffffa0057410>] ? write_dirty+0xb0/0xb0 [bcache]
[ 4068.253220]  [<ffffffff8109be38>] kthread+0xd8/0xf0
[ 4068.253221]  [<ffffffff8102c782>] ? __switch_to+0x2d2/0x630
[ 4068.253223]  [<ffffffff815f823f>] ret_from_fork+0x1f/0x40
[ 4068.253225]  [<ffffffff8109bd60>] ? kthread_worker_fn+0x170/0x170
[ 4068.253230] INFO: task qemu-system-x86:829 blocked for more than 120 seconds.
[ 4068.255137]       Not tainted 4.8.13-1-ARCH #1
[ 4068.256969] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4068.258844] qemu-system-x86 D ffff88046933b7a8     0   829      1 0x00000000
[ 4068.258846]  ffff88046933b7a8 00ff88046933b7b0 ffff8808650faac0 ffff88086ab52ac0
[ 4068.258848]  8000000000000000 ffff88046933c000 ffff8804696f0ad8 ffff88046933b7e0
[ 4068.258850]  ffff8804696f0af0 ffff8804696f0000 ffff88046933b7c0 ffffffff815f40ec
[ 4068.258853] Call Trace:
[ 4068.258855]  [<ffffffff815f40ec>] schedule+0x3c/0x90
[ 4068.258856]  [<ffffffff815f6669>] rwsem_down_read_failed+0xf9/0x150
[ 4068.258861]  [<ffffffffa00457db>] ? bch_submit_bbio+0x2b/0x30 [bcache]
[ 4068.258863]  [<ffffffff8130bb08>] call_rwsem_down_read_failed+0x18/0x30
[ 4068.258866]  [<ffffffff815f5f07>] down_read+0x17/0x30
[ 4068.258870]  [<ffffffffa004ab9b>] cached_dev_make_request+0x63b/0xcb0 [bcache]
[ 4068.258872]  [<ffffffff812cd0e2>] generic_make_request+0xf2/0x1a0
[ 4068.258874]  [<ffffffff812cd20d>] submit_bio+0x7d/0x150
[ 4068.258877]  [<ffffffff8124a1e3>] __blockdev_direct_IO+0x31a3/0x4040
[ 4068.258879]  [<ffffffff8121d2dd>] ? poll_freewait+0x8d/0xb0
[ 4068.258881]  [<ffffffff81244520>] ? I_BDEV+0x20/0x20
[ 4068.258883]  [<ffffffff81244e43>] blkdev_direct_IO+0x43/0x50
[ 4068.258886]  [<ffffffff81179b04>] generic_file_direct_write+0xb4/0x170
[ 4068.258887]  [<ffffffff81179c7b>] __generic_file_write_iter+0xbb/0x1d0
[ 4068.258889]  [<ffffffff81205d34>] ? __check_object_size+0x54/0x1d6
[ 4068.258891]  [<ffffffff81245fb0>] ? bd_acquire+0xb0/0xb0
[ 4068.258892]  [<ffffffff8124603b>] blkdev_write_iter+0x8b/0x100
[ 4068.258894]  [<ffffffff81245fb0>] ? bd_acquire+0xb0/0xb0
[ 4068.258896]  [<ffffffff8131235a>] ? import_iovec+0x3a/0xe0
[ 4068.258898]  [<ffffffff81259407>] aio_run_iocb+0x247/0x2c0
[ 4068.258900]  [<ffffffff81256586>] ? eventfd_ctx_read+0x166/0x1e0
[ 4068.258901]  [<ffffffff8121d4c0>] ? poll_select_copy_remaining+0x150/0x150
[ 4068.258903]  [<ffffffff810a6c00>] ? wake_up_q+0x80/0x80
[ 4068.258904]  [<ffffffff81227567>] ? __fget+0x77/0xb0
[ 4068.258906]  [<ffffffff81227605>] ? __fget_light+0x25/0x60
[ 4068.258908]  [<ffffffff81227653>] ? __fdget+0x13/0x20
[ 4068.258911]  [<ffffffff8125ade4>] do_io_submit+0x364/0x590
[ 4068.258913]  [<ffffffff8125b020>] SyS_io_submit+0x10/0x20
[ 4068.258915]  [<ffffffff815f8032>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[ 4068.258917] INFO: task qemu-system-x86:903 blocked for more than 120 seconds.
[ 4068.260756]       Not tainted 4.8.13-1-ARCH #1
[ 4068.262646] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4068.264530] qemu-system-x86 D ffff8802966b77a8     0   903      1 0x00000000
[ 4068.264533]  ffff8802966b77a8 00ff88086ab53900 ffff880460a1c740 ffff88086ab53900
[ 4068.264535]  ffff8802966b77f8 ffff8802966b8000 ffff8804696f0ad8 ffff8802966b77e0
[ 4068.264537]  ffff8804696f0af0 ffff8804696f0000 ffff8802966b77c0 ffffffff815f40ec
[ 4068.264539] Call Trace:
[ 4068.264541]  [<ffffffff815f40ec>] schedule+0x3c/0x90
[ 4068.264543]  [<ffffffff815f6669>] rwsem_down_read_failed+0xf9/0x150
[ 4068.264545]  [<ffffffff8130bb08>] call_rwsem_down_read_failed+0x18/0x30
[ 4068.264546]  [<ffffffff815f5f07>] down_read+0x17/0x30
[ 4068.264550]  [<ffffffffa004ab9b>] cached_dev_make_request+0x63b/0xcb0 [bcache]
[ 4068.264552]  [<ffffffff812cd0e2>] generic_make_request+0xf2/0x1a0
[ 4068.264554]  [<ffffffff812cd20d>] submit_bio+0x7d/0x150
[ 4068.264556]  [<ffffffff8124a1e3>] __blockdev_direct_IO+0x31a3/0x4040
[ 4068.264558]  [<ffffffff8121d2dd>] ? poll_freewait+0x8d/0xb0
[ 4068.264560]  [<ffffffff81244520>] ? I_BDEV+0x20/0x20
[ 4068.264562]  [<ffffffff81244e43>] blkdev_direct_IO+0x43/0x50
[ 4068.264564]  [<ffffffff81179b04>] generic_file_direct_write+0xb4/0x170
[ 4068.264566]  [<ffffffff81179c7b>] __generic_file_write_iter+0xbb/0x1d0
[ 4068.264567]  [<ffffffff81205d34>] ? __check_object_size+0x54/0x1d6
[ 4068.264569]  [<ffffffff81245fb0>] ? bd_acquire+0xb0/0xb0
[ 4068.264571]  [<ffffffff8124603b>] blkdev_write_iter+0x8b/0x100
[ 4068.264573]  [<ffffffff81245fb0>] ? bd_acquire+0xb0/0xb0
[ 4068.264574]  [<ffffffff8131235a>] ? import_iovec+0x3a/0xe0
[ 4068.264576]  [<ffffffff81259407>] aio_run_iocb+0x247/0x2c0
[ 4068.264579]  [<ffffffff810af45c>] ? set_next_entity+0x4c/0x940
[ 4068.264581]  [<ffffffff810b41d4>] ? put_prev_entity+0xb4/0x8c0
[ 4068.264582]  [<ffffffff81227567>] ? __fget+0x77/0xb0
[ 4068.264583]  [<ffffffff81227605>] ? __fget_light+0x25/0x60
[ 4068.264585]  [<ffffffff81227653>] ? __fdget+0x13/0x20
[ 4068.264587]  [<ffffffff8125ade4>] do_io_submit+0x364/0x590
[ 4068.264589]  [<ffffffff8125b020>] SyS_io_submit+0x10/0x20
[ 4068.264590]  [<ffffffff815f8032>] entry_SYSCALL_64_fastpath+0x1a/0xa4
