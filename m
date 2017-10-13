From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 01/15] bcache: Avoid nested function definition
Date: Fri, 13 Oct 2017 16:35:28 -0700
Message-ID: <20171013233542.20938-2-mlyle@lyle.org>
References: <20171013233542.20938-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:48286 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752468AbdJMXf6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 19:35:58 -0400
Received: by mail-pg0-f68.google.com with SMTP id v78so2336623pgb.5
        for <linux-bcache@vger.kernel.org>; Fri, 13 Oct 2017 16:35:58 -0700 (PDT)
In-Reply-To: <20171013233542.20938-1-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Peter Foley <pefoley2@pefoley.com>

From: Peter Foley <pefoley2@pefoley.com>

Fixes below error with clang:
../drivers/md/bcache/sysfs.c:759:3: error: function definition is not allowed here
                {       return *((uint16_t *) r) - *((uint16_t *) l); }
                ^
../drivers/md/bcache/sysfs.c:789:32: error: use of undeclared identifier 'cmp'
                sort(p, n, sizeof(uint16_t), cmp, NULL);
                                             ^
2 errors generated.

v2:
rename function to __bch_cache_cmp

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Reviewed-by: Coly Li <colyli@suse.de>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/sysfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 104c57cd666c..69f355b9650c 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -745,6 +745,11 @@ static struct attribute *bch_cache_set_internal_files[] = {
 };
 KTYPE(bch_cache_set_internal);
 
+static int __bch_cache_cmp(const void *l, const void *r)
+{
+	return *((uint16_t *)r) - *((uint16_t *)l);
+}
+
 SHOW(__bch_cache)
 {
 	struct cache *ca = container_of(kobj, struct cache, kobj);
@@ -769,9 +774,6 @@ SHOW(__bch_cache)
 					       CACHE_REPLACEMENT(&ca->sb));
 
 	if (attr == &sysfs_priority_stats) {
-		int cmp(const void *l, const void *r)
-		{	return *((uint16_t *) r) - *((uint16_t *) l); }
-
 		struct bucket *b;
 		size_t n = ca->sb.nbuckets, i;
 		size_t unused = 0, available = 0, dirty = 0, meta = 0;
@@ -800,7 +802,7 @@ SHOW(__bch_cache)
 			p[i] = ca->buckets[i].prio;
 		mutex_unlock(&ca->set->bucket_lock);
 
-		sort(p, n, sizeof(uint16_t), cmp, NULL);
+		sort(p, n, sizeof(uint16_t), __bch_cache_cmp, NULL);
 
 		while (n &&
 		       !cached[n - 1])
-- 
2.11.0
