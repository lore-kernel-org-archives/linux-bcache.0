Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28073C433DB
	for <linux-bcache@archiver.kernel.org>; Thu, 24 Dec 2020 02:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB742256F
	for <linux-bcache@archiver.kernel.org>; Thu, 24 Dec 2020 02:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLXB76 (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 23 Dec 2020 20:59:58 -0500
Received: from regular1.263xmail.com ([211.150.70.204]:39326 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgLXB76 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 20:59:58 -0500
Received: from localhost (unknown [192.168.167.16])
        by regular1.263xmail.com (Postfix) with ESMTP id 8DD065CF;
        Thu, 24 Dec 2020 09:54:05 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P20583T140370625181440S1608774839433536_;
        Thu, 24 Dec 2020 09:54:05 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <4b455d5aa5a14b4a7285797047c52806>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: colyli@suse.de
X-SENDER-IP: 14.18.236.70
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     colyli@suse.de
Cc:     yilikernel@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yi Li <yili@winhong.com>
Subject: [PATCH] bcache: set pdev_set_uuid before scond loop iteration
Date:   Thu, 24 Dec 2020 09:53:55 +0800
Message-Id: <20201224015355.358211-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There is no need to reassign pdev_set_uuid in the second loop iteration,
so move it to the place before second loop.

Signed-off-by: Yi Li <yili@winhong.com>
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
2.25.3



