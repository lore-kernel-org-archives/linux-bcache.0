Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_06_12,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957CBC433ED
	for <linux-bcache@archiver.kernel.org>; Fri, 21 May 2021 07:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 793DD611BD
	for <linux-bcache@archiver.kernel.org>; Fri, 21 May 2021 07:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhEUHVa (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 21 May 2021 03:21:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:16559 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhEUHVa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 03:21:30 -0400
IronPort-SDR: 2rozh19LiM+m06MmU5nvTW+xP7SAmiOX1Y3AuzUTPIPTS1NRIpiwLpzuI891AC+o9kgJMMSrXR
 hL303Un3lZPQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="199484342"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="199484342"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 00:20:07 -0700
IronPort-SDR: RgQB9ZkNsOBnVWrOjdeGG47b1pWD0CpUHbZGw723qkKIHqALYCEEe6MT73RZ7qBO2yHeQCjLvT
 RPrJwu9UWzww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440817178"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2021 00:20:06 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     linux-bcache@vger.kernel.org
Cc:     qiaowei.ren@intel.com, jianpeng.ma@intel.com, colyli@suse.de,
        rdunlap@infradead.oom
Subject: [bch-nvm-pages v10 6/6] bcache: get allocated pages from specific owner
Date:   Fri, 21 May 2021 10:57:26 -0400
Message-Id: <20210521145726.154276-7-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521145726.154276-1-qiaowei.ren@intel.com>
References: <20210521145726.154276-1-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements bch_get_allocated_pages() of the buddy to be used to
get allocated pages from specific owner.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 6 ++++++
 drivers/md/bcache/nvm-pages.h | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 755f3727a468..4f7fde0286a3 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -395,6 +395,12 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 }
 EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
 
+struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
+{
+	return find_owner_head(owner_uuid, false);
+}
+EXPORT_SYMBOL_GPL(bch_get_allocated_pages);
+
 #define BCH_PGOFF_TO_KVADDR(pgoff) ((void *)((unsigned long)pgoff << PAGE_SHIFT))
 
 static int init_owner_info(struct bch_nvm_namespace *ns)
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 918aee6a9afc..cfb3e8ef01ee 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -64,6 +64,7 @@ int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
+struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid);
 
 #else
 
@@ -81,6 +82,10 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 	return NULL;
 }
 static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
+static inline struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
+{
+	return NULL;
+}
 
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
-- 
2.25.1

