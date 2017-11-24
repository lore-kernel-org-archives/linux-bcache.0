From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH] bcache: check return value of register_shrinker
Date: Fri, 24 Nov 2017 12:18:14 -0800
Message-ID: <20171124201814.26173-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:37834 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753647AbdKXUSd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 15:18:33 -0500
Received: by mail-pl0-f65.google.com with SMTP id 61so4946444plf.4
        for <linux-bcache@vger.kernel.org>; Fri, 24 Nov 2017 12:18:33 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Michael Lyle <mlyle@lyle.org>

This is now __must_check, so this kills a warning.  Caller of
bch_btree_cache_alloc in super.c appropriately checks return value
so this is fully plumbed through.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/btree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 11c5503d31dc..0c2b77e0194b 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -807,7 +807,10 @@ int bch_btree_cache_alloc(struct cache_set *c)
 	c->shrink.scan_objects = bch_mca_scan;
 	c->shrink.seeks = 4;
 	c->shrink.batch = c->btree_pages * 2;
-	register_shrinker(&c->shrink);
+
+	if (register_shrinker(&c->shrink)) {
+		pr_warn("bcache: bch_btree_cache_alloc: could not register shrinker");
+	}
 
 	return 0;
 }
-- 
2.14.1
