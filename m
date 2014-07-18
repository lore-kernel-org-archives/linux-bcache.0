From: Jianjian Huo <samuel.huo@gmail.com>
Subject: [PATCH] bcache: add sysfs option to enable/disable read caching
Date: Thu, 17 Jul 2014 23:34:23 -0700
Message-ID: <1405665263-2418-1-git-send-email-samuel.huo@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33961 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaGRGeo (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 18 Jul 2014 02:34:44 -0400
Received: by mail-pa0-f51.google.com with SMTP id ey11so4766975pad.24
        for <linux-bcache@vger.kernel.org>; Thu, 17 Jul 2014 23:34:44 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: kmo@daterainc.com, Jianjian Huo <samuel.huo@gmail.com>

A few of bcache users are requesting a bcache option to enable/disable
read caching, in order to fine tune their bcache use cases. This patch
will do the work. The new sysfs setting is within backing device sysfs
folders, for example  /sys/block/bcache0/bcache/cache_read_enable.

By default, it's enabled, since it's typical cache use case. And it works
with all three cache policies, writearound, writeback and writethrough.

This patch is based on 3.15, has been tested for several related test cases.

Signed-off-by: Jianjian Huo <samuel.huo@gmail.com>
---
 drivers/md/bcache/bcache.h  |    2 ++
 drivers/md/bcache/request.c |    5 +++--
 drivers/md/bcache/super.c   |    1 +
 drivers/md/bcache/sysfs.c   |    4 ++++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 82c9c5d..b9ce6c1 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -365,6 +365,8 @@ struct cached_dev {
 	unsigned		sequential_cutoff;
 	unsigned		readahead;
 
+	unsigned		cache_read_enable:1;
+
 	unsigned		verify:1;
 	unsigned		bypass_torture_test:1;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 15fff4f..f382223 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -368,6 +368,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	unsigned sectors, congested = bch_get_congested(c);
 	struct task_struct *task = current;
 	struct io *i;
+	int rw = bio_data_dir(bio);
 
 	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
 	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
@@ -375,8 +376,8 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 		goto skip;
 
 	if (mode == CACHE_MODE_NONE ||
-	    (mode == CACHE_MODE_WRITEAROUND &&
-	     (bio->bi_rw & REQ_WRITE)))
+	    (mode == CACHE_MODE_WRITEAROUND && (bio->bi_rw & REQ_WRITE)) ||
+	    (!rw && !dc->cache_read_enable))
 		goto skip;
 
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 926ded8..ed57be7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1126,6 +1126,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
 	bch_cache_accounting_init(&dc->accounting, &dc->disk.cl);
 
 	dc->sequential_cutoff		= 4 << 20;
+	dc->cache_read_enable		= true;
 
 	for (io = dc->io; io < dc->io + RECENT_IO; io++) {
 		list_add(&io->lru, &dc->io_lru);
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b3ff57d..e15f888 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -73,6 +73,7 @@ rw_attribute(congested_write_threshold_us);
 rw_attribute(sequential_cutoff);
 rw_attribute(data_csum);
 rw_attribute(cache_mode);
+rw_attribute(cache_read_enable);
 rw_attribute(writeback_metadata);
 rw_attribute(writeback_running);
 rw_attribute(writeback_percent);
@@ -124,6 +125,7 @@ SHOW(__bch_cached_dev)
 	var_printf(bypass_torture_test,	"%i");
 	var_printf(writeback_metadata,	"%i");
 	var_printf(writeback_running,	"%i");
+	var_printf(cache_read_enable,	"%i");
 	var_print(writeback_delay);
 	var_print(writeback_percent);
 	sysfs_hprint(writeback_rate,	dc->writeback_rate.rate << 9);
@@ -205,6 +207,7 @@ STORE(__cached_dev)
 	d_strtoul(writeback_metadata);
 	d_strtoul(writeback_running);
 	d_strtoul(writeback_delay);
+	d_strtoul(cache_read_enable);
 
 	sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent, 0, 40);
 
@@ -312,6 +315,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_data_csum,
 #endif
 	&sysfs_cache_mode,
+	&sysfs_cache_read_enable,
 	&sysfs_writeback_metadata,
 	&sysfs_writeback_running,
 	&sysfs_writeback_delay,
-- 
1.7.9.5
