From: Konstantin Shalygin <k0ste@k0ste.ru>
Subject: Re: lock, Workqueue: bcache bch_data_insert_keys [bcache]
Date: Sun, 6 Aug 2017 10:40:57 +0700
Message-ID: <6d4fc08e-2ba8-009d-e54a-4d63c2477138@k0ste.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------EFE1ACF244C734A142A426CE"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from k0ste.ru ([212.20.43.218]:59524 "EHLO k0ste.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbdHFDlQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 5 Aug 2017 23:41:16 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------EFE1ACF244C734A142A426CE
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

After month of usage I can confirm that this patch resolve this issue.

-- 
Best regards,
Konstantin Shalygin


--------------EFE1ACF244C734A142A426CE
Content-Type: text/x-patch;
 name="linux-4.11-bcache_fix_for_gc_and_write-back_race.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linux-4.11-bcache_fix_for_gc_and_write-back_race.diff"

From: Tang Junhui <tang.junhui@xxxxxxxxxx>

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

Signed-off-by: Tang Junhui <tang.junhui@xxxxxxxxxx>
---
diff -Naupr linux-4.11_orig/drivers/md/bcache/bcache.h linux-4.11/drivers/md/bcache/bcache.h
--- linux-4.11_orig/drivers/md/bcache/bcache.h	2017-05-01 09:47:48.000000000 +0700
+++ linux-4.11/drivers/md/bcache/bcache.h	2017-07-08 11:49:25.044671097 +0700
@@ -333,6 +333,7 @@ struct cached_dev {
 	/* Limit number of writeback bios in flight */
 	struct semaphore	in_flight;
 	struct task_struct	*writeback_thread;
+	struct workqueue_struct	*writeback_write_wq;
 
 	struct keybuf		writeback_keys;
 
diff -Naupr linux-4.11_orig/drivers/md/bcache/super.c linux-4.11/drivers/md/bcache/super.c
--- linux-4.11_orig/drivers/md/bcache/super.c	2017-05-01 09:47:48.000000000 +0700
+++ linux-4.11/drivers/md/bcache/super.c	2017-07-08 11:50:16.574952148 +0700
@@ -1061,6 +1061,8 @@ static void cached_dev_free(struct closu
 	cancel_delayed_work_sync(&dc->writeback_rate_update);
 	if (!IS_ERR_OR_NULL(dc->writeback_thread))
 		kthread_stop(dc->writeback_thread);
+		if (dc->writeback_write_wq)
+			destroy_workqueue(dc->writeback_write_wq);
 
 	mutex_lock(&bch_register_lock);
 
diff -Naupr linux-4.11_orig/drivers/md/bcache/writeback.c linux-4.11/drivers/md/bcache/writeback.c
--- linux-4.11_orig/drivers/md/bcache/writeback.c	2017-05-01 09:47:48.000000000 +0700
+++ linux-4.11/drivers/md/bcache/writeback.c	2017-07-08 11:52:21.799010810 +0700
@@ -186,7 +186,7 @@ static void write_dirty(struct closure *
 
 	closure_bio_submit(&io->bio, cl);
 
-	continue_at(cl, write_dirty_finish, system_wq);
+	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
 }
 
 static void read_dirty_endio(struct bio *bio)
@@ -206,7 +206,7 @@ static void read_dirty_submit(struct clo
 
 	closure_bio_submit(&io->bio, cl);
 
-	continue_at(cl, write_dirty, system_wq);
+	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
 }
 
 static void read_dirty(struct cached_dev *dc)
@@ -516,6 +516,10 @@ void bch_cached_dev_writeback_init(struc
 
 int bch_cached_dev_writeback_start(struct cached_dev *dc)
 {
+	dc->writeback_write_wq = alloc_workqueue("bcache_writeback_wq", WQ_MEM_RECLAIM, 0);
+	if (!dc->writeback_write_wq)
+		return -ENOMEM;
+
 	dc->writeback_thread = kthread_create(bch_writeback_thread, dc,
 					      "bcache_writeback");
 	if (IS_ERR(dc->writeback_thread))

--------------EFE1ACF244C734A142A426CE--
