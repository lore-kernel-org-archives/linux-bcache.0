Return-Path: <SRS0=V1bn=AM=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03638C433DF
	for <linux-bcache@archiver.kernel.org>; Wed,  1 Jul 2020 09:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6408206C3
	for <linux-bcache@archiver.kernel.org>; Wed,  1 Jul 2020 09:01:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KTbKBFdI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgGAJAK (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 1 Jul 2020 05:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbgGAJAJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 05:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C538C03E979;
        Wed,  1 Jul 2020 02:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=N4V7c3aeDLuwhXVBAMVeI93XDU7dFLU/PzjjNBBA1go=; b=KTbKBFdIcNq7kcCYKLM8QT5rvT
        +BTkHkyQXt5A+fSSZkebxiNfAonPP5ePXVQUMMfxf2F7LG5La2VTPgqnueUPN5wD41j0tq2tSTnLG
        CnKo5+wyDIIBjuHKF5QovT9L95/sxG+C/xoA0AdoHdiigLjTXCAbH8EMqQ0vQ6JEpeKfr9jbHMR/h
        Vfo7Nw/N6PlBvbAXfnAU9KGWVRVSG5zRNxncxOSmyTyPNmmc+0D+LbE1uQGICJ1ISGr39OgP8dzV5
        /Y+pLFxgALv6ZbHRImHf0e+iUhlCNBZYvL8OGqJC+01BhnA2k43UqnSF95GoYRGtCYLt+QNb4JfYL
        QrjhBVtg==;
Received: from [2001:4bb8:184:76e3:ea38:596b:3e9e:422a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYb7-0008Ct-0I; Wed, 01 Jul 2020 09:00:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 11/20] fs: remove a weird comment in submit_bh_wbc
Date:   Wed,  1 Jul 2020 10:59:38 +0200
Message-ID: <20200701085947.3354405-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701085947.3354405-1-hch@lst.de>
References: <20200701085947.3354405-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200701085938.5B9BT5o6ZBBvWzSZhycR26eTef98PADSX3z0gX6xbhk@z>

All bios can get remapped if submitted to partitions.  No need to
comment on that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/buffer.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 64fe82ec65ff1f..2725ebbcfdc246 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3040,12 +3040,7 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 	if (test_set_buffer_req(bh) && (op == REQ_OP_WRITE))
 		clear_buffer_write_io_error(bh);
 
-	/*
-	 * from here on down, it's all bio -- do the initial mapping,
-	 * submit_bio -> generic_make_request may further map this bio around
-	 */
 	bio = bio_alloc(GFP_NOIO, 1);
-
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio_set_dev(bio, bh->b_bdev);
 	bio->bi_write_hint = write_hint;
-- 
2.26.2

