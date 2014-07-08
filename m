From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: bcache_writebac at nearly 100% CPU
Date: Tue, 08 Jul 2014 12:18:59 -0500
Message-ID: <53BC2803.2040707@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:56186 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537AbaGHSL7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 8 Jul 2014 14:11:59 -0400
Received: from [IPv6:2601:e:1200:11d0:52e5:49ff:febe:9a2b] ([IPv6:2601:e:1200:11d0:52e5:49ff:febe:9a2b])
	(authenticated bits=0)
	by mail.nuclearwinter.com (8.14.4/8.14.4) with ESMTP id s68HIsUc012369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-bcache@vger.kernel.org>; Tue, 8 Jul 2014 12:18:55 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

%CPU %MEM     TIME+ COMMAND
98.8  0.0 645:05.50 bcache_writebac
97.2  0.0 600:50.18 bcache_writebac

The machine in question is a backup server. Backups usually take
40-60min but this morning took 8.5-9 hours. I did make several changes
yesterday.

There is a single (md raid 1) cache device and I had 2 md raid6 arrays
attached. Yesterday I attached a third raid6.

Since noticing the high CPU usage (and poor IO performance) I attempted
to detach each of the three backing devices with the idea that I would
rebuild the cache set. One of the backing devices did detach but two
have not. One of the two remaining devices has 1GB of dirty data and the
other has 696KB.

I had been running kernel 3.14.9-200.fc20.x86_64 but once this high load
situation happened I switched to 3.15.3-200.fc20.x86_64.

When I reboot the two bcache_writebac processes start out immediately at
high load.

/sys/block/md[13]/bcache/writeback_percent start out at 10%.

There is no IO other than to the root fs which is on a separate raid1.

==> /sys/block/md1/bcache/writeback_rate_debug <==
rate:           512/sec
dirty:          1.1G
target:         15.5G
proportional:   -13.7M
derivative:     0
change:         -13.7M/sec
next io:        -62ms

==> /sys/block/md3/bcache/writeback_rate_debug <==
rate:           512/sec
dirty:          696k
target:         4.4G
proportional:   -4.2M
derivative:     0
change:         -4.2M/sec
next io:        0ms

After switching writeback_percent to 0%, there is still no IO and...

==> /sys/block/md1/bcache/writeback_rate_debug <==
rate:           512/sec
dirty:          1.1G
target:         15.5G
proportional:   -13.7M
derivative:     0
change:         -13.7M/sec
next io:        -50ms

==> /sys/block/md3/bcache/writeback_rate_debug <==
rate:           512/sec
dirty:          696k
target:         4.4G
proportional:   -4.2M
derivative:     0
change:         -4.2M/sec
next io:        0ms

... and switching back to 10%, still no IO and...

==> /sys/block/md1/bcache/writeback_rate_debug <==
rate:           512/sec
dirty:          1.1G
target:         15.5G
proportional:   -13.7M
derivative:     0
change:         -13.7M/sec
next io:        -67ms

==> /sys/block/md3/bcache/writeback_rate_debug <==
rate:           512/sec
dirty:          696k
target:         4.4G
proportional:   -4.2M
derivative:     0
change:         -4.2M/sec
next io:        0ms

The only log messages for bcache are:

[   23.728302] bcache: register_bdev() registered backing device md2
[   23.750124] bcache: register_bdev() registered backing device md1
[   23.776249] bcache: register_bdev() registered backing device md3
[   25.414604] bcache: bch_journal_replay() journal replay done, 66 keys
in 10 entries, seq 26249932
[   25.534038] bcache: bch_cached_dev_attach() Caching md3 as bcache2 on
set 66c1a39b-5898-4aae-abe4-6ab609c18155
[   25.682785] bcache: bch_cached_dev_attach() Caching md1 as bcache1 on
set 66c1a39b-5898-4aae-abe4-6ab609c18155
[   25.695961] bcache: register_cache() registered cache device dm-2

Status (shortly after reboot):

# bcache-status -s
--- bcache ---
UUID                        66c1a39b-5898-4aae-abe4-6ab609c18155
Block Size                  4.00 KiB
Bucket Size                 2.0 MiB
Congested?                  False
Read Congestion             2.0ms
Write Congestion            20.0ms
Total Cache Size            200 GiB
Total Cache Used            148 GiB     (74%)
Total Cache Unused          52 GiB      (26%)
Evictable Cache             200 GiB     (100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  6174        (94%)
Total Misses                380
Total Bypass Hits           0
Total Bypass Misses         0
Total Bypassed              0 B
--- Backing Device ---
  Device File               /dev/md1 (9:1)
  bcache Device File        /dev/bcache1 (252:1)
  Size                      13 TiB
  Cache Mode                writethrough [writeback] writearound none
  Readahead                 0
  Sequential Cutoff         16.0 MiB
  Merge sequential?         False
  State                     dirty
  Writeback?                True
  Dirty Data                1 GiB
  Total Hits                6108        (99%)
  Total Misses              12
  Total Bypass Hits         0
  Total Bypass Misses       0
  Total Bypassed            0 B
--- Backing Device ---
  Device File               /dev/md3 (9:3)
  bcache Device File        /dev/bcache2 (252:2)
  Size                      4 TiB
  Cache Mode                writethrough [writeback] writearound none
  Readahead                 0
  Sequential Cutoff         16.0 MiB
  Merge sequential?         False
  State                     dirty
  Writeback?                True
  Dirty Data                696.00 KiB
  Total Hits                66  (15%)
  Total Misses              368
  Total Bypass Hits         0
  Total Bypass Misses       0
  Total Bypassed            0 B
--- Cache Device ---
  Device File               /dev/dm-2 (253:2)
  Size                      200 GiB
  Block Size                4.00 KiB
  Bucket Size               2.0 MiB
  Replacement Policy        [lru] fifo random
  Discard?                  False
  I/O Errors                0
  Metadata Written          2.0 MiB
  Data Written              1.4 MiB
  Buckets                   102400
  Cache Used                148 GiB     (74%)
  Cache Unused              52 GiB      (26%)

I did find the following in the logs from a day prior to when I did the
work. The cacti graphs show high load at that time but a raid-check
started shortly before this which usually causes this kind of load. So,
the problem may have been occurring since the 6th without being noticing.

Jul  6 00:26:32 mcp kernel: WARNING: CPU: 1 PID: 15568 at
drivers/md/bcache/btree.c:1979 btree_split+0x5bb/0x630 [bcache]()
Jul  6 00:26:32 mcp kernel: bcache: btree split failed
Jul  6 00:26:32 mcp kernel: Modules linked in:
Jul  6 00:26:32 mcp kernel: [30957.447979] bcache: btree split failed
Jul  6 00:26:32 mcp kernel: [30957.451654] Modules linked in:
binfmt_misc cfg80211 rfkill it87 hwmon_vid nf_conntrack_ipv4 ip6t_REJECT
nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ip
v6 xt_conntrack ip6table_filter nf_conntrack ip6_tables raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx kvm microcode
edac_core serio_raw sp5100_tco edac_mce_amd
 k10temp snd_hda_codec_realtek i2c_piix4 snd_hda_codec_generic
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer snd r8169 soundcore
 mii shpchp wmi acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs
xor raid6_pq raid1 radeon i2c_algo_bit firewire_ohci drm_kms_helper
firewire_core ttm crc_itu_t mvsas drm l
ibsas scsi_transport_sas i2c_core cpufreq_stats bcache
Jul  6 00:26:32 mcp kernel: [30957.528183] CPU: 1 PID: 15568 Comm:
kworker/1:2 Not tainted 3.14.8-200.fc20.x86_64 #1
Jul  6 00:26:32 mcp kernel: [30957.537550] Hardware name: Gigabyte
Technology Co., Ltd. GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS F9 09/09/2011
Jul  6 00:26:32 mcp kernel: binfmt_misc cfg80211 rfkill it87 hwmon_vid
nf_conntrack_ipv4 ip6t_REJECT nf_defrag_ipv4 nf_conntrack_ipv6
nf_defrag_ipv6 xt_conntrack ip6table_filter nf
_conntrack ip6_tables raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx kvm microcode edac_core serio_raw sp5100_tco
edac_mce_amd k10temp snd_hda_codec_realtek i2c
_piix4 snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel
snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd
r8169 soundcore mii shpchp wmi acpi_cpufreq nfsd
auth_rpcgss nfs_acl lockd sunrpc btrfs xor raid6_pq raid1 radeon
i2c_algo_bit firewire_ohci drm_kms_helper firewire_core ttm crc_itu_t
mvsas drm libsas scsi_transport_sas i2c_core
cpufreq_stats bcache
Jul  6 00:26:32 mcp kernel: [30957.548771] Workqueue: events
write_dirty_finish [bcache]
Jul  6 00:26:32 mcp kernel: CPU: 1 PID: 15568 Comm: kworker/1:2 Not
tainted 3.14.8-200.fc20.x86_64 #1
Jul  6 00:26:32 mcp kernel: [30957.555773]  0000000000000000
00000000dea1a02f ffff880007ffd8b0 ffffffff816f0502
Jul  6 00:26:32 mcp kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS F9 09/09/2011
Jul  6 00:26:32 mcp kernel: [30957.564855]  ffff880007ffd8f8
ffff880007ffd8e8 ffffffff8108a1cd ffff88040e6b7800
Jul  6 00:26:32 mcp kernel: Workqueue: events write_dirty_finish [bcache]
Jul  6 00:26:32 mcp kernel: 0000000000000000 00000000dea1a02f
ffff880007ffd8b0 ffffffff816f0502
Jul  6 00:26:32 mcp kernel: ffff880007ffd8f8 ffff880007ffd8e8
ffffffff8108a1cd ffff88040e6b7800
Jul  6 00:26:32 mcp kernel: [30957.573943]  ffffffffffffffe4
ffff880007ffdd58 ffff880007ffd980 0000000000000000
Jul  6 00:26:32 mcp kernel: [30957.583045] Call Trace:
Jul  6 00:26:32 mcp kernel: [30957.587031]  [<ffffffff816f0502>]
dump_stack+0x45/0x56
Jul  6 00:26:32 mcp kernel: ffffffffffffffe4 ffff880007ffdd58
ffff880007ffd980 0000000000000000
Jul  6 00:26:32 mcp kernel: Call Trace:
Jul  6 00:26:32 mcp kernel: [<ffffffff816f0502>] dump_stack+0x45/0x56
Jul  6 00:26:32 mcp kernel: [30957.593729]  [<ffffffff8108a1cd>]
warn_slowpath_common+0x7d/0xa0
Jul  6 00:26:32 mcp kernel: [<ffffffff8108a1cd>]
warn_slowpath_common+0x7d/0xa0
Jul  6 00:26:32 mcp kernel: [<ffffffff8108a24c>] warn_slowpath_fmt+0x5c/0x80
Jul  6 00:26:32 mcp kernel: [30957.601287]  [<ffffffff8108a24c>]
warn_slowpath_fmt+0x5c/0x80
Jul  6 00:26:32 mcp kernel: [30957.608568]  [<ffffffffa000965b>]
btree_split+0x5bb/0x630 [bcache]
Jul  6 00:26:32 mcp kernel: [<ffffffffa000965b>] btree_split+0x5bb/0x630
[bcache]
Jul  6 00:26:32 mcp kernel: [30957.616248]  [<ffffffff816f3d22>] ?
__schedule+0x2e2/0x740
Jul  6 00:26:32 mcp kernel: [<ffffffff816f3d22>] ? __schedule+0x2e2/0x740
Jul  6 00:26:32 mcp kernel: [30957.623240]  [<ffffffff8136decd>] ?
list_del+0xd/0x30
Jul  6 00:26:32 mcp kernel: [<ffffffff8136decd>] ? list_del+0xd/0x30
Jul  6 00:26:32 mcp kernel: [30957.629792]  [<ffffffffa0009771>]
bch_btree_insert_node+0xa1/0x2c0 [bcache]
Jul  6 00:26:32 mcp kernel: [30957.638293]  [<ffffffffa000a724>]
btree_insert_fn+0x24/0x50 [bcache]
Jul  6 00:26:32 mcp kernel: [<ffffffffa0009771>]
bch_btree_insert_node+0xa1/0x2c0 [bcache]
Jul  6 00:26:32 mcp kernel: [<ffffffffa000a724>]
btree_insert_fn+0x24/0x50 [bcache]
Jul  6 00:26:32 mcp kernel: [<ffffffffa0007861>]
bch_btree_map_nodes_recurse+0x51/0x180 [bcache]
Jul  6 00:26:32 mcp kernel: [30957.646175]  [<ffffffffa0007861>]
bch_btree_map_nodes_recurse+0x51/0x180 [bcache]
Jul  6 00:26:32 mcp kernel: [30957.655171]  [<ffffffffa000a700>] ?
bch_btree_insert_check_key+0x1b0/0x1b0 [bcache]
Jul  6 00:26:32 mcp kernel: [<ffffffffa000a700>] ?
bch_btree_insert_check_key+0x1b0/0x1b0 [bcache]
Jul  6 00:26:32 mcp kernel: [<ffffffffa000da62>] ?
bch_btree_ptr_invalid+0x12/0x20 [bcache]
Jul  6 00:26:32 mcp kernel: [30957.664290]  [<ffffffffa000da62>] ?
bch_btree_ptr_invalid+0x12/0x20 [bcache]
Jul  6 00:26:32 mcp kernel: [30957.672814]  [<ffffffffa000c48d>] ?
bch_btree_ptr_bad+0x4d/0x110 [bcache]
Jul  6 00:26:32 mcp kernel: [<ffffffffa000c48d>] ?
bch_btree_ptr_bad+0x4d/0x110 [bcache]
Jul  6 00:26:32 mcp kernel: [30957.681045]  [<ffffffff816f6592>] ?
down_write+0x12/0x30
Jul  6 00:26:32 mcp kernel: [<ffffffff816f6592>] ? down_write+0x12/0x30
Jul  6 00:26:32 mcp kernel: [30957.731889]  [<ffffffff810b2d66>] ?
srcu_notifier_call_chain+0x16/0x20
Jul  6 00:26:32 mcp kernel: [<ffffffff810b2d66>] ?
srcu_notifier_call_chain+0x16/0x20
Jul  6 00:26:32 mcp kernel: [<ffffffffa000b1e1>]
bch_btree_insert+0xf1/0x170 [bcache]
Jul  6 00:26:32 mcp kernel: [30957.739905]  [<ffffffffa000b1e1>]
bch_btree_insert+0xf1/0x170 [bcache]
Jul  6 00:26:32 mcp kernel: [30957.747908]  [<ffffffff810d2180>] ?
abort_exclusive_wait+0xb0/0xb0
Jul  6 00:26:32 mcp kernel: [<ffffffff810d2180>] ?
abort_exclusive_wait+0xb0/0xb0
Jul  6 00:26:33 mcp kernel: [<ffffffffa0021d66>]
write_dirty_finish+0x1f6/0x260 [bcache]
Jul  6 00:26:33 mcp kernel: [30957.755602]  [<ffffffffa0021d66>]
write_dirty_finish+0x1f6/0x260 [bcache]
Jul  6 00:26:33 mcp kernel: [30957.763908]  [<ffffffff810c3e76>] ?
__dequeue_entity+0x26/0x40
Jul  6 00:26:33 mcp kernel: [<ffffffff810c3e76>] ?
__dequeue_entity+0x26/0x40
Jul  6 00:26:33 mcp kernel: [30957.771228]  [<ffffffff810135d6>] ?
__switch_to+0x126/0x4c0
Jul  6 00:26:33 mcp kernel: [<ffffffff810135d6>] ? __switch_to+0x126/0x4c0
Jul  6 00:26:33 mcp kernel: [30957.778283]  [<ffffffff810a68e6>]
process_one_work+0x176/0x430
Jul  6 00:26:33 mcp kernel: [<ffffffff810a68e6>]
process_one_work+0x176/0x430
Jul  6 00:26:33 mcp kernel: [30957.785598]  [<ffffffff810a757b>]
worker_thread+0x11b/0x3a0
Jul  6 00:26:33 mcp kernel: [<ffffffff810a757b>] worker_thread+0x11b/0x3a0
Jul  6 00:26:33 mcp kernel: [30957.792656]  [<ffffffff810a7460>] ?
rescuer_thread+0x3b0/0x3b0
Jul  6 00:26:33 mcp kernel: [<ffffffff810a7460>] ?
rescuer_thread+0x3b0/0x3b0
Jul  6 00:26:33 mcp kernel: [30957.799982]  [<ffffffff810ae2d1>]
kthread+0xe1/0x100
Jul  6 00:26:33 mcp kernel: [<ffffffff810ae2d1>] kthread+0xe1/0x100
Jul  6 00:26:33 mcp kernel: [30957.806427]  [<ffffffff810ae1f0>] ?
insert_kthread_work+0x40/0x40
Jul  6 00:26:33 mcp kernel: [<ffffffff810ae1f0>] ?
insert_kthread_work+0x40/0x40
Jul  6 00:26:33 mcp kernel: [30957.813995]  [<ffffffff8170083c>]
ret_from_fork+0x7c/0xb0
Jul  6 00:26:33 mcp kernel: [<ffffffff8170083c>] ret_from_fork+0x7c/0xb0
Jul  6 00:26:33 mcp kernel: [30957.820844]  [<ffffffff810ae1f0>] ?
insert_kthread_work+0x40/0x40
Jul  6 00:26:33 mcp kernel: [<ffffffff810ae1f0>] ?
insert_kthread_work+0x40/0x40
Jul  6 00:26:33 mcp kernel: [30957.828357] ---[ end trace
874ec8b4276a8f33 ]---
Jul  6 00:26:33 mcp kernel: ---[ end trace 874ec8b4276a8f33 ]---
Jul  6 00:26:33 mcp kernel: [30957.834379] bcache: bch_btree_insert()
error -12
Jul  6 00:26:33 mcp kernel: bcache: bch_btree_insert() error -12

--Larkin
