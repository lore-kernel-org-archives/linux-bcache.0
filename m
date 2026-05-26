Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E571335E1B8
	for <linux-bcache@vger.kernel.org>; Tue, 26 May 2026 05:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779774315; cv=none; b=evNmVBlMjbtFXzqtadH4ZG+LdoofYZkQ4QOWDiBPaxgks3EEkaUrmto3nU5zPj8ou6H/UafkxbN5Zr4XC++dL55b4IO7C+KZCrNmbqw1gZ6CKjKjngA+9bjQLY45RoRd2iMaT9cqOhqNFtLST2KVHuF6WVxjYeH6nJa2YPuZRNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779774315; c=relaxed/simple;
	bh=mSr0ctr0YAf5VPQ+H8bg4E0oZTkU8UjnixBliO635SY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FIPG8gPdO1CBNg/v+W7hIByMZw/GA0NrfYCI+e9+bUj0Oqo18loUrK752oG2/4TNpAvrW0XlQis3hjcRWdcu3JJx9S3e6IezUjKbW49TEM8Xmcaf3XrWs3fz8nzoAkNo8Lw0Aidq0ecpowoP7oI6g8TtUognLpKT6AsuEl8wWEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3611F000E9;
	Tue, 26 May 2026 05:45:11 +0000 (UTC)
From: colyli@fygo.io
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fygo.io>,
	Zhou Jifeng <zhoujifeng@kylinos.com.cn>,
	linux-stable@vger.kernel.org
Subject: [PATCH RFC] bcache: flush backing device before cleaning the writeback dirty keys
Date: Tue, 26 May 2026 13:44:38 +0800
Message-ID: <20260526054438.818708-1-colyli@fygo.io>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fygo.io>

After dirty data on cache device is written back to backing device, the
dirty keys of these written dirty data are set to clean and inserted
back to the btree. There is no explicit flush bio sent to the backing
device, whether the dirty data is flushed onto disk media or still in
hard drive's DRAM cache, it is uncertain. If a power failure occurs
after the cleaned keys are inserted back to the btree while dirty data
still stays in hard drive's DRAM cache, after the reboot a stale data of
the written data may happen because the dirty key is clean now, but
dirty data has not been persisted indeed.

This patch introduce struct writeback_batch, and allocates a on-stack
batch in read_dirty(), uses it to collect all successful writeback I/Os
(a.k.a struct dirty_io). Then in write_dirty_finish() the successfully
written back dirty key is not cleaned and inserted back to the btree
immediately, it is added into batch->keys list and delayed to a new
function writeback_finish_batch() to be cleaned and inserted back to
the btree. In writeback_finish_batch, before inserting back all the
cleaned keys to the btree by writeback_clean_key(), an explicit flush
bio is issued to backing device if a real writeback I/O once happened.

By this method, when writeback I/Os are busy, a flush bio will be issued
around every 500 writeback I/O based on current code.  Therefore an
explicit backing device flush bio can be issued in time (every batch
writeback I/Os in read_dirty()), and in a reasonable frequency.

Now this patch just passes compiling, not survive long time pressure
testing yet.

Fixes: cafe563591446 ("bcache: A block layer cache")
Reported-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: linux-stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@fygo.io>
---
 drivers/md/bcache/writeback.c | 133 +++++++++++++++++++++++++++-------
 1 file changed, 106 insertions(+), 27 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4b237074f453..81b4514d6532 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -320,14 +320,22 @@ static unsigned int writeback_delay(struct cached_dev *dc,
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
+	bool			need_flush;
+};
+
 static void dirty_init(struct keybuf_key *w)
 {
 	struct dirty_io *io = w->private;
 	struct bio *bio = &io->bio;
 
@@ -351,42 +359,41 @@ static CLOSURE_CALLBACK(dirty_io_destructor)
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
+	 * Temporarily add this key into io->batch->keys. Once all dirty keys
+	 * in dc->writeback_keys are written back to backing device, a flush
+	 * bio will be issued to backing device by writeback_finish_batch().
+	 * Then before all clean keys are inserted back to btree, the writeback
+	 * dirty data is for sure flushed to backing device.
+	 * If power failure occurs after the clean key is inserted back to the
+	 * btree, the dirty data has already been in the disk platter and a
+	 * stale clean bkey can be avoided.
+	 */
+	if (written) {
+		INIT_LIST_HEAD(&io->list);
+		if (io->batch->need_flush != true)
+			io->batch->need_flush = true;
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
@@ -398,10 +405,74 @@ static void dirty_endio(struct bio *bio)
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
+	if (batch->need_flush)
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
@@ -478,15 +549,20 @@ static void read_dirty(struct cached_dev *dc)
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
+	batch.need_flush = false;
+
 	/*
 	 * XXX: if we error, background writeback just spins. Should use some
 	 * mempools.
 	 */
 
@@ -542,10 +618,11 @@ static void read_dirty(struct cached_dev *dc)
 			if (!io)
 				goto err;
 
 			w->private	= io;
 			io->dc		= dc;
+			io->batch	= &batch;
 			io->sequence    = sequence++;
 
 			dirty_init(w);
 			io->bio.bi_opf = REQ_OP_READ;
 			io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
@@ -583,14 +660,16 @@ static void read_dirty(struct cached_dev *dc)
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

