From: Vivek Dasmohapatra <vivek@collabora.co.uk>
Subject: bcache deadlock with /dev/ramX + partition
Date: Thu, 20 Feb 2014 18:23:02 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1402201818410.14562@noise.cbg.collabora.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:43416 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaBTSXG (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 20 Feb 2014 13:23:06 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi: We've been using bcache to fashion an "overflow" ramdisc: We use
/dev/ramX as the cache, and an actual block device on spinning rust
as the backing device. This works pretty well, but we've bumped into
what appears to be a locking problem in the kernel:

When the backing device is a top level block device ( eg /dev/sdb )
everything seems to work just fine. When the backing device is a 
partition ( eg /dev/sda11 ) processes seem to end up in the D state
when they fsync.

Under kernel 3.11.2 this can be triggered with a simple fsync. Under 
kernels 3.12.9, 3.13 and 3.13 running with the nosmp command line
argument it is slightly harder to provoke ( a simple fsync won't always
trigger it but our chroot install script triggers it every time ).

Further investigation hinted at this being a memory alignment problem: 
We haven't confirmed it yet, but certain offsets for partitions don't 
trigger the deadlock:

[ In all cases it's an msdos partition table, the device is bcache0 and is
   mounted under /srv which happens to be on sda10. The cache device is
   always /dev/ram0 ]:

Deadlocking configurations:

    backing: sda11;  default offset from sda (NOT a multiple of 4 KiB)
    backing: sdb1;   default offset from sdb (!= 4 KiB)
    backing: sda11;  offset from sda is:
                     - a multiple of 4  KiB
                     - a multiple of 4  MiB
                     - a multplie of 16 MiB

Non-deadlocking configurations:

    backing: sdb
    backing: sdb1;   offset from start of sdb is 4096 B

So, to sum up: a top level block device as a backing device never
seems to deadlock, some offsets for some partitions (ok, PAGE_SIZE
alignment for sdb1) _also_ do not deadlock. All other cases of
use of a partition have deadlocked so far.

I'm currently testiung under 3.12.9 and get the following trace from the
deadlocked process:

[82440.244111] INFO: task dpkg:14059 blocked for more than 120 seconds.
[82440.244141]       Not tainted 3.12-0.bpo.1-amd64 #1
[82440.244153] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82440.244167] dpkg            D ffff88021fc14300     0 14059  14056 0x00000000
[82440.244173]  ffff8800c0edd800 0000000000000086 0000000000000088 ffffffff81813480
[82440.244177]  ffff8801d5d5bfd8 ffff8801d5d5bfd8 ffff8801d5d5bfd8 ffff8800c0edd800
[82440.244181]  0000000000000000 ffff88021fc14b40 ffff8800c0edd800 ffffffff8111f800
[82440.244185] Call Trace:
[82440.244195]  [<ffffffff8111f800>] ? __lock_page+0x70/0x70
[82440.244201]  [<ffffffff814c2797>] ? io_schedule+0x87/0xd0
[82440.244204]  [<ffffffff8111f809>] ? sleep_on_page+0x9/0x10
[82440.244208]  [<ffffffff814c00c2>] ? __wait_on_bit+0x52/0x80
[82440.244212]  [<ffffffff8111f943>] ? wait_on_page_bit+0x73/0x80
[82440.244217]  [<ffffffff81082d80>] ? wake_atomic_t_function+0x30/0x30
[82440.244220]  [<ffffffff8111fa46>] ? filemap_fdatawait_range+0xf6/0x170
[82440.244225]  [<ffffffff81121058>] ? filemap_write_and_wait_range+0x48/0x90
[82440.244230]  [<ffffffff811a948d>] ? generic_file_fsync+0x2d/0xa0
[82440.244247]  [<ffffffffa0159543>] ? ext4_sync_file+0x203/0x320 [ext4]
[82440.244251]  [<ffffffff811b3298>] ? do_fsync+0x58/0x90
[82440.244255]  [<ffffffff811b362b>] ? SyS_fsync+0xb/0x20
[82440.244259]  [<ffffffff814cb7b9>] ? system_call_fastpath+0x16/0x1b

Other traces from previous tests:

3.11.2:
[501840.292105] Call Trace:
[501840.292141]  [<ffffffff8110b270>] ? wait_on_page_read+0x60/0x60
[501840.292159]  [<ffffffff814787e4>] ? io_schedule+0x94/0x120
[501840.292167]  [<ffffffff8110b275>] ? sleep_on_page+0x5/0x10
[501840.292171]  [<ffffffff81476824>] ? __wait_on_bit+0x54/0x80
[501840.292178]  [<ffffffff8110b08f>] ? wait_on_page_bit+0x7f/0x90
[501840.292194]  [<ffffffff81078c40>] ? wake_atomic_t_function+0x30/0x30
[501840.292207]  [<ffffffff811175e8>] ? pagevec_lookup_tag+0x18/0x20
[501840.292211]  [<ffffffff8110b178>] ? filemap_fdatawait_range+0xd8/0x150
[501840.292217]  [<ffffffff8110c765>] ? filemap_write_and_wait_range+0x35/0x60
[501840.292229]  [<ffffffff8118cd8b>] ? generic_file_fsync+0x1b/0x90
[501840.292259]  [<ffffffffa01750ea>] ? ext4_sync_file+0x10a/0x2e0 [ext4]
[501840.292264]  [<ffffffff8119515c>] ? do_fsync+0x4c/0x80
[501840.292267]  [<ffffffff811953d7>] ? SyS_fsync+0x7/0x10
[501840.292275]  [<ffffffff81481de9>] ? system_call_fastpath+0x16/0x1b
[501960.292133] INFO: task dpkg:17778 blocked for more than 120 seconds.

3.13:
[ 1560.256491] Call Trace:
[ 1560.256502]  [<ffffffff81120410>] ? __lock_page+0x70/0x70
[ 1560.256509]  [<ffffffff814c96d8>] ? io_schedule+0x88/0xd0
[ 1560.256513]  [<ffffffff81120419>] ? sleep_on_page+0x9/0x10
[ 1560.256517]  [<ffffffff814c9c52>] ? __wait_on_bit+0x52/0x80
[ 1560.256521]  [<ffffffff81120adb>] ? find_get_pages_tag+0xcb/0x180
[ 1560.256526]  [<ffffffff81120533>] ? wait_on_page_bit+0x73/0x80
[ 1560.256531]  [<ffffffff8109c230>] ? wake_atomic_t_function+0x30/0x30
[ 1560.256535]  [<ffffffff81120610>] ? filemap_fdatawait_range+0xd0/0x150
[ 1560.256540]  [<ffffffff8112193c>] ? __filemap_fdatawrite_range+0x4c/0x60
[ 1560.256544]  [<ffffffff81121997>] ? filemap_write_and_wait_range+0x47/0x90
[ 1560.256549]  [<ffffffff811abf8d>] ? generic_file_fsync+0x2d/0xa0
[ 1560.256570]  [<ffffffffa018d3e3>] ? ext4_sync_file+0x153/0x300 [ext4]
[ 1560.256576]  [<ffffffff811b5be3>] ? do_fsync+0x53/0x90
[ 1560.256580]  [<ffffffff811b5e9b>] ? SyS_fsync+0xb/0x20
[ 1560.256586]  [<ffffffff814d4279>] ? system_call_fastpath+0x16/0x1b

3.13 + nosmp:
[  240.236653]  [<ffffffff81120410>] ? __lock_page+0x70/0x70
[  240.236660]  [<ffffffff814c96d8>] ? io_schedule+0x88/0xd0
[  240.236664]  [<ffffffff81120419>] ? sleep_on_page+0x9/0x10
[  240.236668]  [<ffffffff814c9c52>] ? __wait_on_bit+0x52/0x80
[  240.236672]  [<ffffffff81120adb>] ? find_get_pages_tag+0xcb/0x180
[  240.236676]  [<ffffffff81120533>] ? wait_on_page_bit+0x73/0x80
[  240.236681]  [<ffffffff8109c230>] ? wake_atomic_t_function+0x30/0x30
[  240.236685]  [<ffffffff81120610>] ? filemap_fdatawait_range+0xd0/0x150
[  240.236691]  [<ffffffff811b602b>] ? SyS_sync_file_range+0x15b/0x1a0
[  240.236696]  [<ffffffff814d4279>] ? system_call_fastpath+0x16/0x1b
