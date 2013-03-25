From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] bcache: Build fixes from test robot
Date: Mon, 25 Mar 2013 11:46:43 -0700
Message-ID: <1364237204-5467-1-git-send-email-koverstreet@google.com>
References: <20130325135252.GC5401@kernel.dk>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130325135252.GC5401-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

config: make ARCH=i386 allmodconfig

All error/warnings:

   drivers/md/bcache/bset.c: In function 'bch_ptr_bad':
>> drivers/md/bcache/bset.c:164:2: warning: format '%li' expects argument of type 'long int', but argument 4 has type 'size_t' [-Wformat]
--
   drivers/md/bcache/debug.c: In function 'bch_pbtree':
>> drivers/md/bcache/debug.c:86:4: warning: format '%li' expects argument of type 'long int', but argument 4 has type 'size_t' [-Wformat]
--
   drivers/md/bcache/btree.c: In function 'bch_btree_read_done':
>> drivers/md/bcache/btree.c:245:8: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'size_t' [-Wformat]
--
   drivers/md/bcache/closure.o: In function `closure_debug_init':
>> (.init.text+0x0): multiple definition of `init_module'
>> drivers/md/bcache/super.o:super.c:(.init.text+0x0): first defined here

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/md/bcache/bset.c    | 2 +-
 drivers/md/bcache/btree.c   | 2 +-
 drivers/md/bcache/closure.c | 4 +---
 drivers/md/bcache/closure.h | 2 ++
 drivers/md/bcache/super.c   | 1 +
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index bb0f7ae..79fe1f0 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -161,7 +161,7 @@ bool bch_ptr_bad(struct btree *b, const struct bkey *k)
 #ifdef CONFIG_BCACHE_EDEBUG
 bug:
 	mutex_unlock(&b->c->bucket_lock);
-	btree_bug(b, "inconsistent pointer %s: bucket %li pin %i "
+	btree_bug(b, "inconsistent pointer %s: bucket %zu pin %i "
 		  "prio %i gen %i last_gc %i mark %llu gc_gen %i", pkey(k),
 		  PTR_BUCKET_NR(b->c, k, i), atomic_read(&g->pin),
 		  g->prio, g->gen, g->last_gc, GC_MARK(g), g->gc_gen);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index e7bc917..af9ea4a 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -240,7 +240,7 @@ out:
 	closure_return(cl);
 err:
 	set_btree_node_io_error(b);
-	bch_cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
+	bch_cache_set_error(b->c, "%s at bucket %zu, block %zu, %u keys",
 			    err, PTR_BUCKET_NR(b->c, &b->key, 0),
 			    index(i, b), i->keys);
 	goto out;
diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index d6fbec0..f54f7c9 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -334,14 +334,12 @@ static const struct file_operations debug_ops = {
 	.release	= single_release
 };
 
-int __init closure_debug_init(void)
+void __init closure_debug_init(void)
 {
 	debug = debugfs_create_file("closures", 0400, NULL, NULL, &debug_ops);
 	return 0;
 }
 
-module_init(closure_debug_init);
-
 #endif
 
 MODULE_AUTHOR("Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>");
diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 3f31d59..0003992 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -313,11 +313,13 @@ void __closure_flush_sync(struct closure *cl, struct timer_list *timer);
 
 #ifdef CONFIG_BCACHE_CLOSURES_DEBUG
 
+void closure_debug_init(void);
 void closure_debug_create(struct closure *cl);
 void closure_debug_destroy(struct closure *cl);
 
 #else
 
+static inline void closure_debug_init(void) {}
 static inline void closure_debug_create(struct closure *cl) {}
 static inline void closure_debug_destroy(struct closure *cl) {}
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 31ef47f..7b8efc7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1917,6 +1917,7 @@ static int __init bcache_init(void)
 	mutex_init(&bch_register_lock);
 	init_waitqueue_head(&unregister_wait);
 	register_reboot_notifier(&reboot);
+	closure_debug_init();
 
 	bcache_major = register_blkdev(0, "bcache");
 	if (bcache_major < 0)
-- 
1.8.1.3
