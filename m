From: Coly Li <colyli@suse.de>
Subject: [PATCH 01/10] bcache: do not check return value of debugfs_create_dir()
Date: Thu,  9 Aug 2018 15:48:42 +0800
Message-ID: <20180809074851.11027-2-colyli@suse.de>
References: <20180809074851.11027-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180809074851.11027-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, stable@vger.kernel.org, Kai Krakow <kai@kaishome.de>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Greg KH suggests that normal code should not care about debugfs. Therefore
no matter successful or failed of debugfs_create_dir() execution, it is
unncessary to check its return value.

There are two functions called debugfs_create_dir() and check the return
value, which are bch_debug_init() and closure_debug_init(). This patch
changes these two functions from int to void type, and ignore return values
of debugfs_create_dir().

This patch does not fix exact bug, just makes things work as they should.

Signed-off-by: Coly Li <colyli@suse.de>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Cc: Kai Krakow <kai@kaishome.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/bcache/bcache.h  |  2 +-
 drivers/md/bcache/closure.c | 13 +++++++++----
 drivers/md/bcache/closure.h |  4 ++--
 drivers/md/bcache/debug.c   | 11 ++++++-----
 drivers/md/bcache/super.c   |  4 +++-
 5 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 872ef4d67711..0a3e82b0876d 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1001,7 +1001,7 @@ void bch_open_buckets_free(struct cache_set *);
 int bch_cache_allocator_start(struct cache *ca);
 
 void bch_debug_exit(void);
-int bch_debug_init(struct kobject *);
+void bch_debug_init(struct kobject *kobj);
 void bch_request_exit(void);
 int bch_request_init(void);
 
diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 0e14969182c6..618253683d40 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -199,11 +199,16 @@ static const struct file_operations debug_ops = {
 	.release	= single_release
 };
 
-int __init closure_debug_init(void)
+void  __init closure_debug_init(void)
 {
-	closure_debug = debugfs_create_file("closures",
-				0400, bcache_debug, NULL, &debug_ops);
-	return IS_ERR_OR_NULL(closure_debug);
+	if (!IS_ERR_OR_NULL(bcache_debug))
+		/*
+		 * it is unnecessary to check return value of
+		 * debugfs_create_file(), we should not care
+		 * about this.
+		 */
+		closure_debug = debugfs_create_file(
+			"closures", 0400, bcache_debug, NULL, &debug_ops);
 }
 #endif
 
diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 71427eb5fdae..7c2c5bc7c88b 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -186,13 +186,13 @@ static inline void closure_sync(struct closure *cl)
 
 #ifdef CONFIG_BCACHE_CLOSURES_DEBUG
 
-int closure_debug_init(void);
+void closure_debug_init(void);
 void closure_debug_create(struct closure *cl);
 void closure_debug_destroy(struct closure *cl);
 
 #else
 
-static inline int closure_debug_init(void) { return 0; }
+static inline void closure_debug_init(void) {}
 static inline void closure_debug_create(struct closure *cl) {}
 static inline void closure_debug_destroy(struct closure *cl) {}
 
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 04d146711950..12034c07257b 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -252,11 +252,12 @@ void bch_debug_exit(void)
 		debugfs_remove_recursive(bcache_debug);
 }
 
-int __init bch_debug_init(struct kobject *kobj)
+void __init bch_debug_init(struct kobject *kobj)
 {
-	if (!IS_ENABLED(CONFIG_DEBUG_FS))
-		return 0;
-
+	/*
+	 * it is unnecessary to check return value of
+	 * debugfs_create_file(), we should not care
+	 * about this.
+	 */
 	bcache_debug = debugfs_create_dir("bcache", NULL);
-	return IS_ERR_OR_NULL(bcache_debug);
 }
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e0a92104ca23..c7ffa6ef3f82 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2345,10 +2345,12 @@ static int __init bcache_init(void)
 		goto err;
 
 	if (bch_request_init() ||
-	    bch_debug_init(bcache_kobj) || closure_debug_init() ||
 	    sysfs_create_files(bcache_kobj, files))
 		goto err;
 
+	bch_debug_init(bcache_kobj);
+	closure_debug_init();
+
 	return 0;
 err:
 	bcache_exit();
-- 
2.18.0
