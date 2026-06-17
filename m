Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5940940BCA4
	for <linux-bcache@vger.kernel.org>; Wed, 17 Jun 2026 10:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781692473; cv=none; b=jmZWz7F52m7+6OYoq0fasEWvJLNuggk2Zzy+Z70kdP1HcQzhsy8jyiGByNTmlP3dbyGNgG6Wmq0MY1sRBddiD6Uv6q3Q3nayvtPvV5+UvYJlhDyM/A/SzCU9JJ5MxwTpzsImd7Ay2gQxiD1Q+1U7B3fpaKRw0wmfbn7h8+D2lqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781692473; c=relaxed/simple;
	bh=abd+lNE1V6uWgy5R/5VRSBHOCB9WGcDNDm0DVwgvmkQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hHREwm0tJPIC2Ihpktn26suudBxT3y9zFYwSZ2oez98v32CIN7tR8YBJIKDYtaUYEGGQ+ke6+yrQeY85EJGiAffzVgrFcYsJKTGD9VJzGkmJoL8KCMsjyOtOeDn1nh5SWrusZx6dF8P9Iz4v3vf8IdlBm/R7GJOn5+OX7yzL3DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M+2JFSAx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ankitkap.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M+2JFSAx"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8620ee0971so5727252a12.0
        for <linux-bcache@vger.kernel.org>; Wed, 17 Jun 2026 03:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781692468; x=1782297268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya7Fy8x4kork9xGGOgP/9E4FHC1s2a7QAOwrpxwAMRY=;
        b=M+2JFSAx7P8dppOMguO6AhPJnA9s6ZNYJI7Ix+rqHZfaeFA9Ai0gd5yRaGZFpmhyTD
         Z6t6xJxaI56fD7qLkW9dSTNgSud7ruuCkXeVHnu3I9ILdKYyBIYqgsEAAyhQMzKr5IIm
         5z1mVbGv1FxsJPTfsdn4AM+hv20oCVjJRDXpqVyqqOZhkN0MMzzOtGp8PscNSQRlv32x
         u28M6KoutsxWumj7Kyi+fiZxuAf+s3JG+IYHIoSsc3iGE3deazkYvQROzfuAEieqiRGd
         kwfqh0AWAoLCTJmCqE5saDP0VZ3xeFnliuT6aBZjWrI/VocRmEk970iOhIH98Tt63zqA
         SB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781692468; x=1782297268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya7Fy8x4kork9xGGOgP/9E4FHC1s2a7QAOwrpxwAMRY=;
        b=abj9Jp8ETd+JiqtPMn+JGcaI4gbvxk1c54vklH8hnvdkY2Nyr2cmDc0F3IhaqCmy3d
         pxjWl3s6QeK5B1IiyVxU+88U7V3chXrbNzFmq5B4dPZDT00PKCThPzlNVCzVDEKV7tav
         f8vfMKCyOEp4WDQZrhNeyHWqKu2szznC6mP5rwoqfJnoQCM0lV/MkqYg1l7RruWls1GV
         oCnRh+jH/FYMZxAm1hJgXMv+zOcM5xo2476QZeIFtrzEpPigsfCI+Hm9tfd6NGWEIfL5
         p7Qzz0lBs/KxqHqgIgRu12tr9XleF5bXoIbXV3TPjDTG5L0J24f3AklhTJVorBsw7b/a
         dDaA==
X-Gm-Message-State: AOJu0Yyvw8dJHM10wsJaphM9dXVjYTrue54U0b+S/UlPbAb6JQpXgle4
	/HVTdHfP0/k+FXiQuuLoPeOqgil0QxZu6vKbEx0rsYThLvBaQGoRdHNel7v7OQrLEgctUn5J3xu
	S+B0iGbaruNJ44w/7c6eKr8X6YEdZwccoREAxIwCo4wsxFCI+uCSuEtNcDpx49L0hbBkjC67zIj
	8/VgsOZq+d9fXOn/ZP6Fmlxty7blb1RKIibDpzISFEboraqHItQGh3bZk=
X-Received: from pgli27.prod.google.com ([2002:a63:131b:0:b0:c80:1ab9:b111])
 (user=ankitkap job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:9154:b0:3b4:85db:1bdb with SMTP id adf61e73a8af0-3b8b7ff267emr3511817637.44.1781692467160;
 Wed, 17 Jun 2026 03:34:27 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:33:56 +0000
In-Reply-To: <20260617103356.3287775-1-ankitkap@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260617103356.3287775-1-ankitkap@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617103356.3287775-2-ankitkap@google.com>
Subject: [PATCH v2 1/1] bcache: track active bypass writes to prevent stale
 cache reads
From: Ankit Kapoor <ankitkap@google.com>
To: linux-bcache@vger.kernel.org
Cc: colyli@fygo.io, kent.overstreet@linux.dev, linux-kernel@vger.kernel.org, 
	Ankit Kapoor <ankitkap@google.com>
Content-Type: text/plain; charset="UTF-8"

A race condition exists between a read cache miss and a bypass write
due to either congestion or sequential bypass, that causes stale data
to be cached when the read cache miss runs concurrently with a bypass
write targeting the same sectors. If the read cache miss fetches data
from the backing device before the write to the backing device, stale
data populates the cache.

The root cause is that bcache currently executes btree key
invalidation in parallel with (or prior to) writing the actual data
payload to the backing device. Under this sequence, a concurrent read
path can register a cache miss and insert a placeholder key. If the
write's btree key invalidation completes before the read finishes
fetching old data from the backing device, the read's subsequent key
replacement will not detect a collision, allowing stale data to
persist in the cache.

Fix this by tracking active bypass writes. We divide the backing
device space into 32MB chunks and track concurrent bypass writes
using refcounts. The tracking counters are stored in dynamically
allocated pages, minimizing memory overhead (a single 4KB page
supports 64GB of disk space). Synchronization is handled via
page-level spinlocks rather than a single global lock, ensuring
minimal contention across different regions of the disk.

On a cache miss read, bcache checks if there are any active bypass
writes overlapping the target sectors. If an active bypass write is
detected, the read is forced to bypass the cache to ensure data
consistency.

If the system fails to allocate a tracking page due to memory
pressure, the bypass write proceeds untracked. To provide
observability into this fallback, we print a rate-limited dmesg
warning and track the allocation failures using a new
`bypass_tracking_alloc_fails` sysfs counter.

Additionally, add a `cache_read_bypass_races` sysfs counter and a
corresponding tracepoint to monitor these occurrences.

Signed-off-by: Ankit Kapoor <ankitkap@google.com>
Suggested-by: Coly Li <colyli@fygo.io>
---

v2:
- Addressed feedback from Coly Li regarding SSD power failures.
- Implemented bypass write monitoring to force concurrent reads 
  to the bypass path.
- Referenced md RAID bitmap implementation for the architectural
  approach as per Coly Li's suggestion

 Documentation/admin-guide/bcache.rst |   8 ++
 drivers/md/bcache/bcache.h           |  35 +++++++
 drivers/md/bcache/request.c          | 132 +++++++++++++++++++++++++++
 drivers/md/bcache/stats.c            |  14 +++
 drivers/md/bcache/stats.h            |   4 +
 drivers/md/bcache/super.c            |  30 ++++++
 drivers/md/bcache/sysfs.c            |   5 +
 include/trace/events/bcache.h        |   5 +
 8 files changed, 233 insertions(+)

diff --git a/Documentation/admin-guide/bcache.rst b/Documentation/admin-guide/bcache.rst
index 325816edbdab..e08cfa6b0ea0 100644
--- a/Documentation/admin-guide/bcache.rst
+++ b/Documentation/admin-guide/bcache.rst
@@ -507,6 +507,10 @@ cache_miss_collisions
   cache miss, but raced with a write and data was already present (usually 0
   since the synchronization for cache misses was rewritten)
 
+cache_read_bypass_races
+  Counts instances where a cache miss read raced with a concurrent bypass
+  write, forcing the read to bypass the cache to prevent reading stale data.
+
 Sysfs - cache set
 ~~~~~~~~~~~~~~~~~
 
@@ -592,6 +596,10 @@ bset_tree_stats
 btree_cache_max_chain
   Longest chain in the btree node cache's hash table
 
+bypass_tracking_alloc_fails
+  Counts instances where memory allocation for bypass write tracking
+  failed. When this occurs, a bypass write proceeds untracked.
+
 cache_read_races
   Counts instances where while data was being read from the cache, the bucket
   was reused and invalidated - i.e. where the pointer was stale after the read
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ec9ff9715081..8e08503a698b 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -299,6 +299,12 @@ enum stop_on_failure {
 	BCH_CACHED_DEV_STOP_MODE_MAX,
 };
 
+struct bch_bypass_page {
+	u16		*counts;
+	unsigned int	active;
+	spinlock_t	lock;
+};
+
 struct cached_dev {
 	struct list_head	list;
 	struct bcache_device	disk;
@@ -407,8 +413,36 @@ struct cached_dev {
 	 */
 #define BCH_WBRATE_UPDATE_MAX_SKIPS	15
 	unsigned int		rate_update_retry;
+
+	/* For tracking active bypass writes */
+#define BCH_BYPASS_CHUNK_SHIFT		16  /* 2^16 sectors = 32MB */
+#define BCH_BYPASS_PAGE_COUNTERS	(PAGE_SIZE / sizeof(u16))
+#define BCH_BYPASS_PAGE_SHIFT		(PAGE_SHIFT - 1)
+#define BCH_BYPASS_PAGE_MASK		((1UL << BCH_BYPASS_PAGE_SHIFT) - 1)
+	struct bch_bypass_page	*bypass_pages;
+	unsigned long		bypass_num_pages;
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
@@ -714,6 +748,7 @@ struct cache_set {
 	struct time_stats	btree_read_time;
 
 	atomic_long_t		cache_read_races;
+	atomic_long_t		bypass_tracking_alloc_fails;
 	atomic_long_t		writeback_keys_done;
 	atomic_long_t		writeback_keys_failed;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3fa3b13a410f..426665c07394 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -830,6 +830,126 @@ static CLOSURE_CALLBACK(cached_dev_cache_miss_done)
 	closure_put(&d->cl);
 }
 
+static void bch_bypass_write_start(struct cached_dev *dc, sector_t sector, unsigned int sectors)
+{
+	unsigned long start_chunk = sector_to_bypass_chunk(sector);
+	unsigned long end_chunk = sector_to_bypass_chunk(sector + sectors - 1);
+	unsigned long end_pg_idx = bypass_chunk_to_page(end_chunk);
+	unsigned long chunk;
+
+	if (!dc->bypass_pages)
+		return;
+
+	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
+		return;
+
+	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
+		unsigned long pg_idx = bypass_chunk_to_page(chunk);
+		unsigned long pg_off = bypass_chunk_to_offset(chunk);
+		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
+		u16 *new_counts;
+		u16 *dup_counts = NULL;
+
+		spin_lock_irq(&pg->lock);
+		if (!pg->counts) {
+			spin_unlock_irq(&pg->lock);
+			new_counts = kzalloc(PAGE_SIZE, __GFP_NOWARN | GFP_NOIO);
+			spin_lock_irq(&pg->lock);
+			if (!new_counts) {
+				if (!pg->counts) {
+					spin_unlock_irq(&pg->lock);
+					pr_warn_ratelimited("failed to allocate bypass write tracking page, bypass write untracked for sectors %llu-%llu\n",
+							    (uint64_t)bypass_chunk_to_sector(chunk),
+							    (uint64_t)bypass_chunk_to_sector(
+								    chunk + 1) - 1);
+					if (dc->disk.c)
+						atomic_long_inc(
+							&dc->disk.c->bypass_tracking_alloc_fails);
+					continue;
+				}
+			}
+			if (new_counts) {
+				if (pg->counts)
+					dup_counts = new_counts;
+				else
+					pg->counts = new_counts;
+			}
+		}
+		pg->counts[pg_off]++;
+		pg->active++;
+		spin_unlock_irq(&pg->lock);
+
+		kfree(dup_counts);
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
+	if (!dc->bypass_pages)
+		return;
+
+	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
+		return;
+
+	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
+		unsigned long pg_idx = bypass_chunk_to_page(chunk);
+		unsigned long pg_off = bypass_chunk_to_offset(chunk);
+		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
+		u16 *counts = NULL;
+		unsigned long flags;
+
+		spin_lock_irqsave(&pg->lock, flags);
+		if (pg->counts && pg->counts[pg_off] > 0) {
+			pg->counts[pg_off]--;
+			pg->active--;
+			if (!pg->active) {
+				counts = pg->counts;
+				pg->counts = NULL;
+			}
+		}
+		spin_unlock_irqrestore(&pg->lock, flags);
+
+		kfree(counts);
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
+	if (!dc->bypass_pages)
+		return false;
+
+	if (WARN_ON_ONCE(end_pg_idx >= dc->bypass_num_pages))
+		return false;
+
+	for (chunk = start_chunk; chunk <= end_chunk; chunk++) {
+		unsigned long pg_idx = bypass_chunk_to_page(chunk);
+		unsigned long pg_off = bypass_chunk_to_offset(chunk);
+		struct bch_bypass_page *pg = &dc->bypass_pages[pg_idx];
+
+		spin_lock_irq(&pg->lock);
+		if (pg->counts && pg->counts[pg_off] > 0) {
+			has_active = true;
+			spin_unlock_irq(&pg->lock);
+			break;
+		}
+		spin_unlock_irq(&pg->lock);
+	}
+
+	return has_active;
+}
+
 static CLOSURE_CALLBACK(cached_dev_read_done)
 {
 	closure_type(s, struct search, cl);
@@ -899,6 +1019,13 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 
 	s->cache_missed = 1;
 
+	if (bch_has_active_bypass_writes(dc, bio->bi_iter.bi_sector,
+					 min(sectors, bio_sectors(bio)))) {
+		s->iop.bypass = true;
+		trace_bcache_read_bypass_race(bio);
+		bch_mark_cache_read_bypass_race(s->iop.c, s->d);
+	}
+
 	if (s->cache_miss || s->iop.bypass) {
 		miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
 		ret = miss == bio ? MAP_DONE : MAP_CONTINUE;
@@ -974,6 +1101,9 @@ static CLOSURE_CALLBACK(cached_dev_write_complete)
 	closure_type(s, struct search, cl);
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
+	if (s->iop.bypass)
+		bch_bypass_write_end(dc, s->iop.bio->bi_iter.bi_sector, bio_sectors(s->iop.bio));
+
 	up_read_non_owner(&dc->writeback_lock);
 	cached_dev_bio_complete(&cl->work);
 }
@@ -1018,6 +1148,8 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 		s->iop.bio = s->orig_bio;
 		bio_get(s->iop.bio);
 
+		bch_bypass_write_start(dc, bio->bi_iter.bi_sector, bio_sectors(bio));
+
 		if (bio_op(bio) == REQ_OP_DISCARD &&
 		    !bdev_max_discard_sectors(dc->bdev))
 			goto insert_data;
diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
index 0056106495a7..df21452e106a 100644
--- a/drivers/md/bcache/stats.c
+++ b/drivers/md/bcache/stats.c
@@ -47,6 +47,7 @@ read_attribute(cache_bypass_hits);
 read_attribute(cache_bypass_misses);
 read_attribute(cache_hit_ratio);
 read_attribute(cache_miss_collisions);
+read_attribute(cache_read_bypass_races);
 read_attribute(bypassed);
 
 SHOW(bch_stats)
@@ -64,6 +65,7 @@ SHOW(bch_stats)
 			     var(cache_hits) + var(cache_misses)));
 
 	var_print(cache_miss_collisions);
+	var_print(cache_read_bypass_races);
 	sysfs_hprint(bypassed,	var(sectors_bypassed) << 9);
 #undef var
 	return 0;
@@ -85,6 +87,7 @@ static struct attribute *bch_stats_attrs[] = {
 	&sysfs_cache_bypass_misses,
 	&sysfs_cache_hit_ratio,
 	&sysfs_cache_miss_collisions,
+	&sysfs_cache_read_bypass_races,
 	&sysfs_bypassed,
 	NULL
 };
@@ -112,6 +115,7 @@ void bch_cache_accounting_clear(struct cache_accounting *acc)
 	acc->total.cache_bypass_hits = 0;
 	acc->total.cache_bypass_misses = 0;
 	acc->total.cache_miss_collisions = 0;
+	acc->total.cache_read_bypass_races = 0;
 	acc->total.sectors_bypassed = 0;
 }
 
@@ -143,6 +147,7 @@ static void scale_stats(struct cache_stats *stats, unsigned long rescale_at)
 		scale_stat(&stats->cache_bypass_hits);
 		scale_stat(&stats->cache_bypass_misses);
 		scale_stat(&stats->cache_miss_collisions);
+		scale_stat(&stats->cache_read_bypass_races);
 		scale_stat(&stats->sectors_bypassed);
 	}
 }
@@ -165,6 +170,7 @@ static void scale_accounting(struct timer_list *t)
 	move_stat(cache_bypass_hits);
 	move_stat(cache_bypass_misses);
 	move_stat(cache_miss_collisions);
+	move_stat(cache_read_bypass_races);
 	move_stat(sectors_bypassed);
 
 	scale_stats(&acc->total, 0);
@@ -212,6 +218,14 @@ void bch_mark_cache_miss_collision(struct cache_set *c, struct bcache_device *d)
 	atomic_inc(&c->accounting.collector.cache_miss_collisions);
 }
 
+void bch_mark_cache_read_bypass_race(struct cache_set *c, struct bcache_device *d)
+{
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+
+	atomic_inc(&dc->accounting.collector.cache_read_bypass_races);
+	atomic_inc(&c->accounting.collector.cache_read_bypass_races);
+}
+
 void bch_mark_sectors_bypassed(struct cache_set *c, struct cached_dev *dc,
 			       int sectors)
 {
diff --git a/drivers/md/bcache/stats.h b/drivers/md/bcache/stats.h
index 21b445f8af15..97d25e0d177c 100644
--- a/drivers/md/bcache/stats.h
+++ b/drivers/md/bcache/stats.h
@@ -8,6 +8,7 @@ struct cache_stat_collector {
 	atomic_t cache_bypass_hits;
 	atomic_t cache_bypass_misses;
 	atomic_t cache_miss_collisions;
+	atomic_t cache_read_bypass_races;
 	atomic_t sectors_bypassed;
 };
 
@@ -19,6 +20,7 @@ struct cache_stats {
 	unsigned long cache_bypass_hits;
 	unsigned long cache_bypass_misses;
 	unsigned long cache_miss_collisions;
+	unsigned long cache_read_bypass_races;
 	unsigned long sectors_bypassed;
 
 	unsigned int		rescale;
@@ -55,6 +57,8 @@ void bch_mark_cache_accounting(struct cache_set *c, struct bcache_device *d,
 			       bool hit, bool bypass);
 void bch_mark_cache_miss_collision(struct cache_set *c,
 				   struct bcache_device *d);
+void bch_mark_cache_read_bypass_race(struct cache_set *c,
+				     struct bcache_device *d);
 void bch_mark_sectors_bypassed(struct cache_set *c,
 			       struct cached_dev *dc,
 			       int sectors);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 97d9adb0bf96..dc584da349d9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1346,6 +1346,13 @@ void bch_cached_dev_release(struct kobject *kobj)
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
+	if (dc->bypass_pages) {
+		unsigned long i;
+
+		for (i = 0; i < dc->bypass_num_pages; i++)
+			kfree(dc->bypass_pages[i].counts);
+		kfree(dc->bypass_pages);
+	}
 	kfree(dc);
 	module_put(THIS_MODULE);
 }
@@ -1407,6 +1414,25 @@ static CLOSURE_CALLBACK(cached_dev_flush)
 	continue_at(cl, cached_dev_free, system_percpu_wq);
 }
 
+static int bch_cached_dev_bypass_init(struct cached_dev *dc, sector_t sectors)
+{
+	unsigned long chunks = (sectors + (1UL << BCH_BYPASS_CHUNK_SHIFT) - 1) >>
+			       BCH_BYPASS_CHUNK_SHIFT;
+	unsigned long i;
+
+	dc->bypass_num_pages = DIV_ROUND_UP(chunks, BCH_BYPASS_PAGE_COUNTERS);
+	dc->bypass_pages = kcalloc(dc->bypass_num_pages,
+				   sizeof(struct bch_bypass_page),
+				   GFP_KERNEL);
+	if (!dc->bypass_pages)
+		return -ENOMEM;
+
+	for (i = 0; i < dc->bypass_num_pages; i++)
+		spin_lock_init(&dc->bypass_pages[i].lock);
+
+	return 0;
+}
+
 static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 {
 	int ret;
@@ -1447,6 +1473,10 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 	/* default to auto */
 	dc->stop_when_cache_set_failed = BCH_CACHED_DEV_STOP_AUTO;
 
+	ret = bch_cached_dev_bypass_init(dc, bdev_nr_sectors(dc->bdev));
+	if (ret)
+		return ret;
+
 	bch_cached_dev_request_init(dc);
 	bch_cached_dev_writeback_init(dc);
 	return 0;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index cfac56caa804..26b17edd5576 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -95,6 +95,7 @@ read_attribute(feature_incompat);
 
 read_attribute(state);
 read_attribute(cache_read_races);
+read_attribute(bypass_tracking_alloc_fails);
 read_attribute(reclaim);
 read_attribute(reclaimed_journal_buckets);
 read_attribute(flush_write);
@@ -748,6 +749,9 @@ SHOW(__bch_cache_set)
 	sysfs_print(cache_read_races,
 		    atomic_long_read(&c->cache_read_races));
 
+	sysfs_print(bypass_tracking_alloc_fails,
+		    atomic_long_read(&c->bypass_tracking_alloc_fails));
+
 	sysfs_print(reclaim,
 		    atomic_long_read(&c->reclaim));
 
@@ -993,6 +997,7 @@ static struct attribute *bch_cache_set_internal_attrs[] = {
 
 	&sysfs_bset_tree_stats,
 	&sysfs_cache_read_races,
+	&sysfs_bypass_tracking_alloc_fails,
 	&sysfs_reclaim,
 	&sysfs_reclaimed_journal_buckets,
 	&sysfs_flush_write,
diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
index 899fdacf57b9..b76bca0c5285 100644
--- a/include/trace/events/bcache.h
+++ b/include/trace/events/bcache.h
@@ -120,6 +120,11 @@ DEFINE_EVENT(bcache_bio, bcache_bypass_congested,
 	TP_ARGS(bio)
 );
 
+DEFINE_EVENT(bcache_bio, bcache_read_bypass_race,
+	TP_PROTO(struct bio *bio),
+	TP_ARGS(bio)
+);
+
 TRACE_EVENT(bcache_read,
 	TP_PROTO(struct bio *bio, bool hit, bool bypass),
 	TP_ARGS(bio, hit, bypass),
-- 
2.54.0.1136.gdb2ca164c4-goog

