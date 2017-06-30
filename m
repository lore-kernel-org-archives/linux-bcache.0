From: bcache@lists.ewheeler.net
Subject: [PATCH 14/19] bcache: Correct return value for sysfs attach errors
Date: Fri, 30 Jun 2017 13:43:03 -0700
Message-ID: <1498855388-16990-14-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tony Asleson <tasleson@redhat.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Tony Asleson <tasleson@redhat.com>

If you encounter any errors in bch_cached_dev_attach it will return a negative
error code.  The variable 'v' which stores the result is unsigned, thus user
space sees a very large value returned for bytes written which can cause
incorrect user space behavior.  Utilize 1 signed variable to use throughout
the function to preserve error return capability.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
Acked-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index cc0076d..7579ca6 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -206,7 +206,7 @@ STORE(__cached_dev)
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
-	unsigned v = size;
+	ssize_t v = size;
 	struct cache_set *c;
 	struct kobj_uevent_env *env;
 	unsigned ioprio_class = 0; /* invalid initial ioprio values */
@@ -245,7 +245,7 @@ STORE(__cached_dev)
 		bch_cached_dev_run(dc);
 
 	if (attr == &sysfs_cache_mode) {
-		ssize_t v = bch_read_string_list(buf, bch_cache_modes + 1);
+		v = bch_read_string_list(buf, bch_cache_modes + 1);
 
 		if (v < 0)
 			return v;
-- 
1.8.3.1
