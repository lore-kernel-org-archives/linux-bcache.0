From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache register deadlock in bcache_bucket_alloc() between
 bch_uuid_write and bch_prio_write
Date: Mon, 4 Apr 2016 02:08:29 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604040206300.5949@mail.ewheeler.net>
References: <alpine.LRH.2.11.1604040040030.5857@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:56772 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbcDDCIe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 3 Apr 2016 22:08:34 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.ewheeler.net (Postfix) with ESMTP id CB92CA0F4B
	for <linux-bcache@vger.kernel.org>; Mon,  4 Apr 2016 02:08:32 +0000 (UTC)
Received: from mail.ewheeler.net ([127.0.0.1])
	by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id QIlXgLG8rwVL for <linux-bcache@vger.kernel.org>;
	Mon,  4 Apr 2016 02:08:30 +0000 (UTC)
Received: from 23-95-35-21-host.colocrossing.com (unknown [23.95.35.21])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ewheeler.net (Postfix) with ESMTPSA id 16C31A0F4A
	for <linux-bcache@vger.kernel.org>; Mon,  4 Apr 2016 02:08:30 +0000 (UTC)
In-Reply-To: <alpine.LRH.2.11.1604040040030.5857@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Mon, 4 Apr 2016, Eric Wheeler wrote:

> Hello all,
> 
> I have a test system that won't register.  I can register either the
> caching dev or the cached dev fine, but as soon as I register the
> sencond dev, bash hangs when echoing into /sys/fs/bcache/register .
> I can register in either order (cache first or cached dev first) and
> the deadlock still presents.
> 
> I've narrowed down the problem to these two call stacks:
> 
> 
> == The allocator thread is one half of the deadlock:
> 
> [  405.619895] INFO: task bcache_allocato:3494 blocked for more than 5 seconds.
> [  405.620897]       Tainted: G        W  O    4.1.20+ #5
> [  405.621732] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  405.623132] bcache_allocato D ffff88007b78fc98     0  3494      2 0x00000080
> [  405.624406]  ffff88007b78fc98 ffff88007b78fc68 0000000000000002 ffff88007c8ddb80
> [  405.626241]  ffff8800796e0000 ffff88007b78fc78 ffff88007b790000 0000000000000005
> [  405.627890]  ffff880079cf0028 0000000000000001 0000000000000001 ffff88007b78fcb8
> [  405.629730] Call Trace:
> [  405.630362]  [<ffffffff817a9f47>] schedule+0x37/0x90
> [  405.631230]  [<ffffffffa048e4f0>] bch_bucket_alloc+0x1b0/0x670 [bcache]
> [  405.632261]  [<ffffffff81103860>] ? prepare_to_wait_event+0x110/0x110
> [  405.633274]  [<ffffffffa04a90d5>] bch_prio_write+0x1b5/0x390 [bcache]
> [  405.634362]  [<ffffffffa048e19d>] bch_allocator_thread+0x31d/0x4c0 [bcache]
> [  405.635496]  [<ffffffffa048de80>] ? invalidate_buckets+0x980/0x980 [bcache]
> [  405.636655]  [<ffffffff810d734e>] kthread+0xfe/0x120
> [  405.637604]  [<ffffffff817b0440>] ? _raw_spin_unlock_irq+0x30/0x50
> [  405.638569]  [<ffffffff810d7250>] ? kthread_create_on_node+0x240/0x240
> [  405.639628]  [<ffffffff817b11a2>] ret_from_fork+0x42/0x70
> [  405.640570]  [<ffffffff810d7250>] ? kthread_create_on_node+0x240/0x240
> [  405.641568] no locks held by bcache_allocato/3494.
> 
> There is a comment in the code inside of bch_allocator_thread() before it
> calls bch_prio_write(ca):
> 	360  /*
> 	361   * This could deadlock if an allocation with a btree
> 	362   * node locked ever blocked - having the btree node
> 	363   * locked would block garbage collection, but here we're
> 	364   * waiting on garbage collection before we invalidate
> 	365   * and free anything.
> 	366   *
> 	367   * But this should be safe since the btree code always
> 	368   * uses btree_check_reserve() before allocating now, and
> 	369   * if it fails it blocks without btree nodes locked.
> 	370   */
> 	371   if (!fifo_full(&ca->free_inc))
> 	372           goto retry_invalidate;
> 	373 
> 	374   bch_prio_write(ca);
> 
> I think I'm hitting the deadlock which this comment speaks to.  
> 
> 
> == This is the other side of the deadlock caused by registering the cache device:
>   echo /dev/sdb > /sys/fs/bcache/register
> 
> [  405.578073] INFO: task bash:3490 blocked for more than 5 seconds:
> [  405.580255] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ ... ]
> [  405.588984]  [<ffffffff817a9f47>] schedule+0x37/0x90
> [  405.589986]  [<ffffffffa048e4f0>] bch_bucket_alloc+0x1b0/0x670 [bcache]
> [  405.591084]  [<ffffffff81103860>] ? prepare_to_wait_event+0x110/0x110
> [  405.592078]  [<ffffffffa048eb59>] __bch_bucket_alloc_set+0x109/0x1a0 [bcache]
> [  405.593113]  [<ffffffffa048ec40>] bch_bucket_alloc_set+0x50/0x70 [bcache]
> [  405.594153]  [<ffffffffa04a7927>] __uuid_write+0x67/0x160 [bcache]
> [  405.595223]  [<ffffffffa04a8a06>] bch_uuid_write+0x16/0x40 [bcache]
> [  405.596273]  [<ffffffffa04a9877>] bch_cached_dev_attach+0x157/0x490 [bcache]
> [  405.597384]  [<ffffffffa04a6b68>] ? __write_super+0x148/0x180 [bcache]
> [  405.598432]  [<ffffffffa04a8986>] ? bcache_write_super+0x1d6/0x240 [bcache]
> [  405.599464]  [<ffffffffa04aa761>] run_cache_set+0x601/0x910 [bcache]
> [  405.600548]  [<ffffffffa04ac0ce>] register_bcache+0xeae/0x1430 [bcache]
> [...]
> [  405.611623] 4 locks held by bash/3490:
> [  405.612342]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff8126f773>] vfs_write+0x183/0x1b0
> [  405.614200]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff812faaa6>] kernfs_fop_write+0x66/0x1a0
> [  405.615994]  #2:  (s_active#194){.+.+.+}, at: [<ffffffff812faaae>] kernfs_fop_write+0x6e/0x1a0
> [  405.617925]  #3:  (&bch_register_lock){+.+.+.}, at: [<ffffffffa04abe70>] register_bcache+0xc50/0x1430 [bcache]
> 
> 
> I'm rather perplexed as to why this is deadlocking because
> bch_bucket_alloc_set() locks c->bucket_lock, and the allocator holds
> ca->set->bucket_lock before calling bch_prio_write() .  I checked,
> this is the same lock (same memory position).
> 
> This implies that the allocator waits on bch_bucket_alloc_set()
> which was invoked by bash through register_bcache, and register_bcache
> waits on the allocator's call to bch_prio_write().
> 
> Things that I've tried which don't work or make the problem worse:
>   * Adding a mutex inside bch_bucket_alloc so that only one may proceed at a time
>   * Holding bch_register_lock in the allocator thread before calling bch_prio_write.
> 
> Does anyone else have insight here that might help solve the problem?
> 

Also noteworthy,

I get this trace immediately after registering the SSD cache device,
though no deadlock at this point:

[   28.753548] random: nonblocking pool is initialized
[   72.792018] ------------[ cut here ]------------
[   72.792607] WARNING: CPU: 0 PID: 2430 at kernel/locking/lockdep.c:728 __lock_acquire+0x129a/0x15d0()
[   72.793009] Modules linked in: bcache(O) xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter netconsole bridge stp llc kvm_intel kvm nfsd sg ppdev virtio_balloon i2c_piix4 parport_pc auth_rpcgss parport pcspkr acpi_cpufreq nfs_acl lockd grace sunrpc ip_tables ext4 mbcache jbd2 ata_generic pata_acpi syscopyarea sysfillrect sysimgblt drm_kms_helper ttm crc32c_intel drm serio_raw i2c_core ata_piix libata virtio_net floppy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: bcache]
[   72.793009] CPU: 0 PID: 2430 Comm: bash Tainted: G           O    4.1.20+ #5
[   72.793009] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   72.793009]  0000000000000086 0000000096bd7654 ffff880078e178f8 ffffffff817a5f78
[   72.793009]  0000000000000000 ffffffff81a1898b ffff880078e17938 ffffffff810af92a
[   72.793009]  ffff88007b38c4a0 ffff88007b38c4a0 0000000000000000 ffff88007a7380c0
[   72.793009] Call Trace:
[   72.793009]  [<ffffffff817a5f78>] dump_stack+0x85/0xbe
[   72.793009]  [<ffffffff810af92a>] warn_slowpath_common+0x8a/0xc0
[   72.793009]  [<ffffffff810afa5a>] warn_slowpath_null+0x1a/0x20
[   72.793009]  [<ffffffff8110f6ea>] __lock_acquire+0x129a/0x15d0
[   72.793009]  [<ffffffff8110fb82>] lock_acquire+0xd2/0x300
[   72.793009]  [<ffffffffa04fa441>] ? mca_reap+0x61/0x1a0 [bcache]
[   72.793009]  [<ffffffff811090ff>] down_write_trylock+0x6f/0x90
[   72.793009]  [<ffffffffa04fa441>] ? mca_reap+0x61/0x1a0 [bcache]
[   72.793009]  [<ffffffffa04fa441>] mca_reap+0x61/0x1a0 [bcache]
[   72.793009]  [<ffffffffa04f8ab6>] ? mca_find+0xe6/0x190 [bcache]
[   72.793009]  [<ffffffffa04f89d5>] ? mca_find+0x5/0x190 [bcache]
[   72.793009]  [<ffffffffa04fa8e7>] mca_alloc+0xc7/0x640 [bcache]
[   72.793009]  [<ffffffffa04f89d5>] ? mca_find+0x5/0x190 [bcache]
[   72.793009]  [<ffffffffa04fb3e2>] bch_btree_node_get+0x152/0x2b0 [bcache]
[   72.793009]  [<ffffffffa0517cee>] ? bch_crc64+0x3e/0x50 [bcache]
[   72.793009]  [<ffffffffa050f402>] run_cache_set+0x272/0x910 [bcache]
[   72.793009]  [<ffffffffa05110fe>] register_bcache+0xeae/0x1430 [bcache]
[   72.793009]  [<ffffffff8121a0ff>] ? might_fault+0x5f/0xb0
[   72.793009]  [<ffffffff8110fe50>] ? lock_release_non_nested+0xa0/0x300
[   72.793009]  [<ffffffff813b214f>] kobj_attr_store+0xf/0x20
[   72.793009]  [<ffffffff812fb658>] sysfs_kf_write+0x48/0x60
[   72.793009]  [<ffffffff812fab83>] kernfs_fop_write+0x143/0x1a0
[   72.793009]  [<ffffffff8126ef67>] __vfs_write+0x37/0x110
[   72.793009]  [<ffffffff8126f773>] ? vfs_write+0x183/0x1b0
[   72.793009]  [<ffffffff8132bca3>] ? security_file_permission+0x23/0xa0
[   72.793009]  [<ffffffff8126f699>] vfs_write+0xa9/0x1b0
[   72.793009]  [<ffffffff81270558>] SyS_write+0x58/0xd0
[   72.793009]  [<ffffffff817b0d6e>] system_call_fastpath+0x12/0x76
[   72.793009] ---[ end trace 43d86c2e9eb293e9 ]---
[   72.845818] bcache: bch_journal_replay() journal replay done, 1240 keys in 2 entries, seq 5
[   72.847503] bcache: register_cache() registered cache device sdb


--
Eric Wheeler

> 
> --
> Eric Wheeler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
