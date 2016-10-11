From: Marcin <marcin@mejor.pl>
Subject: [bcachefs][tier]  INFO: task bch_tier_read:21414 blocked for more
 than 120 seconds.
Date: Tue, 11 Oct 2016 23:13:56 +0200
Message-ID: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:11542 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752916AbcJKVOW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 Oct 2016 17:14:22 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!

Kernel at:
commit 2677d7d38f465ca9c8c33619a46bf4fe2852c39d
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Mon Oct 10 12:10:48 2016 -0800

Freshly formated two tiered filesystem:
# bcache format --force --tier 0 /dev/sde1 --tier 1 /dev/sdd1 
--btree_node=262144
External UUID:                  f213abd2-2517-4723-a82f-cffed89094f6
Internal UUID:                  b6b5409e-e198-43a6-8e2a-49f4ba8c714b
Label:
Version:                        6
Block_size:                     512
Btree node size:                256.0K
Error action:                   readonly
Clean:                          0
Metadata replicas:              have 1, want 1
Data replicas:                  have 1, want 1
Metadata checksum type:         crc32c
Data checksum type:             crc32c
Compression type:               none
String hash type:               siphash
32 bit inodes:                  0
GC reserve percentage:          0%
Root reserve percentage:        0%
Devices:                        2

Device 0:
   UUID:                         29916bec-62ce-4d1e-bf3f-d2b72b1e68b2
   bucket_size:                  128.0K
   first_bucket:                 8
   nbuckets:                     81920
   Last mount:                   (never)
   State:                        active
   Tier:                         0
   Has metadata:                 0
   Has data:                     0
   Replacement policy:           lru
   Discard:                      0

Device 1:
   UUID:                         84a22c92-c386-42a7-a98d-a4f00e916527
   bucket_size:                  256.0K
   first_bucket:                 4
   nbuckets:                     5723193
   Last mount:                   (never)
   State:                        active
   Tier:                         1
[I've got no more in tmux history]


While I was copying many small files using mc I got:
[ 6019.040067] INFO: task bch_tier_read:21414 blocked for more than 120 
seconds.
[ 6019.040071]       Tainted: G        W       4.8.0+ #1
[ 6019.040072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6019.040073] bch_tier_read   D ffff880003a7bbc0     0 21414      2 
0x00000000
[ 6019.040079]  ffff880003a7bbc0 ffff880036949a80 ffff880000f64f80 
ffff880003a7bc98
[ 6019.040082]  ffff880003a7c000 ffff880003a7bd08 ffff880003a7bcf0 
ffff880003a7bc00
[ 6019.040085]  0000000000000001 ffff880003a7bbd8 ffffffff81473730 
ffff880003a7bc98
[ 6019.040089] Call Trace:
[ 6019.040096]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6019.040128]  [<ffffffffa02c7798>] bch_move_ctxt_wait+0x88/0xb0 
[bcache]
[ 6019.040133]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
[ 6019.040152]  [<ffffffffa02d5b53>] read_tiering+0x143/0x4c0 [bcache]
[ 6019.040155]  [<ffffffff814732ad>] ? __schedule+0x2cd/0x720
[ 6019.040172]  [<ffffffffa02a959a>] ? 
bch_bucket_stats_read_cache+0xda/0x150 [bcache]
[ 6019.040191]  [<ffffffffa02d6117>] bch_tiering_thread+0x247/0x250 
[bcache]
[ 6019.040210]  [<ffffffffa02d5ed0>] ? read_tiering+0x4c0/0x4c0 [bcache]
[ 6019.040213]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[ 6019.040216]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[ 6019.040219]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[ 6019.040221] INFO: task mc:21426 blocked for more than 120 seconds.
[ 6019.040222]       Tainted: G        W       4.8.0+ #1
[ 6019.040223] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6019.040224] mc              D ffff88001cd53810     0 21426   2301 
0x00000000
[ 6019.040227]  ffff88001cd53810 ffffffff8180b4c0 ffff880000f63500 
ffff880005cc4118
[ 6019.040231]  ffff88001cd54000 ffff8800370e3c00 ffff880000fc0000 
00000557e2c862eb
[ 6019.040234]  ffff88001cd538a8 ffff88001cd53828 ffffffff81473730 
ffff880000f63500
[ 6019.040237] Call Trace:
[ 6019.040239]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6019.040258]  [<ffffffffa02deab5>] __closure_sync+0x55/0x5a0 [bcache]
[ 6019.040273]  [<ffffffffa02a1cc1>] bch_btree_node_read+0x141/0x2d0 
[bcache]
[ 6019.040290]  [<ffffffffa02ab0a0>] ? bch_io_clock_init+0x90/0x90 
[bcache]
[ 6019.040306]  [<ffffffffa029d2b6>] ? mca_alloc+0x106/0x420 [bcache]
[ 6019.040321]  [<ffffffffa029d676>] bch_btree_node_fill+0xa6/0x1c0 
[bcache]
[ 6019.040337]  [<ffffffffa029d88a>] bch_btree_node_get+0xfa/0x3d0 
[bcache]
[ 6019.040352]  [<ffffffffa02a25d4>] 
btree_iter_down.constprop.17+0xf4/0x200 [bcache]
[ 6019.040369]  [<ffffffffa02a61fd>] ? 
bch_btree_bset_insert_key+0xed/0x160 [bcache]
[ 6019.040385]  [<ffffffffa02a2f1f>] 
__bch_btree_iter_traverse+0x1af/0x5b0 [bcache]
[ 6019.040401]  [<ffffffffa02a4028>] 
bch_btree_iter_peek_with_holes+0x38/0x290 [bcache]
[ 6019.040419]  [<ffffffffa02b6f02>] __bch_write_inode+0x92/0x2b0 
[bcache]
[ 6019.040422]  [<ffffffff811565f1>] ? __kmalloc+0x121/0x1a0
[ 6019.040440]  [<ffffffffa02acd67>] ? dirent_create_key+0x37/0xc0 
[bcache]
[ 6019.040443]  [<ffffffff81189659>] ? __mark_inode_dirty+0x2e9/0x390
[ 6019.040446]  [<ffffffff81176d7f>] ? __d_instantiate+0x2f/0xe0
[ 6019.040464]  [<ffffffffa02b7525>] bch_inc_nlink+0x35/0x50 [bcache]
[ 6019.040481]  [<ffffffffa02b7576>] bch_mkdir+0x36/0x40 [bcache]
[ 6019.040484]  [<ffffffff8116cfc8>] vfs_mkdir+0xc8/0x120
[ 6019.040486]  [<ffffffff81170dd6>] SyS_mkdir+0x66/0xc0
[ 6019.040488]  [<ffffffff814777df>] entry_SYSCALL_64_fastpath+0x17/0x93
[ 6019.040494] INFO: task kworker/1:0:17657 blocked for more than 120 
seconds.
[ 6019.040496]       Tainted: G        W       4.8.0+ #1
[ 6019.040496] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6019.040497] kworker/1:0     D ffff88000aa87cc8     0 17657      2 
0x00000000
[ 6019.040516] Workqueue: events_freezable btree_node_write_work 
[bcache]
[ 6019.040518]  ffff88000aa87cc8 ffff88003e144f80 ffff880000f60000 
ffff88003e023000
[ 6019.040521]  ffff88000aa88000 ffff880019e43218 ffff880000f60000 
0000000000000040
[ 6019.040524]  ffff880019e43230 ffff88000aa87ce0 ffffffff81473730 
7fffffffffffffff
[ 6019.040527] Call Trace:
[ 6019.040530]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6019.040532]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
[ 6019.040550]  [<ffffffffa02cafe0>] ? six_lock_type+0x60/0x340 [bcache]
[ 6019.040552]  [<ffffffff814752df>] __down+0x5f/0xa0
[ 6019.040554]  [<ffffffff8108bd9c>] down+0x3c/0x50
[ 6019.040570]  [<ffffffffa02a1fb5>] __bch_btree_node_write+0x25/0xa0 
[bcache]
[ 6019.040585]  [<ffffffffa02a2066>] 
bch_btree_node_write_dirty+0x36/0x50 [bcache]
[ 6019.040601]  [<ffffffffa02a2142>] btree_node_write_work+0x12/0x20 
[bcache]
[ 6019.040603]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
[ 6019.040605]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
[ 6019.040607]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6019.040609]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6019.040612]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[ 6019.040614]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[ 6019.040617]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[ 6028.003562] hpsa 0000:01:00.0: scsi 10:0:0:0: added RAID              
HP       P400             controller SSDSmartPathCap- En- Exp=1
[ 6028.120251] hpsa 0000:01:00.0: addition failed -19, device not added.
[ 6058.723545] hpsa 0000:01:00.0: scsi 10:0:0:0: added RAID              
HP       P400             controller SSDSmartPathCap- En- Exp=1
[ 6058.840113] hpsa 0000:01:00.0: addition failed -19, device not added.
[ 6089.443513] hpsa 0000:01:00.0: scsi 10:0:0:0: added RAID              
HP       P400             controller SSDSmartPathCap- En- Exp=1
[ 6089.560195] hpsa 0000:01:00.0: addition failed -19, device not added.
[ 6120.163498] hpsa 0000:01:00.0: scsi 10:0:0:0: added RAID              
HP       P400             controller SSDSmartPathCap- En- Exp=1
[ 6120.280129] hpsa 0000:01:00.0: addition failed -19, device not added.
[ 6141.920058] INFO: task bch_tier_read:21414 blocked for more than 120 
seconds.
[ 6141.920062]       Tainted: G        W       4.8.0+ #1
[ 6141.920063] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6141.920064] bch_tier_read   D ffff880003a7bbc0     0 21414      2 
0x00000000
[ 6141.920070]  ffff880003a7bbc0 ffff880036949a80 ffff880000f64f80 
ffff880003a7bc98
[ 6141.920073]  ffff880003a7c000 ffff880003a7bd08 ffff880003a7bcf0 
ffff880003a7bc00
[ 6141.920076]  0000000000000001 ffff880003a7bbd8 ffffffff81473730 
ffff880003a7bc98
[ 6141.920080] Call Trace:
[ 6141.920088]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6141.920127]  [<ffffffffa02c7798>] bch_move_ctxt_wait+0x88/0xb0 
[bcache]
[ 6141.920132]  [<ffffffff810864c0>] ? wake_atomic_t_function+0x60/0x60
[ 6141.920151]  [<ffffffffa02d5b53>] read_tiering+0x143/0x4c0 [bcache]
[ 6141.920154]  [<ffffffff814732ad>] ? __schedule+0x2cd/0x720
[ 6141.920171]  [<ffffffffa02a959a>] ? 
bch_bucket_stats_read_cache+0xda/0x150 [bcache]
[ 6141.920190]  [<ffffffffa02d6117>] bch_tiering_thread+0x247/0x250 
[bcache]
[ 6141.920224]  [<ffffffffa02d5ed0>] ? read_tiering+0x4c0/0x4c0 [bcache]
[ 6141.920227]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[ 6141.920230]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[ 6141.920233]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[ 6141.920235] INFO: task mc:21426 blocked for more than 120 seconds.
[ 6141.920237]       Tainted: G        W       4.8.0+ #1
[ 6141.920237] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6141.920239] mc              D ffff88001cd53810     0 21426   2301 
0x00000000
[ 6141.920242]  ffff88001cd53810 ffffffff8180b4c0 ffff880000f63500 
ffff880005cc4118
[ 6141.920245]  ffff88001cd54000 ffff8800370e3c00 ffff880000fc0000 
00000557e2c862eb
[ 6141.920248]  ffff88001cd538a8 ffff88001cd53828 ffffffff81473730 
ffff880000f63500
[ 6141.920252] Call Trace:
[ 6141.920254]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6141.920272]  [<ffffffffa02deab5>] __closure_sync+0x55/0x5a0 [bcache]
[ 6141.920288]  [<ffffffffa02a1cc1>] bch_btree_node_read+0x141/0x2d0 
[bcache]
[ 6141.920305]  [<ffffffffa02ab0a0>] ? bch_io_clock_init+0x90/0x90 
[bcache]
[ 6141.920320]  [<ffffffffa029d2b6>] ? mca_alloc+0x106/0x420 [bcache]
[ 6141.920336]  [<ffffffffa029d676>] bch_btree_node_fill+0xa6/0x1c0 
[bcache]
[ 6141.920351]  [<ffffffffa029d88a>] bch_btree_node_get+0xfa/0x3d0 
[bcache]
[ 6141.920367]  [<ffffffffa02a25d4>] 
btree_iter_down.constprop.17+0xf4/0x200 [bcache]
[ 6141.920383]  [<ffffffffa02a61fd>] ? 
bch_btree_bset_insert_key+0xed/0x160 [bcache]
[ 6141.920406]  [<ffffffffa02a2f1f>] 
__bch_btree_iter_traverse+0x1af/0x5b0 [bcache]
[ 6141.920422]  [<ffffffffa02a4028>] 
bch_btree_iter_peek_with_holes+0x38/0x290 [bcache]
[ 6141.920440]  [<ffffffffa02b6f02>] __bch_write_inode+0x92/0x2b0 
[bcache]
[ 6141.920443]  [<ffffffff811565f1>] ? __kmalloc+0x121/0x1a0
[ 6141.920460]  [<ffffffffa02acd67>] ? dirent_create_key+0x37/0xc0 
[bcache]
[ 6141.920464]  [<ffffffff81189659>] ? __mark_inode_dirty+0x2e9/0x390
[ 6141.920467]  [<ffffffff81176d7f>] ? __d_instantiate+0x2f/0xe0
[ 6141.920485]  [<ffffffffa02b7525>] bch_inc_nlink+0x35/0x50 [bcache]
[ 6141.920502]  [<ffffffffa02b7576>] bch_mkdir+0x36/0x40 [bcache]
[ 6141.920505]  [<ffffffff8116cfc8>] vfs_mkdir+0xc8/0x120
[ 6141.920507]  [<ffffffff81170dd6>] SyS_mkdir+0x66/0xc0
[ 6141.920509]  [<ffffffff814777df>] entry_SYSCALL_64_fastpath+0x17/0x93
[ 6141.920513] INFO: task kworker/0:1:22843 blocked for more than 120 
seconds.
[ 6141.920514]       Tainted: G        W       4.8.0+ #1
[ 6141.920515] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6141.920516] kworker/0:1     D ffff88002afdfcc8     0 22843      2 
0x00000000
[ 6141.920535] Workqueue: events_freezable btree_node_write_work 
[bcache]
[ 6141.920537]  ffff88002afdfcc8 ffffffff8180b4c0 ffff8800369d4f80 
00000000ffffffff
[ 6141.920540]  ffff88002afe0000 ffff880014e92218 ffff8800369d4f80 
0000000000000000
[ 6141.920543]  ffff880014e92230 ffff88002afdfce0 ffffffff81473730 
7fffffffffffffff
[ 6141.920546] Call Trace:
[ 6141.920549]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6141.920551]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
[ 6141.920569]  [<ffffffffa02cafe0>] ? six_lock_type+0x60/0x340 [bcache]
[ 6141.920571]  [<ffffffff814752df>] __down+0x5f/0xa0
[ 6141.920573]  [<ffffffff8108bd9c>] down+0x3c/0x50
[ 6141.920589]  [<ffffffffa02a1fb5>] __bch_btree_node_write+0x25/0xa0 
[bcache]
[ 6141.920604]  [<ffffffffa02a2066>] 
bch_btree_node_write_dirty+0x36/0x50 [bcache]
[ 6141.920620]  [<ffffffffa02a2142>] btree_node_write_work+0x12/0x20 
[bcache]
[ 6141.920622]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
[ 6141.920624]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
[ 6141.920626]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6141.920628]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6141.920630]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[ 6141.920633]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[ 6141.920636]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[ 6141.920638] INFO: task kworker/0:0:27540 blocked for more than 120 
seconds.
[ 6141.920640]       Tainted: G        W       4.8.0+ #1
[ 6141.920641] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6141.920641] kworker/0:0     D ffff880009f8fcc8     0 27540      2 
0x00000000
[ 6141.920659] Workqueue: events_freezable btree_node_write_work 
[bcache]
[ 6141.920680]  ffff880009f8fcc8 ffff88003771cf80 ffff8800369d3500 
ffff880009f8fcd0
[ 6141.920683]  ffff880009f90000 ffff8800369fce18 ffff8800369d3500 
0000000000000000
[ 6141.920687]  ffff8800369fce30 ffff880009f8fce0 ffffffff81473730 
7fffffffffffffff
[ 6141.920690] Call Trace:
[ 6141.920692]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6141.920695]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
[ 6141.920713]  [<ffffffffa02cafe0>] ? six_lock_type+0x60/0x340 [bcache]
[ 6141.920715]  [<ffffffff814752df>] __down+0x5f/0xa0
[ 6141.920717]  [<ffffffff8108bd9c>] down+0x3c/0x50
[ 6141.920733]  [<ffffffffa02a1fb5>] __bch_btree_node_write+0x25/0xa0 
[bcache]
[ 6141.920748]  [<ffffffffa02a2066>] 
bch_btree_node_write_dirty+0x36/0x50 [bcache]
[ 6141.920764]  [<ffffffffa02a2142>] btree_node_write_work+0x12/0x20 
[bcache]
[ 6141.920766]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
[ 6141.920768]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
[ 6141.920770]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6141.920772]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[ 6141.920774]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[ 6141.920777]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[ 6141.920779] INFO: task kworker/1:2:27553 blocked for more than 120 
seconds.
[ 6141.920781]       Tainted: G        W       4.8.0+ #1
[ 6141.920781] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6141.920782] kworker/1:2     D ffff8800326cbcc8     0 27553      2 
0x00000000
[ 6141.920800] Workqueue: events_freezable btree_node_write_work 
[bcache]
[ 6141.920802]  ffff8800326cbcc8 ffff88003e123500 ffff88003e261a80 
0000000200000001
[ 6141.920805]  ffff8800326cc000 ffff880018d85618 ffff88003e261a80 
0000000000000040
[ 6141.920808]  ffff880018d85630 ffff8800326cbce0 ffffffff81473730 
7fffffffffffffff
[ 6141.920811] Call Trace:
[ 6141.920814]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6141.920816]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
[ 6141.920834]  [<ffffffffa02cafe0>] ? six_lock_type+0x60/0x340 [bcache]
[ 6141.920836]  [<ffffffff814752df>] __down+0x5f/0xa0
[ 6141.920838]  [<ffffffff8108bd9c>] down+0x3c/0x50
[ 6141.920854]  [<ffffffffa02a1fb5>] __bch_btree_node_write+0x25/0xa0 
[bcache]
[ 6141.920869]  [<ffffffffa02a2066>] 
bch_btree_node_write_dirty+0x36/0x50 [bcache]
[ 6141.920884]  [<ffffffffa02a2142>] btree_node_write_work+0x12/0x20 
[bcache]
[ 6141.920894]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
[ 6141.920896]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
[ 6141.920898]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6141.920900]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6141.920902]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[ 6141.920905]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[ 6141.920907]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[ 6141.920910] INFO: task kworker/u8:2:10367 blocked for more than 120 
seconds.
[ 6141.920911]       Tainted: G        W       4.8.0+ #1
[ 6141.920912] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6141.920913] kworker/u8:2    D ffff8800179a3798     0 10367      2 
0x00000000
[ 6141.920918] Workqueue: writeback wb_workfn (flush-bcache-1)
[ 6141.920920]  ffff8800179a3798 ffff88003e144f80 ffff88003764b500 
ffff880000fcc860
[ 6141.920924]  ffff8800179a4000 ffff8800179a37e0 0000000000000004 
0000000000000004
[ 6141.920927]  ffff880014e92050 ffff8800179a37b0 ffffffff81473730 
0000000000000002
[ 6141.920930] Call Trace:
[ 6141.920932]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6141.920950]  [<ffffffffa02cb1b2>] six_lock_type+0x232/0x340 [bcache]
[ 6141.920966]  [<ffffffffa02a27de>] btree_node_lock_write+0x8e/0xc0 
[bcache]
[ 6141.920982]  [<ffffffffa02a4ec1>] 
btree_node_lock_for_insert+0x51/0x90 [bcache]
[ 6141.920998]  [<ffffffffa02a78e0>] __bch_btree_insert_at+0x230/0x990 
[bcache]
[ 6141.921021]  [<ffffffffa02a407a>] ? 
bch_btree_iter_peek_with_holes+0x8a/0x290 [bcache]
[ 6141.921039]  [<ffffffffa02b709c>] __bch_write_inode+0x22c/0x2b0 
[bcache]
[ 6141.921058]  [<ffffffffa02b73ec>] bch_vfs_write_inode+0x3c/0x90 
[bcache]
[ 6141.921060]  [<ffffffff8118994f>] 
__writeback_single_inode+0x24f/0x320
[ 6141.921063]  [<ffffffff81189e95>] writeback_sb_inodes+0x1d5/0x490
[ 6141.921065]  [<ffffffff8118a1dd>] __writeback_inodes_wb+0x8d/0xc0
[ 6141.921067]  [<ffffffff8118a4ca>] wb_writeback+0x22a/0x2e0
[ 6141.921070]  [<ffffffff8118c508>] wb_workfn+0x2e8/0x3b0
[ 6141.921072]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
[ 6141.921074]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
[ 6141.921076]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6141.921078]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[ 6141.921081]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[ 6141.921083]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160
[ 6141.921085] INFO: task kworker/0:2:17582 blocked for more than 120 
seconds.
[ 6141.921087]       Tainted: G        W       4.8.0+ #1
[ 6141.921088] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6141.921088] kworker/0:2     D ffff880006b3fcc8     0 17582      2 
0x00000000
[ 6141.921106] Workqueue: events_freezable btree_node_write_work 
[bcache]
[ 6141.921108]  ffff880006b3fcc8 ffffffff8180b4c0 ffff88003771b500 
ffffffff8107250a
[ 6141.921111]  ffff880006b40000 ffff88003e24f618 ffff88003771b500 
0000000000000000
[ 6141.921114]  ffff88003e24f630 ffff880006b3fce0 ffffffff81473730 
7fffffffffffffff
[ 6141.921117] Call Trace:
[ 6141.921120]  [<ffffffff8107250a>] ? ttwu_do_activate+0x6a/0x80
[ 6141.921123]  [<ffffffff81473730>] schedule+0x30/0x80
[ 6141.921125]  [<ffffffff814767bd>] schedule_timeout+0x24d/0x300
[ 6141.921142]  [<ffffffffa02cafe0>] ? six_lock_type+0x60/0x340 [bcache]
[ 6141.921145]  [<ffffffff814752df>] __down+0x5f/0xa0
[ 6141.921147]  [<ffffffff8108bd9c>] down+0x3c/0x50
[ 6141.921162]  [<ffffffffa02a1fb5>] __bch_btree_node_write+0x25/0xa0 
[bcache]
[ 6141.921185]  [<ffffffffa02a2066>] 
bch_btree_node_write_dirty+0x36/0x50 [bcache]
[ 6141.921200]  [<ffffffffa02a2142>] btree_node_write_work+0x12/0x20 
[bcache]
[ 6141.921202]  [<ffffffff81064c7b>] process_one_work+0x15b/0x470
[ 6141.921204]  [<ffffffff81064fd6>] worker_thread+0x46/0x4e0
[ 6141.921206]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6141.921208]  [<ffffffff81064f90>] ? process_one_work+0x470/0x470
[ 6141.921210]  [<ffffffff81069f84>] kthread+0xc4/0xe0
[ 6141.921213]  [<ffffffff814779ff>] ret_from_fork+0x1f/0x40
[ 6141.921215]  [<ffffffff81069ec0>] ? kthread_worker_fn+0x160/0x160



I didn't try to reproduce it.
Marcin
