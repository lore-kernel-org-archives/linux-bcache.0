Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F308D1FDA92;
	Thu, 22 Jan 2026 06:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769062490; cv=none; b=WRwvmqvR/IWCa3tNCv6+aDd8/3Nk1ArMwxH2weH26mhY7qTz+GS4ilZghpqYEqeyCTN+WPb1oTP6FPNBpqmAKCZ3CCv2El0hXVSbCgpAHZQQus4L3eoXBaJTDRK6tEBpCF27OkfgbTewtCOliKJZKcVpZHcUijoL58EWS3foRrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769062490; c=relaxed/simple;
	bh=Ga0iY3cYs1BYLOdtPD0EAKv4cGiLNcUSm8KeB06Y5yg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BlIiiGJOkWhhva+7KseKDQ0fMAC+hedbJu1OJyAMeFgVT7Uwn5x9Y4zG6omDO3L0EQSaaeTo5WJRE7hfJ8DSXWADnEmkNJtnPR1U77TG14akiERg20bnHx61Ke6kqrPHvy6Vglxe34yggbnLD4oWeC5PPl5PKdLYf9Lb5aN9tAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=e+U9UK09; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="e+U9UK09"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=/n
	Qkm6U8kuMak1NETrehk+xhBvXEAhy7B5xuV8TVcKs=; b=e+U9UK09iSa5PW6jaf
	Op2wcqLZ8/yIeOWMQL0BVFjqjIi+eup/ZQYibjVChTqlH6icEssl+DiPP6bHETlR
	vL6cQnc4/JTsV/ODo6Kblh0/vQWc0dU/OH6Uer6G9FCYqNZvpdzSX7MkQsM2Dkch
	edfOvPf7ZB3sNi2C8WhfUMJ+0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wC3hvAOwHFpcbKwGw--.4488S2;
	Thu, 22 Jan 2026 14:13:35 +0800 (CST)
From: zhangshida2026@163.com
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	axboe@kernel.dk,
	sashal@kernel.org,
	hch@infradead.org
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH RESEND v3] bcache: use bio cloning for detached device requests
Date: Thu, 22 Jan 2026 14:13:21 +0800
Message-Id: <20260122061321.359218-1-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3hvAOwHFpcbKwGw--.4488S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtF4fGFWftFWDGF4rWFykZrb_yoWxuFyUpF
	Z7Wa4jkrW0ga10g3y7Aw4UuryrKrWDta43Xa4xCw4S9ry2yryDKFWUGa45Arn5ArWDuFZr
	AF1vqrWDWF45GaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j__-dUUUUU=
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC6BDq9mlxwBDUbQAA3V

From: Shida Zhang <zhangshida@kylinos.cn>

Previously, bcache hijacked the bi_end_io and bi_private fields of
the incoming bio when the backing device was in a detached state.
This is fragile and breaks if the bio is needed to be processed by
other layers.

This patch transitions to using a cloned bio embedded within a private
structure. This ensures the original bio's metadata remains untouched.

Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
Co-developed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/md/bcache/bcache.h  |  9 +++++
 drivers/md/bcache/request.c | 79 ++++++++++++++++---------------------
 drivers/md/bcache/super.c   | 12 +++++-
 3 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 8ccacba8554..ec9ff971508 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -273,6 +273,8 @@ struct bcache_device {
 
 	struct bio_set		bio_split;
 
+	struct bio_set		bio_detached;
+
 	unsigned int		data_csum:1;
 
 	int (*cache_miss)(struct btree *b, struct search *s,
@@ -753,6 +755,13 @@ struct bbio {
 	struct bio		bio;
 };
 
+struct detached_dev_io_private {
+	struct bcache_device	*d;
+	unsigned long		start_time;
+	struct bio		*orig_bio;
+	struct bio              bio;
+};
+
 #define BTREE_PRIO		USHRT_MAX
 #define INITIAL_PRIO		32768U
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 82fdea7dea7..a02aecac05c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1077,68 +1077,58 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
 	continue_at(cl, cached_dev_bio_complete, NULL);
 }
 
-struct detached_dev_io_private {
-	struct bcache_device	*d;
-	unsigned long		start_time;
-	bio_end_io_t		*bi_end_io;
-	void			*bi_private;
-	struct block_device	*orig_bdev;
-};
-
 static void detached_dev_end_io(struct bio *bio)
 {
-	struct detached_dev_io_private *ddip;
-
-	ddip = bio->bi_private;
-	bio->bi_end_io = ddip->bi_end_io;
-	bio->bi_private = ddip->bi_private;
+	struct detached_dev_io_private *ddip =
+		container_of(bio, struct detached_dev_io_private, bio);
+	struct bio *orig_bio = ddip->orig_bio;
 
 	/* Count on the bcache device */
-	bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
+	bio_end_io_acct(orig_bio, ddip->start_time);
 
 	if (bio->bi_status) {
-		struct cached_dev *dc = container_of(ddip->d,
-						     struct cached_dev, disk);
+		struct cached_dev *dc = bio->bi_private;
+
 		/* should count I/O error for backing device here */
 		bch_count_backing_io_errors(dc, bio);
+		orig_bio->bi_status = bio->bi_status;
 	}
 
-	kfree(ddip);
-	bio_endio(bio);
+	bio_put(bio);
+	bio_endio(orig_bio);
 }
 
-static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
-		struct block_device *orig_bdev, unsigned long start_time)
+static void detached_dev_do_request(struct bcache_device *d,
+		struct bio *orig_bio, unsigned long start_time)
 {
 	struct detached_dev_io_private *ddip;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	struct bio *clone_bio;
 
-	/*
-	 * no need to call closure_get(&dc->disk.cl),
-	 * because upper layer had already opened bcache device,
-	 * which would call closure_get(&dc->disk.cl)
-	 */
-	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
-	if (!ddip) {
-		bio->bi_status = BLK_STS_RESOURCE;
-		bio_endio(bio);
+	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
+	    !bdev_max_discard_sectors(dc->bdev)) {
+		bio_endio(orig_bio);
 		return;
 	}
 
-	ddip->d = d;
+	clone_bio = bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
+				    &d->bio_detached);
+	if (!clone_bio) {
+		orig_bio->bi_status = BLK_STS_RESOURCE;
+		bio_endio(orig_bio);
+		return;
+	}
+
+	ddip = container_of(clone_bio, struct detached_dev_io_private, bio);
 	/* Count on the bcache device */
-	ddip->orig_bdev = orig_bdev;
+	ddip->d = d;
 	ddip->start_time = start_time;
-	ddip->bi_end_io = bio->bi_end_io;
-	ddip->bi_private = bio->bi_private;
-	bio->bi_end_io = detached_dev_end_io;
-	bio->bi_private = ddip;
-
-	if ((bio_op(bio) == REQ_OP_DISCARD) &&
-	    !bdev_max_discard_sectors(dc->bdev))
-		detached_dev_end_io(bio);
-	else
-		submit_bio_noacct(bio);
+	ddip->orig_bio = orig_bio;
+
+	clone_bio->bi_end_io = detached_dev_end_io;
+	clone_bio->bi_private = dc;
+
+	submit_bio_noacct(clone_bio);
 }
 
 static void quit_max_writeback_rate(struct cache_set *c,
@@ -1214,10 +1204,10 @@ void cached_dev_submit_bio(struct bio *bio)
 
 	start_time = bio_start_io_acct(bio);
 
-	bio_set_dev(bio, dc->bdev);
 	bio->bi_iter.bi_sector += dc->sb.data_offset;
 
 	if (cached_dev_get(dc)) {
+		bio_set_dev(bio, dc->bdev);
 		s = search_alloc(bio, d, orig_bdev, start_time);
 		trace_bcache_request_start(s->d, bio);
 
@@ -1237,9 +1227,10 @@ void cached_dev_submit_bio(struct bio *bio)
 			else
 				cached_dev_read(dc, s);
 		}
-	} else
+	} else {
 		/* I/O request sent to backing device */
-		detached_dev_do_request(d, bio, orig_bdev, start_time);
+		detached_dev_do_request(d, bio, start_time);
+	}
 }
 
 static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c17d4517af2..238d12ffdae 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -887,6 +887,7 @@ static void bcache_device_free(struct bcache_device *d)
 	}
 
 	bioset_exit(&d->bio_split);
+	bioset_exit(&d->bio_detached);
 	kvfree(d->full_dirty_stripes);
 	kvfree(d->stripe_sectors_dirty);
 
@@ -949,6 +950,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
 		goto out_ida_remove;
 
+	if (bioset_init(&d->bio_detached, 4,
+			offsetof(struct detached_dev_io_private, bio),
+			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
+		goto out_bioset_split_exit;
+
 	if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
 		/*
 		 * This should only happen with BCACHE_SB_VERSION_BDEV.
@@ -964,7 +970,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 
 	d->disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(d->disk))
-		goto out_bioset_exit;
+		goto out_bioset_detach_exit;
 
 	set_capacity(d->disk, sectors);
 	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
@@ -976,7 +982,9 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	d->disk->private_data	= d;
 	return 0;
 
-out_bioset_exit:
+out_bioset_detach_exit:
+	bioset_exit(&d->bio_detached);
+out_bioset_split_exit:
 	bioset_exit(&d->bio_split);
 out_ida_remove:
 	ida_free(&bcache_device_idx, idx);
-- 
2.34.1

