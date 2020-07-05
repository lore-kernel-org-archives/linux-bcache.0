From: Coly Li <colyli@suse.de>
Subject: [RFC PATCH 1/4] bcache-tools: comments offset for members of struct cache_sb
Date: Mon,  6 Jul 2020 00:04:37 +0800
Message-ID: <20200705160440.5801-2-colyli@suse.de>
References: <20200705160440.5801-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39504 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgGEQEu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 12:04:50 -0400
In-Reply-To: <20200705160440.5801-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

This patch adds code comments to mark the offset of each member from
struct cache_sb. It is helpful for understand the super block on disk.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.h | 64 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/bcache.h b/bcache.h
index c83f838..3fcf187 100644
--- a/bcache.h
+++ b/bcache.h
@@ -41,54 +41,58 @@ static const char bcache_magic[] = {
 #define SB_START		(SB_SECTOR * 512)
 
 struct cache_sb {
-	uint64_t		csum;
-	uint64_t		offset;	/* sector where this sb was written */
-	uint64_t		version;
+/*000*/	uint64_t		csum;
+	/* sector where this sb was written */
+/*008*/	uint64_t		offset;
+/*010*/	uint64_t		version;
 
-	uint8_t			magic[16];
+/*018*/	uint8_t			magic[16];
 
-	uint8_t			uuid[16];
+/*028*/	uint8_t			uuid[16];
 	union {
-		uint8_t		set_uuid[16];
-		uint64_t	set_magic;
+/*038*/		uint8_t		set_uuid[16];
+/*038*/		uint64_t	set_magic;
 	};
-	uint8_t			label[SB_LABEL_SIZE];
+/*048*/	uint8_t			label[SB_LABEL_SIZE];
 
-	uint64_t		flags;
-	uint64_t		seq;
-	uint64_t		pad[8];
+/*068*/	uint64_t		flags;
+/*070*/	uint64_t		seq;
+/*078*/	uint64_t		pad[8];
 
 	union {
 	struct {
-		/* Cache devices */
-		uint64_t	nbuckets;	/* device size */
+			/* Cache devices */
+/*0b8*/		uint64_t	nbuckets;	/* device size */
 
-		uint16_t	block_size;	/* sectors */
-		uint16_t	bucket_size;	/* sectors */
+/*0c0*/		uint16_t	block_size;	/* sectors */
+/*0c2*/		uint16_t	bucket_size;	/* sectors */
 
-		uint16_t	nr_in_set;
-		uint16_t	nr_this_dev;
+/*0c4*/		uint16_t	nr_in_set;
+/*0c6*/		uint16_t	nr_this_dev;
 	};
 	struct {
-		/* Backing devices */
-		uint64_t	data_offset;
-
-		/*
-		 * block_size from the cache device section is still used by
-		 * backing devices, so don't add anything here until we fix
-		 * things to not need it for backing devices anymore
-		 */
+			/* Backing devices */
+/*0b8*/		uint64_t	data_offset;
+
+			/*
+			 * block_size from the cache device section is still
+			 * used by backing devices, so don't add anything here
+			 * until we fix things to not need it for backing
+			 * devices anymore
+			 */
 	};
 	};
 
-	uint32_t		last_mount;	/* time_t */
+/*0c8*/	uint32_t		last_mount;	/* time_t */
 
-	uint16_t		first_bucket;
+/*0cc*/	uint16_t		first_bucket;
 	union {
-		uint16_t	njournal_buckets;
-		uint16_t	keys;
+/*0ce*/		uint16_t	njournal_buckets;
+/*0ce*/		uint16_t	keys;
 	};
-	uint64_t		d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+	/* journal buckets */
+/*0d0*/	uint64_t		d[SB_JOURNAL_BUCKETS];
+/*8d0*/
 };
 
 static inline bool SB_IS_BDEV(const struct cache_sb *sb)
-- 
2.26.2
