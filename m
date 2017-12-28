From: Michael Lyle <mlyle@lyle.org>
Subject: [for-416 PATCH 2/3] bcache: writeback: properly order backing device IO
Date: Wed, 27 Dec 2017 16:47:43 -0800
Message-ID: <20171228004744.3522-2-mlyle@lyle.org>
References: <20171228004744.3522-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:44167 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752782AbdL1AsJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Dec 2017 19:48:09 -0500
Received: by mail-pl0-f67.google.com with SMTP id n13so20277744plp.11
        for <linux-bcache@vger.kernel.org>; Wed, 27 Dec 2017 16:48:09 -0800 (PST)
In-Reply-To: <20171228004744.3522-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Michael Lyle <mlyle@lyle.org>

Writeback keys are presently iterated and dispatched for writeback in
order of the logical block address on the backing device.  Multiple may
be, in parallel, read from the cache device and then written back
(especially when there are contiguous I/O).

However-- there was no guarantee with the existing code that the writes
would be issued in LBA order, as the reads from the cache device are
often re-ordered.  In turn, when writing back quickly, the backing disk
often has to seek backwards-- this slows writeback and increases
utilization.

This patch introduces an ordering mechanism that guarantees that the
original order of issue is maintained for the write portion of the I/O.
Performance for writeback is significantly improved when there are
multiple contiguous keys or high writeback rates.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/bcache.h    |  8 ++++++++
 drivers/md/bcache/writeback.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1784e50eb857..3be0fcc19b1f 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -330,6 +330,14 @@ struct cached_dev {
 
 	struct keybuf		writeback_keys;
 
+	/*
+	 * Order the write-half of writeback operations strongly in dispatch
+	 * order.  (Maintain LBA order; don't allow reads completing out of
+	 * order to re-order the writes...)
+	 */
+	struct closure_waitlist writeback_ordering_wait;
+	atomic_t		writeback_sequence_next;
+
 	/* For tracking sequential IO */
 #define RECENT_IO_BITS	7
 #define RECENT_IO	(1 << RECENT_IO_BITS)
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 4e4836c6e7cf..4084586d5991 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -130,6 +130,7 @@ static unsigned writeback_delay(struct cached_dev *dc, unsigned sectors)
 struct dirty_io {
 	struct closure		cl;
 	struct cached_dev	*dc;
+	uint16_t		sequence;
 	struct bio		bio;
 };
 
@@ -208,6 +209,27 @@ static void write_dirty(struct closure *cl)
 {
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
+	struct cached_dev *dc = io->dc;
+
+	uint16_t next_sequence;
+
+	if (atomic_read(&dc->writeback_sequence_next) != io->sequence) {
+		/* Not our turn to write; wait for a write to complete */
+		closure_wait(&dc->writeback_ordering_wait, cl);
+
+		if (atomic_read(&dc->writeback_sequence_next) == io->sequence) {
+			/*
+			 * Edge case-- it happened in indeterminate order
+			 * relative to when we were added to wait list..
+			 */
+			closure_wake_up(&dc->writeback_ordering_wait);
+		}
+
+		continue_at(cl, write_dirty, io->dc->writeback_write_wq);
+		return;
+	}
+
+	next_sequence = io->sequence + 1;
 
 	/*
 	 * IO errors are signalled using the dirty bit on the key.
@@ -225,6 +247,9 @@ static void write_dirty(struct closure *cl)
 		closure_bio_submit(&io->bio, cl);
 	}
 
+	atomic_set(&dc->writeback_sequence_next, next_sequence);
+	closure_wake_up(&dc->writeback_ordering_wait);
+
 	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
 }
 
@@ -269,7 +294,10 @@ static void read_dirty(struct cached_dev *dc)
 	int nk, i;
 	struct dirty_io *io;
 	struct closure cl;
+	uint16_t sequence = 0;
 
+	BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
+	atomic_set(&dc->writeback_sequence_next, sequence);
 	closure_init_stack(&cl);
 
 	/*
@@ -330,6 +358,7 @@ static void read_dirty(struct cached_dev *dc)
 
 			w->private	= io;
 			io->dc		= dc;
+			io->sequence    = sequence++;
 
 			dirty_init(w);
 			bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
-- 
2.14.1
