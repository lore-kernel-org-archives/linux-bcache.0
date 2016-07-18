From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] bcache: untagle cache_aolloc
Date: Mon, 18 Jul 2016 12:11:09 +0200
Message-ID: <1468836669-1136-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbcGRKLW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 18 Jul 2016 06:11:22 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

bcache's cache_alloc() function currenty has no way freeing memory if one of
the allocations fails. Untangle the if + allocation statement so we have
defined checkpoints to free previous allocations if one fails.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 51 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f5dbb4e..b5703a9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1817,18 +1817,29 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 
 	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
 
-	if (!init_fifo(&ca->free[RESERVE_BTREE], 8, GFP_KERNEL) ||
-	    !init_fifo(&ca->free[RESERVE_PRIO], prio_buckets(ca), GFP_KERNEL) ||
-	    !init_fifo(&ca->free[RESERVE_MOVINGGC], free, GFP_KERNEL) ||
-	    !init_fifo(&ca->free[RESERVE_NONE], free, GFP_KERNEL) ||
-	    !init_fifo(&ca->free_inc,	free << 2, GFP_KERNEL) ||
-	    !init_heap(&ca->heap,	free << 3, GFP_KERNEL) ||
-	    !(ca->buckets	= vzalloc(sizeof(struct bucket) *
-					  ca->sb.nbuckets)) ||
-	    !(ca->prio_buckets	= kzalloc(sizeof(uint64_t) * prio_buckets(ca) *
-					  2, GFP_KERNEL)) ||
-	    !(ca->disk_buckets	= alloc_bucket_pages(GFP_KERNEL, ca)))
+	if (!init_fifo(&ca->free[RESERVE_BTREE], 8, GFP_KERNEL))
 		return -ENOMEM;
+	if (!init_fifo(&ca->free[RESERVE_PRIO], prio_buckets(ca), GFP_KERNEL))
+		goto free_btree_fifo;
+	if (!init_fifo(&ca->free[RESERVE_MOVINGGC], free, GFP_KERNEL))
+		goto free_prio_fifo;
+	if (!init_fifo(&ca->free[RESERVE_NONE], free, GFP_KERNEL))
+		goto free_movinggc_fifo;
+	if (!init_fifo(&ca->free_inc, free << 2, GFP_KERNEL))
+		goto free_none_fifo;
+	if (!init_heap(&ca->heap, free << 3, GFP_KERNEL))
+		goto free_inc_fifo;
+	ca->buckets = vzalloc(sizeof(struct bucket) * ca->sb.nbuckets);
+	if (!ca->buckets)
+		goto free_cache_heap;
+	ca->prio_buckets = kzalloc(sizeof(uint64_t) * prio_buckets(ca) * 2,
+				   GFP_KERNEL);
+	if (!ca->prio_buckets)
+		goto free_cache_buckets;
+
+	ca->disk_buckets = alloc_bucket_pages(GFP_KERNEL, ca);
+	if (!ca->disk_buckets)
+		goto free_prio_buckets;
 
 	ca->prio_last_buckets = ca->prio_buckets + prio_buckets(ca);
 
@@ -1836,6 +1847,24 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 		atomic_set(&b->pin, 0);
 
 	return 0;
+
+free_prio_buckets:
+	kfree(ca->prio_buckets);
+free_cache_buckets:
+	vfree(ca->buckets);
+free_cache_heap:
+	free_heap(&ca->heap);
+free_inc_fifo:
+	free_fifo(&ca->free_inc);
+free_none_fifo:
+	free_fifo(&ca->free[RESERVE_NONE]);
+free_movinggc_fifo:
+	free_fifo(&ca->free[RESERVE_MOVINGGC]);
+free_prio_fifo:
+	free_fifo(&ca->free[RESERVE_PRIO]);
+free_btree_fifo:
+	free_fifo(&ca->free[RESERVE_BTREE]);
+	return -ENOMEM;
 }
 
 static int register_cache(struct cache_sb *sb, struct page *sb_page,
-- 
1.8.5.6
