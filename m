From: tang.junhui@zte.com.cn
Subject: [PATCH 1/2] bcache: name bcache devices in an ordered sequence as bcache0, bcache1
Date: Mon, 10 Apr 2017 16:36:37 +0800
Message-ID: <1491813398-7344-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx7.zte.com.cn ([202.103.147.169]:60449 "EHLO mx7.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752078AbdDJIoj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Apr 2017 04:44:39 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, "tang.junhui" <tang.junhui@zte.com.cn>

From: "tang.junhui" <tang.junhui@zte.com.cn>

Currently, names of bcache devices displayed as bcache0, bcache16,
bcache32, etc. This patch changes their names as bcache0, bcache1,
bcache2, etc.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3a19cbc..867d9a9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -793,7 +793,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	}
 
 	set_capacity(d->disk, sectors);
-	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor);
+	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor / BCACHE_MINORS);
 
 	d->disk->major		= bcache_major;
 	d->disk->first_minor	= minor;
-- 
2.8.1.windows.1
