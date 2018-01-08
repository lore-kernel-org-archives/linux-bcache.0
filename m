From: Michael Lyle <mlyle@lyle.org>
Subject: [416 PATCH 01/13] bcache: ret IOERR when read meets metadata error
Date: Mon,  8 Jan 2018 12:21:18 -0800
Message-ID: <20180108202130.31303-2-mlyle@lyle.org>
References: <20180108202130.31303-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180108202130.31303-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Rui Hua <huarui.dev@gmail.com>, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

From: Rui Hua <huarui.dev@gmail.com>

The read request might meet error when searching the btree, but the error
was not handled in cache_lookup(), and this kind of metadata failure will
not go into cached_dev_read_error(), finally, the upper layer will receive
bi_status=0.  In this patch we judge the metadata error by the return
value of bch_btree_map_keys(), there are two potential paths give rise to
the error:

1. Because the btree is not totally cached in memery, we maybe get error
   when read btree node from cache device (see bch_btree_node_get()), the
   likely errno is -EIO, -ENOMEM

2. When read miss happens, bch_btree_insert_check_key() will be called to
   insert a "replace_key" to btree(see cached_dev_cache_miss(), just for
   doing preparatory work before insert the missed data to cache device),
   a failure can also happen in this situation, the likely errno is
   -ENOMEM

bch_btree_map_keys() will return MAP_DONE in normal scenario, but we will
get either -EIO or -ENOMEM in above two cases. if this happened, we should
NOT recover data from backing device (when cache device is dirty) because
we don't know whether bkeys the read request covered are all clean.  And
after that happened, s->iop.status is still its initially value(0) before
we submit s->bio.bio, we set it to BLK_STS_IOERR, so it can go into
cached_dev_read_error(), and finally it can be passed to upper layer, or
recovered by reread from backing device.

[edit by mlyle: patch formatting, word-wrap, comment spelling,
commit log format]

Signed-off-by: Hua Rui <huarui.dev@gmail.com>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 drivers/md/bcache/request.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index c493fb947dc9..52b4ce24f9e2 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -576,6 +576,7 @@ static void cache_lookup(struct closure *cl)
 {
 	struct search *s = container_of(cl, struct search, iop.cl);
 	struct bio *bio = &s->bio.bio;
+	struct cached_dev *dc;
 	int ret;
 
 	bch_btree_op_init(&s->op, -1);
@@ -588,6 +589,27 @@ static void cache_lookup(struct closure *cl)
 		return;
 	}
 
+	/*
+	 * We might meet err when searching the btree, If that happens, we will
+	 * get negative ret, in this scenario we should not recover data from
+	 * backing device (when cache device is dirty) because we don't know
+	 * whether bkeys the read request covered are all clean.
+	 *
+	 * And after that happened, s->iop.status is still its initial value
+	 * before we submit s->bio.bio
+	 */
+	if (ret < 0) {
+		BUG_ON(ret == -EINTR);
+		if (s->d && s->d->c &&
+				!UUID_FLASH_ONLY(&s->d->c->uuids[s->d->id])) {
+			dc = container_of(s->d, struct cached_dev, disk);
+			if (dc && atomic_read(&dc->has_dirty))
+				s->recoverable = false;
+		}
+		if (!s->iop.status)
+			s->iop.status = BLK_STS_IOERR;
+	}
+
 	closure_return(cl);
 }
 
-- 
2.14.1
