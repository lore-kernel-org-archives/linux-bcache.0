From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] bcache: stop using the deprecated get_seconds()
Date: Wed, 20 Jun 2018 11:51:54 +0200
Message-ID: <20180620095228.3686471-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, Michael Lyle <mlyle@lyle.org>, Tang Junhui <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bart.vanassche@wdc.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

bcache uses get_seconds() to read the current system time and store it in
the superblock as well as in uuid_entry structures that are user visible.

This changes over from the deprecated function to
ktime_get_real_seconds(), which returns a 64-bit timestamp as it
should. Unfortunately, the two structures are still limited to 32 bits,
so this won't fix any real problems. Let's at least document that
properly, in case we get an updated format in the future it can be
fixed. Until then, we still have some time, and checking the tools
at https://github.com/koverstreet/bcache-tools reveals no access to
any of them.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/bcache/super.c   | 23 +++++++++++++++++------
 include/uapi/linux/bcache.h |  4 ++--
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fa4058e43202..aa9790ee5cb5 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -53,6 +53,17 @@ struct workqueue_struct *bcache_wq;
 /* limitation of bcache devices number on single system */
 #define BCACHE_DEVICE_IDX_MAX	((1U << MINORBITS)/BCACHE_MINORS)
 
+/*
+ * various timestamp fields in the superblock are unfortunately
+ * limited to 32 bits, which will lead to overflow in year 2106.
+ *
+ * If we ever get a new superblock format, that should be fixed.
+ */
+static inline u32 bcache_get_realtime32(void)
+{
+	return (u32)ktime_get_real_seconds();
+}
+
 /* Superblock */
 
 static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
@@ -181,7 +192,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 		goto err;
 	}
 
-	sb->last_mount = get_seconds();
+	sb->last_mount = bcache_get_realtime32();
 	err = NULL;
 
 	get_page(bh->b_page);
@@ -701,7 +712,7 @@ static void bcache_device_detach(struct bcache_device *d)
 
 		SET_UUID_FLASH_ONLY(u, 0);
 		memcpy(u->uuid, invalid_uuid, 16);
-		u->invalidated = cpu_to_le32(get_seconds());
+		u->invalidated = cpu_to_le32(bcache_get_realtime32());
 		bch_uuid_write(d->c);
 	}
 
@@ -1027,7 +1038,7 @@ void bch_cached_dev_detach(struct cached_dev *dc)
 int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 			  uint8_t *set_uuid)
 {
-	uint32_t rtime = cpu_to_le32(get_seconds());
+	uint32_t rtime = cpu_to_le32(bcache_get_realtime32());
 	struct uuid_entry *u;
 	struct cached_dev *exist_dc, *t;
 
@@ -1070,7 +1081,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	    (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
 	     BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
 		memcpy(u->uuid, invalid_uuid, 16);
-		u->invalidated = cpu_to_le32(get_seconds());
+		u->invalidated = cpu_to_le32(bcache_get_realtime32());
 		u = NULL;
 	}
 
@@ -1390,7 +1401,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 
 	get_random_bytes(u->uuid, 16);
 	memset(u->label, 0, 32);
-	u->first_reg = u->last_reg = cpu_to_le32(get_seconds());
+	u->first_reg = u->last_reg = cpu_to_le32(bcache_get_realtime32());
 
 	SET_UUID_FLASH_ONLY(u, 1);
 	u->sectors = size >> 9;
@@ -1894,7 +1905,7 @@ static void run_cache_set(struct cache_set *c)
 		goto err;
 
 	closure_sync(&cl);
-	c->sb.last_mount = get_seconds();
+	c->sb.last_mount = bcache_get_realtime32();
 	bcache_write_super(c);
 
 	list_for_each_entry_safe(dc, t, &uncached_devices, list)
diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 821f71a2e48f..8d19e02d752a 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -195,7 +195,7 @@ struct cache_sb {
 	};
 	};
 
-	__u32			last_mount;	/* time_t */
+	__u32			last_mount;	/* time overflow in y2106 */
 
 	__u16			first_bucket;
 	union {
@@ -318,7 +318,7 @@ struct uuid_entry {
 		struct {
 			__u8	uuid[16];
 			__u8	label[32];
-			__u32	first_reg;
+			__u32	first_reg; /* time overflow in y2106 */
 			__u32	last_reg;
 			__u32	invalidated;
 
-- 
2.9.0
