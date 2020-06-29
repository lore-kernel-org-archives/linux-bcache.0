Return-Path: <SRS0=COrE=AK=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61ECDC433E2
	for <linux-bcache@archiver.kernel.org>; Mon, 29 Jun 2020 20:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3628020672
	for <linux-bcache@archiver.kernel.org>; Mon, 29 Jun 2020 20:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nX6H72rw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387555AbgF2TkP (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733202AbgF2TkM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:12 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF841C03E97A;
        Mon, 29 Jun 2020 12:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=U8tCb4h17a0rL+ZZdq18PAV+yDbvWsH96GC5gLr1vuc=; b=nX6H72rwNYY0Uodz17aYP0bvqk
        9gSPPIErWrLN9tgBHhvIIJkOaKgVsJo4ToReNXQeJGEcFnMtOneeM9lvCktfvClRYHDtNElRZj2F6
        8v+5TR40P7wF9sVI6FNZgxu5kOa2TO9rd1Tk/CVbrQpxDd6MTudpLktSUdh658nMTs0t6pbT8L0DU
        oLPd3ny9KNPaRYcpjp5BKqZJvHEO/AQA8V3gJ3oEvuI02EACAolGm1l5wddF6nve0W3P8jOwehhxt
        HUK/Vlvd1nnX1ZKXj4mHlQgYSZ/JMOLFPBM2+5fH9Dc8Y+nLWvs6b4VA5Ugvca4/Jx5cC4ko7Xilx
        7KEB9k7g==;
Received: from [2001:4bb8:184:76e3:fcca:c8dc:a4bf:12fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpzd9-0004Eg-CR; Mon, 29 Jun 2020 19:39:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 01/20] nfblock: stop using ->queuedata
Date:   Mon, 29 Jun 2020 21:39:28 +0200
Message-ID: <20200629193947.2705954-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
References: <20200629193947.2705954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200629193928.BsFwaw1_zhcN7aNd4H4arY6dYsR06d7glqjx1xf2YUk@z>

Instead of setting up the queuedata as well just use one private data
field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/m68k/emu/nfblock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index c3a630440512e9..87e8b1700acd28 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -61,7 +61,7 @@ struct nfhd_device {
 
 static blk_qc_t nfhd_make_request(struct request_queue *queue, struct bio *bio)
 {
-	struct nfhd_device *dev = queue->queuedata;
+	struct nfhd_device *dev = bio->bi_disk->private_data;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	int dir, len, shift;
@@ -122,7 +122,6 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	if (dev->queue == NULL)
 		goto free_dev;
 
-	dev->queue->queuedata = dev;
 	blk_queue_logical_block_size(dev->queue, bsize);
 
 	dev->disk = alloc_disk(16);
-- 
2.26.2

