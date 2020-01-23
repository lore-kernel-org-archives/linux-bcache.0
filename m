From: colyli@suse.de
Subject: [PATCH 16/17] bcache: reap c->btree_cache_freeable from the tail in bch_mca_scan()
Date: Fri, 24 Jan 2020 01:01:41 +0800
Message-ID: <20200123170142.98974-17-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

In order to skip the most recently freed btree node cahce, currently
in bch_mca_scan() the first 3 caches in c->btree_cache_freeable list
are skipped when shrinking bcache node caches in bch_mca_scan(). The
related code in bch_mca_scan() is,

 737 list_for_each_entry_safe(b, t, &c->btree_cache_freeable, list) {
 738         if (nr <= 0)
 739                 goto out;
 740
 741         if (++i > 3 &&
 742             !mca_reap(b, 0, false)) {
             		lines free cache memory
 746         }
 747         nr--;
 748 }

The problem is, if virtual memory code calls bch_mca_scan() and
the calculated 'nr' is 1 or 2, then in the above loop, nothing will
be shunk. In such case, if slub/slab manager calls bch_mca_scan()
for many times with small scan number, it does not help to shrink
cache memory and just wasts CPU cycles.

This patch just selects btree node caches from tail of the
c->btree_cache_freeable list, then the newly freed host cache can
still be allocated by mca_alloc(), and at least 1 node can be shunk.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 357535a5c89c..c3a314deb09d 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -734,17 +734,17 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 
 	i = 0;
 	btree_cache_used = c->btree_cache_used;
-	list_for_each_entry_safe(b, t, &c->btree_cache_freeable, list) {
+	list_for_each_entry_safe_reverse(b, t, &c->btree_cache_freeable, list) {
 		if (nr <= 0)
 			goto out;
 
-		if (++i > 3 &&
-		    !mca_reap(b, 0, false)) {
+		if (!mca_reap(b, 0, false)) {
 			mca_data_free(b);
 			rw_unlock(true, b);
 			freed++;
 		}
 		nr--;
+		i++;
 	}
 
 	for (;  (nr--) && i < btree_cache_used; i++) {
-- 
2.16.4
