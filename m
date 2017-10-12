From: Alexandr Kuznetsov <progmachine@xenlab.one>
Subject: bcache failure hangs something in kernel
Date: Thu, 12 Oct 2017 15:49:36 +0300
Message-ID: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from forward103o.mail.yandex.net ([37.140.190.177]:37159 "EHLO
        forward103o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751040AbdJLM5h (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Oct 2017 08:57:37 -0400
Received: from mxback8g.mail.yandex.net (mxback8g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:169])
        by forward103o.mail.yandex.net (Yandex) with ESMTP id BA0AD5881216
        for <linux-bcache@vger.kernel.org>; Thu, 12 Oct 2017 15:49:38 +0300 (MSK)
Content-Language: ru
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hellow.

Can any one help me? Two days ago i encountered bcache failure and since 
then i can't boot my system Ubuntu 16.04 amd64.
Now when cache and backend devices meets each other during register 
process, something hangs inside the kernel and such messages appear in 
dmesg:
[  839.113067] INFO: task bcache-register:2303 blocked for more than 120 
seconds.
[  839.113077]       Not tainted 4.4.0-97-generic #120-Ubuntu
[  839.113079] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  839.113082] bcache-register D ffff8801256f3a88     0  2303 1 0x00000004
[  839.113089]  ffff8801256f3a88 ffff88008edc0dd0 ffff88013560b800 
ffff880135bd5400
[  839.113093]  ffff8801256f4000 ffff88007a9f8000 0000000000000000 
0000000000000000
[  839.113096]  0000000000000000 ffff8801256f3aa0 ffffffff8183f6b5 
ffff88007a9f8000
[  839.113099] Call Trace:
[  839.113112]  [<ffffffff8183f6b5>] schedule+0x35/0x80
[  839.113133]  [<ffffffffc039c2b8>] bch_bucket_alloc+0x1d8/0x350 [bcache]
[  839.113139]  [<ffffffff810c4410>] ? wake_atomic_t_function+0x60/0x60
[  839.113148]  [<ffffffffc039c5c1>] __bch_bucket_alloc_set+0xf1/0x150 
[bcache]
[  839.113157]  [<ffffffffc039c66e>] bch_bucket_alloc_set+0x4e/0x70 [bcache]
[  839.113168]  [<ffffffffc03b0529>] __uuid_write+0x59/0x130 [bcache]
[  839.113179]  [<ffffffffc03b0ed6>] bch_uuid_write+0x16/0x40 [bcache]
[  839.113189]  [<ffffffffc03b1ad5>] bch_cached_dev_attach+0xf5/0x490 
[bcache]
[  839.113199]  [<ffffffffc03af5ad>] ? __write_super+0x13d/0x170 [bcache]
[  839.113210]  [<ffffffffc03b0eb0>] ? bcache_write_super+0x190/0x1a0 
[bcache]
[  839.113225]  [<ffffffffc03b2958>] run_cache_set+0x5e8/0x8f0 [bcache]
[  839.113236]  [<ffffffffc03b3f62>] register_bcache+0xdc2/0x1140 [bcache]
[  839.113242]  [<ffffffff813fcd2f>] kobj_attr_store+0xf/0x20
[  839.113247]  [<ffffffff81290f27>] sysfs_kf_write+0x37/0x40
[  839.113250]  [<ffffffff8129030d>] kernfs_fop_write+0x11d/0x170
[  839.113255]  [<ffffffff8120f888>] __vfs_write+0x18/0x40
[  839.113258]  [<ffffffff81210219>] vfs_write+0xa9/0x1a0
[  839.113261]  [<ffffffff81210ed5>] SyS_write+0x55/0xc0
[  839.113264]  [<ffffffff818437f2>] entry_SYSCALL_64_fastpath+0x16/0x71

No /dev/bcache* devices appear and whole system switches into strange 
state, for example it can not reboot gracefuly - it freezes.
My data storage configuration is:
     /dev/md2 as caching device, it is mdadm raid1 on two 64GiB 
partitions on two 128Gb SSD's.
     /dev/md0 as primary storage (mdadm raid5), splitted to 55 100Gib 
partitions and remainder as 56 partition, that gives /dev/md0p<1-56> 
devices.
     /dev/md0p* used as backing devices and produces /dev/bcache<0-55> 
cached devices.
     /dev/bcache* used as pv's for lvm.

Two days ago i experimented with remote lvm volumes creation/deletion 
using ssh commands, and something hanged. System could not reboot 
gracefuly, and later was reset hardly. After that it refuses to boot.
bcache-super-show on cache device and all backing devices says that 
everything is fine.
54 backing devices show:
     dev.data.cache_mode    1 [writeback]
     dev.data.cache_state    1 [clean]
     cset.uuid        d93ae507-b4bb-48ef-8d64-fa9329a08a39
One backing device (md0p3) show:
     dev.data.cache_mode    1 [writeback]
     dev.data.cache_state    1 [dirty]
     cset.uuid        d93ae507-b4bb-48ef-8d64-fa9329a08a39
And one strange device (md0p2) show:
     dev.data.cache_mode    1 [writeback]
     dev.data.cache_state    0 [detached]
     cset.uuid        9a6aeb43-5f33-45ca-a1b0-a1277e3e5c44

Is it possible that device can be detached in writeback mode with 
strange cset.uuid?
After that i copied images of cache device and 2 backing devices (with 
dd) as examples for experiments to recovery. But i can't do anything - 
when caching and backing devices meet each other during register, no 
matter in which order, something bad happens inside the kernel, 
/dev/bcache* devices do not appear and commands like 'cat 
/sys/block/md0p1/bcache/running' hangs infinitely.
Is it possible to recover data in this situation?
