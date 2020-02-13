From: Coly Li <colyli@suse.de>
Subject: [PATCH 3/3] bcache: remove macro nr_to_fifo_front()
Date: Thu, 13 Feb 2020 22:12:07 +0800
Message-ID: <20200213141207.77219-4-colyli@suse.de>
References: <20200213141207.77219-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50402 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgBMOMd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Feb 2020 09:12:33 -0500
In-Reply-To: <20200213141207.77219-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

Macro nr_to_fifo_front() is only used once in btree_flush_write(),
it is unncessary indeed. This patch removes this macro and does
calculation directly in place.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 6730820780b0..0e3ff9745ac7 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -417,8 +417,6 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 
 /* Journalling */
 
-#define nr_to_fifo_front(p, front_p, mask)	(((p) - (front_p)) & (mask))
-
 static void btree_flush_write(struct cache_set *c)
 {
 	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
@@ -510,9 +508,8 @@ static void btree_flush_write(struct cache_set *c)
 		 *   journal entry can be reclaimed). These selected nodes
 		 *   will be ignored and skipped in the folowing for-loop.
 		 */
-		if (nr_to_fifo_front(btree_current_write(b)->journal,
-				     fifo_front_p,
-				     mask) != 0) {
+		if (((btree_current_write(b)->journal - fifo_front_p) &
+		     mask) != 0) {
 			mutex_unlock(&b->write_lock);
 			continue;
 		}
-- 
2.16.4
