From: Rui Hua <huarui.dev@gmail.com>
Subject: [PATCH] bcache: return IOERR to upper layer when read request meet
 metadata error
Date: Tue, 21 Nov 2017 21:58:30 +0800
Message-ID: <CAPGwLLOXh7-T7HtXGWRTAuLh3La-njWtv44dgPZXUfbrUod1zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:42249 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdKUN6v (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Nov 2017 08:58:51 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>, Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org

The read request might meet error when searching the btree, but the error was
not handled in cache_lookup(), and this kind of metadata failure will not go
into cached_dev_read_error(), finally, the upper layer will receive bi_status=0.
In this patch we judge the metadata error by the return value of
bch_btree_map_keys(), there are two potential paths give rise to the error:
1.Because the btree is not totally cached in memery, we maybe get error when
  read btree node from cache device (see bch_btree_node_get()), the likely
  errno is -EIO, -ENOMEM
2.When read miss happend, bch_btree_insert_check_key() will be called to
  insert a "replace_key" to btree(see cached_dev_cache_miss(), just for doing
  preparatory work before insert the missed data to cache device), a failure
  can also happen in this situation, the likely errno is -ENOMEM
bch_btree_map_keys() will return MAP_DONE in normal scenario, but we will
get either -EIO or -ENOMEM in above two cases. if these happend, we should
NOT recover data from backing device (when cache device is dirty) because
we don't know whether bkeys the read request covered are all clean.
And after that happend, s->iop.status is still its initially value(0)
before we submit s->bio.bio, we set it to BLK_STS_IOERR, so it can go into
cached_dev_read_error(), and finally it can be passed to upper layer,
or recovered by reread from backing device.

Signed-off-by: Hua Rui <huarui.dev@gmail.com>
---
 drivers/md/bcache/request.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index f02fefb..b749431 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -576,6 +576,7 @@ static void cache_lookup(struct closure *cl)
 {
        struct search *s = container_of(cl, struct search, iop.cl);
        struct bio *bio = &s->bio.bio;
+       struct cached_dev *dc;
        int ret;

        bch_btree_op_init(&s->op, -1);
@@ -588,6 +589,27 @@ static void cache_lookup(struct closure *cl)
                return;
        }

+       /*
+        * We might meet err when searching the btree, If that happend, we will
+        * get negative ret, in this scenario we should not recover data from
+        * backing device (when cache device is dirty) because we don't know
+        * whether bkeys the read request covered are all clean.
+        *
+        * And after that happend, s->iop.status is still its initially value
+        * before we submit s->bio.bio
+        */
+        if (ret < 0) {
+                BUG_ON(ret == -EINTR);
+                if (s->d && s->d->c &&
+                        !UUID_FLASH_ONLY(&s->d->c->uuids[s->d->id])) {
+                        dc = container_of(s->d, struct cached_dev, disk);
+                        if (dc && atomic_read(&dc->has_dirty))
+                                s->recoverable = false;
+                }
+                if (!s->iop.status)
+                        s->iop.status = BLK_STS_IOERR;
+        }
+
        closure_return(cl);
 }

-- 
1.8.3.1
