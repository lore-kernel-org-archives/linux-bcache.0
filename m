Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9477FC83024
	for <linux-bcache@archiver.kernel.org>; Thu, 26 Nov 2020 13:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F76021D7E
	for <linux-bcache@archiver.kernel.org>; Thu, 26 Nov 2020 13:07:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FvaOkU4k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389936AbgKZNHS (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389943AbgKZNHQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Nov 2020 08:07:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB737C0617A7;
        Thu, 26 Nov 2020 05:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nM9OOc09jMaYn13UV1xnGqzKik4TLLc3/ktZdtaCR0w=; b=FvaOkU4kHXBfdVMOB12oBu42Hv
        2Q6c93H7622fyezJLxcX1lNn6/+eBm1N4BO6MUqga76cjNXsxq+yP9INBhup2opIJdInRULSN9aDv
        GXbI+5/8/S8q0EEQqeJMGpAxYRc9Bouh85ULoV7h2+YJtrqWK591lWcqICJoIMhn+6U32lVibdG6c
        zdzfdXIPDC9Gr8O03nTWJEA0xUmb3isXObNWRHLOLN9RLVwU4MUy3AIKq3kZuzMn+AmgsOgUThrS/
        AH8fDByu5LV7WH3TMt6wI71LLeECxnAiCKy4fsXHiDZZN9KarAZRFuaXs+F2IoEGCuauV4qgnSctF
        1Pk0KJbA==;
Received: from [2001:4bb8:18c:1dd6:27b8:b8a1:c13e:ceb1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kiGzI-00042P-5Y; Thu, 26 Nov 2020 13:07:04 +0000
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
Subject: [PATCH 22/44] block: opencode devcgroup_inode_permission
Date:   Thu, 26 Nov 2020 14:04:00 +0100
Message-Id: <20201126130422.92945-23-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126130422.92945-1-hch@lst.de>
References: <20201126130422.92945-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Just call devcgroup_check_permission to avoid various superflous checks
and a double conversion of the access flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/block_dev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index d0783c55a0ce65..b12ab68297baf3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1516,15 +1516,13 @@ static int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 	struct block_device *claiming;
 	bool unblock_events = true;
 	struct gendisk *disk;
-	int perm = 0;
 	int partno;
 	int ret;
 
-	if (mode & FMODE_READ)
-		perm |= MAY_READ;
-	if (mode & FMODE_WRITE)
-		perm |= MAY_WRITE;
-	ret = devcgroup_inode_permission(bdev->bd_inode, perm);
+	ret = devcgroup_check_permission(DEVCG_DEV_BLOCK,
+			imajor(bdev->bd_inode), iminor(bdev->bd_inode),
+			((mode & FMODE_READ) ? DEVCG_ACC_READ : 0) |
+			((mode & FMODE_WRITE) ? DEVCG_ACC_WRITE : 0));
 	if (ret)
 		goto bdput;
 
-- 
2.29.2

