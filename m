From: Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: back to cache all readahead I/Os
Date: Sat,  4 Jan 2020 14:58:02 +0800
Message-ID: <20200104065802.113137-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, stable@vger.kernel.org, Eric Wheeler <bcache@linux.ewheeler.net>
List-Id: linux-bcache@vger.kernel.org

In year 2007 high performance SSD was still expensive, in order to
save more space for real workload or meta data, the readahead I/Os
for non-meta data was bypassed and not cached on SSD.

In now days, SSD price drops a lot and people can find larger size
SSD with more comfortable price. It is unncessary to bypass normal
readahead I/Os to save SSD space for now.

This patch removes the code which checks REQ_RAHEAD tag of bio in
check_should_bypass(), then all readahead I/Os will be cached on SSD.

NOTE: this patch still keeps the checking of "REQ_META|REQ_PRIO" in
should_writeback(), because we still want to cache meta data I/Os
even they are asynchronized.

Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Eric Wheeler <bcache@linux.ewheeler.net>
---
 drivers/md/bcache/request.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 73478a91a342..acc07c4f27ae 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -378,15 +378,6 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	     op_is_write(bio_op(bio))))
 		goto skip;
 
-	/*
-	 * Flag for bypass if the IO is for read-ahead or background,
-	 * unless the read-ahead request is for metadata
-	 * (eg, for gfs2 or xfs).
-	 */
-	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
-	    !(bio->bi_opf & (REQ_META|REQ_PRIO)))
-		goto skip;
-
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
 	    bio_sectors(bio) & (c->sb.block_size - 1)) {
 		pr_debug("skipping unaligned io");
-- 
2.16.4
