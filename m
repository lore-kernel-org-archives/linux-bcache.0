From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] bcache: Reload device size
Date: Sun, 05 May 2013 21:33:56 +0200
Message-ID: <5186B424.90009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Adds /sys/block/bcache*/bcache/resize; writing "max"
to such a file will reload the device size to match
the size of the underlying device, minus the bcache
superblock.

This is useful to grow a filesystem stacked on top
of bcache and a logical volume.

Other values than max are reserved for now; support
for shrinking might be added if the need comes up.

Signed-off-by: Gabriel de Perthuis <g2p.code+bcache-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
v2: use revalidate_disk to commit changes

 Documentation/bcache.txt   |  4 ++++
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/super.c  | 10 +++++++++-
 drivers/md/bcache/sysfs.c  | 11 +++++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
index acfa679..a53ee2d 100644
--- a/Documentation/bcache.txt
+++ b/Documentation/bcache.txt
@@ -215,10 +215,14 @@ label
 readahead
   Size of readahead that should be performed.  Defaults to 0.  If set to e.g.
   1M, it will round cache miss reads up to that size, but without overlapping
   existing cache entries.
 
+resize
+  Write "max" to this file after resizing the underlying device.
+  bcache will update its device size to match.
+
 running
   1 if bcache is running (i.e. whether the /dev/bcache device exists, whether
   it's in passthrough mode or caching).
 
 sequential_cutoff
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index cd185ad..0ccb8f0 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1214,10 +1214,11 @@ void bcache_write_super(struct cache_set *);
 int bch_flash_dev_create(struct cache_set *c, uint64_t size);
 
 int bch_cached_dev_attach(struct cached_dev *, struct cache_set *);
 void bch_cached_dev_detach(struct cached_dev *);
 void bch_cached_dev_run(struct cached_dev *);
+void bch_cached_dev_resize(struct cached_dev *);
 void bcache_device_stop(struct bcache_device *);
 
 void bch_cache_set_unregister(struct cache_set *);
 void bch_cache_set_stop(struct cache_set *);
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4c16411..b862910 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -805,10 +805,18 @@ static void calc_cached_dev_sectors(struct cache_set *c)
 		sectors += bdev_sectors(dc->bdev);
 
 	c->cached_dev_sectors = sectors;
 }
 
+void bch_cached_dev_resize(struct cached_dev *dc)
+{
+	set_capacity(
+		dc->disk.disk,
+		dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
+	revalidate_disk(dc->disk.disk);
+}
+
 void bch_cached_dev_run(struct cached_dev *dc)
 {
 	struct bcache_device *d = &dc->disk;
 
 	if (atomic_xchg(&dc->running, 1))
@@ -1087,11 +1095,11 @@ static const char *register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev = bdev;
 	dc->bdev->bd_holder = dc;
 
 	g = dc->disk.disk;
 
-	set_capacity(g, dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
+	bch_cached_dev_resize(dc);
 
 	g->queue->backing_dev_info.ra_pages =
 		max(g->queue->backing_dev_info.ra_pages,
 		    bdev->bd_queue->backing_dev_info.ra_pages);
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 6b9f0ee..69a5d13 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -26,10 +26,11 @@ write_attribute(unregister);
 write_attribute(stop);
 write_attribute(clear_stats);
 write_attribute(trigger_gc);
 write_attribute(prune_cache);
 write_attribute(flash_vol_create);
+write_attribute(resize);
 
 read_attribute(bucket_size);
 read_attribute(block_size);
 read_attribute(nbuckets);
 read_attribute(tree_depth);
@@ -200,10 +201,19 @@ STORE(__cached_dev)
 
 	if (attr == &sysfs_running &&
 	    strtoul_or_return(buf))
 		bch_cached_dev_run(dc);
 
+	if (attr == &sysfs_resize) {
+		if (!strcmp(buf, "max") || !strcmp(buf, "max\n"))
+			bch_cached_dev_resize(dc);
+		else
+			/* Reserved for future use, if someone needs sizes below the max.
+			 * memparse units would be consistent with fs resizing tools. */
+			return -EINVAL;
+	}
+
 	if (attr == &sysfs_cache_mode) {
 		ssize_t v = bch_read_string_list(buf, bch_cache_modes + 1);
 
 		if (v < 0)
 			return v;
@@ -287,10 +297,11 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_dirty_data,
 	&sysfs_sequential_cutoff,
 	&sysfs_sequential_merge,
 	&sysfs_clear_stats,
 	&sysfs_running,
+	&sysfs_resize,
 	&sysfs_state,
 	&sysfs_label,
 	&sysfs_readahead,
 #ifdef CONFIG_BCACHE_DEBUG
 	&sysfs_verify,
-- 
1.8.2.1.419.ga0b97c6
