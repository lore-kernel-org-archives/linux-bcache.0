From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: bcache fails after reboot if discard is enabled
Date: Fri, 02 Jan 2015 11:00:36 +0100
Message-ID: <54A66C44.6070505@profihost.ag>
References: <54A66945.6030403@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:16099 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbABKAi (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 2 Jan 2015 05:00:38 -0500
In-Reply-To: <54A66945.6030403@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>

I'm sorry the backtraces were incomplete.

Here is a complete one:
[    8.191781] CPU: 1 PID: 1184 Comm: bcache-register Tainted: G
W  O 3.10.63+96-ph #1
[    8.191783] Hardware name: Supermicro
X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 1.0c
10/08/2012
[    8.191784]  ffffc90017cb0000 ffff880c315a1608 ffffffff8154fad2
ffff880c315a1638
[    8.191786]  ffffffffa00805e5 ffff880c315a165e ffff880c3cffa8c8
ffff880c31340680
[    8.191788]  ffff880c3a440530 ffff880c315a1648 ffffffffa0074c2a
ffff880c315a1708
[    8.191790] Call Trace:
[    8.191795]  [<ffffffff8154fad2>] dump_stack+0x19/0x1b
[    8.191802]  [<ffffffffa00805e5>] bch_extent_bad+0x1b5/0x1c0 [bcache]
[    8.191806]  [<ffffffffa0074c2a>] bch_ptr_bad+0xa/0x10 [bcache]
[    8.191809]  [<ffffffffa00750e1>] btree_mergesort+0x2d1/0x560 [bcache]
[    8.191813]  [<ffffffffa0074c20>] ? bch_ptr_invalid+0x10/0x10 [bcache]
[    8.191816]  [<ffffffff8137e800>] ? get_random_bytes+0x20/0x30
[    8.191820]  [<ffffffffa007571e>] ? bch_bset_init_next+0x8e/0xf0 [bcache]
[    8.191823]  [<ffffffffa007712c>] ? bch_btree_iter_init+0x7c/0xc0
[bcache]
[    8.191827]  [<ffffffffa0077705>] bch_btree_sort_into+0x55/0x80 [bcache]
[    8.191830]  [<ffffffff810706ab>] ? prepare_to_wait+0x5b/0x90
[    8.191833]  [<ffffffffa007b421>]
btree_node_alloc_replacement+0x81/0xc0 [bcache]
[    8.191837]  [<ffffffffa007bd1c>] btree_split+0xbc/0x6d0 [bcache]
[    8.191840]  [<ffffffff81083f16>] ? find_busiest_group+0x36/0x4a0
[    8.191843]  [<ffffffffa007c5ea>] bch_btree_insert_node+0x2ba/0x3a0
[bcache]
[    8.191847]  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0
[bcache]
[    8.191850]  [<ffffffffa007c6f8>] btree_insert_fn+0x28/0x50 [bcache]
[    8.191853]  [<ffffffffa007b098>]
bch_btree_map_nodes_recurse+0x38/0x160 [bcache]
[    8.191857]  [<ffffffffa00762b7>] ? __bch_bset_search+0x187/0x4a0
[bcache]
[    8.191861]  [<ffffffffa0080372>] ? bch_btree_ptr_invalid+0x12/0x20
[bcache]
[    8.191864]  [<ffffffffa007acb8>] ? bch_btree_node_get+0x78/0x290
[bcache]
[    8.191868]  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0
[bcache]
[    8.191871]  [<ffffffffa007b133>]
bch_btree_map_nodes_recurse+0xd3/0x160 [bcache]
[    8.191875]  [<ffffffffa007ddf4>] __bch_btree_map_nodes+0x104/0x120
[bcache]
[    8.191878]  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0
[bcache]
[    8.191881]  [<ffffffffa007def1>] bch_btree_insert+0xe1/0x150 [bcache]
[    8.191883]  [<ffffffff81070430>] ? finish_wait+0x80/0x80
[    8.191887]  [<ffffffffa008264a>] bch_journal_replay+0x12a/0x250 [bcache]
[    8.191889]  [<ffffffff8107c29d>] ? ttwu_do_wakeup+0x1d/0xe0
[    8.191891]  [<ffffffff8107e8fc>] ? try_to_wake_up+0x20c/0x2e0
[    8.191893]  [<ffffffff8107ea37>] ? wake_up_process+0x27/0x50
[    8.191898]  [<ffffffffa008bcdf>] run_cache_set+0x56f/0x900 [bcache]
[    8.191902]  [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
[    8.191904]  [<ffffffff8111510f>] ? handle_mm_fault+0x2cf/0x400
[    8.191907]  [<ffffffff812b83df>] kobj_attr_store+0xf/0x20
[    8.191909]  [<ffffffff811bf480>] sysfs_write_file+0xd0/0x150
[    8.191911]  [<ffffffff81151fc5>] vfs_write+0xc5/0x1f0
[    8.191913]  [<ffffffff811524b2>] SyS_write+0x52/0xa0
[    8.191915]  [<ffffffff81032ece>] ? do_page_fault+0xe/0x10
[    8.191917]  [<ffffffff81555a12>] system_call_fastpath+0x16/0x1b
Am 02.01.2015 um 10:47 schrieb Stefan Priebe - Profihost AG:
> Hi,
> 
> while running 3.10 or 3.18 kernel i've problems enabling discard.
> Strangely this only appears on reboot or crash. While these situations
> work fine without discard.
> 
> bcache completely fails when discard is enabled for reboot or crash.
> Strangely it works fine while "running".
> 
> After a reboot dmesg looks like this (for all 3 cache and all backing
> devices):
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> WARNING: at drivers/md/bcache/alloc.c:79 bch_inc_gen+0x5f/0x70 [bcache]()
> Modules linked in: bcache sg sd_mod crc32_pclmul ghash_clmulni_intel
> isci(+) libsas ahci scsi_transport_sas libahci igb i2c_algo_bit i2c_core
> ixgbe(O) ptp pps_core
> CPU: 0 PID: 438 Comm: bcache-register Tainted: G           O 3.18.1 #1
>  [<ffffffffa007305f>] bch_inc_gen+0x5f/0x70 [bcache]
>  [<ffffffffa0073234>] __bch_invalidate_one_bucket+0x44/0xe0 [bcache]
>  [<ffffffffa007ba06>] bch_initial_gc_finish+0xe6/0x190 [bcache]
>  [<ffffffffa0093747>] ? bch_crc64+0x37/0x50 [bcache]
>  [<ffffffffa008bb38>] run_cache_set+0x3c8/0x900 [bcache]
>  [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
> bcache: error on d85a7b6f-50cf-4293-8f20-cdd16d5d16e0: key too stale:
> 97, need_gc 128, disabling caching
> CPU: 1 PID: 438 Comm: bcache-register Tainted: G        W  O 3.18.1 #1
>  [<ffffffffa00805e5>] bch_extent_bad+0x1b5/0x1c0 [bcache]
>  [<ffffffffa0074c2a>] bch_ptr_bad+0xa/0x10 [bcache]
>  [<ffffffffa00750e1>] btree_mergesort+0x2d1/0x560 [bcache]
>  [<ffffffffa0074c20>] ? bch_ptr_invalid+0x10/0x10 [bcache]
>  [<ffffffffa007571e>] ? bch_bset_init_next+0x8e/0xf0 [bcache]
>  [<ffffffffa007712c>] ? bch_btree_iter_init+0x7c/0xc0 [bcache]
>  [<ffffffffa0077705>] bch_btree_sort_into+0x55/0x80 [bcache]
>  [<ffffffffa007b421>] btree_node_alloc_replacement+0x81/0xc0 [bcache]
>  [<ffffffffa007bd1c>] btree_split+0xbc/0x6d0 [bcache]
>  [<ffffffffa007c5ea>] bch_btree_insert_node+0x2ba/0x3a0 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007c6f8>] btree_insert_fn+0x28/0x50 [bcache]
>  [<ffffffffa007b098>] bch_btree_map_nodes_recurse+0x38/0x160 [bcache]
>  [<ffffffffa00762b7>] ? __bch_bset_search+0x187/0x4a0 [bcache]
>  [<ffffffffa0080372>] ? bch_btree_ptr_invalid+0x12/0x20 [bcache]
>  [<ffffffffa007acb8>] ? bch_btree_node_get+0x78/0x290 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007b133>] bch_btree_map_nodes_recurse+0xd3/0x160 [bcache]
>  [<ffffffffa007ddf4>] __bch_btree_map_nodes+0x104/0x120 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007def1>] bch_btree_insert+0xe1/0x150 [bcache]
>  [<ffffffffa008264a>] bch_journal_replay+0x12a/0x250 [bcache]
>  [<ffffffffa0093747>] ? bch_crc64+0x37/0x50 [bcache]
>  [<ffffffffa008bcdf>] run_cache_set+0x56f/0x900 [bcache]
>  [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
> bcache: bch_journal_replay() journal replay done, 4390 keys in 57
> entries, seq 2406219
> bcache: register_cache() registered cache device sda5
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: error on 157e5dc9-4017-410b-b1f6-450385345128: key too stale:
> 107, need_gc 128, disabling caching
> CPU: 1 PID: 447 Comm: bcache-register Tainted: G        W  O 3.18.1 #1
>  [<ffffffffa00805e5>] bch_extent_bad+0x1b5/0x1c0 [bcache]
>  [<ffffffffa0074c2a>] bch_ptr_bad+0xa/0x10 [bcache]
>  [<ffffffffa00750e1>] btree_mergesort+0x2d1/0x560 [bcache]
>  [<ffffffffa0074c20>] ? bch_ptr_invalid+0x10/0x10 [bcache]
>  [<ffffffffa007571e>] ? bch_bset_init_next+0x8e/0xf0 [bcache]
>  [<ffffffffa007712c>] ? bch_btree_iter_init+0x7c/0xc0 [bcache]
>  [<ffffffffa0077705>] bch_btree_sort_into+0x55/0x80 [bcache]
>  [<ffffffffa007b421>] btree_node_alloc_replacement+0x81/0xc0 [bcache]
>  [<ffffffffa007bd1c>] btree_split+0xbc/0x6d0 [bcache]
>  [<ffffffffa007c5ea>] bch_btree_insert_node+0x2ba/0x3a0 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007c6f8>] btree_insert_fn+0x28/0x50 [bcache]
>  [<ffffffffa007b098>] bch_btree_map_nodes_recurse+0x38/0x160 [bcache]
>  [<ffffffffa00762b7>] ? __bch_bset_search+0x187/0x4a0 [bcache]
>  [<ffffffffa0080372>] ? bch_btree_ptr_invalid+0x12/0x20 [bcache]
>  [<ffffffffa007acb8>] ? bch_btree_node_get+0x78/0x290 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007b133>] bch_btree_map_nodes_recurse+0xd3/0x160 [bcache]
>  [<ffffffffa007ddf4>] __bch_btree_map_nodes+0x104/0x120 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007def1>] bch_btree_insert+0xe1/0x150 [bcache]
>  [<ffffffffa008264a>] bch_journal_replay+0x12a/0x250 [bcache]
>  [<ffffffffa009374f>] ? bch_crc64+0x3f/0x50 [bcache]
>  [<ffffffffa008bcdf>] run_cache_set+0x56f/0x900 [bcache]
>  [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
> bcache: bch_journal_replay() journal replay done, 4355 keys in 56
> entries, seq 435045
> bcache: register_cache() registered cache device sdb3
> bcache: register_bdev() registered backing device sdd1
> bcache: bch_cached_dev_attach() Can't attach sdd1: shutting down
> bcache: register_bdev() registered backing device sdc1
> bcache: register_bdev() registered backing device sde1
> bcache: bch_cached_dev_attach() Can't attach sde1: shutting down
> bcache: cache_set_free() Cache set d85a7b6f-50cf-4293-8f20-cdd16d5d16e0
> unregistered
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: error on b755d45b-9fa1-490f-9eca-6b739618aaf1: accessing
> priorities, disabling caching
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: register_cache() registered cache device sdi5
> bcache: cache_set_free() Cache set b755d45b-9fa1-490f-9eca-6b739618aaf1
> unregistered
> bcache: register_bdev() registered backing device sdf1
> bcache: register_bdev() registered backing device sdh1
> bcache: bch_cached_dev_attach() Can't attach sdh1: shutting down
> bcache: register_bdev() registered backing device sdg1
> bcache: bch_cached_dev_attach() Can't attach sdg1: shutting down
> bcache: error on d85a7b6f-50cf-4293-8f20-cdd16d5d16e0: key too stale:
> 105, need_gc 128, disabling caching
> CPU: 1 PID: 1184 Comm: bcache-register Tainted: G        W  O 3.18.1 #1
>  [<ffffffffa00805e5>] bch_extent_bad+0x1b5/0x1c0 [bcache]
>  [<ffffffffa0074c2a>] bch_ptr_bad+0xa/0x10 [bcache]
>  [<ffffffffa00750e1>] btree_mergesort+0x2d1/0x560 [bcache]
>  [<ffffffffa0074c20>] ? bch_ptr_invalid+0x10/0x10 [bcache]
>  [<ffffffffa007571e>] ? bch_bset_init_next+0x8e/0xf0 [bcache]
>  [<ffffffffa007712c>] ? bch_btree_iter_init+0x7c/0xc0 [bcache]
>  [<ffffffffa0077705>] bch_btree_sort_into+0x55/0x80 [bcache]
>  [<ffffffffa007b421>] btree_node_alloc_replacement+0x81/0xc0 [bcache]
>  [<ffffffffa007bd1c>] btree_split+0xbc/0x6d0 [bcache]
>  [<ffffffffa007c5ea>] bch_btree_insert_node+0x2ba/0x3a0 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007c6f8>] btree_insert_fn+0x28/0x50 [bcache]
>  [<ffffffffa007b098>] bch_btree_map_nodes_recurse+0x38/0x160 [bcache]
>  [<ffffffffa00762b7>] ? __bch_bset_search+0x187/0x4a0 [bcache]
>  [<ffffffffa0080372>] ? bch_btree_ptr_invalid+0x12/0x20 [bcache]
>  [<ffffffffa007acb8>] ? bch_btree_node_get+0x78/0x290 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007b133>] bch_btree_map_nodes_recurse+0xd3/0x160 [bcache]
>  [<ffffffffa007ddf4>] __bch_btree_map_nodes+0x104/0x120 [bcache]
>  [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
>  [<ffffffffa007def1>] bch_btree_insert+0xe1/0x150 [bcache]
>  [<ffffffffa008264a>] bch_journal_replay+0x12a/0x250 [bcache]
>  [<ffffffffa008bcdf>] run_cache_set+0x56f/0x900 [bcache]
>  [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
> bcache: bch_journal_replay() journal replay done, 4390 keys in 58
> entries, seq 2406220
> bcache: bch_cached_dev_attach() Can't attach sde1: shutting down
> bcache: bch_cached_dev_attach() Can't attach sdd1: shutting down
> bcache: register_cache() registered cache device sda5
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: error on b755d45b-9fa1-490f-9eca-6b739618aaf1: accessing
> priorities, disabling caching
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: register_cache() registered cache device sdi5
> bcache: cache_set_free() Cache set b755d45b-9fa1-490f-9eca-6b739618aaf1
> unregistered
> bcache: cache_set_free() Cache set d85a7b6f-50cf-4293-8f20-cdd16d5d16e0
> unregistered
> bcache: cache_set_free() Cache set 157e5dc9-4017-410b-b1f6-450385345128
> unregistered
> 
> Stefan
> 
