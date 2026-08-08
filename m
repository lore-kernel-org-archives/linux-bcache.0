Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199401EE7C6
	for <linux-bcache@vger.kernel.org>; Sat,  8 Aug 2026 04:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786161978; cv=none; b=eLKjK0yHSrrQgU8U76szRXSSfmQ2a1olY2u1ebWKpA1EP7rYIeuCiA8zdnguxondgbBomFr/H9Zb7J5uvcQ/12fAWxPZ+KI+19PFPf0vhh1+zA5h4RtfGHUDOzERKQqecpQCKCmlZyzOh0YF8zN15Z21jpZ37KUfy6SwnR5Wzb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786161978; c=relaxed/simple;
	bh=AiP5lQkQvr65OeITf1ZDc4QYsn+VgdaKtX4H6Wh88KQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HkoKMmL7BrV/oSB/fofcnShqc23oXNtjqvMt4OrMpxfpuOrnqx3DJ/xzl+P20tBMErmLlKgISao15LnqMXtPdhK0xD4Hp5TZJ4rrRWVM1OORjmo/zS9Gl8nU25eWAFrcVh3AKab665U3RlXZ6+07m6OoTBG2AvcB3V99UEuduHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EVrV2DPc; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EVrV2DPc"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so109796a12.1
        for <linux-bcache@vger.kernel.org>; Fri, 07 Aug 2026 21:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786161976; x=1786766776; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mGzS19pS03FkctEDmT6U8dvEyRhKg7nZqwMJ4coRBkk=;
        b=EVrV2DPcNJ+2cMfTKXx1rZ0bzb8AKcggxJuCek10rM/x1ddMjsjRlbPcPIFY+Abs9t
         JKb2IkikP+kejVhsxO3b+Mt21C4zjSwF13C7jf856k16PImwgsrAxFlMXRLFDlA5xo9N
         wMEfwtOMeERRtH8XYfR9gsAWJX38g1qVpfznTCucdm3JOxR/CKYRUtiF2CScKPKOX/qa
         XIXA1W7VuaJPl542D82ynDz2Ovz7joHsexENImze6Gu9FqEJWJoH9GSadmMzkZ0PPDCo
         r9QgytIrIS3cGV7uf7g8wLQWT/+FzEeykKrsQJymLt1mclPS5KXk0os2HGS5ZoLEc4ZV
         66uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786161976; x=1786766776;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mGzS19pS03FkctEDmT6U8dvEyRhKg7nZqwMJ4coRBkk=;
        b=GHUkwlYZpVuqDIzZQxaxHVX85olynn3JM/LhzHbD2taj9nGyLakkQa9l8QMlcGDcGb
         D7cEPKcC8VbmsjYRPEkvmX6fH9Dj0m8n+X44Cqo7t0jsVXZvYeQMGguDorTlQAxrQ+Js
         MiYju7M6phsjH3+KNXon+MPUF+8ds50wMZSZcAZ1WHjxXbkA4LTaziySnBC3jbIn7fq8
         C8Nz+kQ5oHOQk5C+oP2PBCd6sOt67GLjXPfR+440FmRWkt933s5OdHIIsjYhKuD/Yo8g
         R2tS/CFAajr3+aARSkL+HuD1dAp8m9okJqepEbOV7QSoSaIEyZqHuEg3EaeqWLWMSu9t
         luuA==
X-Forwarded-Encrypted: i=1; AHgh+RqHw3K7VNW5ZhLaxKpUUNmA5aaCUUtJBspm9FvecY8amMfWqjuvoQY4OtG1OktKwXCnAipofYs5eC8E06A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYxuAWsPBJdCuM/bJl7AMdpzXBLscNF8RznC2S1rGQNyYEjMYV
	hOCfNsAH7v6sk3/FjQURaMclfheSDrnCMxdTwrS0o2qz0Q+/EVa1ccIDA4Gsmu7RezmmTM0Bo7A
	S3CN7erERLqwK2g==
X-Received: from pgct6.prod.google.com ([2002:a05:6a02:5286:b0:c85:98b1:c613])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:b91:b0:3bf:8de9:c647 with SMTP id adf61e73a8af0-3cb85ba8da6mr34695235637.0.1786161976140;
 Fri, 07 Aug 2026 21:06:16 -0700 (PDT)
Date: Sat,  8 Aug 2026 04:05:48 +0000
In-Reply-To: <20260808040549.2778125-1-ankitkap@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260808040549.2778125-1-ankitkap@google.com>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260808040549.2778125-2-ankitkap@google.com>
Subject: [PATCH v3 1/2] bcache: track active bypass writes to fix read miss race
From: Ankit Kapoor <ankitkap@google.com>
To: Coly Li <colyli@fygo.io>, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-kernel@vger.kernel.org, 
	Ankit Kapoor <ankitkap@google.com>
Content-Type: text/plain; charset="UTF-8"

A race condition exists between a read cache miss and a bypass write
due to either congestion or sequential bypass, which causes stale data
to be cached when the read cache miss runs concurrently with a bypass
write targeting the same sectors. If the read cache miss fetches data
from the backing device before the write to the backing device finishes,
stale data populates the cache.

The root cause is that bcache currently executes btree key
invalidation in parallel with (or prior to) writing the actual data
payload to the backing device. Under this sequence, a concurrent read
path can register a cache miss and insert a placeholder key. If the
write's btree key invalidation completes before the read finishes
fetching old data from the backing device, the read's subsequent key
replacement will not detect a collision, allowing stale data to
persist in the cache.

Fix this by tracking active bypass writes and serializing cache
invalidation.

First, divide the backing device space into 32MB chunks and track
concurrent bypass writes using refcounts. The tracking counters are
stored in dynamically allocated pages backed by a dedicated mempool
to prevent allocation failures under memory pressure, minimizing overall
footprint (a single 4KB page supports 32GB of disk space using u32
counters).

On a cache miss read, bcache checks if there are any active bypass
writes overlapping the target sectors. If an active bypass write is
detected, the read is forced to bypass the cache to ensure data
consistency.

Second, serialize the btree key invalidation (bch_data_insert) for
bypass writes so that it executes in cached_dev_write_complete(), after
the payload has been written to the backing device. This prevents early
invalidation from opening a window where a concurrent read miss could
fetch and re-cache stale data before the bypass write reaches the disk.

Suggested-by: Coly Li <colyli@fygo.io>
Signed-off-by: Ankit Kapoor <ankitkap@google.com>
---
 drivers/md/bcache/bcache.h  |  35 ++++++++++
 drivers/md/bcache/request.c | 131 +++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/super.c   |  39 +++++++++++
 3 files changed, 202 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff9715081..2e50526a52fc 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -299,6 +299,12 @@ enum stop_on_failure {
 	BCH_CACHED_DEV_STOP_MODE_MAX,
 };
 
+struct bch_bypass_page {
+	u32		*counts;
+	unsigned int	active;
+	spinlock_t	lock;
+};
+
 struct cached_dev {
 	struct list_head	list;
 	struct bcache_device	disk;
@@ -407,8 +413,37 @@ struct cached_dev {
 	 */
 #define BCH_WBRATE_UPDATE_MAX_SKIPS	15
 	unsigned int		rate_update_retry;
+
+	/* For tracking active bypass writes */
+#define BCH_BYPASS_CHUNK_SHIFT		16  /* 2^16 sectors = 32MB */
+#define BCH_BYPASS_PAGE_COUNTERS	(PAGE_SIZE / sizeof(u32))
+#define BCH_BYPASS_PAGE_SHIFT		(PAGE_SHIFT - 2)
+#define BCH_BYPASS_PAGE_MASK		((1UL << BCH_BYPASS_PAGE_SHIFT) - 1)
+	struct bch_bypass_page	*bypass_pages;
+	unsigned long		bypass_num_pages;
+	mempool_t		bypass_mempool;
 };
 
+static inline unsigned long sector_to_bypass_chunk(sector_t sector)
+{
+	return sector >> BCH_BYPASS_CHUNK_SHIFT;
+}
+
+static inline unsigned long bypass_chunk_to_page(unsigned long chunk)
+{
+	return chunk >> BCH_BYPASS_PAGE_SHIFT;
+}
+
+static inline unsigned long bypass_chunk_to_offset(unsigned long chunk)
+{
+	return chunk & BCH_BYPASS_PAGE_MASK;
+}
+
+static inline sector_t bypass_chunk_to_sector(unsigned long chunk)
+{
+	return (sector_t)chunk << BCH_BYPASS_CHUNK_SHIFT;
+}
+
 enum alloc_reserve {
 	RESERVE_BTREE,
 	RESERVE_PRIO,
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3fa3b13a410f..bfd28b68f499 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -492,6 +492,9 @@ struct search {
 	struct block_device	*orig_bdev;
 	unsigned long		start_time;
 
+	sector_t		bypass_sector;
+	unsigned int		bypass_sectors;
+
 	struct btree_op		op;
 	struct data_insert_op	iop;
 };
@@ -763,11 +766,16 @@ static inline struct search *search_alloc(struct bio *bio,
 
 /* Cached devices */
 
+static void bch_bypass_write_end(struct cached_dev *dc, sector_t sector, unsigned int sectors);
+
 static CLOSURE_CALLBACK(cached_dev_bio_complete)
 {
 	closure_type(s, struct search, cl);
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
+	if (s->iop.bypass && op_is_write(bio_op(s->orig_bio)))
+		bch_bypass_write_end(dc, s->bypass_sector, s->bypass_sectors);
+
 	cached_dev_put(dc);
 	search_free(&cl->work);
 }
@@ -830,6 +838,110 @@ static CLOSURE_CALLBACK(cached_dev_cache_miss_done)
 	closure_put(&d->cl);
 }
 
+static void bch_bypass_write_start(struct cached_dev *dc, sector_t sector, unsigned int sectors)
+{
+	unsigned long start_chunk = sector_to_bypass_chunk(sector);
+	unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
+	unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
+	unsigned long chunk;
+
+	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
+		return;
+
+	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
+		unsigned long pg_idx = bypass_chunk_to_page(chunk);
+		unsigned long pg_off = bypass_chunk_to_offset(chunk);
+		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
+		u32 *new_counts;
+		u32 *dup_counts = NULL;
+		unsigned long flags;
+
+		spin_lock_irqsave(&pg->lock, flags);
+		if (!pg->counts) {
+			spin_unlock_irqrestore(&pg->lock, flags);
+			new_counts = mempool_alloc(&dc->bypass_mempool, GFP_NOIO);
+			memset(new_counts, 0, PAGE_SIZE);
+			spin_lock_irqsave(&pg->lock, flags);
+			if (pg->counts)
+				dup_counts = new_counts;
+			else
+				pg->counts = new_counts;
+		}
+		pg->counts[pg_off]++;
+		pg->active++;
+		spin_unlock_irqrestore(&pg->lock, flags);
+
+		if (dup_counts)
+			mempool_free(dup_counts, &dc->bypass_mempool);
+	}
+}
+
+static void bch_bypass_write_end(struct cached_dev *dc, sector_t sector, unsigned int sectors)
+{
+	unsigned long start_chunk = sector_to_bypass_chunk(sector);
+	unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
+	unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
+	unsigned long chunk;
+
+	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
+		return;
+
+	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
+		unsigned long pg_idx = bypass_chunk_to_page(chunk);
+		unsigned long pg_off = bypass_chunk_to_offset(chunk);
+		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
+		u32 *counts = NULL;
+		unsigned long flags;
+
+		spin_lock_irqsave(&pg->lock, flags);
+		if (WARN_ON_ONCE(!pg->counts || !pg->counts[pg_off])) {
+			spin_unlock_irqrestore(&pg->lock, flags);
+			continue;
+		}
+
+		pg->counts[pg_off]--;
+		pg->active--;
+		if (!pg->active) {
+			counts = pg->counts;
+			pg->counts = NULL;
+		}
+		spin_unlock_irqrestore(&pg->lock, flags);
+
+		if (counts)
+			mempool_free(counts, &dc->bypass_mempool);
+	}
+}
+
+static bool bch_has_active_bypass_writes(struct cached_dev *dc, sector_t sector,
+					 unsigned int sectors)
+{
+	unsigned long start_chunk = sector_to_bypass_chunk(sector);
+	unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
+	unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
+	unsigned long chunk;
+	bool has_active = false;
+
+	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
+		return false;
+
+	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
+		unsigned long pg_idx = bypass_chunk_to_page(chunk);
+		unsigned long pg_off = bypass_chunk_to_offset(chunk);
+		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
+		unsigned long flags;
+
+		spin_lock_irqsave(&pg->lock, flags);
+		if (pg->counts && pg->counts[pg_off] > 0) {
+			has_active = true;
+			spin_unlock_irqrestore(&pg->lock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&pg->lock, flags);
+	}
+
+	return has_active;
+}
+
 static CLOSURE_CALLBACK(cached_dev_read_done)
 {
 	closure_type(s, struct search, cl);
@@ -864,7 +976,9 @@ static CLOSURE_CALLBACK(cached_dev_read_done)
 	bio_complete(s);
 
 	if (s->iop.bio &&
-	    !test_bit(CACHE_SET_STOPPING, &s->iop.c->flags)) {
+	    !test_bit(CACHE_SET_STOPPING, &s->iop.c->flags) &&
+	    !bch_has_active_bypass_writes(dc, s->iop.bio->bi_iter.bi_sector,
+					  bio_sectors(s->iop.bio))) {
 		BUG_ON(!s->iop.replace);
 		closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
 	}
@@ -975,7 +1089,13 @@ static CLOSURE_CALLBACK(cached_dev_write_complete)
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
 	up_read_non_owner(&dc->writeback_lock);
-	cached_dev_bio_complete(&cl->work);
+
+	if (s->iop.bypass) {
+		closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
+		continue_at(cl, cached_dev_bio_complete, NULL);
+	} else {
+		cached_dev_bio_complete(&cl->work);
+	}
 }
 
 static void cached_dev_write(struct cached_dev *dc, struct search *s)
@@ -1018,6 +1138,10 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 		s->iop.bio = s->orig_bio;
 		bio_get(s->iop.bio);
 
+		s->bypass_sector = bio->bi_iter.bi_sector;
+		s->bypass_sectors = bio_sectors(bio);
+		bch_bypass_write_start(dc, s->bypass_sector, s->bypass_sectors);
+
 		if (bio_op(bio) == REQ_OP_DISCARD &&
 		    !bdev_max_discard_sectors(dc->bdev))
 			goto insert_data;
@@ -1058,7 +1182,8 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 	}
 
 insert_data:
-	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
+	if (!s->iop.bypass)
+		closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
 	continue_at(cl, cached_dev_write_complete, NULL);
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 97d9adb0bf96..b994483511de 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1346,6 +1346,16 @@ void bch_cached_dev_release(struct kobject *kobj)
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
+	if (dc->bypass_pages) {
+		unsigned long i;
+
+		for (i = 0; i < dc->bypass_num_pages; i++) {
+			if (dc->bypass_pages[i].counts)
+				mempool_free(dc->bypass_pages[i].counts, &dc->bypass_mempool);
+		}
+		kvfree(dc->bypass_pages);
+		mempool_exit(&dc->bypass_mempool);
+	}
 	kfree(dc);
 	module_put(THIS_MODULE);
 }
@@ -1407,6 +1417,31 @@ static CLOSURE_CALLBACK(cached_dev_flush)
 	continue_at(cl, cached_dev_free, system_percpu_wq);
 }
 
+static int bch_cached_dev_bypass_init(struct cached_dev *dc, sector_t sectors)
+{
+	unsigned long chunks =
+		sector_to_bypass_chunk(sectors + (1UL << BCH_BYPASS_CHUNK_SHIFT) - 1);
+	unsigned long i;
+
+	dc->bypass_num_pages = DIV_ROUND_UP(chunks, BCH_BYPASS_PAGE_COUNTERS);
+	dc->bypass_pages = kvcalloc(dc->bypass_num_pages,
+				   sizeof(struct bch_bypass_page),
+				   GFP_KERNEL);
+	if (!dc->bypass_pages)
+		return -ENOMEM;
+
+	for (i = 0; i < dc->bypass_num_pages; i++)
+		spin_lock_init(&dc->bypass_pages[i].lock);
+
+	if (mempool_init_kmalloc_pool(&dc->bypass_mempool, 16, PAGE_SIZE)) {
+		kvfree(dc->bypass_pages);
+		dc->bypass_pages = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 {
 	int ret;
@@ -1447,6 +1482,10 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 	/* default to auto */
 	dc->stop_when_cache_set_failed = BCH_CACHED_DEV_STOP_AUTO;
 
+	ret = bch_cached_dev_bypass_init(dc, bdev_nr_sectors(dc->bdev));
+	if (ret)
+		return ret;
+
 	bch_cached_dev_request_init(dc);
 	bch_cached_dev_writeback_init(dc);
 	return 0;
-- 
2.55.0.679.g6767b8d81c-goog

