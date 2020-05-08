Return-Path: <SRS0=je0I=6W=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E94FC47257
	for <linux-bcache@archiver.kernel.org>; Fri,  8 May 2020 16:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55AB9206B9
	for <linux-bcache@archiver.kernel.org>; Fri,  8 May 2020 16:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p0ElUfR3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgEHQPz (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 8 May 2020 12:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbgEHQPy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724C0C061A0C;
        Fri,  8 May 2020 09:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=v95R0zjTgUANy896rAxmeWpttbECsK32wQlrntDvB9M=; b=p0ElUfR3gK1Rk5PmAzNROj0KqY
        c74p4QSvm4KdW68E1PC0gFs+KF+EO5SGozWG9ESk4gFf2HbF9XfXdh77qoEi3XzLs0Q43Xy9f26fv
        BAaig/pdUtmrY/BtkXTGeCDNxZjhpZcXPrh52CtE57IcvP5DedivWBwD/tMewiCvxZ50AfXIR2HP6
        o7+ZJ1BiHyG6xf1CJfZP9+pZgfbtfB1+M9Ku/h/9GLXId/E1gM7ns2sEo65YxszlshCiIe+YNWoCD
        sKmSj/N22isoShI/24frjlLR2xgBEGCSYuD1u8yApU/BWCbrigPs9wWHe777HKrqy8m6Z1TP9tMUg
        QyuKblsg==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5f6-0004i4-Ek; Fri, 08 May 2020 16:15:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: [PATCH 08/15] zram: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:10 +0200
Message-ID: <20200508161517.252308-9-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
References: <20200508161517.252308-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200508161510.SxL-Lrz3lbNc3yAP2_D9CCl1Xj2RzUwylUQpTh7LIbE@z>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ebb234f36909c..e1a6c74c7a4ba 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1593,7 +1593,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
  */
 static blk_qc_t zram_make_request(struct request_queue *queue, struct bio *bio)
 {
-	struct zram *zram = queue->queuedata;
+	struct zram *zram = bio->bi_disk->private_data;
 
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
@@ -1916,7 +1916,6 @@ static int zram_add(void)
 	zram->disk->first_minor = device_id;
 	zram->disk->fops = &zram_devops;
 	zram->disk->queue = queue;
-	zram->disk->queue->queuedata = zram;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
-- 
2.26.2

