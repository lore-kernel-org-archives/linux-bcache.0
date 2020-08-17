Return-Path: <SRS0=Zhg3=B3=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48244C433E1
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 12:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 292752072E
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 12:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgHQMGN (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 17 Aug 2020 08:06:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:53400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgHQMGN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 729AFAEDA
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:06:37 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 2/8] bcache-tools: bitwise.h: more swap bitwise for different CPU endians
Date:   Mon, 17 Aug 2020 20:05:52 +0800
Message-Id: <20200817120558.4491-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817120558.4491-1-colyli@suse.de>
References: <20200817120558.4491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds more swap routines to bitwise.h,
	le16_to_cpu()
	le32_to_cpu()
	le64_to_cpu()

Signed-off-by: Coly Li <colyli@suse.de>
---
 bitwise.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/bitwise.h b/bitwise.h
index 968002f..1194b27 100644
--- a/bitwise.h
+++ b/bitwise.h
@@ -45,11 +45,21 @@
 #define cpu_to_le16(val)	((__le16)(val))
 #define cpu_to_le32(val)	((__le32)(val))
 #define cpu_to_le64(val)	((__le64)(val))
+
+#define le16_to_cpu(val)	((__le16)(val))
+#define le32_to_cpu(val)	((__le32)(val))
+#define le64_to_cpu(val)	((__le64)(val))
+
 #else
 /* For big endian */
 #define cpu_to_le16(val)	((__be16)__swab16((__u16)(val)))
 #define cpu_to_le32(val)	((__be32)__swab32((__u32)(val)))
 #define cpu_to_le64(val)	((__be64)__swab64((__u64)(val)))
+
+#define le16_to_cpu(val)	((__be16)__swab16((__u16)(val)))
+#define le32_to_cpu(val)	((__be32)__swab32((__u32)(val)))
+#define le64_to_cpu(val)	((__be64)__swab64((__u64)(val)))
+
 #endif
 
 #endif
-- 
2.26.2

