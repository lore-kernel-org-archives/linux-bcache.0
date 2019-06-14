From: Coly Li <colyli@suse.de>
Subject: [PATCH 02/29] bcache: Revert "bcache: free heap cache_set->flush_btree in bch_journal_free"
Date: Fri, 14 Jun 2019 21:13:31 +0800
Message-ID: <20190614131358.2771-3-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, stable@vger.kernel.org, Shenghui Wang <shhuiw@foxmail.com>
List-Id: linux-bcache@vger.kernel.org

This reverts commit 6268dc2c4703aabfb0b35681be709acf4c2826c6.

This patch depends on commit c4dc2497d50d ("bcache: fix high CPU
occupancy during journal") which is reverted in previous patch. So
revert this one too.

Fixes: 6268dc2c4703 ("bcache: free heap cache_set->flush_btree in bch_journal_free")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Cc: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/bcache/journal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 621ebf5c62a5..f18c1e7b012c 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -839,7 +839,6 @@ void bch_journal_free(struct cache_set *c)
 	free_pages((unsigned long) c->journal.w[1].data, JSET_BITS);
 	free_pages((unsigned long) c->journal.w[0].data, JSET_BITS);
 	free_fifo(&c->journal.pin);
-	free_heap(&c->flush_btree);
 }
 
 int bch_journal_alloc(struct cache_set *c)
-- 
2.16.4
