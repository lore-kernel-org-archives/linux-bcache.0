From: Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] bcache: writeback: Remove unneeded variable ret
Date: Thu,  9 Jul 2020 03:39:04 +0000
Message-ID: <20200709033904.27391-1-vulab@iscas.ac.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
List-Id: linux-bcache@vger.kernel.org

Remove unneeded variable ret i.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/md/bcache/writeback.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 1cf1e5016cb9..71801c086b82 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -825,10 +825,8 @@ static int bch_dirty_init_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
-	int i;
 
 	k = p = NULL;
-	i = 0;
 	cur_idx = prev_idx = 0;
 
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
-- 
2.17.1
