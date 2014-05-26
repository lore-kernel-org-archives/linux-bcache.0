From: sp@datera.io
Subject: [PATCH] bcache: fix crash on shutdown in passthrough mode
Date: Mon, 26 May 2014 15:35:37 -0700
Message-ID: <1401143737-7724-1-git-send-email-sp@datera.io>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61967 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaEZWfy (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 26 May 2014 18:35:54 -0400
Received: by mail-pb0-f43.google.com with SMTP id up15so8231054pbc.30
        for <linux-bcache@vger.kernel.org>; Mon, 26 May 2014 15:35:54 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Slava Pestov <sp@daterainc.com>

From: Slava Pestov <sp@daterainc.com>

We never started the writeback thread in this case, so don't stop it.
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3ebe829..a417a2b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1073,7 +1073,8 @@ static void cached_dev_free(struct closure *cl)
 	struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
 
 	cancel_delayed_work_sync(&dc->writeback_rate_update);
-	kthread_stop(dc->writeback_thread);
+	if (!IS_ERR_OR_NULL(dc->writeback_thread))
+		kthread_stop(dc->writeback_thread);
 
 	mutex_lock(&bch_register_lock);
 
-- 
2.0.0.rc0
