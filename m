From: Coly Li <colyli@suse.de>
Subject: [PATCH 2/3] bcache: Revert "bcache: shrink btree node cache after bch_btree_check()"
Date: Thu, 13 Feb 2020 22:12:06 +0800
Message-ID: <20200213141207.77219-3-colyli@suse.de>
References: <20200213141207.77219-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200213141207.77219-1-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
List-Id: linux-bcache@vger.kernel.org

This reverts commit 1df3877ff6a4810054237c3259d900ded4468969.

In my testing, sometimes even all the cached btree nodes are freed,
creating gc and allocator kernel threads may still fail. Finally it
turns out that kthread_run() may fail if there is pending signal for
current task. And the pending signal is sent from OOM killer which
is triggered by memory consuption in bch_btree_check().

Therefore explicitly shrinking bcache btree node here does not help,
and after the shrinker callback is improved, as well as pending signals
are ignored before creating kernel threads, now such operation is
unncessary anymore.

This patch reverts the commit 1df3877ff6a4 ("bcache: shrink btree node
cache after bch_btree_check()") because we have better improvement now.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2749daf09724..0c3c5419c52b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1917,23 +1917,6 @@ static int run_cache_set(struct cache_set *c)
 		if (bch_btree_check(c))
 			goto err;
 
-		/*
-		 * bch_btree_check() may occupy too much system memory which
-		 * has negative effects to user space application (e.g. data
-		 * base) performance. Shrink the mca cache memory proactively
-		 * here to avoid competing memory with user space workloads..
-		 */
-		if (!c->shrinker_disabled) {
-			struct shrink_control sc;
-
-			sc.gfp_mask = GFP_KERNEL;
-			sc.nr_to_scan = c->btree_cache_used * c->btree_pages;
-			/* first run to clear b->accessed tag */
-			c->shrink.scan_objects(&c->shrink, &sc);
-			/* second run to reap non-accessed nodes */
-			c->shrink.scan_objects(&c->shrink, &sc);
-		}
-
 		bch_journal_mark(c, &journal);
 		bch_initial_gc_finish(c);
 		pr_debug("btree_check() done");
-- 
2.16.4
