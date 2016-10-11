From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PATCH v2 1/2] bcache: introduce per-process ioprio-based
 bypass/writeback hints
Date: Tue, 11 Oct 2016 12:04:52 -0700
Message-ID: <S1751057AbcJKTQx/20161011191653Z+507@vger.kernel.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:40319 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751317AbcJKTQw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 Oct 2016 15:16:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.ewheeler.net (Postfix) with ESMTP id 2FADBA0C50
        for <linux-bcache@vger.kernel.org>; Tue, 11 Oct 2016 12:14:27 -0700 (PDT)
Received: from mail.ewheeler.net ([127.0.0.1])
        by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id b14oxN8wnFBA for <linux-bcache@vger.kernel.org>;
        Tue, 11 Oct 2016 12:14:26 -0700 (PDT)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.ewheeler.net (Postfix) with ESMTPSA id 727B8A0C2C
        for <linux-bcache@vger.kernel.org>; Tue, 11 Oct 2016 12:14:26 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Add support to bcache hinting functions and sysfs to hint by the ioprio of
'current' for cache writeback or bypass (configured per-process with `ionice`).

Having idle IOs bypass the cache can increase performance elsewhere
since you probably don't care about their performance.  In addition,
this prevents idle IOs from promoting into (polluting) your cache and
evicting blocks that are more important elsewhere.

If you really nead the performance at the expense of SSD wearout,
then configure ioprio_writeback and set your `ionice` appropriately.

For example:
	echo 2,7 > /sys/block/bcache0/bcache/ioprio_bypass
	echo 2,0 > /sys/block/bcache0/bcache/ioprio_writeback

See the documentation commit for details.

Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
Tested-by: Kai Krakow <kai@kaishome.de>
---
 drivers/md/bcache/bcache.h    |  3 ++
 drivers/md/bcache/request.c   | 14 +++++++++
 drivers/md/bcache/sysfs.c     | 71 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.c |  8 +++++
 drivers/md/bcache/writeback.h | 14 +++++++++
 5 files changed, 110 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 6b420a5..bf945fa 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -367,6 +367,9 @@ struct cached_dev {
 	unsigned		writeback_rate_update_seconds;
 	unsigned		writeback_rate_d_term;
 	unsigned		writeback_rate_p_term_inverse;
+
+	unsigned short		ioprio_writeback;
+	unsigned short		ioprio_bypass;
 };
 
 enum alloc_reserve {
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 4b177fe..b6911df 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -375,6 +375,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	unsigned sectors, congested = bch_get_congested(c);
 	struct task_struct *task = current;
 	struct io *i;
+	struct io_context *ioc;
 
 	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
 	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
@@ -386,6 +387,19 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	     op_is_write(bio_op(bio))))
 		goto skip;
 
+	/* If process ioprio is lower-or-equal to dc->ioprio_bypass, then
+	 * hint for bypass. Note that a lower-priority IO class+value
+	 * has a greater numeric value. */
+	ioc = get_task_io_context(current, GFP_ATOMIC, NUMA_NO_NODE);
+	if (ioc
+		&& ioprio_valid(ioc->ioprio)
+		&& ioprio_valid(dc->ioprio_writeback)
+		&& ioc->ioprio >= dc->ioprio_bypass) {
+		put_io_context(ioc);
+		return true;
+	}
+	if (ioc) put_io_context(ioc);
+
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
 	    bio_sectors(bio) & (c->sb.block_size - 1)) {
 		pr_debug("skipping unaligned io");
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b3ff57d..c65c21e 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -106,6 +106,9 @@ rw_attribute(btree_shrinker_disabled);
 rw_attribute(copy_gc_enabled);
 rw_attribute(size);
 
+rw_attribute(ioprio_writeback);
+rw_attribute(ioprio_bypass);
+
 SHOW(__bch_cached_dev)
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
@@ -182,6 +185,17 @@ SHOW(__bch_cached_dev)
 		return strlen(buf);
 	}
 
+	if (attr == &sysfs_ioprio_bypass)
+		return snprintf(buf, PAGE_SIZE-1, "%d,%ld\n",
+			IOPRIO_PRIO_CLASS(dc->ioprio_bypass),
+			IOPRIO_PRIO_DATA(dc->ioprio_bypass));
+
+	if (attr == &sysfs_ioprio_writeback)
+		return snprintf(buf, PAGE_SIZE-1, "%d,%ld\n",
+			IOPRIO_PRIO_CLASS(dc->ioprio_writeback),
+			IOPRIO_PRIO_DATA(dc->ioprio_writeback));
+
+
 #undef var
 	return 0;
 }
@@ -194,6 +208,10 @@ STORE(__cached_dev)
 	unsigned v = size;
 	struct cache_set *c;
 	struct kobj_uevent_env *env;
+	unsigned ioprio_class = 0; /* invalid initial ioprio values */
+	unsigned ioprio_level = IOPRIO_BE_NR;
+	unsigned short *ioprio_hint = NULL;
+	char *ioprio_type = NULL;
 
 #define d_strtoul(var)		sysfs_strtoul(var, dc->var)
 #define d_strtoul_nonzero(var)	sysfs_strtoul_clamp(var, dc->var, 1, INT_MAX)
@@ -282,6 +300,57 @@ STORE(__cached_dev)
 	if (attr == &sysfs_stop)
 		bcache_device_stop(&dc->disk);
 
+	/* ioprio hinting: we use ioprio_hint to reduce duplicate printk verbiage */
+	if (attr == &sysfs_ioprio_writeback) {
+		ioprio_hint = &dc->ioprio_writeback;
+		ioprio_type = "writeback";
+	}
+
+	if (attr == &sysfs_ioprio_bypass) {
+		ioprio_hint = &dc->ioprio_bypass;
+		ioprio_type = "bypass";
+	}
+
+	if (ioprio_hint != NULL)
+	{
+		if (sscanf(buf, "%u,%u", &ioprio_class, &ioprio_level) != 2
+			|| ioprio_class > IOPRIO_CLASS_IDLE
+			|| ioprio_level >= IOPRIO_BE_NR) {
+			pr_err("ioprio_%s invalid, expecting: (class,level) but parsed (%u,%u); ignored.",
+				ioprio_type,
+				ioprio_class, ioprio_level);
+			return size;
+		}
+
+		/* Use the maximum(/minimum) value in the class shift space to make integer
+		  comparison correct for ioprio_writeback(/ioprio_bypass) for IOPRIO_CLASS_IDLE.
+		  This is necessary because there are no ioprio levels for the idle class. */
+		if (ioprio_class == IOPRIO_CLASS_IDLE) {
+			if (ioprio_hint == &dc->ioprio_writeback)
+				ioprio_level = IOPRIO_PRIO_MASK;
+			else
+				/* Same, but 0 for bypass (inverted vs. writeback) */
+				ioprio_level = 0;
+		}
+
+		*ioprio_hint = IOPRIO_PRIO_VALUE(ioprio_class, ioprio_level);
+
+		if (!ioprio_valid(*ioprio_hint))
+			pr_info("disabled ioprio_%s hints.", ioprio_type);
+		else
+			pr_info("set hint for cache %s with priority %s: (class,level) = (%u,%u)",
+				ioprio_type,
+				( ioprio_hint == &dc->ioprio_writeback ? "at-or-above" : "at-or-below" ),
+				ioprio_class, ioprio_level);
+
+		if (ioprio_valid(dc->ioprio_writeback)
+			&& ioprio_valid(dc->ioprio_bypass)
+			&& dc->ioprio_writeback >= dc->ioprio_bypass)
+			pr_warning(
+				"warning: ioprio_writeback hint is neither disabled nor higher priority than the bypass hint; "
+				"will always writeback!");
+	}
+
 	return size;
 }
 
@@ -334,6 +403,8 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_verify,
 	&sysfs_bypass_torture_test,
 #endif
+	&sysfs_ioprio_bypass,
+	&sysfs_ioprio_writeback,
 	NULL
 };
 KTYPE(bch_cached_dev);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index d9fd2a6..1e3ec3d 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -514,6 +514,14 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate_d_term	= 30;
 	dc->writeback_rate_p_term_inverse = 6000;
 
+	/* These defaults provide the best SSD life by enabling bypass
+	 for priorities at-or-below BE-7. This also provides better
+	 performance (cache hits) by preventing (near-)idle processes from
+	 polluting the cache working set.  Only set ioprio_writeback if
+	 you really need it: it will wear out your SSD sooner. */
+	dc->ioprio_writeback = IOPRIO_PRIO_VALUE(0, 0);
+	dc->ioprio_bypass    = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, (IOPRIO_BE_NR-1));
+
 	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
 }
 
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 301eaf5..efd1b47 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -43,6 +43,7 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 				    unsigned cache_mode, bool would_skip)
 {
 	unsigned in_use = dc->disk.c->gc_stats.in_use;
+	struct io_context *ioc;
 
 	if (cache_mode != CACHE_MODE_WRITEBACK ||
 	    test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
@@ -57,6 +58,19 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 	if (would_skip)
 		return false;
 
+	/* If process ioprio is higher-or-equal to dc->ioprio_writeback, then
+	 * hint for writeback. Note that a higher-priority IO class+value
+	 * has a lesser numeric value. */
+	ioc = get_task_io_context(current, GFP_ATOMIC, NUMA_NO_NODE);
+	if (ioc
+		&& ioprio_valid(ioc->ioprio)
+		&& ioprio_valid(dc->ioprio_writeback)
+		&& ioc->ioprio <= dc->ioprio_writeback) {
+		put_io_context(ioc);
+		return true;
+	}
+	if (ioc) put_io_context(ioc);
+
 	return bio->bi_opf & REQ_SYNC ||
 		in_use <= CUTOFF_WRITEBACK;
 }
-- 
1.8.3.1
