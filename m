From: bcache@lists.ewheeler.net
Subject: [PATCH 04/19] bcache: fix wrong cache_misses statistics
Date: Fri, 30 Jun 2017 13:42:53 -0700
Message-ID: <1498855388-16990-4-git-send-email-bcache@lists.ewheeler.net>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:43804 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752592AbdF3Unx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Jun 2017 16:43:53 -0400
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Some missed IOs are not counted into cache_misses, this patch fix this
issue.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/request.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 4b413db..d27707d 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -462,6 +462,7 @@ struct search {
 	unsigned		recoverable:1;
 	unsigned		write:1;
 	unsigned		read_dirty_data:1;
+	unsigned		cache_missed:1;
 
 	unsigned long		start_time;
 
@@ -647,6 +648,7 @@ static inline struct search *search_alloc(struct bio *bio,
 
 	s->orig_bio		= bio;
 	s->cache_miss		= NULL;
+	s->cache_missed		= 0;
 	s->d			= d;
 	s->recoverable		= 1;
 	s->write		= op_is_write(bio_op(bio));
@@ -758,7 +760,7 @@ static void cached_dev_read_done_bh(struct closure *cl)
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
 	bch_mark_cache_accounting(s->iop.c, s->d,
-				  !s->cache_miss, s->iop.bypass);
+				  !s->cache_missed, s->iop.bypass);
 	trace_bcache_read(s->orig_bio, !s->cache_miss, s->iop.bypass);
 
 	if (s->iop.status)
@@ -777,6 +779,8 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 	struct bio *miss, *cache_bio;
 
+	s->cache_missed = 1; /* true */
+
 	if (s->cache_miss || s->iop.bypass) {
 		miss = bio_next_split(bio, sectors, GFP_NOIO, s->d->bio_split);
 		ret = miss == bio ? MAP_DONE : MAP_CONTINUE;
-- 
1.8.3.1
