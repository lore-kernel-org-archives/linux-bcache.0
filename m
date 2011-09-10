From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: [PATCH 6/7] Temporary fix to pr_latency()
Date: Sat, 10 Sep 2011 14:45:38 +0100
Message-ID: <1315662339-3115-6-git-send-email-mark@pogo.org.uk>
References: <1109101110320.2733@stax.localdomain>
 <1315662339-3115-1-git-send-email-mark@pogo.org.uk>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315662339-3115-1-git-send-email-mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

The following compile errors are caused by pr_latency (gcc 4.5.2):

  block/bcache.c: In function 'fill_bucket_work':
  block/bcache.c:2510:2: error: initializer element is not constant
  block/bcache.c:2510:2: error: (near initialization for '_rs.lock')
  [...]

This is caused by printk_ratelimited() when compiled with --std=gnu99.
Although it is not clear why; the pre-processed code seems to be
constant. Perhaps this is even a bug in GCC.

This patch fixes the build in this case, by using regular printk
instead.

But the correct fix is to remove the specialised compile flag on bcache
code. It is mainly required by variables initialised in for loops.
---
 block/bcache_util.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bcache_util.h b/block/bcache_util.h
index 872ca56..c7e72d0 100644
--- a/block/bcache_util.h
+++ b/block/bcache_util.h
@@ -414,7 +414,7 @@ extern unsigned latency_warn_ms;
 do {									\
 	int _ms = jiffies_to_msecs(jiffies - (j));			\
 	if (j && latency_warn_ms && (_ms) > (int) latency_warn_ms)	\
-		printk_ratelimited(KERN_DEBUG "bcache: %i ms latency "	\
+		printk(KERN_DEBUG "bcache: %i ms latency "		\
 			"called from %pf for " fmt "\n", _ms,		\
 		       __builtin_return_address(0), ##__VA_ARGS__);	\
 } while (0)
-- 
1.7.4.4
