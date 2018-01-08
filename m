From: Michael Lyle <mlyle@lyle.org>
Subject: [416 PATCH 10/13] bcache: fix unmatched generic_end_io_acct() & generic_start_io_acct()
Date: Mon,  8 Jan 2018 12:21:27 -0800
Message-ID: <20180108202130.31303-11-mlyle@lyle.org>
References: <20180108202130.31303-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180108202130.31303-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Zhai Zhaoxuan <kxuanobj@gmail.com>
List-Id: linux-bcache@vger.kernel.org

From: Zhai Zhaoxuan <kxuanobj@gmail.com>

The function cached_dev_make_request() and flash_dev_make_request() call
generic_start_io_acct() with (struct bcache_device)->disk when they start a
closure. Then the function bio_complete() calls generic_end_io_acct() with
(struct search)->orig_bio->bi_disk when the closure has done.
Since the `bi_disk` is not the bcache device, the generic_end_io_acct() is
called with a wrong device queue.

It causes the "inflight" (in struct hd_struct) counter keep increasing
without decreasing.

This patch fix the problem by calling generic_end_io_acct() with
(struct bcache_device)->disk.

Signed-off-by: Zhai Zhaoxuan <kxuanobj@gmail.com>
Reviewed-by: Michael Lyle <mlyle@lyle.org>
Reviewed-by: Coly Li <colyli@suse.de>
Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/md/bcache/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index ddd941056f3c..1a46b41dac70 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -633,8 +633,8 @@ static void request_endio(struct bio *bio)
 static void bio_complete(struct search *s)
 {
 	if (s->orig_bio) {
-		struct request_queue *q = s->orig_bio->bi_disk->queue;
-		generic_end_io_acct(q, bio_data_dir(s->orig_bio),
+		generic_end_io_acct(s->d->disk->queue,
+				    bio_data_dir(s->orig_bio),
 				    &s->d->disk->part0, s->start_time);
 
 		trace_bcache_request_end(s->d, s->orig_bio);
-- 
2.14.1
