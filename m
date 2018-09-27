From: guoju <fangguoju@gmail.com>
Subject: [PATCH] bcache: add separate workqueue for journal_write to avoid deadlock
Date: Thu, 27 Sep 2018 21:45:19 +0800
Message-ID: <1538055919-5757-1-git-send-email-fangguoju@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guoju <fangguoju@gmail.com>
List-Id: linux-bcache@vger.kernel.org

After write SSD completed, bcache schedule journal_write work to
system_wq, that is a public workqueue in system, without WQ_MEM_RECLAIM
flag. system_wq is also a bound wq, and there may be no idle kworker on
current processor. Creating a new kworker may unfortunately need to
reclaim memory first, by shrinking cache and slab used by vfs, which
depends on bcache device. That's a deadlock.

This patch create a new workqueue for journal_write with WQ_MEM_RECLAIM
flag. It's rescuer thread will work to avoid the deadlock.

Signed-off-by: guoju <fangguoju@gmail.com>
---
 drivers/md/bcache/bcache.h  | 1 +
 drivers/md/bcache/journal.c | 6 +++---
 drivers/md/bcache/super.c   | 8 ++++++++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 83504dd..954dad2 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -965,6 +965,7 @@ bool bch_alloc_sectors(struct cache_set *c, struct bkey *k,
 void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 
 extern struct workqueue_struct *bcache_wq;
+extern struct workqueue_struct *bch_journal_wq;
 extern struct mutex bch_register_lock;
 extern struct list_head bch_cache_sets;
 
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 6116bbf..522c742 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -485,7 +485,7 @@ static void do_journal_discard(struct cache *ca)
 
 		closure_get(&ca->set->cl);
 		INIT_WORK(&ja->discard_work, journal_discard_work);
-		schedule_work(&ja->discard_work);
+		queue_work(bch_journal_wq, &ja->discard_work);
 	}
 }
 
@@ -592,7 +592,7 @@ static void journal_write_done(struct closure *cl)
 		: &j->w[0];
 
 	__closure_wake_up(&w->wait);
-	continue_at_nobarrier(cl, journal_write, system_wq);
+	continue_at_nobarrier(cl, journal_write, bch_journal_wq);
 }
 
 static void journal_write_unlock(struct closure *cl)
@@ -627,7 +627,7 @@ static void journal_write_unlocked(struct closure *cl)
 		spin_unlock(&c->journal.lock);
 
 		btree_flush_write(c);
-		continue_at(cl, journal_write, system_wq);
+		continue_at(cl, journal_write, bch_journal_wq);
 		return;
 	}
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3ede144..64715a8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -47,6 +47,7 @@
 static DEFINE_IDA(bcache_device_idx);
 static wait_queue_head_t unregister_wait;
 struct workqueue_struct *bcache_wq;
+struct workqueue_struct *bch_journal_wq;
 
 #define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
 /* limitation of partitions number on single bcache device */
@@ -2344,6 +2345,9 @@ static void bcache_exit(void)
 		kobject_put(bcache_kobj);
 	if (bcache_wq)
 		destroy_workqueue(bcache_wq);
+	if (bch_journal_wq)
+		destroy_workqueue(bch_journal_wq);
+
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
@@ -2373,6 +2377,10 @@ static int __init bcache_init(void)
 	if (!bcache_wq)
 		goto err;
 
+	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
+	if (!bch_journal_wq)
+		goto err;
+
 	bcache_kobj = kobject_create_and_add("bcache", fs_kobj);
 	if (!bcache_kobj)
 		goto err;
-- 
1.8.3.1
