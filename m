From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] bcache: register_quiet should still report errors
Date: Tue, 27 Aug 2013 00:31:46 +0200
Message-ID: <1377556306-29938-1-git-send-email-g2p.code@gmail.com>
References: <521BD3C0.9070209@gmail.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521BD3C0.9070209-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

register_quiet should still report all errors except
"device already registered".

Before this some potential errors would be silenced.

Signed-off-by: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/md/bcache/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a41c681..c3a3dc8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1901,14 +1901,17 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
 				  sb);
 	if (IS_ERR(bdev)) {
 		if (bdev == ERR_PTR(-EBUSY)) {
 			bdev = lookup_bdev(strim(path));
-			if (!IS_ERR(bdev) && bch_is_open(bdev))
+			if (!IS_ERR(bdev) && bch_is_open(bdev)) {
+				if (attr == &ksysfs_register_quiet)
+					goto out;
 				err = "device already registered";
-			else
+			} else {
 				err = "device busy";
+			}
 		}
 		goto err;
 	}
 
 	err = "failed to set blocksize";
@@ -1942,12 +1945,11 @@ out:
 	return ret;
 
 err_close:
 	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 err:
-	if (attr != &ksysfs_register_quiet)
-		pr_info("error opening %s: %s", path, err);
+	pr_info("error opening %s: %s", path, err);
 	ret = -EINVAL;
 	goto out;
 }
 
 static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
-- 
1.8.4.rc0.5.g48765cc
