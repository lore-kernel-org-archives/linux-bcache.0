From: Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH v2 2/2] [PATCH] bcache: __write_super to handle page sizes other than 4k
Date: Fri,  6 Dec 2019 21:43:14 +0800
Message-ID: <1575639794-30056-1-git-send-email-liangchen.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Liang Chen <liangchen.linux@gmail.com>
List-Id: linux-bcache@vger.kernel.org

__write_super assumes super block data starts at offset 0 of the page
read in with __bread from read_super, which is not true when page size
is not 4k. We encountered the issue on system with 64K page size - commonly
 seen on aarch64 architecture.

Instead of making any assumption on the offset of the data within the page,
this patch calls __bread again to locate the data. That should not introduce
an extra io since the page has been held when it's read in from read_super,
and __write_super is not on performance critical code path.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/md/bcache/super.c | 56 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a573ce1d85aa..a40eb6335cb8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -207,15 +207,43 @@ static void write_bdev_super_endio(struct bio *bio)
 	closure_put(&dc->sb_write);
 }
 
-static void __write_super(struct cache_sb *sb, struct bio *bio)
+/*
+ * With 4k page size, the 4k super block will be read in at offset 0 of
+ * the cache page. But it's not the case with larger page sizes. For
+ * example, with 64k page size reading in a 4k size block will cause the
+ * cache page being divided into 16 equal sized buffers, and block 1
+ * to be put at offset 4K in the page.
+ * Thus locating the super block again is nessessary in order to be
+ * compatilbe with different page sizes. And the page is held since
+ * read_super, this __bread should not cause an extra io.
+ */
+static inline struct cache_sb *locate_bch_sb(struct block_device *bdev)
+{
+ 	struct cache_sb *s;
+	struct buffer_head *bh = __bread(bdev, 1, SB_SIZE);
+	if (!bh)
+		return NULL;
+	s = (struct cache_sb *)bh->b_data;
+
+	/* The page will still be held without this bh.*/
+	put_bh(bh);
+	return s;
+}
+
+static int __write_super(struct cache_sb *sb, struct bio *bio,
+			 struct block_device *bdev)
 {
-	struct cache_sb *out = page_address(bio_first_page_all(bio));
+	struct cache_sb *out;
 	unsigned int i;
 
+	out = locate_bch_sb(bdev);
+	if (!out)
+		goto out_locate;
+
 	bio->bi_iter.bi_sector	= SB_SECTOR;
 	bio->bi_iter.bi_size	= SB_SIZE;
 	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC|REQ_META);
-	bch_bio_map(bio, NULL);
+	bch_bio_map(bio, out);
 
 	out->offset		= cpu_to_le64(sb->offset);
 	out->version		= cpu_to_le64(sb->version);
@@ -240,6 +268,11 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 		 sb->version, sb->flags, sb->seq);
 
 	submit_bio(bio);
+	return 0;
+
+out_locate:
+	pr_err("Couldn't locate super block, __write_super failed");
+	return -1;
 }
 
 static void bch_write_bdev_super_unlock(struct closure *cl)
@@ -263,8 +296,13 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
 	bio->bi_private = dc;
 
 	closure_get(cl);
-	/* I/O request sent to backing device */
-	__write_super(&dc->sb, bio);
+	/* I/O request sent to backing device
+	 * Needs to put the clouser explicitly if __write_super failed,
+	 * because the bio is not submitted and write_bdev_super_endio
+	 * will not have a chance to put the closure.
+	 */
+	if(__write_super(&dc->sb, bio, dc->bdev))
+		closure_put(cl);
 
 	closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
 }
@@ -312,7 +350,13 @@ void bcache_write_super(struct cache_set *c)
 		bio->bi_private = ca;
 
 		closure_get(cl);
-		__write_super(&ca->sb, bio);
+		/* Needs to put the clouser explicitly if __write_super failed,
+		 * because the bio is not submitted and write_super_endio
+		 * will not have a chance to put the closure.
+		 */
+		if(__write_super(&ca->sb, bio, ca->bdev))
+			closure_put(cl);
+
 	}
 
 	closure_return_with_destructor(cl, bcache_write_super_unlock);
-- 
2.17.0
