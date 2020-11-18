Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E294C64E7A
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 08:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9BBE2463B
	for <linux-bcache@archiver.kernel.org>; Wed, 18 Nov 2020 08:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PneJaAwH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgKRIsZ (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 18 Nov 2020 03:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgKRIsZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 18 Nov 2020 03:48:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14745C0613D4;
        Wed, 18 Nov 2020 00:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TGRxj3P5fN3QWbEKVTDt35+3igPcA4rCa+2EvBLtC8g=; b=PneJaAwHQHJWZMHR7k5+0kk3SW
        A637+tLVo0+wFYquvEJFrDmJGArQtG1KOZwaGCDcb5uwjoCpzXm5p38WC3Z79c3W1Swj1SNUBRNa6
        rcFaHgHlsCggXHjqeabUB4vl/TxH3BbslIfvIWOw76bNGryHFS0oOO6QGe02Z/szHszDuZfZaVGF7
        23TDL9jueG8glTxv5jhe+z4KkCNXNKIuP3jUqJ8Fp21K4ZBhqs9AfHyhYybRkG2we41vboVqG0XXs
        mAy1tiCpbrwoXa0Ibko7TJrxx/UZnZMUdAbbu4bn9DFirVnGNcjP7fIL0fwtGBVYjU1KM/a0NOzqV
        GyvwqgEA==;
Received: from [2001:4bb8:18c:31ba:32b1:ec66:5459:36a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfJ8H-0007kQ-Oc; Wed, 18 Nov 2020 08:48:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Richard Weinberger <richard@nod.at>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 02/20] block: remove a duplicate __disk_get_part prototype
Date:   Wed, 18 Nov 2020 09:47:42 +0100
Message-Id: <20201118084800.2339180-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118084800.2339180-1-hch@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/genhd.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 46553d6d602563..22f5b9fd96f8bf 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -250,7 +250,6 @@ static inline dev_t part_devt(struct hd_struct *part)
 	return part_to_dev(part)->devt;
 }
 
-extern struct hd_struct *__disk_get_part(struct gendisk *disk, int partno);
 extern struct hd_struct *disk_get_part(struct gendisk *disk, int partno);
 
 static inline void disk_put_part(struct hd_struct *part)
-- 
2.29.2

