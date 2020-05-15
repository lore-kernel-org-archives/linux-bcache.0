From: Coly Li <colyli@suse.de>
Subject: [RFC PATCH 3/4] block: remove queue_is_mq restriction from blk_revalidate_disk_zones()
Date: Sat, 16 May 2020 00:31:56 +0800
Message-ID: <20200515163157.72796-4-colyli@suse.de>
References: <20200515163157.72796-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgEOQg3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 12:36:29 -0400
In-Reply-To: <20200515163157.72796-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com, hch@lst.de, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>

The bcache driver is bio based and NOT request based multiqueued driver,
if a zoned SMR hard drive is used as backing device of a bcache device,
calling blk_revalidate_disk_zones() for the bcache device will fail due
to the following check in blk_revalidate_disk_zones(),
478       if (WARN_ON_ONCE(!queue_is_mq(q)))
479             return -EIO;

Now bcache is able to export the zoned information from the underlying
zoned SMR drives and format zonefs on top of a bcache device, the
resitriction that a zoned device should be multiqueued is unnecessary
for now.

Although in commit ae58954d8734c ("block: don't handle bio based drivers
in blk_revalidate_disk_zones") it is said that bio based drivers should
not call blk_revalidate_disk_zones() and just manually update their own
q->nr_zones, but this is inaccurate. The bio based drivers also need to
set their zone size and initialize bitmaps for cnv and seq zones, it is
necessary to call blk_revalidate_disk_zones() for bio based drivers.

This patch removes the above queue_is_mq() restriction to permit
bcache driver calls blk_revalidate_disk_zones() for bcache device zoned
information initialization.

Fixes: ae58954d8734c ("block: don't handle bio based drivers in blk_revalidate_disk_zones")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-zoned.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index f87956e0dcaf..1e0708c68267 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -475,8 +475,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 
 	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
 		return -EIO;
-	if (WARN_ON_ONCE(!queue_is_mq(q)))
-		return -EIO;
 
 	/*
 	 * Ensure that all memory allocations in this context are done as if
-- 
2.25.0
