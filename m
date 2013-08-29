From: kernel neophyte <neophyte.hacker001-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache hangs and calll trace
Date: Thu, 29 Aug 2013 16:34:17 -0700
Message-ID: <CAFkUHxfg5MCrZ8y8FCJzQZsj91PwqwerfjjGZGLwL6tziM6+jQ@mail.gmail.com>
References: <521ED8E3.5010407@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521ED8E3.5010407-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Aug 28, 2013 at 10:15 PM, Stefan Priebe <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org> wrote:
> Hi,
>
> i got this one today. I have a load aof 1200 after this.
>

We are evaluating to use bcache on our production systems where the
caching devices are insanely fast, in this scenario under a heavy load
of random 4k writes.. bcache fails miserably :-(
I have posted several such crash logs...

in my case I see this very very frequently...  :-(


[  928.788063] bcache: bch_cached_dev_attach() Caching sda3 as bcache0
on set 64af0627-4df2-4e5d-9ca3-d5d0af2f923c
[ 2162.689481] INFO: task kswapd0:51 blocked for more than 120 seconds.
[ 2162.689492] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.689498] kswapd0         D 0000000000000001     0    51      2 0x00000000
[ 2162.689505]  ffff882f8a075ba8 0000000000000046 ffff882f8a075bc8
ffff882fa49f4cf8
[ 2162.689511]  ffff882fa49f4cb0 ffff882f8a075fd8 ffff882f8a075fd8
ffff882f8a075fd8
[ 2162.689516]  ffff882f8a6ce640 ffff882fa49f4cb0 ffff882f881d9990
ffff882983500d98
[ 2162.689521] Call Trace:
[ 2162.689535]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.689540]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
[ 2162.689546]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
[ 2162.689551]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
[ 2162.689559]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
[ 2162.689567]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
[ 2162.689576]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
[ 2162.689582]  [<ffffffff81131f54>] kswapd+0x634/0x9b0
[ 2162.689680]  [<ffffffff8106a720>] ? add_wait_queue+0x60/0x60
[ 2162.689685]  [<ffffffff81131920>] ? try_to_free_pages+0x1a0/0x1a0
[ 2162.689691]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.689695]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.689704]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.689708]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.689713] INFO: task kworker/0:3:341 blocked for more than 120 seconds.
[ 2162.689718] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.689723] kworker/0:3     D 0000000000000000     0   341      2 0x00000000
[ 2162.689734] Workqueue: events write_dirty_finish
[ 2162.689736]  ffff882f8888bb30 0000000000000046 ffffffff81511b8c
ffffffff815137c0
[ 2162.689741]  ffff882f885b0000 ffff882f8888bfd8 ffff882f8888bfd8
ffff882f8888bfd8
[ 2162.689745]  ffff88179f2ce640 ffff882f885b0000 ffffffff815117a1
ffff882f885b0000
[ 2162.689750] Call Trace:
[ 2162.689754]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
[ 2162.689759]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.689764]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
[ 2162.689769]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.689775]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 2162.689783]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 2162.689788]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 2162.689793]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
[ 2162.689797]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.689804]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
[ 2162.689809]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
[ 2162.689814]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 2162.689819]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
[ 2162.689824]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
[ 2162.689830]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
[ 2162.689836]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2162.689841]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2162.689846]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2162.689850]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.689855]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.689860]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.689864]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.689874] INFO: task bcache_writebac:1692 blocked for more than
120 seconds.
[ 2162.689879] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.689883] bcache_writebac D 0000000000000000     0  1692      2 0x00000000
[ 2162.689888]  ffff88291b73fc58 0000000000000046 ffff88291b73fd48
ffffffff811269e2
[ 2162.689892]  ffff882f8a61b320 ffff88291b73ffd8 ffff88291b73ffd8
ffff88291b73ffd8
[ 2162.689897]  ffff882f8a6ce640 ffff882f8a61b320 ffff88291b73fc68
ffff882f7fa10ba0
[ 2162.689901] Call Trace:
[ 2162.689912]  [<ffffffff811269e2>] ? __alloc_pages_nodemask+0x152/0x9b0
[ 2162.689917]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.689923]  [<ffffffff816bc015>] schedule_timeout+0x1e5/0x250
[ 2162.689929]  [<ffffffff810799bf>] ? try_to_wake_up+0x24f/0x2b0
[ 2162.689934]  [<ffffffff816bcd09>] __down_common+0x8e/0xe3
[ 2162.689942]  [<ffffffff81160600>] ? alloc_pages_current+0x90/0x170
[ 2162.689947]  [<ffffffff816bcdd1>] __down+0x1d/0x1f
[ 2162.689953]  [<ffffffff8106f351>] down+0x41/0x50
[ 2162.689959]  [<ffffffff8151ba7d>] bch_writeback_thread+0x35d/0x7f0
[ 2162.689964]  [<ffffffff8108458b>] ? idle_balance+0xeb/0x150
[ 2162.689970]  [<ffffffff8151b720>] ? write_dirty+0xc0/0xc0
[ 2162.689974]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.689978]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.689984]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.689988]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.689991] INFO: task bcache_allocato:1701 blocked for more than
120 seconds.
[ 2162.689996] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.690000] bcache_allocato D 0000000000000001     0  1701      2 0x00000000
[ 2162.690004]  ffff881bf0d95d88 0000000000000046 ffff881bf0d95da8
ffffffff810808ad
[ 2162.690008]  ffff882f94b09990 ffff881bf0d95fd8 ffff881bf0d95fd8
ffff881bf0d95fd8
[ 2162.690013]  ffff882f8a161990 ffff882f94b09990 ffff882f881d9990
ffff882983500d98
[ 2162.690017] Call Trace:
[ 2162.690021]  [<ffffffff810808ad>] ? dequeue_task_fair+0x2cd/0x530
[ 2162.690027]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.690032]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
[ 2162.690037]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
[ 2162.690041]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
[ 2162.690046]  [<ffffffff8150cdbf>] bch_allocator_thread+0x10f/0xe20
[ 2162.690051]  [<ffffffff8150ccb0>] ? bch_bucket_add_unused+0xe0/0xe0
[ 2162.690054]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.690059]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690064]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.690068]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690072] INFO: task kworker/0:0:1710 blocked for more than 120 seconds.
[ 2162.690076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.690080] kworker/0:0     D 0000000000000000     0  1710      2 0x00000000
[ 2162.690087] Workqueue: events write_dirty_finish
[ 2162.690090]  ffff882f7f26fb30 0000000000000046 ffffffff81511b8c
ffffffff815137c0
[ 2162.690094]  ffff882f88914cb0 ffff882f7f26ffd8 ffff882f7f26ffd8
ffff882f7f26ffd8
[ 2162.690098]  ffff881770ca6640 ffff882f88914cb0 ffffffff815117a1
ffff882f88914cb0
[ 2162.690103] Call Trace:
[ 2162.690107]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
[ 2162.690112]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690116]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
[ 2162.690121]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.690127]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 2162.690132]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 2162.690136]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 2162.690141]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
[ 2162.690145]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690151]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
[ 2162.690156]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
[ 2162.690160]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 2162.690165]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
[ 2162.690170]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
[ 2162.690175]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
[ 2162.690179]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2162.690184]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2162.690189]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2162.690193]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.690197]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690202]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.690206]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690210] INFO: task iozone:1750 blocked for more than 120 seconds.
[ 2162.690214] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.690218] iozone          D 0000000000000001     0  1750   1475 0x00000000
[ 2162.690222]  ffff882786867978 0000000000000086 ffff882786867938
ffffffff81301d7a
[ 2162.690227]  ffff882fa6a84cb0 ffff882786867fd8 ffff882786867fd8
ffff882786867fd8
[ 2162.690231]  ffff882f881d9990 ffff882fa6a84cb0 ffff882786867978
ffff882fbf2139f8
[ 2162.690236] Call Trace:
[ 2162.690241]  [<ffffffff81301d7a>] ? generic_make_request+0xca/0x100
[ 2162.690247]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.690251]  [<ffffffff816be36f>] io_schedule+0x8f/0xd0
[ 2162.690259]  [<ffffffff811b797c>] do_blockdev_direct_IO+0x1a7c/0x1fb0
[ 2162.690269]  [<ffffffffa027aa80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 2162.690275]  [<ffffffff811b7f05>] __blockdev_direct_IO+0x55/0x60
[ 2162.690281]  [<ffffffffa027aa80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 2162.690287]  [<ffffffffa027b349>] ext2_direct_IO+0x79/0xe0 [ext2]
[ 2162.690293]  [<ffffffffa027aa80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 2162.690300]  [<ffffffff8104ade6>] ? current_fs_time+0x16/0x60
[ 2162.690306]  [<ffffffff8111f126>] generic_file_direct_write+0xc6/0x180
[ 2162.690312]  [<ffffffff8111f4bd>] __generic_file_aio_write+0x2dd/0x3b0
[ 2162.690317]  [<ffffffff8111f5f9>] generic_file_aio_write+0x69/0xd0
[ 2162.690322]  [<ffffffff8117b88a>] do_sync_write+0x7a/0xb0
[ 2162.690327]  [<ffffffff8106e960>] ? SyS_setns+0xf0/0xf0
[ 2162.690332]  [<ffffffff8117c63e>] vfs_write+0xce/0x1e0
[ 2162.690337]  [<ffffffff8117cb22>] SyS_write+0x52/0xa0
[ 2162.690342]  [<ffffffff816c7a02>] system_call_fastpath+0x16/0x1b
[ 2162.690347] INFO: task kworker/1:0:2001 blocked for more than 120 seconds.
[ 2162.690353] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.690358] kworker/1:0     D ffffffff81813a60     0  2001      2 0x00000000
[ 2162.690367] Workqueue: bcache bch_data_insert_keys
[ 2162.690369]  ffff882fa677bbe0 0000000000000046 ffffffff81053bd0
ffff88298350cbc0
[ 2162.690373]  ffff882f89b26640 ffff882fa677bfd8 ffff882fa677bfd8
ffff882fa677bfd8
[ 2162.690378]  ffff882fa6ae8000 ffff882f89b26640 0000000000000286
ffff882f89b26640
[ 2162.690382] Call Trace:
[ 2162.690388]  [<ffffffff81053bd0>] ? internal_add_timer+0x20/0x50
[ 2162.690393]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.690398]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 2162.690403]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 2162.690408]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 2162.690413]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
[ 2162.690417]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690422]  [<ffffffff8151ac6f>] ? bch_journal+0x42f/0x4b0
[ 2162.690427]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 2162.690432]  [<ffffffff8151e1be>] bch_data_insert_keys+0x3e/0x160
[ 2162.690437]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2162.690442]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2162.690447]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2162.690450]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.690455]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690460]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.690464]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690468] INFO: task kworker/0:2:2244 blocked for more than 120 seconds.
[ 2162.690473] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.690478] kworker/0:2     D 0000000000000000     0  2244      2 0x00000000
[ 2162.690484] Workqueue: events write_dirty_finish
[ 2162.690486]  ffff8829b9c39b30 0000000000000046 ffffffff81511b8c
ffffffff815137c0
[ 2162.690491]  ffff882fa67d3320 ffff8829b9c39fd8 ffff8829b9c39fd8
ffff8829b9c39fd8
[ 2162.690495]  ffff882f8af0e640 ffff882fa67d3320 ffffffff815117a1
ffff882fa67d3320
[ 2162.690500] Call Trace:
[ 2162.690504]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
[ 2162.690508]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690513]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
[ 2162.690518]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.690523]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 2162.690528]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 2162.690533]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 2162.690537]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
[ 2162.690542]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690546]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
[ 2162.690551]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
[ 2162.690555]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 2162.690561]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
[ 2162.690565]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
[ 2162.690570]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
[ 2162.690575]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2162.690579]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2162.690584]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2162.690588]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.690592]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690598]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.690602]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690605] INFO: task kworker/0:1:2267 blocked for more than 120 seconds.
[ 2162.690610] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.690616] kworker/0:1     D 0000000000000000     0  2267      2 0x00000000
[ 2162.690621] Workqueue: events write_dirty_finish
[ 2162.690623]  ffff882fa33abb30 0000000000000046 ffffffff81511b8c
ffffffff815137c0
[ 2162.690628]  ffff882f89b13320 ffff882fa33abfd8 ffff882fa33abfd8
ffff882fa33abfd8
[ 2162.690632]  ffff882f8af09990 ffff882f89b13320 ffffffff815117a1
ffff882f89b13320
[ 2162.690637] Call Trace:
[ 2162.690641]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
[ 2162.690645]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690650]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
[ 2162.690655]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.690660]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 2162.690665]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 2162.690669]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 2162.690674]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
[ 2162.690678]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690682]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
[ 2162.690687]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
[ 2162.690692]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 2162.690697]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
[ 2162.690701]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
[ 2162.690706]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
[ 2162.690711]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2162.690716]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2162.690720]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2162.690724]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.690728]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690734]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.690738]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690741] INFO: task kworker/0:4:2269 blocked for more than 120 seconds.
[ 2162.690746] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2162.690751] kworker/0:4     D 0000000000000000     0  2269      2 0x00000000
[ 2162.690757] Workqueue: events write_dirty_finish
[ 2162.690759]  ffff88299ff2bb30 0000000000000046 ffffffff81511b8c
ffffffff815137c0
[ 2162.690764]  ffff882f89b11990 ffff88299ff2bfd8 ffff88299ff2bfd8
ffff88299ff2bfd8
[ 2162.690768]  ffff882fa6726640 ffff882f89b11990 ffffffff815117a1
ffff882f89b11990
[ 2162.690773] Call Trace:
[ 2162.690777]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
[ 2162.690781]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690786]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
[ 2162.690791]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2162.690796]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 2162.690801]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 2162.690805]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 2162.690810]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
[ 2162.690814]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2162.690820]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
[ 2162.690824]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 2162.690829]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
[ 2162.690834]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
[ 2162.690838]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
[ 2162.690843]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2162.690848]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2162.690853]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2162.690856]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2162.690861]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2162.690866]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2162.690870]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0


-Neo

> [158645.058211] INFO: task kworker/3:2:668 blocked for more than 120
> seconds.
> [158645.059757] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158645.061531] kworker/3:2     D ffffffff8160f760     0   668      2
> 0x00000000
> [158645.063289] Workqueue: events bch_allocator_thread [bcache]
> [158645.064776]  ffff880c412d5c88 0000000000000046 ffff880c412d5fd8
> 0000000000012c80
> [158645.066677]  ffff880c412d4010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158645.068512]  ffff880c412d5fd8 0000000000012c80 ffff880c462098e0
> ffff880c48dd31c0
> [158645.070615] Call Trace:
> [158645.071208]  [<ffffffff81524874>] schedule+0x24/0x70
> [158645.072455]  [<ffffffff81524b69>] schedule_preempt_disabled+0x9/0x10
> [158645.074073]  [<ffffffff815236e4>] __mutex_lock_slowpath+0x194/0x240
> [158645.075621]  [<ffffffff81522f1e>] mutex_lock+0x1e/0x40
> [158645.076960]  [<ffffffffa01e1665>] bch_allocator_thread+0x125/0x650
> [bcache]
> [158645.078552]  [<ffffffff81070ad0>] ? wake_up_bit+0x40/0x40
> [158645.079803]  [<ffffffff81069661>] process_one_work+0x171/0x410
> [158645.081119]  [<ffffffff8106aabf>] worker_thread+0x11f/0x3e0
> [158645.082396]  [<ffffffff8106a9a0>] ? manage_workers+0x160/0x160
> [158645.083853]  [<ffffffff81070326>] kthread+0xc6/0xd0
> [158645.085164]  [<ffffffff81070260>] ? kthread_parkme+0x20/0x20
> [158645.086614]  [<ffffffff81526a6c>] ret_from_fork+0x7c/0xb0
> [158645.087864]  [<ffffffff81070260>] ? kthread_parkme+0x20/0x20
> [158645.089148] INFO: task ceph-osd:3691 blocked for more than 120 seconds.
> [158645.090652] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158645.092434] ceph-osd        D ffffffff8160f760     0  3691      1
> 0x00000000
> [158645.094237]  ffff880c31547d38 0000000000000086 ffff880c31547fd8
> 0000000000012c80
> [158645.096076]  ffff880c31546010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158645.097881]  ffff880c31547fd8 0000000000012c80 ffff880c3832b1c0
> ffff880c48dee380
> [158645.099735] Call Trace:
> [158645.100302]  [<ffffffff81524874>] schedule+0x24/0x70
> [158645.101427]  [<ffffffff81522bbd>] schedule_timeout+0x16d/0x200
> [158645.102759]  [<ffffffff81068eba>] ? __queue_delayed_work+0xaa/0x1a0
> [158645.104303]  [<ffffffff81068d19>] ? try_to_grab_pending+0x109/0x190
> [158645.105714]  [<ffffffff815251e5>] wait_for_completion+0x95/0x110
> [158645.107091]  [<ffffffff8107fd00>] ? try_to_wake_up+0x2a0/0x2a0
> [158645.108433]  [<ffffffff81167797>] ? bdi_queue_work+0x77/0xc0
> [158645.109702]  [<ffffffff81167863>] writeback_inodes_sb_nr+0x83/0xb0
> [158645.111107]  [<ffffffff811678ea>] writeback_inodes_sb+0x5a/0x70
> [158645.112452]  [<ffffffff8116dd0a>] __sync_filesystem+0x4a/0x50
> [158645.113810]  [<ffffffff8116dd42>] sync_filesystem+0x32/0x60
> [158645.115136]  [<ffffffff8116ddc0>] SyS_syncfs+0x50/0x90
> [158645.116308]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> [158645.117654] INFO: task ceph-osd:3699 blocked for more than 120 seconds.
> [158645.119153] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158645.120909] ceph-osd        D ffffffff8160f760     0  3699      1
> 0x00000000
> [158645.122563]  ffff880c3845b790 0000000000000086 ffff880c3845bfd8
> 0000000000012c80
> [158645.124468]  ffff880c3845a010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158645.170846]  ffff880c3845bfd8 0000000000012c80 ffff880c42f7b1c0
> ffff880c48dee380
> [158645.217702] Call Trace:
> [158645.262627]  [<ffffffff81524874>] schedule+0x24/0x70
> [158645.307261]  [<ffffffff81525d7d>] rwsem_down_read_failed+0x9d/0xe5
> [158645.351755]  [<ffffffff812aa0a4>] call_rwsem_down_read_failed+0x14/0x30
> [158645.395832]  [<ffffffff81523a42>] ? down_read+0x12/0x20
> [158645.438918]  [<ffffffffa01f1d62>] btree_read_async+0xa2/0x1a0 [bcache]
> [158645.482648]  [<ffffffffa01feb73>] closure_queue+0x43/0x60 [bcache]
> [158645.527144]  [<ffffffffa01f2903>] T.1050+0x63/0x70 [bcache]
> [158645.570204]  [<ffffffffa01f46ea>] cached_dev_make_request+0x20a/0x350
> [bcache]
> [158645.614751]  [<ffffffff81281952>] generic_make_request+0xc2/0x100
> [158645.658722]  [<ffffffff812819f7>] submit_bio+0x67/0x130
> [158645.702390]  [<ffffffff8116f5f3>] _submit_bh+0x143/0x200
> [158645.745862]  [<ffffffff8116f6bb>] submit_bh+0xb/0x10
> [158645.788846]  [<ffffffff81170826>] ll_rw_block+0xa6/0xb0
> [158645.831263]  [<ffffffff8117275f>] __block_write_begin+0x26f/0x530
> [158645.874533]  [<ffffffff811e90c0>] ? xfs_get_blocks_direct+0x20/0x20
> [158645.917967]  [<ffffffff810e6d6f>] ?
> grab_cache_page_write_begin+0x9f/0xd0
> [158645.960801]  [<ffffffff811e809f>] xfs_vm_write_begin+0x5f/0xd0
> [158646.004157]  [<ffffffff810e521a>] ?
> iov_iter_copy_from_user_atomic+0xea/0x150
> [158646.048422]  [<ffffffff810e561a>] generic_perform_write+0xca/0x200
> [158646.093424]  [<ffffffff810e57af>] generic_file_buffered_write+0x5f/0x90
> [158646.142867]  [<ffffffff811f02e5>] xfs_file_buffered_aio_write+0xf5/0x180
> [158646.187998]  [<ffffffff811f043e>] xfs_file_aio_write+0xce/0x150
> [158646.230793]  [<ffffffff8114acfd>] ? path_put+0x1d/0x30
> [158646.272575]  [<ffffffff811407f8>] do_sync_readv_writev+0x68/0xa0
> [158646.314299]  [<ffffffff811420c2>] do_readv_writev+0xf2/0x2e0
> [158646.356620]  [<ffffffff811f0370>] ?
> xfs_file_buffered_aio_write+0x180/0x180
> [158646.398982]  [<ffffffff81140830>] ? do_sync_readv_writev+0xa0/0xa0
> [158646.440790]  [<ffffffff811422ee>] vfs_writev+0x3e/0x60
> [158646.482174]  [<ffffffff8114243a>] SyS_writev+0x5a/0xc0
> [158646.524316]  [<ffffffff81141143>] ? SyS_lseek+0x53/0x80
> [158646.565544]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> [158646.608015] INFO: task ceph-osd:3700 blocked for more than 120 seconds.
> [158646.650176] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158646.693338] ceph-osd        D ffffffff8160f760     0  3700      1
> 0x00000000
> [158646.737144]  ffff880c35da7790 0000000000000086 ffff880c35da7fd8
> 0000000000012c80
> [158646.781401]  ffff880c35da6010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158646.826639]  ffff880c35da7fd8 0000000000012c80 ffff880c42f7caa0
> ffffffff81a10420
> [158646.871873] Call Trace:
> [158646.916272]  [<ffffffff81524874>] schedule+0x24/0x70
> [158646.961209]  [<ffffffff81525d7d>] rwsem_down_read_failed+0x9d/0xe5
> [158647.006594]  [<ffffffff812aa0a4>] call_rwsem_down_read_failed+0x14/0x30
> [158647.052053]  [<ffffffff81523a42>] ? down_read+0x12/0x20
> [158647.097154]  [<ffffffffa01f1d62>] btree_read_async+0xa2/0x1a0 [bcache]
> [158647.140916]  [<ffffffffa01feb73>] closure_queue+0x43/0x60 [bcache]
> [158647.184914]  [<ffffffffa01f2903>] T.1050+0x63/0x70 [bcache]
> [158647.228652]  [<ffffffffa01f46ea>] cached_dev_make_request+0x20a/0x350
> [bcache]
> [158647.272936]  [<ffffffff81281952>] generic_make_request+0xc2/0x100
> [158647.316736]  [<ffffffff812819f7>] submit_bio+0x67/0x130
> [158647.360750]  [<ffffffff8116f5f3>] _submit_bh+0x143/0x200
> [158647.407208]  [<ffffffff8116f6bb>] submit_bh+0xb/0x10
> [158647.449859]  [<ffffffff81170826>] ll_rw_block+0xa6/0xb0
> [158647.492521]  [<ffffffff8117275f>] __block_write_begin+0x26f/0x530
> [158647.535373]  [<ffffffff811e90c0>] ? xfs_get_blocks_direct+0x20/0x20
> [158647.579262]  [<ffffffff810e6d6f>] ?
> grab_cache_page_write_begin+0x9f/0xd0
> [158647.627839]  [<ffffffff811e809f>] xfs_vm_write_begin+0x5f/0xd0
> [158647.675609]  [<ffffffff810e51af>] ?
> iov_iter_copy_from_user_atomic+0x7f/0x150
> [158647.723418]  [<ffffffff810e561a>] generic_perform_write+0xca/0x200
> [158647.767945]  [<ffffffff810e57af>] generic_file_buffered_write+0x5f/0x90
> [158647.811264]  [<ffffffff811f02e5>] xfs_file_buffered_aio_write+0xf5/0x180
> [158647.855420]  [<ffffffff811f043e>] xfs_file_aio_write+0xce/0x150
> [158647.898677]  [<ffffffff8114acfd>] ? path_put+0x1d/0x30
> [158647.941845]  [<ffffffff811407f8>] do_sync_readv_writev+0x68/0xa0
> [158647.984976]  [<ffffffff811420c2>] do_readv_writev+0xf2/0x2e0
> [158648.027533]  [<ffffffff811f0370>] ?
> xfs_file_buffered_aio_write+0x180/0x180
> [158648.071360]  [<ffffffff81140830>] ? do_sync_readv_writev+0xa0/0xa0
> [158648.115227]  [<ffffffff811422ee>] vfs_writev+0x3e/0x60
> [158648.157775]  [<ffffffff8114243a>] SyS_writev+0x5a/0xc0
> [158648.199905]  [<ffffffff81141143>] ? SyS_lseek+0x53/0x80
> [158648.241889]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> [158648.284075] INFO: task ceph-osd:3781 blocked for more than 120 seconds.
> [158648.326973] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158648.371493] ceph-osd        D ffffffff8160f760     0  3781      1
> 0x00000000
> [158648.416060]  ffff880c38463770 0000000000000086 ffff880c38463fd8
> 0000000000012c80
> [158648.461454]  ffff880c38462010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158648.506047]  ffff880c38463fd8 0000000000012c80 ffff880c3784b1c0
> ffff880c48dd18e0
> [158648.550419] Call Trace:
> [158648.596187]  [<ffffffff81524874>] schedule+0x24/0x70
> [158648.641218]  [<ffffffff81525d7d>] rwsem_down_read_failed+0x9d/0xe5
> [158648.686533]  [<ffffffff812aa0a4>] call_rwsem_down_read_failed+0x14/0x30
> [158648.731382]  [<ffffffff81523a42>] ? down_read+0x12/0x20
> [158648.776221]  [<ffffffffa01f1d62>] btree_read_async+0xa2/0x1a0 [bcache]
> [158648.820360]  [<ffffffffa01feb73>] closure_queue+0x43/0x60 [bcache]
> [158648.864657]  [<ffffffffa01f2903>] T.1050+0x63/0x70 [bcache]
> [158648.913544]  [<ffffffffa01f46ea>] cached_dev_make_request+0x20a/0x350
> [bcache]
> [158648.959712]  [<ffffffff81281952>] generic_make_request+0xc2/0x100
> [158649.003388]  [<ffffffff812819f7>] submit_bio+0x67/0x130
> [158649.046907]  [<ffffffff811eac60>] xfs_buf_ioapply_map+0x180/0x1d0
> [158649.092278]  [<ffffffff811eadb7>] _xfs_buf_ioapply+0x107/0x150
> [158649.135841]  [<ffffffff811ec7ac>] ? _xfs_buf_read+0x2c/0x50
> [158649.179011]  [<ffffffff8124e2f1>] ? xfs_trans_read_buf_map+0x191/0x410
> [158649.222304]  [<ffffffff811ec23a>] xfs_buf_iorequest+0x4a/0xa0
> [158649.265927]  [<ffffffff811ec7ac>] _xfs_buf_read+0x2c/0x50
> [158649.309112]  [<ffffffff811ec873>] xfs_buf_read_map+0xa3/0xf0
> [158649.352526]  [<ffffffff8124e2f1>] xfs_trans_read_buf_map+0x191/0x410
> [158649.395566]  [<ffffffff8122260f>] xfs_da_read_buf+0xbf/0x220
> [158649.438050]  [<ffffffff812096e4>] xfs_attr3_leaf_read+0x24/0x60
> [158649.480825]  [<ffffffff8120688d>] xfs_attr_leaf_get+0x3d/0xf0
> [158649.523810]  [<ffffffff8120f826>] ? xfs_bmap_one_block+0x36/0xa0
> [158649.566863]  [<ffffffff81206b70>] xfs_attr_get_int+0x100/0x120
> [158649.611874]  [<ffffffff81206c2e>] xfs_attr_get+0x9e/0xc0
> [158649.654591]  [<ffffffff8120151e>] xfs_xattr_get+0x2e/0x50
> [158649.696779]  [<ffffffff81162458>] generic_getxattr+0x88/0x90
> [158649.738614]  [<ffffffff811629f7>] vfs_getxattr+0x67/0x80
> [158649.780161]  [<ffffffff811634d0>] getxattr+0xb0/0x1a0
> [158649.821541]  [<ffffffff81150dc4>] ? do_filp_open+0x44/0xa0
> [158649.863494]  [<ffffffff81163613>] SyS_fgetxattr+0x53/0x90
> [158649.904869]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> [158649.946609] INFO: task ceph-osd:3671 blocked for more than 120 seconds.
> [158649.988715] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158650.031328] ceph-osd        D ffffffff8160f760     0  3671      1
> 0x00000000
> [158650.074871]  ffff880c29a45790 0000000000000086 ffff880c29a45fd8
> 0000000000012c80
> [158650.122861]  ffff880c29a44010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158650.170457]  ffff880c29a45fd8 0000000000012c80 ffff880c35f86380
> ffff880c48dd6380
> [158650.213977] Call Trace:
> [158650.257133]  [<ffffffff81524874>] schedule+0x24/0x70
> [158650.301077]  [<ffffffff81525d7d>] rwsem_down_read_failed+0x9d/0xe5
> [158650.345435]  [<ffffffff812aa0a4>] call_rwsem_down_read_failed+0x14/0x30
> [158650.389838]  [<ffffffff81523a42>] ? down_read+0x12/0x20
> [158650.432773]  [<ffffffffa01f1d62>] btree_read_async+0xa2/0x1a0 [bcache]
> [158650.475565]  [<ffffffffa01feb73>] closure_queue+0x43/0x60 [bcache]
> [158650.518106]  [<ffffffffa01f2903>] T.1050+0x63/0x70 [bcache]
> [158650.560659]  [<ffffffffa01f46ea>] cached_dev_make_request+0x20a/0x350
> [bcache]
> [158650.605662]  [<ffffffff81281952>] generic_make_request+0xc2/0x100
> [158650.648411]  [<ffffffff812819f7>] submit_bio+0x67/0x130
> [158650.690988]  [<ffffffff8116f5f3>] _submit_bh+0x143/0x200
> [158650.732976]  [<ffffffff8116f6bb>] submit_bh+0xb/0x10
> [158650.774947]  [<ffffffff81170826>] ll_rw_block+0xa6/0xb0
> [158650.816820]  [<ffffffff8117275f>] __block_write_begin+0x26f/0x530
> [158650.858904]  [<ffffffff811e90c0>] ? xfs_get_blocks_direct+0x20/0x20
> [158650.900719]  [<ffffffff810e6d6f>] ?
> grab_cache_page_write_begin+0x9f/0xd0
> [158650.942587]  [<ffffffff811e809f>] xfs_vm_write_begin+0x5f/0xd0
> [158650.984196]  [<ffffffff810e51af>] ?
> iov_iter_copy_from_user_atomic+0x7f/0x150
> [158651.025732]  [<ffffffff810e561a>] generic_perform_write+0xca/0x200
> [158651.067449]  [<ffffffff810e57af>] generic_file_buffered_write+0x5f/0x90
> [158651.110731]  [<ffffffff811f02e5>] xfs_file_buffered_aio_write+0xf5/0x180
> [158651.152567]  [<ffffffff811f043e>] xfs_file_aio_write+0xce/0x150
> [158651.194708]  [<ffffffff8114acfd>] ? path_put+0x1d/0x30
> [158651.235999]  [<ffffffff811407f8>] do_sync_readv_writev+0x68/0xa0
> [158651.277149]  [<ffffffff811420c2>] do_readv_writev+0xf2/0x2e0
> [158651.318313]  [<ffffffff811f0370>] ?
> xfs_file_buffered_aio_write+0x180/0x180
> [158651.360353]  [<ffffffff81140830>] ? do_sync_readv_writev+0xa0/0xa0
> [158651.405056]  [<ffffffff811422ee>] vfs_writev+0x3e/0x60
> [158651.446600]  [<ffffffff8114243a>] SyS_writev+0x5a/0xc0
> [158651.487901]  [<ffffffff81141143>] ? SyS_lseek+0x53/0x80
> [158651.528541]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> [158651.569832] INFO: task ceph-osd:3672 blocked for more than 120 seconds.
> [158651.616630] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158651.665141] ceph-osd        D ffffffff8160f760     0  3672      1
> 0x00000000
> [158651.714329]  ffff880c29a47790 0000000000000086 ffff880c29a47fd8
> 0000000000012c80
> [158651.762559]  ffff880c29a46010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158651.807631]  ffff880c29a47fd8 0000000000012c80 ffff880c35f831c0
> ffff880c48dd18e0
> [158651.853027] Call Trace:
> [158651.897577]  [<ffffffff81524874>] schedule+0x24/0x70
> [158651.942740]  [<ffffffff81525d7d>] rwsem_down_read_failed+0x9d/0xe5
> [158651.988306]  [<ffffffff812aa0a4>] call_rwsem_down_read_failed+0x14/0x30
> [158652.033122]  [<ffffffff81523a42>] ? down_read+0x12/0x20
> [158652.077390]  [<ffffffffa01f1d62>] btree_read_async+0xa2/0x1a0 [bcache]
> [158652.122399]  [<ffffffffa01feb73>] closure_queue+0x43/0x60 [bcache]
> [158652.166743]  [<ffffffffa01f2903>] T.1050+0x63/0x70 [bcache]
> [158652.210570]  [<ffffffffa01f46ea>] cached_dev_make_request+0x20a/0x350
> [bcache]
> [158652.254983]  [<ffffffff81281952>] generic_make_request+0xc2/0x100
> [158652.298983]  [<ffffffff812819f7>] submit_bio+0x67/0x130
> [158652.342402]  [<ffffffff8116f5f3>] _submit_bh+0x143/0x200
> [158652.386453]  [<ffffffff8116f6bb>] submit_bh+0xb/0x10
> [158652.429114]  [<ffffffff81170826>] ll_rw_block+0xa6/0xb0
> [158652.471733]  [<ffffffff8117275f>] __block_write_begin+0x26f/0x530
> [158652.514128]  [<ffffffff811e90c0>] ? xfs_get_blocks_direct+0x20/0x20
> [158652.556817]  [<ffffffff810e6d6f>] ?
> grab_cache_page_write_begin+0x9f/0xd0
> [158652.600689]  [<ffffffff811e809f>] xfs_vm_write_begin+0x5f/0xd0
> [158652.643876]  [<ffffffff810e561a>] generic_perform_write+0xca/0x200
> [158652.686409]  [<ffffffff810e57af>] generic_file_buffered_write+0x5f/0x90
> [158652.728637]  [<ffffffff811f02e5>] xfs_file_buffered_aio_write+0xf5/0x180
> [158652.771637]  [<ffffffff811f043e>] xfs_file_aio_write+0xce/0x150
> [158652.814522]  [<ffffffff8114acfd>] ? path_put+0x1d/0x30
> [158652.857755]  [<ffffffff811407f8>] do_sync_readv_writev+0x68/0xa0
> [158652.903827]  [<ffffffff811420c2>] do_readv_writev+0xf2/0x2e0
> [158652.951211]  [<ffffffff811f0370>] ?
> xfs_file_buffered_aio_write+0x180/0x180
> [158652.998001]  [<ffffffff81140830>] ? do_sync_readv_writev+0xa0/0xa0
> [158653.040667]  [<ffffffff811422ee>] vfs_writev+0x3e/0x60
> [158653.082544]  [<ffffffff8114243a>] SyS_writev+0x5a/0xc0
> [158653.125383]  [<ffffffff81141143>] ? SyS_lseek+0x53/0x80
> [158653.167445]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> [158653.209187] INFO: task ceph-osd:3665 blocked for more than 120 seconds.
> [158653.251572] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158653.295280] ceph-osd        D ffffffff8160f760     0  3665      1
> 0x00000000
> [158653.339222]  ffff880c28c85c28 0000000000000086 ffff880c28c85fd8
> 0000000000012c80
> [158653.384398]  ffff880c28c84010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158653.428586]  ffff880c28c85fd8 0000000000012c80 ffff880c36836380
> ffff880c48dee380
> [158653.472639] Call Trace:
> [158653.516082]  [<ffffffff810e60f0>] ? __lock_page+0x70/0x70
> [158653.560602]  [<ffffffff81524874>] schedule+0x24/0x70
> [158653.606175]  [<ffffffff81524947>] io_schedule+0x87/0xd0
> [158653.650351]  [<ffffffff810e60f9>] sleep_on_page+0x9/0x10
> [158653.694926]  [<ffffffff81522e47>] __wait_on_bit+0x57/0x80
> [158653.737743]  [<ffffffff810e5c1c>] ? find_get_pages_tag+0xcc/0x180
> [158653.780323]  [<ffffffff810e630e>] wait_on_page_bit+0x6e/0x80
> [158653.822456]  [<ffffffff81070b10>] ? autoremove_wake_function+0x40/0x40
> [158653.865849]  [<ffffffff810f26c0>] ? pagevec_lookup_tag+0x20/0x30
> [158653.908405]  [<ffffffff810e684f>] filemap_fdatawait_range+0x10f/0x1b0
> [158653.950566]  [<ffffffff810e6913>] filemap_fdatawait+0x23/0x30
> [158653.992295]  [<ffffffff81166ea5>] wait_sb_inodes+0xb5/0x110
> [158654.034148]  [<ffffffff81167a8c>] sync_inodes_sb+0x9c/0xd0
> [158654.075311]  [<ffffffff8116dcd6>] __sync_filesystem+0x16/0x50
> [158654.118922]  [<ffffffff8116dd53>] sync_filesystem+0x43/0x60
> [158654.164698]  [<ffffffff8116ddc0>] SyS_syncfs+0x50/0x90
> [158654.206230]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> [158654.246908] INFO: task ceph-osd:3685 blocked for more than 120 seconds.
> [158654.287777] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158654.329555] ceph-osd        D ffffffff8160f760     0  3685      1
> 0x00000000
> [158654.372741]  ffff880c296c78d8 0000000000000086 ffff880c296c7fd8
> 0000000000012c80
> [158654.415985]  ffff880c296c6010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158654.459154]  ffff880c296c7fd8 0000000000012c80 ffff880c2ab198e0
> ffff880c48dd6380
> [158654.502381] Call Trace:
> [158654.545034]  [<ffffffff811704a0>] ? __wait_on_buffer+0x30/0x30
> [158654.588704]  [<ffffffff81524874>] schedule+0x24/0x70
> [158654.632054]  [<ffffffff81524947>] io_schedule+0x87/0xd0
> [158654.675323]  [<ffffffff811704a9>] sleep_on_buffer+0x9/0x10
> [158654.718565]  [<ffffffff81522e47>] __wait_on_bit+0x57/0x80
> [158654.761192]  [<ffffffff811704a0>] ? __wait_on_buffer+0x30/0x30
> [158654.804099]  [<ffffffff81522ee3>] out_of_line_wait_on_bit+0x73/0x90
> [158654.847575]  [<ffffffff81070b10>] ? autoremove_wake_function+0x40/0x40
> [158654.891283]  [<ffffffff8116f6bb>] ? submit_bh+0xb/0x10
> [158654.934496]  [<ffffffff81170496>] __wait_on_buffer+0x26/0x30
> [158654.977642]  [<ffffffff81172873>] __block_write_begin+0x383/0x530
> [158655.020551]  [<ffffffff811e90c0>] ? xfs_get_blocks_direct+0x20/0x20
> [158655.063484]  [<ffffffff810e6d6f>] ?
> grab_cache_page_write_begin+0x9f/0xd0
> [158655.107048]  [<ffffffff811e809f>] xfs_vm_write_begin+0x5f/0xd0
> [158655.150574]  [<ffffffff810e51af>] ?
> iov_iter_copy_from_user_atomic+0x7f/0x150
> [158655.195879]  [<ffffffff810e561a>] generic_perform_write+0xca/0x200
> [158655.239777]  [<ffffffff810e57af>] generic_file_buffered_write+0x5f/0x90
> [158655.283361]  [<ffffffff811f02e5>] xfs_file_buffered_aio_write+0xf5/0x180
> [158655.326698]  [<ffffffff811f043e>] xfs_file_aio_write+0xce/0x150
> [158655.368954]  [<ffffffff8114acfd>] ? path_put+0x1d/0x30
> [158655.410567]  [<ffffffff811407f8>] do_sync_readv_writev+0x68/0xa0
> [158655.452505]  [<ffffffff811420c2>] do_readv_writev+0xf2/0x2e0
> [158655.494489]  [<ffffffff811f0370>] ?
> xfs_file_buffered_aio_write+0x180/0x180
> [158655.536230]  [<ffffffff81140830>] ? do_sync_readv_writev+0xa0/0xa0
> [158655.577645]  [<ffffffff811422ee>] vfs_writev+0x3e/0x60
> [158655.619292]  [<ffffffff8114243a>] SyS_writev+0x5a/0xc0
> [158655.660740]  [<ffffffff81141143>] ? SyS_lseek+0x53/0x80
> [158655.702619]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> [158655.744381] INFO: task ceph-osd:3686 blocked for more than 120 seconds.
> [158655.786604] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> [158655.829720] ceph-osd        D ffffffff8160f760     0  3686      1
> 0x00000000
> [158655.873724]  ffff880c298118d8 0000000000000086 ffff880c29811fd8
> 0000000000012c80
> [158655.920739]  ffff880c29810010 0000000000012c80 0000000000012c80
> 0000000000012c80
> [158655.964463]  ffff880c29811fd8 0000000000012c80 ffff880c2ab1b1c0
> ffff880c48dd18e0
> [158656.008690] Call Trace:
> [158656.057983]  [<ffffffff811704a0>] ? __wait_on_buffer+0x30/0x30
> [158656.107852]  [<ffffffff81524874>] schedule+0x24/0x70
> [158656.157651]  [<ffffffff81524947>] io_schedule+0x87/0xd0
> [158656.203807]  [<ffffffff811704a9>] sleep_on_buffer+0x9/0x10
> [158656.248966]  [<ffffffff81522e47>] __wait_on_bit+0x57/0x80
> [158656.293044]  [<ffffffff811704a0>] ? __wait_on_buffer+0x30/0x30
> [158656.337387]  [<ffffffff81522ee3>] out_of_line_wait_on_bit+0x73/0x90
> [158656.381173]  [<ffffffff81070b10>] ? autoremove_wake_function+0x40/0x40
> [158656.424233]  [<ffffffff8116f6bb>] ? submit_bh+0xb/0x10
> [158656.466674]  [<ffffffff81170496>] __wait_on_buffer+0x26/0x30
> [158656.509110]  [<ffffffff81172873>] __block_write_begin+0x383/0x530
> [158656.551775]  [<ffffffff811e90c0>] ? xfs_get_blocks_direct+0x20/0x20
> [158656.594479]  [<ffffffff810e6d6f>] ?
> grab_cache_page_write_begin+0x9f/0xd0
> [158656.637101]  [<ffffffff811e809f>] xfs_vm_write_begin+0x5f/0xd0
> [158656.679179]  [<ffffffff810e51af>] ?
> iov_iter_copy_from_user_atomic+0x7f/0x150
> [158656.722646]  [<ffffffff810e561a>] generic_perform_write+0xca/0x200
> [158656.765810]  [<ffffffff810e57af>] generic_file_buffered_write+0x5f/0x90
> [158656.809135]  [<ffffffff811f02e5>] xfs_file_buffered_aio_write+0xf5/0x180
> [158656.852315]  [<ffffffff811f043e>] xfs_file_aio_write+0xce/0x150
> [158656.895632]  [<ffffffff8114acfd>] ? path_put+0x1d/0x30
> [158656.938289]  [<ffffffff811407f8>] do_sync_readv_writev+0x68/0xa0
> [158656.980809]  [<ffffffff811420c2>] do_readv_writev+0xf2/0x2e0
> [158657.023069]  [<ffffffff811f0370>] ?
> xfs_file_buffered_aio_write+0x180/0x180
> [158657.065997]  [<ffffffff81140830>] ? do_sync_readv_writev+0xa0/0xa0
> [158657.109884]  [<ffffffff811422ee>] vfs_writev+0x3e/0x60
> [158657.152314]  [<ffffffff8114243a>] SyS_writev+0x5a/0xc0
> [158657.194674]  [<ffffffff81141143>] ? SyS_lseek+0x53/0x80
> [158657.236672]  [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
>
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
