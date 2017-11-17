From: Rui Hua <huarui.dev@gmail.com>
Subject: [PATCH] bcache: recover data from backing device when read request
 hit clean
Date: Fri, 17 Nov 2017 11:51:12 +0800
Message-ID: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <i@coly.li>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

When we send a read request and hit the clean data in cache device, there
is a situation called cache read race in bcache(see the commit in the tail
of cache_look_up(), the following explaination just copy from there):
The bucket we're reading from might be reused while our bio is in flight,
and we could then end up reading the wrong data. We guard against this
by checking (in bch_cache_read_endio()) if the pointer is stale again;
if so, we treat it as an error (s->iop.error = -EINTR) and reread from
the backing device (but we don't pass that error up anywhere)

It should be noted that cache read race happened under normal
circumstances, not the circumstance when SSD failed, it was counted
and shown in  /sys/fs/bcache/XXX/internal/cache_read_races.

Without this patch, when we use writeback mode, we will never reread from
the backing device when cache read race happend, until the whole cache
device is clean, because the condition
(s->recoverable && (dc && !atomic_read(&dc->has_dirty))) is false in
cached_dev_read_error(). In this situation, the s->iop.error(= -EINTR)
will be passed up, at last, user will receive -EINTR when it's bio end,
this is not suitable, and wield to up-application.

In this patch, we use s->read_dirty_data to judge whether the read
request hit dirty data in cache device, it is safe to reread data from
the backing device when the read request hit clean data. This can not
only handle cache read race, but also recover data when failed read
request from cache device.

Signed-off-by: Hua Rui <huarui.dev@gmail.com>
---
 drivers/md/bcache/request.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3a7aed7..f02fefb 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -708,16 +708,15 @@ static void cached_dev_read_error(struct closure *cl)
 {
        struct search *s = container_of(cl, struct search, cl);
        struct bio *bio = &s->bio.bio;
-       struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);

        /*
-        * If cache device is dirty (dc->has_dirty is non-zero), then
-        * recovery a failed read request from cached device may get a
-        * stale data back. So read failure recovery is only permitted
-        * when cache device is clean.
+        * If read request hit dirty data (s->read_dirty_data is true),
+        * then recovery a failed read request from cached device may
+        * get a stale data back. So read failure recovery is only
+        * permitted when read request hit clean data in cache device,
+        * or when cache read race happend.
         */
-       if (s->recoverable &&
-           (dc && !atomic_read(&dc->has_dirty))) {
+       if (s->recoverable && !s->read_dirty_data) {
                /* Retry from the backing device: */
                trace_bcache_read_retry(s->orig_bio);

-- 
1.8.3.1
