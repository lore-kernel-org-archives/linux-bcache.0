From: Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PULL] bcache updates based on git.kernel.dk/linux-block:for-next
Date: Tue, 18 Jul 2017 19:31:35 +0100
Message-ID: <d490f93b-b43a-cb08-cf2e-304b3dbf1d96@ehuk.net>
References: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
 <23b4ace1-60b7-1ce6-23d7-29433ec8582c@ehuk.net>
 <7040453d-2272-d376-710b-6ed07527a98e@coly.li>
 <d94db8ff-ff2c-0c3c-5638-97cd3c769c1c@ehuk.net>
 <OF92BA0158.87BDF9E3-ON4825815E.000736BF-4825815E.000833F7@zte.com.cn>
 <f09f9db6-c8ec-3e38-84af-40195b0fc13b@ehuk.net>
Reply-To: Eddie Chapman <eddie@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from schatzi.steelbluetech.co.uk ([92.63.139.240]:12704 "EHLO
        schatzi.steelbluetech.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751379AbdGRSbh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Jul 2017 14:31:37 -0400
In-Reply-To: <f09f9db6-c8ec-3e38-84af-40195b0fc13b@ehuk.net>
Content-Language: en-GB
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <i@coly.li>, linux-bcache@vger.kernel.org, stable@vger.kernel.org

As per previous mail, below are the 4 patches discussed, generated with 
diff -up, from kernel.org 4.4.77, so with correct context for 4.4. Just 
in case they are useful for anyone.

---
From: Tang Junhui <tang.junhui@zte.com.cn>

Sequential write IOs were tested with bs=1M by FIO in writeback cache
mode, these IOs were expected to be bypassed, but actually they did not.
We debug the code, and find in check_should_bypass():
    if (!congested &&
        mode == CACHE_MODE_WRITEBACK &&
        op_is_write(bio_op(bio)) &&
        (bio-＞bi_opf & REQ_SYNC))
        goto rescale
that means, If in writeback mode, a write IO with REQ_SYNC flag will not
be bypassed though it is a sequential large IO, It's not a correct thing
to do actually, so this patch remove these codes.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: stable@vger.kernel.org
---

--- a/drivers/md/bcache/request.c	2017-07-18 18:09:38.686156583 +0100
+++ b/drivers/md/bcache/request.c	2017-07-18 18:09:44.596167542 +0100
@@ -400,12 +400,6 @@ static bool check_should_bypass(struct c
 	if (!congested && !dc->sequential_cutoff)
 		goto rescale;
 
-	if (!congested &&
-	    mode == CACHE_MODE_WRITEBACK &&
-	    (bio->bi_rw & REQ_WRITE) &&
-	    (bio->bi_rw & REQ_SYNC))
-		goto rescale;
-
 	spin_lock(&dc->io_lock);
 
 	hlist_for_each_entry(i, iohash(dc, bio->bi_iter.bi_sector), hash)


From: Tang Junhui <tang.junhui@zte.com.cn>

Since bypassed IOs use no bucket, so do not subtract sectors_to_gc to
trigger gc thread.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: stable@vger.kernel.org
---

--- a/drivers/md/bcache/request.c	2017-07-18 18:18:43.937169337 +0100
+++ b/drivers/md/bcache/request.c	2017-07-18 18:21:45.637507148 +0100
@@ -196,12 +196,12 @@ static void bch_data_insert_start(struct
 	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
 	struct bio *bio = op->bio, *n;
 
-	if (atomic_sub_return(bio_sectors(bio), &op->c->sectors_to_gc) < 0)
-		wake_up_gc(op->c);
-
 	if (op->bypass)
 		return bch_data_invalidate(cl);
 
+	if (atomic_sub_return(bio_sectors(bio), &op->c->sectors_to_gc) < 0)
+		wake_up_gc(op->c);
+
 	/*
 	 * Journal writes are marked REQ_FLUSH; if the original write was a
 	 * flush, it'll wait on the journal write.


From: Tang Junhui <tang.junhui@zte.com.cn>

Thin flash device does not initialize stripe_sectors_dirty correctly, this
patch fixes this issue.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Cc: stable@vger.kernel.org
---

--- a/drivers/md/bcache/super.c	2017-07-18 18:31:38.968611871 +0100
+++ b/drivers/md/bcache/super.c	2017-07-18 18:32:36.078718382 +0100
@@ -1023,7 +1023,7 @@ int bch_cached_dev_attach(struct cached_
 	}
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
-		bch_sectors_dirty_init(dc);
+		bch_sectors_dirty_init(&dc->disk);
 		atomic_set(&dc->has_dirty, 1);
 		atomic_inc(&dc->count);
 		bch_writeback_queue(dc);
@@ -1227,6 +1227,7 @@ static int flash_dev_run(struct cache_se
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
+	bch_sectors_dirty_init(d);
 	bch_flash_dev_request_init(d);
 	add_disk(d->disk);
 
--- a/drivers/md/bcache/writeback.c	2017-07-18 18:31:50.718633782 +0100
+++ b/drivers/md/bcache/writeback.c	2017-07-18 18:32:36.078718382 +0100
@@ -488,17 +488,17 @@ static int sectors_dirty_init_fn(struct
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
--- a/drivers/md/bcache/writeback.h	2017-07-18 18:32:00.588652189 +0100
+++ b/drivers/md/bcache/writeback.h	2017-07-18 18:32:36.078718382 +0100
@@ -85,7 +85,7 @@ static inline void bch_writeback_add(str
 
 void bcache_dev_sectors_dirty_add(struct cache_set *, unsigned, uint64_t, int);
 
-void bch_sectors_dirty_init(struct cached_dev *dc);
+void bch_sectors_dirty_init(struct bcache_device *);
 void bch_cached_dev_writeback_init(struct cached_dev *);
 int bch_cached_dev_writeback_start(struct cached_dev *);


From: Tang Junhui <tang.junhui@zte.com.cn>

Since dirty sectors of thin flash cannot be used to cache data for backend
device, so we should subtract it in calculating writeback rate.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Cc: stable@vger.kernel.org
---

--- a/drivers/md/bcache/writeback.c	2017-07-18 18:38:46.929410077 +0100
+++ b/drivers/md/bcache/writeback.c	2017-07-18 18:39:00.979436233 +0100
@@ -21,7 +21,7 @@
 static void __update_writeback_rate(struct cached_dev *dc)
 {
 	struct cache_set *c = dc->disk.c;
-	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size;
+	uint64_t cache_sectors = c->nbuckets * c->sb.bucket_size - bcache_flash_devs_sectors_dirty(c);
 	uint64_t cache_dirty_target =
 		div_u64(cache_sectors * dc->writeback_percent, 100);
 
--- a/drivers/md/bcache/writeback.h	2017-07-18 18:38:50.489416705 +0100
+++ b/drivers/md/bcache/writeback.h	2017-07-18 18:39:00.979436233 +0100
@@ -14,6 +14,25 @@ static inline uint64_t bcache_dev_sector
 	return ret;
 }
 
+static inline uint64_t  bcache_flash_devs_sectors_dirty(struct cache_set *c)
+{
+	uint64_t i, ret = 0;
+
+	mutex_lock(&bch_register_lock);
+
+	for (i = 0; i < c->nr_uuids; i++) {
+		struct bcache_device *d = c->devices[i];
+
+		if (!d || !UUID_FLASH_ONLY(&c->uuids[i]))
+			continue;
+	   ret += bcache_dev_sectors_dirty(d);
+	}
+
+	mutex_unlock(&bch_register_lock);
+
+	return ret;
+}
+
 static inline unsigned offset_to_stripe(struct bcache_device *d,
 					uint64_t offset)
 {
