From: Coly Li <colyli@suse.de>
Subject: [RFC PATCH v4 3/3] bcache: reject writeback cache mode for zoned backing device
Date: Fri, 22 May 2020 20:18:37 +0800
Message-ID: <20200522121837.109651-4-colyli@suse.de>
References: <20200522121837.109651-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728772AbgEVMS5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 May 2020 08:18:57 -0400
In-Reply-To: <20200522121837.109651-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Damien Le Moal <damien.lemoal@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>

Currently we don't support writeback mode for zoned device as backing
device. So reject it by sysfs interface.

This rejection will be removed after the writeback cache mode support
for zoned device gets done.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/bcache/sysfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 323276994aab..41bdbc42a17d 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -359,6 +359,11 @@ STORE(__cached_dev)
 		if (v < 0)
 			return v;
 
+		if ((unsigned int) v == CACHE_MODE_WRITEBACK) {
+			pr_err("writeback mode is not supported for zoned backing device.\n");
+			return -ENOTSUPP;
+		}
+
 		if ((unsigned int) v != BDEV_CACHE_MODE(&dc->sb)) {
 			SET_BDEV_CACHE_MODE(&dc->sb, v);
 			bch_write_bdev_super(dc, NULL);
-- 
2.25.0
