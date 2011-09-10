From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: [PATCH 5/7] Allow closure debugging without CONFIG_DEBUG_FS
Date: Sat, 10 Sep 2011 14:45:37 +0100
Message-ID: <1315662339-3115-5-git-send-email-mark@pogo.org.uk>
References: <1109101110320.2733@stax.localdomain>
 <1315662339-3115-1-git-send-email-mark@pogo.org.uk>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315662339-3115-1-git-send-email-mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Fixes the build, although closure debugging is not much use without
it.
---
 block/bcache_util.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/bcache_util.c b/block/bcache_util.c
index 19846fb..b014e8c 100644
--- a/block/bcache_util.c
+++ b/block/bcache_util.c
@@ -531,7 +531,9 @@ module_exit(closure_debug_exit);
 static int __init closure_debug_init(void)
 {
 	spin_lock_init(&closure_lock);
+#ifdef CONFIG_DEBUG_FS
 	debug = debugfs_create_file("closures", 0400, NULL, NULL, &debug_ops);
+#endif
 	return 0;
 }
 
-- 
1.7.4.4
