Return-Path: <SRS0=Zhg3=B3=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF79C433DF
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 12:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D23F2072E
	for <linux-bcache@archiver.kernel.org>; Mon, 17 Aug 2020 12:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHQMGL (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Mon, 17 Aug 2020 08:06:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:53332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgHQMGJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 08:06:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D7985AEDA
        for <linux-bcache@vger.kernel.org>; Mon, 17 Aug 2020 12:06:33 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 1/8] bcache-tools: add struct cache_sb_disk into bcache.h
Date:   Mon, 17 Aug 2020 20:05:51 +0800
Message-Id: <20200817120558.4491-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817120558.4491-1-colyli@suse.de>
References: <20200817120558.4491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is to sync the data structure from bcache kernel code uapi header.
The new added struct cache_sb_disk is used to define the on-disk format
bcache super block. Later struct cache_sb will be used for the in-memory
format bcache super block.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.h | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/bcache.h b/bcache.h
index c83f838..82fe580 100644
--- a/bcache.h
+++ b/bcache.h
@@ -7,6 +7,8 @@
 #ifndef _BCACHE_H
 #define _BCACHE_H
 
+#include <linux/types.h>
+
 #define BITMASK(name, type, field, offset, size)		\
 static inline uint64_t name(const type *k)			\
 { return (k->field >> offset) & ~(((uint64_t) ~0) << size); }	\
@@ -40,6 +42,58 @@ static const char bcache_magic[] = {
 #define BDEV_DATA_START_DEFAULT	16	/* sectors */
 #define SB_START		(SB_SECTOR * 512)
 
+struct cache_sb_disk {
+	__le64			csum;
+	__le64			offset; /* sector where this sb was written */
+	__le64			version;
+
+	__u8			magic[16];
+
+	__u8			uuid[16];
+	union {
+		__u8		set_uuid[16];
+		__le64		set_magic;
+	};
+	__u8			label[SB_LABEL_SIZE];
+
+	__le64			flags;
+	__le64			seq;
+
+	__le64			pad[8];
+
+	union {
+	struct {
+		/* Cache devices */
+		__le64		nbuckets;	/* device size */
+
+		__le16		block_size;	/* sectors */
+		__le16		bucket_size;	/* sectors */
+
+		__le16		nr_in_set;
+		__le16		nr_this_dev;
+	};
+	struct {
+		/* Backing devices */
+		__le64		data_offset;
+
+		/*
+		 * block_size from the cache device section is still used by
+		 * backing devices, so don't add anything here until we fix
+		 * things to not need it for backing devices anymore
+		 */
+	};
+	};
+
+	__le32			last_mount;		/* time overflow in y2106 */
+
+	__le16			first_bucket;
+	union {
+		__le16		njournal_buckets;
+		__le16		keys;
+	};
+	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+};
+
 struct cache_sb {
 	uint64_t		csum;
 	uint64_t		offset;	/* sector where this sb was written */
-- 
2.26.2

