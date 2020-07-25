Return-Path: <SRS0=hDdM=BE=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9806C433E8
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Jul 2020 12:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 833B0206C1
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Jul 2020 12:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGYMCn (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 25 Jul 2020 08:02:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:52068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYMCm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:02:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5EA59AFBE;
        Sat, 25 Jul 2020 12:02:50 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org
Subject: [PATCH 02/25] bcache: allocate meta data pages as compound pages
Date:   Sat, 25 Jul 2020 20:00:16 +0800
Message-Id: <20200725120039.91071-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There are some meta data of bcache are allocated by multiple pages,
and they are used as bio bv_page for I/Os to the cache device. for
example cache_set->uuids, cache->disk_buckets, journal_write->data,
bset_tree->data.

For such meta data memory, all the allocated pages should be treated
as a single memory block. Then the memory management and underlying I/O
code can treat them more clearly.

This patch adds __GFP_COMP flag to all the location allocating >0 order
pages for the above mentioned meta data. Then their pages are treated
as compound pages now.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/bset.c    | 2 +-
 drivers/md/bcache/btree.c   | 2 +-
 drivers/md/bcache/journal.c | 4 ++--
 drivers/md/bcache/super.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 4995fcaefe29..67a2c47f4201 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -322,7 +322,7 @@ int bch_btree_keys_alloc(struct btree_keys *b,
 
 	b->page_order = page_order;
 
-	t->data = (void *) __get_free_pages(gfp, b->page_order);
+	t->data = (void *) __get_free_pages(__GFP_COMP|gfp, b->page_order);
 	if (!t->data)
 		goto err;
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 6548a601edf0..dd116c83de80 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -785,7 +785,7 @@ int bch_btree_cache_alloc(struct cache_set *c)
 	mutex_init(&c->verify_lock);
 
 	c->verify_ondisk = (void *)
-		__get_free_pages(GFP_KERNEL, ilog2(bucket_pages(c)));
+		__get_free_pages(GFP_KERNEL|__GFP_COMP, ilog2(bucket_pages(c)));
 
 	c->verify_data = mca_bucket_alloc(c, &ZERO_KEY, GFP_KERNEL);
 
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 90aac4e2333f..d8586b6ccb76 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -999,8 +999,8 @@ int bch_journal_alloc(struct cache_set *c)
 	j->w[1].c = c;
 
 	if (!(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
-	    !(j->w[0].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)) ||
-	    !(j->w[1].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)))
+	    !(j->w[0].data = (void *) __get_free_pages(GFP_KERNEL|__GFP_COMP, JSET_BITS)) ||
+	    !(j->w[1].data = (void *) __get_free_pages(GFP_KERNEL|__GFP_COMP, JSET_BITS)))
 		return -ENOMEM;
 
 	return 0;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 38d79f66fde5..6db698b1739a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1776,7 +1776,7 @@ void bch_cache_set_unregister(struct cache_set *c)
 }
 
 #define alloc_bucket_pages(gfp, c)			\
-	((void *) __get_free_pages(__GFP_ZERO|gfp, ilog2(bucket_pages(c))))
+	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(bucket_pages(c))))
 
 struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 {
-- 
2.26.2

