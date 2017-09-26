From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Tue, 26 Sep 2017 12:24:22 -0700
Message-ID: <20170926192423.10665-4-mlyle@lyle.org>
References: <20170926192423.10665-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38026 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbdIZTYy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 15:24:54 -0400
Received: by mail-pg0-f67.google.com with SMTP id m30so7280903pgn.5
        for <linux-bcache@vger.kernel.org>; Tue, 26 Sep 2017 12:24:54 -0700 (PDT)
In-Reply-To: <20170926192423.10665-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: i@coly.li, Michael Lyle <mlyle@lyle.org>

Previously, there was some logic that attempted to immediately issue
writeback of backing-contiguous blocks when the writeback rate was
fast.

The previous logic did not have any limits on the aggregate size it
would issue, nor the number of keys it would combine at once.  It
would also discard the chance to do a contiguous write when the
writeback rate was low-- e.g. at "background" writeback of target
rate = 8, it would not combine two adjacent 4k writes and would
instead seek the disk twice.

This patch imposes limits and explicitly understands the size of
contiguous I/O during issue.  It also will combine contiguous I/O
in all circumstances, not just when writeback is requested to be
relatively fast.

It is a win on its own, but also lays the groundwork for skip writes to
short keys to make the I/O more sequential/contiguous.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/bcache.h    |   6 --
 drivers/md/bcache/writeback.c | 131 ++++++++++++++++++++++++++++++------------
 2 files changed, 93 insertions(+), 44 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index eb83be693d60..da803a3b1981 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -321,12 +321,6 @@ struct cached_dev {
 	struct bch_ratelimit	writeback_rate;
 	struct delayed_work	writeback_rate_update;
 
-	/*
-	 * Internal to the writeback code, so read_dirty() can keep track of
-	 * where it's at.
-	 */
-	sector_t		last_read;
-
 	/* Limit number of writeback bios in flight */
 	struct semaphore	in_flight;
 	struct task_struct	*writeback_thread;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0b7c89813635..cf29c44605b9 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -229,10 +229,26 @@ static void read_dirty_submit(struct closure *cl)
 	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
 }
 
+static inline bool keys_contiguous(struct cached_dev *dc,
+		struct keybuf_key *first, struct keybuf_key *second)
+{
+	if (PTR_CACHE(dc->disk.c, &second->key, 0)->bdev !=
+			PTR_CACHE(dc->disk.c, &first->key, 0)->bdev)
+		return false;
+
+	if (PTR_OFFSET(&second->key, 0) !=
+			(PTR_OFFSET(&first->key, 0) + KEY_SIZE(&first->key)))
+		return false;
+
+	return true;
+}
+
 static void read_dirty(struct cached_dev *dc)
 {
 	unsigned delay = 0;
-	struct keybuf_key *w;
+	struct keybuf_key *next, *keys[5], *w;
+	size_t size;
+	int nk, i;
 	struct dirty_io *io;
 	struct closure cl;
 
@@ -243,45 +259,84 @@ static void read_dirty(struct cached_dev *dc)
 	 * mempools.
 	 */
 
-	while (!kthread_should_stop()) {
-
-		w = bch_keybuf_next(&dc->writeback_keys);
-		if (!w)
-			break;
-
-		BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
-
-		if (KEY_START(&w->key) != dc->last_read ||
-		    jiffies_to_msecs(delay) > 50)
-			while (!kthread_should_stop() && delay)
-				delay = schedule_timeout_interruptible(delay);
-
-		dc->last_read	= KEY_OFFSET(&w->key);
-
-		io = kzalloc(sizeof(struct dirty_io) + sizeof(struct bio_vec)
-			     * DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
-			     GFP_KERNEL);
-		if (!io)
-			goto err;
-
-		w->private	= io;
-		io->dc		= dc;
-
-		dirty_init(w);
-		bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
-		io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
-		bio_set_dev(&io->bio, PTR_CACHE(dc->disk.c, &w->key, 0)->bdev);
-		io->bio.bi_end_io	= read_dirty_endio;
-
-		if (bio_alloc_pages(&io->bio, GFP_KERNEL))
-			goto err_free;
-
-		trace_bcache_writeback(&w->key);
+	next = bch_keybuf_next(&dc->writeback_keys);
+
+	while (!kthread_should_stop() && next) {
+		size = 0;
+		nk = 0;
+
+		do {
+			BUG_ON(ptr_stale(dc->disk.c, &next->key, 0));
+
+			/* Don't combine too many operations, even if they
+			 * are all small.
+			 */
+			if (nk >= 5)
+				break;
+
+			/* If the current operation is very large, don't
+			 * further combine operations.
+			 */
+			if (size > 5000)
+				break;
+
+			/* Operations are only eligible to be combined
+			 * if they are contiguous.
+			 *
+			 * TODO: add a heuristic willing to fire a
+			 * certain amount of non-contiguous IO per pass,
+			 * so that we can benefit from backing device
+			 * command queueing.
+			 */
+			if (nk != 0 && !keys_contiguous(dc, keys[nk-1], next))
+				break;
+
+			size += KEY_SIZE(&next->key);
+			keys[nk++] = next;
+		} while ((next = bch_keybuf_next(&dc->writeback_keys)));
+
+		/* Now we have gathered a set of 1..5 keys to write back. */
+
+		for (i = 0; i < nk; i++) {
+			w = keys[i];
+
+			io = kzalloc(sizeof(struct dirty_io) +
+				     sizeof(struct bio_vec) *
+				     DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
+				     GFP_KERNEL);
+			if (!io)
+				goto err;
+
+			w->private	= io;
+			io->dc		= dc;
+
+			dirty_init(w);
+			bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
+			io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
+			bio_set_dev(&io->bio,
+				    PTR_CACHE(dc->disk.c, &w->key, 0)->bdev);
+			io->bio.bi_end_io	= read_dirty_endio;
+
+			if (bio_alloc_pages(&io->bio, GFP_KERNEL))
+				goto err_free;
+
+			trace_bcache_writeback(&w->key);
+
+			down(&dc->in_flight);
+
+			/* We've acquired a semaphore for the maximum
+			 * simultaneous number of writebacks; from here
+			 * everything happens asynchronously.
+			 */
+			closure_call(&io->cl, read_dirty_submit, NULL, &cl);
+		}
 
-		down(&dc->in_flight);
-		closure_call(&io->cl, read_dirty_submit, NULL, &cl);
+		delay = writeback_delay(dc, size);
 
-		delay = writeback_delay(dc, KEY_SIZE(&w->key));
+		while (!kthread_should_stop() && delay) {
+			schedule_timeout_interruptible(delay);
+			delay = writeback_delay(dc, 0);
+		}
 	}
 
 	if (0) {
-- 
2.11.0
