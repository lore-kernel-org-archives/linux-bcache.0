From: Alex Vorona <alex@vorona.com.ua>
Subject: writeback deadlocks
Date: Sun, 22 Nov 2015 18:44:18 +0200
Message-ID: <5651F0E2.1010208@vorona.com.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.vorona.com.ua ([78.46.163.58]:50056 "EHLO
	mail.vorona.com.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbbKVQoU (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 22 Nov 2015 11:44:20 -0500
Received: from MBP-IraMac.nest.kh.ua (unknown [193.178.146.68])
	by mail.vorona.com.ua (Postfix) with ESMTPSA id BB8A7906D0
	for <linux-bcache@vger.kernel.org>; Sun, 22 Nov 2015 17:44:18 +0100 (CET)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

We got following bcache-related problem today in one second 03:17:56

INFO: task bcache_writebac:3182 blocked for more than 120 seconds.
      Not tainted 4.1.6-1.el6.elrepo.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bcache_writebac D ffff881021233d38     0  3182      2 0x00000080
ffff881021233d38 ffff881032d18050 ffff8810389280d0 0000000000000000
ffff881021230008 ffff881036910ae8 ffff881032d18050 ffff881036910b00
ffffffff00000000 ffff881021233d58 ffffffff816dff8e ffff881032d18050
Call Trace:
[<ffffffff816dff8e>] schedule+0x3e/0x90
[<ffffffff816e2585>] rwsem_down_write_failed+0xf5/0x210
[<ffffffff81308a73>] call_rwsem_down_write_failed+0x13/0x20
[<ffffffff816e1e71>] ? down_write+0x31/0x50
[<ffffffffa058fb92>] bch_writeback_thread+0x62/0x4d0 [bcache]
[<ffffffffa058fb30>] ? read_dirty+0x400/0x400 [bcache]
[<ffffffffa058fb30>] ? read_dirty+0x400/0x400 [bcache]
[<ffffffff81095c4e>] kthread+0xce/0xf0
[<ffffffff81095b80>] ? kthread_freezable_should_stop+0x70/0x70
[<ffffffff816e3d22>] ret_from_fork+0x42/0x70
[<ffffffff81095b80>] ? kthread_freezable_should_stop+0x70/0x70
INFO: task qemu-kvm:591 blocked for more than 120 seconds.
      Not tainted 4.1.6-1.el6.elrepo.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
qemu-kvm        D ffff88054e71b860     0   591      1 0x00000080
ffff88054e71b860 ffff880102ba6010 ffff880100e23010 ffffffff812c901a
ffff88054e718008 ffff881036910ae8 ffff88054e71b958 ffff88054e71b948
ffff880d175047e0 ffff88054e71b880 ffffffff816dff8e ffff881032406922
Call Trace:
[<ffffffff812c901a>] ? bio_alloc_bioset+0xba/0x220
[<ffffffff816dff8e>] schedule+0x3e/0x90
[<ffffffff816e2435>] rwsem_down_read_failed+0xa5/0x100
[<ffffffff81308a44>] call_rwsem_down_read_failed+0x14/0x30
[<ffffffff816e1eb4>] ? down_read+0x24/0x30
[<ffffffffa05824d1>] cached_dev_write+0x81/0x470 [bcache]
[<ffffffffa0583593>] cached_dev_make_request+0x3b3/0x470 [bcache]
[<ffffffffa0004a96>] ? dm_make_request+0x86/0xe0 [dm_mod]
[<ffffffffa0005141>] ? dm_table_find_target+0x51/0x80 [dm_mod]
[<ffffffff812cffd0>] generic_make_request+0xc0/0x100
[<ffffffff812d008f>] submit_bio+0x7f/0x160
[<ffffffff8121fb78>] do_blockdev_direct_IO+0xa88/0xbc0
[<ffffffff8121aa20>] ? I_BDEV+0x10/0x10
[<ffffffff8121aa20>] ? I_BDEV+0x10/0x10
[<ffffffff8121fcf3>] __blockdev_direct_IO+0x43/0x50
[<ffffffff8121b98c>] blkdev_direct_IO+0x4c/0x50
[<ffffffff8116d91e>] generic_file_direct_write+0xae/0x170
[<ffffffff8116da9b>] __generic_file_write_iter+0xbb/0x1b0
[<ffffffff8121b12b>] blkdev_write_iter+0xab/0x110
[<ffffffff811e2c65>] __vfs_write+0xd5/0x100
[<ffffffff811e2f0b>] vfs_write+0xab/0x120
[<ffffffff811e3adc>] SyS_pwrite64+0x8c/0x90
[<ffffffff816e392e>] system_call_fastpath+0x12/0x71

and a couple of same qemu-kvm stack traces.  We got LA 400+ and blocked 
IO in all qemu-kvm instances.

Kernel 4.1.6-1.el6.elrepo.x86_64, bcache writeback over 2x240GB SSD md 
RAID1 + 2x2TB HDD md RAID1. There was linux raid-check running over HDDs 
and @03:15 daily cronjobs started in all qemu-kvm instances so there was 
IO spike.

It looks like all qemu-kvm processes got a deadlock in bio_alloc_bioset 
and bcache_writebac just waits for down_write writeback_lock

I had noted bio_alloc_bioset can cause deadlock according to 
https://www.kernel.org/doc/htmldocs/filesystems/API-bio-alloc-bioset.html when 
used with GFP_WAIT. bio_alloc_bioset is used in request.c with GFP_NOIO 
with same value as GFP_WAIT. Maybe bioset pool of 4 bios is too small ?

Thanks,
Alex
