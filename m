From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH v3 1/5] bcache: don't write back data if reading it failed
Date: Wed, 27 Sep 2017 10:41:18 -0700
Message-ID: <20170927174122.30341-2-mlyle@lyle.org>
References: <20170927174122.30341-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34041 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751538AbdI0Rli (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 13:41:38 -0400
Received: by mail-pg0-f67.google.com with SMTP id u18so9907619pgo.1
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2017 10:41:38 -0700 (PDT)
In-Reply-To: <20170927174122.30341-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Michael Lyle <mlyle@lyle.org>

If an IO operation fails, and we didn't successfully read data from the
cache, don't writeback invalid/partial data to the backing disk.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
Reviewed-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index e663ca082183..5e65a392287d 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -179,13 +179,21 @@ static void write_dirty(struct closure *cl)
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
 
-	dirty_init(w);
-	bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
-	io->bio.bi_iter.bi_sector = KEY_START(&w->key);
-	bio_set_dev(&io->bio, io->dc->bdev);
-	io->bio.bi_end_io	= dirty_endio;
+	/*
+	 * IO errors are signalled using the dirty bit on the key.
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
