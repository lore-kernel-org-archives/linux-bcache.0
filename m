From: Coly Li <colyli@suse.de>
Subject: [PATCH v2] bcache: set max writeback rate when I/O request is idle
Date: Tue, 24 Jul 2018 12:03:10 +0800
Message-ID: <20180724040310.1590-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: colyli@suse.de, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org, Michael Lyle <mlyle@lyle.org>, Stefan Priebe <s.priebe@profihost.ag>
List-Id: linux-bcache@vger.kernel.org

Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
allows the writeback rate to be faster if there is no I/O request on a
bcache device. It works well if there is only one bcache device attached
to the cache set. If there are many bcache devices attached to a cache
set, it may introduce performance regression because multiple faster
writeback threads of the idle bcache devices will compete the btree level
locks with the bcache device who have I/O requests coming.

This patch fixes the above issue by only permitting fast writebac when
all bcache devices attached on the cache set are idle. And if one of the
bcache devices has new I/O request coming, minimized all writeback
throughput immediately and let PI controller __update_writeback_rate()
to decide the upcoming writeback rate for each bcache device.

Also when all bcache devices are idle, limited wrieback rate to a small
number is wast of thoughput, especially when backing devices are slower
non-rotation devices (e.g. SATA SSD). This patch sets a max writeback
rate for each backing device if the whole cache set is idle. A faster
writeback rate in idle time means new I/Os may have more available space
for dirty data, and people may observe a better write performance then.

Please note bcache may change its cache mode in run time, and this patch
still works if the cache mode is switched from writeback mode and there
is still dirty data on cache.

Fixes: Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
Cc: stable@vger.kernel.org #4.16+
Signed-off-by: Coly Li <colyli@suse.de>
Tested-by: Kai Krakow <kai@kaishome.de>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Stefan Priebe <s.priebe@profihost.ag>
---
Channgelog:
v2, Fix a deadlock reported by Stefan Priebe.
v1, Initial version.

 drivers/md/bcache/bcache.h    |  11 ++--
 drivers/md/bcache/request.c   |  51 ++++++++++++++-
 drivers/md/bcache/super.c     |   1 +
 drivers/md/bcache/sysfs.c     |  14 +++--
 drivers/md/bcache/util.c      |   2 +-
 drivers/md/bcache/util.h      |   2 +-
 drivers/md/bcache/writeback.c | 115 ++++++++++++++++++++++++++--------
 7 files changed, 155 insertions(+), 41 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index d6bf294f3907..469ab1a955e0 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -328,13 +328,6 @@ struct cached_dev {
 	 */
 	atomic_t		has_dirty;
 
-	/*
-	 * Set to zero by things that touch the backing volume-- except
-	 * writeback.  Incremented by writeback.  Used to determine when to
-	 * accelerate idle writeback.
-	 */
-	atomic_t		backing_idle;
-
 	struct bch_ratelimit	writeback_rate;
 	struct delayed_work	writeback_rate_update;
 
@@ -514,6 +507,8 @@ struct cache_set {
 	struct cache_accounting accounting;
 
 	unsigned long		flags;
+	atomic_t		idle_counter;
+	atomic_t		at_max_writeback_rate;
 
 	struct cache_sb		sb;
 
@@ -523,6 +518,8 @@ struct cache_set {
 
 	struct bcache_device	**devices;
 	unsigned		devices_max_used;
+	/* See set_at_max_writeback_rate() for how it is used */
+	unsigned		previous_dirty_dc_nr;
 	struct list_head	cached_devs;
 	uint64_t		cached_dev_sectors;
 	struct closure		caching;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index ae67f5fa8047..1af3d96abfa5 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,6 +1104,43 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
 
 /* Cached devices - read & write stuff */
 
+static void quit_max_writeback_rate(struct cache_set *c,
+				    struct cached_dev *this_dc)
+{
+	int i;
+	struct bcache_device *d;
+	struct cached_dev *dc;
+
+	/*
+	 * If bch_register_lock is acquired by other attach/detach operations,
+	 * waiting here will increase I/O request latency for seconds or more.
+	 * To avoid such situation, only writeback rate of current cached device
+	 * is set to 1, and __update_write_back() will decide writeback rate
+	 * of other cached devices (remember c->idle_counter is 0 now).
+	 */
+	if (mutex_trylock(&bch_register_lock)){
+		for (i = 0; i < c->devices_max_used; i++) {
+			if (!c->devices[i])
+				continue;
+
+			if (UUID_FLASH_ONLY(&c->uuids[i]))
+				continue;
+
+			d = c->devices[i];
+			dc = container_of(d, struct cached_dev, disk);
+			/*
+			 * set writeback rate to default minimum value,
+			 * then let update_writeback_rate() to decide the
+			 * upcoming rate.
+			 */
+			atomic64_set(&dc->writeback_rate.rate, 1);
+		}
+
+		mutex_unlock(&bch_register_lock);
+	} else
+		atomic64_set(&this_dc->writeback_rate.rate, 1);
+}
+
 static blk_qc_t cached_dev_make_request(struct request_queue *q,
 					struct bio *bio)
 {
@@ -1119,7 +1156,19 @@ static blk_qc_t cached_dev_make_request(struct request_queue *q,
 		return BLK_QC_T_NONE;
 	}
 
-	atomic_set(&dc->backing_idle, 0);
+	if (d->c) {
+		atomic_set(&d->c->idle_counter, 0);
+		/*
+		 * If at_max_writeback_rate of cache set is true and new I/O
+		 * comes, quit max writeback rate of all cached devices
+		 * attached to this cache set, and set at_max_writeback_rate
+		 * to false.
+		 */
+		if (unlikely(atomic_read(&d->c->at_max_writeback_rate) == 1)) {
+			atomic_set(&d->c->at_max_writeback_rate, 0);
+			quit_max_writeback_rate(d->c, dc);
+		}
+	}
 	generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
 
 	bio_set_dev(bio, dc->bdev);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fa4058e43202..fa532d9f9353 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1687,6 +1687,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	c->block_bits		= ilog2(sb->block_size);
 	c->nr_uuids		= bucket_bytes(c) / sizeof(struct uuid_entry);
 	c->devices_max_used	= 0;
+	c->previous_dirty_dc_nr	= 0;
 	c->btree_pages		= bucket_pages(c);
 	if (c->btree_pages > BTREE_MAX_PAGES)
 		c->btree_pages = max_t(int, c->btree_pages / 4,
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 225b15aa0340..d719021bff81 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -170,7 +170,8 @@ SHOW(__bch_cached_dev)
 	var_printf(writeback_running,	"%i");
 	var_print(writeback_delay);
 	var_print(writeback_percent);
-	sysfs_hprint(writeback_rate,	dc->writeback_rate.rate << 9);
+	sysfs_hprint(writeback_rate,
+		     atomic64_read(&dc->writeback_rate.rate) << 9);
 	sysfs_hprint(io_errors,		atomic_read(&dc->io_errors));
 	sysfs_printf(io_error_limit,	"%i", dc->error_limit);
 	sysfs_printf(io_disable,	"%i", dc->io_disable);
@@ -188,7 +189,8 @@ SHOW(__bch_cached_dev)
 		char change[20];
 		s64 next_io;
 
-		bch_hprint(rate,	dc->writeback_rate.rate << 9);
+		bch_hprint(rate,
+			   atomic64_read(&dc->writeback_rate.rate) << 9);
 		bch_hprint(dirty,	bcache_dev_sectors_dirty(&dc->disk) << 9);
 		bch_hprint(target,	dc->writeback_rate_target << 9);
 		bch_hprint(proportional,dc->writeback_rate_proportional << 9);
@@ -255,8 +257,12 @@ STORE(__cached_dev)
 
 	sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent, 0, 40);
 
-	sysfs_strtoul_clamp(writeback_rate,
-			    dc->writeback_rate.rate, 1, INT_MAX);
+	if (attr == &sysfs_writeback_rate) {
+		int v;
+
+		sysfs_strtoul_clamp(writeback_rate, v, 1, INT_MAX);
+		atomic64_set(&dc->writeback_rate.rate, v);
+	}
 
 	sysfs_strtoul_clamp(writeback_rate_update_seconds,
 			    dc->writeback_rate_update_seconds,
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index fc479b026d6d..84f90c3d996d 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -200,7 +200,7 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
 {
 	uint64_t now = local_clock();
 
-	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
+	d->next += div_u64(done * NSEC_PER_SEC, atomic64_read(&d->rate));
 
 	/* Bound the time.  Don't let us fall further than 2 seconds behind
 	 * (this prevents unnecessary backlog that would make it impossible
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index cced87f8eb27..7e17f32ab563 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -442,7 +442,7 @@ struct bch_ratelimit {
 	 * Rate at which we want to do work, in units per second
 	 * The units here correspond to the units passed to bch_next_delay()
 	 */
-	uint32_t		rate;
+	atomic64_t		rate;
 };
 
 static inline void bch_ratelimit_reset(struct bch_ratelimit *d)
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index ad45ebe1a74b..11ffadc3cf8f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -49,6 +49,80 @@ static uint64_t __calc_target_rate(struct cached_dev *dc)
 	return (cache_dirty_target * bdev_share) >> WRITEBACK_SHARE_SHIFT;
 }
 
+static bool set_at_max_writeback_rate(struct cache_set *c,
+				      struct cached_dev *dc)
+{
+	int i, dirty_dc_nr = 0;
+	struct bcache_device *d;
+
+	/*
+	 * bch_register_lock is acquired in cached_dev_detach_finish() before
+	 * calling cancel_writeback_rate_update_dwork() to stop the delayed
+	 * kworker writeback_rate_update (where the context we are for now).
+	 * Therefore call mutex_lock() here may introduce deadlock when shut
+	 * down the bcache device.
+	 * c->previous_dirty_dc_nr is used to record previous calculated
+	 * dirty_dc_nr when mutex_trylock() last time succeeded. Then if
+	 * mutex_trylock() failed here, use c->previous_dirty_dc_nr as dirty
+	 * cached device number. Of cause it might be inaccurate, but a few more
+	 * or less loop before setting c->at_max_writeback_rate is much better
+	 * then a deadlock here.
+	 */
+	if (mutex_trylock(&bch_register_lock)) {
+		for (i = 0; i < c->devices_max_used; i++) {
+			if (!c->devices[i])
+				continue;
+			if (UUID_FLASH_ONLY(&c->uuids[i]))
+				continue;
+			d = c->devices[i];
+			dc = container_of(d, struct cached_dev, disk);
+			if (atomic_read(&dc->has_dirty))
+				dirty_dc_nr++;
+		}
+		c->previous_dirty_dc_nr = dirty_dc_nr;
+
+		mutex_unlock(&bch_register_lock);
+	} else
+		dirty_dc_nr = c->previous_dirty_dc_nr;
+
+	/*
+	 * Idle_counter is increased everytime when update_writeback_rate()
+	 * is rescheduled in. If all backing devices attached to the same
+	 * cache set has same dc->writeback_rate_update_seconds value, it
+	 * is about 10 rounds of update_writeback_rate() is called on each
+	 * backing device, then the code will fall through at set 1 to
+	 * c->at_max_writeback_rate, and a max wrteback rate to each
+	 * dc->writeback_rate.rate. This is not very accurate but works well
+	 * to make sure the whole cache set has no new I/O coming before
+	 * writeback rate is set to a max number.
+	 */
+	if (atomic_inc_return(&c->idle_counter) < dirty_dc_nr * 10)
+		return false;
+
+	if (atomic_read(&c->at_max_writeback_rate) != 1)
+		atomic_set(&c->at_max_writeback_rate, 1);
+
+
+	atomic64_set(&dc->writeback_rate.rate, INT_MAX);
+
+	/* keep writeback_rate_target as existing value */
+	dc->writeback_rate_proportional = 0;
+	dc->writeback_rate_integral_scaled = 0;
+	dc->writeback_rate_change = 0;
+
+	/*
+	 * Check c->idle_counter and c->at_max_writeback_rate agagain in case
+	 * new I/O arrives during before set_at_max_writeback_rate() returns.
+	 * Then the writeback rate is set to 1, and its new value should be
+	 * decided via __update_writeback_rate().
+	 */
+	if (atomic_read(&c->idle_counter) < dirty_dc_nr * 10 ||
+	    !atomic_read(&c->at_max_writeback_rate))
+		return false;
+
+	return true;
+}
+
 static void __update_writeback_rate(struct cached_dev *dc)
 {
 	/*
@@ -104,8 +178,9 @@ static void __update_writeback_rate(struct cached_dev *dc)
 
 	dc->writeback_rate_proportional = proportional_scaled;
 	dc->writeback_rate_integral_scaled = integral_scaled;
-	dc->writeback_rate_change = new_rate - dc->writeback_rate.rate;
-	dc->writeback_rate.rate = new_rate;
+	dc->writeback_rate_change = new_rate -
+			atomic64_read(&dc->writeback_rate.rate);
+	atomic64_set(&dc->writeback_rate.rate, new_rate);
 	dc->writeback_rate_target = target;
 }
 
@@ -138,9 +213,16 @@ static void update_writeback_rate(struct work_struct *work)
 
 	down_read(&dc->writeback_lock);
 
-	if (atomic_read(&dc->has_dirty) &&
-	    dc->writeback_percent)
-		__update_writeback_rate(dc);
+	if (atomic_read(&dc->has_dirty) && dc->writeback_percent) {
+		/*
+		 * If the whole cache set is idle, set_at_max_writeback_rate()
+		 * will set writeback rate to a max number. Then it is
+		 * unncessary to update writeback rate for an idle cache set
+		 * in maximum writeback rate number(s).
+		 */
+		if (!set_at_max_writeback_rate(c, dc))
+			__update_writeback_rate(dc);
+	}
 
 	up_read(&dc->writeback_lock);
 
@@ -422,27 +504,6 @@ static void read_dirty(struct cached_dev *dc)
 
 		delay = writeback_delay(dc, size);
 
-		/* If the control system would wait for at least half a
-		 * second, and there's been no reqs hitting the backing disk
-		 * for awhile: use an alternate mode where we have at most
-		 * one contiguous set of writebacks in flight at a time.  If
-		 * someone wants to do IO it will be quick, as it will only
-		 * have to contend with one operation in flight, and we'll
-		 * be round-tripping data to the backing disk as quickly as
-		 * it can accept it.
-		 */
-		if (delay >= HZ / 2) {
-			/* 3 means at least 1.5 seconds, up to 7.5 if we
-			 * have slowed way down.
-			 */
-			if (atomic_inc_return(&dc->backing_idle) >= 3) {
-				/* Wait for current I/Os to finish */
-				closure_sync(&cl);
-				/* And immediately launch a new set. */
-				delay = 0;
-			}
-		}
-
 		while (!kthread_should_stop() &&
 		       !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
 		       delay) {
@@ -715,7 +776,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_running		= true;
 	dc->writeback_percent		= 10;
 	dc->writeback_delay		= 30;
-	dc->writeback_rate.rate		= 1024;
+	atomic64_set(&dc->writeback_rate.rate, 1024);
 	dc->writeback_rate_minimum	= 8;
 
 	dc->writeback_rate_update_seconds = WRITEBACK_RATE_UPDATE_SECS_DEFAULT;
-- 
2.17.1
