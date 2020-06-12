From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH V3] bcache: fix potential deadlock problem in
 btree_gc_coalesce
Date: Fri, 12 Jun 2020 09:02:40 +0800
Message-ID: <ac6f566d-8503-5c4f-eea3-9bfdddaad41e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:44454 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgFLBCv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 11 Jun 2020 21:02:51 -0400
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kmo@daterainc.com>, linux-bcache@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "wubo (T)" <wubo40@huawei.com>, Mingfangsen <mingfangsen@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, linfeilong <linfeilong@huawei.com>, renxudong <renxudong1@huawei.com>


coccicheck reports:
  drivers/md//bcache/btree.c:1538:1-7: preceding lock on line 1417

In btree_gc_coalesce func, if the coalescing process fails, we will goto
to out_nocoalesce tag directly without releasing new_nodes[i]->write_lock.
Then, it will cause a deadlock when trying to acquire new_nodes[i]->write_lock
for freeing new_nodes[i] before return.

btree_gc_coalesce func details as follows:
	if alloc new_nodes[i] fails:
		goto out_nocoalesce;
	mutex_lock(&new_nodes[i]->write_lock) // obtain new_nodes[i]->write_lock
	for (i = nodes - 1; i > 0; --i)	      // main coalescing process
		……
		if coalescing process fails:
			goto out_nocoalesce;  // Here, directly goto out_nocoalesce
					      // tag will cause a deadlock
		……
	mutex_unlock(&new_nodes[i]->write_lock)	// release new_nodes[i]->write_lock
	return;					// coalesing succ, return
	out_nocoalesce:
		btree_node_free(new_nodes[i])	// free new_nodes[i]
			mutex_lock(&new_nodes[i]->write_lock);	// obtain new_nodes[i]->write_lock
			clear_bit(BTREE_NODE_dirty, &ew_nodes[i]->flags); // set flag for reuse
			mutex_unlock(&new_nodes[i]->write_lock); // release new_nodes[i]->write_lock

To fix the problem, we add a new tag 'out_unlock_nocoalesce' for releasing
new_nodes[i]->write_lock before out_nocoalesce tag. If coalescing process fails,
we will go to out_unlock_nocoalesce tag for releasing new_nodes[i]->write_lock
before free new_nodes[i] in out_nocoalesce tag.

Fixes: 2a285686c109816 ("bcache: btree locking rework")
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
Changelog:
	V3: improve commit log again (suggested by Markus and Coly)
	V2: improve commit log
	V1: initial version

 drivers/md/bcache/btree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 72856e5f23a3..fd1f288fd801 100644
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
2.19.1
