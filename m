From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] bcache: fix a livelock in btree lock
Date: Wed, 25 Feb 2015 20:32:09 +0800
Message-ID: <1424867529-19748-1-git-send-email-wenqing.lz@taobao.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41807 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbbBYMTH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 25 Feb 2015 07:19:07 -0500
Received: by padfb1 with SMTP id fb1so4858264pad.8
        for <linux-bcache@vger.kernel.org>; Wed, 25 Feb 2015 04:19:07 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>, Joshua Schmid <jschmid@suse.com>, Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kmo@daterainc.com>

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
Tested-by: Joshua Schmid <jschmid@suse.com>
Cc: Joshua Schmid <jschmid@suse.com>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Kent Overstreet <kmo@daterainc.com>
---
changelog:
v2: fix a bug that stops all concurrency writes unconditionally.

 drivers/md/bcache/btree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 00cde40..2a74635 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2162,8 +2162,10 @@ int bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
 		rw_lock(true, b, b->level);
 
 		if (b->key.ptr[0] != btree_ptr ||
-		    b->seq != seq + 1)
+		    b->seq != seq + 1) {
+			op->lock = b->level;
 			goto out;
+		}
 	}
 
 	SET_KEY_PTRS(check_key, 1);
-- 
1.7.9.7
