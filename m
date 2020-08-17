Return-Path: <SRS0=Zhg3=B3=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2006C433E1
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 12:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B6A32075B
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 12:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgHQMGR (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 17 Aug 2020 08:06:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:53432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgHQMGQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A02B6AEDA
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:06:40 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 3/8] bcache-tools: list.h: only define offsetof() when it is undefined
Date:   Mon, 17 Aug 2020 20:05:53 +0800
Message-Id: <20200817120558.4491-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817120558.4491-1-colyli@suse.de>
References: <20200817120558.4491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

For new gcc headers, offsetof() is defined, the definition in list.h
will be warned as redefined.

This patch checks whether offsetof() is defined, and only defines local
version of offsetof() when it is not defined by gcc headers.

Signed-off-by: Coly Li <colyli@suse.de>
---
 list.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/list.h b/list.h
index 55d2bb4..458281d 100644
--- a/list.h
+++ b/list.h
@@ -25,10 +25,12 @@
  */
 /*@{*/
 
+#ifndef offsetof
 /**
  * Get offset of a member
  */
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif /* offsetof*/
 
 /**
  * Casts a member of a structure out to the containing structure
-- 
2.26.2

