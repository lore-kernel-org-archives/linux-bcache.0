From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] bcache: use kmemdup_nul for CACHED_LABEL buffer
Date: Wed, 30 Jan 2019 17:29:18 +0800
Message-ID: <04ff7c6d5cdd8b389d471989704c2f9dc3def554.1548840161.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

This patch uses kmemdup_nul to create a NUL-terminated string from
dc->sb.label. This is better than open coding it.

With this, we can move env[2] initialization into env[] array to make
code more elegant.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/md/bcache/super.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4dee119c3664..84ab241c8516 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -906,21 +906,18 @@ static int cached_dev_status_update(void *arg)
 void bch_cached_dev_run(struct cached_dev *dc)
 {
 	struct bcache_device *d = &dc->disk;
-	char buf[SB_LABEL_SIZE + 1];
+	char *buf = kmemdup_nul(dc->sb.label, SB_LABEL_SIZE, GFP_KERNEL);
 	char *env[] = {
 		"DRIVER=bcache",
 		kasprintf(GFP_KERNEL, "CACHED_UUID=%pU", dc->sb.uuid),
-		NULL,
+		kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf ? : ""),
 		NULL,
 	};
 
-	memcpy(buf, dc->sb.label, SB_LABEL_SIZE);
-	buf[SB_LABEL_SIZE] = '\0';
-	env[2] = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf);
-
 	if (atomic_xchg(&dc->running, 1)) {
 		kfree(env[1]);
 		kfree(env[2]);
+		kfree(buf);
 		return;
 	}
 
@@ -944,6 +941,7 @@ void bch_cached_dev_run(struct cached_dev *dc)
 	kobject_uevent_env(&disk_to_dev(d->disk)->kobj, KOBJ_CHANGE, env);
 	kfree(env[1]);
 	kfree(env[2]);
+	kfree(buf);
 
 	if (sysfs_create_link(&d->kobj, &disk_to_dev(d->disk)->kobj, "dev") ||
 	    sysfs_create_link(&disk_to_dev(d->disk)->kobj, &d->kobj, "bcache"))
-- 
2.17.1
