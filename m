From: kernel neophyte <neophyte.hacker001-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Re-try] Bcache crashes (Deadlocks ?) on Random Writes
Date: Wed, 14 Aug 2013 17:54:22 -0700
Message-ID: <CAFkUHxczpF2jo=v5WuqiUbznaqv6vVm9+=FQHwgVV2PWySom7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Sorry for resending, I am getting mail not delivered reply.


Hi Kent,

I am an independent researcher, researching on next generation memory.
Thanks a lot for Bcache this was badly needed in linux :-). In future
too I am willing to bet bcache is going to be an very important part
of linux.

The problem I am facing right now:

during random write, Bcache comes to a halt (Deadlock ?) and system
becomes flakey. (its impossible to kill the process and issue a
reboot).

How it is set up

Total Dram is : 192G
Free Ram available is 32G

RamDisk of 150G acting as a cache

Dram<->RamDisk<->HDD

commands used:
make-bcache -B -w 4096 /dev/sda3
make-bcache -C -w 4096 /dev/rxd1 (this is the ramdisk)

echo /dev/sda3 > /sys/fs/bcache/register
echo /dev/rxd1 > /sys/fs/bcache/register
echo 1e26e5ca-5cb9-4c5a-ad7e-3c787524a9dc > /sys/block/bcache0/bcache/attach

echo writeback > /sys/block/bcache0/bcache/cache_mode
echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
echo 0 > /sys/fs/bcache/1e26e5ca-5cb9-4c5a-ad7e-3c787524a9dc/congested_read_threshold_us
echo 0 > /sys/fs/bcache/1e26e5ca-5cb9-4c5a-ad7e-3c787524a9dc/congested_write_threshold_us

mkfs -b 4096 -t ext4 /dev/bcache0
mount /dev/bcache0 /mnt/fastcache/

iozone -s 80g -i 0 -i 1 -i 2 -r 4k -I -b
/home/neo/bcache.80g.4k.ext4.csv -f /mnt/fastcache/test1


The Kernel is 3.11.0-rc5 (custom. It includes all commits from
bcache-dev tree from bcache: Fix a dumb journal discard bug
(eeea65848d4305836b9c397169515b2ab0c2a034) till bcache: Zero less
memory (824e8155faa5afc2a4984378aeed37b343bd2876))

[ 3922.208949] bcache: register_bdev() registered backing device sda3
[ 3932.517255] bcache: run_cache_set() invalidating existing data
[ 3932.535187] bcache: register_cache() registered cache device rxd1
[ 3977.155432] bcache: bch_cached_dev_attach() Caching sda3 as bcache0
on set 92a817d6-4283-4041-9c9c-2635e0fe9253
[ 6962.658113] INFO: task kswapd0:51 blocked for more than 120 seconds.
[ 6962.658123] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6962.658129] kswapd0         D ffffffff8180fbc0     0    51      2 0x00000000
[ 6962.658137]  ffff882fa49b5b28 0000000000000046 ffff882fa49b5b68
ffffffff8108a4d9
[ 6962.658143]  ffff882f8a38c590 ffff882fa49b5fd8 ffff882fa49b5fd8
ffff882fa49b5fd8
[ 6962.658148]  ffff882fa6aa8000 ffff882f8a38c590 ffff882fa49b5b18
ffff882e4b5e0d98
[ 6962.658153] Call Trace:
[ 6962.658167]  [<ffffffff8108a4d9>] ? find_busiest_group+0x39/0x4a0
[ 6962.658176]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 6962.658182]  [<ffffffff816e2fbe>] schedule_preempt_disabled+0xe/0x10
[ 6962.658188]  [<ffffffff816e1272>] __mutex_lock_slowpath+0x112/0x1b0
[ 6962.658194]  [<ffffffff816e076a>] mutex_lock+0x2a/0x41
[ 6962.658202]  [<ffffffff8152af05>] bch_mca_shrink+0x1b5/0x2f0
[ 6962.658211]  [<ffffffff8118c972>] ? prune_super+0x162/0x1b0
[ 6962.658218]  [<ffffffff8113b474>] shrink_slab+0x154/0x300
[ 6962.658223]  [<ffffffff8108b52b>] ? idle_balance+0xeb/0x150
[ 6962.658230]  [<ffffffff8113e934>] balance_pgdat+0x494/0x5d0
[ 6962.658235]  [<ffffffff816e0193>] ? schedule_timeout+0x133/0x250
[ 6962.658240]  [<ffffffff8113ebdf>] kswapd+0x16f/0x480
[ 6962.658248]  [<ffffffff81070cf0>] ? add_wait_queue+0x60/0x60
[ 6962.658252]  [<ffffffff8113ea70>] ? balance_pgdat+0x5d0/0x5d0
[ 6962.658258]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 6962.658263]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.658271]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 6962.658276]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.658286] INFO: task bcache_writebac:5046 blocked for more than
120 seconds.
[ 6962.658290] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6962.658295] bcache_writebac D ffffffff8180fbc0     0  5046      2 0x00000000
[ 6962.658300]  ffff881955e31cd8 0000000000000046 0000000000000001
0000000000000001
[ 6962.658304]  ffff882f8a740000 ffff881955e31fd8 ffff881955e31fd8
ffff881955e31fd8
[ 6962.658309]  ffff882fa6aa9730 ffff882f8a740000 ffff882f8a740000
ffff882f8a740000
[ 6962.658314] Call Trace:
[ 6962.658320]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 6962.658326]  [<ffffffff816e3a15>] rwsem_down_write_failed+0xf5/0x1a0
[ 6962.658335]  [<ffffffff81343e43>] call_rwsem_down_write_failed+0x13/0x20
[ 6962.658340]  [<ffffffff816e16a1>] ? down_write+0x31/0x40
[ 6962.658347]  [<ffffffff81535362>] bch_writeback_thread+0x62/0x7f0
[ 6962.658353]  [<ffffffff8108b52b>] ? idle_balance+0xeb/0x150
[ 6962.658359]  [<ffffffff81535300>] ? write_dirty+0xc0/0xc0
[ 6962.658363]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 6962.658368]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.658374]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 6962.658378]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.658383] INFO: task iozone:7406 blocked for more than 120 seconds.
[ 6962.658387] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6962.658391] iozone          D 0000000000000000     0  7406   7246 0x00000000
[ 6962.658395]  ffff8809dcfbb978 0000000000000082 ffff8809dcfbb938
ffffffff8131187a
[ 6962.658400]  ffff882f8c8b4590 ffff8809dcfbbfd8 ffff8809dcfbbfd8
ffff8809dcfbbfd8
[ 6962.658405]  ffff882f8c8b1730 ffff882f8c8b4590 ffff8809dcfbb978
ffff882fbf293c28
[ 6962.658409] Call Trace:
[ 6962.658417]  [<ffffffff8131187a>] ? generic_make_request+0xca/0x100
[ 6962.658422]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 6962.658427]  [<ffffffff816e2daf>] io_schedule+0x8f/0xd0
[ 6962.658437]  [<ffffffff811c49bc>] do_blockdev_direct_IO+0x1a7c/0x1fb0
[ 6962.658448]  [<ffffffffa022ea70>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 6962.658454]  [<ffffffff811c4f45>] __blockdev_direct_IO+0x55/0x60
[ 6962.658460]  [<ffffffffa022ea70>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 6962.658466]  [<ffffffffa022f339>] ext2_direct_IO+0x79/0xe0 [ext2]
[ 6962.658471]  [<ffffffffa022ea70>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 6962.658480]  [<ffffffff81051426>] ? current_fs_time+0x16/0x60
[ 6962.658487]  [<ffffffff8112b1f6>] generic_file_direct_write+0xc6/0x180
[ 6962.658492]  [<ffffffff8112b58d>] __generic_file_aio_write+0x2dd/0x3b0
[ 6962.658497]  [<ffffffff816e0674>] ? mutex_unlock+0x14/0x20
[ 6962.658502]  [<ffffffff8112b6c9>] generic_file_aio_write+0x69/0xd0
[ 6962.658507]  [<ffffffff8118866a>] do_sync_write+0x7a/0xb0
[ 6962.658512]  [<ffffffff8118949e>] vfs_write+0xce/0x200
[ 6962.658518]  [<ffffffff811a4d60>] ? fget_light+0x70/0xd0
[ 6962.658523]  [<ffffffff811899a2>] SyS_write+0x52/0xa0
[ 6962.658529]  [<ffffffff816ec942>] system_call_fastpath+0x16/0x1b
[ 6962.658533] INFO: task kworker/u64:1:7435 blocked for more than 120 seconds.
[ 6962.658538] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6962.658542] kworker/u64:1   D ffffffff8180fbc0     0  7435      2 0x00000000
[ 6962.658554] Workqueue: writeback bdi_writeback_workfn (flush-252:0)
[ 6962.658557]  ffff8818427955a0 0000000000000046 ffff882f90c15cc0
ffff881842795548
[ 6962.658562]  ffff882f90c15cc0 ffff881842795fd8 ffff881842795fd8
ffff881842795fd8
[ 6962.658566]  ffff882fa6aaae60 ffff882f90c15cc0 ffffffff8112c705
ffff882f90c15cc0
[ 6962.658571] Call Trace:
[ 6962.658576]  [<ffffffff8112c705>] ? mempool_alloc_slab+0x15/0x20
[ 6962.658581]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 6962.658587]  [<ffffffff816e3b5d>] rwsem_down_read_failed+0x9d/0xf0
[ 6962.658592]  [<ffffffff81343e14>] call_rwsem_down_read_failed+0x14/0x30
[ 6962.658598]  [<ffffffff816e16d4>] ? down_read+0x24/0x2b
[ 6962.658602]  [<ffffffff81539932>] cached_dev_make_request+0x752/0xf00
[ 6962.658607]  [<ffffffff813115f8>] ? generic_make_request_checks+0x1e8/0x3a0
[ 6962.658612]  [<ffffffff8131187a>] generic_make_request+0xca/0x100
[ 6962.658617]  [<ffffffff81311929>] submit_bio+0x79/0x160
[ 6962.658622]  [<ffffffff811be700>] ? bio_alloc_bioset+0xa0/0x1d0
[ 6962.658627]  [<ffffffff811b8ccf>] _submit_bh+0x13f/0x200
[ 6962.658631]  [<ffffffff811b8da0>] submit_bh+0x10/0x20
[ 6962.658636]  [<ffffffff811bc6c8>] __block_write_full_page+0x1d8/0x360
[ 6962.658641]  [<ffffffff811ba3c0>] ? end_buffer_async_read+0x130/0x130
[ 6962.658645]  [<ffffffff811bfc60>] ? I_BDEV+0x10/0x10
[ 6962.658650]  [<ffffffff811bfc60>] ? I_BDEV+0x10/0x10
[ 6962.658655]  [<ffffffff811bc91a>] block_write_full_page_endio+0xca/0x100
[ 6962.658660]  [<ffffffff811bc965>] block_write_full_page+0x15/0x20
[ 6962.658665]  [<ffffffff811c0648>] blkdev_writepage+0x18/0x20
[ 6962.658673]  [<ffffffff81133da7>] __writepage+0x17/0x40
[ 6962.658678]  [<ffffffff8113427e>] write_cache_pages+0x20e/0x460
[ 6962.658686]  [<ffffffff8122a636>] ? ext4_writepages+0x416/0xc70
[ 6962.658691]  [<ffffffff81133d90>] ? set_page_dirty_lock+0x60/0x60
[ 6962.658697]  [<ffffffff8113451a>] generic_writepages+0x4a/0x70
[ 6962.658701]  [<ffffffff81135d70>] do_writepages+0x20/0x40
[ 6962.658707]  [<ffffffff811b06d5>] __writeback_single_inode+0x45/0x290
[ 6962.658712]  [<ffffffff81089fb3>] ? update_sd_lb_stats+0x123/0x610
[ 6962.658717]  [<ffffffff811b195d>] writeback_sb_inodes+0x1ad/0x3d0
[ 6962.658723]  [<ffffffff811b1c1e>] __writeback_inodes_wb+0x9e/0xd0
[ 6962.658728]  [<ffffffff811b1ecb>] wb_writeback+0x27b/0x320
[ 6962.658733]  [<ffffffff811a3082>] ? get_nr_dirty_inodes+0x52/0x80
[ 6962.658738]  [<ffffffff811b200f>] wb_check_old_data_flush+0x9f/0xb0
[ 6962.658744]  [<ffffffff811b384c>] bdi_writeback_workfn+0x1bc/0x3e0
[ 6962.658752]  [<ffffffff810681e2>] ? __queue_delayed_work+0x92/0x1a0
[ 6962.658772]  [<ffffffffa008ff8d>] ? mlx4_sense_port+0x7d/0xc0 [mlx4_core]
[ 6962.658777]  [<ffffffff81068724>] process_one_work+0x174/0x490
[ 6962.658782]  [<ffffffff810697eb>] worker_thread+0x11b/0x370
[ 6962.658788]  [<ffffffff810696d0>] ? manage_workers.isra.21+0x2d0/0x2d0
[ 6962.658793]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 6962.658798]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.658803]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 6962.658808]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.658812] INFO: task kworker/4:2:7469 blocked for more than 120 seconds.
[ 6962.658816] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6962.658821] kworker/4:2     D ffffffff8180fea0     0  7469      2 0x00000000
[ 6962.658829] Workqueue: bcache bch_data_insert_keys
[ 6962.658832]  ffff88176c719658 0000000000000046 ffff88176c719678
0000000000000000
[ 6962.658836]  ffff882f8c8b1730 ffff88176c719fd8 ffff88176c719fd8
ffff88176c719fd8
[ 6962.658841]  ffff882fa66e9730 ffff882f8c8b1730 ffff882f8c8b1730
ffff882e4b5e0d98
[ 6962.658845] Call Trace:
[ 6962.658851]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 6962.658856]  [<ffffffff816e2fbe>] schedule_preempt_disabled+0xe/0x10
[ 6962.658862]  [<ffffffff816e1272>] __mutex_lock_slowpath+0x112/0x1b0
[ 6962.658867]  [<ffffffff81147189>] ? zone_statistics+0x99/0xc0
[ 6962.658872]  [<ffffffff816e076a>] mutex_lock+0x2a/0x41
[ 6962.658876]  [<ffffffff8152af05>] bch_mca_shrink+0x1b5/0x2f0
[ 6962.658881]  [<ffffffff8118c972>] ? prune_super+0x162/0x1b0
[ 6962.658886]  [<ffffffff8113b474>] shrink_slab+0x154/0x300
[ 6962.658892]  [<ffffffff8107d258>] ? resched_task+0x68/0x70
[ 6962.658898]  [<ffffffff8107db85>] ? check_preempt_curr+0x75/0xa0
[ 6962.658902]  [<ffffffff811471c9>] ? fragmentation_index+0x19/0x70
[ 6962.658908]  [<ffffffff8113dfdf>] do_try_to_free_pages+0x1ef/0x440
[ 6962.658913]  [<ffffffff8113e3e4>] try_to_free_pages+0xe4/0x1a0
[ 6962.658919]  [<ffffffff81530c51>] ? __bch_bset_search+0x1d1/0x480
[ 6962.658925]  [<ffffffff81132f08>] __alloc_pages_nodemask+0x618/0x9a0
[ 6962.658932]  [<ffffffff8116e47a>] alloc_pages_current+0xba/0x170
[ 6962.658937]  [<ffffffff8112e50e>] __get_free_pages+0xe/0x40
[ 6962.658942]  [<ffffffff815287d3>] mca_data_alloc+0x73/0x1d0
[ 6962.658946]  [<ffffffff8152ab57>] mca_alloc+0x277/0x470
[ 6962.658951]  [<ffffffff81530e59>] ? __bch_bset_search+0x3d9/0x480
[ 6962.658956]  [<ffffffff8152b45e>] bch_btree_node_get+0x10e/0x280
[ 6962.658961]  [<ffffffff8152b822>] bch_btree_map_nodes_recurse+0xe2/0x170
[ 6962.658966]  [<ffffffff8152d3e0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 6962.658971]  [<ffffffff811c222a>] ? dio_bio_end_io+0x5a/0x90
[ 6962.658977]  [<ffffffff81086931>] ? update_curr+0x141/0x200
[ 6962.658982]  [<ffffffff8152e9ee>] __bch_btree_map_nodes+0x13e/0x1c0
[ 6962.658987]  [<ffffffff8152d3e0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 6962.658992]  [<ffffffff8153484f>] ? bch_journal+0x42f/0x4b0
[ 6962.658997]  [<ffffffff8152eb24>] bch_btree_insert+0xb4/0x120
[ 6962.659003]  [<ffffffff81537d9e>] bch_data_insert_keys+0x3e/0x160
[ 6962.659008]  [<ffffffff81068724>] process_one_work+0x174/0x490
[ 6962.659013]  [<ffffffff810697eb>] worker_thread+0x11b/0x370
[ 6962.659018]  [<ffffffff810696d0>] ? manage_workers.isra.21+0x2d0/0x2d0
[ 6962.659023]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 6962.659028]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.659033]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 6962.659038]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.659052] INFO: task kworker/0:32:7497 blocked for more than 120 seconds.
[ 6962.659056] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6962.659061] kworker/0:32    D ffffffff8180fbc0     0  7497      2 0x00000000
[ 6962.659067] Workqueue: events update_writeback_rate
[ 6962.659070]  ffff882f80151cd0 0000000000000046 0000000000000000
ffff882f80151d68
[ 6962.659074]  ffff88232d532e60 ffff882f80151fd8 ffff882f80151fd8
ffff882f80151fd8
[ 6962.659079]  ffffffff81c10440 ffff88232d532e60 0000000000000002
ffff88232d532e60
[ 6962.659083] Call Trace:
[ 6962.659089]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 6962.659094]  [<ffffffff816e3b5d>] rwsem_down_read_failed+0x9d/0xf0
[ 6962.659101]  [<ffffffff8105a210>] ? internal_add_timer+0x20/0x50
[ 6962.659107]  [<ffffffff81343e14>] call_rwsem_down_read_failed+0x14/0x30
[ 6962.659112]  [<ffffffff816e16d4>] ? down_read+0x24/0x2b
[ 6962.659117]  [<ffffffff81534bf0>] update_writeback_rate+0x30/0x230
[ 6962.659123]  [<ffffffff81068724>] process_one_work+0x174/0x490
[ 6962.659128]  [<ffffffff810697eb>] worker_thread+0x11b/0x370
[ 6962.659133]  [<ffffffff810696d0>] ? manage_workers.isra.21+0x2d0/0x2d0
[ 6962.659137]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 6962.659142]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.659148]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 6962.659152]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.659158] INFO: task kworker/u64:0:7535 blocked for more than 120 seconds.
[ 6962.659162] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6962.659170] kworker/u64:0   D ffffffff8180fbc0     0  7535      2 0x00000000
[ 6962.659176] Workqueue: bch_btree_io btree_node_write_work
[ 6962.659178]  ffff8809d3e2f778 0000000000000046 00000000102985a0
0000000974b06800
[ 6962.659183]  ffff8806cc1bdcc0 ffff8809d3e2ffd8 ffff8809d3e2ffd8
ffff8809d3e2ffd8
[ 6962.659188]  ffffffff81c10440 ffff8806cc1bdcc0 9000000000800000
ffff882e4b5e0d98
[ 6962.659192] Call Trace:
[ 6962.659198]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 6962.659203]  [<ffffffff816e2fbe>] schedule_preempt_disabled+0xe/0x10
[ 6962.659208]  [<ffffffff816e1272>] __mutex_lock_slowpath+0x112/0x1b0
[ 6962.659213]  [<ffffffff816e076a>] mutex_lock+0x2a/0x41
[ 6962.659218]  [<ffffffff8152af05>] bch_mca_shrink+0x1b5/0x2f0
[ 6962.659223]  [<ffffffff8118c972>] ? prune_super+0x162/0x1b0
[ 6962.659228]  [<ffffffff8113b474>] shrink_slab+0x154/0x300
[ 6962.659233]  [<ffffffff8107d258>] ? resched_task+0x68/0x70
[ 6962.659239]  [<ffffffff8107db85>] ? check_preempt_curr+0x75/0xa0
[ 6962.659243]  [<ffffffff811471c9>] ? fragmentation_index+0x19/0x70
[ 6962.659248]  [<ffffffff8113dfdf>] do_try_to_free_pages+0x1ef/0x440
[ 6962.659253]  [<ffffffff8113e3e4>] try_to_free_pages+0xe4/0x1a0
[ 6962.659259]  [<ffffffff81132f08>] __alloc_pages_nodemask+0x618/0x9a0
[ 6962.659265]  [<ffffffff8116e47a>] alloc_pages_current+0xba/0x170
[ 6962.659270]  [<ffffffff8112e50e>] __get_free_pages+0xe/0x40
[ 6962.659275]  [<ffffffff81531be8>] __btree_sort+0x48/0x230
[ 6962.659280]  [<ffffffff8153127c>] ? __bch_btree_iter_init+0x7c/0xc0
[ 6962.659285]  [<ffffffff81531f21>] bch_btree_sort_partial+0x101/0x120
[ 6962.659290]  [<ffffffff81528c20>] ? __btree_node_write_done+0x100/0x100
[ 6962.659295]  [<ffffffff81532088>] bch_btree_sort_lazy+0x68/0x90
[ 6962.659300]  [<ffffffff8152a5da>] bch_btree_node_write+0x36a/0x4a0
[ 6962.659306]  [<ffffffff8108b52b>] ? idle_balance+0xeb/0x150
[ 6962.659311]  [<ffffffff8106837c>] ? pwq_activate_delayed_work+0x4c/0xb0
[ 6962.659316]  [<ffffffff8152b097>] btree_node_write_work+0x57/0x80
[ 6962.659320]  [<ffffffff81068724>] process_one_work+0x174/0x490
[ 6962.659326]  [<ffffffff810697eb>] worker_thread+0x11b/0x370
[ 6962.659331]  [<ffffffff810696d0>] ? manage_workers.isra.21+0x2d0/0x2d0
[ 6962.659335]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 6962.659340]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 6962.659345]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 6962.659350]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0


[ 7082.658055] INFO: task kswapd0:51 blocked for more than 120 seconds.
[ 7082.658065] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7082.658072] kswapd0         D ffffffff8180fbc0     0    51      2 0x00000000
[ 7082.658078]  ffff882fa49b5b28 0000000000000046 ffff882fa49b5b68
ffffffff8108a4d9
[ 7082.658083]  ffff882f8a38c590 ffff882fa49b5fd8 ffff882fa49b5fd8
ffff882fa49b5fd8
[ 7082.658088]  ffff882fa6aa8000 ffff882f8a38c590 ffff882fa49b5b18
ffff882e4b5e0d98
[ 7082.658093] Call Trace:
[ 7082.658103]  [<ffffffff8108a4d9>] ? find_busiest_group+0x39/0x4a0
[ 7082.658110]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 7082.658116]  [<ffffffff816e2fbe>] schedule_preempt_disabled+0xe/0x10
[ 7082.658121]  [<ffffffff816e1272>] __mutex_lock_slowpath+0x112/0x1b0
[ 7082.658127]  [<ffffffff816e076a>] mutex_lock+0x2a/0x41
[ 7082.658132]  [<ffffffff8152af05>] bch_mca_shrink+0x1b5/0x2f0
[ 7082.658138]  [<ffffffff8118c972>] ? prune_super+0x162/0x1b0
[ 7082.658144]  [<ffffffff8113b474>] shrink_slab+0x154/0x300
[ 7082.658149]  [<ffffffff8108b52b>] ? idle_balance+0xeb/0x150
[ 7082.658155]  [<ffffffff8113e934>] balance_pgdat+0x494/0x5d0
[ 7082.658160]  [<ffffffff816e0193>] ? schedule_timeout+0x133/0x250
[ 7082.658165]  [<ffffffff8113ebdf>] kswapd+0x16f/0x480
[ 7082.658171]  [<ffffffff81070cf0>] ? add_wait_queue+0x60/0x60
[ 7082.658176]  [<ffffffff8113ea70>] ? balance_pgdat+0x5d0/0x5d0
[ 7082.658180]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 7082.658185]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 7082.658191]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 7082.658196]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 7082.658207] INFO: task bcache_writebac:5046 blocked for more than
120 seconds.
[ 7082.658213] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7082.658219] bcache_writebac D ffffffff8180fbc0     0  5046      2 0x00000000
[ 7082.658223]  ffff881955e31cd8 0000000000000046 0000000000000001
0000000000000001
[ 7082.658228]  ffff882f8a740000 ffff881955e31fd8 ffff881955e31fd8
ffff881955e31fd8
[ 7082.658232]  ffff882fa6aa9730 ffff882f8a740000 ffff882f8a740000
ffff882f8a740000
[ 7082.658237] Call Trace:
[ 7082.658243]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 7082.658249]  [<ffffffff816e3a15>] rwsem_down_write_failed+0xf5/0x1a0
[ 7082.658255]  [<ffffffff81343e43>] call_rwsem_down_write_failed+0x13/0x20
[ 7082.658260]  [<ffffffff816e16a1>] ? down_write+0x31/0x40
[ 7082.658266]  [<ffffffff81535362>] bch_writeback_thread+0x62/0x7f0
[ 7082.658272]  [<ffffffff8108b52b>] ? idle_balance+0xeb/0x150
[ 7082.658278]  [<ffffffff81535300>] ? write_dirty+0xc0/0xc0
[ 7082.658282]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 7082.658287]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 7082.658293]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 7082.658297]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 7082.658301] INFO: task iozone:7406 blocked for more than 120 seconds.
[ 7082.658306] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7082.658312] iozone          D 0000000000000000     0  7406   7246 0x00000000
[ 7082.658316]  ffff8809dcfbb978 0000000000000082 ffff8809dcfbb938
ffffffff8131187a
[ 7082.658320]  ffff882f8c8b4590 ffff8809dcfbbfd8 ffff8809dcfbbfd8
ffff8809dcfbbfd8
[ 7082.658325]  ffff882f8c8b1730 ffff882f8c8b4590 ffff8809dcfbb978
ffff882fbf293c28
[ 7082.658329] Call Trace:
[ 7082.658335]  [<ffffffff8131187a>] ? generic_make_request+0xca/0x100
[ 7082.658341]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 7082.658346]  [<ffffffff816e2daf>] io_schedule+0x8f/0xd0
[ 7082.658353]  [<ffffffff811c49bc>] do_blockdev_direct_IO+0x1a7c/0x1fb0
[ 7082.658362]  [<ffffffffa022ea70>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 7082.658369]  [<ffffffff811c4f45>] __blockdev_direct_IO+0x55/0x60
[ 7082.658375]  [<ffffffffa022ea70>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 7082.658381]  [<ffffffffa022f339>] ext2_direct_IO+0x79/0xe0 [ext2]
[ 7082.658386]  [<ffffffffa022ea70>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 7082.658392]  [<ffffffff81051426>] ? current_fs_time+0x16/0x60
[ 7082.658397]  [<ffffffff8112b1f6>] generic_file_direct_write+0xc6/0x180
[ 7082.658402]  [<ffffffff8112b58d>] __generic_file_aio_write+0x2dd/0x3b0
[ 7082.658407]  [<ffffffff816e0674>] ? mutex_unlock+0x14/0x20
[ 7082.658412]  [<ffffffff8112b6c9>] generic_file_aio_write+0x69/0xd0
[ 7082.658417]  [<ffffffff8118866a>] do_sync_write+0x7a/0xb0
[ 7082.658421]  [<ffffffff8118949e>] vfs_write+0xce/0x200
[ 7082.658426]  [<ffffffff811a4d60>] ? fget_light+0x70/0xd0
[ 7082.658431]  [<ffffffff811899a2>] SyS_write+0x52/0xa0
[ 7082.658437]  [<ffffffff816ec942>] system_call_fastpath+0x16/0x1b


Another similar crash but with ext4:

[ 2088.219467] bcache: register_bdev() registered backing device sda3
[ 2094.581831] bcache: run_cache_set() invalidating existing data
[ 2094.599616] bcache: register_cache() registered cache device rxd1
[ 2117.644140] bcache: bch_cached_dev_attach() Caching sda3 as bcache0
on set 1e26e5ca-5cb9-4c5a-ad7e-3c787524a9dc
[ 2232.400911] EXT4-fs (bcache0): mounted filesystem with ordered data
mode. Opts: (null)
[ 3723.031832] INFO: task kswapd0:51 blocked for more than 120 seconds.
[ 3723.031842] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3723.031848] kswapd0         D ffffffff8180fbc0     0    51      2 0x00000000
[ 3723.031856]  ffff882f8a39bb28 0000000000000046 00000000ffffffff
ffff882f8a39bb78
[ 3723.031862]  ffff882f8a38c590 ffff882f8a39bfd8 ffff882f8a39bfd8
ffff882f8a39bfd8
[ 3723.031867]  ffff882fa6aa8000 ffff882f8a38c590 ffff882f8a39bb18
ffff882ec9ea0d98
[ 3723.031872] Call Trace:
[ 3723.031886]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3723.031893]  [<ffffffff816e2fbe>] schedule_preempt_disabled+0xe/0x10
[ 3723.031899]  [<ffffffff816e1272>] __mutex_lock_slowpath+0x112/0x1b0
[ 3723.031905]  [<ffffffff816e076a>] mutex_lock+0x2a/0x41
[ 3723.031913]  [<ffffffff8152af05>] bch_mca_shrink+0x1b5/0x2f0
[ 3723.031922]  [<ffffffff8118c972>] ? prune_super+0x162/0x1b0
[ 3723.031929]  [<ffffffff8113b474>] shrink_slab+0x154/0x300
[ 3723.031936]  [<ffffffff8113e934>] balance_pgdat+0x494/0x5d0
[ 3723.031941]  [<ffffffff8113ebdf>] kswapd+0x16f/0x480
[ 3723.031949]  [<ffffffff81070cf0>] ? add_wait_queue+0x60/0x60
[ 3723.031954]  [<ffffffff8113ea70>] ? balance_pgdat+0x5d0/0x5d0
[ 3723.031959]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3723.031964]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.031971]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3723.031976]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.031987] INFO: task bcache_writebac:1706 blocked for more than
120 seconds.
[ 3723.031992] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3723.031997] bcache_writebac D ffffffff8180fbc0     0  1706      2 0x00000000
[ 3723.032001]  ffff882f90c2bcd8 0000000000000046 0000000000000001
0000000000000001
[ 3723.032006]  ffff882f8989dcc0 ffff882f90c2bfd8 ffff882f90c2bfd8
ffff882f90c2bfd8
[ 3723.032011]  ffff882fa6aaae60 ffff882f8989dcc0 ffff882f8989dcc0
ffff882f8989dcc0
[ 3723.032015] Call Trace:
[ 3723.032021]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3723.032027]  [<ffffffff816e3a15>] rwsem_down_write_failed+0xf5/0x1a0
[ 3723.032036]  [<ffffffff81343e43>] call_rwsem_down_write_failed+0x13/0x20
[ 3723.032041]  [<ffffffff816e16a1>] ? down_write+0x31/0x40
[ 3723.032049]  [<ffffffff81535362>] bch_writeback_thread+0x62/0x7f0
[ 3723.032057]  [<ffffffff8108b52b>] ? idle_balance+0xeb/0x150
[ 3723.032063]  [<ffffffff81535300>] ? write_dirty+0xc0/0xc0
[ 3723.032068]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3723.032072]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032078]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3723.032082]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032087] INFO: task jbd2/bcache0-8:1732 blocked for more than 120 seconds.
[ 3723.032091] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3723.032096] jbd2/bcache0-8  D ffffffff8180fbc0     0  1732      2 0x00000000
[ 3723.032100]  ffff882fa4b81a00 0000000000000046 ffff882fa4b819d0
0000000000000000
[ 3723.032104]  ffff882f885e2e60 ffff882fa4b81fd8 ffff882fa4b81fd8
ffff882fa4b81fd8
[ 3723.032109]  ffff882fa6aaae60 ffff882f885e2e60 ffff8822e655cf08
ffff882f885e2e60
[ 3723.032113] Call Trace:
[ 3723.032119]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3723.032125]  [<ffffffff816e3b5d>] rwsem_down_read_failed+0x9d/0xf0
[ 3723.032130]  [<ffffffff81343e14>] call_rwsem_down_read_failed+0x14/0x30
[ 3723.032135]  [<ffffffff816e16d4>] ? down_read+0x24/0x2b
[ 3723.032140]  [<ffffffff81539932>] cached_dev_make_request+0x752/0xf00
[ 3723.032147]  [<ffffffff813115f8>] ? generic_make_request_checks+0x1e8/0x3a0
[ 3723.032152]  [<ffffffff8131187a>] generic_make_request+0xca/0x100
[ 3723.032157]  [<ffffffff81311929>] submit_bio+0x79/0x160
[ 3723.032164]  [<ffffffff811be700>] ? bio_alloc_bioset+0xa0/0x1d0
[ 3723.032169]  [<ffffffff811b8ccf>] _submit_bh+0x13f/0x200
[ 3723.032173]  [<ffffffff811b8da0>] submit_bh+0x10/0x20
[ 3723.032180]  [<ffffffff81276521>]
jbd2_journal_commit_transaction+0x6c1/0x1990
[ 3723.032187]  [<ffffffff8105a48f>] ? try_to_del_timer_sync+0x4f/0x70
[ 3723.032193]  [<ffffffff8127b638>] kjournald2+0xb8/0x240
[ 3723.032198]  [<ffffffff81070cf0>] ? add_wait_queue+0x60/0x60
[ 3723.032203]  [<ffffffff8127b580>] ? commit_timeout+0x10/0x10
[ 3723.032208]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3723.032212]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032218]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3723.032223]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032226] INFO: task iozone:2060 blocked for more than 120 seconds.
[ 3723.032230] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3723.032235] iozone          D 0000000000000000     0  2060   1422 0x00000000
[ 3723.032239]  ffff88180409d8e8 0000000000000082 ffff88180409d8a8
ffffffff8131187a
[ 3723.032243]  ffff882f8a5d4590 ffff88180409dfd8 ffff88180409dfd8
ffff88180409dfd8
[ 3723.032248]  ffff88149dbc9730 ffff882f8a5d4590 ffff88180409d8b8
ffff882fbf213c28
[ 3723.032252] Call Trace:
[ 3723.032257]  [<ffffffff8131187a>] ? generic_make_request+0xca/0x100
[ 3723.032263]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3723.032268]  [<ffffffff816e2daf>] io_schedule+0x8f/0xd0
[ 3723.032275]  [<ffffffff811c49bc>] do_blockdev_direct_IO+0x1a7c/0x1fb0
[ 3723.032280]  [<ffffffff810709de>] ? wake_up_bit+0x2e/0x40
[ 3723.032288]  [<ffffffff81227600>] ? ext4_get_block_write_nolock+0x20/0x20
[ 3723.032294]  [<ffffffff811c4f45>] __blockdev_direct_IO+0x55/0x60
[ 3723.032299]  [<ffffffff81227600>] ? ext4_get_block_write_nolock+0x20/0x20
[ 3723.032303]  [<ffffffff81223410>] ? ext4_invalidatepage+0xe0/0xe0
[ 3723.032309]  [<ffffffff811a2381>] ? inode_dio_done+0x31/0x40
[ 3723.032313]  [<ffffffff812252f6>] ext4_direct_IO+0x2c6/0x4e0
[ 3723.032317]  [<ffffffff81227600>] ? ext4_get_block_write_nolock+0x20/0x20
[ 3723.032321]  [<ffffffff81223410>] ? ext4_invalidatepage+0xe0/0xe0
[ 3723.032327]  [<ffffffff811b1283>] ? __mark_inode_dirty+0x53/0x2d0
[ 3723.032334]  [<ffffffff8112b1f6>] generic_file_direct_write+0xc6/0x180
[ 3723.032339]  [<ffffffff8112b58d>] __generic_file_aio_write+0x2dd/0x3b0
[ 3723.032344]  [<ffffffff8121fe08>] ext4_file_write+0x258/0x400
[ 3723.032349]  [<ffffffff8118866a>] do_sync_write+0x7a/0xb0
[ 3723.032354]  [<ffffffff811c81f0>] ? fsnotify+0x2a0/0x2b0
[ 3723.032359]  [<ffffffff8118949e>] vfs_write+0xce/0x200
[ 3723.032363]  [<ffffffff811899a2>] SyS_write+0x52/0xa0
[ 3723.032369]  [<ffffffff816ec942>] system_call_fastpath+0x16/0x1b
[ 3723.032373] INFO: task kworker/u64:1:2070 blocked for more than 120 seconds.
[ 3723.032377] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3723.032381] kworker/u64:1   D ffffffff8180fbc0     0  2070      2 0x00000000
[ 3723.032389] Workqueue: bch_btree_io btree_node_write_work
[ 3723.032391]  ffff880783d1f778 0000000000000046 0000000000000000
0000000000000001
[ 3723.032395]  ffff882f87d88000 ffff880783d1ffd8 ffff880783d1ffd8
ffff880783d1ffd8
[ 3723.032400]  ffffffff81c10440 ffff882f87d88000 ffff880783d1f7b8
ffff882ec9ea0d98
[ 3723.032404] Call Trace:
[ 3723.032410]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3723.032415]  [<ffffffff816e2fbe>] schedule_preempt_disabled+0xe/0x10
[ 3723.032421]  [<ffffffff816e1272>] __mutex_lock_slowpath+0x112/0x1b0
[ 3723.032426]  [<ffffffff816e076a>] mutex_lock+0x2a/0x41
[ 3723.032430]  [<ffffffff8152af05>] bch_mca_shrink+0x1b5/0x2f0
[ 3723.032435]  [<ffffffff8118c972>] ? prune_super+0x162/0x1b0
[ 3723.032440]  [<ffffffff8113b474>] shrink_slab+0x154/0x300
[ 3723.032449]  [<ffffffff8107d258>] ? resched_task+0x68/0x70
[ 3723.032454]  [<ffffffff811471c9>] ? fragmentation_index+0x19/0x70
[ 3723.032460]  [<ffffffff8113dfdf>] do_try_to_free_pages+0x1ef/0x440
[ 3723.032465]  [<ffffffff8113e3e4>] try_to_free_pages+0xe4/0x1a0
[ 3723.032472]  [<ffffffff81132f08>] __alloc_pages_nodemask+0x618/0x9a0
[ 3723.032480]  [<ffffffff8116e47a>] alloc_pages_current+0xba/0x170
[ 3723.032486]  [<ffffffff8112e50e>] __get_free_pages+0xe/0x40
[ 3723.032491]  [<ffffffff81531be8>] __btree_sort+0x48/0x230
[ 3723.032497]  [<ffffffff8153127c>] ? __bch_btree_iter_init+0x7c/0xc0
[ 3723.032502]  [<ffffffff81531f21>] bch_btree_sort_partial+0x101/0x120
[ 3723.032507]  [<ffffffff81528c20>] ? __btree_node_write_done+0x100/0x100
[ 3723.032512]  [<ffffffff81532088>] bch_btree_sort_lazy+0x68/0x90
[ 3723.032516]  [<ffffffff8152a5da>] bch_btree_node_write+0x36a/0x4a0
[ 3723.032522]  [<ffffffff8108b52b>] ? idle_balance+0xeb/0x150
[ 3723.032529]  [<ffffffff8106837c>] ? pwq_activate_delayed_work+0x4c/0xb0
[ 3723.032534]  [<ffffffff8152b097>] btree_node_write_work+0x57/0x80
[ 3723.032539]  [<ffffffff81068724>] process_one_work+0x174/0x490
[ 3723.032544]  [<ffffffff810697eb>] worker_thread+0x11b/0x370
[ 3723.032550]  [<ffffffff810696d0>] ? manage_workers.isra.21+0x2d0/0x2d0
[ 3723.032554]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3723.032559]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032565]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3723.032569]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032575] INFO: task kworker/0:10:2142 blocked for more than 120 seconds.
[ 3723.032579] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3723.032584] kworker/0:10    D ffffffff8180fbc0     0  2142      2 0x00000000
[ 3723.032591] Workqueue: events update_writeback_rate
[ 3723.032593]  ffff8821cfb3fcd0 0000000000000046 0000000000000000
ffff8821cfb3fd68
[ 3723.032597]  ffff882f8965dcc0 ffff8821cfb3ffd8 ffff8821cfb3ffd8
ffff8821cfb3ffd8
[ 3723.032602]  ffffffff81c10440 ffff882f8965dcc0 0000000000000002
ffff882f8965dcc0
[ 3723.032606] Call Trace:
[ 3723.032612]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3723.032617]  [<ffffffff816e3b5d>] rwsem_down_read_failed+0x9d/0xf0
[ 3723.032623]  [<ffffffff81343e14>] call_rwsem_down_read_failed+0x14/0x30
[ 3723.032628]  [<ffffffff816e16d4>] ? down_read+0x24/0x2b
[ 3723.032633]  [<ffffffff81534bf0>] update_writeback_rate+0x30/0x230
[ 3723.032638]  [<ffffffff81068724>] process_one_work+0x174/0x490
[ 3723.032643]  [<ffffffff810697eb>] worker_thread+0x11b/0x370
[ 3723.032649]  [<ffffffff810696d0>] ? manage_workers.isra.21+0x2d0/0x2d0
[ 3723.032653]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3723.032658]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032663]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3723.032668]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032680] INFO: task kworker/0:63:2546 blocked for more than 120 seconds.
[ 3723.032684] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3723.032691] kworker/0:63    D ffffffff8180fea0     0  2546      2 0x00000000
[ 3723.032699] Workqueue: bcache bch_data_insert_keys
[ 3723.032701]  ffff8821d4f99658 0000000000000046 ffff8821d4f99678
ffff88307fff9d80
[ 3723.032705]  ffff88149dbc9730 ffff8821d4f99fd8 ffff8821d4f99fd8
ffff8821d4f99fd8
[ 3723.032710]  ffff882fa6a9dcc0 ffff88149dbc9730 ffff88149dbc9730
ffff882ec9ea0d98
[ 3723.032714] Call Trace:
[ 3723.032720]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3723.032726]  [<ffffffff816e2fbe>] schedule_preempt_disabled+0xe/0x10
[ 3723.032732]  [<ffffffff816e1272>] __mutex_lock_slowpath+0x112/0x1b0
[ 3723.032737]  [<ffffffff816e076a>] mutex_lock+0x2a/0x41
[ 3723.032742]  [<ffffffff8152af05>] bch_mca_shrink+0x1b5/0x2f0
[ 3723.032747]  [<ffffffff8118c972>] ? prune_super+0x162/0x1b0
[ 3723.032752]  [<ffffffff8113b474>] shrink_slab+0x154/0x300
[ 3723.032757]  [<ffffffff8107d258>] ? resched_task+0x68/0x70
[ 3723.032763]  [<ffffffff8107db85>] ? check_preempt_curr+0x75/0xa0
[ 3723.032767]  [<ffffffff811471c9>] ? fragmentation_index+0x19/0x70
[ 3723.032772]  [<ffffffff8113dfdf>] do_try_to_free_pages+0x1ef/0x440
[ 3723.032777]  [<ffffffff8113e3e4>] try_to_free_pages+0xe4/0x1a0
[ 3723.032783]  [<ffffffff81530c51>] ? __bch_bset_search+0x1d1/0x480
[ 3723.032789]  [<ffffffff81132f08>] __alloc_pages_nodemask+0x618/0x9a0
[ 3723.032794]  [<ffffffff8116e47a>] alloc_pages_current+0xba/0x170
[ 3723.032799]  [<ffffffff8112e50e>] __get_free_pages+0xe/0x40
[ 3723.032804]  [<ffffffff815287d3>] mca_data_alloc+0x73/0x1d0
[ 3723.032808]  [<ffffffff8152ab57>] mca_alloc+0x277/0x470
[ 3723.032813]  [<ffffffff81530c51>] ? __bch_bset_search+0x1d1/0x480
[ 3723.032818]  [<ffffffff8152b45e>] bch_btree_node_get+0x10e/0x280
[ 3723.032823]  [<ffffffff8152b822>] bch_btree_map_nodes_recurse+0xe2/0x170
[ 3723.032828]  [<ffffffff8152d3e0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 3723.032834]  [<ffffffff811c222a>] ? dio_bio_end_io+0x5a/0x90
[ 3723.032840]  [<ffffffff81086931>] ? update_curr+0x141/0x200
[ 3723.032845]  [<ffffffff81534dfe>] ? dirty_io_destructor+0xe/0x10
[ 3723.032850]  [<ffffffff8152e9ee>] __bch_btree_map_nodes+0x13e/0x1c0
[ 3723.032855]  [<ffffffff8152d3e0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 3723.032860]  [<ffffffff8153484f>] ? bch_journal+0x42f/0x4b0
[ 3723.032865]  [<ffffffff8152eb24>] bch_btree_insert+0xb4/0x120
[ 3723.032871]  [<ffffffff81537d9e>] bch_data_insert_keys+0x3e/0x160
[ 3723.032876]  [<ffffffff81068724>] process_one_work+0x174/0x490
[ 3723.032881]  [<ffffffff810697eb>] worker_thread+0x11b/0x370
[ 3723.032887]  [<ffffffff810696d0>] ? manage_workers.isra.21+0x2d0/0x2d0
[ 3723.032891]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3723.032896]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3723.032901]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3723.032906]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3843.031746] INFO: task kswapd0:51 blocked for more than 120 seconds.
[ 3843.031755] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3843.031761] kswapd0         D ffffffff8180fbc0     0    51      2 0x00000000
[ 3843.031768]  ffff882f8a39bb28 0000000000000046 00000000ffffffff
ffff882f8a39bb78
[ 3843.031774]  ffff882f8a38c590 ffff882f8a39bfd8 ffff882f8a39bfd8
ffff882f8a39bfd8
[ 3843.031778]  ffff882fa6aa8000 ffff882f8a38c590 ffff882f8a39bb18
ffff882ec9ea0d98
[ 3843.031783] Call Trace:
[ 3843.031794]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3843.031800]  [<ffffffff816e2fbe>] schedule_preempt_disabled+0xe/0x10
[ 3843.031806]  [<ffffffff816e1272>] __mutex_lock_slowpath+0x112/0x1b0
[ 3843.031812]  [<ffffffff816e076a>] mutex_lock+0x2a/0x41
[ 3843.031817]  [<ffffffff8152af05>] bch_mca_shrink+0x1b5/0x2f0
[ 3843.031823]  [<ffffffff8118c972>] ? prune_super+0x162/0x1b0
[ 3843.031829]  [<ffffffff8113b474>] shrink_slab+0x154/0x300
[ 3843.031835]  [<ffffffff8113e934>] balance_pgdat+0x494/0x5d0
[ 3843.031840]  [<ffffffff8113ebdf>] kswapd+0x16f/0x480
[ 3843.031846]  [<ffffffff81070cf0>] ? add_wait_queue+0x60/0x60
[ 3843.031851]  [<ffffffff8113ea70>] ? balance_pgdat+0x5d0/0x5d0
[ 3843.031856]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3843.031861]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3843.031867]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3843.031872]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3843.031883] INFO: task bcache_writebac:1706 blocked for more than
120 seconds.
[ 3843.031888] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3843.031894] bcache_writebac D ffffffff8180fbc0     0  1706      2 0x00000000
[ 3843.031899]  ffff882f90c2bcd8 0000000000000046 0000000000000001
0000000000000001
[ 3843.031904]  ffff882f8989dcc0 ffff882f90c2bfd8 ffff882f90c2bfd8
ffff882f90c2bfd8
[ 3843.031908]  ffff882fa6aaae60 ffff882f8989dcc0 ffff882f8989dcc0
ffff882f8989dcc0
[ 3843.031913] Call Trace:
[ 3843.031919]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3843.031925]  [<ffffffff816e3a15>] rwsem_down_write_failed+0xf5/0x1a0
[ 3843.031931]  [<ffffffff81343e43>] call_rwsem_down_write_failed+0x13/0x20
[ 3843.031936]  [<ffffffff816e16a1>] ? down_write+0x31/0x40
[ 3843.031942]  [<ffffffff81535362>] bch_writeback_thread+0x62/0x7f0
[ 3843.031949]  [<ffffffff8108b52b>] ? idle_balance+0xeb/0x150
[ 3843.031955]  [<ffffffff81535300>] ? write_dirty+0xc0/0xc0
[ 3843.031959]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3843.031964]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3843.031969]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3843.031974]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3843.031978] INFO: task jbd2/bcache0-8:1732 blocked for more than 120 seconds.
[ 3843.031982] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3843.031988] jbd2/bcache0-8  D ffffffff8180fbc0     0  1732      2 0x00000000
[ 3843.031992]  ffff882fa4b81a00 0000000000000046 ffff882fa4b819d0
0000000000000000
[ 3843.031996]  ffff882f885e2e60 ffff882fa4b81fd8 ffff882fa4b81fd8
ffff882fa4b81fd8
[ 3843.032001]  ffff882fa6aaae60 ffff882f885e2e60 ffff8822e655cf08
ffff882f885e2e60
[ 3843.032005] Call Trace:
[ 3843.032011]  [<ffffffff816e2cd9>] schedule+0x29/0x70
[ 3843.032016]  [<ffffffff816e3b5d>] rwsem_down_read_failed+0x9d/0xf0
[ 3843.032022]  [<ffffffff81343e14>] call_rwsem_down_read_failed+0x14/0x30
[ 3843.032027]  [<ffffffff816e16d4>] ? down_read+0x24/0x2b
[ 3843.032031]  [<ffffffff81539932>] cached_dev_make_request+0x752/0xf00
[ 3843.032037]  [<ffffffff813115f8>] ? generic_make_request_checks+0x1e8/0x3a0
[ 3843.032042]  [<ffffffff8131187a>] generic_make_request+0xca/0x100
[ 3843.032047]  [<ffffffff81311929>] submit_bio+0x79/0x160
[ 3843.032052]  [<ffffffff811be700>] ? bio_alloc_bioset+0xa0/0x1d0
[ 3843.032057]  [<ffffffff811b8ccf>] _submit_bh+0x13f/0x200
[ 3843.032061]  [<ffffffff811b8da0>] submit_bh+0x10/0x20
[ 3843.032067]  [<ffffffff81276521>]
jbd2_journal_commit_transaction+0x6c1/0x1990
[ 3843.032073]  [<ffffffff8105a48f>] ? try_to_del_timer_sync+0x4f/0x70
[ 3843.032079]  [<ffffffff8127b638>] kjournald2+0xb8/0x240
[ 3843.032084]  [<ffffffff81070cf0>] ? add_wait_queue+0x60/0x60
[ 3843.032089]  [<ffffffff8127b580>] ? commit_timeout+0x10/0x10
[ 3843.032093]  [<ffffffff810704f0>] kthread+0xc0/0xd0
[ 3843.032098]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0
[ 3843.032104]  [<ffffffff816ec89c>] ret_from_fork+0x7c/0xb0
[ 3843.032108]  [<ffffffff81070430>] ? flush_kthread_worker+0xb0/0xb0

Could you please help me out to fix this ? Also please let me know if
I am missing anything here. I can recreate this scenario very easily
please let me know if you require any specific information.

Thanks,
Neo
