From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: bcache register deadlock in bcache_bucket_alloc() between bch_uuid_write
 and bch_prio_write
Date: Mon, 4 Apr 2016 01:07:29 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604040040030.5857@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:56643 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754059AbcDDBHi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 3 Apr 2016 21:07:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.ewheeler.net (Postfix) with ESMTP id 14ECEA0F4B
	for <linux-bcache@vger.kernel.org>; Mon,  4 Apr 2016 01:07:37 +0000 (UTC)
Received: from mail.ewheeler.net ([127.0.0.1])
	by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id fQ_WDe1mcUSD for <linux-bcache@vger.kernel.org>;
	Mon,  4 Apr 2016 01:07:36 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [71.19.153.34])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ewheeler.net (Postfix) with ESMTPSA id 9B870A0F4A
	for <linux-bcache@vger.kernel.org>; Mon,  4 Apr 2016 01:07:35 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello all,

I have a test system that won't register.  I can register either the
caching dev or the cached dev fine, but as soon as I register the
sencond dev, bash hangs when echoing into /sys/fs/bcache/register .
I can register in either order (cache first or cached dev first) and
the deadlock still presents.

I've narrowed down the problem to these two call stacks:


== The allocator thread is one half of the deadlock:

[  405.619895] INFO: task bcache_allocato:3494 blocked for more than 5 seconds.
[  405.620897]       Tainted: G        W  O    4.1.20+ #5
[  405.621732] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  405.623132] bcache_allocato D ffff88007b78fc98     0  3494      2 0x00000080
[  405.624406]  ffff88007b78fc98 ffff88007b78fc68 0000000000000002 ffff88007c8ddb80
[  405.626241]  ffff8800796e0000 ffff88007b78fc78 ffff88007b790000 0000000000000005
[  405.627890]  ffff880079cf0028 0000000000000001 0000000000000001 ffff88007b78fcb8
[  405.629730] Call Trace:
[  405.630362]  [<ffffffff817a9f47>] schedule+0x37/0x90
[  405.631230]  [<ffffffffa048e4f0>] bch_bucket_alloc+0x1b0/0x670 [bcache]
[  405.632261]  [<ffffffff81103860>] ? prepare_to_wait_event+0x110/0x110
[  405.633274]  [<ffffffffa04a90d5>] bch_prio_write+0x1b5/0x390 [bcache]
[  405.634362]  [<ffffffffa048e19d>] bch_allocator_thread+0x31d/0x4c0 [bcache]
[  405.635496]  [<ffffffffa048de80>] ? invalidate_buckets+0x980/0x980 [bcache]
[  405.636655]  [<ffffffff810d734e>] kthread+0xfe/0x120
[  405.637604]  [<ffffffff817b0440>] ? _raw_spin_unlock_irq+0x30/0x50
[  405.638569]  [<ffffffff810d7250>] ? kthread_create_on_node+0x240/0x240
[  405.639628]  [<ffffffff817b11a2>] ret_from_fork+0x42/0x70
[  405.640570]  [<ffffffff810d7250>] ? kthread_create_on_node+0x240/0x240
[  405.641568] no locks held by bcache_allocato/3494.

There is a comment in the code inside of bch_allocator_thread() before it
calls bch_prio_write(ca):
	360  /*
	361   * This could deadlock if an allocation with a btree
	362   * node locked ever blocked - having the btree node
	363   * locked would block garbage collection, but here we're
	364   * waiting on garbage collection before we invalidate
	365   * and free anything.
	366   *
	367   * But this should be safe since the btree code always
	368   * uses btree_check_reserve() before allocating now, and
	369   * if it fails it blocks without btree nodes locked.
	370   */
	371   if (!fifo_full(&ca->free_inc))
	372           goto retry_invalidate;
	373 
	374   bch_prio_write(ca);

I think I'm hitting the deadlock which this comment speaks to.  


== This is the other side of the deadlock caused by registering the cache device:
  echo /dev/sdb > /sys/fs/bcache/register

[  405.578073] INFO: task bash:3490 blocked for more than 5 seconds:
[  405.580255] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ ... ]
[  405.588984]  [<ffffffff817a9f47>] schedule+0x37/0x90
[  405.589986]  [<ffffffffa048e4f0>] bch_bucket_alloc+0x1b0/0x670 [bcache]
[  405.591084]  [<ffffffff81103860>] ? prepare_to_wait_event+0x110/0x110
[  405.592078]  [<ffffffffa048eb59>] __bch_bucket_alloc_set+0x109/0x1a0 [bcache]
[  405.593113]  [<ffffffffa048ec40>] bch_bucket_alloc_set+0x50/0x70 [bcache]
[  405.594153]  [<ffffffffa04a7927>] __uuid_write+0x67/0x160 [bcache]
[  405.595223]  [<ffffffffa04a8a06>] bch_uuid_write+0x16/0x40 [bcache]
[  405.596273]  [<ffffffffa04a9877>] bch_cached_dev_attach+0x157/0x490 [bcache]
[  405.597384]  [<ffffffffa04a6b68>] ? __write_super+0x148/0x180 [bcache]
[  405.598432]  [<ffffffffa04a8986>] ? bcache_write_super+0x1d6/0x240 [bcache]
[  405.599464]  [<ffffffffa04aa761>] run_cache_set+0x601/0x910 [bcache]
[  405.600548]  [<ffffffffa04ac0ce>] register_bcache+0xeae/0x1430 [bcache]
[...]
[  405.611623] 4 locks held by bash/3490:
[  405.612342]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff8126f773>] vfs_write+0x183/0x1b0
[  405.614200]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff812faaa6>] kernfs_fop_write+0x66/0x1a0
[  405.615994]  #2:  (s_active#194){.+.+.+}, at: [<ffffffff812faaae>] kernfs_fop_write+0x6e/0x1a0
[  405.617925]  #3:  (&bch_register_lock){+.+.+.}, at: [<ffffffffa04abe70>] register_bcache+0xc50/0x1430 [bcache]


I'm rather perplexed as to why this is deadlocking because
bch_bucket_alloc_set() locks c->bucket_lock, and the allocator holds
ca->set->bucket_lock before calling bch_prio_write() .  I checked,
this is the same lock (same memory position).

This implies that the allocator waits on bch_bucket_alloc_set()
which was invoked by bash through register_bcache, and register_bcache
waits on the allocator's call to bch_prio_write().

Things that I've tried which don't work or make the problem worse:
  * Adding a mutex inside bch_bucket_alloc so that only one may proceed at a time
  * Holding bch_register_lock in the allocator thread before calling bch_prio_write.

Does anyone else have insight here that might help solve the problem?

-Eric

--
Eric Wheeler
