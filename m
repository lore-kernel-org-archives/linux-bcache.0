From: Coly Li <colyli@suse.de>
Subject: [PATCH 01/15] Revert "bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()"
Date: Tue,  4 Jun 2019 23:16:10 +0800
Message-ID: <20190604151624.105150-2-colyli@suse.de>
References: <20190604151624.105150-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190604151624.105150-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

This reverts commit 6147305c73e4511ca1a975b766b97a779d442567.

Although this patch helps the failed bcache device to stop faster when
too many I/O errors detected on corresponding cached device, setting
CACHE_SET_IO_DISABLE bit to cache set c->flags was not a good idea. This
operation will disable all I/Os on cache set, which means other attached
bcache devices won't work neither.

Without this patch, the failed bcache device can also be stopped
eventually if internal I/O accomplished (e.g. writeback). Therefore here
I revert it.

Fixes: 6147305c73e4 ("bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()")
Reported-by: Yong Li <mr.liyong@qq.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/super.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1b63ac876169..eaaa046fd95d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1437,8 +1437,6 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 
 bool bch_cached_dev_error(struct cached_dev *dc)
 {
-	struct cache_set *c;
-
 	if (!dc || test_bit(BCACHE_DEV_CLOSING, &dc->disk.flags))
 		return false;
 
@@ -1449,21 +1447,6 @@ bool bch_cached_dev_error(struct cached_dev *dc)
 	pr_err("stop %s: too many IO errors on backing device %s\n",
 		dc->disk.disk->disk_name, dc->backing_dev_name);
 
-	/*
-	 * If the cached device is still attached to a cache set,
-	 * even dc->io_disable is true and no more I/O requests
-	 * accepted, cache device internal I/O (writeback scan or
-	 * garbage collection) may still prevent bcache device from
-	 * being stopped. So here CACHE_SET_IO_DISABLE should be
-	 * set to c->flags too, to make the internal I/O to cache
-	 * device rejected and stopped immediately.
-	 * If c is NULL, that means the bcache device is not attached
-	 * to any cache set, then no CACHE_SET_IO_DISABLE bit to set.
-	 */
-	c = dc->disk.c;
-	if (c && test_and_set_bit(CACHE_SET_IO_DISABLE, &c->flags))
-		pr_info("CACHE_SET_IO_DISABLE already set");
-
 	bcache_device_stop(&dc->disk);
 	return true;
 }
-- 
2.16.4
