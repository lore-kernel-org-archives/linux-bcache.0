From: tang.junhui@zte.com.cn
Subject: Re: [PATCH] bcache: fix unmatched generic_end_io_acct() &generic_start_io_acct()
Date: Wed, 3 Jan 2018 00:43:11 +0800
Message-ID: <1514911391-21692-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: kxuanobj@gmail.com
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>


>The function cached_dev_make_request() and flash_dev_make_request() call
>generic_start_io_acct() with (struct bcache_device)->disk when they start a
>closure. Then the function bio_complete() calls generic_end_io_acct() with
>(struct search)->orig_bio->bi_disk when the closure has done.
>Since the `bi_disk` is not the bcache device, the generic_end_io_acct() is
>called with a wrong device queue.
>
>It causes the "inflight" (in struct hd_struct) counter keep increasing
>without decreasing.
>
>This patch fix the problem by calling generic_end_io_acct() with
>(struct bcache_device)->disk.
>
>Signed-off-by: Zhai Zhaoxuan <kxuanobj@gmail.com>
>---
> drivers/md/bcache/request.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>index 643c3021624f..83de85fe4542 100644
>--- a/drivers/md/bcache/request.c
>+++ b/drivers/md/bcache/request.c
>@@ -611,8 +611,8 @@ static void request_endio(struct bio *bio)
> static void bio_complete(struct search *s)
> {
>     if (s->orig_bio) {
>-        struct request_queue *q = s->orig_bio->bi_disk->queue;
>-        generic_end_io_acct(q, bio_data_dir(s->orig_bio),
>+        generic_end_io_acct(s->d->disk->queue,
>+                    bio_data_dir(s->orig_bio),
>                     &s->d->disk->part0, s->start_time);
> 
>         trace_bcache_request_end(s->d, s->orig_bio);
>-- 
>2.15.1


LGTM.

Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

Thanks,
Tang Junhui
