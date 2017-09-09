From: Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: option for recovery from staled data
Date: Sun, 10 Sep 2017 01:56:21 +0800
Message-ID: <20170909175621.9705-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

When bcache does read I/Os, for example in writeback or writethrough mode,
if a read request on cache device is failed, bcache will try to recovery
the request by reading from cached device. If the data on cached device is
not synced with cache device, then requester will get a staled data.

For critical storage system like database, recovery from staled data may
result an application level data corruption, which is unacceptible. But
for some other situation like multi-media stream cache, continuous service
may be more important and it is acceptible to fetch a staled chunk of data.

This patch tries to solve the above conflict by adding a sysfs option
	/sys/block/bcache<idx>/bcache/recovery_from_staled_data
which is defaultly cleared (to 0) as disabled. Now people can make choices
for different situations.

With this patch, for a failed read request in writeback or writethrough
mode, recovery a recoverable read request only happens in one of the
following conditions,
 - dc->has_dirty is zero. It means all data on cache device is synced to
   cached device, the recoveried data is up-to-date. 
 - dc->has_dirty is non-zero, and dc->recovery_from_staled_data is set
   to 1. It means there is dirty data not synced to cached device yet, but
   option recovery_from_staled_data is set, receiving staled data is
   explicitly acceptible for requester.

For other cache modes in bcache, read request will never hit
cached_dev_read_error(), they don't need this patch.

Please note, because cache mode can be switched arbitrarily in run time, a
writethrough mode might be switched from a writeback mode. Therefore
checking dc->has_data in writethrough mode still makes sense.

Signed-off-by: Coly Li <colyli@suse.de>
Reported-by: Arne Wolf <awolf@lenovo.com>
Cc: Kai Krakow <hurikhan77@gmail.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/bcache.h  |  1 +
 drivers/md/bcache/request.c | 14 +++++++++++++-
 drivers/md/bcache/sysfs.c   |  4 ++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index dee542fff68e..f26b174f409a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -356,6 +356,7 @@ struct cached_dev {
 	unsigned		partial_stripes_expensive:1;
 	unsigned		writeback_metadata:1;
 	unsigned		writeback_running:1;
+	unsigned		recovery_from_staled_data:1;
 	unsigned char		writeback_percent;
 	unsigned		writeback_delay;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 019b3df9f1c6..becbc0959ca2 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -702,8 +702,20 @@ static void cached_dev_read_error(struct closure *cl)
 {
 	struct search *s = container_of(cl, struct search, cl);
 	struct bio *bio = &s->bio.bio;
+	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
+	int recovery_staled_data = dc ? dc->recovery_from_staled_data : 0;
 
-	if (s->recoverable) {
+	/*
+	 * If dc->has_dirty is non-zero and the recovering data is on cache
+	 * device, then recover from cached device will return a staled data
+	 * to requester. But in some cases people accept staled data to avoid
+	 * an -EIO. So I/O error recovery only happens when,
+	 * - No dirty data on cache device.
+	 * - Cached device is dirty but sysfs recovery_from_staled_data is
+	 *   explicitly set (to 1) to accept recovering from staled data.
+	 */
+	if (s->recoverable &&
+	    (!atomic_read(&dc->has_dirty) || recovery_staled_data)) {
 		/* Retry from the backing device: */
 		trace_bcache_read_retry(s->orig_bio);
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index f90f13616980..8603756005a8 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -106,6 +106,7 @@ rw_attribute(cache_replacement_policy);
 rw_attribute(btree_shrinker_disabled);
 rw_attribute(copy_gc_enabled);
 rw_attribute(size);
+rw_attribute(recovery_from_staled_data);
 
 SHOW(__bch_cached_dev)
 {
@@ -125,6 +126,7 @@ SHOW(__bch_cached_dev)
 	var_printf(bypass_torture_test,	"%i");
 	var_printf(writeback_metadata,	"%i");
 	var_printf(writeback_running,	"%i");
+	var_printf(recovery_from_staled_data,"%i");
 	var_print(writeback_delay);
 	var_print(writeback_percent);
 	sysfs_hprint(writeback_rate,	dc->writeback_rate.rate << 9);
@@ -201,6 +203,7 @@ STORE(__cached_dev)
 #define d_strtoi_h(var)		sysfs_hatoi(var, dc->var)
 
 	sysfs_strtoul(data_csum,	dc->disk.data_csum);
+	d_strtoul(recovery_from_staled_data);
 	d_strtoul(verify);
 	d_strtoul(bypass_torture_test);
 	d_strtoul(writeback_metadata);
@@ -335,6 +338,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_verify,
 	&sysfs_bypass_torture_test,
 #endif
+	&sysfs_recovery_from_staled_data,
 	NULL
 };
 KTYPE(bch_cached_dev);
-- 
2.13.5
