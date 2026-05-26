Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983153C0621
	for <linux-bcache@vger.kernel.org>; Tue, 26 May 2026 06:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779775754; cv=none; b=XaRgJF9r3IX05sq8HL8dzfmDgVJUUAxj00+CEnrQwwWDgyHIPN0JSRJY4kpArEgrjZ2+OCKZTND+yZj+TS4wRbcrwPQb1+SdrgK0LQUfNJLUqiEN167RqangkqUIaS0OAyA81gsfrzuMwtC5+zpjFtZmWzRo/Tgv138TBEzLUNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779775754; c=relaxed/simple;
	bh=dcXrpqa3WAg+nH27/1itAbd3AdVeekcZ1aRjYwSzb4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b2TWtuEcjtTDlk+prmM3F+kCvqcm6HNQHp4Wk+fQ0amWt+vbhChPW8y6Djm1AXH/l1Aq3ggLY55++FIi0pIIdCwF7ZaA+/8diTEBCvdixMcCEymFfDK9DF4r7V5F6Ky/93spvvRSeYj1xBeU9yuxnYd2cJAJmia3nvXWZmSN+Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8D41F000E9;
	Tue, 26 May 2026 06:09:10 +0000 (UTC)
From: colyli@fygo.io
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fygo.io>,
	Zhou Jifeng <zhoujifeng@kylinos.com.cn>,
	linux-stable@vger.kernel.org
Subject: [PATCH RFC v2] bcache: flush backing device before cleaning the writeback dirty keys
Date: Tue, 26 May 2026 14:09:02 +0800
Message-ID: <20260526060902.832500-1-colyli@fygo.io>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fygo.io>

After dirty data on the cache device is written back to the backing
device, the dirty keys for the written data are set clean and inserted
back into the btree. However, no explicit flush bio is sent to the
backing device, so the data may still be in the backing device's
volatile write cache instead of stable media.

If power fails after the clean keys are inserted into the btree but
before the backing device has persisted the data, stale data may be
exposed after reboot: the btree key is clean, so bcache no longer has a
chance to write back the still-valid dirty data from the cache device.

Fix this by adding struct writeback_batch and allocating an on-stack
batch in read_dirty(). In write_dirty_finish() successful writeback IOs
are collected in batch->keys instead of being cleaned immediately. After
all outstanding writeback IOs in the read_dirty() completed, an explicit
flush bio is issued in writeback_finish_batch() to the backing device.
Only if the flush succeeds are the corresponding clean keys inserted
back into the btree. Otherwise the dirty keys will continue to stay in
btree and wait for next chance to be selected for writeback again.

With the current keybuf size, this issues at most one backing-device
flush per read_dirty() pass, roughly every 500 writeback IOs when
writeback is busy. Now an explicit backing device flush bio can be
issued in time and in a reasonable frequency.

Fixes: cafe563591446 ("bcache: A block layer cache")
Reported-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: linux-stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@fygo.io>
---
v2, refine commit log, and code cleanup.
v1, initial version.
 drivers/md/bcache/writeback.c | 128 +++++++++++++++++++++++++++-------
 1 file changed, 101 insertions(+), 27 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4b237074f453..d0cb728c252e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -320,14 +320,21 @@ static unsigned int writeback_delay(struct cached_dev *dc,
 }
 
 struct dirty_io {
 	struct closure		cl;
 	struct cached_dev	*dc;
+	struct writeback_batch	*batch;
+	struct list_head	list;
 	uint16_t		sequence;
 	struct bio		bio;
 };
 
+struct writeback_batch {
+	struct list_head	keys;
+	spinlock_t		lock;
+};
+
 static void dirty_init(struct keybuf_key *w)
 {
 	struct dirty_io *io = w->private;
 	struct bio *bio = &io->bio;
 
@@ -351,42 +358,38 @@ static CLOSURE_CALLBACK(dirty_io_destructor)
 static CLOSURE_CALLBACK(write_dirty_finish)
 {
 	closure_type(io, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
 	struct cached_dev *dc = io->dc;
+	bool written = KEY_DIRTY(&w->key);
 
 	bio_free_pages(&io->bio);
 
-	/* This is kind of a dumb way of signalling errors. */
-	if (KEY_DIRTY(&w->key)) {
-		int ret;
-		unsigned int i;
-		struct keylist keys;
-
-		bch_keylist_init(&keys);
-
-		bkey_copy(keys.top, &w->key);
-		SET_KEY_DIRTY(keys.top, false);
-		bch_keylist_push(&keys);
-
-		for (i = 0; i < KEY_PTRS(&w->key); i++)
-			atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
-
-		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
-
-		if (ret)
-			trace_bcache_writeback_collision(&w->key);
-
-		atomic_long_inc(ret
-				? &dc->disk.c->writeback_keys_failed
-				: &dc->disk.c->writeback_keys_done);
+	/*
+	* Temporarily add this key to io->batch->keys. After the successful
+	* writeback IOs inside the current batch of read_dirty() finished,
+	* writeback_finish_batch() explicitly flushes the backing device before
+	* inserting the cleaned keys back into the btree. This guarantees that
+	* the backing data will be on stable media before the dirty btree keys
+	* are marked by the clean keys, avoiding stale clean bkeys after power
+	* failure.
+	*/
+	if (written) {
+		INIT_LIST_HEAD(&io->list);
+		spin_lock(&io->batch->lock);
+		list_add_tail(&io->list, &io->batch->keys);
+		spin_unlock(&io->batch->lock);
+	} else {
+		bch_keybuf_del(&dc->writeback_keys, w);
 	}
 
-	bch_keybuf_del(&dc->writeback_keys, w);
 	up(&dc->in_flight);
 
-	closure_return_with_destructor(cl, dirty_io_destructor);
+	if (written)
+		closure_return(cl);
+	else
+		closure_return_with_destructor(cl, dirty_io_destructor);
 }
 
 static void dirty_endio(struct bio *bio)
 {
 	struct keybuf_key *w = bio->bi_private;
@@ -398,10 +401,74 @@ static void dirty_endio(struct bio *bio)
 	}
 
 	closure_put(&io->cl);
 }
 
+static int writeback_flush(struct cached_dev *dc)
+{
+	struct bio bio;
+	int ret;
+
+	bio_init(&bio, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
+
+	ret = submit_bio_wait(&bio);
+	if (ret)
+		bch_count_backing_io_errors(dc, &bio);
+
+	bio_uninit(&bio);
+	return ret;
+}
+
+static void writeback_clean_key(struct cached_dev *dc, struct keybuf_key *w)
+{
+	int ret;
+	unsigned int i;
+	struct keylist keys;
+
+	bch_keylist_init(&keys);
+
+	bkey_copy(keys.top, &w->key);
+	SET_KEY_DIRTY(keys.top, false);
+	bch_keylist_push(&keys);
+
+	for (i = 0; i < KEY_PTRS(&w->key); i++)
+		atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
+
+	ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
+
+	if (ret)
+		trace_bcache_writeback_collision(&w->key);
+
+	atomic_long_inc(ret
+			? &dc->disk.c->writeback_keys_failed
+			: &dc->disk.c->writeback_keys_done);
+}
+
+static void writeback_finish_batch(struct cached_dev *dc,
+				   struct writeback_batch *batch)
+{
+	struct dirty_io *io, *t;
+	int flush_ret = 0;
+
+	if (!list_empty(&batch->keys))
+		flush_ret = writeback_flush(dc);
+
+	list_for_each_entry_safe(io, t, &batch->keys, list) {
+		struct keybuf_key *w = io->bio.bi_private;
+
+		list_del(&io->list);
+
+		if (flush_ret == 0)
+			writeback_clean_key(dc, w);
+		else
+			atomic_long_inc(&dc->disk.c->writeback_keys_failed);
+
+		bch_keybuf_del(&dc->writeback_keys, w);
+		kfree(io);
+	}
+}
+
 static CLOSURE_CALLBACK(write_dirty)
 {
 	closure_type(io, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
 	struct cached_dev *dc = io->dc;
@@ -478,15 +545,19 @@ static void read_dirty(struct cached_dev *dc)
 	size_t size;
 	int nk, i;
 	struct dirty_io *io;
 	struct closure cl;
 	uint16_t sequence = 0;
+	struct writeback_batch batch;
 
 	BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
 	atomic_set(&dc->writeback_sequence_next, sequence);
 	closure_init_stack(&cl);
 
+	INIT_LIST_HEAD(&batch.keys);
+	spin_lock_init(&batch.lock);
+
 	/*
 	 * XXX: if we error, background writeback just spins. Should use some
 	 * mempools.
 	 */
 
@@ -542,10 +613,11 @@ static void read_dirty(struct cached_dev *dc)
 			if (!io)
 				goto err;
 
 			w->private	= io;
 			io->dc		= dc;
+			io->batch	= &batch;
 			io->sequence    = sequence++;
 
 			dirty_init(w);
 			io->bio.bi_opf = REQ_OP_READ;
 			io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
@@ -583,14 +655,16 @@ static void read_dirty(struct cached_dev *dc)
 err:
 		bch_keybuf_del(&dc->writeback_keys, w);
 	}
 
 	/*
-	 * Wait for outstanding writeback IOs to finish (and keybuf slots to be
-	 * freed) before refilling again
+	 * Wait for outstanding writeback IOs to finish, then flush the
+	 * backing device, insert the clean keys back to btree, and free
+	 * keybuf slots.
 	 */
 	closure_sync(&cl);
+	writeback_finish_batch(dc, &batch);
 }
 
 /* Scan for dirty data */
 
 void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
-- 
2.47.3

