From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [PATCH] bcache: decouple emitting a cached_dev CHANGE uevent
Date: Thu,  1 Mar 2018 14:38:46 -0500
Message-ID: <07844d5b6f5e3273f774db248815da4d50cb4e3c.1513001217.git.joseph.salisbury__25867.1984229752$1519933015$gmane$org@canonical.com>
References: <cover.1513001217.git.joseph.salisbury@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1513001217.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mlyle@lyle.org, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ryan.harper@canonical.com, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Ryan Harper <ryan.harper@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/1729145

A bug is preventing /dev/bcache/by-uuid links from being created after reboot.
It appears that since the initramfs loads the bcache module which probes and
finds all of the cache devices and backing devices then once the rootfs is
mounted and udev gets to run, the bcache kernel module does not emit the
CACHED_UUID value into the environment if the underlying devices are already registered.    

With this patch, instead of just failing with "device already registered"
the kernel emits another uevent with CACHED_UUID which would be processed
another time to set up a symlink.


- decouple emitting a cached_dev CHANGE uevent which includes dev.uuid
  and dev.label from bch_cached_dev_run() which only happens when a
  bcacheX device is bound to the actual backing block device (bcache0 -> vdb)

- update bch_cached_dev_run() to invoke bch_cached_dev_emit_change() as
  needed; no functional code path changes here

- Modify register_bcache to detect a re-registering of a bcache
  cached_dev, and in that case call bcache_cached_dev_emit_change() to

Cc: stable@vger.kernel.org
Signed-off-by: Ryan Harper <ryan.harper@canonical.com>
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
---
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/super.c  | 53 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 02619ca..8ed7e7a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -906,6 +906,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size);
 
 int bch_cached_dev_attach(struct cached_dev *, struct cache_set *);
 void bch_cached_dev_detach(struct cached_dev *);
+void bch_cached_dev_emit_change(struct cached_dev *);
 void bch_cached_dev_run(struct cached_dev *);
 void bcache_device_stop(struct bcache_device *);
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 04608da..9ff0aac 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -834,7 +834,7 @@ static void calc_cached_dev_sectors(struct cache_set *c)
 	c->cached_dev_sectors = sectors;
 }
 
-void bch_cached_dev_run(struct cached_dev *dc)
+void bch_cached_dev_emit_change(struct cached_dev *dc)
 {
 	struct bcache_device *d = &dc->disk;
 	char buf[SB_LABEL_SIZE + 1];
@@ -849,9 +849,18 @@ void bch_cached_dev_run(struct cached_dev *dc)
 	buf[SB_LABEL_SIZE] = '\0';
 	env[2] = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf);
 
+	/* won't show up in the uevent file, use udevadm monitor -e instead
+	 * only class / kset properties are persistent */
+	kobject_uevent_env(&disk_to_dev(d->disk)->kobj, KOBJ_CHANGE, env);
+	kfree(env[1]);
+	kfree(env[2]);
+
+}
+
+void bch_cached_dev_run(struct cached_dev *dc)
+{
+	struct bcache_device *d = &dc->disk;
 	if (atomic_xchg(&dc->running, 1)) {
-		kfree(env[1]);
-		kfree(env[2]);
 		return;
 	}
 
@@ -867,11 +876,9 @@ void bch_cached_dev_run(struct cached_dev *dc)
 
 	add_disk(d->disk);
 	bd_link_disk_holder(dc->bdev, dc->disk.disk);
-	/* won't show up in the uevent file, use udevadm monitor -e instead
-	 * only class / kset properties are persistent */
-	kobject_uevent_env(&disk_to_dev(d->disk)->kobj, KOBJ_CHANGE, env);
-	kfree(env[1]);
-	kfree(env[2]);
+
+	/* emit change event */
+	bch_cached_dev_emit_change(dc);
 
 	if (sysfs_create_link(&d->kobj, &disk_to_dev(d->disk)->kobj, "dev") ||
 	    sysfs_create_link(&disk_to_dev(d->disk)->kobj, &d->kobj, "bcache"))
@@ -1916,6 +1923,21 @@ static bool bch_is_open_backing(struct block_device *bdev) {
 	return false;
 }
 
+static struct cached_dev *bch_find_cached_dev(struct block_device *bdev) {
+	struct cache_set *c, *tc;
+	struct cached_dev *dc, *t;
+
+	list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
+		list_for_each_entry_safe(dc, t, &c->cached_devs, list)
+			if (dc->bdev == bdev)
+				return dc;
+	list_for_each_entry_safe(dc, t, &uncached_devices, list)
+		if (dc->bdev == bdev)
+			return dc;
+
+	return NULL;
+}
+
 static bool bch_is_open_cache(struct block_device *bdev) {
 	struct cache_set *c, *tc;
 	struct cache *ca;
@@ -1941,6 +1963,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	struct cache_sb *sb = NULL;
 	struct block_device *bdev = NULL;
 	struct page *sb_page = NULL;
+	struct cached_dev *dc = NULL;
 
 	if (!try_module_get(THIS_MODULE))
 		return -EBUSY;
@@ -1957,10 +1980,20 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		if (bdev == ERR_PTR(-EBUSY)) {
 			bdev = lookup_bdev(strim(path), 0);
 			mutex_lock(&bch_register_lock);
-			if (!IS_ERR(bdev) && bch_is_open(bdev))
+			if (!IS_ERR(bdev) && bch_is_open(bdev)) {
 				err = "device already registered";
-			else
+				/* emit CHANGE event for backing devices to export
+				 * CACHED_{UUID/LABEL} values to udev */
+				if (bch_is_open_backing(bdev)) {
+					dc = bch_find_cached_dev(bdev);
+					if (dc) {
+						bch_cached_dev_emit_change(dc);
+						err = "device already registered (emitting change event)";
+					}
+				}
+			} else {
 				err = "device busy";
+            }
 			mutex_unlock(&bch_register_lock);
 			if (!IS_ERR(bdev))
 				bdput(bdev);
-- 
2.7.4
