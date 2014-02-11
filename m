From: "Darrick J. Wong" <kmo@daterainc.com>
Subject: [PATCH] bcache: fix BUG_ON due to integer overflow with
 GC_SECTORS_USED
Date: Tue, 11 Feb 2014 10:02:57 -0800
Message-ID: <20140211180257.GA26313@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

The BUG_ON at the end of __bch_btree_mark_key can be triggered due to
an integer overflow error:

BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, 13);
...
SET_GC_SECTORS_USED(g, min_t(unsigned,
	     GC_SECTORS_USED(g) + KEY_SIZE(k),
	     (1 << 14) - 1));
BUG_ON(!GC_SECTORS_USED(g));

In bcache.h, the SECTORS_USED bitfield is defined to be 13 bits wide.
While the SET_ code tries to ensure that the field doesn't overflow by
clamping it to (1<<14)-1 == 16383, this is incorrect because 16383
requires 14 bits.  Therefore, if GC_SECTORS_USED() + KEY_SIZE() =
8192, the SET_ statement tries to store 8192 into a 13-bit field.  In
a 13-bit field, 8192 becomes zero, thus triggering the BUG_ON.

Therefore, create a field width constant and a max value constant, and
use those to create the bitfield and check the inputs to
SET_GC_SECTORS_USED.  Arguably the BITMASK() template ought to have
BUG_ON checks for too-large values, but that's a separate patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
Greg, stable team et. all - can you apply this asap to 3.13? It hasn't hit
Linus's tree yet (it's on its way via Jens), but multiple users are hitting this
BUG_ON() and the fix has been tested.

 drivers/md/bcache/bcache.h | 4 +++-
 drivers/md/bcache/btree.c  | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 0c707e4f4e..a4c7306ff4 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -210,7 +210,9 @@ BITMASK(GC_MARK,	 struct bucket, gc_mark, 0, 2);
 #define GC_MARK_RECLAIMABLE	0
 #define GC_MARK_DIRTY		1
 #define GC_MARK_METADATA	2
-BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, 13);
+#define GC_SECTORS_USED_SIZE	13
+#define MAX_GC_SECTORS_USED	(~(~0ULL << GC_SECTORS_USED_SIZE))
+BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, GC_SECTORS_USED_SIZE);
 BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);
 
 #include "journal.h"
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 98cc0a810a..7d421180b6 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1167,7 +1167,7 @@ uint8_t __bch_btree_mark_key(struct cache_set *c, int level, struct bkey *k)
 		/* guard against overflow */
 		SET_GC_SECTORS_USED(g, min_t(unsigned,
 					     GC_SECTORS_USED(g) + KEY_SIZE(k),
-					     (1 << 14) - 1));
+					     MAX_GC_SECTORS_USED));
 
 		BUG_ON(!GC_SECTORS_USED(g));
 	}
-- 
1.9.0.rc3
