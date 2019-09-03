From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 01/23] bcache: only clear BTREE_NODE_dirty bit when it is set
Date: Tue,  3 Sep 2019 12:24:02 -0400
Message-ID: <20190903162424.6877-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

In bch_btree_cache_free() and btree_node_free(), BTREE_NODE_dirty is
always set no matter btree node is dirty or not. The code looks like
this,
	if (btree_node_dirty(b))
		btree_complete_write(b, btree_current_write(b));
	clear_bit(BTREE_NODE_dirty, &b->flags);

Indeed if btree_node_dirty(b) returns false, it means BTREE_NODE_dirty
bit is cleared, then it is unnecessary to clear the bit again.

This patch only clears BTREE_NODE_dirty when btree_node_dirty(b) is
true (the bit is set), to save a few CPU cycles.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/btree.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 773f5fdad25fb..3fbadf2058a65 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -778,10 +778,10 @@ void bch_btree_cache_free(struct cache_set *c)
 	while (!list_empty(&c->btree_cache)) {
 		b = list_first_entry(&c->btree_cache, struct btree, list);
 
-		if (btree_node_dirty(b))
+		if (btree_node_dirty(b)) {
 			btree_complete_write(b, btree_current_write(b));
-		clear_bit(BTREE_NODE_dirty, &b->flags);
-
+			clear_bit(BTREE_NODE_dirty, &b->flags);
+		}
 		mca_data_free(b);
 	}
 
@@ -1069,9 +1069,10 @@ static void btree_node_free(struct btree *b)
 
 	mutex_lock(&b->write_lock);
 
-	if (btree_node_dirty(b))
+	if (btree_node_dirty(b)) {
 		btree_complete_write(b, btree_current_write(b));
-	clear_bit(BTREE_NODE_dirty, &b->flags);
+		clear_bit(BTREE_NODE_dirty, &b->flags);
+	}
 
 	mutex_unlock(&b->write_lock);
 
-- 
2.20.1
