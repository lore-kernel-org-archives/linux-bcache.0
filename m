Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB85FC433DB
	for <linux-bcache@archiver.kernel.org>; Sun,  3 Jan 2021 16:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E91B20936
	for <linux-bcache@archiver.kernel.org>; Sun,  3 Jan 2021 16:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbhACQZE (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sun, 3 Jan 2021 11:25:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:35442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbhACQZD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 3 Jan 2021 11:25:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F411BAB87;
        Sun,  3 Jan 2021 16:24:21 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 1/3] bcache-tools: recover the missing sb.csum for showing bcache device super block
Date:   Mon,  4 Jan 2021 00:24:11 +0800
Message-Id: <20210103162413.16895-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit 2891723d7075 ("bcache-tools: define separated super block for
in-memory and on-disk format") does following change in detail_base(),
         strcpy(base->name, devname);
         base->magic = "ok";
         base->first_sector = SB_SECTOR;
 -       base->csum = sb.csum;
         base->version = sb.version;
because sb (in type struct cache_sb) doesn't have csum of the on-disk
super block anymore. The aftermath is base.csum was missing, and the
"show" command always display sb.csum as 0.

This patch recovers the csum value setting for base.csum, then command
"bcache show -d" may display the correct super block check sum.

Fixes: 2891723d7075 ("bcache-tools: define separated super block for in-memory and on-disk format")
Signed-off-by: Coly Li <colyli@suse.de>
---
 lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib.c b/lib.c
index b005eb5..340ddf3 100644
--- a/lib.c
+++ b/lib.c
@@ -487,6 +487,7 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 	    sb.version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET ||
 	    sb.version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
 		detail_base(devname, sb, &bd->base);
+		bd->base.csum = expected_csum;
 		bd->first_sector = BDEV_DATA_START_DEFAULT;
 		bd->cache_mode = BDEV_CACHE_MODE(&sb);
 		bd->cache_state = BDEV_STATE(&sb);
@@ -494,6 +495,7 @@ int detail_dev(char *devname, struct bdev *bd, struct cdev *cd, int *type)
 		   sb.version == BCACHE_SB_VERSION_CDEV_WITH_UUID ||
 		   sb.version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
 		detail_base(devname, sb, &cd->base);
+		cd->base.csum = expected_csum;
 		cd->first_sector = sb.bucket_size * sb.first_bucket;
 		cd->cache_sectors =
 		    sb.bucket_size * (sb.nbuckets - sb.first_bucket);
-- 
2.26.2

