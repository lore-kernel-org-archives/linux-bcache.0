From: marcin@mejor.pl
Subject: How to create becachefs and mount? (and one issue with bcache tools
 help)
Date: Sat, 06 Aug 2016 15:28:41 +0200
Message-ID: <9c46c1a1e159e09d7218d88ab8434dc6@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:10032 "EHLO jowisz.mejor.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbcHFVCX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sat, 6 Aug 2016 17:02:23 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi again!
I've got brain fade at this moment. I'd like to create and mount 
bcachefs and I can't do that.
bcache-tools are on "dev" branch at 
f2e0c203096ddba72826206f51a3089092bd48dc. I try to create filesystem 
without any cache. I think that I should prepare backing device, I'm 
doing:
# ./bcache format --meta_replicas=2 --compression_type=gzip -B /dev/sdd1
UUID:                   4218cfd3-2138-4bba-af89-c783d6b4d21a
version:                1
block_size:             1
data_offset:            16

When I try to mount I'm getting in kernel.log:
bcache: bch_open_as_blockdevs() register_cache_set err attempting to 
register backing device

Hmm, let me try with "-C".
# mount /dev/sdd1 /mnt/test/

and it hanged. In kernel log I see:
[  754.888439] bcache: bch_open_as_blockdevs() register_cache_set err 
attempting to register backing device
[ 1285.990485] bcache (sdd1): initializing new filesystem
[ 1440.320042] INFO: task mount:2655 blocked for more than 120 seconds.
[ 1440.320048]       Not tainted 4.7.0+ #1
[ 1440.320050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 1440.320052] mount           D ffff880037a77b40     0  2655   2234 
0x00000000
[ 1440.320058]  ffff880037a77b40 ffffffff8180b4c0 ffff88003770b500 
ffff880037a77b30
[ 1440.320063]  ffff880037a78000 fffffffffffffff5 ffff880021310000 
ffff880037a77c20
[ 1440.320068]  0000000000000000 ffff880037a77b58 ffffffff814672a0 
ffff88003770b500
[ 1440.320072] Call Trace:
[ 1440.320081]  [<ffffffff814672a0>] schedule+0x30/0x80
[ 1440.320120]  [<ffffffffc02d5255>] __closure_sync+0x55/0xe00 [bcache]
[ 1440.320141]  [<ffffffffc029c430>] bch_btree_root_alloc+0xe0/0xf0 
[bcache]
[ 1440.320162]  [<ffffffffc02a1620>] ? bch_io_clock_init+0x90/0x90 
[bcache]
[ 1440.320185]  [<ffffffffc02c68d7>] run_cache_set+0x717/0x880 [bcache]
[ 1440.320207]  [<ffffffffc02bb855>] ? bch_scan_keylist_init+0x95/0xa0 
[bcache]
[ 1440.320230]  [<ffffffffc02c4e1c>] ? cache_alloc+0x90c/0x920 [bcache]
[ 1440.320252]  [<ffffffffc02c7462>] bch_register_cache_set+0x272/0x2e0 
[bcache]
[ 1440.320274]  [<ffffffffc02aaeb5>] bch_mount+0x2c5/0x490 [bcache]
[ 1440.320280]  [<ffffffff8116336f>] mount_fs+0xf/0x90
[ 1440.320285]  [<ffffffff8117d362>] vfs_kern_mount+0x62/0x100
[ 1440.320288]  [<ffffffff8117f649>] do_mount+0x1e9/0xd10
[ 1440.320292]  [<ffffffff811598cc>] ? __kmalloc_track_caller+0x2c/0x170
[ 1440.320297]  [<ffffffff8112566d>] ? memdup_user+0x3d/0x70
[ 1440.320300]  [<ffffffff811804a0>] SyS_mount+0x90/0xd0
[ 1440.320304]  [<ffffffff8146ae9f>] entry_SYSCALL_64_fastpath+0x17/0x93
[ 1560.320042] INFO: task mount:2655 blocked for more than 120 seconds.
[ 1560.320048]       Not tainted 4.7.0+ #1
[ 1560.320050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 1560.320053] mount           D ffff880037a77b40     0  2655   2234 
0x00000000
[ 1560.320059]  ffff880037a77b40 ffffffff8180b4c0 ffff88003770b500 
ffff880037a77b30
[ 1560.320064]  ffff880037a78000 fffffffffffffff5 ffff880021310000 
ffff880037a77c20
[ 1560.320068]  0000000000000000 ffff880037a77b58 ffffffff814672a0 
ffff88003770b500
[ 1560.320072] Call Trace:
[ 1560.320081]  [<ffffffff814672a0>] schedule+0x30/0x80
[ 1560.320118]  [<ffffffffc02d5255>] __closure_sync+0x55/0xe00 [bcache]
[ 1560.320139]  [<ffffffffc029c430>] bch_btree_root_alloc+0xe0/0xf0 
[bcache]
[ 1560.320160]  [<ffffffffc02a1620>] ? bch_io_clock_init+0x90/0x90 
[bcache]
[ 1560.320183]  [<ffffffffc02c68d7>] run_cache_set+0x717/0x880 [bcache]
[ 1560.320205]  [<ffffffffc02bb855>] ? bch_scan_keylist_init+0x95/0xa0 
[bcache]
[ 1560.320228]  [<ffffffffc02c4e1c>] ? cache_alloc+0x90c/0x920 [bcache]
[ 1560.320250]  [<ffffffffc02c7462>] bch_register_cache_set+0x272/0x2e0 
[bcache]
[ 1560.320272]  [<ffffffffc02aaeb5>] bch_mount+0x2c5/0x490 [bcache]
[ 1560.320277]  [<ffffffff8116336f>] mount_fs+0xf/0x90
[ 1560.320282]  [<ffffffff8117d362>] vfs_kern_mount+0x62/0x100
[ 1560.320285]  [<ffffffff8117f649>] do_mount+0x1e9/0xd10
[ 1560.320290]  [<ffffffff811598cc>] ? __kmalloc_track_caller+0x2c/0x170
[ 1560.320294]  [<ffffffff8112566d>] ? memdup_user+0x3d/0x70
[ 1560.320297]  [<ffffffff811804a0>] SyS_mount+0x90/0xd0
[ 1560.320301]  [<ffffffff8146ae9f>] entry_SYSCALL_64_fastpath+0x17/0x93

Am I doing something wrong?
Kernel is at commit 885262cd16cc8a0c312f914e25227954cd964c8d.

Second issue is in help displayed by bcache:
# ./bcache format --help
Usage: bcache format [OPTION]... <list of devices>
Create a new bcache volume from one or more devices

Options:
   -C, --cache=dev             Format a cache device
   -B, --bdev=dev              Format a backing device
[...]
   -v, --version=#             superblock version
   -q, --quiet                 reduce output to errors only
   -v, --verbose               increase output to include informational 
messages
       --help                  display this help and exit
       --version               output version information and exit


What "-v" does? Increases verbosity or allows to set superblock version?
What "--version" does? Displays info about version of tools or allow to 
set superblock version?

Thanks,
Marcin.
