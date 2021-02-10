Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B016C433E0
	for <linux-bcache@archiver.kernel.org>; Wed, 10 Feb 2021 05:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 559D864E42
	for <linux-bcache@archiver.kernel.org>; Wed, 10 Feb 2021 05:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhBJFIs (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 10 Feb 2021 00:08:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:40128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhBJFIq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:08:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 188BEAFFB;
        Wed, 10 Feb 2021 05:08:04 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 02/20] bcache: Fix register_device_aync typo
Date:   Wed, 10 Feb 2021 13:07:24 +0800
Message-Id: <20210210050742.31237-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Kai Krakow <kai@kaishome.de>

Should be `register_device_async`.

Cc: Coly Li <colyli@suse.de>
Signed-off-by: Kai Krakow <kai@kaishome.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2047a9cccdb5..e7d1b52c5cc8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2517,7 +2517,7 @@ static void register_cache_worker(struct work_struct *work)
 	module_put(THIS_MODULE);
 }
 
-static void register_device_aync(struct async_reg_args *args)
+static void register_device_async(struct async_reg_args *args)
 {
 	if (SB_IS_BDEV(args->sb))
 		INIT_DELAYED_WORK(&args->reg_work, register_bdev_worker);
@@ -2611,7 +2611,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		args->sb	= sb;
 		args->sb_disk	= sb_disk;
 		args->bdev	= bdev;
-		register_device_aync(args);
+		register_device_async(args);
 		/* No wait and returns to user space */
 		goto async_done;
 	}
-- 
2.26.2

