From: Coly Li <colyli@suse.de>
Subject: [PATCH 07/12] bcache: Correct return value for sysfs attach errors
Date: Wed,  6 Sep 2017 14:25:57 +0800
Message-ID: <20170906062602.50497-8-colyli@suse.de>
References: <20170906062602.50497-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170906062602.50497-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk
Cc: bcache@lists.ewheeler.net, Tony Asleson <tasleson@redhat.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Tony Asleson <tasleson@redhat.com>

If you encounter any errors in bch_cached_dev_attach it will return
a negative error code.  The variable 'v' which stores the result is
unsigned, thus user space sees a very large value returned for bytes
written which can cause incorrect user space behavior.  Utilize 1
signed variable to use throughout the function to preserve error return
capability.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
Acked-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 09295c07ea88..104c57cd666c 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -192,7 +192,7 @@ STORE(__cached_dev)
 {
 	struct cached_dev *dc = container_of(kobj, struct cached_dev,
 					     disk.kobj);
-	unsigned v = size;
+	ssize_t v = size;
 	struct cache_set *c;
 	struct kobj_uevent_env *env;
 
@@ -227,7 +227,7 @@ STORE(__cached_dev)
 		bch_cached_dev_run(dc);
 
 	if (attr == &sysfs_cache_mode) {
-		ssize_t v = bch_read_string_list(buf, bch_cache_modes + 1);
+		v = bch_read_string_list(buf, bch_cache_modes + 1);
 
 		if (v < 0)
 			return v;
-- 
2.13.5
