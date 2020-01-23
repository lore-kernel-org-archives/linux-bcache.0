From: colyli@suse.de
Subject: [PATCH 17/17] bcache: reap from tail of c->btree_cache in bch_mca_scan()
Date: Fri, 24 Jan 2020 01:01:42 +0800
Message-ID: <20200123170142.98974-18-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbgAWRDO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:03:14 -0500
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

From: Coly Li <colyli@suse.de>

When shrink btree node cache from c->btree_cache in bch_mca_scan(),
no matter the selected node is reaped or not, it will be rotated from
the head to the tail of c->btree_cache list. But in bcache journal
code, when flushing the btree nodes with oldest journal entry, btree
nodes are iterated and slected from the tail of c->btree_cache list in
btree_flush_write(). The list_rotate_left() in bch_mca_scan() will
make btree_flush_write() iterate more nodes in c->btree_list in reverse
order.

This patch just reaps the selected btree node cache, and not move it
from the head to the tail of c->btree_cache list. Then bch_mca_scan()
will not mess up c->btree_cache list to btree_flush_write().

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index c3a314deb09d..fa872df4e770 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -747,19 +747,19 @@ static unsigned long bch_mca_scan(struct shrinker *shrink,
 		i++;
 	}
 
-	for (;  (nr--) && i < btree_cache_used; i++) {
-		if (list_empty(&c->btree_cache))
+	list_for_each_entry_safe_reverse(b, t, &c->btree_cache, list) {
+		if (nr <= 0 || i >= btree_cache_used)
 			goto out;
 
-		b = list_first_entry(&c->btree_cache, struct btree, list);
-		list_rotate_left(&c->btree_cache);
-
 		if (!mca_reap(b, 0, false)) {
 			mca_bucket_free(b);
 			mca_data_free(b);
 			rw_unlock(true, b);
 			freed++;
 		}
+
+		nr--;
+		i++;
 	}
 out:
 	mutex_unlock(&c->bucket_lock);
-- 
2.16.4
