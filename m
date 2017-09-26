From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 1/5] bcache: don't write back data if reading it failed
Date: Tue, 26 Sep 2017 12:24:19 -0700
Message-ID: <20170926192423.10665-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36574 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdIZTYp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 15:24:45 -0400
Received: by mail-pf0-f196.google.com with SMTP id f84so5374599pfj.3
        for <linux-bcache@vger.kernel.org>; Tue, 26 Sep 2017 12:24:44 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: i@coly.li, Michael Lyle <mlyle@lyle.org>

If an IO operation fails, and we didn't successfully read data from the
cache, don't writeback invalid/partial data to the backing disk.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/writeback.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index e663ca082183..eea49bf36401 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -179,13 +179,20 @@ static void write_dirty(struct closure *cl)
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
 
-	dirty_init(w);
-	bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
-	io->bio.bi_iter.bi_sector = KEY_START(&w->key);
-	bio_set_dev(&io->bio, io->dc->bdev);
-	io->bio.bi_end_io	= dirty_endio;
+	/* IO errors are signalled using the dirty bit on the key.
+	 * If we failed to read, we should not attempt to write to the
+	 * backing device.  Instead, immediately go to write_dirty_finish
+	 * to clean up.
+	 */
+	if (KEY_DIRTY(&w->key)) {
+		dirty_init(w);
+		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
+		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
+		bio_set_dev(&io->bio, io->dc->bdev);
+		io->bio.bi_end_io	= dirty_endio;
 
-	closure_bio_submit(&io->bio, cl);
+		closure_bio_submit(&io->bio, cl);
+	}
 
 	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
 }
-- 
2.11.0
