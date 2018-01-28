From: Coly Li <colyli@suse.de>
Subject: [PATCH v4 13/13] bcache: add stop_when_cache_set_failed to struct cached_dev
Date: Sun, 28 Jan 2018 09:56:25 +0800
Message-ID: <20180128015625.128497-14-colyli@suse.de>
References: <20180128015625.128497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180128015625.128497-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Nix <nix@esperi.org.uk>, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>
List-Id: linux-bcache@vger.kernel.org

Current bcache failure handling code will stop all attached bcache devices
when the cache set is broken or disconnected. This is desired behavior for
most of enterprise or cloud use cases, but maybe not for low end
configuration. Nix <nix@esperi.org.uk> points out, users may still want to
access the bcache device after cache device failed, for example on laptops.

This patch adds a per-cached_dev option stop_when_cache_set_failed, which
is enabled (1) by default. Its value can be set via sysfs, when it is set
to 0, the corresponding bcache device won't be stopped when a broken
or disconnected cache set is retiring. 

When the cached device has dirty data on retiring cache set, if bcache
device is not stopped, following I/O request on the bcache device may
result data corruption on backing device. This patch also prints out warn-
ing information in kernel message.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Nix <nix@esperi.org.uk>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/super.c  | 63 +++++++++++++++++++++++++++++++++-------------
 drivers/md/bcache/sysfs.c  | 10 ++++++++
 3 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9eedb35d01bc..3756a196916f 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -362,6 +362,7 @@ struct cached_dev {
 	unsigned		readahead;
 
 	unsigned		io_disable:1;
+	unsigned		stop_when_cache_set_failed:1;
 	unsigned		verify:1;
 	unsigned		bypass_torture_test:1;
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 85adf1e29d11..93f720433b40 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1246,6 +1246,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
 	atomic_set(&dc->io_errors, 0);
 	dc->io_disable = false;
 	dc->error_limit = DEFAULT_CACHED_DEV_ERROR_LIMIT;
+	dc->stop_when_cache_set_failed = 1;
 
 	bch_cached_dev_request_init(dc);
 	bch_cached_dev_writeback_init(dc);
@@ -1541,33 +1542,59 @@ static void cache_set_flush(struct closure *cl)
 	closure_return(cl);
 }
 
+/*
+ * dc->stop_when_cache_set_failed is default to true. If it is explicitly
+ * set to false by user, the bcache device won't be stopped when cache set
+ * is broken or disconnected. If there is dirty data on failed cache set,
+ * not stopping bcache device may result data corruption on backing device,
+ * pr_warn() notices the protential risk in kernel message.
+ */
+static void try_stop_bcache_device(struct cache_set *c,
+				   struct bcache_device *d,
+				   struct cached_dev *dc)
+{
+	if (dc->stop_when_cache_set_failed)
+		bcache_device_stop(d);
+	else if (!dc->stop_when_cache_set_failed &&
+		 atomic_read(&dc->has_dirty))
+		pr_warn("bcache: device %s won't be stopped while unregistering"
+			" broken dirty cache set %pU, your data has potential "
+			"risk to be corrupted. To disable this warning message,"
+			" please set /sys/block/%s/bcache/stop_when_"
+			"cache_set_failed to 1.",
+			d->name, c->sb.set_uuid, d->name);
+}
+
 static void __cache_set_unregister(struct closure *cl)
 {
 	struct cache_set *c = container_of(cl, struct cache_set, caching);
 	struct cached_dev *dc;
+	struct bcache_device *d;
 	size_t i;
 
 	mutex_lock(&bch_register_lock);
 
-	for (i = 0; i < c->devices_max_used; i++)
-		if (c->devices[i]) {
-			if (!UUID_FLASH_ONLY(&c->uuids[i]) &&
-			    test_bit(CACHE_SET_UNREGISTERING, &c->flags)) {
-				dc = container_of(c->devices[i],
-						  struct cached_dev, disk);
-				bch_cached_dev_detach(dc);
-				/*
-				 * If we come here by too many I/O errors,
-				 * bcache device should be stopped too, to
-				 * keep data consistency on cache and
-				 * backing devices.
-				 */
-				if (test_bit(CACHE_SET_IO_DISABLE, &c->flags))
-					bcache_device_stop(c->devices[i]);
-			} else {
-				bcache_device_stop(c->devices[i]);
-			}
+	for (i = 0; i < c->devices_max_used; i++) {
+		d = c->devices[i];
+		if (!d)
+			continue;
+
+		if (!UUID_FLASH_ONLY(&c->uuids[i]) &&
+		    test_bit(CACHE_SET_UNREGISTERING, &c->flags)) {
+			dc = container_of(d, struct cached_dev, disk);
+			bch_cached_dev_detach(dc);
+			/*
+			 * If we come here by too many I/O errors,
+			 * bcache device should be stopped too, to
+			 * keep data consistency on cache and
+			 * backing devices.
+			 */
+			if (test_bit(CACHE_SET_IO_DISABLE, &c->flags))
+				try_stop_bcache_device(c, d, dc);
+		} else {
+			bcache_device_stop(d);
 		}
+	}
 
 	mutex_unlock(&bch_register_lock);
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 7288927f2a47..b096d4c37c9b 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -93,6 +93,7 @@ read_attribute(partial_stripes_expensive);
 rw_attribute(synchronous);
 rw_attribute(journal_delay_ms);
 rw_attribute(io_disable);
+rw_attribute(stop_when_cache_set_failed);
 rw_attribute(discard);
 rw_attribute(running);
 rw_attribute(label);
@@ -134,6 +135,8 @@ SHOW(__bch_cached_dev)
 	sysfs_hprint(io_errors,		atomic_read(&dc->io_errors));
 	sysfs_printf(io_error_limit,	"%i", dc->error_limit);
 	sysfs_printf(io_disable,	"%i", dc->io_disable);
+	sysfs_printf(stop_when_cache_set_failed, "%i",
+		     dc->stop_when_cache_set_failed);
 	var_print(writeback_rate_update_seconds);
 	var_print(writeback_rate_i_term_inverse);
 	var_print(writeback_rate_p_term_inverse);
@@ -233,6 +236,12 @@ STORE(__cached_dev)
 		dc->io_disable = v ? 1 : 0;
 	}
 
+	if (attr == &sysfs_stop_when_cache_set_failed) {
+		int v = strtoul_or_return(buf);
+
+		dc->stop_when_cache_set_failed = v ? 1 : 0;
+	}
+
 	d_strtoi_h(sequential_cutoff);
 	d_strtoi_h(readahead);
 
@@ -343,6 +352,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_errors,
 	&sysfs_io_error_limit,
 	&sysfs_io_disable,
+	&sysfs_stop_when_cache_set_failed,
 	&sysfs_dirty_data,
 	&sysfs_stripe_size,
 	&sysfs_partial_stripes_expensive,
-- 
2.15.1
