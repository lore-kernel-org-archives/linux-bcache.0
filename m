From: Joshua Schmid <jschmid@suse.com>
Subject: [PATCH] fix a leak in bch_cached_dev_run()
Date: Tue,  3 Feb 2015 12:24:06 +0100
Message-ID: <1422962646-26462-1-git-send-email-jschmid@suse.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbbBCLYJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 3 Feb 2015 06:24:09 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Al Viro <viro@zeniv.linux.org.uk>

From: Al Viro <viro@ZenIV.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Joshua Schmid <jschmid@suse.com>
---
 drivers/md/bcache/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8c2d657..53f1512 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -880,8 +880,11 @@ void bch_cached_dev_run(struct cached_dev *dc)
 	buf[SB_LABEL_SIZE] = '\0';
 	env[2] = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf);
 
-	if (atomic_xchg(&dc->running, 1))
+	if (atomic_xchg(&dc->running, 1)) {
+		kfree(env[1]);
+		kfree(env[2]);
 		return;
+	}
 
 	if (!d->c &&
 	    BDEV_STATE(&dc->sb) != BDEV_STATE_NONE) {
-- 
2.1.2
