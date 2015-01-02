From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: bcache fails after reboot if discard is enabled
Date: Fri, 02 Jan 2015 10:47:49 +0100
Message-ID: <54A66945.6030403@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:29421 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbABJrw (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 2 Jan 2015 04:47:52 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>

Hi,

while running 3.10 or 3.18 kernel i've problems enabling discard.
Strangely this only appears on reboot or crash. While these situations
work fine without discard.

bcache completely fails when discard is enabled for reboot or crash.
Strangely it works fine while "running".

After a reboot dmesg looks like this (for all 3 cache and all backing
devices):
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
WARNING: at drivers/md/bcache/alloc.c:79 bch_inc_gen+0x5f/0x70 [bcache]()
Modules linked in: bcache sg sd_mod crc32_pclmul ghash_clmulni_intel
isci(+) libsas ahci scsi_transport_sas libahci igb i2c_algo_bit i2c_core
ixgbe(O) ptp pps_core
CPU: 0 PID: 438 Comm: bcache-register Tainted: G           O 3.18.1 #1
 [<ffffffffa007305f>] bch_inc_gen+0x5f/0x70 [bcache]
 [<ffffffffa0073234>] __bch_invalidate_one_bucket+0x44/0xe0 [bcache]
 [<ffffffffa007ba06>] bch_initial_gc_finish+0xe6/0x190 [bcache]
 [<ffffffffa0093747>] ? bch_crc64+0x37/0x50 [bcache]
 [<ffffffffa008bb38>] run_cache_set+0x3c8/0x900 [bcache]
 [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
bcache: error on d85a7b6f-50cf-4293-8f20-cdd16d5d16e0: key too stale:
97, need_gc 128, disabling caching
CPU: 1 PID: 438 Comm: bcache-register Tainted: G        W  O 3.18.1 #1
 [<ffffffffa00805e5>] bch_extent_bad+0x1b5/0x1c0 [bcache]
 [<ffffffffa0074c2a>] bch_ptr_bad+0xa/0x10 [bcache]
 [<ffffffffa00750e1>] btree_mergesort+0x2d1/0x560 [bcache]
 [<ffffffffa0074c20>] ? bch_ptr_invalid+0x10/0x10 [bcache]
 [<ffffffffa007571e>] ? bch_bset_init_next+0x8e/0xf0 [bcache]
 [<ffffffffa007712c>] ? bch_btree_iter_init+0x7c/0xc0 [bcache]
 [<ffffffffa0077705>] bch_btree_sort_into+0x55/0x80 [bcache]
 [<ffffffffa007b421>] btree_node_alloc_replacement+0x81/0xc0 [bcache]
 [<ffffffffa007bd1c>] btree_split+0xbc/0x6d0 [bcache]
 [<ffffffffa007c5ea>] bch_btree_insert_node+0x2ba/0x3a0 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007c6f8>] btree_insert_fn+0x28/0x50 [bcache]
 [<ffffffffa007b098>] bch_btree_map_nodes_recurse+0x38/0x160 [bcache]
 [<ffffffffa00762b7>] ? __bch_bset_search+0x187/0x4a0 [bcache]
 [<ffffffffa0080372>] ? bch_btree_ptr_invalid+0x12/0x20 [bcache]
 [<ffffffffa007acb8>] ? bch_btree_node_get+0x78/0x290 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007b133>] bch_btree_map_nodes_recurse+0xd3/0x160 [bcache]
 [<ffffffffa007ddf4>] __bch_btree_map_nodes+0x104/0x120 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007def1>] bch_btree_insert+0xe1/0x150 [bcache]
 [<ffffffffa008264a>] bch_journal_replay+0x12a/0x250 [bcache]
 [<ffffffffa0093747>] ? bch_crc64+0x37/0x50 [bcache]
 [<ffffffffa008bcdf>] run_cache_set+0x56f/0x900 [bcache]
 [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
bcache: bch_journal_replay() journal replay done, 4390 keys in 57
entries, seq 2406219
bcache: register_cache() registered cache device sda5
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: error on 157e5dc9-4017-410b-b1f6-450385345128: key too stale:
107, need_gc 128, disabling caching
CPU: 1 PID: 447 Comm: bcache-register Tainted: G        W  O 3.18.1 #1
 [<ffffffffa00805e5>] bch_extent_bad+0x1b5/0x1c0 [bcache]
 [<ffffffffa0074c2a>] bch_ptr_bad+0xa/0x10 [bcache]
 [<ffffffffa00750e1>] btree_mergesort+0x2d1/0x560 [bcache]
 [<ffffffffa0074c20>] ? bch_ptr_invalid+0x10/0x10 [bcache]
 [<ffffffffa007571e>] ? bch_bset_init_next+0x8e/0xf0 [bcache]
 [<ffffffffa007712c>] ? bch_btree_iter_init+0x7c/0xc0 [bcache]
 [<ffffffffa0077705>] bch_btree_sort_into+0x55/0x80 [bcache]
 [<ffffffffa007b421>] btree_node_alloc_replacement+0x81/0xc0 [bcache]
 [<ffffffffa007bd1c>] btree_split+0xbc/0x6d0 [bcache]
 [<ffffffffa007c5ea>] bch_btree_insert_node+0x2ba/0x3a0 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007c6f8>] btree_insert_fn+0x28/0x50 [bcache]
 [<ffffffffa007b098>] bch_btree_map_nodes_recurse+0x38/0x160 [bcache]
 [<ffffffffa00762b7>] ? __bch_bset_search+0x187/0x4a0 [bcache]
 [<ffffffffa0080372>] ? bch_btree_ptr_invalid+0x12/0x20 [bcache]
 [<ffffffffa007acb8>] ? bch_btree_node_get+0x78/0x290 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007b133>] bch_btree_map_nodes_recurse+0xd3/0x160 [bcache]
 [<ffffffffa007ddf4>] __bch_btree_map_nodes+0x104/0x120 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007def1>] bch_btree_insert+0xe1/0x150 [bcache]
 [<ffffffffa008264a>] bch_journal_replay+0x12a/0x250 [bcache]
 [<ffffffffa009374f>] ? bch_crc64+0x3f/0x50 [bcache]
 [<ffffffffa008bcdf>] run_cache_set+0x56f/0x900 [bcache]
 [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
bcache: bch_journal_replay() journal replay done, 4355 keys in 56
entries, seq 435045
bcache: register_cache() registered cache device sdb3
bcache: register_bdev() registered backing device sdd1
bcache: bch_cached_dev_attach() Can't attach sdd1: shutting down
bcache: register_bdev() registered backing device sdc1
bcache: register_bdev() registered backing device sde1
bcache: bch_cached_dev_attach() Can't attach sde1: shutting down
bcache: cache_set_free() Cache set d85a7b6f-50cf-4293-8f20-cdd16d5d16e0
unregistered
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: error on b755d45b-9fa1-490f-9eca-6b739618aaf1: accessing
priorities, disabling caching
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: register_cache() registered cache device sdi5
bcache: cache_set_free() Cache set b755d45b-9fa1-490f-9eca-6b739618aaf1
unregistered
bcache: register_bdev() registered backing device sdf1
bcache: register_bdev() registered backing device sdh1
bcache: bch_cached_dev_attach() Can't attach sdh1: shutting down
bcache: register_bdev() registered backing device sdg1
bcache: bch_cached_dev_attach() Can't attach sdg1: shutting down
bcache: error on d85a7b6f-50cf-4293-8f20-cdd16d5d16e0: key too stale:
105, need_gc 128, disabling caching
CPU: 1 PID: 1184 Comm: bcache-register Tainted: G        W  O 3.18.1 #1
 [<ffffffffa00805e5>] bch_extent_bad+0x1b5/0x1c0 [bcache]
 [<ffffffffa0074c2a>] bch_ptr_bad+0xa/0x10 [bcache]
 [<ffffffffa00750e1>] btree_mergesort+0x2d1/0x560 [bcache]
 [<ffffffffa0074c20>] ? bch_ptr_invalid+0x10/0x10 [bcache]
 [<ffffffffa007571e>] ? bch_bset_init_next+0x8e/0xf0 [bcache]
 [<ffffffffa007712c>] ? bch_btree_iter_init+0x7c/0xc0 [bcache]
 [<ffffffffa0077705>] bch_btree_sort_into+0x55/0x80 [bcache]
 [<ffffffffa007b421>] btree_node_alloc_replacement+0x81/0xc0 [bcache]
 [<ffffffffa007bd1c>] btree_split+0xbc/0x6d0 [bcache]
 [<ffffffffa007c5ea>] bch_btree_insert_node+0x2ba/0x3a0 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007c6f8>] btree_insert_fn+0x28/0x50 [bcache]
 [<ffffffffa007b098>] bch_btree_map_nodes_recurse+0x38/0x160 [bcache]
 [<ffffffffa00762b7>] ? __bch_bset_search+0x187/0x4a0 [bcache]
 [<ffffffffa0080372>] ? bch_btree_ptr_invalid+0x12/0x20 [bcache]
 [<ffffffffa007acb8>] ? bch_btree_node_get+0x78/0x290 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007b133>] bch_btree_map_nodes_recurse+0xd3/0x160 [bcache]
 [<ffffffffa007ddf4>] __bch_btree_map_nodes+0x104/0x120 [bcache]
 [<ffffffffa007c6d0>] ? bch_btree_insert_node+0x3a0/0x3a0 [bcache]
 [<ffffffffa007def1>] bch_btree_insert+0xe1/0x150 [bcache]
 [<ffffffffa008264a>] bch_journal_replay+0x12a/0x250 [bcache]
 [<ffffffffa008bcdf>] run_cache_set+0x56f/0x900 [bcache]
 [<ffffffffa008d517>] register_bcache+0xd37/0x13c0 [bcache]
bcache: bch_journal_replay() journal replay done, 4390 keys in 58
entries, seq 2406220
bcache: bch_cached_dev_attach() Can't attach sde1: shutting down
bcache: bch_cached_dev_attach() Can't attach sdd1: shutting down
bcache: register_cache() registered cache device sda5
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: error on b755d45b-9fa1-490f-9eca-6b739618aaf1: accessing
priorities, disabling caching
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: prio_read() bad csum reading priorities
bcache: prio_read() bad magic reading priorities
bcache: register_cache() registered cache device sdi5
bcache: cache_set_free() Cache set b755d45b-9fa1-490f-9eca-6b739618aaf1
unregistered
bcache: cache_set_free() Cache set d85a7b6f-50cf-4293-8f20-cdd16d5d16e0
unregistered
bcache: cache_set_free() Cache set 157e5dc9-4017-410b-b1f6-450385345128
unregistered

Stefan
