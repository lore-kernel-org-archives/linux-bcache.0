From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH] bcache: Fix building error on MIPS
Date: Thu, 16 Nov 2017 11:06:13 +0800
Message-ID: <1510801573-17878-1-git-send-email-chenhc@lemote.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

This patch try to fix the building error on MIPS. The reason is MIPS
has already defined the PTR macro, which conflicts with the PTR macro
in include/uapi/linux/bcache.h.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/md/bcache/alloc.c   | 2 +-
 drivers/md/bcache/extents.c | 2 +-
 drivers/md/bcache/journal.c | 2 +-
 include/uapi/linux/bcache.h | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index a27d852..a0cc1bc 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -490,7 +490,7 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned reserve,
 		if (b == -1)
 			goto err;
 
-		k->ptr[i] = PTR(ca->buckets[b].gen,
+		k->ptr[i] = MAKE_PTR(ca->buckets[b].gen,
 				bucket_to_sector(c, b),
 				ca->sb.nr_this_dev);
 
diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index 41c238f..f9d3917 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -585,7 +585,7 @@ static bool bch_extent_merge(struct btree_keys *bk, struct bkey *l, struct bkey
 		return false;
 
 	for (i = 0; i < KEY_PTRS(l); i++)
-		if (l->ptr[i] + PTR(0, KEY_SIZE(l), 0) != r->ptr[i] ||
+		if (l->ptr[i] + MAKE_PTR(0, KEY_SIZE(l), 0) != r->ptr[i] ||
 		    PTR_BUCKET_NR(b->c, l, i) != PTR_BUCKET_NR(b->c, r, i))
 			return false;
 
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 02a98dd..03cc072 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -507,7 +507,7 @@ static void journal_reclaim(struct cache_set *c)
 			continue;
 
 		ja->cur_idx = next;
-		k->ptr[n++] = PTR(0,
+		k->ptr[n++] = MAKE_PTR(0,
 				  bucket_to_sector(c, ca->sb.d[ja->cur_idx]),
 				  ca->sb.nr_this_dev);
 	}
diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 90fc490..5cc599c 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -91,7 +91,7 @@ PTR_FIELD(PTR_GEN,			0,  8)
 
 #define PTR_CHECK_DEV			((1 << PTR_DEV_BITS) - 1)
 
-#define PTR(gen, offset, dev)						\
+#define MAKE_PTR(gen, offset, dev)						\
 	((((__u64) dev) << 51) | ((__u64) offset) << 8 | gen)
 
 /* Bkey utility code */
-- 
2.7.0
