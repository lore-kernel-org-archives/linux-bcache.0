From: tang.junhui@zte.com.cn
Subject: Re: [for-416 PATCH 3/3] bcache: allow quick writeback when backing idle
Date: Tue, 2 Jan 2018 15:02:52 +0800
Message-ID: <1514876572-10611-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

I noticed you add "closure_sync(&cl)" before assigning delay to zero in your patch, 
I think we should add it before:
delay = writeback_delay(dc, size)
otherwise we would alays get a wrong value of delay after calling writeback_delay(), 
since the write-back IO is just sended out and not finished yet.

Am I right?

>If the control system would wait for at least half a second, and there's
>been no reqs hitting the backing disk for awhile: use an alternate mode
>where we have at most one contiguous set of writebacks in flight at a
>time. (But don't otherwise delay).  If front-end IO appears, it will
>still be quick, as it will only have to contend with one real operation
>in flight.  But otherwise, we'll be sending data to the backing disk as
>quickly as it can accept it (with one op at a time).
>
>Signed-off-by: Michael Lyle <mlyle@lyle.org>
>---
> drivers/md/bcache/bcache.h    |  7 +++++++
> drivers/md/bcache/request.c   |  1 +
> drivers/md/bcache/writeback.c | 21 +++++++++++++++++++++
> 3 files changed, 29 insertions(+)
>
>diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>index 3be0fcc19b1f..5f7b0b2513cc 100644
>--- a/drivers/md/bcache/bcache.h
>+++ b/drivers/md/bcache/bcache.h
>@@ -320,6 +320,13 @@ struct cached_dev {
>      */
>     atomic_t        has_dirty;
> 
>+    /*
>+     * Set to zero by things that touch the backing volume-- except
>+     * writeback.  Incremented by writeback.  Used to determine when to
>+     * accelerate idle writeback.
>+     */
>+    atomic_t        backing_idle;
>+
>     struct bch_ratelimit    writeback_rate;
>     struct delayed_work    writeback_rate_update;
> 
>diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>index d1faaba6b93f..3b4defbdcbbd 100644
>--- a/drivers/md/bcache/request.c
>+++ b/drivers/md/bcache/request.c
>@@ -996,6 +996,7 @@ static blk_qc_t cached_dev_make_request(struct request_queue *q,
>     struct cached_dev *dc = container_of(d, struct cached_dev, disk);
>     int rw = bio_data_dir(bio);
> 
>+    atomic_set(&dc->backing_idle, 0);
>     generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
> 
>     bio_set_dev(bio, dc->bdev);
>diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>index 4084586d5991..bf309a480335 100644
>--- a/drivers/md/bcache/writeback.c
>+++ b/drivers/md/bcache/writeback.c
>@@ -383,6 +383,27 @@ static void read_dirty(struct cached_dev *dc)
> 
>         delay = writeback_delay(dc, size);
> 
>+        /* If the control system would wait for at least half a
>+         * second, and there's been no reqs hitting the backing disk
>+         * for awhile: use an alternate mode where we have at most
>+         * one contiguous set of writebacks in flight at a time.  If
>+         * someone wants to do IO it will be quick, as it will only
>+         * have to contend with one operation in flight, and we'll
>+         * be round-tripping data to the backing disk as quickly as
>+         * it can accept it.
>+         */
>+        if (delay >= HZ / 2) {
>+            /* 3 means at least 1.5 seconds, up to 7.5 if we
>+             * have slowed way down.
>+             */
>+            if (atomic_inc_return(&dc->backing_idle) >= 3) {
>+                /* Wait for current I/Os to finish */
>+                closure_sync(&cl);
>+                /* And immediately launch a new set. */
>+                delay = 0;
>+            }
>+        }
>+
>         while (!kthread_should_stop() && delay) {
>             schedule_timeout_interruptible(delay);
>             delay = writeback_delay(dc, 0);
>-- 

Thanks,
Tang Junhui
