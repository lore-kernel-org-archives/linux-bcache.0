From: Igor Pavlikevich <ipavlikevich@gmail.com>
Subject: bcache freeze with latest patches
Date: Fri, 29 Aug 2014 11:12:29 +0400
Message-ID: <CA+O_+Ewjq7STXoq2f0V3F5-=nmpiWQ2ny2WPpt2SkHNq6Kt6iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61462 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaH2HMa (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 29 Aug 2014 03:12:30 -0400
Received: by mail-ig0-f177.google.com with SMTP id r10so2176856igi.4
        for <linux-bcache@vger.kernel.org>; Fri, 29 Aug 2014 00:12:29 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

while using debian testing kernel 3.14.13-2 with backported patches up
to d46cc754c0f0ac8cf9016d256dccd1a8e78ffbec ( bcache: add
kthread_wait_freezable() ) I see this output in dmesg/netconsole.
System is running Xen, using two md raid10 with separate SSD cache
each in writethrough mode.


Aug 18 01:30:00 [ 2730.772893] INFO: task kworker/2:1:585 blocked for
more than 120 seconds.
Aug 18 01:30:00 [ 2730.773019]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.773097] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.773196] kworker/2:1     D
Aug 18 01:30:00 [ 2730.773420] Workqueue: bcache bch_data_insert_keys [bcache]
Aug 18 01:30:00 [ 2730.774510] Call Trace:
Aug 18 01:30:00 [ 2730.774596]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.774683]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.774776]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.774878]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.774985]  [<ffffffffa020a335>] ?
__bch_btree_map_nodes+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.775077]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.775184]  [<ffffffffa020a488>] ?
bch_btree_insert+0xd8/0x140 [bcache]
Aug 18 01:30:00 [ 2730.775273]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.775363]  [<ffffffffa02115df>] ?
bch_data_insert_keys+0x2f/0x140 [bcache]
Aug 18 01:30:00 [ 2730.775451]  [<ffffffff81079bdd>] ?
process_one_work+0x16d/0x420
Aug 18 01:30:00 [ 2730.775533]  [<ffffffff8107a7e6>] ? worker_thread+0x116/0x3b0
Aug 18 01:30:00 [ 2730.775615]  [<ffffffff8107a6d0>] ?
rescuer_thread+0x380/0x380
Aug 18 01:30:00 [ 2730.775698]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.775778]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.775863]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.775962]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.776045] INFO: task kworker/6:1:592 blocked for
more than 120 seconds.
Aug 18 01:30:00 [ 2730.776126]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.776200] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.776297] kworker/6:1     D
Aug 18 01:30:00 [ 2730.776490] Workqueue: bcache bch_data_insert_keys [bcache]
Aug 18 01:30:00 [ 2730.777780] Call Trace:
Aug 18 01:30:00 [ 2730.777881]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.777986]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.778109]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.778230]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.778344]  [<ffffffffa020a335>] ?
__bch_btree_map_nodes+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.778451]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.778559]  [<ffffffffa020a488>] ?
bch_btree_insert+0xd8/0x140 [bcache]
Aug 18 01:30:00 [ 2730.778644]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.778733]  [<ffffffffa02115df>] ?
bch_data_insert_keys+0x2f/0x140 [bcache]
Aug 18 01:30:00 [ 2730.778825]  [<ffffffff81079bdd>] ?
process_one_work+0x16d/0x420
Aug 18 01:30:00 [ 2730.778919]  [<ffffffff8107a7e6>] ? worker_thread+0x116/0x3b0
Aug 18 01:30:00 [ 2730.779003]  [<ffffffff8107a6d0>] ?
rescuer_thread+0x380/0x380
Aug 18 01:30:00 [ 2730.779085]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.779164]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.779247]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.779328]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.779410] INFO: task kworker/8:1:596 blocked for
more than 120 seconds.
Aug 18 01:30:00 [ 2730.779490]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.779565] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.779667] kworker/8:1     D
Aug 18 01:30:00 [ 2730.779888] Workqueue: bcache bch_data_insert_keys [bcache]
Aug 18 01:30:00 [ 2730.780724] Call Trace:
Aug 18 01:30:00 [ 2730.780785]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.780878]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.780949]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.781030]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.781095]  [<ffffffffa020a335>] ?
__bch_btree_map_nodes+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.781164]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.781247]  [<ffffffffa020a488>] ?
bch_btree_insert+0xd8/0x140 [bcache]
Aug 18 01:30:00 [ 2730.781521]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.781612]  [<ffffffffa02115df>] ?
bch_data_insert_keys+0x2f/0x140 [bcache]
Aug 18 01:30:00 [ 2730.781678]  [<ffffffff81079bdd>] ?
process_one_work+0x16d/0x420
Aug 18 01:30:00 [ 2730.781746]  [<ffffffff8107a7e6>] ? worker_thread+0x116/0x3b0
Aug 18 01:30:00 [ 2730.781816]  [<ffffffff8107a6d0>] ?
rescuer_thread+0x380/0x380
Aug 18 01:30:00 [ 2730.781884]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.781945]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.782007]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.782069]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.782132] INFO: task kworker/10:1:600 blocked for
more than 120 seconds.
Aug 18 01:30:00 [ 2730.782195]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.783454] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.783553] kworker/10:1    D
Aug 18 01:30:00 [ 2730.783761] Workqueue: bcache bch_data_insert_keys [bcache]
Aug 18 01:30:00 [ 2730.784938] Call Trace:
Aug 18 01:30:00 [ 2730.785025]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.785124]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.785224]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.785329]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.785432]  [<ffffffffa020a335>] ?
__bch_btree_map_nodes+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.785531]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.785643]  [<ffffffffa020a488>] ?
bch_btree_insert+0xd8/0x140 [bcache]
Aug 18 01:30:00 [ 2730.785740]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.785853]  [<ffffffffa02115df>] ?
bch_data_insert_keys+0x2f/0x140 [bcache]
Aug 18 01:30:00 [ 2730.785942]  [<ffffffff81079bdd>] ?
process_one_work+0x16d/0x420
Aug 18 01:30:00 [ 2730.786033]  [<ffffffff8107a7e6>] ? worker_thread+0x116/0x3b0
Aug 18 01:30:00 [ 2730.786130]  [<ffffffff8107a6d0>] ?
rescuer_thread+0x380/0x380
Aug 18 01:30:00 [ 2730.786195]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.786292]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.786386]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.786502]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.786600] INFO: task kworker/12:2:720 blocked for
more than 120 seconds.
Aug 18 01:30:00 [ 2730.786695]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.786773] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.786871] kworker/12:2    D
Aug 18 01:30:00 [ 2730.787065] Workqueue: bcache bch_data_insert_keys [bcache]
Aug 18 01:30:00 [ 2730.788164] Call Trace:
Aug 18 01:30:00 [ 2730.788240]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.788323]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.788415]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.788530]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.788641]  [<ffffffffa020a335>] ?
__bch_btree_map_nodes+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.788748]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.788923]  [<ffffffffa020a488>] ?
bch_btree_insert+0xd8/0x140 [bcache]
Aug 18 01:30:00 [ 2730.789015]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.789105]  [<ffffffffa02115df>] ?
bch_data_insert_keys+0x2f/0x140 [bcache]
Aug 18 01:30:00 [ 2730.789191]  [<ffffffff81079bdd>] ?
process_one_work+0x16d/0x420
Aug 18 01:30:00 [ 2730.789273]  [<ffffffff8107a7e6>] ? worker_thread+0x116/0x3b0
Aug 18 01:30:00 [ 2730.789355]  [<ffffffff8107a6d0>] ?
rescuer_thread+0x380/0x380
Aug 18 01:30:00 [ 2730.789435]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.789514]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.789619]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.789704]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.789787] INFO: task bcache_gc:738 blocked for
more than 120 seconds.
Aug 18 01:30:00 [ 2730.789866]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.789941] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.790037] bcache_gc       D
Aug 18 01:30:00 [ 2730.791224] Call Trace:
Aug 18 01:30:00 [ 2730.791315]  [<ffffffff814c7f90>] ?
schedule_preempt_disabled+0x20/0x70
Aug 18 01:30:00 [ 2730.791398]  [<ffffffff814c9a03>] ?
__mutex_lock_slowpath+0x133/0x1b0
Aug 18 01:30:00 [ 2730.791483]  [<ffffffff814c9a96>] ? mutex_lock+0x16/0x25
Aug 18 01:30:00 [ 2730.791577]  [<ffffffffa020534d>] ?
btree_node_free+0x2d/0xf0 [bcache]
Aug 18 01:30:00 [ 2730.791683]  [<ffffffffa0209452>] ?
btree_gc_coalesce.isra.27+0x532/0x710 [bcache]
Aug 18 01:30:00 [ 2730.791790]  [<ffffffffa02047f0>] ?
bch_ptr_invalid+0x10/0x10 [bcache]
Aug 18 01:30:00 [ 2730.791878]  [<ffffffffa02044ab>] ?
bch_btree_iter_next_filter+0x1bb/0x350 [bcache]
Aug 18 01:30:00 [ 2730.791985]  [<ffffffffa0204d50>] ?
btree_gc_count_keys+0x40/0x50 [bcache]
Aug 18 01:30:00 [ 2730.792075]  [<ffffffffa0209914>] ?
btree_gc_recurse+0x1b4/0x300 [bcache]
Aug 18 01:30:00 [ 2730.792164]  [<ffffffffa02044ab>] ?
bch_btree_iter_next_filter+0x1bb/0x350 [bcache]
Aug 18 01:30:00 [ 2730.792271]  [<ffffffffa0209fc7>] ?
bch_btree_gc+0x3d7/0x560 [bcache]
Aug 18 01:30:00 [ 2730.792355]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.792443]  [<ffffffffa020a180>] ?
bch_gc_thread+0x30/0x120 [bcache]
Aug 18 01:30:00 [ 2730.792539]  [<ffffffffa020a150>] ?
bch_btree_gc+0x560/0x560 [bcache]
Aug 18 01:30:00 [ 2730.792623]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.792702]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.792784]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.792891]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.792983] INFO: task kworker/4:2:1581 blocked for
more than 120 seconds.
Aug 18 01:30:00 [ 2730.793063]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.793138] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.793234] kworker/4:2     D
Aug 18 01:30:00 [ 2730.793429] Workqueue: bcache bch_data_insert_keys [bcache]
Aug 18 01:30:00 [ 2730.794492] Call Trace:
Aug 18 01:30:00 [ 2730.794574]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.794657]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.794763]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.794864]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.794949]  [<ffffffffa020a335>] ?
__bch_btree_map_nodes+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.795038]  [<ffffffffa0209bb0>] ?
bch_btree_insert_check_key+0x150/0x150 [bcache]
Aug 18 01:30:00 [ 2730.795144]  [<ffffffffa020a488>] ?
bch_btree_insert+0xd8/0x140 [bcache]
Aug 18 01:30:00 [ 2730.795228]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.795313]  [<ffffffffa02115df>] ?
bch_data_insert_keys+0x2f/0x140 [bcache]
Aug 18 01:30:00 [ 2730.795422]  [<ffffffff81079bdd>] ?
process_one_work+0x16d/0x420
Aug 18 01:30:00 [ 2730.795508]  [<ffffffff8107a7e6>] ? worker_thread+0x116/0x3b0
Aug 18 01:30:00 [ 2730.795592]  [<ffffffff8107a6d0>] ?
rescuer_thread+0x380/0x380
Aug 18 01:30:00 [ 2730.795676]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.795755]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.795839]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.795919]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.796157] INFO: task blkback.17.hda:1357 blocked
for more than 120 seconds.
Aug 18 01:30:00 [ 2730.796238]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.796312] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.796421] blkback.17.hda  D
Aug 18 01:30:00 [ 2730.797823] Call Trace:
Aug 18 01:30:00 [ 2730.797905]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.797990]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.798092]  [<ffffffffa0210a50>] ?
cached_dev_congested+0x160/0x160 [bcache]
Aug 18 01:30:00 [ 2730.798177]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.798265]  [<ffffffffa020a5b5>] ?
bch_btree_map_keys+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.798357]  [<ffffffffa0210a50>] ?
cached_dev_congested+0x160/0x160 [bcache]
Aug 18 01:30:00 [ 2730.798475]  [<ffffffffa02114cc>] ?
cache_lookup+0xdc/0x1c0 [bcache]
Aug 18 01:30:00 [ 2730.798564]  [<ffffffffa0213602>] ?
cached_dev_make_request+0xcc2/0xee0 [bcache]
Aug 18 01:30:00 [ 2730.798669]  [<ffffffff81255c98>] ?
generic_make_request+0xa8/0xf0
Aug 18 01:30:00 [ 2730.798752]  [<ffffffff81255d3c>] ? submit_bio+0x5c/0x120
Aug 18 01:30:00 [ 2730.798835]  [<ffffffffa051e6c0>] ?
dispatch_rw_block_io+0x510/0x8c0 [xen_blkback]
Aug 18 01:30:00 [ 2730.798936]  [<ffffffffa051ec6c>] ?
__do_block_io_op+0x1fc/0x650 [xen_blkback]
Aug 18 01:30:00 [ 2730.799088]  [<ffffffff8106bea4>] ?
try_to_del_timer_sync+0x44/0x60
Aug 18 01:30:00 [ 2730.799174]  [<ffffffff8106bf0a>] ? del_timer_sync+0x4a/0x60
Aug 18 01:30:00 [ 2730.799261]  [<ffffffffa051f3e0>] ?
xen_blkif_schedule+0xd0/0x830 [xen_blkback]
Aug 18 01:30:00 [ 2730.799388]  [<ffffffff81089621>] ?
finish_task_switch+0x41/0xf0
Aug 18 01:30:00 [ 2730.799477]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.799561]  [<ffffffffa051f310>] ?
xen_blkif_be_int+0x30/0x30 [xen_blkback]
Aug 18 01:30:00 [ 2730.799650]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.799733]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.799816]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.799911]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.800027] INFO: task blkback.19.hda:2601 blocked
for more than 120 seconds.
Aug 18 01:30:00 [ 2730.800177]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.800253] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.800368] blkback.19.hda  D
Aug 18 01:30:00 [ 2730.801516] Call Trace:
Aug 18 01:30:00 [ 2730.801574]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.801638]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.801709]  [<ffffffffa0210a50>] ?
cached_dev_congested+0x160/0x160 [bcache]
Aug 18 01:30:00 [ 2730.801782]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.801861]  [<ffffffffa020a5b5>] ?
bch_btree_map_keys+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.801936]  [<ffffffffa0210a50>] ?
cached_dev_congested+0x160/0x160 [bcache]
Aug 18 01:30:00 [ 2730.803244]  [<ffffffffa02114cc>] ?
cache_lookup+0xdc/0x1c0 [bcache]
Aug 18 01:30:00 [ 2730.803315]  [<ffffffffa0213602>] ?
cached_dev_make_request+0xcc2/0xee0 [bcache]
Aug 18 01:30:00 [ 2730.803403]  [<ffffffff81255c98>] ?
generic_make_request+0xa8/0xf0
Aug 18 01:30:00 [ 2730.803467]  [<ffffffff81255d3c>] ? submit_bio+0x5c/0x120
Aug 18 01:30:00 [ 2730.803529]  [<ffffffffa051e6c0>] ?
dispatch_rw_block_io+0x510/0x8c0 [xen_blkback]
Aug 18 01:30:00 [ 2730.803610]  [<ffffffffa051ec6c>] ?
__do_block_io_op+0x1fc/0x650 [xen_blkback]
Aug 18 01:30:00 [ 2730.803690]  [<ffffffff8106bea4>] ?
try_to_del_timer_sync+0x44/0x60
Aug 18 01:30:00 [ 2730.803753]  [<ffffffff8106bf0a>] ? del_timer_sync+0x4a/0x60
Aug 18 01:30:00 [ 2730.803816]  [<ffffffffa051f3e0>] ?
xen_blkif_schedule+0xd0/0x830 [xen_blkback]
Aug 18 01:30:00 [ 2730.803896]  [<ffffffff81089621>] ?
finish_task_switch+0x41/0xf0
Aug 18 01:30:00 [ 2730.803959]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.804023]  [<ffffffffa051f310>] ?
xen_blkif_be_int+0x30/0x30 [xen_blkback]
Aug 18 01:30:00 [ 2730.804087]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.804149]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.804220]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.804283]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.804354] INFO: task blkback.24.xvda:4653 blocked
for more than 120 seconds.
Aug 18 01:30:00 [ 2730.804433]       Not tainted 3.14-2-amd64 #1
Aug 18 01:30:00 [ 2730.804491] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 18 01:30:00 [ 2730.804571] blkback.24.xvda D
Aug 18 01:30:00 [ 2730.805422] Call Trace:
Aug 18 01:30:00 [ 2730.805480]  [<ffffffff814ca39d>] ?
rwsem_down_read_failed+0xed/0x130
Aug 18 01:30:00 [ 2730.805544]  [<ffffffff8128bf04>] ?
call_rwsem_down_read_failed+0x14/0x30
Aug 18 01:30:00 [ 2730.805615]  [<ffffffffa0210a50>] ?
cached_dev_congested+0x160/0x160 [bcache]
Aug 18 01:30:00 [ 2730.805679]  [<ffffffff814c9c37>] ? down_read+0x17/0x20
Aug 18 01:30:00 [ 2730.805745]  [<ffffffffa020a5b5>] ?
bch_btree_map_keys+0xc5/0x140 [bcache]
Aug 18 01:30:00 [ 2730.805812]  [<ffffffffa0210a50>] ?
cached_dev_congested+0x160/0x160 [bcache]
Aug 18 01:30:00 [ 2730.805880]  [<ffffffffa02114cc>] ?
cache_lookup+0xdc/0x1c0 [bcache]
Aug 18 01:30:00 [ 2730.805946]  [<ffffffffa0213602>] ?
cached_dev_make_request+0xcc2/0xee0 [bcache]
Aug 18 01:30:00 [ 2730.806027]  [<ffffffff81255c98>] ?
generic_make_request+0xa8/0xf0
Aug 18 01:30:00 [ 2730.806090]  [<ffffffff81255d3c>] ? submit_bio+0x5c/0x120
Aug 18 01:30:00 [ 2730.806160]  [<ffffffffa051e6c0>] ?
dispatch_rw_block_io+0x510/0x8c0 [xen_blkback]
Aug 18 01:30:00 [ 2730.806246]  [<ffffffffa051ec6c>] ?
__do_block_io_op+0x1fc/0x650 [xen_blkback]
Aug 18 01:30:00 [ 2730.806330]  [<ffffffff8106bea4>] ?
try_to_del_timer_sync+0x44/0x60
Aug 18 01:30:00 [ 2730.806393]  [<ffffffff8106bf0a>] ? del_timer_sync+0x4a/0x60
Aug 18 01:30:00 [ 2730.806456]  [<ffffffffa051f3e0>] ?
xen_blkif_schedule+0xd0/0x830 [xen_blkback]
Aug 18 01:30:00 [ 2730.806536]  [<ffffffff81089621>] ?
finish_task_switch+0x41/0xf0
Aug 18 01:30:00 [ 2730.806599]  [<ffffffff8109f4e0>] ?
prepare_to_wait_event+0xf0/0xf0
Aug 18 01:30:00 [ 2730.806663]  [<ffffffffa051f310>] ?
xen_blkif_be_int+0x30/0x30 [xen_blkback]
Aug 18 01:30:00 [ 2730.806726]  [<ffffffff81080a68>] ? kthread+0xb8/0xd0
Aug 18 01:30:00 [ 2730.806788]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
Aug 18 01:30:00 [ 2730.806851]  [<ffffffff814d2c4c>] ? ret_from_fork+0x7c/0xb0
Aug 18 01:30:00 [ 2730.806912]  [<ffffffff810809b0>] ?
kthread_create_on_node+0x170/0x170
