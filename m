From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix for allocator and register thread race
Date: Wed, 10 Jan 2018 16:51:15 +0800
Message-ID: <1515574275-10782-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:57028 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750852AbeAJIts (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Jan 2018 03:49:48 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: huarui.dev@gmail.com, colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

After long time run of random small IO writing,
reboot the machine, and after the machine power on,
bcache got stuck, the stack is:
[root@ceph153 ~]# cat /proc/2510/task/*/stack
[<ffffffffa06b2455>] closure_sync+0x25/0x90 [bcache]
[<ffffffffa06b6be8>] bch_journal+0x118/0x2b0 [bcache]
[<ffffffffa06b6dc7>] bch_journal_meta+0x47/0x70 [bcache]
[<ffffffffa06be8f7>] bch_prio_write+0x237/0x340 [bcache]
[<ffffffffa06a8018>] bch_allocator_thread+0x3c8/0x3d0 [bcache]
[<ffffffff810a631f>] kthread+0xcf/0xe0
[<ffffffff8164c318>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff
[root@ceph153 ~]# cat /proc/2038/task/*/stack
[<ffffffffa06b1abd>] __bch_btree_map_nodes+0x12d/0x150 [bcache]
[<ffffffffa06b1bd1>] bch_btree_insert+0xf1/0x170 [bcache]
[<ffffffffa06b637f>] bch_journal_replay+0x13f/0x230 [bcache]
[<ffffffffa06c75fe>] run_cache_set+0x79a/0x7c2 [bcache]
[<ffffffffa06c0cf8>] register_bcache+0xd48/0x1310 [bcache]
[<ffffffff812f702f>] kobj_attr_store+0xf/0x20
[<ffffffff8125b216>] sysfs_write_file+0xc6/0x140
[<ffffffff811dfbfd>] vfs_write+0xbd/0x1e0
[<ffffffff811e069f>] SyS_write+0x7f/0xe0
[<ffffffff8164c3c9>] system_call_fastpath+0x16/0x1
The stack shows the register thread and allocator thread
were getting stuck when registering cache device.

we reboot the machine several times, the issue always
exsit in this machine.

We debug the code, and found the call trace as bellow:
register_bcache()
  ==>run_cache_set()
     ==>bch_journal_replay()
        ==>bch_btree_insert()
           ==>__bch_btree_map_nodes()
              ==>btree_insert_fn()
                 ==>btree_split() //node need split
                    ==>btree_check_reserve()
In btree_check_reserve(), It will check if there is enough buckets
of RESERVE_BTREE type, since allocator thread did not work yet, so
no buckets of RESERVE_BTREE type allocated, so the register thread
waits on c->btree_cache_wait, and goes to sleep.

Then the allocator thread initialized, and goes to work,
the call trace is bellow:
bch_allocator_thread()
  ==>bch_prio_write()
     ==>bch_journal_meta()
        ==>bch_journal()
           ==>journal_wait_for_write()
In journal_wait_for_write(), It will check if journal is full by
journal_full(), but the long time random small IO writing
causes the exhaustion of journal buckets(journal.blocks_free=0),
In order to release the journal buckets,
the allocator calls btree_flush_write() to flush keys to
btree nodes, and waits on c->journal.wait until btree nodes writing over
or there has already some journal buckets space, then the allocator
thread goes to sleep. but in btree_flush_write(), since
bch_journal_replay() is not finished, so no btree nodes have journal
(condition "if (btree_current_write(b)->journal)" never satisfied),
so we got no btree node to flush, no journal bucket released,
and allocator sleep all the times.

Through the above analysis, we can see that:
1) Register thread wait for allocator thread to allocate buckets of
   RESERVE_BTREE type;
2) Alloctor thread wait for register thread to replay journal, so it
   can flush btree nodes and get journal bucket.
   then they are all got stuck by waiting for each other.

Hua Rui provided a patch for me, by allocating some buckets of
RESERVE_BTREE type in advance, so the register thread can get bucket
when btree node splitting and no need to waiting for the allocator thread.
I tested it, it has effect, and register thread run a step forward, but
finally are still got stuck, the reason is only 8 bucket of RESERVE_BTREE
type were allocated, and in bch_journal_replay(), after 2 btree nodes
splitting, only 4 bucket of RESERVE_BTREE type left, then
btree_check_reserve() is not satisfied anymore, so it goes to sleep again,
and in the same time, alloctor thread did not flush enough btree nodes to
release a journal bucket, so they all got stuck again.

So we need to allocate more buckets of RESERVE_BTREE type in advance,
but how much is enough?  By experience and test, I think it should be
as much as journal buckets. Then I modify the code as this patch,
and test in the machine, and it works.

This patch modified base on Hua Rui’s patch, and allocate more buckets
of RESERVE_BTREE type in advance to avoid register thread and allocate
thread going to wait for each other.

Signed-off-by: Hua Rui <huarui.dev@gmail.com>
Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/btree.c |  9 ++++++---
 drivers/md/bcache/super.c | 12 +++++++++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 658c54b..d222a9b 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1865,14 +1865,17 @@ void bch_initial_gc_finish(struct cache_set *c)
 	 */
 	for_each_cache(ca, c, i) {
 		for_each_bucket(b, ca) {
-			if (fifo_full(&ca->free[RESERVE_PRIO]))
+			if (fifo_full(&ca->free[RESERVE_PRIO]) &&
+			    fifo_full(&ca->free[RESERVE_BTREE]))
 				break;
 
 			if (bch_can_invalidate_bucket(ca, b) &&
 			    !GC_MARK(b)) {
 				__bch_invalidate_one_bucket(ca, b);
-				fifo_push(&ca->free[RESERVE_PRIO],
-					  b - ca->buckets);
+				if (!fifo_push(&ca->free[RESERVE_PRIO],
+				   b - ca->buckets))
+					fifo_push(&ca->free[RESERVE_BTREE],
+						  b - ca->buckets);
 			}
 		}
 	}
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fc0a31b..b34e18b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1812,6 +1812,7 @@ void bch_cache_release(struct kobject *kobj)
 static int cache_alloc(struct cache *ca)
 {
 	size_t free;
+	size_t btree_buckets;
 	struct bucket *b;
 
 	__module_get(THIS_MODULE);
@@ -1819,9 +1820,18 @@ static int cache_alloc(struct cache *ca)
 
 	bio_init(&ca->journal.bio, ca->journal.bio.bi_inline_vecs, 8);
 
+	/*
+	 * in bch_journal_replay(), btree node may split,
+	 * so bucket of RESERVE_BTREE type is needed,
+	 * the worst situation is all journal buckets are valid,
+	 * and all the keys need to replay,
+	 * so the number of  RESERVE_BTREE type buckets should be as much
+	 * as journal buckets
+	 */
+	btree_buckets = ca->sb.njournal_buckets;
 	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
 
-	if (!init_fifo(&ca->free[RESERVE_BTREE], 8, GFP_KERNEL) ||
+	if (!init_fifo(&ca->free[RESERVE_BTREE], btree_buckets, GFP_KERNEL) ||
 	    !init_fifo_exact(&ca->free[RESERVE_PRIO], prio_buckets(ca), GFP_KERNEL) ||
 	    !init_fifo(&ca->free[RESERVE_MOVINGGC], free, GFP_KERNEL) ||
 	    !init_fifo(&ca->free[RESERVE_NONE], free, GFP_KERNEL) ||
-- 
1.8.3.1
