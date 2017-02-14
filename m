From: Rui Hua <flowerui@gmail.com>
Subject: Re: bcache register deadlock in bcache_bucket_alloc() between
 bch_uuid_write and bch_prio_write
Date: Tue, 14 Feb 2017 10:47:01 +0800
Message-ID: <CAMO59RDrWbkz3s+UoC3HgB9CSo-+UXeB8posvG6aP+XwmvGaAw@mail.gmail.com>
References: <alpine.LRH.2.11.1604040040030.5857@mail.ewheeler.net>
 <CAMO59RDYhZZZsjyg2hsCxpU8=_VEhDA6j__=TXTHZKtQVyxpBw@mail.gmail.com>
 <alpine.LRH.2.11.1702111545180.5783@mail.ewheeler.net> <CAMO59RBbyfvHXvJgrijuGQyua8nqYh1+nUpLk6oGETS2_UOg0Q@mail.gmail.com>
 <alpine.LRH.2.11.1702131727410.5783@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36575 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdBNCrD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Feb 2017 21:47:03 -0500
Received: by mail-qk0-f196.google.com with SMTP id p22so9721550qka.3
        for <linux-bcache@vger.kernel.org>; Mon, 13 Feb 2017 18:47:02 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1702131727410.5783@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

Hi, kent & Eric
Unfortunately I can't reproduce that problem in my environment. I
think this is a solution, is this safe ??

--- ./linux-4.4.48/drivers/md/bcache/btree.c 2017-02-09 15:02:59.000000000 +0800
+++ btree.c 2017-02-14 10:07:56.000000000 +0800
@@ -1866,14 +1866,15 @@
     */
    for_each_cache(ca, c, i) {
        for_each_bucket(b, ca) {
-           if (fifo_full(&ca->free[RESERVE_PRIO]))
+          if (fifo_full(&ca->free[RESERVE_PRIO]) &&
+                fifo_full(&ca->free[RESERVE_BTREE]))
                break;

            if (bch_can_invalidate_bucket(ca, b) &&
                !GC_MARK(b)) {
                __bch_invalidate_one_bucket(ca, b);
-               fifo_push(&ca->free[RESERVE_PRIO],
-                     b - ca->buckets);
+               if (!fifo_push(&ca->free[RESERVE_PRIO], b - ca->buckets))
+                     fifo_push(&ca->free[RESERVE_BTREE], b - ca->buckets);
            }
        }
    }

2017-02-14 9:29 GMT+08:00 Eric Wheeler <bcache@lists.ewheeler.net>:
>
> On Mon, 13 Feb 2017, Rui Hua wrote:
>
>> Thanks for reply.
>>
>> Yes, the patch you mentioned is already in my code.
>> There is different between this patch and my problem, the problem
>> which this patch solves is hanging on RESERVE_PRIO buckets alloc,
>> but in my environment, the allocator thread hang on RESERVE_BTREE
>> buckets alloc(bch_journal())
>
> Ahh, ok, interesting.  You could try adding _exact to the allocator like
> the other patch and see if that fixes it.
>
> Kent, does this sound safe?
>
>
> --
> Eric Wheeler
>
>>
>> The patch calltrace:
>> [  405.629730] Call Trace:
>> [  405.630362]  [<ffffffff817a9f47>] schedule+0x37/0x90
>> [  405.631230]  [<ffffffffa048e4f0>] bch_bucket_alloc+0x1b0/0x670 [bcache]
>> [  405.632261]  [<ffffffff81103860>] ? prepare_to_wait_event+0x110/0x110
>> [  405.633274]  [<ffffffffa04a90d5>] bch_prio_write+0x1b5/0x390 [bcache]
>> [  405.634362]  [<ffffffffa048e19d>] bch_allocator_thread+0x31d/0x4c0 [bcache]
>>
>> My calltrace:
>> [  +0.000002] Call Trace:
>> [  +0.000003]  [<ffffffff8163a909>] schedule+0x29/0x70
>> [  +0.000005]  [<ffffffffa0453c05>] closure_sync+0x25/0x90 [bcache]
>> [  +0.000004]  [<ffffffffa04584b8>] bch_journal+0x128/0x340 [bcache]
>> [  +0.000005]  [<ffffffffa0458717>] bch_journal_meta+0x47/0x70 [bcache]
>> [  +0.000002]  [<ffffffff8163a909>] ? schedule+0x29/0x70
>> [  +0.000004]  [<ffffffffa0453c05>] ? closure_sync+0x25/0x90 [bcache]
>> [  +0.000005]  [<ffffffffa045ef5b>] ? prio_io+0xfb/0x170 [bcache]
>> [  +0.000002]  [<ffffffff81638b42>] ? mutex_lock+0x12/0x2f
>> [  +0.000005]  [<ffffffffa0461407>] bch_prio_write+0x237/0x340 [bcache]
>> [  +0.000004]  [<ffffffffa0448cf0>] ? invalidate_buckets+0x9c0/0x9c0 [bcache]
>> [  +0.000004]  [<ffffffffa04490b8>] bch_allocator_thread+0x3c8/0x3d0 [bcache]
>>
>>
>>
>> 2017-02-12 7:49 GMT+08:00 Eric Wheeler <bcache@lists.ewheeler.net>:
>> > On Sat, 11 Feb 2017, Rui Hua wrote:
>> >
>> >> Hi Eric,
>> >> Does this problem fixed?
>> >> I'm hitting a deadlock which is similar to yours: I backport bcache
>> >> code from 4.4.24 to kernel 3.10.0-327.el7.x86_64(CentOS7.2), It has
>> >> been working fine many days (writeback mode, the caching device is a
>> >> Intel DC S3700 200G, attached 5 HDD disks).
>> >
>> > Maybe try this patch:
>> >
>> > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=2d64cbc819b13ebd503780f39552827516f4ce4a
>> >
>> > Its the only one I can think of.  However, it might already be in 4.4.24.
>> > You would need to check and see if you have this or not.
>> >
>> >
>> > --
>> > Eric Wheeler
>> >
>> >
>> >> Today, I reboot the system  when running some XFS benchmarks over all
>> >> cachedevs, After the system is startup, the task of register
>> >> command(echo /dev/sdg > /sys/fs/bcache/register) hang, and the dmesg
>> >> info as follow (/dev/sdg is my S3700 SSD):
>> >>
>> >> [Feb10 20:31] INFO: task bash:2615 blocked for more than 120 seconds.
>> >> [  +0.000059] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> >> disables this message.
>> >> [  +0.000059] bash            D ffff88022f86a060     0  2615   2611 0x00000080
>> >> [  +0.000007]  ffff88022e833b28 0000000000000082 ffff88022f985c00
>> >> ffff88022e833fd8
>> >> [  +0.000006]  ffff88022e833fd8 ffff88022e833fd8 ffff88022f985c00
>> >> ffff88022ddc0000
>> >> [  +0.000004]  00000000fffffffc ffff88022f86a000 ffff88022e833bb0
>> >> ffff88022f86a060
>> >> [  +0.000005] Call Trace:
>> >> [  +0.000013]  [<ffffffff8163a909>] schedule+0x29/0x70
>> >> [  +0.000016]  [<ffffffffa045701d>] __bch_btree_map_nodes+0x12d/0x150 [bcache]
>> >> [  +0.000010]  [<ffffffffa0456700>] ?
>> >> bch_btree_insert_check_key+0x1d0/0x1d0 [bcache]
>> >> [  +0.000010]  [<ffffffffa0457131>] bch_btree_insert+0xf1/0x170 [bcache]
>> >> [  +0.000006]  [<ffffffff810a6ae0>] ? wake_up_atomic_t+0x30/0x30
>> >> [  +0.000011]  [<ffffffffa045bbda>] bch_journal_replay+0x14a/0x260 [bcache]
>> >> [  +0.000007]  [<ffffffff8101cd69>] ? sched_clock+0x9/0x10
>> >> [  +0.000008]  [<ffffffff810b8a66>] ? try_to_wake_up+0x1b6/0x300
>> >> [  +0.000013]  [<ffffffffa04673dd>] run_cache_set+0x56d/0x950 [bcache]
>> >> [  +0.000012]  [<ffffffffa0468ec3>] register_bcache+0xde3/0x1370 [bcache]
>> >> [  +0.000008]  [<ffffffff812f4d0f>] kobj_attr_store+0xf/0x20
>> >> [  +0.000005]  [<ffffffff81259176>] sysfs_write_file+0xc6/0x140
>> >> [  +0.000006]  [<ffffffff811de5cd>] vfs_write+0xbd/0x1e0
>> >> [  +0.000003]  [<ffffffff811df06f>] SyS_write+0x7f/0xe0
>> >> [  +0.000006]  [<ffffffff81645909>] system_call_fastpath+0x16/0x1b
>> >> [  +0.000006] INFO: task bcache_allocato:2676 blocked for more than 120 seconds.
>> >> [  +0.000054] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> >> disables this message.
>> >> [  +0.000057] bcache_allocato D 0000000000000001     0  2676      2 0x00000080
>> >> [  +0.000004]  ffff880220edfc78 0000000000000046 ffff8800b8ed0b80
>> >> ffff880220edffd8
>> >> [  +0.000005]  ffff880220edffd8 ffff880220edffd8 ffff8800b8ed0b80
>> >> ffff880220edfce0
>> >> [  +0.000004]  ffff8800b8ed0b80 ffff88022ddd8870 ffff8800b9cae320
>> >> 0000000000000001
>> >> [  +0.000004] Call Trace:
>> >> [  +0.000005]  [<ffffffff8163a909>] schedule+0x29/0x70
>> >> [  +0.000010]  [<ffffffffa0457c05>] closure_sync+0x25/0x90 [bcache]
>> >> [  +0.000011]  [<ffffffffa045c4b8>] bch_journal+0x128/0x340 [bcache]
>> >> [  +0.000009]  [<ffffffffa045c717>] bch_journal_meta+0x47/0x70 [bcache]
>> >> [  +0.000005]  [<ffffffff8163a909>] ? schedule+0x29/0x70
>> >> [  +0.000009]  [<ffffffffa0457c05>] ? closure_sync+0x25/0x90 [bcache]
>> >> [  +0.000011]  [<ffffffffa0462f5b>] ? prio_io+0xfb/0x170 [bcache]
>> >> [  +0.000004]  [<ffffffff81638b42>] ? mutex_lock+0x12/0x2f
>> >> [  +0.000011]  [<ffffffffa0465407>] bch_prio_write+0x237/0x340 [bcache]
>> >> [  +0.000008]  [<ffffffffa044ccf0>] ? invalidate_buckets+0x9c0/0x9c0 [bcache]
>> >> [  +0.000009]  [<ffffffffa044d0b8>] bch_allocator_thread+0x3c8/0x3d0 [bcache]
>> >> [  +0.000008]  [<ffffffffa044ccf0>] ? invalidate_buckets+0x9c0/0x9c0 [bcache]
>> >> [  +0.000007]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
>> >> [  +0.000005]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
>> >> [  +0.000005]  [<ffffffff81645858>] ret_from_fork+0x58/0x90
>> >> [  +0.000006]  [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
>> >>
>> >> The trace info as fallow:
>> >> [root@localhost ~]# perf record -e 'bcache:*' -o /tmp/perf.data -a
>> >> ^C[ perf record: Woken up 1 times to write data ]
>> >> [bcache] with build id 4ce18096008788e940370b93dcb21b5711b7bed6 not
>> >> found, continuing without symbols
>> >> [ perf record: Captured and wrote 0.207 MB /tmp/perf.data (675 samples) ]
>> >> [root@localhost ~]#
>> >> [root@localhost ~]# cd /tmp/
>> >> [root@localhost tmp]# perf script
>> >>             bash  2615 [004]    97.000138: bcache:bcache_btree_read:
>> >> bucket 186634
>> >>             .......
>> >>             bash  2615 [004]    98.708044: bcache:bcache_btree_read:
>> >> bucket 122988
>> >>             bash  2615 [004]    98.711088: bcache:bcache_btree_read:
>> >> bucket 270990
>> >>             bash  2615 [004]    98.741592:
>> >> bcache:bcache_journal_replay_key: 3:978301904 len 16 dirty 1
>> >>         kthreadd  2676 [002]    98.756234: bcache:bcache_alloc:
>> >> allocated 8,98 sector=1024
>> >>         kthreadd  2676 [002]    98.760511: bcache:bcache_alloc:
>> >> allocated 8,98 sector=1024
>> >>         kthreadd  2676 [002]    98.762685: bcache:bcache_journal_full: (nil)U
>> >>
>> >> ====
>> >> Looks like deadlock between the SSD register command and
>> >> bcache_allocator thread? The trace info tell us the journal is full,
>> >> so the allocator thread waits on
>> >> bch_prio_write()->prio_io()->bch_journal_meta(), but there is no
>> >> RESERVE_BTREE buckets to use for journal replay at this time, so
>> >> register waits on bch_journal_replay()->bch_btree_insert()
>> >>
>> >> 2016-04-04 9:07 GMT+08:00 Eric Wheeler <bcache@lists.ewheeler.net>:
>> >> > Hello all,
>> >> >
>> >> > I have a test system that won't register.  I can register either the
>> >> > caching dev or the cached dev fine, but as soon as I register the
>> >> > sencond dev, bash hangs when echoing into /sys/fs/bcache/register .
>> >> > I can register in either order (cache first or cached dev first) and
>> >> > the deadlock still presents.
>> >> >
>> >> > I've narrowed down the problem to these two call stacks:
>> >> >
>> >> >
>> >> > == The allocator thread is one half of the deadlock:
>> >> >
>> >> > [  405.619895] INFO: task bcache_allocato:3494 blocked for more than 5 seconds.
>> >> > [  405.620897]       Tainted: G        W  O    4.1.20+ #5
>> >> > [  405.621732] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> > [  405.623132] bcache_allocato D ffff88007b78fc98     0  3494      2 0x00000080
>> >> > [  405.624406]  ffff88007b78fc98 ffff88007b78fc68 0000000000000002 ffff88007c8ddb80
>> >> > [  405.626241]  ffff8800796e0000 ffff88007b78fc78 ffff88007b790000 0000000000000005
>> >> > [  405.627890]  ffff880079cf0028 0000000000000001 0000000000000001 ffff88007b78fcb8
>> >> > [  405.629730] Call Trace:
>> >> > [  405.630362]  [<ffffffff817a9f47>] schedule+0x37/0x90
>> >> > [  405.631230]  [<ffffffffa048e4f0>] bch_bucket_alloc+0x1b0/0x670 [bcache]
>> >> > [  405.632261]  [<ffffffff81103860>] ? prepare_to_wait_event+0x110/0x110
>> >> > [  405.633274]  [<ffffffffa04a90d5>] bch_prio_write+0x1b5/0x390 [bcache]
>> >> > [  405.634362]  [<ffffffffa048e19d>] bch_allocator_thread+0x31d/0x4c0 [bcache]
>> >> > [  405.635496]  [<ffffffffa048de80>] ? invalidate_buckets+0x980/0x980 [bcache]
>> >> > [  405.636655]  [<ffffffff810d734e>] kthread+0xfe/0x120
>> >> > [  405.637604]  [<ffffffff817b0440>] ? _raw_spin_unlock_irq+0x30/0x50
>> >> > [  405.638569]  [<ffffffff810d7250>] ? kthread_create_on_node+0x240/0x240
>> >> > [  405.639628]  [<ffffffff817b11a2>] ret_from_fork+0x42/0x70
>> >> > [  405.640570]  [<ffffffff810d7250>] ? kthread_create_on_node+0x240/0x240
>> >> > [  405.641568] no locks held by bcache_allocato/3494.
>> >> >
>> >> > There is a comment in the code inside of bch_allocator_thread() before it
>> >> > calls bch_prio_write(ca):
>> >> >         360  /*
>> >> >         361   * This could deadlock if an allocation with a btree
>> >> >         362   * node locked ever blocked - having the btree node
>> >> >         363   * locked would block garbage collection, but here we're
>> >> >         364   * waiting on garbage collection before we invalidate
>> >> >         365   * and free anything.
>> >> >         366   *
>> >> >         367   * But this should be safe since the btree code always
>> >> >         368   * uses btree_check_reserve() before allocating now, and
>> >> >         369   * if it fails it blocks without btree nodes locked.
>> >> >         370   */
>> >> >         371   if (!fifo_full(&ca->free_inc))
>> >> >         372           goto retry_invalidate;
>> >> >         373
>> >> >         374   bch_prio_write(ca);
>> >> >
>> >> > I think I'm hitting the deadlock which this comment speaks to.
>> >> >
>> >> >
>> >> > == This is the other side of the deadlock caused by registering the cache device:
>> >> >   echo /dev/sdb > /sys/fs/bcache/register
>> >> >
>> >> > [  405.578073] INFO: task bash:3490 blocked for more than 5 seconds:
>> >> > [  405.580255] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> > [ ... ]
>> >> > [  405.588984]  [<ffffffff817a9f47>] schedule+0x37/0x90
>> >> > [  405.589986]  [<ffffffffa048e4f0>] bch_bucket_alloc+0x1b0/0x670 [bcache]
>> >> > [  405.591084]  [<ffffffff81103860>] ? prepare_to_wait_event+0x110/0x110
>> >> > [  405.592078]  [<ffffffffa048eb59>] __bch_bucket_alloc_set+0x109/0x1a0 [bcache]
>> >> > [  405.593113]  [<ffffffffa048ec40>] bch_bucket_alloc_set+0x50/0x70 [bcache]
>> >> > [  405.594153]  [<ffffffffa04a7927>] __uuid_write+0x67/0x160 [bcache]
>> >> > [  405.595223]  [<ffffffffa04a8a06>] bch_uuid_write+0x16/0x40 [bcache]
>> >> > [  405.596273]  [<ffffffffa04a9877>] bch_cached_dev_attach+0x157/0x490 [bcache]
>> >> > [  405.597384]  [<ffffffffa04a6b68>] ? __write_super+0x148/0x180 [bcache]
>> >> > [  405.598432]  [<ffffffffa04a8986>] ? bcache_write_super+0x1d6/0x240 [bcache]
>> >> > [  405.599464]  [<ffffffffa04aa761>] run_cache_set+0x601/0x910 [bcache]
>> >> > [  405.600548]  [<ffffffffa04ac0ce>] register_bcache+0xeae/0x1430 [bcache]
>> >> > [...]
>> >> > [  405.611623] 4 locks held by bash/3490:
>> >> > [  405.612342]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff8126f773>] vfs_write+0x183/0x1b0
>> >> > [  405.614200]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff812faaa6>] kernfs_fop_write+0x66/0x1a0
>> >> > [  405.615994]  #2:  (s_active#194){.+.+.+}, at: [<ffffffff812faaae>] kernfs_fop_write+0x6e/0x1a0
>> >> > [  405.617925]  #3:  (&bch_register_lock){+.+.+.}, at: [<ffffffffa04abe70>] register_bcache+0xc50/0x1430 [bcache]
>> >> >
>> >> >
>> >> > I'm rather perplexed as to why this is deadlocking because
>> >> > bch_bucket_alloc_set() locks c->bucket_lock, and the allocator holds
>> >> > ca->set->bucket_lock before calling bch_prio_write() .  I checked,
>> >> > this is the same lock (same memory position).
>> >> >
>> >> > This implies that the allocator waits on bch_bucket_alloc_set()
>> >> > which was invoked by bash through register_bcache, and register_bcache
>> >> > waits on the allocator's call to bch_prio_write().
>> >> >
>> >> > Things that I've tried which don't work or make the problem worse:
>> >> >   * Adding a mutex inside bch_bucket_alloc so that only one may proceed at a time
>> >> >   * Holding bch_register_lock in the allocator thread before calling bch_prio_write.
>> >> >
>> >> > Does anyone else have insight here that might help solve the problem?
>> >> >
>> >> > -Eric
>> >> >
>> >> > --
>> >> > Eric Wheeler
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>>
