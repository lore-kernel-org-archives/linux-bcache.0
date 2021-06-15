Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55EDC49361
	for <linux-bcache@archiver.kernel.org>; Tue, 15 Jun 2021 05:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C717861413
	for <linux-bcache@archiver.kernel.org>; Tue, 15 Jun 2021 05:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhFOFvk (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Tue, 15 Jun 2021 01:51:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45584 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhFOFvk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Jun 2021 01:51:40 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9635C1FD2A;
        Tue, 15 Jun 2021 05:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623736174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fo5bo8mzPI37nH0cbbOFJn0vZDu8ORoqn2KbFGq/mE=;
        b=G0BT+GR4kJQtsK79hYUzHKSGMI6EKzZEdvl4ydvmcmGzlJZi1WRiTTd1p3622gxH2rEMVn
        ljGUv3ehDzdCC0NZsWKbjemo++k4pgV6Kcxgo1pOXzcT+Ae1e15Cwe+OtnwTJhpO/COMbQ
        BGfcwX2f0bd4IrG8xS4261V/4QWX2ls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623736174;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fo5bo8mzPI37nH0cbbOFJn0vZDu8ORoqn2KbFGq/mE=;
        b=Pz9fVln/f62jPwhZ+ATg5spsmgQImwMPL1rHD4R3DYEjsWJLlFAwx6GFxXjeYJOnhmyc1g
        y35Nmi78+ocWocDw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id BACEAA3B94;
        Tue, 15 Jun 2021 05:49:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Ding Senjie <dingsenjie@yulong.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 02/14] md: bcache: Fix spelling of 'acquire'
Date:   Tue, 15 Jun 2021 13:49:09 +0800
Message-Id: <20210615054921.101421-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210615054921.101421-1-colyli@suse.de>
References: <20210615054921.101421-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Ding Senjie <dingsenjie@yulong.com>

acqurie -> acquire

Signed-off-by: Ding Senjie <dingsenjie@yulong.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 0a20ccf5a1db..2f1ee4fbf4d5 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2760,7 +2760,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		 * The reason bch_register_lock is not held to call
 		 * bch_cache_set_stop() and bcache_device_stop() is to
 		 * avoid potential deadlock during reboot, because cache
-		 * set or bcache device stopping process will acqurie
+		 * set or bcache device stopping process will acquire
 		 * bch_register_lock too.
 		 *
 		 * We are safe here because bcache_is_reboot sets to
-- 
2.26.2

