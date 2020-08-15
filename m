Return-Path: <SRS0=BgHr=BZ=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C3AC433E8
	for <linux-bcache@archiver.kernel.org>; Sat, 15 Aug 2020 21:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F3823B24
	for <linux-bcache@archiver.kernel.org>; Sat, 15 Aug 2020 21:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHOVoV (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 15 Aug 2020 17:44:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:54984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgHOVnr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Aug 2020 17:43:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9068DB79A;
        Sat, 15 Aug 2020 04:11:30 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 07/14] bcache: remove useless bucket_pages()
Date:   Sat, 15 Aug 2020 12:10:36 +0800
Message-Id: <20200815041043.45116-8-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200815041043.45116-1-colyli@suse.de>
References: <20200815041043.45116-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

It seems alloc_bucket_pages() is the only user of bucket_pages().
Considering alloc_bucket_pages() is removed from bcache code, it is safe
to remove the useless macro bucket_pages() now.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 29bec61cafbb..48a2585b6bbb 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -757,7 +757,6 @@ struct bbio {
 #define btree_default_blocks(c)						\
 	((unsigned int) ((PAGE_SECTORS * (c)->btree_pages) >> (c)->block_bits))
 
-#define bucket_pages(c)		((c)->sb.bucket_size / PAGE_SECTORS)
 #define bucket_bytes(c)		((c)->sb.bucket_size << 9)
 #define block_bytes(ca)		((ca)->sb.block_size << 9)
 
-- 
2.26.2

