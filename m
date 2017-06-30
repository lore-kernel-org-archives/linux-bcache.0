From: bcache@lists.ewheeler.net
Subject: [PATCH 10/19] bcache: initialize stripe_sectors_dirty correctly for thin flash device
Date: Fri, 30 Jun 2017 13:42:59 -0700
Message-ID: <1498855388-16990-10-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: stable-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Thin flash device does not initialize stripe_sectors_dirty correctly, this
patch fixes this issue.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/super.c     | 3 ++-
 drivers/md/bcache/writeback.c | 8 ++++----
 drivers/md/bcache/writeback.h | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1f84791..e06641e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1030,7 +1030,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	}
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
-		bch_sectors_dirty_init(dc);
+		bch_sectors_dirty_init(&dc->disk);
 		atomic_set(&dc->has_dirty, 1);
 		atomic_inc(&dc->count);
 		bch_writeback_queue(dc);
@@ -1232,6 +1232,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
+	bch_sectors_dirty_init(d);
 	bch_flash_dev_request_init(d);
 	add_disk(d->disk);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3d463f0..4ac8b13 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -482,17 +482,17 @@ static int sectors_dirty_init_fn(struct btree_op *_op, struct btree *b,
 	return MAP_CONTINUE;
 }
 
-void bch_sectors_dirty_init(struct cached_dev *dc)
+void bch_sectors_dirty_init(struct bcache_device *d)
 {
 	struct sectors_dirty_init op;
 
 	bch_btree_op_init(&op.op, -1);
-	op.inode = dc->disk.id;
+	op.inode = d->id;
 
-	bch_btree_map_keys(&op.op, dc->disk.c, &KEY(op.inode, 0, 0),
+	bch_btree_map_keys(&op.op, d->c, &KEY(op.inode, 0, 0),
 			   sectors_dirty_init_fn, 0);
 
-	dc->disk.sectors_dirty_last = bcache_dev_sectors_dirty(&dc->disk);
+	d->sectors_dirty_last = bcache_dev_sectors_dirty(d);
 }
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index ea2f92e..c2ab4b4 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -109,7 +109,7 @@ static inline void bch_writeback_add(struct cached_dev *dc)
 
 void bcache_dev_sectors_dirty_add(struct cache_set *, unsigned, uint64_t, int);
 
-void bch_sectors_dirty_init(struct cached_dev *dc);
+void bch_sectors_dirty_init(struct bcache_device *);
 void bch_cached_dev_writeback_init(struct cached_dev *);
 int bch_cached_dev_writeback_start(struct cached_dev *);
 
-- 
1.8.3.1
