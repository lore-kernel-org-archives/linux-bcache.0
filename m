From: Dongbo Cao <cdbdyx@163.com>
Subject: [PATCH] split if-condition code in bch_cache_set_alloc
Date: Wed, 26 Sep 2018 17:00:32 +0800
Message-ID: <20180926090032.1881-1-cdbdyx@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Dongbo Cao <cdbdyx@163.com>
List-Id: linux-bcache@vger.kernel.org

rebase my local code and commit it again.

Signed-off-by: Dongbo Cao <cdbdyx@163.com>
---
 drivers/md/bcache/super.c | 114 +++++++++++++++++++++++++++++++-------
 1 file changed, 93 insertions(+), 21 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a2cc354c..03099c4c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1691,10 +1691,13 @@ void bch_cache_set_unregister(struct cache_set *c)
 struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 {
 	int iter_size;
-	struct cache_set *c = kzalloc(sizeof(struct cache_set), GFP_KERNEL);
+	const char *err = NULL;
 
-	if (!c)
-		return NULL;
+	struct cache_set *c = kzalloc(sizeof(struct cache_set), GFP_KERNEL);
+	if (!c) {
+		err = "cache_set alloc failed";
+		goto err_cache_set_alloc;
+	}
 
 	__module_get(THIS_MODULE);
 	closure_init(&c->cl, NULL);
@@ -1750,22 +1753,65 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	iter_size = (sb->bucket_size / sb->block_size + 1) *
 		sizeof(struct btree_iter_set);
 
-	if (!(c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL)) ||
-	    mempool_init_slab_pool(&c->search, 32, bch_search_cache) ||
-	    mempool_init_kmalloc_pool(&c->bio_meta, 2,
-				sizeof(struct bbio) + sizeof(struct bio_vec) *
-				bucket_pages(c)) ||
-	    mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size) ||
-	    bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
-			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
-	    !(c->uuids = alloc_bucket_pages(GFP_KERNEL, c)) ||
-	    !(c->moving_gc_wq = alloc_workqueue("bcache_gc",
-						WQ_MEM_RECLAIM, 0)) ||
-	    bch_journal_alloc(c) ||
-	    bch_btree_cache_alloc(c) ||
-	    bch_open_buckets_alloc(c) ||
-	    bch_bset_sort_state_init(&c->sort, ilog2(c->btree_pages)))
-		goto err;
+	c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL);
+	if (!c->devices) {
+		err = "c->devices alloc failed";
+		goto err_devices_alloc;
+	}
+
+	if (mempool_init_slab_pool(&c->search, 32, bch_search_cache)) {
+		err = "c->search alloc failed";
+		goto err_search_alloc;
+	}
+
+	if (mempool_init_kmalloc_pool(&c->bio_meta, 2, sizeof(struct bbio)
+				+ sizeof(struct bio_vec) * bucket_pages(c))) {
+		err = "c->bio_meta alloc failed";
+		goto err_bio_meta_alloc;
+	}
+
+	if (mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size)) {
+		err = "c->fill_iter alloc failed";
+		goto err_fill_iter_alloc;
+	}
+
+	if (bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
+				BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER)) {
+		err = "c->bio_split init failed";
+		goto err_bio_split_init;
+	}
+
+	c->uuids = alloc_bucket_pages(GFP_KERNEL, c);
+	if (!c->uuids) {
+		err = "c->uuids alloc failed";
+		goto err_uuids_alloc;
+	}
+
+	c->moving_gc_wq = alloc_workqueue("bcache_gc", WQ_MEM_RECLAIM, 0);
+	if (!c->moving_gc_wq) {
+		err = "c->moving_gc_wq alloc failed";
+		goto err_moving_gc_wq_alloc;
+	}
+
+	if (bch_journal_alloc(c)) {
+		err = "bch_journal_alloc failed";
+		goto err_bch_journal_alloc;
+	}
+
+	if (bch_btree_cache_alloc(c)) {
+		err = "bch_btree_cache_alloc failed";
+		goto err_bch_btree_cache_alloc;
+	}
+
+	if (bch_open_buckets_alloc(c)) {
+		err = "bch_open_buckets_alloc failed";
+		goto err_bch_open_buckets_alloc;
+	}
+
+	if (bch_bset_sort_state_init(&c->sort, ilog2(c->btree_pages))) {
+		err = "bch_bset_sort_state_init failed";
+		goto err_bch_bset_sort_state_init;
+	}
 
 	c->congested_read_threshold_us	= 2000;
 	c->congested_write_threshold_us	= 20000;
@@ -1773,8 +1819,34 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	WARN_ON(test_and_clear_bit(CACHE_SET_IO_DISABLE, &c->flags));
 
 	return c;
-err:
-	bch_cache_set_unregister(c);
+
+err_bch_bset_sort_state_init:
+	bch_open_buckets_free(c);
+err_bch_open_buckets_alloc:
+	bch_btree_cache_free(c);
+err_bch_btree_cache_alloc:
+	bch_journal_free(c);
+err_bch_journal_alloc:
+	destroy_workqueue(c->moving_gc_wq);
+err_moving_gc_wq_alloc:
+	free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
+err_uuids_alloc:
+	bioset_exit(&c->bio_split);
+err_bio_split_init:
+	mempool_exit(&c->fill_iter);
+err_fill_iter_alloc:
+	mempool_exit(&c->bio_meta);
+err_bio_meta_alloc:
+	mempool_exit(&c->search);
+err_search_alloc:
+	kfree(c->devices);
+err_devices_alloc:
+	bch_cache_accounting_destroy(&c->accounting);
+	kfree(c);
+	module_put(THIS_MODULE);
+err_cache_set_alloc:
+	if (err)
+		pr_notice("error cache set %s: %s", c->sb.set_uuid, err);
 	return NULL;
 }
 
-- 
2.17.1
