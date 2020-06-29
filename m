Return-Path: <SRS0=COrE=AK=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE31C433E0
	for <linux-bcache@archiver.kernel.org>; Mon, 29 Jun 2020 19:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5134C20674
	for <linux-bcache@archiver.kernel.org>; Mon, 29 Jun 2020 19:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L1r7EY9F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388552AbgF2T7u (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387579AbgF2TkQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:16 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EE9C03E97E;
        Mon, 29 Jun 2020 12:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=t6BqkN6Yxn/8o7GWQerTXSXZiT8M8tft7EnhoW3IIiE=; b=L1r7EY9FHzvyzP1GXJQq8PamRy
        kklMB3B/Z5AAP3Qz+3yMUhnjDthIvzaMmika+09k+I9SG4WEZAz27Zc7R8q/CIaJAhDL1Vw5JTPP/
        AZ+zHno+y/TSc0HS3BAt05sXoXJqTSDpWO5oz0rKQrhLvAp3Pmi7Fx3itzdowGp2kggIN20A8Ze1Y
        KQtyy2SujehoRs4mDT1ZuP0yV/o/b7G/qsh2YKbGLedvrZAORnbzDSX5wU9BiGWR5fF3RMON6NxIy
        XhSqrz6RqcUKLEkpYG9v3D+yp3TYTmJXD2arCvG0V0IFSdsIFbFgyQdmXf4PAC2OX+gRcnpXfeuLc
        IYHHkXtA==;
Received: from [2001:4bb8:184:76e3:fcca:c8dc:a4bf:12fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpzdL-0004IV-Ik; Mon, 29 Jun 2020 19:40:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 08/20] zram: stop using ->queuedata
Date:   Mon, 29 Jun 2020 21:39:35 +0200
Message-ID: <20200629193947.2705954-9-hch@lst.de>
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
Message-ID: <20200629193935.bHTk-bptqesdPjCuu9jHoYUBUI9EeXClE7vN2Tf47C0@z>

Instead of setting up the queuedata as well just use one private data
field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6e2ad90b17a376..0564e3f384089e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1586,7 +1586,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
  */
 static blk_qc_t zram_make_request(struct request_queue *queue, struct bio *bio)
 {
-	struct zram *zram = queue->queuedata;
+	struct zram *zram = bio->bi_disk->private_data;
 
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
@@ -1912,7 +1912,6 @@ static int zram_add(void)
 	zram->disk->first_minor = device_id;
 	zram->disk->fops = &zram_devops;
 	zram->disk->queue = queue;
-	zram->disk->queue->queuedata = zram;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
-- 
2.26.2

