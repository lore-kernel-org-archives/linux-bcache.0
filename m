From: Eric Wheeler <bcache@linux.ewheeler.net>
Subject: [PATCH] bcache: register_bcache(): call blkdev_put() when
 cache_alloc() fails
Date: Fri, 17 Jun 2016 15:01:54 -0700
Message-ID: <S1751103AbcFQW3k/20160617222940Z+635@vger.kernel.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:50071 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750840AbcFQW3k (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Jun 2016 18:29:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.ewheeler.net (Postfix) with ESMTP id 7F1ADA0F4B
	for <linux-bcache@vger.kernel.org>; Fri, 17 Jun 2016 15:29:39 -0700 (PDT)
Received: from mail.ewheeler.net ([127.0.0.1])
	by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id IU6zR1o-rBHy for <linux-bcache@vger.kernel.org>;
	Fri, 17 Jun 2016 15:29:39 -0700 (PDT)
Received: from 23-95-35-21-host.colocrossing.com (unknown [23.95.35.21])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ewheeler.net (Postfix) with ESMTPSA id 11251A0F4A
	for <linux-bcache@vger.kernel.org>; Fri, 17 Jun 2016 15:29:39 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

register_cache() is supposed to return an error string on error so that
register_bcache() will will blkdev_put and cleanup other user counters,
but it does not set 'char *err' when cache_alloc() fails (eg, due to
memory pressure) and thus register_bcache() performs no cleanup.

register_bcache() <----------\  <- no jump to err_close, no blkdev_put()
   |                         |
   +->register_cache()       |  <- fails to set char *err
         |                   |
         +->cache_alloc() ---/  <- returns error

This patch sets `char *err` for this failure case so that register_cache()
will cause register_bcache() to correctly jump to err_close and do
cleanup.

Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/super.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f5dbb4e..9191a3c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1842,7 +1842,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
-	const char *err = NULL;
+	const char *err = NULL; /* must be set for any error case */
 	int ret = 0;
 
 	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
@@ -1859,8 +1859,13 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 		ca->discard = CACHE_DISCARD(&ca->sb);
 
 	ret = cache_alloc(sb, ca);
-	if (ret != 0)
+	if (ret != 0) {
+		if (ret == -ENOMEM)
+			err = "cache_alloc(): -ENOMEM";
+		else
+			err = "cache_alloc(): unknown error";
 		goto err;
+	}
 
 	if (kobject_add(&ca->kobj, &part_to_dev(bdev->bd_part)->kobj, "bcache")) {
 		err = "error calling kobject_add";
-- 
1.8.3.1
