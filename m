From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: [PATCH 1/3] bcache: drop obsolete comments
Date: Sat, 27 Jul 2019 18:19:57 +0800
Message-ID: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, baiyaowei@cmss.chinamobile.com
List-Id: linux-bcache@vger.kernel.org

Unused list was killed by commit 2531d9ee61fa ("bcache: Kill unused freelist")
but left these comments, let's drop them.

This patch doesn't introduce functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
---
 drivers/md/bcache/alloc.c | 13 +++----------
 drivers/md/bcache/super.c |  3 ---
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 6f77682..c22c260 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -33,13 +33,6 @@
  * If we've got discards enabled, that happens when a bucket moves from the
  * free_inc list to the free list.
  *
- * There is another freelist, because sometimes we have buckets that we know
- * have nothing pointing into them - these we can reuse without waiting for
- * priorities to be rewritten. These come from freed btree nodes and buckets
- * that garbage collection discovered no longer had valid keys pointing into
- * them (because they were overwritten). That's the unused list - buckets on the
- * unused list move to the free list, optionally being discarded in the process.
- *
  * It's also important to ensure that gens don't wrap around - with respect to
  * either the oldest gen in the btree or the gen on disk. This is quite
  * difficult to do in practice, but we explicitly guard against it anyways - if
@@ -323,9 +316,9 @@ static int bch_allocator_thread(void *arg)
 
 	while (1) {
 		/*
-		 * First, we pull buckets off of the unused and free_inc lists,
-		 * possibly issue discards to them, then we add the bucket to
-		 * the free list:
+		 * First, we pull buckets off of the free_inc list, possibly
+		 * issue discards to them, then we add the bucket to the free
+		 * list:
 		 */
 		while (1) {
 			long bucket;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 26e374f..eba38aa 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -544,9 +544,6 @@ void bch_prio_write(struct cache *ca)
 	atomic_long_add(ca->sb.bucket_size * prio_buckets(ca),
 			&ca->meta_sectors_written);
 
-	//pr_debug("free %zu, free_inc %zu, unused %zu", fifo_used(&ca->free),
-	//	 fifo_used(&ca->free_inc), fifo_used(&ca->unused));
-
 	for (i = prio_buckets(ca) - 1; i >= 0; --i) {
 		long bucket;
 		struct prio_set *p = ca->disk_buckets;
-- 
1.8.3.1
