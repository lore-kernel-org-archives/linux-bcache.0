From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [v2] bcache: stop using the deprecated get_seconds()
Date: Fri, 22 Jun 2018 15:48:41 +0200
Message-ID: <20180622134907.227131-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, Michael Lyle <mlyle@lyle.org>, Tang Junhui <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

The get_seconds function is deprecated now since it returns a 32-bit
value that will eventually overflow, and we are replacing it throughout
the kernel with ktime_get_seconds() or ktime_get_real_seconds() that
return a time64_t.

bcache uses get_seconds() to read the current system time and store it in
the superblock as well as in uuid_entry structures that are user visible.

Unfortunately, the two structures in are still limited to 32 bits, so this
won't fix any real problems but will still overflow in year 2106. Let's
at least document that properly, in case we get an updated format in the
future it can be fixed. We still have a long time before the overflow
and checking the tools at https://github.com/koverstreet/bcache-tools
reveals no access to any of them.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/bcache/super.c   | 12 ++++++------
 include/uapi/linux/bcache.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fa4058e43202..74746d8ee05e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -181,7 +181,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 		goto err;
 	}
 
-	sb->last_mount = get_seconds();
+	sb->last_mount = (u32)ktime_get_real_seconds();
 	err = NULL;
 
 	get_page(bh->b_page);
@@ -701,7 +701,7 @@ static void bcache_device_detach(struct bcache_device *d)
 
 		SET_UUID_FLASH_ONLY(u, 0);
 		memcpy(u->uuid, invalid_uuid, 16);
-		u->invalidated = cpu_to_le32(get_seconds());
+		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
 		bch_uuid_write(d->c);
 	}
 
@@ -1027,7 +1027,7 @@ void bch_cached_dev_detach(struct cached_dev *dc)
 int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 			  uint8_t *set_uuid)
 {
-	uint32_t rtime = cpu_to_le32(get_seconds());
+	uint32_t rtime = cpu_to_le32((u32)ktime_get_real_seconds());
 	struct uuid_entry *u;
 	struct cached_dev *exist_dc, *t;
 
@@ -1070,7 +1070,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	    (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
 	     BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
 		memcpy(u->uuid, invalid_uuid, 16);
-		u->invalidated = cpu_to_le32(get_seconds());
+		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
 		u = NULL;
 	}
 
@@ -1390,7 +1390,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 
 	get_random_bytes(u->uuid, 16);
 	memset(u->label, 0, 32);
-	u->first_reg = u->last_reg = cpu_to_le32(get_seconds());
+	u->first_reg = u->last_reg = cpu_to_le32((u32)ktime_get_real_seconds());
 
 	SET_UUID_FLASH_ONLY(u, 1);
 	u->sectors = size >> 9;
@@ -1894,7 +1894,7 @@ static void run_cache_set(struct cache_set *c)
 		goto err;
 
 	closure_sync(&cl);
-	c->sb.last_mount = get_seconds();
+	c->sb.last_mount = (u32)ktime_get_real_seconds();
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
