Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EF93B9933
	for <linux-bcache@vger.kernel.org>; Wed, 27 May 2026 08:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779870608; cv=none; b=H/hZPmb0Jec6mjaQ2zNjBFi6ktflxzRxXmzZ9FBXvNHkW9J41zOSLrM9ttKIdhzf46Kxy/Sz0ASZMzGFgu0a3B+9MEcMEnWJNEsB02iOHJt6dwbE8mCnosYboRdpgpYcau2YlAPe0fM0aPoo4cENEApPXL/NCFVK4AhNRNJibkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779870608; c=relaxed/simple;
	bh=iGJ87GHcMlAXiZTbTh1pBeISbGaoZsvFHfVqdXsCNr8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qHmvUdEPJbcXn7KiJfgSqPjJ/IYB04mOXk317P4Cr8IJS2rh1HuH3kOadHVs8Lvq3CdMEETBq5sTkxhPUa4kK1jp9jBGALVy2JZlvsCiq4vaLqWrwgZEgK5S5I7r3Yo93f8ob4fclBCLmvZtUoisxDZUbe38bEFVQugfxU7cPdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinsec.com.cn; spf=pass smtp.mailfrom=kylinsec.com.cn; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinsec.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinsec.com.cn
X-QQ-mid: esmtpgz10t1779870596tb58a0649
X-QQ-Originating-IP: AnnOPJCF87UwMAp6W7fd9pkNLkqR1R6a/HXDHPRP5bM=
Received: from ksvd-Standard-PC-i440FX-PIIX-19 ( [175.11.89.213])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 16:28:38 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 970392071818683256
EX-QQ-RecipientCnt: 3
From: Zhou Jifeng <zhoujifeng@kylinsec.com.cn>
To: colyli@fygo.io,
	linux-bcache@vger.kernel.org
Cc: zhoujifeng@kylinsec.com.cn
Subject: [PATCH RFC v3] bcache: flush backing device before cleaning the writeback dirty keys
Date: Wed, 27 May 2026 01:27:50 -0700
Message-Id: <20260527082750.726707-1-zhoujifeng@kylinsec.com.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:kylinsec.com.cn:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MOhA8RfXD6A4rWywrZBvO2rPNPKhHLR1seCJUqGz41uxqO/2bYGQ+6fP
	lO4ZeYWZE5DcorTEzCUcHHQVmnptZUF1v36F6MgSBI8XUcl/eqfSlJ51oUSFdMUqh2KHgHY
	uVQfynI0NYiU9cAjjPgFtmvr1hvapajZbExM0lnZGawUyuD+c7bJitld4rHgcSXdacJwOoS
	7+AqwGR9clTRC32JovGy/I717OWJqSRmsBCA8KmqMBm0gDT7Fe0M/5t0i3TGJhsqBk4PFnj
	HmaE96W1jveA50u/CSSY7CxxZhINs3g5sSFSzjyd38CrtF+woBK//kf5OLp+6iqjoPOfir8
	vxuzwt3EqiQN9qtoPlH8KPejOuBARYedk/rD71XSMHolS0Qji5N3h5MwYjwrRM4iTu7fzrE
	6i+S6XF91RBlYSnpJDIlWptCHn8zkiAg7mdI8r8O0Opzp7NKtxvonBAo3x6WRpB3sCR8JSJ
	zNtgxgEkF5+xUuqjsrcKW5pUPLWfy+xw6BeDLjbrGmnXVayYzwp4D7BJmeywVxEG3uDL7KN
	biMx8zUSPmnkQDq6vfsAN5ifavVUm0k6iQrlp/oZOZOqj5alOm3iIBsOenXurYc/c1yMfPn
	v9gv4RUzWzp2ftSAzMNKsXeGWdzcWEe4Cy5wd0705xG6VLBt9foBFg8+Gb2hl8CVr+yZaFQ
	na48XJMDa1DX1nk8eei6xfLakDkPKXZuTTEgJ/k68OLc0FaeS+LoRJvQKKM6wqo3axZDT8V
	ZC4KTcLeIpKJ4jcqyfx+o00HGu0otvjXkQ9TZMPUlxAAE1iXsdc90VyySCYHrM5Viwnp4j+
	4p8/bUmxe5l0ISanifNyhQdamRjuR2zdRi1nt8Wf7pfEjo+Nue0FPpSNXYkRbW0uCt8jrW1
	xKzuU5EFo0fKRC5SQc+v7a0HHCIag5bZ31uhmMOn8WPq5OG3ufLxdfij+RxLEgX8BNyxfCj
	LxtFHvOwRKdq8WNxLr/6lk1DIeumfFl77E/v8VWIsJ0jVpNqYXbrgbx97hHYpWT5pqc806o
	RdzWzn31EQr5E9ijgxSqkjDNTFVig=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Coly Li proposed an RFC that collects written-back keys into an on-stack
per-pass batch (struct writeback_batch) inside read_dirty() and issues
one REQ_PREFLUSH per pass (~500 IOs, bounded by KEYBUF_NR).  This patch
builds directly on that design: the core data structures, function names
(writeback_flush(), writeback_finish_batch()), and naming convention all
follow Coly's RFC.

The extension is a persistent preallocated batch (dc->writeback_batch)
that survives across read_dirty() passes, controlled by a new sysfs knob
writeback_flush_interval:

  writeback_flush_interval = 0  (default):
    writeback_finish_batch() is triggered after every read_dirty() pass
    (because !0 is always true), reproducing Coly's one-flush-per-pass
    behavior exactly.  In this mode keys never accumulate between passes,
    so bch_writeback_finish_batch() (the GC hook) skips each device —
    there is nothing pending to flush.

  writeback_flush_interval > 0  (cross-pass batching):
    writeback_finish_batch() fires only when the accumulated key count
    reaches the threshold.  The GC hook flushes pending keys before
    btree_gc_start() so GC can reclaim their bucket space.

Signed-off-by: Coly Li <colyli@fygo.io>
Signed-off-by: Zhou Jifeng <zhoujifeng@kylinsec.com.cn>
---
 drivers/md/bcache/bcache.h    |  20 +++++
 drivers/md/bcache/btree.c     |   2 +
 drivers/md/bcache/btree.h     |   1 +
 drivers/md/bcache/sysfs.c     |   6 ++
 drivers/md/bcache/writeback.c | 137 ++++++++++++++++++++++++++++------
 drivers/md/bcache/writeback.h |   1 +
 6 files changed, 145 insertions(+), 22 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff9715..03e401575 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -247,6 +247,24 @@ struct keybuf {
 	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
 };
 
+struct writeback_bkey {
+	BKEY_PADDED(key);
+	struct list_head	list;
+};
+
+#define WRITEBACK_FLUSH_INTERVAL_DEFAULT	0
+#define WRITEBACK_FLUSH_INTERVAL_MIN		0
+#define WRITEBACK_FLUSH_INTERVAL_MAX		50000
+
+struct writeback_batch {
+	spinlock_t		lock;
+	u32			count;
+	struct list_head	keys;
+
+	DECLARE_ARRAY_ALLOCATOR(struct writeback_bkey, pool,
+				WRITEBACK_FLUSH_INTERVAL_MAX);
+};
+
 struct bcache_device {
 	struct closure		cl;
 
@@ -347,6 +365,8 @@ struct cached_dev {
 	struct workqueue_struct	*writeback_write_wq;
 
 	struct keybuf		writeback_keys;
+	struct writeback_batch	writeback_batch;
+	unsigned int		writeback_flush_interval;
 
 	struct task_struct	*status_update_thread;
 	/*
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 27a129d47..d10c03f60 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -25,6 +25,7 @@
 #include "btree.h"
 #include "debug.h"
 #include "extents.h"
+#include "writeback.h"
 
 #include <linux/slab.h>
 #include <linux/bitops.h>
@@ -1837,6 +1838,7 @@ static void bch_btree_gc(struct cache_set *c)
 	closure_init_stack(&writes);
 	bch_btree_op_init(&op, SHRT_MAX);
 
+	bch_writeback_finish_batch(c);
 	btree_gc_start(c);
 
 	/* if CACHE_SET_IO_DISABLE set, gc thread should stop too */
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 45d64b541..701b0009c 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -414,4 +414,5 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *c,
 					  struct bkey *end,
 					  keybuf_pred_fn *pred);
 void bch_update_bucket_in_use(struct cache_set *c, struct gc_stat *stats);
+void bkey_put(struct cache_set *c, struct bkey *k);
 #endif
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index cfac56caa..7a87c64d7 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -150,6 +150,7 @@ rw_attribute(copy_gc_enabled);
 rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
 rw_attribute(size);
+rw_attribute(writeback_flush_interval);
 
 static ssize_t bch_snprint_string_list(char *buf,
 				       size_t size,
@@ -212,6 +213,7 @@ SHOW(__bch_cached_dev)
 	var_print(writeback_rate_fp_term_mid);
 	var_print(writeback_rate_fp_term_high);
 	var_print(writeback_rate_minimum);
+	var_print(writeback_flush_interval);
 
 	if (attr == &sysfs_writeback_rate_debug) {
 		char rate[20];
@@ -353,6 +355,9 @@ STORE(__cached_dev)
 
 	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
 
+	sysfs_strtoul_clamp(writeback_flush_interval, dc->writeback_flush_interval,
+			    WRITEBACK_FLUSH_INTERVAL_MIN, WRITEBACK_FLUSH_INTERVAL_MAX);
+
 	if (attr == &sysfs_io_disable) {
 		int v = strtoul_or_return(buf);
 
@@ -540,6 +545,7 @@ static struct attribute *bch_cached_dev_attrs[] = {
 #endif
 	&sysfs_backing_dev_name,
 	&sysfs_backing_dev_uuid,
+	&sysfs_writeback_flush_interval,
 	NULL
 };
 ATTRIBUTE_GROUPS(bch_cached_dev);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4b237074f..f36b515d6 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -348,39 +348,122 @@ static CLOSURE_CALLBACK(dirty_io_destructor)
 	kfree(io);
 }
 
-static CLOSURE_CALLBACK(write_dirty_finish)
+static void writeback_batch_init(struct writeback_batch *wb)
 {
-	closure_type(io, struct dirty_io, cl);
-	struct keybuf_key *w = io->bio.bi_private;
-	struct cached_dev *dc = io->dc;
+	wb->count = 0;
+	spin_lock_init(&wb->lock);
+	array_allocator_init(&wb->pool);
+	INIT_LIST_HEAD(&wb->keys);
+}
 
-	bio_free_pages(&io->bio);
+static void writeback_add_key(struct cached_dev *dc, struct bkey *key)
+{
+	struct writeback_bkey *bk;
+	unsigned int i;
 
-	/* This is kind of a dumb way of signalling errors. */
-	if (KEY_DIRTY(&w->key)) {
-		int ret;
-		unsigned int i;
-		struct keylist keys;
+	spin_lock(&dc->writeback_batch.lock);
+	bk = array_alloc(&dc->writeback_batch.pool);
+	if (!bk) {
+		spin_unlock(&dc->writeback_batch.lock);
+		return;
+	}
+
+	for (i = 0; i < KEY_PTRS(key); i++)
+		atomic_inc(&PTR_BUCKET(dc->disk.c, key, i)->pin);
 
-		bch_keylist_init(&keys);
+	bkey_copy(&bk->key, key);
+	INIT_LIST_HEAD(&bk->list);
+	list_add_tail(&bk->list, &dc->writeback_batch.keys);
+	dc->writeback_batch.count++;
+	spin_unlock(&dc->writeback_batch.lock);
+}
 
-		bkey_copy(keys.top, &w->key);
-		SET_KEY_DIRTY(keys.top, false);
-		bch_keylist_push(&keys);
+static int writeback_flush(struct cached_dev *dc)
+{
+	struct bio bio;
+	int ret;
 
-		for (i = 0; i < KEY_PTRS(&w->key); i++)
-			atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
+	bio_init(&bio, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
 
-		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
+	ret = submit_bio_wait(&bio);
+	if (ret)
+		bch_count_backing_io_errors(dc, &bio);
 
-		if (ret)
-			trace_bcache_writeback_collision(&w->key);
+	bio_uninit(&bio);
+	return ret;
+}
 
-		atomic_long_inc(ret
-				? &dc->disk.c->writeback_keys_failed
-				: &dc->disk.c->writeback_keys_done);
+static void writeback_finish_batch(struct cached_dev *dc)
+{
+	struct writeback_bkey *bk, *tmp;
+	struct keylist keys;
+	LIST_HEAD(local);
+	int flush_ret, ret;
+
+	spin_lock(&dc->writeback_batch.lock);
+	if (list_empty(&dc->writeback_batch.keys)) {
+		spin_unlock(&dc->writeback_batch.lock);
+		return;
+	}
+	list_splice_init(&dc->writeback_batch.keys, &local);
+	dc->writeback_batch.count = 0;
+	spin_unlock(&dc->writeback_batch.lock);
+
+	flush_ret = writeback_flush(dc);
+
+	list_for_each_entry(bk, &local, list) {
+		if (flush_ret == 0) {
+			bch_keylist_init(&keys);
+			bkey_copy(keys.top, &bk->key);
+			SET_KEY_DIRTY(keys.top, false);
+			bch_keylist_push(&keys);
+			ret = bch_btree_insert(dc->disk.c, &keys, NULL,
+					       &bk->key);
+			if (ret)
+				trace_bcache_writeback_collision(&bk->key);
+			atomic_long_inc(ret
+					? &dc->disk.c->writeback_keys_failed
+					: &dc->disk.c->writeback_keys_done);
+		} else {
+			bkey_put(dc->disk.c, &bk->key);
+		}
 	}
 
+	spin_lock(&dc->writeback_batch.lock);
+	list_for_each_entry_safe(bk, tmp, &local, list) {
+		list_del(&bk->list);
+		array_free(&dc->writeback_batch.pool, bk);
+	}
+	spin_unlock(&dc->writeback_batch.lock);
+}
+
+void bch_writeback_finish_batch(struct cache_set *c)
+{
+	unsigned int i;
+
+	for (i = 0; i < c->devices_max_used; i++) {
+		struct bcache_device *d = c->devices[i];
+		struct cached_dev *dc;
+
+		if (!d || UUID_FLASH_ONLY(&c->uuids[i]))
+			continue;
+		dc = container_of(d, struct cached_dev, disk);
+		if (dc->writeback_flush_interval)
+			writeback_finish_batch(dc);
+	}
+}
+
+static CLOSURE_CALLBACK(write_dirty_finish)
+{
+	closure_type(io, struct dirty_io, cl);
+	struct keybuf_key *w = io->bio.bi_private;
+	struct cached_dev *dc = io->dc;
+
+	bio_free_pages(&io->bio);
+
+	if (KEY_DIRTY(&w->key))
+		writeback_add_key(dc, &w->key);
+
 	bch_keybuf_del(&dc->writeback_keys, w);
 	up(&dc->in_flight);
 
@@ -818,9 +901,15 @@ static int bch_writeback_thread(void *arg)
 
 		read_dirty(dc);
 
+		if (!dc->writeback_flush_interval ||
+		    dc->writeback_batch.count >= dc->writeback_flush_interval)
+			writeback_finish_batch(dc);
+
 		if (searched_full_index) {
 			unsigned int delay = dc->writeback_delay * HZ;
 
+			writeback_finish_batch(dc);
+
 			while (delay &&
 			       !kthread_should_stop() &&
 			       !test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
@@ -831,6 +920,8 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
+	writeback_finish_batch(dc);
+
 	if (dc->writeback_write_wq)
 		destroy_workqueue(dc->writeback_write_wq);
 
@@ -1049,6 +1140,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	sema_init(&dc->in_flight, 64);
 	init_rwsem(&dc->writeback_lock);
 	bch_keybuf_init(&dc->writeback_keys);
+	writeback_batch_init(&dc->writeback_batch);
 
 	dc->writeback_metadata		= true;
 	dc->writeback_running		= false;
@@ -1064,6 +1156,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate_fp_term_mid = 10;
 	dc->writeback_rate_fp_term_high = 1000;
 	dc->writeback_rate_i_term_inverse = 10000;
+	dc->writeback_flush_interval	= WRITEBACK_FLUSH_INTERVAL_DEFAULT;
 
 	/* For dc->writeback_lock contention in update_writeback_rate() */
 	dc->rate_update_retry = 0;
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df71695..12b4c4420 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -151,5 +151,6 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 void bch_sectors_dirty_init(struct bcache_device *d);
 void bch_cached_dev_writeback_init(struct cached_dev *dc);
 int bch_cached_dev_writeback_start(struct cached_dev *dc);
+void bch_writeback_finish_batch(struct cache_set *c);
 
 #endif
-- 
2.34.1

