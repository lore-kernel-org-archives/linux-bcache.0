Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FC5C433DB
	for <linux-bcache@archiver.kernel.org>; Fri, 22 Jan 2021 15:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2686023A84
	for <linux-bcache@archiver.kernel.org>; Fri, 22 Jan 2021 15:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbhAVPXC (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 22 Jan 2021 10:23:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:44450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729128AbhAVPV7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 Jan 2021 10:21:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 16352B91F
        for <linux-bcache@vger.kernel.org>; Fri, 22 Jan 2021 15:21:10 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH] bcache-tools: Update super block version in bch_set_feature_* routines
Date:   Fri, 22 Jan 2021 23:21:01 +0800
Message-Id: <20210122152101.71647-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When calling bch_set_feature_* routines, it indicates the super block
supports feature set and its version of cache device should at least be
BCACHE_SB_VERSION_CDEV_WITH_FEATURES.

In order to always keep the cache device super block version being
updated, this patch checks whether the super block version is set
correctly when calling bch_set_feature_* routines, if not then set
the version to BCACHE_SB_VERSION_CDEV_WITH_FEATURES.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/bcache.h b/bcache.h
index 6dcdbb7..46d9683 100644
--- a/bcache.h
+++ b/bcache.h
@@ -228,6 +228,8 @@ static inline int bch_has_feature_##name(struct cache_sb *sb) \
 } \
 static inline void bch_set_feature_##name(struct cache_sb *sb) \
 { \
+	if ((sb)->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
+		(sb)->version = BCACHE_SB_VERSION_CDEV_WITH_FEATURES; \
 	(sb)->feature_compat |= \
 		BCH##_FEATURE_COMPAT_##flagname; \
 } \
@@ -245,6 +247,8 @@ static inline int bch_has_feature_##name(struct cache_sb *sb) \
 } \
 static inline void bch_set_feature_##name(struct cache_sb *sb) \
 { \
+	if ((sb)->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
+		(sb)->version = BCACHE_SB_VERSION_CDEV_WITH_FEATURES; \
 	(sb)->feature_ro_compat |= \
 		BCH##_FEATURE_RO_COMPAT_##flagname; \
 } \
@@ -262,6 +266,8 @@ static inline int bch_has_feature_##name(struct cache_sb *sb) \
 } \
 static inline void bch_set_feature_##name(struct cache_sb *sb) \
 { \
+	if ((sb)->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
+		(sb)->version = BCACHE_SB_VERSION_CDEV_WITH_FEATURES; \
 	(sb)->feature_incompat |= \
 		BCH##_FEATURE_INCOMPAT_##flagname; \
 } \
-- 
2.26.2

