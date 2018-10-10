From: Guoju Fang <fangguoju@gmail.com>
Subject: [PATCH] bcache: fix superblock being corrupted with non-4KB page size
Date: Thu, 11 Oct 2018 02:27:43 +0800
Message-ID: <1539196063-129439-1-git-send-email-fangguoju@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guoju Fang <fangguoju@gmail.com>
List-Id: linux-bcache@vger.kernel.org

In read_super(), after read super block  by __bread(), a page is used to
cache the data. But it will cause superblock corrupted when PAGE_SIZE is
8KB or larger, because bh->b_data doesn't always point to the beginning
of the page. So use a bio_vec struct to point the superblock cached.

Signed-off-by: Guoju Fang <fangguoju@gmail.com>
---
 drivers/md/bcache/super.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 30ba9ae..64715a8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -58,7 +58,7 @@
 /* Superblock */
 
 static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
-			      struct page **res)
+			      struct bio_vec *bv)
 {
 	const char *err;
 	struct cache_sb *s;
@@ -188,7 +188,9 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	err = NULL;
 
 	get_page(bh->b_page);
-	*res = bh->b_page;
+	bv->bv_page = bh->b_page;
+	bv->bv_len = SB_SIZE;
+	bv->bv_offset = (unsigned long)bh->b_data & ~PAGE_MASK;
 err:
 	put_bh(bh);
 	return err;
@@ -204,7 +206,8 @@ static void write_bdev_super_endio(struct bio *bio)
 
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
-	struct cache_sb *out = page_address(bio_first_page_all(bio));
+	struct cache_sb *out = page_address(bio_first_bvec_all(bio)->bv_page) +
+		    bio_first_bvec_all(bio)->bv_offset;
 	unsigned int i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
@@ -1277,7 +1280,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 
 /* Cached device - bcache superblock */
 
-static void register_bdev(struct cache_sb *sb, struct page *sb_page,
+static void register_bdev(struct cache_sb *sb, struct bio_vec *bv,
 				 struct block_device *bdev,
 				 struct cached_dev *dc)
 {
@@ -1290,8 +1293,8 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev->bd_holder = dc;
 
 	bio_init(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
-	bio_first_bvec_all(&dc->sb_bio)->bv_page = sb_page;
-	get_page(sb_page);
+	memcpy(bio_first_bvec_all(&dc->sb_bio), bv, sizeof(*bv));
+	get_page(bv->bv_page);
 
 
 	if (cached_dev_init(dc, sb->block_size << 9))
@@ -2089,7 +2092,7 @@ static int cache_alloc(struct cache *ca)
 	return 0;
 }
 
-static int register_cache(struct cache_sb *sb, struct page *sb_page,
+static int register_cache(struct cache_sb *sb, struct bio_vec *bv,
 				struct block_device *bdev, struct cache *ca)
 {
 	const char *err = NULL; /* must be set for any error case */
@@ -2101,8 +2104,8 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->bdev->bd_holder = ca;
 
 	bio_init(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
-	bio_first_bvec_all(&ca->sb_bio)->bv_page = sb_page;
-	get_page(sb_page);
+	memcpy(bio_first_bvec_all(&ca->sb_bio), bv, sizeof(*bv));
+	get_page(bv->bv_page);
 
 	if (blk_queue_discard(bdev_get_queue(bdev)))
 		ca->discard = CACHE_DISCARD(&ca->sb);
@@ -2195,7 +2198,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	char *path = NULL;
 	struct cache_sb *sb = NULL;
 	struct block_device *bdev = NULL;
-	struct page *sb_page = NULL;
+	struct bio_vec bv = { NULL };
 
 	if (!try_module_get(THIS_MODULE))
 		return -EBUSY;
@@ -2233,7 +2236,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto err_close;
 
-	err = read_super(sb, bdev, &sb_page);
+	err = read_super(sb, bdev, &bv);
 	if (err)
 		goto err_close;
 
@@ -2245,7 +2248,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			goto err_close;
 
 		mutex_lock(&bch_register_lock);
-		register_bdev(sb, sb_page, bdev, dc);
+		register_bdev(sb, &bv, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 	} else {
 		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
@@ -2253,12 +2256,12 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		if (!ca)
 			goto err_close;
 
-		if (register_cache(sb, sb_page, bdev, ca) != 0)
+		if (register_cache(sb, &bv, bdev, ca) != 0)
 			goto err;
 	}
 out:
-	if (sb_page)
-		put_page(sb_page);
+	if (bv.bv_page)
+		put_page(bv.bv_page);
 	kfree(sb);
 	kfree(path);
 	module_put(THIS_MODULE);
-- 
1.8.3.1
