From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH] md/bcache: Remove NULL check.
Date: Mon, 13 Aug 2018 17:38:49 +0800
Message-ID: <1534153129-24869-1-git-send-email-fxinrong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Sean Fu <fxinrong@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Remove unnessesary NULL check before kmem_cache_destroy() in
drivers/md/bcache/request.c

Signed-off-by: Sean Fu <fxinrong@gmail.com>
---
 drivers/md/bcache/request.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index ae67f5f..0ddee35 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1306,8 +1306,7 @@ void bch_flash_dev_request_init(struct bcache_device *d)
 
 void bch_request_exit(void)
 {
-	if (bch_search_cache)
-		kmem_cache_destroy(bch_search_cache);
+	kmem_cache_destroy(bch_search_cache);
 }
 
 int __init bch_request_init(void)
-- 
2.6.2
