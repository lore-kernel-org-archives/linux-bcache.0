From: tang.junhui@zte.com.cn
Subject: [PATCH] bcache: fix for gc and write-back race
Date: Sat, 24 Jun 2017 17:51:17 +0800
Message-ID: <1498297877-8424-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:42046 "EHLO out1.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbdFXJwk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 24 Jun 2017 05:52:40 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net
Cc: linux-bcache@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

gc and write-back get raced (see the email "bcache get stucked" I sended
before):
gc thread						write-back thread
|							|bch_writeback_thread()
|bch_gc_thread()					|
|							|==>read_dirty()
|==>bch_btree_gc()					|
|==>btree_root() //get btree root			|
|			node write locker		|
|==>bch_btree_gc_root()					|
|							|==>read_dirty_submit()
|							|==>write_dirty()
|							|==>continue_at(cl, write_dirty_finish, system_wq);
|							|==>write_dirty_finish()//excute in system_wq
|							|==>bch_btree_insert()
|							|==>bch_btree_map_leaf_nodes()
|							|==>__bch_btree_map_nodes()
|							|==>btree_root //try to get btree root node read lock
|							|-----stuck here
|==>bch_btree_set_root()				|
|==>bch_journal_meta()					|
|==>bch_journal()					|
|==>journal_try_write()					|
|==>journal_write_unlocked() //journal_full(&c->journal) condition satisfied
|==>continue_at(cl, journal_write, system_wq); //try to excute journal_write in system_wq
|					//but work queue is excuting write_dirty_finish()
|==>closure_sync(); //wait journal_write execute over and wake up gc,
|			--stuck here
|==>release root node write locker

This patch alloc a separate work-queue for write-back thread to avoid such
race.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/bcache.h    | 1 +
 drivers/md/bcache/super.c     | 2 ++
 drivers/md/bcache/writeback.c | 8 ++++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index c3ea03c..02619ca 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -333,6 +333,7 @@ struct cached_dev {
 	/* Limit number of writeback bios in flight */
 	struct semaphore	in_flight;
 	struct task_struct	*writeback_thread;
+	struct workqueue_struct	*writeback_write_wq;
 
 	struct keybuf		writeback_keys;
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3a19cbc..98470c6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1061,6 +1061,8 @@ static void cached_dev_free(struct closure *cl)
 	cancel_delayed_work_sync(&dc->writeback_rate_update);
 	if (!IS_ERR_OR_NULL(dc->writeback_thread))
 		kthread_stop(dc->writeback_thread);
+	if (dc->writeback_write_wq)
+		destroy_workqueue(dc->writeback_write_wq);
 
 	mutex_lock(&bch_register_lock);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 69e1ae5..5e4e7a8 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -185,7 +185,7 @@ static void write_dirty(struct closure *cl)
 
 	closure_bio_submit(&io->bio, cl);
 
-	continue_at(cl, write_dirty_finish, system_wq);
+	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
 }
 
 static void read_dirty_endio(struct bio *bio)
@@ -205,7 +205,7 @@ static void read_dirty_submit(struct closure *cl)
 
 	closure_bio_submit(&io->bio, cl);
 
-	continue_at(cl, write_dirty, system_wq);
+	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
 }
 
 static void read_dirty(struct cached_dev *dc)
@@ -515,6 +515,10 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 
 int bch_cached_dev_writeback_start(struct cached_dev *dc)
 {
+	dc->writeback_write_wq = alloc_workqueue("bcache_writeback_wq", WQ_MEM_RECLAIM, 0);
+	if (!dc->writeback_write_wq)
+		return -ENOMEM;
+
 	dc->writeback_thread = kthread_create(bch_writeback_thread, dc,
 					      "bcache_writeback");
 	if (IS_ERR(dc->writeback_thread))
-- 
2.8.1.windows.1
