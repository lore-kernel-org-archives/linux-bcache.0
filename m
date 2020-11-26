Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD0DC8300F
	for <linux-bcache@archiver.kernel.org>; Thu, 26 Nov 2020 13:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980C1221FA
	for <linux-bcache@archiver.kernel.org>; Thu, 26 Nov 2020 13:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tFjT6IkZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389985AbgKZNHY (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389978AbgKZNHX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Nov 2020 08:07:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EF3C0613D4;
        Thu, 26 Nov 2020 05:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7zJyA1+2dNtOVgFSOqRhBotQ/SGMaZPnGEludQAyDbM=; b=tFjT6IkZrllK1gCvx3sgLP9AIc
        OTjjaMfxu6Sr78eemKDudzxtJJ4WjsR32/1co/MX6KOHwzotcSZYQYFPChzT/4mkYwOqXV25Bcy+Y
        F+TiUT40riLcGeEXWkICD1YeOY0nPbUjgMfvQu6e7MfqeIZt3D/MHYQNWnos3sFcB/QTxugA73GvE
        bOBLPOUzeJ0hUQbECYWpjJijnkOXoRKZ4Sk3RrxllMGrBs7EmljV3+Y/0SAggChY5UdJjfy+oEncL
        t+l+Fo13Rr6SDL7fUpjTgkjRc/PT6UI1K0Ul/QrCTxzFl5uu22GSDh78VVi27hK/Bagqt9iF6YsoN
        2JG9EfAQ==;
Received: from [2001:4bb8:18c:1dd6:27b8:b8a1:c13e:ceb1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kiGzP-000443-4a; Thu, 26 Nov 2020 13:07:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Jan Kara <jack@suse.com>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 27/44] block: simplify part_to_disk
Date:   Thu, 26 Nov 2020 14:04:05 +0100
Message-Id: <20201126130422.92945-28-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126130422.92945-1-hch@lst.de>
References: <20201126130422.92945-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now that struct hd_struct has a block_device pointer use that to
find the disk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 include/linux/genhd.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 42a51653c7303e..6ba91ee54cb2f6 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -218,13 +218,9 @@ struct gendisk {
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
 {
-	if (likely(part)) {
-		if (part->partno)
-			return dev_to_disk(part_to_dev(part)->parent);
-		else
-			return dev_to_disk(part_to_dev(part));
-	}
-	return NULL;
+	if (unlikely(!part))
+		return NULL;
+	return part->bdev->bd_disk;
 }
 
 static inline int disk_max_parts(struct gendisk *disk)
-- 
2.29.2

