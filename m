From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] bcache: register_bdev can fail, make it failable
Date: Wed,  4 Nov 2015 16:22:24 +0100
Message-ID: <1446650544-24411-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbbKDPWb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 4 Nov 2015 10:22:31 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

Registering a bcache can actually fail for some reasons, but register_bdev()
assumes it to go all well. Make register_bdev() return errors to it's caller
register_bcache().

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/md/bcache/super.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 679a093..76aea03 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1126,7 +1126,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
 
 /* Cached device - bcache superblock */
 
-static void register_bdev(struct cache_sb *sb, struct page *sb_page,
+static int register_bdev(struct cache_sb *sb, struct page *sb_page,
 				 struct block_device *bdev,
 				 struct cached_dev *dc)
 {
@@ -1157,17 +1157,25 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	pr_info("registered backing device %s", bdevname(bdev, name));
 
 	list_add(&dc->list, &uncached_devices);
-	list_for_each_entry(c, &bch_cache_sets, list)
-		bch_cached_dev_attach(dc, c);
+	list_for_each_entry(c, &bch_cache_sets, list) {
+		int ret;
+
+		ret = bch_cached_dev_attach(dc, c);
+		if (ret)
+			goto err;
+	}
 
 	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
 	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE)
 		bch_cached_dev_run(dc);
+	else
+		goto err;
 
-	return;
+	return 0;
 err:
 	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
 	bcache_device_stop(&dc->disk);
+	return 1;
 }
 
 /* Flash only volumes */
@@ -1946,13 +1954,16 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		goto err_close;
 
 	if (SB_IS_BDEV(sb)) {
+		int ret;
 		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 		if (!dc)
 			goto err_close;
 
 		mutex_lock(&bch_register_lock);
-		register_bdev(sb, sb_page, bdev, dc);
+		ret = register_bdev(sb, sb_page, bdev, dc);
 		mutex_unlock(&bch_register_lock);
+		if (ret)
+			goto err_close;
 	} else {
 		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 		if (!ca)
-- 
2.6.2
