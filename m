Return-Path: <SRS0=hH7c=6J=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6464BC55197
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Apr 2020 07:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CCE220857
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Apr 2020 07:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Svsw2QPY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgDYHxm (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 25 Apr 2020 03:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYHxm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Apr 2020 03:53:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E798C09B049;
        Sat, 25 Apr 2020 00:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FirIqiBriGoVpJstrt8fx7KLCwnx0rnqYAIeNgkdfk8=; b=Svsw2QPYkP5zLtHcPjS3qaheV0
        ZUdjlYNzs/ynlLEt+BMIiLY74PiWQI88vStvXEM9Jau4GIlj8ww1Vb0FYIVD8LXttCHaipLJTv494
        tJ6JcQaPENaeevrBkspchhW2RHR+k7WTjNzPxTQx95MQm55VirhJj2y6o8z3KCm3UZJW4IKYlxCnA
        zZEB3yVeewX+ArzhR/aHRFN1xgKNvM4ugyP3jRPPD+5UtVy8rLBVE7gxxK/6gUb/5c2Pyyi5VrTn3
        FcG1Gxovakw0jqMsuLZfTJZN/us3AYyBYzOPTnfaiJqI3hh6F7PGZX5Qg/R0fF/sJTlqRiTCx3PFP
        hPslBe8w==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSFd7-0007d6-9G; Sat, 25 Apr 2020 07:53:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 1/3] bcache: remove a duplicate ->make_request_fn assignment
Date:   Sat, 25 Apr 2020 09:53:34 +0200
Message-ID: <20200425075336.721021-2-hch@lst.de>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200425075336.721021-1-hch@lst.de>
References: <20200425075336.721021-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200425075334.kY-dZc2NFbK0zTMflR6xRfk7q1woHer_-ysaiHxrDfI@z>

The make_request_fn pointer should only be assigned by blk_alloc_queue.
Fix a left over manual initialization.

Fixes: ff27668ce809 ("bcache: pass the make_request methods to blk_queue_make_request")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/request.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 71a90fbec314b..77d1a26975174 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1372,7 +1372,6 @@ void bch_flash_dev_request_init(struct bcache_device *d)
 {
 	struct gendisk *g = d->disk;
 
-	g->queue->make_request_fn		= flash_dev_make_request;
 	g->queue->backing_dev_info->congested_fn = flash_dev_congested;
 	d->cache_miss				= flash_dev_cache_miss;
 	d->ioctl				= flash_dev_ioctl;
-- 
2.26.1

