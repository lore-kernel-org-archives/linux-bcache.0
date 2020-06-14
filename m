From: colyli@suse.de
Subject: [PATCH 1/4] bcache: fix potential deadlock problem in btree_gc_coalesce
Date: Mon, 15 Jun 2020 00:53:30 +0800
Message-ID: <20200614165333.124999-2-colyli@suse.de>
References: <20200614165333.124999-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbgFNQxo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 Jun 2020 12:53:44 -0400
In-Reply-To: <20200614165333.124999-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Zhiqiang Liu <liuzhiqiang26@huawei.com>, Coly Li <colyli@suse.de>

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

coccicheck reports:
  drivers/md//bcache/btree.c:1538:1-7: preceding lock on line 1417

In btree_gc_coalesce func, if the coalescing process fails, we will goto
to out_nocoalesce tag directly without releasing new_nodes[i]->write_lock.
Then, it will cause a deadlock when trying to acquire new_nodes[i]->
write_lock for freeing new_nodes[i] before return.

btree_gc_coalesce func details as follows:
	if alloc new_nodes[i] fails:
		goto out_nocoalesce;
	// obtain new_nodes[i]->write_lock
	mutex_lock(&new_nodes[i]->write_lock)
	// main coalescing process
	for (i = nodes - 1; i > 0; --i)
		[snipped]
		if coalescing process fails:
			// Here, directly goto out_nocoalesce
			 // tag will cause a deadlock
			goto out_nocoalesce;
		[snipped]
	// release new_nodes[i]->write_lock
	mutex_unlock(&new_nodes[i]->write_lock)
	// coalesing succ, return
	return;
out_nocoalesce:
	btree_node_free(new_nodes[i])	// free new_nodes[i]
	// obtain new_nodes[i]->write_lock
	mutex_lock(&new_nodes[i]->write_lock);
	// set flag for reuse
	clear_bit(BTREE_NODE_dirty, &ew_nodes[i]->flags);
	// release new_nodes[i]->write_lock
	mutex_unlock(&new_nodes[i]->write_lock);

To fix the problem, we add a new tag 'out_unlock_nocoalesce' for
releasing new_nodes[i]->write_lock before out_nocoalesce tag. If
coalescing process fails, we will go to out_unlock_nocoalesce tag
for releasing new_nodes[i]->write_lock before free new_nodes[i] in
out_nocoalesce tag.

(Coly Li helps to clean up commit log format.)

Fixes: 2a285686c109816 ("bcache: btree locking rework")
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 39de94edd73a..6548a601edf0 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1389,7 +1389,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 			if (__set_blocks(n1, n1->keys + n2->keys,
 					 block_bytes(b->c)) >
 			    btree_blocks(new_nodes[i]))
-				goto out_nocoalesce;
+				goto out_unlock_nocoalesce;
 
 			keys = n2->keys;
 			/* Take the key of the node we're getting rid of */
@@ -1418,7 +1418,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 
 		if (__bch_keylist_realloc(&keylist,
 					  bkey_u64s(&new_nodes[i]->key)))
-			goto out_nocoalesce;
+			goto out_unlock_nocoalesce;
 
 		bch_btree_node_write(new_nodes[i], &cl);
 		bch_keylist_add(&keylist, &new_nodes[i]->key);
@@ -1464,6 +1464,10 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
 	/* Invalidated our iterator */
 	return -EINTR;
 
+out_unlock_nocoalesce:
+	for (i = 0; i < nodes; i++)
+		mutex_unlock(&new_nodes[i]->write_lock);
+
 out_nocoalesce:
 	closure_sync(&cl);
 
-- 
2.25.0
