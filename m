Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B51C433F5
	for <linux-bcache@archiver.kernel.org>; Thu,  3 Mar 2022 11:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiCCLVC (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 3 Mar 2022 06:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiCCLVB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 06:21:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EDB1795D0;
        Thu,  3 Mar 2022 03:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jwQ8EMek85Vv3Kxcg6RZE3A0yhPrWq7YuU+GB1UR/fc=; b=a0w5wMhnV2cAkl4jBAoeIc/lvE
        RM2lW8parEdSKE3bhF38pyGY1TAesz3WERdXg+/tbwDWKI24aMa3z4mLe7db7FQFF2V5HnN3ZKh4E
        VpezJuV3vAQC20v5kv17fpLTeYYWA2+Rt/AlcwGZsQ8MsW9MMsJUjIKPcks0BCC3gAIjZtj+sNKyL
        pRhllO7VZoDCVHscPgjWm2gyaIxVCxrby/j/UVqvhC5HMpmFRFAll9t7ejJJt/nlv+X6BCGw2Musx
        BAiaU1DI/JnZXbYu8cgvbAAo/zsJG2qihgIRU/Hnecjga3hynK2ki+1XN/sHc8FPIBviY4hN4Z5vX
        dqWuGtzA==;
Received: from [91.93.38.115] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPjVB-006C8B-MV; Thu, 03 Mar 2022 11:20:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Justin Sanders <justin@coraid.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Denis Efremov <efremov@linux.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, linux-xtensa@linux-xtensa.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev
Subject: [PATCH 08/10] drbd: use bvec_kmap_local in drbd_csum_bio
Date:   Thu,  3 Mar 2022 14:19:03 +0300
Message-Id: <20220303111905.321089-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220303111905.321089-1-hch@lst.de>
References: <20220303111905.321089-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/block/drbd/drbd_worker.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index a5e04b38006b6..1b48c8172a077 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -326,9 +326,9 @@ void drbd_csum_bio(struct crypto_shash *tfm, struct bio *bio, void *digest)
 	bio_for_each_segment(bvec, bio, iter) {
 		u8 *src;
 
-		src = kmap_atomic(bvec.bv_page);
-		crypto_shash_update(desc, src + bvec.bv_offset, bvec.bv_len);
-		kunmap_atomic(src);
+		src = bvec_kmap_local(&bvec);
+		crypto_shash_update(desc, src, bvec.bv_len);
+		kunmap_local(src);
 
 		/* REQ_OP_WRITE_SAME has only one segment,
 		 * checksum the payload only once. */
-- 
2.30.2

