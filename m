From: Coly Li <colyli@suse.de>
Subject: [PATCH 3/3] bcache-tools: convert writeback to writethrough mode for zoned backing device
Date: Sat, 16 May 2020 22:09:40 +0800
Message-ID: <20200516140940.101190-4-colyli@suse.de>
References: <20200516140940.101190-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgEPOKa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 10:10:30 -0400
In-Reply-To: <20200516140940.101190-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>

Currently bcache does not support writeback cache mode for zoned device
as backing device.

If the backing device is zoned device, and cache mode is explicitly set
to writeback mode, a information will be print to terminal,
  "Zoned device <device name> detected: convert to writethrough mode."
Then the cache mode will be automatically converted to writethrough,
which is the default cache mode of bcache-tools.

Signed-off-by: Coly Li <colyli@suse.de>
---
 make.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/make.c b/make.c
index c1090a6..c5658ba 100644
--- a/make.c
+++ b/make.c
@@ -378,6 +378,19 @@ static void write_sb(char *dev, unsigned int block_size,
 		SET_BDEV_CACHE_MODE(&sb, writeback ?
 			CACHE_MODE_WRITEBACK : CACHE_MODE_WRITETHROUGH);
 
+		/*
+		 * Currently bcache does not support writeback mode for
+		 * zoned device as backing device. If the cache mode is
+		 * explicitly set to writeback, automatically convert to
+		 * writethough mode.
+		 */
+		if (is_zoned_device(dev) &&
+		    BDEV_CACHE_MODE(&sb) == CACHE_MODE_WRITEBACK) {
+			printf("Zoned device %s detected: convert to writethrough mode.\n",
+				dev);
+			SET_BDEV_CACHE_MODE(&sb, CACHE_MODE_WRITETHROUGH);
+		}
+
 		if (data_offset != BDEV_DATA_START_DEFAULT) {
 			sb.version = BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
 			sb.data_offset = data_offset;
-- 
2.25.0
