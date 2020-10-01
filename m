Return-Path: <SRS0=Ei6X=DI=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DF7C4727C
	for <linux-bcache@archiver.kernel.org>; Thu,  1 Oct 2020 06:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A2F2085B
	for <linux-bcache@archiver.kernel.org>; Thu,  1 Oct 2020 06:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgJAGvh (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 1 Oct 2020 02:51:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:34052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgJAGvh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 02:51:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 390AFB01D;
        Thu,  1 Oct 2020 06:51:35 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/15] bcache: remove useless bucket_pages()
Date:   Thu,  1 Oct 2020 14:50:51 +0800
Message-Id: <20201001065056.24411-11-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001065056.24411-1-colyli@suse.de>
References: <20201001065056.24411-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

It seems alloc_bucket_pages() is the only user of bucket_pages().
Considering alloc_bucket_pages() is removed from bcache code, it is safe
to remove the useless macro bucket_pages() now.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

