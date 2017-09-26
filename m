From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 5/5] bcache: writeback: properly order backing device IO
Date: Tue, 26 Sep 2017 12:24:23 -0700
Message-ID: <20170926192423.10665-5-mlyle@lyle.org>
References: <20170926192423.10665-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37783 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754459AbdIZTYz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 15:24:55 -0400
Received: by mail-pf0-f195.google.com with SMTP id e69so5363777pfg.4
        for <linux-bcache@vger.kernel.org>; Tue, 26 Sep 2017 12:24:55 -0700 (PDT)
In-Reply-To: <20170926192423.10665-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: i@coly.li, Michael Lyle <mlyle@lyle.org>

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
 drivers/md/bcache/bcache.h    |  7 +++++++
 drivers/md/bcache/writeback.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index da803a3b1981..6ae6efda6c57 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -328,6 +328,13 @@ struct cached_dev {
 
 	struct keybuf		writeback_keys;
 
+	/* Order the write-half of writeback operations strongly in dispatch
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
index cf29c44605b9..3ca775fbae7f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -112,6 +112,7 @@ static unsigned writeback_delay(struct cached_dev *dc, unsigned sectors)
 struct dirty_io {
 	struct closure		cl;
 	struct cached_dev	*dc;
+	uint16_t		sequence;
 	struct bio		bio;
 };
 
@@ -190,6 +191,26 @@ static void write_dirty(struct closure *cl)
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
+			/* Edge case-- it happened in indeterminate order
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
 
 	/* IO errors are signalled using the dirty bit on the key.
 	 * If we failed to read, we should not attempt to write to the
@@ -206,6 +227,9 @@ static void write_dirty(struct closure *cl)
 		closure_bio_submit(&io->bio, cl);
 	}
 
+	atomic_set(&dc->writeback_sequence_next, next_sequence);
+	closure_wake_up(&dc->writeback_ordering_wait);
+
 	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
 }
 
@@ -251,7 +275,10 @@ static void read_dirty(struct cached_dev *dc)
 	int nk, i;
 	struct dirty_io *io;
 	struct closure cl;
+	uint16_t sequence = 0;
 
+	BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
+	atomic_set(&dc->writeback_sequence_next, sequence);
 	closure_init_stack(&cl);
 
 	/*
@@ -309,6 +336,7 @@ static void read_dirty(struct cached_dev *dc)
 
 			w->private	= io;
 			io->dc		= dc;
+			io->sequence    = sequence++;
 
 			dirty_init(w);
 			bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
-- 
2.11.0
