Return-Path: <SRS0=x8oq=C7=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED5DC4363D
	for <linux-bcache@archiver.kernel.org>; Tue, 22 Sep 2020 15:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E490F2399A
	for <linux-bcache@archiver.kernel.org>; Tue, 22 Sep 2020 15:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="dY1GfTz+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIVPrx (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:47:53 -0400
Received: from mail-m965.mail.126.com ([123.126.96.5]:58162 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgIVPrx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Sep 2020 11:47:53 -0400
X-Greylist: delayed 1097 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 11:47:52 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=tCkrBBvXt5/OwlXwUQ
        sa/C9K2DcHXxGcbnhOFUQbVJc=; b=dY1GfTz+iG9PO+6tuCsZQuOFk+mkzRVXom
        H0USYR1KRlaomgLBvjy2j6tv5SLBSgsIKKZoE0HvI318lZZaC6WAvwLYIndVji4U
        hOoWT4rPlJsSQN7oSRzQcsg/44CRYMpslazQaZT4YjVCfQKmjzlloEwE3QCRkUDN
        eAs1fRJek=
Received: from localhost.localdomain (unknown [118.144.11.10])
        by smtp10 (Coremail) with SMTP id NuRpCgCXq7ucHGpfLcHKcQ--.6474S2;
        Tue, 22 Sep 2020 23:47:41 +0800 (CST)
From:   Liu Hua <liusdu@126.com>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Cc:     sdu.liu@huawei.com, Liu Hua <liusdu@126.com>
Subject: [PATCH] bcache: insert bkeys without overlap when placeholder missed
Date:   Tue, 22 Sep 2020 23:47:27 +0800
Message-Id: <20200922154727.30389-1-liusdu@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NuRpCgCXq7ucHGpfLcHKcQ--.6474S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurykKF4xGr4xArWkWF47twb_yoWktrb_u3
        WFqF93Kw4YyFZFgr1jyr4xZrW0ya98ZF1Iqa4jqF9avrW7Ca93Wr4UJayxJrs8CrW3CFy3
        G34DXrnYyas29jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUDPEPUUUUU==
X-Originating-IP: [118.144.11.10]
X-CM-SenderInfo: polx2vbx6rjloofrz/1tbiJAmnNFpEAxHktwAAsh
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Btree spliting and garbage collection process will drop
placeholders, which may cause cache miss collision. We can
insert nonoverlapping bkeys with write lock. It is helpful
for performance.

Signed-off-by: Liu Hua <liusdu@126.com>
---
 drivers/md/bcache/extents.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index c809724e6571..acebe5bdb3f1 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -329,6 +329,7 @@ static bool bch_extent_insert_fixup(struct btree_keys *b,
 
 	uint64_t old_offset;
 	unsigned int old_size, sectors_found = 0;
+	bool overlap = false;
 
 	BUG_ON(!KEY_OFFSET(insert));
 	BUG_ON(!KEY_SIZE(insert));
@@ -340,15 +341,18 @@ static bool bch_extent_insert_fixup(struct btree_keys *b,
 			break;
 
 		if (bkey_cmp(&START_KEY(k), insert) >= 0) {
-			if (KEY_SIZE(k))
-				break;
-			else
+			if (!KEY_SIZE(k))
 				continue;
+			if (replace_key && overlap == false)
+				goto out;
+			break;
 		}
 
 		if (bkey_cmp(k, &START_KEY(insert)) <= 0)
 			continue;
 
+		overlap = true;
+
 		old_offset = KEY_START(k);
 		old_size = KEY_SIZE(k);
 
-- 
2.17.1

