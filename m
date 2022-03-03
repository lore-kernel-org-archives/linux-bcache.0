Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877DBC433EF
	for <linux-bcache@archiver.kernel.org>; Thu,  3 Mar 2022 11:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiCCLUp (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 3 Mar 2022 06:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiCCLUo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 06:20:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5870E1795D0;
        Thu,  3 Mar 2022 03:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tYmKkYIu7zmzEunNhXdDRfJJ/EwgH0W1E2S7/DDX3UA=; b=GzbwebO0Roewyzk83YwKk9DagD
        zeUBlwlV1NkIxBPGBcb9H+3xjAgUPwtWvrWAQrcZ7pDP7/0WsBSFP94U07wVtXBNVAZoo31JdUOuK
        wrnY1bO3fJrr6Qyojb57a3lSdNJSe1afocW5UiNmzZGRZMkhnmtxgZz/Fy/RHP2rwj9iviJfAEhJu
        TVq6pGMWjhGf9KLJDM3TYsXlNC0KLDY1d2980KLZOkECVZe9XYnu59UmljGI2x2vUzKcY7qY2YXy1
        g99dwHsVeZXILZEYM1/IyAEhM9wqdKY7mnt/+Te5e6J+QI+EYavoK+8zlfTaYxkTsiJ6A+ofiAWP3
        1CocIhVA==;
Received: from [91.93.38.115] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPjUt-006C1X-Ge; Thu, 03 Mar 2022 11:19:52 +0000
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
Subject: [PATCH 05/10] nvdimm-blk: use bvec_kmap_local in nd_blk_rw_integrity
Date:   Thu,  3 Mar 2022 14:19:00 +0300
Message-Id: <20220303111905.321089-6-hch@lst.de>
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
 drivers/nvdimm/blk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index c1db43524d755..0a38738335941 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -88,10 +88,9 @@ static int nd_blk_rw_integrity(struct nd_namespace_blk *nsblk,
 		 */
 
 		cur_len = min(len, bv.bv_len);
-		iobuf = kmap_atomic(bv.bv_page);
-		err = ndbr->do_io(ndbr, dev_offset, iobuf + bv.bv_offset,
-				cur_len, rw);
-		kunmap_atomic(iobuf);
+		iobuf = bvec_kmap_local(&bv);
+		err = ndbr->do_io(ndbr, dev_offset, iobuf, cur_len, rw);
+		kunmap_local(iobuf);
 		if (err)
 			return err;
 
-- 
2.30.2

