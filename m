From: tang.junhui@zte.com.cn
Subject: [PATCH 2/2] bcache: fix for data collapse after re-attaching an attached device
Date: Mon, 5 Feb 2018 20:11:59 +0800
Message-ID: <1517832719-28525-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

back-end device sdm has already attached a cache_set with ID
f67ebe1f-f8bc-4d73-bfe5-9dc88607f119, then try to attach with
another cache set, and it returns with an error:
[root]# cd /sys/block/sdm/bcache
[root]# echo 5ccd0a63-148e-48b8-afa2-aca9cbd6279f > attach
-bash: echo: write error: Invalid argument

After that, execute a command to modify the label of bcache
device:
[root]# echo data_disk1 > label

Then we reboot the system, when the system power on, the back-end
device can not attach to cache_set, a messages show in the log:
Feb  5 12:05:52 ceph152 kernel: [922385.508498] bcache:
bch_cached_dev_attach() couldn't find uuid for sdm in set

In sysfs_attach(), dc->sb.set_uuid was assigned to the value
which input through sysfs, no matter whether it is success
or not in bch_cached_dev_attach(). For example, If the back-end
device has already attached to an cache set, bch_cached_dev_attach()
would fail, but dc->sb.set_uuid was changed. Then modify the
label of bcache device, it will call bch_write_bdev_super(),
which would write the dc->sb.set_uuid to the super block, so we
record a wrong cache set ID in the super block, after the system
reboot, the cache set couldn't find the uuid of the back-end
device, so the bcache device couldn't exist and use any more.

In this patch, we don't assigned cache set ID to dc->sb.set_uuid
in sysfs_attach() directly, but input it into bch_cached_dev_attach(),
and assigned dc->sb.set_uuid to the cache set ID after the back-end
device attached to the cache set successful.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/bcache.h |  2 +-
 drivers/md/bcache/super.c  | 10 ++++++----
 drivers/md/bcache/sysfs.c  |  6 ++++--
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 843877e..40f0267 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -907,7 +907,7 @@ bool bch_alloc_sectors(struct cache_set *, struct bkey *, unsigned,
 
 int bch_flash_dev_create(struct cache_set *c, uint64_t size);
 
-int bch_cached_dev_attach(struct cached_dev *, struct cache_set *);
+int bch_cached_dev_attach(struct cached_dev *, struct cache_set *, uint8_t *);
 void bch_cached_dev_detach(struct cached_dev *);
 void bch_cached_dev_run(struct cached_dev *);
 void bcache_device_stop(struct bcache_device *);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index b4d2892..bdabdca 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -946,7 +946,8 @@ void bch_cached_dev_detach(struct cached_dev *dc)
 	cached_dev_put(dc);
 }
 
-int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
+int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
+			  uint8_t *set_uuid)
 {
 	uint32_t rtime = cpu_to_le32(get_seconds());
 	struct uuid_entry *u;
@@ -954,7 +955,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 
 	bdevname(dc->bdev, buf);
 
-	if (memcmp(dc->sb.set_uuid, c->sb.set_uuid, 16))
+	if ((set_uuid && memcmp(set_uuid, c->sb.set_uuid, 16)) ||
+	    (!set_uuid && memcmp(dc->sb.set_uuid, c->sb.set_uuid, 16)))
 		return -ENOENT;
 
 	if (dc->disk.c) {
@@ -1183,7 +1185,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 
 	list_add(&dc->list, &uncached_devices);
 	list_for_each_entry(c, &bch_cache_sets, list)
-		bch_cached_dev_attach(dc, c);
+		bch_cached_dev_attach(dc, c, NULL);
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
 	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE)
@@ -1705,7 +1707,7 @@ static void run_cache_set(struct cache_set *c)
 	bcache_write_super(c);
 
 	list_for_each_entry_safe(dc, t, &uncached_devices, list)
-		bch_cached_dev_attach(dc, c);
+		bch_cached_dev_attach(dc, c, NULL);
 
 	flash_devs_run(c);
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 9c8fdd5..6316399 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -267,12 +267,14 @@
 	}
 
 	if (attr == &sysfs_attach) {
-		if (bch_parse_uuid(buf, dc->sb.set_uuid) < 16)
+		uint8_t		set_uuid[16];
+
+		if (bch_parse_uuid(buf, set_uuid) < 16)
 			return -EINVAL;
 
 		v = -ENOENT;
 		list_for_each_entry(c, &bch_cache_sets, list) {
-			v = bch_cached_dev_attach(dc, c);
+			v = bch_cached_dev_attach(dc, c, set_uuid);
 			if (!v)
 				return size;
 		}
-- 
1.8.3.1
