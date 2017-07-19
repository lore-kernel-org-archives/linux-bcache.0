From: Coly Li <colyli@suse.de>
Subject: [PATCH 2/2] bcache: implement max_writeback_rate_when_idle option for writeback mode
Date: Wed, 19 Jul 2017 13:36:15 +0800
Message-ID: <20170719053615.99305-3-colyli@suse.de>
References: <20170719053615.99305-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751400AbdGSFgb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Jul 2017 01:36:31 -0400
In-Reply-To: <20170719053615.99305-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: bcache@lists.ewheeler.net, tang.junhui@zte.com.cn, kubuxu@ipfs.io, Coly Li <colyli@suse.de>

For bcache writeback mode, a writeback rate for each cached device is
adjusted dynamically by a PD controller in __update_writeback_rate().

If a bcache device is in idle state (no I/O request for an explicity
while of time), and there is dirty data existing on cache device, the
PD controller will decrease its writeback rate continuously and finally
adjust the writeback rate to 1. It means the writeback throughput of
a cached device is around 1 key per second, this is almost useless.

There are two major disadvantage of the above behavior,
1) The time of idle state is wasted. It could have been used for dirty
   data writeback and garbage collection, which might have had positive
   contribution for throughput and latency of further I/O requests.
2) For large amount of dirty data, cached devices are always actived with
   very low I/O efficiency. If all the dirty data could have been wrote
   back to cached devices in a relative short time, there could have been
   a potential energy saving because no active cached device any more.

max_writeback_rate_when_idle is a cache set option via sysfs interface,
it is implemented to solve the above problems. Here I explain how it works.
1) When max_writeback_rate_when_idle of a cache set is enabled (set to 1),
   and this cache set goes into idle state (no I/O request for an explicity
   while of time), writeback rate of all its cached devices containing
   dirty data will be set to max value (INT_MAX for now). Now dirty data
   can be wrote back to cached device as fast as it can be.
2) If an I/O request comes while max rate writeback is performing,
   writeback rates of all writing back cached device will be set to 1. Then
   writeback I/O won't interfere regular I/O request to bcache device. The
   writeback rate of each cached device will continue to be dynamically
   adjusted by PD controller in __update_writeback_rate(), until next cache
   set I/O idle state comes.

This patch does not change existing PD controller logic, most of its changes
happens in update_writeback_rate(), to set writeback rate to INT_MAX or 1
depending on cache set I/O idle state.

This option can be configured via sysfs file at
/sys/block/<bcache device>/bcache/cache/internal/max_writeback_rate_when_idle
Write integer 1 to enable it, and integer 0 to disable it. It is enabled
as default.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h    |  2 ++
 drivers/md/bcache/super.c     |  1 +
 drivers/md/bcache/sysfs.c     |  6 +++++
 drivers/md/bcache/writeback.c | 51 ++++++++++++++++++++++++++++++++++---------
 4 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ab7e60336edb..8499cd1c6c7f 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -659,6 +659,8 @@ struct cache_set {
 	unsigned		gc_always_rewrite:1;
 	unsigned		shrinker_disabled:1;
 	unsigned		copy_gc_enabled:1;
+	unsigned		max_writeback_rate_when_idle:1;
+	unsigned		request_to_cache_idle:1;
 
 #define BUCKET_HASH_BITS	12
 	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8352fad765f6..e21a1684ca2e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1533,6 +1533,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	c->congested_read_threshold_us	= 2000;
 	c->congested_write_threshold_us	= 20000;
 	c->error_limit	= 8 << IO_ERROR_SHIFT;
+	c->max_writeback_rate_when_idle = 1;
 
 	return c;
 err:
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index f90f13616980..6b1652fe797d 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -106,6 +106,7 @@ rw_attribute(cache_replacement_policy);
 rw_attribute(btree_shrinker_disabled);
 rw_attribute(copy_gc_enabled);
 rw_attribute(size);
+rw_attribute(max_writeback_rate_when_idle);
 
 SHOW(__bch_cached_dev)
 {
@@ -570,6 +571,8 @@ SHOW(__bch_cache_set)
 	sysfs_printf(gc_always_rewrite,		"%i", c->gc_always_rewrite);
 	sysfs_printf(btree_shrinker_disabled,	"%i", c->shrinker_disabled);
 	sysfs_printf(copy_gc_enabled,		"%i", c->copy_gc_enabled);
+	sysfs_printf(max_writeback_rate_when_idle,
+		     "%i", c->max_writeback_rate_when_idle);
 
 	if (attr == &sysfs_bset_tree_stats)
 		return bch_bset_print_stats(c, buf);
@@ -653,6 +656,8 @@ STORE(__bch_cache_set)
 	sysfs_strtoul(gc_always_rewrite,	c->gc_always_rewrite);
 	sysfs_strtoul(btree_shrinker_disabled,	c->shrinker_disabled);
 	sysfs_strtoul(copy_gc_enabled,		c->copy_gc_enabled);
+	sysfs_strtoul(max_writeback_rate_when_idle,
+		      c->max_writeback_rate_when_idle);
 
 	return size;
 }
@@ -728,6 +733,7 @@ static struct attribute *bch_cache_set_internal_files[] = {
 	&sysfs_gc_always_rewrite,
 	&sysfs_btree_shrinker_disabled,
 	&sysfs_copy_gc_enabled,
+	&sysfs_max_writeback_rate_when_idle,
 	NULL
 };
 KTYPE(bch_cache_set_internal);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 13594dd7f564..38dac49b28cb 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -74,22 +74,53 @@ static void update_writeback_rate(struct work_struct *work)
 	struct cached_dev *dc = container_of(to_delayed_work(work),
 					     struct cached_dev,
 					     writeback_rate_update);
+	struct cache_set *c = dc->disk.c;
+	uint64_t duration, now;
+	bool timeout = false, wakeup = false;
 
 	down_read(&dc->writeback_lock);
+	if (!atomic_read(&dc->has_dirty))
+		goto schedule_delay;
+
+	now = local_clock();
+	if (c->last_request_time) {
+		duration = now - c->last_request_time;
+	} else {
+		c->last_request_time = now;
+		duration = 0;
+	}
 
-	if (atomic_read(&dc->has_dirty) &&
-	    dc->writeback_percent) {
-		__update_writeback_rate(dc);
-		/*
-		 * wake up writeback thread to check whether request
-		 * duration is timeout in no_writeback_now(). If yes,
-		 * existing dirty data should be handled.
-		 */
-		bch_writeback_queue(dc);
+	if ((duration/NSEC_PER_MSEC) > BCH_IDLE_DURATION_MSECS)
+		timeout = true;
+
+	if (timeout && c->max_writeback_rate_when_idle) {
+		dc->writeback_rate.rate = INT_MAX;
+		wakeup = true;
+		goto schedule_delay;
 	}
 
-	up_read(&dc->writeback_lock);
+	/*
+	 * New requests break I/O idle status, set writeback rate to 1,
+	 * to make sure requests on cache device have good throughput
+	 * and latency as soon as possible. Then the PD controller in
+	 * __update_writeback_tate() may dynamic set a proper writeback
+	 * rate.
+	 */
+	if (!timeout && c->request_to_cache_idle)
+		dc->writeback_rate.rate = 1;
 
+	/*
+	 * Do not check writeback_percent here, because it might be set
+	 * to zero while dirty data exist. Once dc->has_dirty is set,
+	 * __update_writeback_rate() should always be called here.
+	 */
+	__update_writeback_rate(dc);
+
+schedule_delay:
+	c->request_to_cache_idle = timeout ? 1 : 0;
+	up_read(&dc->writeback_lock);
+	if (wakeup)
+		bch_writeback_queue(dc);
 	schedule_delayed_work(&dc->writeback_rate_update,
 			      dc->writeback_rate_update_seconds * HZ);
 }
-- 
2.12.0
