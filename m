From: Yijing Wang <wangyijing@huawei.com>
Subject: [UPDATE][PATCH 3/3] bcache: Remove redundant block_size assignment
Date: Wed, 11 May 2016 14:02:04 +0800
Message-ID: <1462946524-11639-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:4693 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbcEKF4C (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 May 2016 01:56:02 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>

We have assigned sb->block_size before the switch,
so remove the redundant one.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/md/bcache/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1ccb9be..64d0be6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -134,7 +134,6 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	case BCACHE_SB_VERSION_CDEV:
 	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
 		sb->nbuckets	= le64_to_cpu(s->nbuckets);
-		sb->block_size	= le16_to_cpu(s->block_size);
 		sb->bucket_size	= le16_to_cpu(s->bucket_size);
 
 		sb->nr_in_set	= le16_to_cpu(s->nr_in_set);
-- 
1.7.1
