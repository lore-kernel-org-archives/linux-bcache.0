Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62557C8301F
	for <linux-bcache@archiver.kernel.org>; Sat, 28 Nov 2020 22:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A6122470
	for <linux-bcache@archiver.kernel.org>; Sat, 28 Nov 2020 22:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I3jCuyW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389998AbgK1Vua (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731150AbgK1Sry (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 Nov 2020 13:47:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634CBC02548D;
        Sat, 28 Nov 2020 08:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=GIjN25CHDvXn0PUDT3xHPXMPnhcG28R4lRKj+byEQtQ=; b=I3jCuyW0xpEhM8f46M3RSoE9ZN
        KVOxycRTfDmYw44tAeGrpSIvjc3hfQQjDmDMWsVXlyXi1bmABY1szY6DHRpakuePWJtBcCmjhdBnd
        xJ4/djR9iJSq7agAU4wE+Y4mR5xYh/vujEzqko4aSOqDtDhpz8YeT2jWNPMdOFbYPvoFAas5QhKJv
        mAXloQLzPoZWTYD9yHjuwDu/Pt3H0I/jqsQrLpm6UrSQ564ffDVuj81x+idaWVhmP2dDsq74f9fJz
        gO6LKtDMjRArN59Ll9Rd1VnLJ/yj9GC+l3xu8TLh7ri54mtZk9AC5kpVttNDM8yZpupLrS74J6+jd
        daSpBbhw==;
Received: from [2001:4bb8:18c:1dd6:48f3:741a:602e:7fdd] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kj2tE-0000Lg-GH; Sat, 28 Nov 2020 16:16:01 +0000
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
Subject: [PATCH 28/45] block: simplify part_to_disk
Date:   Sat, 28 Nov 2020 17:14:53 +0100
Message-Id: <20201128161510.347752-29-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201128161510.347752-1-hch@lst.de>
References: <20201128161510.347752-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now that struct hd_struct has a block_device pointer use that to
find the disk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
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

