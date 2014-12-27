From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: Using vmalloc instead of get_free_pages?
Date: Sat, 27 Dec 2014 11:52:18 +0100 (CET)
Message-ID: <20141226142206.GA27239@cuci.nl>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:59535 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaL0L0L (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 27 Dec 2014 06:26:11 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I have a system with currently:
4 x 6TB HDD backing devices  (it will expand to 12 x 8TB HDD)
2 x 490GB SSD caching devices
16GB RAM
16GB Swap

I intend to:
a. Use BTRFS using ncopies=3 (three way mirroring) for data and metadata
   on the backing devices.
b. Use the two SSD caches as a non-redundant (striped) bcache for the
   whole HDD set.

In trying to do this I notice:

- That the amount of memory being allocated for a single caching device
  exceeds maximum the amount allocatable by get_free_pages(), so I changed
  that to use vzalloc(), which seems to work (patch included).
  Is there any direct io from that area which requires special handling?

- bcache does not allow more than one cache device per set.  Is simply
  allowing this in make-bcache enough to get this working, or does it need
  code changes in the driver to allow for this?

commit 65e977a48967804a63487273a47ad39e26f39970
Author: Stephen R. van den Berg <srb@cuci.nl>
Date:   Thu Dec 25 13:54:42 2014 +0100

    Use vmalloc for alloc_bucket_pages.

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4dd2bb7..cbba7ec 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1339,6 +1339,8 @@ void bch_cache_set_release(struct kobject *kobj)
 	module_put(THIS_MODULE);
 }
 
+#define free_bucket_pages(p, c)		(vfree((void*) (p)))
+
 static void cache_set_free(struct closure *cl)
 {
 	struct cache_set *c = container_of(cl, struct cache_set, cl);
@@ -1360,7 +1362,7 @@ static void cache_set_free(struct closure *cl)
 		}
 
 	bch_bset_sort_state_free(&c->sort);
-	free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
+	free_bucket_pages(c->uuids, c);
 
 	if (c->moving_gc_wq)
 		destroy_workqueue(c->moving_gc_wq);
@@ -1462,7 +1464,7 @@ void bch_cache_set_unregister(struct cache_set *c)
 }
 
 #define alloc_bucket_pages(gfp, c)			\
-	((void *) __get_free_pages(__GFP_ZERO|gfp, ilog2(bucket_pages(c))))
+	((void *) vzalloc(bucket_pages(c)<<PAGE_SHIFT))
 
 struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 {
@@ -1801,7 +1803,7 @@ void bch_cache_release(struct kobject *kobj)
 
 	bio_split_pool_free(&ca->bio_split_hook);
 
-	free_pages((unsigned long) ca->disk_buckets, ilog2(bucket_pages(ca)));
+	free_bucket_pages(ca->disk_buckets, ca);
 	kfree(ca->prio_buckets);
 	vfree(ca->buckets);
 
-- 
Stephen.
