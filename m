Return-Path: <SRS0=hH7c=6J=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974ECC55185
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Apr 2020 07:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C62B20706
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Apr 2020 07:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mpz5J1uI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgDYHxp (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 25 Apr 2020 03:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYHxo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Apr 2020 03:53:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F90C09B049;
        Sat, 25 Apr 2020 00:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Gq24q7chHQ+azlEZ1mRSOxBwPGoxrPhSPTwhDW5nYSU=; b=Mpz5J1uIs4RxlfWwwG4n/S7DFE
        R3W5dTyU5HiLA6H96GB4081JXGnUFw0+b7rYDo5Jxkx4za+3iA7tCJgweqb/8fbgsL5QrBraSqUmD
        8Q/gLV5oTKCu7Fg7rhSDZf125mtyt/vIqMrizWF//jBXhRxMRmJM/nJ4pQZLOImNokRoFi8NxSbR/
        ZGnp6rcWT6Hx4k7BGkk8Hf0CdSt/oBYe9Iramgtkv2RJzC8BtJVAhfz/FawjJdVyyMPvlnwTsOX2F
        qEssm7ggo3yqb2uDFTB8NWfT8DCX5a523YFKOqjavsWKCIyuwXUUQJAoApj0gi53HLCUsienJwTrk
        10sbtC4Q==;
Received: from [2001:4bb8:193:f203:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSFd9-0007dT-M3; Sat, 25 Apr 2020 07:53:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 2/3] dm: remove the make_request_fn check in device_area_is_invalid
Date:   Sat, 25 Apr 2020 09:53:35 +0200
Message-ID: <20200425075336.721021-3-hch@lst.de>
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
Message-ID: <20200425075335.q5MqQaV4ib_9-TRz48LdS6jONFeLl8M7ArmQNOA_XBU@z>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0a2cc197f62b4..8277b959e00bd 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -279,7 +279,6 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q;
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	sector_t dev_size =
@@ -288,22 +287,6 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		limits->logical_block_size >> SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
-	/*
-	 * Some devices exist without request functions,
-	 * such as loop devices not yet bound to backing files.
-	 * Forbid the use of such devices.
-	 */
-	q = bdev_get_queue(bdev);
-	if (!q || !q->make_request_fn) {
-		DMWARN("%s: %s is not yet initialised: "
-		       "start=%llu, len=%llu, dev_size=%llu",
-		       dm_device_name(ti->table->md), bdevname(bdev, b),
-		       (unsigned long long)start,
-		       (unsigned long long)len,
-		       (unsigned long long)dev_size);
-		return 1;
-	}
-
 	if (!dev_size)
 		return 0;
 
-- 
2.26.1

