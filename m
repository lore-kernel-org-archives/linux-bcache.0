Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB7CC433DB
	for <linux-bcache@archiver.kernel.org>; Wed, 10 Feb 2021 13:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 295FA64E6F
	for <linux-bcache@archiver.kernel.org>; Wed, 10 Feb 2021 13:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhBJN6b (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 10 Feb 2021 08:58:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:45404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhBJN5y (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 08:57:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3B6F0AE1B;
        Wed, 10 Feb 2021 13:57:11 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Reported-by : kernel test robot" <lkp@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 4/4] bcache: fix a typo in nvme-pages.c
Date:   Wed, 10 Feb 2021 21:56:57 +0800
Message-Id: <20210210135657.35284-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210135657.35284-1-colyli@suse.de>
References: <20210210135657.35284-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch fixes a typo in init_owner_info() which causes an invalid
pointer checking from a kazlloc().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 3ea27ea3dd54..9cf69dc36f3a 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -561,7 +561,7 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 				for (k = 0; k < nvm_pgalloc_recs->used; k++) {
 					rec = &nvm_pgalloc_recs->recs[k];
 					extent = kzalloc(sizeof(*extent), GFP_KERNEL);
-					if (!extents) {
+					if (!extent) {
 						mutex_unlock(&only_set->lock);
 						return -ENOMEM;
 					}
-- 
2.26.2

