Return-Path: <SRS0=je0I=6W=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8055AC47247
	for <linux-bcache@archiver.kernel.org>; Fri,  8 May 2020 16:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F09C206B9
	for <linux-bcache@archiver.kernel.org>; Fri,  8 May 2020 16:16:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hg0J6vPc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgEHQPp (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 8 May 2020 12:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbgEHQPh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDC4C05BD43;
        Fri,  8 May 2020 09:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=StWP0crF+8pSNFux4pjsqh9CnHUPvltK4WN7YgDzDwo=; b=hg0J6vPc1CAtRbBcIKiIwGZj1R
        U/NYXsltRCgUXRtF02xAh6x/dQQt7bD8PzPhXtSQ7xtfClVpUVDRELn7ixFyZ4B2pCgOFCooBv00b
        Kb3UuE2iupMli5UVx0Ld3aKZ1QZcPq28l06UGMLW5DFIhlEjEpmVKcxKOP5Z6+5Ul64aYiy4wQLjf
        XUU256tNa+A9CfSiuzAX8CUPPPYrqDPrd5en8kVJ2NLMaRiEdIyuo4wfyA6bowpdUqeN6bgwNuwZy
        ZWQbvwwkYO4D0ebTcT0ciGUghRQlVk/s8oLF8DDRZGiij+odbfRZdhIEZqowwh8vFKNKZjPynC6hV
        xkR17kBw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5er-0004Wm-9C; Fri, 08 May 2020 16:15:30 +0000
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
Subject: [PATCH 03/15] drbd: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:05 +0200
Message-ID: <20200508161517.252308-4-hch@lst.de>
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
Message-ID: <20200508161505.sr_ST9HoMZvb6Uszxui21yLpXcdIOEULkaUhVyaZvlA@z>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c | 1 -
 drivers/block/drbd/drbd_req.c  | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c094c3c2c5d4d..be787b268f044 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2805,7 +2805,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	if (!q)
 		goto out_no_q;
 	device->rq_queue = q;
-	q->queuedata   = device;
 
 	disk = alloc_disk(1);
 	if (!disk)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 840c3aef3c5c9..02c104a0c45e0 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1614,7 +1614,7 @@ void do_submit(struct work_struct *ws)
 
 blk_qc_t drbd_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct drbd_device *device = (struct drbd_device *) q->queuedata;
+	struct drbd_device *device = bio->bi_disk->private_data;
 	unsigned long start_jif;
 
 	blk_queue_split(q, &bio);
-- 
2.26.2

