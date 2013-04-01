From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: bcache memleaks
Date: Mon, 1 Apr 2013 15:09:58 -0400
Message-ID: <20130401190958.GA18634@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

FYI, here are some leaks that kmemleak caught when I tested Jens'
for-next with test_git_extract_bcache_quick from the thinp-test-suite:

unreferenced object 0xffff88032f096bc0 (size 128):
  comm "sh", pid 24310, jiffies 4303299100 (age 887.483s)
  hex dump (first 32 bytes):
    00 00 00 00 04 00 00 00 04 00 00 00 00 00 00 00  ................
    80 76 c5 2c 03 88 ff ff 50 00 00 00 00 00 00 00  .v.,....P.......
  backtrace:
    [<ffffffff814f4d8e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff8115bbd3>] kmem_cache_alloc_node_trace+0xf3/0x1a0
    [<ffffffff8110fcc0>] mempool_create_node+0x50/0x150
    [<ffffffff8110fdda>] mempool_create+0x1a/0x20
    [<ffffffffa0894885>] bio_split_pool_init+0x55/0x70 [bcache]
    [<ffffffffa089491d>] bcache_device_init+0x7d/0x1c0 [bcache]
    [<ffffffffa0896839>] cached_dev_init+0xa9/0x200 [bcache]
    [<ffffffffa089749f>] register_bdev+0x4f/0x1d0 [bcache]
    [<ffffffffa08990d0>] register_bcache+0x1f0/0x220 [bcache]
    [<ffffffff8125a1c7>] kobj_attr_store+0x17/0x20
    [<ffffffff811e14cf>] sysfs_write_file+0xef/0x170
    [<ffffffff8116c964>] vfs_write+0xb4/0x130
    [<ffffffff8116d12f>] sys_write+0x5f/0xa0
    [<ffffffff81511219>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88032cc57680 (size 32):
  comm "sh", pid 24310, jiffies 4303299100 (age 887.483s)
  hex dump (first 32 bytes):
    40 48 49 1a 03 88 ff ff c0 32 54 32 03 88 ff ff  @HI......2T2....
    40 4e a6 2f 03 88 ff ff c0 41 a6 2f 03 88 ff ff  @N./.....A./....
  backtrace:
    [<ffffffff814f4d8e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff8115bbd3>] kmem_cache_alloc_node_trace+0xf3/0x1a0
    [<ffffffff8115bd2e>] __kmalloc_node+0x4e/0x60
    [<ffffffff8110fce2>] mempool_create_node+0x72/0x150
    [<ffffffff8110fdda>] mempool_create+0x1a/0x20
    [<ffffffffa0894885>] bio_split_pool_init+0x55/0x70 [bcache]
    [<ffffffffa089491d>] bcache_device_init+0x7d/0x1c0 [bcache]
    [<ffffffffa0896839>] cached_dev_init+0xa9/0x200 [bcache]
    [<ffffffffa089749f>] register_bdev+0x4f/0x1d0 [bcache]
    [<ffffffffa08990d0>] register_bcache+0x1f0/0x220 [bcache]
    [<ffffffff8125a1c7>] kobj_attr_store+0x17/0x20
    [<ffffffff811e14cf>] sysfs_write_file+0xef/0x170
    [<ffffffff8116c964>] vfs_write+0xb4/0x130
    [<ffffffff8116d12f>] sys_write+0x5f/0xa0
    [<ffffffff81511219>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88031a494840 (size 128):
  comm "sh", pid 24310, jiffies 4303299100 (age 887.495s)
  hex dump (first 32 bytes):
    4c 56 4d 2d 61 33 75 77 69 46 73 56 5a 58 45 48  LVM-a3uwiFsVZXEH
    6e 52 48 56 36 4b 79 34 49 47 74 52 69 71 61 78  nRHV6Ky4IGtRiqax
  backtrace:
    [<ffffffff814f4d8e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff8115d377>] __kmalloc+0x157/0x2a0
    [<ffffffff8110f815>] mempool_kmalloc+0x15/0x20
    [<ffffffff8110fd51>] mempool_create_node+0xe1/0x150
    [<ffffffff8110fdda>] mempool_create+0x1a/0x20
    [<ffffffffa0894885>] bio_split_pool_init+0x55/0x70 [bcache]
    [<ffffffffa089491d>] bcache_device_init+0x7d/0x1c0 [bcache]
    [<ffffffffa0896839>] cached_dev_init+0xa9/0x200 [bcache]
    [<ffffffffa089749f>] register_bdev+0x4f/0x1d0 [bcache]
    [<ffffffffa08990d0>] register_bcache+0x1f0/0x220 [bcache]
    [<ffffffff8125a1c7>] kobj_attr_store+0x17/0x20
    [<ffffffff811e14cf>] sysfs_write_file+0xef/0x170
    [<ffffffff8116c964>] vfs_write+0xb4/0x130
    [<ffffffff8116d12f>] sys_write+0x5f/0xa0
    [<ffffffff81511219>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880332543e40 (size 128):
  comm "sh", pid 24318, jiffies 4303299162 (age 887.433s)
  hex dump (first 32 bytes):
    00 00 00 00 04 00 00 00 04 00 00 00 00 00 00 00  ................
    00 33 1e 2a 03 88 ff ff 50 00 00 00 00 00 00 00  .3.*....P.......
  backtrace:
    [<ffffffff814f4d8e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff8115bbd3>] kmem_cache_alloc_node_trace+0xf3/0x1a0
    [<ffffffff8110fcc0>] mempool_create_node+0x50/0x150
    [<ffffffff8110fdda>] mempool_create+0x1a/0x20
    [<ffffffffa0894885>] bio_split_pool_init+0x55/0x70 [bcache]
    [<ffffffffa0898b17>] cache_alloc+0x407/0x650 [bcache]
    [<ffffffffa0898da4>] register_cache+0x44/0x180 [bcache]
    [<ffffffffa0899093>] register_bcache+0x1b3/0x220 [bcache]
    [<ffffffff8125a1c7>] kobj_attr_store+0x17/0x20
    [<ffffffff811e14cf>] sysfs_write_file+0xef/0x170
    [<ffffffff8116c964>] vfs_write+0xb4/0x130
    [<ffffffff8116d12f>] sys_write+0x5f/0xa0
    [<ffffffff81511219>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88032a1e3300 (size 32):
  comm "sh", pid 24318, jiffies 4303299162 (age 887.433s)
  hex dump (first 32 bytes):
    c0 45 6d 22 03 88 ff ff c0 b7 8c 1b 03 88 ff ff  .Em"............
    c0 58 c3 2c 03 88 ff ff c0 46 6d 22 03 88 ff ff  .X.,.....Fm"....
  backtrace:
    [<ffffffff814f4d8e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff8115bbd3>] kmem_cache_alloc_node_trace+0xf3/0x1a0
    [<ffffffff8115bd2e>] __kmalloc_node+0x4e/0x60
    [<ffffffff8110fce2>] mempool_create_node+0x72/0x150
    [<ffffffff8110fdda>] mempool_create+0x1a/0x20
    [<ffffffffa0894885>] bio_split_pool_init+0x55/0x70 [bcache]
    [<ffffffffa0898b17>] cache_alloc+0x407/0x650 [bcache]
    [<ffffffffa0898da4>] register_cache+0x44/0x180 [bcache]
    [<ffffffffa0899093>] register_bcache+0x1b3/0x220 [bcache]
    [<ffffffff8125a1c7>] kobj_attr_store+0x17/0x20
    [<ffffffff811e14cf>] sysfs_write_file+0xef/0x170
    [<ffffffff8116c964>] vfs_write+0xb4/0x130
    [<ffffffff8116d12f>] sys_write+0x5f/0xa0
    [<ffffffff81511219>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8803226d45c0 (size 128):
  comm "sh", pid 24318, jiffies 4303299162 (age 887.445s)
  hex dump (first 32 bytes):
    c0 45 6d 22 03 88 ff ff c0 45 6d 22 03 88 ff ff  .Em".....Em"....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814f4d8e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff8115d377>] __kmalloc+0x157/0x2a0
    [<ffffffff8110f815>] mempool_kmalloc+0x15/0x20
    [<ffffffff8110fd51>] mempool_create_node+0xe1/0x150
    [<ffffffff8110fdda>] mempool_create+0x1a/0x20
    [<ffffffffa0894885>] bio_split_pool_init+0x55/0x70 [bcache]
    [<ffffffffa0898b17>] cache_alloc+0x407/0x650 [bcache]
    [<ffffffffa0898da4>] register_cache+0x44/0x180 [bcache]
    [<ffffffffa0899093>] register_bcache+0x1b3/0x220 [bcache]
    [<ffffffff8125a1c7>] kobj_attr_store+0x17/0x20
    [<ffffffff811e14cf>] sysfs_write_file+0xef/0x170
    [<ffffffff8116c964>] vfs_write+0xb4/0x130
    [<ffffffff8116d12f>] sys_write+0x5f/0xa0
    [<ffffffff81511219>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88031b8cb7c0 (size 128):
  comm "sh", pid 24318, jiffies 4303299162 (age 887.445s)
  hex dump (first 32 bytes):
    4c 56 4d 2d 61 33 75 77 69 46 73 56 5a 58 45 48  LVM-a3uwiFsVZXEH
    6e 52 48 56 36 4b 79 34 49 47 74 52 69 71 61 78  nRHV6Ky4IGtRiqax
  backtrace:
    [<ffffffff814f4d8e>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff8115d377>] __kmalloc+0x157/0x2a0
    [<ffffffff8110f815>] mempool_kmalloc+0x15/0x20
    [<ffffffff8110fd51>] mempool_create_node+0xe1/0x150
    [<ffffffff8110fdda>] mempool_create+0x1a/0x20
    [<ffffffffa0894885>] bio_split_pool_init+0x55/0x70 [bcache]
    [<ffffffffa0898b17>] cache_alloc+0x407/0x650 [bcache]
    [<ffffffffa0898da4>] register_cache+0x44/0x180 [bcache]
    [<ffffffffa0899093>] register_bcache+0x1b3/0x220 [bcache]
    [<ffffffff8125a1c7>] kobj_attr_store+0x17/0x20
    [<ffffffff811e14cf>] sysfs_write_file+0xef/0x170
    [<ffffffff8116c964>] vfs_write+0xb4/0x130
    [<ffffffff8116d12f>] sys_write+0x5f/0xa0
    [<ffffffff81511219>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
