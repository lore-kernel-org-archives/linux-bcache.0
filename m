From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 7/8] bcache: return attach error when no cache set exist
Date: Wed,  7 Feb 2018 11:41:45 -0800
Message-ID: <20180207194146.5095-8-mlyle@lyle.org>
References: <20180207194146.5095-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:40068 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754355AbeBGTmG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Feb 2018 14:42:06 -0500
Received: by mail-pg0-f67.google.com with SMTP id g2so696014pgn.7
        for <linux-bcache@vger.kernel.org>; Wed, 07 Feb 2018 11:42:06 -0800 (PST)
In-Reply-To: <20180207194146.5095-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Tang Junhui <tang.junhui@zte.com.cn>

From: Tang Junhui <tang.junhui@zte.com.cn>

I attach a back-end device to a cache set, and the cache set is not
registered yet, this back-end device did not attach successfully, and no
error returned:
[root]# echo 87859280-fec6-4bcc-20df7ca8f86b > /sys/block/sde/bcache/attach
[root]#

In sysfs_attach(), the return value "v" is initialized to "size" in
the beginning, and if no cache set exist in bch_cache_sets, the "v" value
would not change any more, and return to sysfs, sysfs regard it as success
since the "size" is a positive number.

This patch fixes this issue by assigning "v" with "-ENOENT" in the
initialization.

Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 4a6a697e1680..a7552f509f50 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -198,7 +198,7 @@ STORE(__cached_dev)
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
-	ssize_t v = size;
+	ssize_t v;
 	struct cache_set *c;
 	struct kobj_uevent_env *env;
 
@@ -275,6 +275,7 @@ STORE(__cached_dev)
 		if (bch_parse_uuid(buf, dc->sb.set_uuid) < 16)
 			return -EINVAL;
 
+		v = -ENOENT;
 		list_for_each_entry(c, &bch_cache_sets, list) {
 			v = bch_cached_dev_attach(dc, c);
 			if (!v)
@@ -282,7 +283,7 @@ STORE(__cached_dev)
 		}
 
 		pr_err("Can't attach %s: cache set not found", buf);
-		size = v;
+		return v;
 	}
 
 	if (attr == &sysfs_detach && dc->disk.c)
-- 
2.14.1
