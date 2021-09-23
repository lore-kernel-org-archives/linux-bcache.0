Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB20C433EF
	for <linux-bcache@archiver.kernel.org>; Thu, 23 Sep 2021 06:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6BEC610D1
	for <linux-bcache@archiver.kernel.org>; Thu, 23 Sep 2021 06:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239266AbhIWGUz (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Thu, 23 Sep 2021 02:20:55 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48210 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbhIWGUz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Sep 2021 02:20:55 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1CD0F2234A;
        Thu, 23 Sep 2021 06:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632377963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ySO0NWtZIUIpUWMuie7uHAGLlZagMHeoDLXHhNX1Xe0=;
        b=IgmhpfMOIlwbiMIzDE+0NO3pPQtoh935FGMzmeUWAjx7FdhMJi6wyeyJMjFPMrCPvluqBq
        lk+8MhhUqVaAb2JOEWgI+7wHE5w253kll1iqBgMSdp3tJqAhNjaOCzMG+jYQJ+R4ju0b4/
        jWzfOLvhO5jSKPOFNcbjVPwig0e2G8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632377963;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ySO0NWtZIUIpUWMuie7uHAGLlZagMHeoDLXHhNX1Xe0=;
        b=bCSEMyLiFwTKcYtMGiBwacNLOyhJAafE/KspGKLR6zHx0NfmiLzBKnwuRaGHuwpvxqzrvD
        tXJNsMIvklqZTJAg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay1.suse.de (Postfix) with ESMTP id 6EBF825CEB;
        Thu, 23 Sep 2021 06:19:21 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: reserve never used bits from bkey.high
Date:   Thu, 23 Sep 2021 14:19:13 +0800
Message-Id: <20210923061913.25421-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There sre 3 bits in member high of struct bkey are never used, and no
plan to support them in future,
- HEADER_SIZE, start at bit 58, length 2 bits
- KEY_PINNED,  start at bit 55, length 1 bit

No any kernel code, or user space tool references or accesses the three
bits. Therefore it is possible and feasible to reserve the valuable bits
from bkey.high. They can be used in future for other purpose.

Signed-off-by: Coly Li <colyli@suse.de>
---
 include/uapi/linux/bcache.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index cf7399f03b71..97413586195b 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -43,9 +43,9 @@ static inline void SET_##name(struct bkey *k, unsigned int i, __u64 v)	\
 #define KEY_MAX_U64S		8
 
 KEY_FIELD(KEY_PTRS,	high, 60, 3)
-KEY_FIELD(HEADER_SIZE,	high, 58, 2)
+KEY_FIELD(__PAD0,	high, 58, 2)
 KEY_FIELD(KEY_CSUM,	high, 56, 2)
-KEY_FIELD(KEY_PINNED,	high, 55, 1)
+KEY_FIELD(__PAD1,	high, 55, 1)
 KEY_FIELD(KEY_DIRTY,	high, 36, 1)
 
 KEY_FIELD(KEY_SIZE,	high, 20, KEY_SIZE_BITS)
-- 
2.31.1

