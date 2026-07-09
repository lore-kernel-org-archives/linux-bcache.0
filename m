Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B7D3368A4
	for <linux-bcache@vger.kernel.org>; Thu,  9 Jul 2026 06:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783578240; cv=none; b=uCQMEwzb46VvupKr2C3qDQgjIImQ2sCI0l9gWrJ4bha9aUQIXmLI+vDgMFVfE7fVlD11cvDhvxrd6CqNftGddYA4rytmeuoVP8nGxMZfmAnogB4C6N/p4oG1KBEDMGtSDchDfi6GauBL82u8IU9RBWrVYyyThO1NrKMHDaQLapY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783578240; c=relaxed/simple;
	bh=LXAqcoXmz5xrVIKsXo18b1xYQpMaSZgFddBgjP5rCXs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djCxinmRCvawUoCDPBafQUO0G7sF3wEw9AuvJB7Cv/7l7Ff+1htrQGi0UVEt2Sgp9/bQAGL5Kmc50ZyPHkT/tXT49Eqp8wI0QYKNfcffY+QoaB/qoClYhSuxsiSBEX7mgXb5lGpxe6gXqk1ogcvBQzJ1DtqqMSCTMkmUNjwD5ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
X-QQ-mid: esmtpgz15t1783578219t0036cb44
X-QQ-Originating-IP: /XO8qxsKiyhnuG9dMo3RIADJf+pozh1CgJ+Yr3aBQgE=
Received: from localhost.localdomain ( [111.22.53.71])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 09 Jul 2026 14:23:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15721205814008757680
EX-QQ-RecipientCnt: 3
From: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
To: colyli@fygo.io
Cc: linux-bcache@vger.kernel.org,
	zhoujifeng@kylinsec.com.cn
Subject: [PATCH RFC v4] bcache: flush backing device before cleaning the writeback dirty keys
Date: Thu,  9 Jul 2026 14:23:30 +0800
Message-Id: <20260709062330.16970-1-zhoujifeng@kylinos.com.cn>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <ak3Jf2ZUhQmDmA3A@studio.local>
References: <ak3Jf2ZUhQmDmA3A@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:kylinos.com.cn:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N/EN6P+BmEafRJLL/FOXyPKViuIvrTIo6YhdcjvTLziZ5jii4nb+YPLx
	5Jae4Yx7TG7fH9vBOI/ETBIeOgG9WgIW6/P1j4MlqrnQhNl+BcbDLHne8sBVka7HxjiWEh+
	lN0y2iWvLQdEK8aqf1WnaYjJYMhMNVSCSL78wQHGRZlqK1T8rchIM8gyGAb6te3ILzk/Pn5
	0NauXnqpDl7K85AOIU3Fnj1g7wK3rfQfnIUxPnr0AT2aElZyxaU9yQtGATFlCvvFW8QSk7o
	vMP0CWo+4BlJjmIws+JatbUWeeA7fZqd+4LIp7QQqxR3B4BiuRjT2jZc9YZ2NfoFbuGx4zf
	T6MGrBidbkJgfBKQmC5Y06e14OXWb5sHbVmYUqAuLrLDqs0TRvE1bT76rVbMBKv6Fkx4xcO
	YvFd9/irKqSKxDIhfAJjTPbEtXOJ5olG6K4iMCjPuOe8rdkh+qhan8+OK0Vh4Jm6Ixp7e8w
	lScmrd0Rz9iQgatHMbxu0OogdJ+JN3JjfTD6gPM23bwm5g5woau4aamIrTEG1oJw8QFzEiw
	VroUPt/1Hl/psVeaPn7kEg+Pji/2hjfkVAun4ioQ3rvcSrDUCjrLKwinkKVXedLpoPsST55
	PjFbJoQWHw9iDDAbz2EVOXoOmp9I1JTjEcNI/R8sYinuMCgj1XDsK9L4BsNUhC2IvKjbw8R
	Sxhdb/0SK6cpUMGzlTI6I+lw8UeRRnUZMCCjOZQPKUYpff+MA7JtDP7plxhkoPgfMamoYWm
	AzJUq7H4jc/jmhts3Dv7ONAKA1BTrMhgyX9b6BUbLOleCLMQBe8COZ96E5wRiVDkEw7B8Bj
	Z/4W2kXbPeluEN/UCzJFq6dUL5Nepa2wOnYHKFhjPYQMDkeiwu+CqUhmJoySqeXeoStSVJm
	/JnIWyhaFaEMI7Xe+7dW33ZatMgc/3GovIeEyA+WgtO2YPnY+6IczkN9bNxrqJeuLXpVV6b
	IalAqbwvGQPX8+KreDQl/mdxyeOjkqxnDnDiK9swjV/YSIGDDBJ152wSbQkn2SzMEdnpxpi
	gl1T1v2pOG99jNAFIOZu5KXzjvoITTs4b0N1hOtQ==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

From: Zhou Jifeng <zhoujifeng@kylinsec.com.cn>

Currently, when writeback dirty data completes, write_dirty_finish()
immediately inserts the clean key into the btree.  If a power failure
occurs after the clean-key insert but before the backing device has
flushed its volatile write cache, the btree contains a clean key that
points at backing data that never reached stable media.  On the next
read, bcache serves stale data from the backing device.

Fix this by deferring the clean-key btree insert until after an
explicit backing-device flush (REQ_PREFLUSH).  Written keys are first
parked in a new rbtree (writeback_flush_pending) keyed by START_KEY.
After enough read_dirty() passes, a full btree scan, or a wrap-around
in refill_dirty(), writeback_finish_batch() issues a synchronous
backing-device flush, and only on success inserts the clean keys into
the btree and removes them from the pending tree.  On flush failure
the entries are re-inserted into the current tree for a later retry.

Key changes:

- Introduce struct writeback_pending (separate kmalloc'd allocation,
  decoupled from the dirty_io closure so the closure can be freed
  immediately and the pending entry lives until the flush).

- Add __writeback_pending_insert() — inserts into the START_KEY-
  ordered rbtree with overlap detection.  The rbtree is also used as
  an interval tree by bch_writeback_drop_pending() for front-end
  write overlap queries; that search is correct only because dirty
  btree keys are pairwise disjoint, an invariant enforced at insert
  time.

- writeback_add_to_pending() parks a key after successful writeback
  IO.  Uses GFP_NOIO because the caller runs on the WQ_MEM_RECLAIM
  writeback workqueue.  kmalloc failure silently drops the key (it
  stays dirty and is re-selected by the next scan).

- writeback_finish_batch() detaches the entire pending tree into a
  local list under spinlock, issues writeback_flush(), then either
  cleans the keys (on success) or re-inserts them (on failure).

- writeback_flush() open-codes blkdev_issue_flush() to call
  bch_count_backing_io_errors() on failure.

- bch_writeback_drop_pending() drops overlapping entries from the
  pending tree.  Called from cached_dev_write() alongside the
  existing bch_keybuf_check_overlapping(); overlapping front-end
  writes now force writeback instead of bypassing the cache.

- refill_dirty() now returns enum writeback_scan_result (PARTIAL,
  PARTIAL_WRAP, FULL_SEARCHED) instead of a boolean.  Before
  wrapping around for a second scan pass, it flushes the pending
  tree so the wrap scan won't re-select keys that are still
  KEY_DIRTY in the btree but already written to backing and
  awaiting flush.  writeback_lock may be transiently released
  mid-function during this pre-wrap flush.

- refill_full_stripes() no longer wraps internally; it returns
  at the end of the stripe range and delegates the wrap to
  refill_dirty().  buf->last_scanned is no longer rewound past
  the current position to avoid re-selecting keys already in
  writeback_flush_pending.

- read_dirty() gates deferred flush-and-clean on PASS_PER_FLUSH
  (default 5) passes, a full btree scan, or a PARTIAL_WRAP.  It
  accepts the scan_result from refill_dirty() as a parameter.

- write_dirty_finish() is simplified: it no longer inserts clean
  keys inline; it only calls writeback_add_to_pending().

- BDEV_STATE_CLEAN eligibility in the main loop now also requires
  writeback_pending_empty(), so a device is not marked clean while
  entries are still in the pending tree.

- Thread exit: the workqueue is destroyed first, then a final
  writeback_finish_batch() is attempted (skipped when the cache
  set is disabled or the device is detaching), then any remaining
  pending entries are drained.  The exit path intentionally does
  NOT set BDEV_STATE_CLEAN because it lacks the WB_SCAN_FULL_SEARCHED
  gate that the in-loop check requires; a kthread_stop mid-scan
  (e.g. from bch_cached_dev_attach's error path) must not mark a
  still-dirty device clean.

Signed-off-by: Coly Li <colyli@fygo.io>
Signed-off-by: Zhou Jifeng <zhoujifeng@kylinsec.com.cn>
---
 drivers/md/bcache/bcache.h    |  11 +
 drivers/md/bcache/request.c   |   6 +-
 drivers/md/bcache/writeback.c | 497 ++++++++++++++++++++++++++++++----
 drivers/md/bcache/writeback.h |  13 +
 4 files changed, 470 insertions(+), 57 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff9715..620f2d4a5 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -347,6 +347,17 @@ struct cached_dev {
 	struct workqueue_struct	*writeback_write_wq;
 
 	struct keybuf		writeback_keys;
+	/*
+	 * writeback_flush_pending and writeback_flush_lock are accessed
+	 * by both the writeback thread (via writeback_add_to_pending and
+	 * writeback_finish_batch) and foreground writes (via
+	 * bch_writeback_drop_pending).  writeback_flush_passes is
+	 * accessed only by the writeback thread.
+	 */
+	struct rb_root		writeback_flush_pending;
+	spinlock_t		writeback_flush_lock;
+	unsigned int		writeback_flush_passes;
+	mempool_t		*writeback_pending_pool;
 
 	struct task_struct	*status_update_thread;
 	/*
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3fa3b13a4..b2c5acd88 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -990,13 +990,15 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 	down_read_non_owner(&dc->writeback_lock);
 	if (bch_keybuf_check_overlapping(&dc->writeback_keys, &start, &end)) {
 		/*
-		 * We overlap with some dirty data undergoing background
-		 * writeback, force this write to writeback
+		 * We overlap with dirty data undergoing background
+		 * writeback, force this write to writeback.
 		 */
 		s->iop.bypass = false;
 		s->iop.writeback = true;
 	}
 
+	bch_writeback_drop_pending(dc, &start, &end);
+
 	/*
 	 * Discards aren't _required_ to do anything, so skipping if
 	 * check_overlapping returned true is ok
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4b237074f..7a1ec8f03 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -319,6 +319,12 @@ static unsigned int writeback_delay(struct cached_dev *dc,
 	return bch_next_delay(&dc->writeback_rate, sectors);
 }
 
+struct writeback_pending {
+	struct rb_node		node;
+	struct list_head	list;
+	BKEY_PADDED(key);
+};
+
 struct dirty_io {
 	struct closure		cl;
 	struct cached_dev	*dc;
@@ -348,38 +354,83 @@ static CLOSURE_CALLBACK(dirty_io_destructor)
 	kfree(io);
 }
 
+/*
+ * Insert wp into writeback_flush_pending rbtree (ordered by START_KEY).
+ * Caller must hold dc->writeback_flush_lock.
+ *
+ * The rbtree is used as an interval tree by bch_writeback_drop_pending()
+ * via a standard BST interval search.  That search is only correct because
+ * the entries are pairwise disjoint (dirty btree keys never overlap).
+ *
+ * Returns false if an overlapping entry already exists.  This is the
+ * expected outcome when PASS_PER_FLUSH > 1 and a key is re-selected by
+ * a later refill pass while still sitting in the pending tree — the key
+ * is still KEY_DIRTY in the btree until writeback_clean_key() runs.
+ * The read-and-rewrite cycle is wasted IO, but the tree stays consistent
+ * and the key will be cleaned when the next flush finally fires.
+ */
+static bool __writeback_pending_insert(struct cached_dev *dc,
+				       struct writeback_pending *wp)
+{
+	struct writeback_pending *entry;
+	struct rb_node **p, *parent = NULL;
+
+	lockdep_assert_held(&dc->writeback_flush_lock);
+
+	p = &dc->writeback_flush_pending.rb_node;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct writeback_pending, node);
+		if (bkey_cmp(&wp->key, &START_KEY(&entry->key)) <= 0)
+			p = &(*p)->rb_left;
+		else if (bkey_cmp(&START_KEY(&wp->key), &entry->key) >= 0)
+			p = &(*p)->rb_right;
+		else
+			return false; /* overlap */
+	}
+	rb_link_node(&wp->node, parent, p);
+	rb_insert_color(&wp->node, &dc->writeback_flush_pending);
+	return true;
+}
+
+/*
+ * Temporarily add this key to writeback_flush_pending. After enough
+ * read_dirty() passes finish, or the full btree scan completes,
+ * writeback_finish_batch() explicitly flushes the backing device before
+ * inserting the cleaned keys back into the btree. This guarantees that
+ * the backing data will be on stable media before the dirty btree keys
+ * are overwritten by the clean keys, avoiding stale clean bkeys after
+ * power failure.
+ */
+static void writeback_add_to_pending(struct cached_dev *dc,
+				     struct bkey *key)
+{
+	struct writeback_pending *wp;
+
+	wp = mempool_alloc(dc->writeback_pending_pool, GFP_NOIO);
+
+	INIT_LIST_HEAD(&wp->list);
+	bkey_copy(&wp->key, key);
+	spin_lock(&dc->writeback_flush_lock);
+	if (!__writeback_pending_insert(dc, wp)) {
+		spin_unlock(&dc->writeback_flush_lock);
+		mempool_free(wp, dc->writeback_pending_pool);
+		return;
+	}
+	spin_unlock(&dc->writeback_flush_lock);
+}
+
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
-	}
+	if (written)
+		writeback_add_to_pending(dc, &w->key);
 
 	bch_keybuf_del(&dc->writeback_keys, w);
 	up(&dc->in_flight);
@@ -400,6 +451,213 @@ static void dirty_endio(struct bio *bio)
 	closure_put(&io->cl);
 }
 
+/*
+ * Issue a flush to the backing device.  Open-codes blkdev_issue_flush()
+ * so we can call bch_count_backing_io_errors() on failure.
+ */
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
+static void writeback_clean_key(struct cached_dev *dc, struct bkey *key)
+{
+	int ret;
+	unsigned int i;
+	struct keylist keys;
+
+	bch_keylist_init(&keys);
+
+	bkey_copy(keys.top, key);
+	SET_KEY_DIRTY(keys.top, false);
+	bch_keylist_push(&keys);
+
+	for (i = 0; i < KEY_PTRS(key); i++)
+		atomic_inc(&PTR_BUCKET(dc->disk.c, key, i)->pin);
+
+	/*
+	 * If the insert fails (e.g. GC moved the cached data and the key's
+	 * pointers went stale), just give up. The key stays dirty in btree
+	 * and will be re-selected on the next writeback pass. The backing
+	 * device already has the correct data, so no harm done.
+	 */
+	ret = bch_btree_insert(dc->disk.c, &keys, NULL, key);
+
+	if (ret)
+		trace_bcache_writeback_collision(key);
+
+	atomic_long_inc(ret
+			? &dc->disk.c->writeback_keys_failed
+			: &dc->disk.c->writeback_keys_done);
+}
+
+static void writeback_drain_pending(struct cached_dev *dc)
+{
+	struct writeback_pending *wp, *n;
+	LIST_HEAD(keys);
+
+	/*
+	 * Called only at writeback-thread exit, after the workqueue has
+	 * been destroyed.  New foreground writers can no longer reach
+	 * bch_writeback_drop_pending() at this point, but we hold the
+	 * lock anyway to keep the API uniform with the rest of the
+	 * pending-tree code.
+	 */
+	spin_lock(&dc->writeback_flush_lock);
+	while (!RB_EMPTY_ROOT(&dc->writeback_flush_pending)) {
+		struct rb_node *rb_node =
+			rb_first(&dc->writeback_flush_pending);
+
+		wp = rb_entry(rb_node, struct writeback_pending, node);
+		rb_erase(rb_node, &dc->writeback_flush_pending);
+		list_add(&wp->list, &keys);
+	}
+	spin_unlock(&dc->writeback_flush_lock);
+
+	list_for_each_entry_safe(wp, n, &keys, list)
+		mempool_free(wp, dc->writeback_pending_pool);
+}
+
+static bool writeback_pending_empty(struct cached_dev *dc)
+{
+	bool ret;
+
+	spin_lock(&dc->writeback_flush_lock);
+	ret = RB_EMPTY_ROOT(&dc->writeback_flush_pending);
+	spin_unlock(&dc->writeback_flush_lock);
+
+	return ret;
+}
+
+/*
+ * Drop all entries in writeback_flush_pending that overlap [start, end).
+ * Called from the foreground write path to force-writeback overlapped
+ * dirty data instead of bypassing the cache.
+ *
+ * The search below is a standard BST interval lookup that relies on the
+ * tree being pairwise disjoint: an entry's (START_KEY, end_key) range
+ * never overlaps another entry's range.  The disjoint invariant is
+ * enforced by __writeback_pending_insert() which rejects overlapping
+ * inserts.  Without this invariant the search would need the "max subtree
+ * end" augmentation provided by lib/interval_tree.
+ */
+bool bch_writeback_drop_pending(struct cached_dev *dc,
+				struct bkey *start,
+				struct bkey *end)
+{
+	struct writeback_pending *wp, *n;
+	LIST_HEAD(overlap);
+	struct rb_node *node;
+	bool ret = false;
+
+	spin_lock(&dc->writeback_flush_lock);
+	node = dc->writeback_flush_pending.rb_node;
+	while (node) {
+		wp = rb_entry(node, struct writeback_pending, node);
+
+		if (bkey_cmp(end, &START_KEY(&wp->key)) <= 0) {
+			node = node->rb_left;
+		} else if (bkey_cmp(start, &wp->key) >= 0) {
+			node = node->rb_right;
+		} else {
+			rb_erase(&wp->node, &dc->writeback_flush_pending);
+			list_add(&wp->list, &overlap);
+			ret = true;
+			/* restart search from root after erase */
+			node = dc->writeback_flush_pending.rb_node;
+		}
+	}
+	spin_unlock(&dc->writeback_flush_lock);
+
+	list_for_each_entry_safe(wp, n, &overlap, list)
+		mempool_free(wp, dc->writeback_pending_pool);
+
+	return ret;
+}
+
+static bool writeback_finish_batch(struct cached_dev *dc)
+{
+	struct writeback_pending *wp, *n;
+	LIST_HEAD(keys);
+	int flush_ret = 0;
+
+	spin_lock(&dc->writeback_flush_lock);
+	if (RB_EMPTY_ROOT(&dc->writeback_flush_pending)) {
+		spin_unlock(&dc->writeback_flush_lock);
+		return true;
+	}
+	/*
+	 * Detach all entries into a local list. New completions arriving
+	 * during the flush below will be added to the (now empty) tree.
+	 *
+	 * While the entries sit on the local list, they are invisible to
+	 * bch_writeback_drop_pending(), so a concurrent front-end write
+	 * overlapping a flushing key will not force-writeback and instead
+	 * write around the cache.  The resulting invalidation key has
+	 * KEY_PTRS=0 (bch_data_invalidate), which trims or removes the
+	 * overlapping dirty btree key.  The subsequent clean-key insert in
+	 * writeback_clean_key() then hits a pointer mismatch in
+	 * bch_extent_insert_fixup() -> replace_key(), producing an
+	 * insert_collision (ESRCH).  The clean-key insert is a no-op.
+	 * Subsequent reads miss the cache and go to the backing device,
+	 * which has the new data.  No data is lost.
+	 */
+	while (!RB_EMPTY_ROOT(&dc->writeback_flush_pending)) {
+		struct rb_node *rb_node =
+			rb_first(&dc->writeback_flush_pending);
+
+		wp = rb_entry(rb_node, struct writeback_pending, node);
+		rb_erase(rb_node, &dc->writeback_flush_pending);
+		list_add(&wp->list, &keys);
+	}
+	spin_unlock(&dc->writeback_flush_lock);
+
+	flush_ret = writeback_flush(dc);
+
+	if (flush_ret) {
+		/*
+		 * Re-insert all saved entries back into the current tree
+		 * (which may have accumulated new entries during the flush).
+		 * This preserves both old and new keys instead of leaking
+		 * the new ones.
+		 */
+		spin_lock(&dc->writeback_flush_lock);
+		list_for_each_entry_safe(wp, n, &keys, list) {
+			if (!__writeback_pending_insert(dc, wp)) {
+				/*
+				 * A new writeback completion added this range
+				 * while we held the lock for re-insert —
+				 * expected with PASS_PER_FLUSH > 1.
+				 */
+				list_del_init(&wp->list);
+				mempool_free(wp, dc->writeback_pending_pool);
+				continue;
+			}
+			list_del_init(&wp->list);
+		}
+		spin_unlock(&dc->writeback_flush_lock);
+
+		return false;
+	}
+
+	list_for_each_entry_safe(wp, n, &keys, list) {
+		writeback_clean_key(dc, &wp->key);
+		mempool_free(wp, dc->writeback_pending_pool);
+	}
+
+	return true;
+}
+
 static CLOSURE_CALLBACK(write_dirty)
 {
 	closure_type(io, struct dirty_io, cl);
@@ -471,7 +729,14 @@ static CLOSURE_CALLBACK(read_dirty_submit)
 	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
 }
 
-static void read_dirty(struct cached_dev *dc)
+enum writeback_scan_result {
+	WB_SCAN_PARTIAL,
+	WB_SCAN_PARTIAL_WRAP,
+	WB_SCAN_FULL_SEARCHED,
+};
+
+static void read_dirty(struct cached_dev *dc,
+		       enum writeback_scan_result scan_result)
 {
 	unsigned int delay = 0;
 	struct keybuf_key *next, *keys[MAX_WRITEBACKS_IN_PASS], *w;
@@ -585,10 +850,27 @@ static void read_dirty(struct cached_dev *dc)
 	}
 
 	/*
-	 * Wait for outstanding writeback IOs to finish (and keybuf slots to be
-	 * freed) before refilling again
+	 * Wait for outstanding writeback IOs to finish before refilling again.
+	 * Clean keys are inserted after writeback_finish_batch() flushes the
+	 * backing device.
 	 */
 	closure_sync(&cl);
+
+	dc->writeback_flush_passes++;
+	/*
+	 * WB_SCAN_PARTIAL_WRAP covers two sub-cases: (i) the pre-wrap
+	 * flush failed, so keys are still in the pending tree; (ii) the
+	 * wrap scan filled the keybuf before reaching start_pos.  In
+	 * case (ii) the flush is conservative — we could defer it until
+	 * another pass — but the extra flush is cheap and the simpler
+	 * predicate avoids tracking the distinction through refill_dirty.
+	 */
+	if (dc->writeback_flush_passes >= PASS_PER_FLUSH ||
+	    scan_result == WB_SCAN_FULL_SEARCHED ||
+	    scan_result == WB_SCAN_PARTIAL_WRAP) {
+		if (writeback_finish_batch(dc))
+			dc->writeback_flush_passes = 0;
+	}
 }
 
 /* Scan for dirty data */
@@ -652,28 +934,44 @@ static bool dirty_pred(struct keybuf *buf, struct bkey *k)
 static void refill_full_stripes(struct cached_dev *dc)
 {
 	struct keybuf *buf = &dc->writeback_keys;
-	unsigned int start_stripe, next_stripe;
+	unsigned int next_stripe;
 	int stripe;
-	bool wrapped = false;
 
 	stripe = offset_to_stripe(&dc->disk, KEY_OFFSET(&buf->last_scanned));
 	if (stripe < 0)
 		stripe = 0;
 
-	start_stripe = stripe;
-
 	while (1) {
 		stripe = find_next_bit(dc->disk.full_dirty_stripes,
 				       dc->disk.nr_stripes, stripe);
 
+		/*
+		 * Reached the end of stripes.  Do not wrap here — return
+		 * and let refill_dirty() handle the wrap (which optionally
+		 * flushes pending entries first), so keys already in
+		 * writeback_flush_pending are not re-selected.
+		 */
 		if (stripe == dc->disk.nr_stripes)
-			goto next;
+			return;
 
 		next_stripe = find_next_zero_bit(dc->disk.full_dirty_stripes,
 						 dc->disk.nr_stripes, stripe);
 
-		buf->last_scanned = KEY(dc->disk.id,
-					stripe * dc->disk.stripe_size, 0);
+		/*
+		 * Don't rewind last_scanned: if the keybuf filled
+		 * mid-range on the previous pass, keys from the
+		 * start of this stripe up to last_scanned have
+		 * already been written back and may be sitting in
+		 * writeback_flush_pending (still dirty in btree).
+		 * Rewinding would re-select them, creating
+		 * duplicates.
+		 */
+		if (bkey_cmp(&buf->last_scanned,
+			     &KEY(dc->disk.id,
+				  stripe * dc->disk.stripe_size, 0)) < 0)
+			buf->last_scanned = KEY(dc->disk.id,
+						stripe * dc->disk.stripe_size,
+						0);
 
 		bch_refill_keybuf(dc->disk.c, buf,
 				  &KEY(dc->disk.id,
@@ -684,21 +982,19 @@ static void refill_full_stripes(struct cached_dev *dc)
 			return;
 
 		stripe = next_stripe;
-next:
-		if (wrapped && stripe > start_stripe)
-			return;
-
-		if (stripe == dc->disk.nr_stripes) {
-			stripe = 0;
-			wrapped = true;
-		}
 	}
 }
 
 /*
- * Returns true if we scanned the entire disk
+ * Refill the writeback keybuf by scanning the btree for dirty keys.
+ *
+ * IMPORTANT: writeback_lock is held on entry but may be transiently
+ * released mid-function when flushing pending keys before a wrap-around
+ * scan.  Callers must not rely on the lock being held across the call.
+ *
+ * Returns the scan result indicating scan coverage.
  */
-static bool refill_dirty(struct cached_dev *dc)
+static enum writeback_scan_result refill_dirty(struct cached_dev *dc)
 {
 	struct keybuf *buf = &dc->writeback_keys;
 	struct bkey start = KEY(dc->disk.id, 0, 0);
@@ -717,30 +1013,49 @@ static bool refill_dirty(struct cached_dev *dc)
 	if (dc->partial_stripes_expensive) {
 		refill_full_stripes(dc);
 		if (array_freelist_empty(&buf->freelist))
-			return false;
+			return WB_SCAN_PARTIAL;
 	}
 
 	start_pos = buf->last_scanned;
 	bch_refill_keybuf(dc->disk.c, buf, &end, dirty_pred);
 
 	if (bkey_cmp(&buf->last_scanned, &end) < 0)
-		return false;
+		return WB_SCAN_PARTIAL;
 
 	/*
-	 * If we get to the end start scanning again from the beginning, and
-	 * only scan up to where we initially started scanning from:
+	 * Forward scan reached the end. Flush pending writeback keys
+	 * before wrapping around, so the wrap scan won't re-select
+	 * keys that are already on writeback_flush_pending.
+	 */
+	if (!writeback_pending_empty(dc)) {
+		bool flushed;
+
+		up_write(&dc->writeback_lock);
+		flushed = writeback_finish_batch(dc);
+		down_write(&dc->writeback_lock);
+
+		if (!flushed)
+			return WB_SCAN_PARTIAL_WRAP;
+	}
+
+	/*
+	 * Start scanning again from the beginning, up to where we
+	 * initially started.
 	 */
 	buf->last_scanned = start;
 	bch_refill_keybuf(dc->disk.c, buf, &start_pos, dirty_pred);
 
-	return bkey_cmp(&buf->last_scanned, &start_pos) >= 0;
+	if (bkey_cmp(&buf->last_scanned, &start_pos) < 0)
+		return WB_SCAN_PARTIAL_WRAP;
+
+	return WB_SCAN_FULL_SEARCHED;
 }
 
 static int bch_writeback_thread(void *arg)
 {
 	struct cached_dev *dc = arg;
 	struct cache_set *c = dc->disk.c;
-	bool searched_full_index;
+	enum writeback_scan_result searched_full_index;
 
 	bch_ratelimit_reset(&dc->writeback_rate);
 
@@ -765,6 +1080,26 @@ static int bch_writeback_thread(void *arg)
 				break;
 			}
 
+			/*
+			 * Drain writeback_flush_pending before sleeping.
+			 * If writeback_running is cleared mid-cycle (e.g., at
+			 * pass 37 of PASS_PER_FLUSH=40), read_dirty() waits
+			 * for all IOs via closure_sync, so write_dirty_finish()
+			 * has already pushed entries into
+			 * writeback_flush_pending before this sleep check is
+			 * reached.  With writeback stopped, no further
+			 * read_dirty() call fires and the next PASS_PER_FLUSH
+			 * threshold is never reached.
+			 *
+			 * Use continue so the sleep condition is re-evaluated
+			 * after the drain completes.
+			 */
+			if (!writeback_pending_empty(dc)) {
+				set_current_state(TASK_RUNNING);
+				writeback_finish_batch(dc);
+				continue;
+			}
+
 			schedule();
 			continue;
 		}
@@ -772,8 +1107,9 @@ static int bch_writeback_thread(void *arg)
 
 		searched_full_index = refill_dirty(dc);
 
-		if (searched_full_index &&
-		    RB_EMPTY_ROOT(&dc->writeback_keys.keys)) {
+		if (searched_full_index == WB_SCAN_FULL_SEARCHED &&
+		    RB_EMPTY_ROOT(&dc->writeback_keys.keys) &&
+		    writeback_pending_empty(dc)) {
 			atomic_set(&dc->has_dirty, 0);
 			SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
 			bch_write_bdev_super(dc, NULL);
@@ -816,9 +1152,9 @@ static int bch_writeback_thread(void *arg)
 
 		up_write(&dc->writeback_lock);
 
-		read_dirty(dc);
+		read_dirty(dc, searched_full_index);
 
-		if (searched_full_index) {
+		if (searched_full_index == WB_SCAN_FULL_SEARCHED) {
 			unsigned int delay = dc->writeback_delay * HZ;
 
 			while (delay &&
@@ -831,8 +1167,40 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
-	if (dc->writeback_write_wq)
+	if (dc->writeback_write_wq) {
 		destroy_workqueue(dc->writeback_write_wq);
+		dc->writeback_write_wq = NULL;
+	}
+
+	/*
+	 * Try a final flush-and-clean before draining so pending keys are
+	 * cleaned rather than left dirty for the next mount.
+	 *
+	 * Skip when the cache set is disabled (flush would hang on a dead
+	 * backing device) or the device is detaching (the in-loop drain
+	 * has already cleaned everything; otherwise we tolerate redoing
+	 * the work on next mount).
+	 *
+	 * Note: a backing-device failure that races the flag checks above
+	 * can still hang kthread teardown — bounded by the device's own
+	 * IO-error timeout.
+	 *
+	 * We do NOT set BDEV_STATE_CLEAN here because the in-loop check
+	 * additionally requires WB_SCAN_FULL_SEARCHED (a full btree scan
+	 * found nothing dirty).  Without that gate, the on-disk superblock
+	 * could be marked clean while the btree still holds dirty keys
+	 * that were never scanned by this thread (e.g. kthread_stop from
+	 * bch_cached_dev_attach's error path).  Let the next mount observe
+	 * BDEV_STATE_DIRTY and re-confirm.
+	 */
+	if (!test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
+	    !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
+		writeback_finish_batch(dc);
+
+	writeback_drain_pending(dc);
+
+	mempool_destroy(dc->writeback_pending_pool);
+	dc->writeback_pending_pool = NULL;
 
 	cached_dev_put(dc);
 	wait_for_kthread_stop();
@@ -1049,6 +1417,9 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	sema_init(&dc->in_flight, 64);
 	init_rwsem(&dc->writeback_lock);
 	bch_keybuf_init(&dc->writeback_keys);
+	dc->writeback_flush_pending = RB_ROOT;
+	spin_lock_init(&dc->writeback_flush_lock);
+	dc->writeback_flush_passes	= 0;
 
 	dc->writeback_metadata		= true;
 	dc->writeback_running		= false;
@@ -1079,11 +1450,27 @@ int bch_cached_dev_writeback_start(struct cached_dev *dc)
 	if (!dc->writeback_write_wq)
 		return -ENOMEM;
 
+	/*
+	 * Pre-allocate a pool sized to the maximum number of concurrent
+	 * writeback IOs (bounded by the in_flight semaphore, initialised to
+	 * 64).  mempool_alloc(GFP_NOIO) will draw from this reserve when the
+	 * normal allocator fails under memory pressure, guaranteeing that
+	 * writeback_add_to_pending() never drops an entry silently.
+	 */
+	dc->writeback_pending_pool = mempool_create_kmalloc_pool(
+			64, sizeof(struct writeback_pending));
+	if (!dc->writeback_pending_pool) {
+		destroy_workqueue(dc->writeback_write_wq);
+		return -ENOMEM;
+	}
+
 	cached_dev_get(dc);
 	dc->writeback_thread = kthread_create(bch_writeback_thread, dc,
 					      "bcache_writeback");
 	if (IS_ERR(dc->writeback_thread)) {
 		cached_dev_put(dc);
+		mempool_destroy(dc->writeback_pending_pool);
+		dc->writeback_pending_pool = NULL;
 		destroy_workqueue(dc->writeback_write_wq);
 		return PTR_ERR(dc->writeback_thread);
 	}
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df71695..51aba51b2 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -10,6 +10,14 @@
 
 #define MAX_WRITEBACKS_IN_PASS  5
 #define MAX_WRITESIZE_IN_PASS   5000	/* *512b */
+/*
+ * Number of read_dirty() passes before forcing a backing-device flush
+ * and clean-key insert.  Larger values amortize flush cost but may
+ * re-select keys still in writeback_flush_pending (still KEY_DIRTY)
+ * and re-write them, causing IO amplification.  Small values flush
+ * more often, reducing amplification at the cost of more flushes.
+ */
+#define PASS_PER_FLUSH		5
 
 #define WRITEBACK_RATE_UPDATE_SECS_MAX		60
 #define WRITEBACK_RATE_UPDATE_SECS_DEFAULT	5
@@ -21,6 +29,7 @@
 #define BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH 64
 
 #define BCH_DIRTY_INIT_THRD_MAX	12
+
 /*
  * 14 (16384ths) is chosen here as something that each backing device
  * should be a reasonable fraction of the share, and not to blow up
@@ -28,6 +37,10 @@
  */
 #define WRITEBACK_SHARE_SHIFT   14
 
+bool bch_writeback_drop_pending(struct cached_dev *dc,
+				struct bkey *start,
+				struct bkey *end);
+
 struct bch_dirty_init_state;
 struct dirty_init_thrd_info {
 	struct bch_dirty_init_state	*state;
-- 
2.52.0.windows.1

