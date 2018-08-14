From: Dongbo Cao <cdbdyx@163.com>
Subject: [PATCH 2/2] bcache: add undef for macro in function
Date: Tue, 14 Aug 2018 16:16:25 +0800
Message-ID: <20180814081625.12326-1-cdbdyx@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Dongbo Cao <cdbdyx@163.com>
List-Id: linux-bcache@vger.kernel.org

add undef for macro d_strtoul,d_strtoul_nonzero and d_strtoi_h

Signed-off-by: Dongbo Cao <cdbdyx@163.com>
---
 drivers/md/bcache/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 225b15aa..ed67a290 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -349,6 +349,9 @@ STORE(__cached_dev)
 	if (attr == &sysfs_stop)
 		bcache_device_stop(&dc->disk);
 
+#undef d_strtoul
+#undef d_strtoul_nonzero
+#undef d_strtoi_h
 	return size;
 }
 
-- 
2.17.1
