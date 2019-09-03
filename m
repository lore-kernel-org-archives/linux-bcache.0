From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 02/23] bcache: add comments for mutex_lock(&b->write_lock)
Date: Tue,  3 Sep 2019 12:24:03 -0400
Message-ID: <20190903162424.6877-2-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

When accessing or modifying BTREE_NODE_dirty bit, it is not always
necessary to acquire b->write_lock. In bch_btree_cache_free() and
mca_reap() acquiring b->write_lock is necessary, and this patch adds
comments to explain why mutex_lock(&b->write_lock) is necessary for
checking or clearing BTREE_NODE_dirty bit there.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/btree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 3fbadf2058a65..9788b2ee6638f 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -655,6 +655,11 @@ static int mca_reap(struct btree *b, unsigned int min_order, bool flush)
 		up(&b->io_mutex);
 	}
 
+	/*
+	 * BTREE_NODE_dirty might be cleared in btree_flush_btree() by
+	 * __bch_btree_node_write(). To avoid an extra flush, acquire
+	 * b->write_lock before checking BTREE_NODE_dirty bit.
+	 */
 	mutex_lock(&b->write_lock);
 	if (btree_node_dirty(b))
 		__bch_btree_node_write(b, &cl);
@@ -778,6 +783,11 @@ void bch_btree_cache_free(struct cache_set *c)
 	while (!list_empty(&c->btree_cache)) {
 		b = list_first_entry(&c->btree_cache, struct btree, list);
 
+		/*
+		 * This function is called by cache_set_free(), no I/O
+		 * request on cache now, it is unnecessary to acquire
+		 * b->write_lock before clearing BTREE_NODE_dirty anymore.
+		 */
 		if (btree_node_dirty(b)) {
 			btree_complete_write(b, btree_current_write(b));
 			clear_bit(BTREE_NODE_dirty, &b->flags);
-- 
2.20.1
