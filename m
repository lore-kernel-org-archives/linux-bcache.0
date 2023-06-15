Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E202CEB64D9
	for <linux-bcache@archiver.kernel.org>; Thu, 15 Jun 2023 12:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245596AbjFOMNv (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 15 Jun 2023 08:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244616AbjFOMNv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Jun 2023 08:13:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4782103;
        Thu, 15 Jun 2023 05:13:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B7EEA223D6;
        Thu, 15 Jun 2023 12:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686831226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e6cTEpWtFyhxahMGG8LtioUr28o+z4A0cbIJXkAlc+8=;
        b=i8YcUghtragBXujEjxEc4M9oOjBdo3pMweIOXjmOVaUHKeY6uYkDuMchg8WeCzcl62vnXR
        tWK3YwIcV21Om40J2zXlqedCFcZCwAhEbM7Fe4VLBx+iqWt0qBq4XXd4UYqCF+XlanIvZQ
        dN7x/utZVLMAwudbZo982vAW4ULc2aE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686831226;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e6cTEpWtFyhxahMGG8LtioUr28o+z4A0cbIJXkAlc+8=;
        b=KUyg11EghyU7CGwl4JchxKh9mrgh6VVTwLrBwS3qASS+YUuK93s4Agb2DK2wD2I8ZyCW64
        pHXJN8Fh+K6kbdDw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 9757A2C141;
        Thu, 15 Jun 2023 12:13:44 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Zheng Wang <zyytlz.wz@163.com>, stable@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 5/6] bcache: Fix __bch_btree_node_alloc to make the failure behavior consistent
Date:   Thu, 15 Jun 2023 20:12:22 +0800
Message-Id: <20230615121223.22502-6-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230615121223.22502-1-colyli@suse.de>
References: <20230615121223.22502-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

In some specific situation, the return value of __bch_btree_node_alloc may
be NULL. This may lead to poential NULL pointer dereference in caller
 function like a calling chaion :
 btree_split->bch_btree_node_alloc->__bch_btree_node_alloc.

Fix it by initialize return value in __bch_btree_node_alloc before return.

Fixes: cafe56359144 ("bcache: A block layer cache")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 7c21e54468bf..0ddf91204782 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1090,10 +1090,12 @@ struct btree *__bch_btree_node_alloc(struct cache_set *c, struct btree_op *op,
 				     struct btree *parent)
 {
 	BKEY_PADDED(key) k;
-	struct btree *b = ERR_PTR(-EAGAIN);
+	struct btree *b;
 
 	mutex_lock(&c->bucket_lock);
 retry:
+	/* return ERR_PTR(-EAGAIN) when it fails */
+	b = ERR_PTR(-EAGAIN);
 	if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
 		goto err;
 
-- 
2.35.3

