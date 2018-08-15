From: Dongbo Cao <cdbdyx@163.com>
Subject: [PATCH 3/3] fix some potential memory leak in bcache_device_init
Date: Wed, 15 Aug 2018 16:41:23 +0800
Message-ID: <20180815084123.7048-1-cdbdyx@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Dongbo Cao <cdbdyx@163.com>
List-Id: linux-bcache@vger.kernel.org

add some goto label to release memory in case we got wrong return value.

Signed-off-by: Dongbo Cao <cdbdyx@163.com>
---
 drivers/md/bcache/super.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 14c31e03..b1197cb7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -768,6 +768,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 					 SIZE_MAX / sizeof(atomic_t));
 	size_t n;
 	int idx;
+	int ret = -ENOMEM;
 
 	if (!d->stripe_size)
 		d->stripe_size = 1 << 31;
@@ -777,18 +778,18 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	if (!d->nr_stripes || d->nr_stripes > max_stripes) {
 		pr_err("nr_stripes too large or invalid: %u (start sector beyond end of disk?)",
 			(unsigned)d->nr_stripes);
-		return -ENOMEM;
+		goto err1;
 	}
 
 	n = d->nr_stripes * sizeof(atomic_t);
 	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
 	if (!d->stripe_sectors_dirty)
-		return -ENOMEM;
+		goto err1;
 
 	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
 	d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
 	if (!d->full_dirty_stripes)
-		return -ENOMEM;
+		goto err2;
 
 	idx = ida_simple_get(&bcache_device_idx, 0,
 				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
@@ -799,7 +800,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
 	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
 		ida_simple_remove(&bcache_device_idx, idx);
-		return -ENOMEM;
+		goto err3;
 	}
 
 	set_capacity(d->disk, sectors);
@@ -812,7 +813,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 
 	q = blk_alloc_queue(GFP_KERNEL);
 	if (!q)
-		return -ENOMEM;
+		goto err4;
 
 	blk_queue_make_request(q, NULL);
 	d->disk->queue			= q;
@@ -834,6 +835,16 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	blk_queue_write_cache(q, true, true);
 
 	return 0;
+err4:
+	bioset_exit(&d->bio_split);
+	if(d->disk)
+		del_gendisk(d->disk);
+err3:
+	kvfree(d->full_dirty_stripes);
+err2:
+	kvfree(d->stripe_sectors_dirty);
+err1:
+	return ret;
 }
 
 /* Cached device */
-- 
2.17.1
