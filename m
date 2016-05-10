From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 1/3] bcache: Remove redundant parameter for cache_alloc()
Date: Tue, 10 May 2016 16:38:47 +0800
Message-ID: <1462869529-11293-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:25674 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbcEJIcy (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 10 May 2016 04:32:54 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>

Cache_sb is not used in cache_alloc, and we have copied
sb info to cache->sb already, remove it.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/md/bcache/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a296425..1ccb9be 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1803,7 +1803,7 @@ void bch_cache_release(struct kobject *kobj)
 	module_put(THIS_MODULE);
 }
 
-static int cache_alloc(struct cache_sb *sb, struct cache *ca)
+static int cache_alloc(struct cache *ca)
 {
 	size_t free;
 	struct bucket *b;
@@ -1858,7 +1858,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
 		ca->discard = CACHE_DISCARD(&ca->sb);
 
-	ret = cache_alloc(sb, ca);
+	ret = cache_alloc(ca);
 	if (ret != 0)
 		goto err;
 
-- 
1.7.1
