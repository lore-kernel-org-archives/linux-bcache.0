From: Stefan Bader <stefan.bader@canonical.com>
Subject: [PATCH] bcache: Fix bcache device names
Date: Thu,  2 Mar 2017 12:11:55 +0100
Message-ID: <1488453115-17245-1-git-send-email-stefan.bader@canonical.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52653 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdCBMGm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Mar 2017 07:06:42 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Wheeler <bcache@linux.ewheeler.net>

When adding partition support to bcache, the name assignment was not
updated, resulting in numbers jumping (bcache0, bcache16, bcache32...).
Fix this by taking BCACHE_MINORS into account when assigning the disk
name.

BugLink: https://bugs.launchpad.net/bugs/1667078

Fixes: b8c0d91 (bcache: partition support: add 16 minors per bcacheN device)
Cc: <stable@vger.kernel.org> # v4.10
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 85e3f21..817e155 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -793,7 +793,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	}
 
 	set_capacity(d->disk, sectors);
-	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor);
+	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i",
+		 minor / BCACHE_MINORS);
 
 	d->disk->major		= bcache_major;
 	d->disk->first_minor	= minor;
-- 
2.7.4
