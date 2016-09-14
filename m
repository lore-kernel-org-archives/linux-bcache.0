From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: [bcachefs][Resend] Can't mount filesystem formated with
 --btree_node=262144
Date: Wed, 14 Sep 2016 09:29:48 +0200
Message-ID: <74ea0537-c1ea-9704-c9e5-1271dd5a2d82@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:28072 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753254AbcINHah (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Sep 2016 03:30:37 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

[Resend because mail with 100kB attachment was probably redirected to
Dave Null by mailinglist MTA]
Hi again,
Shortly:
fresh kernel with last tier fixes.
# bcache format --force --tier 0 /dev/sde1 --tier 1 /dev/sdd1
--btree_node=262144
UUID:                   b968d0b6-d024-4371-be9c-1b0ef9015b89
Set UUID:               48c3f74a-b0ca-4fdc-b7eb-00f4def3ffeb
version:                6
nbuckets:               81920
block_size:             1
bucket_size:            256
nr_in_set:              2
nr_this_dev:            0
first_bucket:           8
UUID:                   7262354d-1cfc-4994-b3ca-e855ef25f6f2
Set UUID:               48c3f74a-b0ca-4fdc-b7eb-00f4def3ffeb
version:                6
nbuckets:               5723193
block_size:             1
bucket_size:            512
nr_in_set:              2
nr_this_dev:            1
first_bucket:           4

# mount -t bcache -o verbose_recovery,nofsck /dev/sde1:/dev/sdd1 /mnt/test/
... hangs forever.

dmesg:
[  600.320038] INFO: task mount:3069 blocked for more than 120 seconds.
[  600.320044]       Not tainted 4.7.0+ #12
[  600.320046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  600.320049] mount           D ffff880034a4bb50     0  3069   2231
0x00000000
[  600.320055]  ffff880034a4bb50 ffff88003e144f80 ffff8800336d0000
ffff88003cb37900
[  600.320060]  ffff880034a4c000 fffffffffffffff5 ffff880034d20000
ffff880034a4bc30
[  600.320064]  0000000000000000 ffff880034a4bb68 ffffffff814622f0
ffff8800336d0000
[  600.320069] Call Trace:
[  600.320077]  [<ffffffff814622f0>] schedule+0x30/0x80
[  600.320114]  [<ffffffffa030d325>] __closure_sync+0x55/0xd30 [bcache]
[  600.320134]  [<ffffffffa02d33d0>] bch_btree_root_alloc+0xe0/0xf0 [bcache]
[  600.320156]  [<ffffffffa02d8740>] ? bch_io_clock_init+0x90/0x90 [bcache]
[  600.320179]  [<ffffffffa02fe459>] run_cache_set+0x789/0x9c0 [bcache]
[  600.320201]  [<ffffffffa02f2de5>] ? bch_scan_keylist_init+0x95/0xa0
[bcache]
[  600.320223]  [<ffffffffa02fc95c>] ? cache_alloc+0x91c/0x930 [bcache]
[  600.320246]  [<ffffffffa02ff0b7>] bch_register_cache_set+0x277/0x2f0
[bcache]
[  600.320268]  [<ffffffffa02e3e06>] ? bch_mount+0x266/0x4c0 [bcache]
[  600.320290]  [<ffffffffa02e3e98>] bch_mount+0x2f8/0x4c0 [bcache]
[  600.320295]  [<ffffffff8116069f>] mount_fs+0xf/0x90
[  600.320299]  [<ffffffff8117a852>] vfs_kern_mount+0x62/0x100
[  600.320303]  [<ffffffff8117cb39>] do_mount+0x1e9/0xd10
[  600.320308]  [<ffffffff811551e7>] ? __kmalloc_track_caller+0x117/0x190
[  600.320311]  [<ffffffff8117d980>] SyS_mount+0x90/0xd0
[  600.320316]  [<ffffffff81465f9f>] entry_SYSCALL_64_fastpath+0x17/0x93

[...]
# echo t >/proc/sysrq-trigger

dmesg is here -> https://paste.pound-python.org/show/fMRDxddiJIWprLBguDIQ/

Marcin
