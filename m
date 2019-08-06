From: Andrea Righi <andrea.righi@canonical.com>
Subject: [PATCH v2] bcache: fix deadlock in bcache_allocator
Date: Tue, 6 Aug 2019 11:18:01 +0200
Message-ID: <20190806091801.GC11184@xps-13>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

bcache_allocator() can call the following:

 bch_allocator_thread()
  -> bch_prio_write()
     -> bch_bucket_alloc()
        -> wait on &ca->set->bucket_wait

But the wake up event on bucket_wait is supposed to come from
bch_allocator_thread() itself => deadlock:

[ 1158.490744] INFO: task bcache_allocato:15861 blocked for more than 10 seconds.
[ 1158.495929]       Not tainted 5.3.0-050300rc3-generic #201908042232
[ 1158.500653] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1158.504413] bcache_allocato D    0 15861      2 0x80004000
[ 1158.504419] Call Trace:
[ 1158.504429]  __schedule+0x2a8/0x670
[ 1158.504432]  schedule+0x2d/0x90
[ 1158.504448]  bch_bucket_alloc+0xe5/0x370 [bcache]
[ 1158.504453]  ? wait_woken+0x80/0x80
[ 1158.504466]  bch_prio_write+0x1dc/0x390 [bcache]
[ 1158.504476]  bch_allocator_thread+0x233/0x490 [bcache]
[ 1158.504491]  kthread+0x121/0x140
[ 1158.504503]  ? invalidate_buckets+0x890/0x890 [bcache]
[ 1158.504506]  ? kthread_park+0xb0/0xb0
[ 1158.504510]  ret_from_fork+0x35/0x40

Fix by making the call to bch_prio_write() non-blocking, so that
bch_allocator_thread() never waits on itself.

Moreover, make sure to wake up the garbage collector thread when
bch_prio_write() is failing to allocate buckets.

BugLink: https://bugs.launchpad.net/bugs/1784665
BugLink: https://bugs.launchpad.net/bugs/1796292
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
Changes in v2:
 - prevent retry_invalidate busy loop in bch_allocator_thread()

 drivers/md/bcache/alloc.c  |  5 ++++-
 drivers/md/bcache/bcache.h |  2 +-
 drivers/md/bcache/super.c  | 13 +++++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 6f776823b9ba..a1df0d95151c 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -377,7 +377,10 @@ static int bch_allocator_thread(void *arg)
 			if (!fifo_full(&ca->free_inc))
 				goto retry_invalidate;
 
-			bch_prio_write(ca);
+			if (bch_prio_write(ca, false) < 0) {
+				ca->invalidate_needs_gc = 1;
+				wake_up_gc(ca->set);
+			}
 		}
 	}
 out:
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 013e35a9e317..deb924e1d790 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -977,7 +977,7 @@ bool bch_cached_dev_error(struct cached_dev *dc);
 __printf(2, 3)
 bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...);
 
-void bch_prio_write(struct cache *ca);
+int bch_prio_write(struct cache *ca, bool wait);
 void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 
 extern struct workqueue_struct *bcache_wq;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 20ed838e9413..716ea272fb55 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -529,7 +529,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, int op,
 	closure_sync(cl);
 }
 
-void bch_prio_write(struct cache *ca)
+int bch_prio_write(struct cache *ca, bool wait)
 {
 	int i;
 	struct bucket *b;
@@ -564,8 +564,12 @@ void bch_prio_write(struct cache *ca)
 		p->magic	= pset_magic(&ca->sb);
 		p->csum		= bch_crc64(&p->magic, bucket_bytes(ca) - 8);
 
-		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, true);
-		BUG_ON(bucket == -1);
+		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
+		if (bucket == -1) {
+			if (!wait)
+				return -ENOMEM;
+			BUG_ON(1);
+		}
 
 		mutex_unlock(&ca->set->bucket_lock);
 		prio_io(ca, bucket, REQ_OP_WRITE, 0);
@@ -593,6 +597,7 @@ void bch_prio_write(struct cache *ca)
 
 		ca->prio_last_buckets[i] = ca->prio_buckets[i];
 	}
+	return 0;
 }
 
 static void prio_read(struct cache *ca, uint64_t bucket)
@@ -1954,7 +1959,7 @@ static int run_cache_set(struct cache_set *c)
 
 		mutex_lock(&c->bucket_lock);
 		for_each_cache(ca, c, i)
-			bch_prio_write(ca);
+			bch_prio_write(ca, true);
 		mutex_unlock(&c->bucket_lock);
 
 		err = "cannot allocate new UUID bucket";
-- 
2.20.1
