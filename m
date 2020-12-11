Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA855C433FE
	for <linux-bcache@archiver.kernel.org>; Fri, 11 Dec 2020 08:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E1023E1B
	for <linux-bcache@archiver.kernel.org>; Fri, 11 Dec 2020 08:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392901AbgLKIxR (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 11 Dec 2020 03:53:17 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9163 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392926AbgLKIwp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 11 Dec 2020 03:52:45 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CskzM55c4z15bZQ;
        Fri, 11 Dec 2020 16:51:27 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 16:51:53 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>,
        <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] md/bcache: convert comma to semicolon
Date:   Fri, 11 Dec 2020 16:52:22 +0800
Message-ID: <20201211085222.2762-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 554e3afc9b68..00a520c03f41 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -404,7 +404,7 @@ STORE(__cached_dev)
 		if (!env)
 			return -ENOMEM;
 		add_uevent_var(env, "DRIVER=bcache");
-		add_uevent_var(env, "CACHED_UUID=%pU", dc->sb.uuid),
+		add_uevent_var(env, "CACHED_UUID=%pU", dc->sb.uuid);
 		add_uevent_var(env, "CACHED_LABEL=%s", buf);
 		kobject_uevent_env(&disk_to_dev(dc->disk.disk)->kobj,
 				   KOBJ_CHANGE,
-- 
2.22.0

