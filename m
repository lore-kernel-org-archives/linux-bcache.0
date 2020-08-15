Return-Path: <SRS0=BgHr=BZ=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6645FC433E3
	for <linux-bcache@archiver.kernel.org>; Sat, 15 Aug 2020 22:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF9E20657
	for <linux-bcache@archiver.kernel.org>; Sat, 15 Aug 2020 22:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgHOWYN (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:24:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:37946 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbgHOWXp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Aug 2020 18:23:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 25828B1CE;
        Sat, 15 Aug 2020 12:48:32 +0000 (UTC)
From:   colyli@suse.de
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v1 11/14] bcache: remove can_attach_cache()
Date:   Sat, 15 Aug 2020 20:47:40 +0800
Message-Id: <20200815124743.115270-12-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200815124743.115270-1-colyli@suse.de>
References: <20200815124743.115270-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

After removing the embedded struct cache_sb from struct cache_set, cache
set will directly reference the in-memory super block of struct cache.
It is unnecessary to compare block_size, bucket_size and nr_in_set from
the identical in-memory super block in can_attach_cache().

This is a preparation patch for latter removing cache_set->sb from
struct cache_set.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index cdc1ebee5044..80cfb9dfe93e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2112,13 +2112,6 @@ static int run_cache_set(struct cache_set *c)
 	return -EIO;
 }
 
-static bool can_attach_cache(struct cache *ca, struct cache_set *c)
-{
-	return ca->sb.block_size	== c->sb.block_size &&
-		ca->sb.bucket_size	== c->sb.bucket_size &&
-		ca->sb.nr_in_set	== c->sb.nr_in_set;
-}
-
 static const char *register_cache_set(struct cache *ca)
 {
 	char buf[12];
@@ -2130,9 +2123,6 @@ static const char *register_cache_set(struct cache *ca)
 			if (c->cache)
 				return "duplicate cache set member";
 
-			if (!can_attach_cache(ca, c))
-				return "cache sb does not match set";
-
 			if (!CACHE_SYNC(&ca->sb))
 				SET_CACHE_SYNC(&c->sb, false);
 
-- 
2.26.2

