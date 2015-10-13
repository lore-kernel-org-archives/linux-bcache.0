From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 2/7] block_dev: Check permissions towards block device inode when mounting
Date: Tue, 13 Oct 2015 12:04:15 -0500
Message-ID: <1444755861-54997-3-git-send-email-seth.forshee@canonical.com>
References: <1444755861-54997-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36785 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbbJMRF1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 13 Oct 2015 13:05:27 -0400
Received: by ioii196 with SMTP id i196so27954150ioi.3
        for <linux-bcache@vger.kernel.org>; Tue, 13 Oct 2015 10:05:26 -0700 (PDT)
In-Reply-To: <1444755861-54997-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

Unprivileged users should not be able to mount block devices when
they lack sufficient privileges towards the block device inode.
Update blkdev_get_by_path() to validate that the user has the
required access to the inode at the specified path. The check
will be skipped for CAP_SYS_ADMIN, so privileged mounts will
continue working as before.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/block_dev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index f1f0aa7214a3..54d94cd64577 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1394,9 +1394,14 @@ struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
 					void *holder)
 {
 	struct block_device *bdev;
+	int perm = 0;
 	int err;
 
-	bdev = lookup_bdev(path, 0);
+	if (mode & FMODE_READ)
+		perm |= MAY_READ;
+	if (mode & FMODE_WRITE)
+		perm |= MAY_WRITE;
+	bdev = lookup_bdev(path, perm);
 	if (IS_ERR(bdev))
 		return bdev;
 
-- 
1.9.1
