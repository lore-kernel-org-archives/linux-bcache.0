From: Dongbo Cao <cdbdyx@163.com>
Subject: [PATCH] add label interface for cache device in sysfs
Date: Fri, 14 Sep 2018 17:51:20 +0800
Message-ID: <20180914095120.2699-1-cdbdyx@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Dongbo Cao <cdbdyx@163.com>
List-Id: linux-bcache@vger.kernel.org

label interface will be called by bcache tools in user space.

Signed-off-by: Dongbo Cao <cdbdyx@163.com>
---
 drivers/md/bcache/sysfs.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 225b15aa..e64c718f 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -950,6 +950,13 @@ SHOW(__bch_cache)
 		return ret;
 	}
 
+	if (attr == &sysfs_label) {
+		memcpy(buf, ca->sb.label, SB_LABEL_SIZE);
+		buf[SB_LABEL_SIZE + 1] = '\0';
+		strcat(buf, "\n");
+		return strlen(buf);
+	}
+
 	return 0;
 }
 SHOW_LOCKED(bch_cache)
@@ -993,6 +1000,17 @@ STORE(__bch_cache)
 		atomic_set(&ca->io_errors, 0);
 	}
 
+	if (attr == &sysfs_label) {
+		if (size > SB_LABEL_SIZE)
+			return -EINVAL;
+		memcpy(ca->sb.label, buf, size);
+		if (size < SB_LABEL_SIZE)
+			ca->sb.label[size] = '\0';
+		if (size && ca->sb.label[size - 1] == '\n')
+			ca->sb.label[size - 1] = '\0';
+		bcache_write_super(ca->set);
+	}
+
 	return size;
 }
 STORE_LOCKED(bch_cache)
@@ -1009,6 +1027,7 @@ static struct attribute *bch_cache_files[] = {
 	&sysfs_io_errors,
 	&sysfs_clear_stats,
 	&sysfs_cache_replacement_policy,
+	&sysfs_label,
 	NULL
 };
 KTYPE(bch_cache);
-- 
2.17.1
