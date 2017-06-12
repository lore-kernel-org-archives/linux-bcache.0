From: Tony Asleson <tasleson@redhat.com>
Subject: [PATCH] bcache: Correct return value for sysfs attach errors
Date: Mon, 12 Jun 2017 16:18:26 -0500
Message-ID: <1497302306-17398-1-git-send-email-tasleson@redhat.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752491AbdFLVS2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Jun 2017 17:18:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B3AD80460
        for <linux-bcache@vger.kernel.org>; Mon, 12 Jun 2017 21:18:28 +0000 (UTC)
Received: from redhat.com (ovpn-116-136.phx2.redhat.com [10.3.116.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEC9A7EE01
        for <linux-bcache@vger.kernel.org>; Mon, 12 Jun 2017 21:18:27 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

If you encounter any errors in bch_cached_dev_attach it will return a negative
error code.  The variable 'v' which stores the result is unsigned, thus user
space sees a very large value returned for bytes written which can cause
incorrect user space behavior.  Utilize 1 signed variable to use throughout
the function to preserve error return capability.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/md/bcache/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index f90f136..ab2f8ce 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -192,7 +192,7 @@
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
-	unsigned v = size;
+	ssize_t v = size;
 	struct cache_set *c;
 	struct kobj_uevent_env *env;
 
@@ -227,7 +227,7 @@
 		bch_cached_dev_run(dc);
 
 	if (attr == &sysfs_cache_mode) {
-		ssize_t v = bch_read_string_list(buf, bch_cache_modes + 1);
+		v = bch_read_string_list(buf, bch_cache_modes + 1);
 
 		if (v < 0)
 			return v;
-- 
1.8.3.1
