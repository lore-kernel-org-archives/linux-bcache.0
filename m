From: colyli@suse.de
Subject: [PATCH 11/17] bcache: add code comments for state->pool in __btree_sort()
Date: Fri, 24 Jan 2020 01:01:36 +0800
Message-ID: <20200123170142.98974-12-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbgAWRC5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:57 -0500
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

From: Coly Li <colyli@suse.de>

To explain the pages allocated from mempool state->pool can be
swapped in __btree_sort(), because state->pool is a page pool,
which allocates pages by alloc_pages() indeed.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bset.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index cffcdc9feefb..4385303836d8 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -1257,6 +1257,11 @@ static void __btree_sort(struct btree_keys *b, struct btree_iter *iter,
 		 * Our temporary buffer is the same size as the btree node's
 		 * buffer, we can just swap buffers instead of doing a big
 		 * memcpy()
+		 *
+		 * Don't worry event 'out' is allocated from mempool, it can
+		 * still be swapped here. Because state->pool is a page mempool
+		 * creaated by by mempool_init_page_pool(), which allocates
+		 * pages by alloc_pages() indeed.
 		 */
 
 		out->magic	= b->set->data->magic;
-- 
2.16.4
