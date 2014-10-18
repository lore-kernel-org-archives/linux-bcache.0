From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] bcache: fix a livelock in btree lock
Date: Sat, 18 Oct 2014 20:51:44 +0800
Message-ID: <1413636704-18462-1-git-send-email-wenqing.lz@taobao.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63682 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaJRMlP (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 18 Oct 2014 08:41:15 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so2379075pad.5
        for <linux-bcache@vger.kernel.org>; Sat, 18 Oct 2014 05:41:14 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit tries to fix a livelock in bcache.  This livelock might
happen when we causes a huge number of cache misses simultaneously.

When we get a cache miss, bcache will execute the following path.

->cached_dev_make_request()
  ->cached_dev_read()
    ->cached_lookup()
      ->bch->btree_map_keys()
        ->btree_root()  <------------------------
          ->bch_btree_map_keys_recurse()        |
            ->cache_lookup_fn()                 |
              ->cached_dev_cache_miss()         |
                ->bch_btree_insert_check_key() -|
                  [If btree->seq is not equal to seq + 1, we should return
                   EINTR and traverse btree again.]

In bch_btree_insert_check_key() function we first need to check upgrade
flag (op->lock == -1), and when this flag is true we need to release
read btree->lock and try to take write btree->lock.  During taking and
releasing this write lock, btree->seq will be monotone increased in
order to prevent other threads modify this in cache miss (see btree.h:74).
But if there are some cache misses caused by some requested, we could
meet a livelock because btree->seq is always changed by others.  Thus no
one can make progress.

This commit will try to take write btree->lock if it encounters a race
when we traverse btree.  Although it sacrifice the scalability but we
can ensure that only one can modify the btree.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 drivers/md/bcache/btree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 00cde40..d14560a 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2162,8 +2162,10 @@ int bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
 		rw_lock(true, b, b->level);
 
 		if (b->key.ptr[0] != btree_ptr ||
-		    b->seq != seq + 1)
+		    b->seq != seq + 1) {
+			op->lock = b->c->root->level + 1;
 			goto out;
+		}
 	}
 
 	SET_KEY_PTRS(check_key, 1);
-- 
1.7.1
