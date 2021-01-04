Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13786C43217
	for <linux-bcache@archiver.kernel.org>; Mon,  4 Jan 2021 07:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D73902076D
	for <linux-bcache@archiver.kernel.org>; Mon,  4 Jan 2021 07:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhADHmL (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 4 Jan 2021 02:42:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:41002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbhADHmL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Jan 2021 02:42:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 57AAFB295;
        Mon,  4 Jan 2021 07:41:29 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Yi Li <yili@winhong.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 1/5] bcache: set pdev_set_uuid before scond loop iteration
Date:   Mon,  4 Jan 2021 15:41:18 +0800
Message-Id: <20210104074122.19759-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104074122.19759-1-colyli@suse.de>
References: <20210104074122.19759-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Yi Li <yili@winhong.com>

There is no need to reassign pdev_set_uuid in the second loop iteration,
so move it to the place before second loop.

Signed-off-by: Yi Li <yili@winhong.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a4752ac410dc..6aa23a6fb394 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2644,8 +2644,8 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 	}
 
 	list_for_each_entry_safe(pdev, tpdev, &pending_devs, list) {
+		char *pdev_set_uuid = pdev->dc->sb.set_uuid;
 		list_for_each_entry_safe(c, tc, &bch_cache_sets, list) {
-			char *pdev_set_uuid = pdev->dc->sb.set_uuid;
 			char *set_uuid = c->set_uuid;
 
 			if (!memcmp(pdev_set_uuid, set_uuid, 16)) {
-- 
2.26.2

