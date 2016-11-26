From: Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH] Avoid nested function definition
Date: Sat, 26 Nov 2016 17:24:15 -0500
Message-ID: <20161126222415.13404-1-pefoley2@pefoley.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33651 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbcKZWYU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 26 Nov 2016 17:24:20 -0500
Received: by mail-qt0-f180.google.com with SMTP id p16so92382494qta.0
        for <linux-bcache@vger.kernel.org>; Sat, 26 Nov 2016 14:24:20 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-kernel@vger.kernel.org, kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>

Fixes below error with clang:
../drivers/md/bcache/sysfs.c:759:3: error: function definition is not allowed here
                {       return *((uint16_t *) r) - *((uint16_t *) l); }
                ^
../drivers/md/bcache/sysfs.c:789:32: error: use of undeclared identifier 'cmp'
                sort(p, n, sizeof(uint16_t), cmp, NULL);
                                             ^
2 errors generated.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 drivers/md/bcache/sysfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b3ff57d61dde..22ac9e6676a0 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -731,6 +731,11 @@ static struct attribute *bch_cache_set_internal_files[] = {
 };
 KTYPE(bch_cache_set_internal);
 
+static int cmp(const void *l, const void *r)
+{
+	return *((uint16_t *)r) - *((uint16_t *)l);
+}
+
 SHOW(__bch_cache)
 {
 	struct cache *ca = container_of(kobj, struct cache, kobj);
@@ -755,9 +760,6 @@ SHOW(__bch_cache)
 					       CACHE_REPLACEMENT(&ca->sb));
 
 	if (attr == &sysfs_priority_stats) {
-		int cmp(const void *l, const void *r)
-		{	return *((uint16_t *) r) - *((uint16_t *) l); }
-
 		struct bucket *b;
 		size_t n = ca->sb.nbuckets, i;
 		size_t unused = 0, available = 0, dirty = 0, meta = 0;
-- 
2.11.0.rc2
