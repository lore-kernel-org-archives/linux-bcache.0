Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40447C433B4
	for <linux-bcache@archiver.kernel.org>; Wed, 14 Apr 2021 05:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AE96613BB
	for <linux-bcache@archiver.kernel.org>; Wed, 14 Apr 2021 05:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347531AbhDNFsB (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 14 Apr 2021 01:48:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:43454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347492AbhDNFsA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Apr 2021 01:48:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D5380B038;
        Wed, 14 Apr 2021 05:47:38 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        Coly Li <colyli@suse.de>, kernel test robot <lkp@intel.com>
Subject: [PATCH 13/13] bcache: use div_u64() in init_owner_info()
Date:   Wed, 14 Apr 2021 13:46:48 +0800
Message-Id: <20210414054648.24098-14-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414054648.24098-1-colyli@suse.de>
References: <20210414054648.24098-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Kernel test robot reports the built-in u64/u32 in init_owner_info()
doesn't work for m68k arch, the explicit div_u64() should be used.

This patch explicit uses div_u64() to do the u64/u32 division on
32bit m68k arch.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index c7e3ccc6af46..08cd45e90481 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -408,7 +408,7 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
 	only_set->owner_list_used = owner_list_head->used;
 
 	/* remove used space */
-	remove_owner_space(ns, 0, ns->pages_offset/ns->page_size);
+	remove_owner_space(ns, 0, div_u64(ns->pages_offset, ns->page_size));
 
 	sys_recs = ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
 	/* suppose no hole in array */
-- 
2.26.2

