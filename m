From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 22/60] block: comment on bio_alloc_pages()
Date: Sat, 29 Oct 2016 16:08:21 +0800
Message-ID: <1477728600-12938-23-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34531 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941855AbcJ2INh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 29 Oct 2016 04:13:37 -0400
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Mike Christie <mchristi@redhat.com>, Guoqing Jiang <gqjiang@suse.com>, Hannes Reinecke <hare@suse.com>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>

This patch adds comment on usage of bio_alloc_pages(),
also comments on one special case of bch_data_verify().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/bio.c               | 4 +++-
 drivers/md/bcache/debug.c | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index db85c5753a76..a49d1d89a85c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -907,7 +907,9 @@ EXPORT_SYMBOL(bio_advance);
  * @bio: bio to allocate pages for
  * @gfp_mask: flags for allocation
  *
- * Allocates pages up to @bio->bi_vcnt.
+ * Allocates pages up to @bio->bi_vcnt, and this function should only
+ * be called on a new initialized bio, which means no page isn't added
+ * to the bio via bio_add_page() yet.
  *
  * Returns 0 on success, -ENOMEM on failure. On failure, any allocated pages are
  * freed.
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 430f3050663c..71a9f05918eb 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -110,6 +110,12 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	struct bio_vec bv, cbv;
 	struct bvec_iter iter, citer = { 0 };
 
+	/*
+	 * Once multipage bvec is supported, the bio_clone()
+	 * has to make sure page count in this bio can be held
+	 * in the new cloned bio because each single page need
+	 * to assign to each bvec of the new bio.
+	 */
 	check = bio_clone(bio, GFP_NOIO);
 	if (!check)
 		return;
-- 
2.7.4
