From: shile.zhang@linux.alibaba.com
Subject: [PATCH] bcache: add cond_resched() in __bch_cache_cmp()
Date: Thu,  7 Mar 2019 13:15:28 +0800
Message-ID: <1551935728-243664-1-git-send-email-shile.zhang@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Shile Zhang <shile.zhang@linux.alibaba.com>
List-Id: linux-bcache@vger.kernel.org

From: Shile Zhang <shile.zhang@linux.alibaba.com>

Read /sys/fs/bcache/<uuid>/cacheN/priority_stats can take very long
time with huge cache after long run.

Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
---
 drivers/md/bcache/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 557a8a3..028fea1 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -897,6 +897,7 @@ static void bch_cache_set_internal_release(struct kobject *k)
 
 static int __bch_cache_cmp(const void *l, const void *r)
 {
+	cond_resched();
 	return *((uint16_t *)r) - *((uint16_t *)l);
 }
 
-- 
1.8.3.1
