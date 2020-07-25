Return-Path: <SRS0=hDdM=BE=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FA5C4345A
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Jul 2020 12:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E61C206C1
	for <linux-bcache@archiver.kernel.org>; Sat, 25 Jul 2020 12:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGYMDF (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Sat, 25 Jul 2020 08:03:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:52316 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbgGYMDE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:03:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 28B9AAB55;
        Sat, 25 Jul 2020 12:03:12 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/25] bcache: add more accurate error information in read_super_common()
Date:   Sat, 25 Jul 2020 20:00:24 +0800
Message-Id: <20200725120039.91071-11-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The improperly set bucket or block size will trigger error in
read_super_common(). For large bucket size, a more accurate error message
for invalid bucket or block size is necessary.

This patch disassembles the combined if() checks into multiple single
if() check, and provide more accurate error message for each check
failure condition.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/super.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index b5b81b92b2ef..fd8c9ee4d4a6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -79,11 +79,20 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
 	if (sb->nbuckets < 1 << 7)
 		goto err;
 
-	err = "Bad block/bucket size";
-	if (!is_power_of_2(sb->block_size) ||
-	    sb->block_size > PAGE_SECTORS ||
-	    !is_power_of_2(sb->bucket_size) ||
-	    sb->bucket_size < PAGE_SECTORS)
+	err = "Bad block size (not power of 2)";
+	if (!is_power_of_2(sb->block_size))
+		goto err;
+
+	err = "Bad block size (larger than page size)";
+	if (sb->block_size > PAGE_SECTORS)
+		goto err;
+
+	err = "Bad bucket size (not power of 2)";
+	if (!is_power_of_2(sb->bucket_size))
+		goto err;
+
+	err = "Bad bucket size (smaller than page size)";
+	if (sb->bucket_size < PAGE_SECTORS)
 		goto err;
 
 	err = "Invalid superblock: device too small";
-- 
2.26.2

