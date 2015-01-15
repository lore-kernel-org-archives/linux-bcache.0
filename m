From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: [PATCH] bcache: Make sure to pass GFP_WAIT to mempool_alloc()
Date: Thu, 15 Jan 2015 17:26:37 +0100
Message-ID: <54B7EA3D.7050203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: bcache <linux-bcache@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

this was very wrong - mempool_alloc() only guarantees success with GFP_WAIT.
bcache uses GFP_NOWAIT in various other places where we have a fallback,
circuits must've gotten crossed when writing this code or something.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---

The bug was introduced in v3.11, fixed in v3.17.

Jens mentioned bcache has many stable@ candidates previously: 
https://lkml.org/lkml/2014/9/5/360

I'm cherry-picking this fix because I was getting crashes.

---
  drivers/md/bcache/btree.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 9dd9f1c..e538d45 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -200,11 +200,11 @@ void bch_btree_node_read_done(struct btree *b)
  {
  	const char *err = "bad btree header";
  	struct bset *i = btree_bset_first(b);
  	struct btree_iter *iter;
-	iter = mempool_alloc(b->c->fill_iter, GFP_NOWAIT);
+	iter = mempool_alloc(b->c->fill_iter, GFP_NOIO);
  	iter->size = b->c->sb.bucket_size / b->c->sb.block_size;
  	iter->used = 0;
   #ifdef CONFIG_BCACHE_DEBUG
  	iter->b = &b->keys;
-- 
2.2.0.71.g3365589
