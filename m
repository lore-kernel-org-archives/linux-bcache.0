Return-Path: <SRS0=BgHr=BZ=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012F8C433EA
	for <linux-bcache@archiver.kernel.org>; Sat, 15 Aug 2020 21:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC15623B45
	for <linux-bcache@archiver.kernel.org>; Sat, 15 Aug 2020 21:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgHOVoM (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 15 Aug 2020 17:44:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:55012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgHOVnt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Aug 2020 17:43:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE7E3B799;
        Sat, 15 Aug 2020 04:11:27 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 06/14] bcache: remove useless alloc_bucket_pages()
Date:   Sat, 15 Aug 2020 12:10:35 +0800
Message-Id: <20200815041043.45116-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200815041043.45116-1-colyli@suse.de>
References: <20200815041043.45116-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now no one uses alloc_bucket_pages() anymore, remove it from bcache.h.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 5636648902e3..748b08ab4f11 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1832,9 +1832,6 @@ void bch_cache_set_unregister(struct cache_set *c)
 	bch_cache_set_stop(c);
 }
 
-#define alloc_bucket_pages(gfp, c)			\
-	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(bucket_pages(c))))
-
 #define alloc_meta_bucket_pages(gfp, sb)		\
 	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(meta_bucket_pages(sb))))
 
-- 
2.26.2

