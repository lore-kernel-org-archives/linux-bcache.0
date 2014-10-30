From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] fix a leak in bch_cached_dev_run()
Date: Thu, 30 Oct 2014 05:42:09 +0000
Message-ID: <20141030054208.GE7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:50701 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaJ3FmK (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 30 Oct 2014 01:42:10 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -878,8 +878,11 @@ void bch_cached_dev_run(struct cached_dev *dc)
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
