Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07BCC433ED
	for <linux-bcache@archiver.kernel.org>; Fri,  9 Apr 2021 16:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB6166115B
	for <linux-bcache@archiver.kernel.org>; Fri,  9 Apr 2021 16:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhDIQp7 (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 9 Apr 2021 12:45:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:36022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234201AbhDIQp6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Apr 2021 12:45:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A24B1B0B8;
        Fri,  9 Apr 2021 16:45:44 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.01.org,
        axboe@kernel.dk, jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        hare@suse.com, jack@suse.cz, dan.j.williams@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH v7 15/16] bcache: fix BCACHE_NVM_PAGES' dependences in Kconfig
Date:   Sat, 10 Apr 2021 00:43:42 +0800
Message-Id: <20210409164343.56828-16-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409164343.56828-1-colyli@suse.de>
References: <20210409164343.56828-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch fix the following dependences for BCACHE_NVM_PAGES in
Kconfig,
- Add "depends on PHYS_ADDR_T_64BIT" which is mandatory for libnvdimm
- Add "select LIBNVDIMM" and "select DAX" because nvm-pages code needs
  libnvdimm and dax driver.

This patch can be merged into previous nvm-pages patches, and dropped
in next version series.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index fdec9905ef40..0996e366ad0b 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -39,5 +39,8 @@ config BCACHE_ASYNC_REGISTRATION
 config BCACHE_NVM_PAGES
 	bool "NVDIMM support for bcache (EXPERIMENTAL)"
 	depends on BCACHE
+	depends on PHYS_ADDR_T_64BIT
+	select LIBNVDIMM
+	select DAX
 	help
 	nvm pages allocator for bcache.
-- 
2.26.2

