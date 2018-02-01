From: tang.junhui@zte.com.cn
Subject: [PATCH v2 2/2] bcache: fix high CPU occupancy during journal
Date: Thu, 1 Feb 2018 16:14:46 +0800
Message-ID: <1517472886-4240-2-git-send-email-tang.junhui@zte.com.cn>
References: <1517472886-4240-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517472886-4240-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

After long time small writing I/O running, we found the occupancy of CPU
is very high and I/O performance has been reduced by about half:

[root@ceph151 internal]# top
top - 15:51:05 up 1 day,2:43,  4 users,  load average: 16.89, 15.15, 16.53
Tasks: 2063 total,   4 running, 2059 sleeping,   0 stopped,   0 zombie
%Cpu(s):4.3 us, 17.1 sy 0.0 ni, 66.1 id, 12.0 wa,  0.0 hi,  0.5 si,  0.0 st
KiB Mem : 65450044 total, 24586420 free, 38909008 used,  1954616 buff/cache
KiB Swap: 65667068 total, 65667068 free,        0 used. 25136812 avail Mem

  PID USER PR NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
 2023 root 20  0       0      0      0 S 55.1  0.0   0:04.42 kworker/11:191
14126 root 20  0       0      0      0 S 42.9  0.0   0:08.72 kworker/10:3
 9292 root 20  0       0      0      0 S 30.4  0.0   1:10.99 kworker/6:1
 8553 ceph 20  0 4242492 1.805g  18804 S 30.0  2.9 410:07.04 ceph-osd
12287 root 20  0       0      0      0 S 26.7  0.0   0:28.13 kworker/7:85
31019 root 20  0       0      0      0 S 26.1  0.0   1:30.79 kworker/22:1
 1787 root 20  0       0      0      0 R 25.7  0.0   5:18.45 kworker/8:7
32169 root 20  0       0      0      0 S 14.5  0.0   1:01.92 kworker/23:1
21476 root 20  0       0      0      0 S 13.9  0.0   0:05.09 kworker/1:54
 2204 root 20  0       0      0      0 S 12.5  0.0   1:25.17 kworker/9:10
16994 root 20  0       0      0      0 S 12.2  0.0   0:06.27 kworker/5:106
15714 root 20  0       0      0      0 R 10.9  0.0   0:01.85 kworker/19:2
 9661 ceph 20  0 4246876 1.731g  18800 S 10.6  2.8 403:00.80 ceph-osd
11460 ceph 20  0 4164692 2.206g  18876 S 10.6  3.5 360:27.19 ceph-osd
 9960 root 20  0       0      0      0 S 10.2  0.0   0:02.75 kworker/2:139
11699 ceph 20  0 4169244 1.920g  18920 S 10.2  3.1 355:23.67 ceph-osd
 6843 ceph 20  0 4197632 1.810g  18900 S  9.6  2.9 380:08.30 ceph-osd

The kernel work consumed a lot of CPU, and I found they are running journal
work, The journal is reclaiming source and flush btree node with surprising
frequency.

Through further analysis, we found that in btree_flush_write(), we try to
get a btree node with the smallest fifo idex to flush by traverse all the
btree nodein c->bucket_hash, after we getting it, since no locker protects
it, this btree node may have been written to cache device by other works,
and if this occurred, we retry to traverse in c->bucket_hash and get
another btree node. When the problem occurrd, the retry times is very high,
and we consume a lot of CPU in looking for a appropriate btree node.

In this patch, we try to record 128 btree nodes with the smallest fifo idex
in heap, and pop one by one when we need to flush btree node. It greatly
reduces the time for the loop to find the appropriate BTREE node, and also
reduce the occupancy of CPU.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/bcache.h  |  2 ++
 drivers/md/bcache/journal.c | 47 ++++++++++++++++++++++++++++++---------------
 drivers/md/bcache/util.h    |  2 ++
 3 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 0432e28..b343ba4 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -669,6 +669,8 @@ struct cache_set {
 
 #define BUCKET_HASH_BITS	12
 	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
+
+	DECLARE_HEAP(struct btree *, flush_btree);
 };
 
 struct bbio {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 47fd0b8..f42d3ea 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -363,6 +363,12 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 }
 
 /* Journalling */
+#define journal_max_cmp(l, r) \
+	(fifo_idx(&c->journal.pin, btree_current_write(l)->journal) < \
+	 fifo_idx(&(c)->journal.pin, btree_current_write(r)->journal))
+#define journal_min_cmp(l, r) \
+	(fifo_idx(&c->journal.pin, btree_current_write(l)->journal) > \
+	 fifo_idx(&(c)->journal.pin, btree_current_write(r)->journal))
 
 static void btree_flush_write(struct cache_set *c)
 {
@@ -370,25 +376,35 @@ static void btree_flush_write(struct cache_set *c)
 	 * Try to find the btree node with that references the oldest journal
 	 * entry, best is our current candidate and is locked if non NULL:
 	 */
-	struct btree *b, *best;
-	unsigned i;
+	struct btree *b;
+	int i;
 
 	atomic_long_inc(&c->flush_write);
+
 retry:
-	best = NULL;
-
-	for_each_cached_btree(b, c, i)
-		if (btree_current_write(b)->journal) {
-			if (!best)
-				best = b;
-			else if (journal_pin_cmp(c,
-					btree_current_write(best)->journal,
-					btree_current_write(b)->journal)) {
-				best = b;
+	spin_lock(&c->journal.lock);
+	if (heap_empty(&c->flush_btree)) {
+		for_each_cached_btree(b, c, i)
+			if (btree_current_write(b)->journal) {
+				if (!heap_full(&c->flush_btree))
+					heap_add(&c->flush_btree, b,
+						 journal_max_cmp);
+				else if (journal_max_cmp(b,
+					 heap_peek(&c->flush_btree))) {
+					c->flush_btree.data[0] = b;
+					heap_sift(&c->flush_btree, 0,
+						  journal_max_cmp);
+				}
 			}
-		}
 
-	b = best;
+		for (i = c->flush_btree.used / 2 - 1; i >= 0; --i)
+			heap_sift(&c->flush_btree, i, journal_min_cmp);
+	}
+
+	b = NULL;
+	heap_pop(&c->flush_btree, b, journal_min_cmp);
+	spin_unlock(&c->journal.lock);
+
 	if (b) {
 		mutex_lock(&b->write_lock);
 		if (!btree_current_write(b)->journal) {
@@ -819,7 +835,8 @@ int bch_journal_alloc(struct cache_set *c)
 	j->w[0].c = c;
 	j->w[1].c = c;
 
-	if (!(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
+	if (!(init_heap(&c->flush_btree, 128, GFP_KERNEL)) ||
+	    !(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
 	    !(j->w[0].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)) ||
 	    !(j->w[1].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)))
 		return -ENOMEM;
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index f54b582..809bc99 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -112,6 +112,8 @@
 
 #define heap_full(h)	((h)->used == (h)->size)
 
+#define heap_empty(h)	((h)->used == 0)
+
 #define DECLARE_FIFO(type, name)					\
 	struct {							\
 		size_t front, back, size, mask;				\
-- 
1.8.3.1
