From: Christian Brunner <chb-h9bWGtP8wOw@public.gmane.org>
Subject: [PATCH] bcache: Move tracepoint symbols from bcache to bcache_util
Date: Fri, 30 Sep 2011 13:01:56 +0200
Message-ID: <20110930110156.GA6421@sir.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Tracepoint symbols bcache_start_closure_wait and bcache_end_closure_wait
should be defined in bcache_util. Otherwise we get an circular
dependency between bcache.ko and bcache_util.ko, when bcache is compiled
as a module with CONFIG_TRACEPOINT enabled.

Thanks,
Christian

Signed-off-by: Christian Brunner <chb-h9bWGtP8wOw@public.gmane.org>
---
 block/bcache.c      |    8 +-------
 block/bcache_util.c |    6 ++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/bcache.c b/block/bcache.c
index b58e3f1..58ebe25 100644
--- a/block/bcache.c
+++ b/block/bcache.c
@@ -813,16 +813,10 @@ struct search {
 const char *insert_types[] = {
 	"read", "write", NULL, "writeback",
 	"undirty", NULL, "replay"
-}
+};
 
 #define insert_type(s)	insert_types[(s)->insert_type]
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/bcache.h>
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_start_closure_wait);
-EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_end_closure_wait);
-
 static struct kobject *bcache_kobj;
 static struct mutex register_lock;
 static LIST_HEAD(uncached_devices);
diff --git a/block/bcache_util.c b/block/bcache_util.c
index 4104301..7da8ca8 100644
--- a/block/bcache_util.c
+++ b/block/bcache_util.c
@@ -10,6 +10,12 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>");
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/bcache.h>
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_start_closure_wait);
+EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_end_closure_wait);
+
 #define STRTO_H(name, type)					\
 int name ## _h(const char *cp, type *res)		        \
 {								\
-- 
1.7.1
