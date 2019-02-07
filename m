From: Coly Li <colyli@suse.de>
Subject: [PATCH v2] bcache: use (REQ_META|REQ_PRIO) to indicate bio for metadata
Date: Thu,  7 Feb 2019 21:11:44 +0800
Message-ID: <20190207131144.3385-1-colyli@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-bcache@vger.kernel.org

In 'commit 752f66a75aba ("bcache: use REQ_PRIO to indicate bio for
metadata")' REQ_META is replaced by REQ_PRIO to indicate metadata bio.
This assumption is not always correct, e.g. XFS uses REQ_META to mark
metadata bio other than REQ_PRIO. This is why Nix noticed that bcache
does not cache metadata for XFS after the above commit.

Thanks to Dave Chinner, he explains the difference between REQ_META and
REQ_PRIO from view of file system developer. Here I quote part of his
explanation from mailing list,
   REQ_META is used for metadata. REQ_PRIO is used to communicate to
   the lower layers that the submitter considers this IO to be more
   important that non REQ_PRIO IO and so dispatch should be expedited.

   IOWs, if the filesystem considers metadata IO to be more important
   that user data IO, then it will use REQ_PRIO | REQ_META rather than
   just REQ_META.

Then it seems bios with REQ_META or REQ_PRIO should both be cached for
performance optimation, because they are all probably low I/O latency
demand by upper layer (e.g. file system).

So in this patch, when we want to decide whether to bypass the cache,
REQ_META and REQ_PRIO are both checked. Then both metadata and
high priority I/O requests will be handled properly.

Reported-by: Nix <nix@esperi.org.uk>
Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Andre Noll <maan@tuebingen.mpg.de>
Cc: stable@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3bf35914bb57..62bda90a38dc 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -395,7 +395,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	 * unless the read-ahead request is for metadata (eg, for gfs2 or xfs).
 	 */
 	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
-	    !(bio->bi_opf & REQ_PRIO))
+	    !(bio->bi_opf & (REQ_META|REQ_PRIO)))
 		goto skip;
 
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
@@ -877,7 +877,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	}
 
 	if (!(bio->bi_opf & REQ_RAHEAD) &&
-	    !(bio->bi_opf & REQ_PRIO) &&
+	    !(bio->bi_opf & (REQ_META|REQ_PRIO)) &&
 	    s->iop.c->gc_stats.in_use < CUTOFF_CACHE_READA)
 		reada = min_t(sector_t, dc->readahead >> 9,
 			      get_capacity(bio->bi_disk) - bio_end_sector(bio));
-- 
2.16.4
