From: Dongbo Cao <cdbdyx@163.com>
Subject: [PATCH] use STORE_LOCKED instead of STORE macro
Date: Thu, 27 Sep 2018 13:31:42 +0800
Message-ID: <20180927053142.4529-1-cdbdyx@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Dongbo Cao <cdbdyx@163.com>
List-Id: linux-bcache@vger.kernel.org

merge sysfs_writeback_running attr and sysfs_writeback_percent attr together with other attrs of cached_dev.

Signed-off-by: Dongbo Cao <cdbdyx@163.com>
---
 drivers/md/bcache/sysfs.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 26f035a0..14fc9104 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -245,7 +245,7 @@ SHOW(__bch_cached_dev)
 }
 SHOW_LOCKED(bch_cached_dev)
 
-STORE(__cached_dev)
+STORE(__bch_cached_dev)
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
@@ -373,17 +373,6 @@ STORE(__cached_dev)
 	if (attr == &sysfs_stop)
 		bcache_device_stop(&dc->disk);
 
-	return size;
-}
-
-STORE(bch_cached_dev)
-{
-	struct cached_dev *dc = container_of(kobj, struct cached_dev,
-					     disk.kobj);
-
-	mutex_lock(&bch_register_lock);
-	size = __cached_dev_store(kobj, attr, buf, size);
-
 	if (attr == &sysfs_writeback_running)
 		bch_writeback_queue(dc);
 
@@ -392,9 +381,9 @@ STORE(bch_cached_dev)
 			schedule_delayed_work(&dc->writeback_rate_update,
 				      dc->writeback_rate_update_seconds * HZ);
 
-	mutex_unlock(&bch_register_lock);
 	return size;
 }
+STORE_LOCKED(bch_cached_dev)
 
 static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_attach,
-- 
2.17.1
