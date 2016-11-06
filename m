From: Marcin <marcin@mejor.pl>
Subject: [branch:bcachefs-testing][tier] Massive slow down after some time
Date: Sun, 06 Nov 2016 15:04:12 +0100
Message-ID: <d61c1210e331ff556a9fd1d14c278a01@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:16370 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751660AbcKFOEy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 6 Nov 2016 09:04:54 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
I'm trying mentioned branch. I've got tiered bcachefs witch lz4 
compresion turned on.
After some times of copying of files into bcachefs I noticed huge slow 
downa of writing. Htop shows that kernel thread bcache_gc consumes a lot 
of CPU and spends a lot of time waiting for I/O. Iostat shows that 
almost all I/Ooperations goes to tier 1. In dmesg I see a couple of 
repeated messages (they appears together, "INFO: task kworker/u8:2:11787 
blocked for more than 120 seconds." with "INFO: task rsync:11935 blocked 
for more than 120 seconds." :

[sob lis  5 21:11:49 2016] INFO: task kworker/u8:2:11787 blocked for 
more than 120 seconds.
[sob lis  5 21:11:49 2016]       Tainted: G        W       4.8.0+ #1
[sob lis  5 21:11:49 2016] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[sob lis  5 21:11:49 2016] kworker/u8:2    D ffff88006823f9b0     0 
11787      2 0x00000000
[sob lis  5 21:11:49 2016] Workqueue: writeback wb_workfn 
(flush-bcache-1)
[sob lis  5 21:11:49 2016]  ffff88006823f9b0 ffff88003710b600 
ffff880098b08000 ffff88006823f978
[sob lis  5 21:11:49 2016]  ffff880068240000 0000000000000900 
ffff88006823fc10 ffff88009407b578
[sob lis  5 21:11:49 2016]  ffff880094070000 ffff88006823f9c8 
ffffffff8149d9c0 ffff88004c819220
[sob lis  5 21:11:49 2016] Call Trace:
[sob lis  5 21:11:49 2016]  [<ffffffff8149d9c0>] schedule+0x30/0x80
[sob lis  5 21:11:49 2016]  [<ffffffffa02fa24c>] 
bch_writepages+0x37c/0x530 [bcache]
[sob lis  5 21:11:49 2016]  [<ffffffff81089f80>] ? 
wake_atomic_t_function+0x60/0x60
[sob lis  5 21:11:49 2016]  [<ffffffff8111981c>] do_writepages+0x1c/0x30
[sob lis  5 21:11:49 2016]  [<ffffffff811a01d0>] 
__writeback_single_inode+0x40/0x320
[sob lis  5 21:11:49 2016]  [<ffffffff811a0977>] 
writeback_sb_inodes+0x227/0x5b0
[sob lis  5 21:11:49 2016]  [<ffffffff811a0d8d>] 
__writeback_inodes_wb+0x8d/0xc0
[sob lis  5 21:11:49 2016]  [<ffffffff811a107a>] 
wb_writeback+0x22a/0x2e0
[sob lis  5 21:11:49 2016]  [<ffffffff811a194c>] wb_workfn+0x20c/0x3b0
[sob lis  5 21:11:49 2016]  [<ffffffff81064f0b>] 
process_one_work+0x15b/0x470
[sob lis  5 21:11:49 2016]  [<ffffffff81065266>] 
worker_thread+0x46/0x4e0
[sob lis  5 21:11:49 2016]  [<ffffffff81065220>] ? 
process_one_work+0x470/0x470
[sob lis  5 21:11:49 2016]  [<ffffffff81065220>] ? 
process_one_work+0x470/0x470
[sob lis  5 21:11:49 2016]  [<ffffffff8106a214>] kthread+0xc4/0xe0
[sob lis  5 21:11:49 2016]  [<ffffffff814a1c7f>] ret_from_fork+0x1f/0x40
[sob lis  5 21:11:49 2016]  [<ffffffff8106a150>] ? 
kthread_worker_fn+0x160/0x160
[sob lis  5 21:11:49 2016] INFO: task rsync:11935 blocked for more than 
120 seconds.
[sob lis  5 21:11:49 2016]       Tainted: G        W       4.8.0+ #1
[sob lis  5 21:11:49 2016] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[sob lis  5 21:11:49 2016] rsync           D ffff88008e183b18     0 
11935  11934 0x00000000
[sob lis  5 21:11:49 2016]  ffff88008e183b18 ffff880004861b00 
ffff88009b17b600 ffff88008e183ae0
[sob lis  5 21:11:49 2016]  ffff88008e184000 0000000000000000 
ffff88008e183cf0 ffff88009407b578
[sob lis  5 21:11:49 2016]  ffff880094070000 ffff88008e183b30 
ffffffff8149d9c0 ffff880056ed9a78
[sob lis  5 21:11:49 2016] Call Trace:
[sob lis  5 21:11:49 2016]  [<ffffffff8149d9c0>] schedule+0x30/0x80
[sob lis  5 21:11:49 2016]  [<ffffffffa02fa24c>] 
bch_writepages+0x37c/0x530 [bcache]
[sob lis  5 21:11:49 2016]  [<ffffffff8110cb46>] ? 
__find_get_pages+0x136/0x370
[sob lis  5 21:11:49 2016]  [<ffffffff81089f80>] ? 
wake_atomic_t_function+0x60/0x60
[sob lis  5 21:11:49 2016]  [<ffffffff8110cdd5>] ? 
pagecache_iter_next+0x55/0xb0
[sob lis  5 21:11:49 2016]  [<ffffffff8111ceca>] ? 
truncate_inode_pages_range+0x24a/0x670
[sob lis  5 21:11:49 2016]  [<ffffffff8110bf9e>] ? 
__add_to_page_cache_locked+0x9e/0x200
[sob lis  5 21:11:49 2016]  [<ffffffff8119f698>] ? 
locked_inode_to_wb_and_lock_list+0x48/0xf0
[sob lis  5 21:11:49 2016]  [<ffffffff811a00f4>] ? 
__mark_inode_dirty+0x2c4/0x360
[sob lis  5 21:11:49 2016]  [<ffffffff8111981c>] do_writepages+0x1c/0x30
[sob lis  5 21:11:49 2016]  [<ffffffff8110d515>] 
__filemap_fdatawrite_range+0xa5/0xe0
[sob lis  5 21:11:49 2016]  [<ffffffff8110d66c>] 
filemap_write_and_wait_range+0x3c/0x90
[sob lis  5 21:11:49 2016]  [<ffffffffa02fb021>] 
bch_truncate+0x1f1/0x230 [bcache]
[sob lis  5 21:11:49 2016]  [<ffffffffa02f4ba3>] bch_setattr+0x93/0xa0 
[bcache]
[sob lis  5 21:11:49 2016]  [<ffffffff81190be7>] 
notify_change+0x247/0x400
[sob lis  5 21:11:49 2016]  [<ffffffff81172a9a>] do_truncate+0x5a/0x90
[sob lis  5 21:11:49 2016]  [<ffffffff81172d63>] 
do_sys_ftruncate.constprop.18+0xe3/0x100
[sob lis  5 21:11:49 2016]  [<ffffffff81172da9>] SyS_ftruncate+0x9/0x10
[sob lis  5 21:11:49 2016]  [<ffffffff814a1a5f>] 
entry_SYSCALL_64_fastpath+0x17/0x93


Marcin
