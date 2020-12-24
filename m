Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F26EC433E9
	for <linux-bcache@archiver.kernel.org>; Thu, 24 Dec 2020 13:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18598224B1
	for <linux-bcache@archiver.kernel.org>; Thu, 24 Dec 2020 13:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgLXNYs (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 24 Dec 2020 08:24:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9990 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgLXNYr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Dec 2020 08:24:47 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D1rP500t7zhx4X;
        Thu, 24 Dec 2020 21:23:20 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 24 Dec 2020 21:23:54 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>,
        <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 -next] md: bcache: use DEFINE_MUTEX() for mutex lock
Date:   Thu, 24 Dec 2020 21:24:31 +0800
Message-ID: <20201224132431.31180-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/md/bcache/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 46a00134a36a..963d62a15f37 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -40,7 +40,7 @@ static const char invalid_uuid[] = {
 };
 
 static struct kobject *bcache_kobj;
-struct mutex bch_register_lock;
+DEFINE_MUTEX(bch_register_lock);
 bool bcache_is_reboot;
 LIST_HEAD(bch_cache_sets);
 static LIST_HEAD(uncached_devices);
@@ -2832,7 +2832,6 @@ static int __init bcache_init(void)
 
 	check_module_parameters();
 
-	mutex_init(&bch_register_lock);
 	init_waitqueue_head(&unregister_wait);
 	register_reboot_notifier(&reboot);
 
-- 
2.22.0

