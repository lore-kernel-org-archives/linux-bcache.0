From: tang.junhui@zte.com.cn
Subject: [PATCH] [PATCH V2] bcache: fix wrong cache_misses statistics
Date: Sat, 28 Oct 2017 10:39:51 +0800
Message-ID: <1509158391-31992-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:37886 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdJ1Ckb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 22:40:31 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: bcache@lists.ewheeler.net, colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: "tang.junhui" <tang.junhui@zte.com.cn>

Currently, Cache missed IOs are identified by s->cache_miss, but actually,
there are many situations that missed IOs are not assigned a value for
s->cache_miss in cached_dev_cache_miss(), for example, a bypassed IO
(s->iop.bypass = 1), or the cache_bio allocate failed. In these situations,
it will go to out_put or out_submit, and s->cache_miss is null, which leads
bch_mark_cache_accounting() to treat this IO as a hit IO.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/request.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 76d2087..8f280e9 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -468,6 +468,7 @@ struct search {
 	unsigned		recoverable:1;
 	unsigned		write:1;
 	unsigned		read_dirty_data:1;
+	unsigned		cache_missed:1;
 
 	unsigned long		start_time;
 
@@ -653,6 +654,7 @@ static inline struct search *search_alloc(struct bio *bio,
 
 	s->orig_bio		= bio;
 	s->cache_miss		= NULL;
+	s->cache_missed		= 0;
 	s->d			= d;
 	s->recoverable		= 1;
 	s->write		= op_is_write(bio_op(bio));
@@ -764,7 +766,7 @@ static void cached_dev_read_done_bh(struct closure *cl)
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
 	bch_mark_cache_accounting(s->iop.c, s->d,
-				  !s->cache_miss, s->iop.bypass);
+				  !s->cache_missed, s->iop.bypass);
 	trace_bcache_read(s->orig_bio, !s->cache_miss, s->iop.bypass);
 
 	if (s->iop.error)
@@ -783,6 +785,8 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 	struct bio *miss, *cache_bio;
 
+	s->cache_missed = 1;
+
 	if (s->cache_miss || s->iop.bypass) {
 		miss = bio_next_split(bio, sectors, GFP_NOIO, s->d->bio_split);
 		ret = miss == bio ? MAP_DONE : MAP_CONTINUE;
-- 
2.8.1.windows.1
