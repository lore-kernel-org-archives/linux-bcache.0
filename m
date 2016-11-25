From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 1/2] bcache: Remove redundant set_capacity
Date: Fri, 25 Nov 2016 09:39:29 +0800
Message-ID: <1480037969-45042-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:40237 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750833AbcKYBho (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Nov 2016 20:37:44 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@fb.com, kent.overstreet@gmail.com
Cc: git@linux.ewheeler.net, colyli@suse.de, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>

set_capacity() has been called in bcache_device_init(),
remove the redundant one.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/md/bcache/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 849ad44..b638a16 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1126,9 +1126,6 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
 	if (ret)
 		return ret;
 
-	set_capacity(dc->disk.disk,
-		     dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
-
 	dc->disk.disk->queue->backing_dev_info.ra_pages =
 		max(dc->disk.disk->queue->backing_dev_info.ra_pages,
 		    q->backing_dev_info.ra_pages);
-- 
2.5.0
