From: Dongbo Cao <cdbdyx@163.com>
Subject: [PATCH] bug fix for making cache device failed
Date: Fri, 21 Sep 2018 14:14:18 +0800
Message-ID: <20180921061418.3131-1-cdbdyx@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Dongbo Cao <cdbdyx@163.com>
List-Id: linux-bcache@vger.kernel.org

1)when the nbuckets of cache device is smaller than 1024, make cache device will trigger BUG_ON in kernel, add a condition to avoid this.
2)split original if condition code into separate ones to make it clearly to debug.

Signed-off-by: Dongbo Cao <cdbdyx@163.com>
---
 drivers/md/bcache/super.c | 87 ++++++++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fa4058e4..47d122ed 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2017,6 +2017,8 @@ static int cache_alloc(struct cache *ca)
 	size_t free;
 	size_t btree_buckets;
 	struct bucket *b;
+	int ret = -ENOMEM;
+	const char *err = NULL;
 
 	__module_get(THIS_MODULE);
 	kobject_init(&ca->kobj, &bch_cache_ktype);
@@ -2034,27 +2036,82 @@ static int cache_alloc(struct cache *ca)
 	 */
 	btree_buckets = ca->sb.njournal_buckets ?: 8;
 	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
+	if (!free) {
+		ret = -EPERM;
+		err = "ca->sb.nbuckets is too small";
+		goto err_free;
+	}
 
-	if (!init_fifo(&ca->free[RESERVE_BTREE], btree_buckets, GFP_KERNEL) ||
-	    !init_fifo_exact(&ca->free[RESERVE_PRIO], prio_buckets(ca), GFP_KERNEL) ||
-	    !init_fifo(&ca->free[RESERVE_MOVINGGC], free, GFP_KERNEL) ||
-	    !init_fifo(&ca->free[RESERVE_NONE], free, GFP_KERNEL) ||
-	    !init_fifo(&ca->free_inc,	free << 2, GFP_KERNEL) ||
-	    !init_heap(&ca->heap,	free << 3, GFP_KERNEL) ||
-	    !(ca->buckets	= vzalloc(array_size(sizeof(struct bucket),
-						     ca->sb.nbuckets))) ||
-	    !(ca->prio_buckets	= kzalloc(array3_size(sizeof(uint64_t),
-						      prio_buckets(ca), 2),
-					  GFP_KERNEL)) ||
-	    !(ca->disk_buckets	= alloc_bucket_pages(GFP_KERNEL, ca)))
-		return -ENOMEM;
+	if (!init_fifo(&ca->free[RESERVE_BTREE], btree_buckets,
+						GFP_KERNEL)) {
+		err = "ca->free[RESERVE_BTREE] alloc failed";
+		goto err_btree_alloc;
+	}
+	if (!init_fifo_exact(&ca->free[RESERVE_PRIO], prio_buckets(ca),
+							GFP_KERNEL)) {
+		err = "ca->free[RESERVE_PRIO] alloc failed";
+		goto err_prio_alloc;
+	}
+	if (!init_fifo(&ca->free[RESERVE_MOVINGGC], free, GFP_KERNEL)) {
+		err = "ca->free[RESERVE_MOVINGGC] alloc failed";
+		goto err_movinggc_alloc;
+	}
+	if (!init_fifo(&ca->free[RESERVE_NONE], free, GFP_KERNEL)) {
+		err = "ca->free[RESERVE_NONE] alloc failed";
+		goto err_none_alloc;
+	}
+	if (!init_fifo(&ca->free_inc, free << 2, GFP_KERNEL)) {
+		err = "ca->free_inc alloc failed";
+		goto err_free_inc_alloc;
+	}
+	if (!init_heap(&ca->heap, free << 3, GFP_KERNEL)) {
+		err = "ca->heap alloc failed";
+		goto err_heap_alloc;
+	}
+	if (!(ca->buckets = vzalloc(array_size(sizeof(struct bucket),
+						ca->sb.nbuckets)))) {
+		err = "ca->buckets alloc failed";
+		goto err_buckets_alloc;
+	}
+	if (!(ca->prio_buckets = kzalloc(array3_size(sizeof(uint64_t),
+						prio_buckets(ca), 2),
+							GFP_KERNEL))) {
+		err = "ca->prio_buckets alloc failed";
+		goto err_prio_buckets_alloc;
+	}
+	if (!(ca->disk_buckets = alloc_bucket_pages(GFP_KERNEL, ca))) {
+		err = "ca->disk_buckets alloc failed";
+		goto err_disk_buckets_alloc;
+	}
 
 	ca->prio_last_buckets = ca->prio_buckets + prio_buckets(ca);
 
 	for_each_bucket(b, ca)
 		atomic_set(&b->pin, 0);
-
 	return 0;
+
+err_disk_buckets_alloc:
+	kfree(ca->prio_buckets);
+err_prio_buckets_alloc:
+	vfree(ca->buckets);
+err_buckets_alloc:
+	free_heap(&ca->heap);
+err_heap_alloc:
+	free_fifo(&ca->free_inc);
+err_free_inc_alloc:
+	free_fifo(&ca->free[RESERVE_NONE]);
+err_none_alloc:
+	free_fifo(&ca->free[RESERVE_MOVINGGC]);
+err_movinggc_alloc:
+	free_fifo(&ca->free[RESERVE_PRIO]);
+err_prio_alloc:
+	free_fifo(&ca->free[RESERVE_BTREE]);
+err_btree_alloc:
+err_free:
+	module_put(THIS_MODULE);
+	if (err)
+		pr_notice("error %s: %s", ca->cache_dev_name, err);
+	return ret;
 }
 
 static int register_cache(struct cache_sb *sb, struct page *sb_page,
@@ -2080,6 +2137,8 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 		if (ret == -ENOMEM)
 			err = "cache_alloc(): -ENOMEM";
+		else if (ret == -EPERM)
+			err = "cache_alloc(): cache device is too small";
 		else
 			err = "cache_alloc(): unknown error";
 		goto err;
-- 
2.17.1
