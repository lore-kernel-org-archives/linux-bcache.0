From: tang.junhui@zte.com.cn
Subject: Re: [for-416 PATCH 1/3] bcache: writeback: collapse contiguous IO better
Date: Thu, 28 Dec 2017 11:22:17 +0800
Message-ID: <1514431337-3528-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

I remember I have reviewed this patch befor, still there is a bug
in keys_contiguous(), since KEY_OFFSET(key) stores the end adress of the 
request IO, so I think we should judge the contiguous of keys as bellow:
    if (bkey_cmp(&first->key, &START_KEY(&second->key))
        return false;
Since bkey_cmp() also has judged the KEY_INODE(), so I think we can remove 
the KEY_INODE() judement.

Acctually, we can totally use bkey_cmp to replace keys_contiguous().

> Previously, there was some logic that attempted to immediately issue
> writeback of backing-contiguous blocks when the writeback rate was
> fast.
> 
> The previous logic did not have any limits on the aggregate size it
> would issue, nor the number of keys it would combine at once.  It
> would also discard the chance to do a contiguous write when the
> writeback rate was low-- e.g. at "background" writeback of target
> rate = 8, it would not combine two adjacent 4k writes and would
> instead seek the disk twice.
> 
> This patch imposes limits and explicitly understands the size of
> contiguous I/O during issue.  It also will combine contiguous I/O
> in all circumstances, not just when writeback is requested to be
> relatively fast.
> 
> It is a win on its own, but also lays the groundwork for skip writes to
> short keys to make the I/O more sequential/contiguous.  It also gets
> ready to start using blk_*_plug, and to allow issuing of non-contig
> I/O in parallel if requested by the user (to make use of disk
> throughput benefits available from higher queue depths).
> 
> This patch fixes a previous version where the contiguous information
> was not calculated properly.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> ---
>  drivers/md/bcache/bcache.h    |   6 --
>  drivers/md/bcache/writeback.c | 133 ++++++++++++++++++++++++++++++------------
>  drivers/md/bcache/writeback.h |   3 +
>  3 files changed, 98 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 843877e017e1..1784e50eb857 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -323,12 +323,6 @@ struct cached_dev {
>      struct bch_ratelimit    writeback_rate;
>      struct delayed_work    writeback_rate_update;
>  
> -    /*
> -     * Internal to the writeback code, so read_dirty() can keep track of
> -     * where it's at.
> -     */
> -    sector_t        last_read;
> -
>      /* Limit number of writeback bios in flight */
>      struct semaphore    in_flight;
>      struct task_struct    *writeback_thread;
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index f3d680c907ae..4e4836c6e7cf 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -248,10 +248,25 @@ static void read_dirty_submit(struct closure *cl)
>      continue_at(cl, write_dirty, io->dc->writeback_write_wq);
>  }
>  
> +static inline bool keys_contiguous(struct cached_dev *dc,
> +        struct keybuf_key *first, struct keybuf_key *second)
> +{
> +    if (KEY_INODE(&second->key) != KEY_INODE(&first->key))
> +        return false;
> +
> +    if (KEY_OFFSET(&second->key) !=
> +            KEY_OFFSET(&first->key) + KEY_SIZE(&first->key))
> +        return false;
> +
> +    return true;
> +}
> +
>  static void read_dirty(struct cached_dev *dc)
>  {
>      unsigned delay = 0;
> -    struct keybuf_key *w;
> +    struct keybuf_key *next, *keys[MAX_WRITEBACKS_IN_PASS], *w;
> +    size_t size;
> +    int nk, i;
>      struct dirty_io *io;
>      struct closure cl;
>  
> @@ -262,45 +277,87 @@ static void read_dirty(struct cached_dev *dc)
>       * mempools.
>       */
>  
> -    while (!kthread_should_stop()) {
> -
> -        w = bch_keybuf_next(&dc->writeback_keys);
> -        if (!w)
> -            break;
> -
> -        BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
> -
> -        if (KEY_START(&w->key) != dc->last_read ||
> -            jiffies_to_msecs(delay) > 50)
> -            while (!kthread_should_stop() && delay)
> -                delay = schedule_timeout_interruptible(delay);
> -
> -        dc->last_read    = KEY_OFFSET(&w->key);
> -
> -        io = kzalloc(sizeof(struct dirty_io) + sizeof(struct bio_vec)
> -                 * DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
> -                 GFP_KERNEL);
> -        if (!io)
> -            goto err;
> -
> -        w->private    = io;
> -        io->dc        = dc;
> -
> -        dirty_init(w);
> -        bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
> -        io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
> -        bio_set_dev(&io->bio, PTR_CACHE(dc->disk.c, &w->key, 0)->bdev);
> -        io->bio.bi_end_io    = read_dirty_endio;
> -
> -        if (bio_alloc_pages(&io->bio, GFP_KERNEL))
> -            goto err_free;
> -
> -        trace_bcache_writeback(&w->key);
> +    next = bch_keybuf_next(&dc->writeback_keys);
> +
> +    while (!kthread_should_stop() && next) {
> +        size = 0;
> +        nk = 0;
> +
> +        do {
> +            BUG_ON(ptr_stale(dc->disk.c, &next->key, 0));
> +
> +            /*
> +             * Don't combine too many operations, even if they
> +             * are all small.
> +             */
> +            if (nk >= MAX_WRITEBACKS_IN_PASS)
> +                break;
> +
> +            /*
> +             * If the current operation is very large, don't
> +             * further combine operations.
> +             */
> +            if (size >= MAX_WRITESIZE_IN_PASS)
> +                break;
> +
> +            /*
> +             * Operations are only eligible to be combined
> +             * if they are contiguous.
> +             *
> +             * TODO: add a heuristic willing to fire a
> +             * certain amount of non-contiguous IO per pass,
> +             * so that we can benefit from backing device
> +             * command queueing.
> +             */
> +            if (nk != 0 && !keys_contiguous(dc, keys[nk-1], next))
> +                break;
> +
> +            size += KEY_SIZE(&next->key);
> +            keys[nk++] = next;
> +        } while ((next = bch_keybuf_next(&dc->writeback_keys)));
> +
> +        /* Now we have gathered a set of 1..5 keys to write back. */
> +
> +        for (i = 0; i < nk; i++) {
> +            w = keys[i];
> +
> +            io = kzalloc(sizeof(struct dirty_io) +
> +                     sizeof(struct bio_vec) *
> +                     DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
> +                     GFP_KERNEL);
> +            if (!io)
> +                goto err;
> +
> +            w->private    = io;
> +            io->dc        = dc;
> +
> +            dirty_init(w);
> +            bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
> +            io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
> +            bio_set_dev(&io->bio,
> +                    PTR_CACHE(dc->disk.c, &w->key, 0)->bdev);
> +            io->bio.bi_end_io    = read_dirty_endio;
> +
> +            if (bio_alloc_pages(&io->bio, GFP_KERNEL))
> +                goto err_free;
> +
> +            trace_bcache_writeback(&w->key);
> +
> +            down(&dc->in_flight);
> +
> +            /* We've acquired a semaphore for the maximum
> +             * simultaneous number of writebacks; from here
> +             * everything happens asynchronously.
> +             */
> +            closure_call(&io->cl, read_dirty_submit, NULL, &cl);
> +        }
>  
> -        down(&dc->in_flight);
> -        closure_call(&io->cl, read_dirty_submit, NULL, &cl);
> +        delay = writeback_delay(dc, size);
>  
> -        delay = writeback_delay(dc, KEY_SIZE(&w->key));
> +        while (!kthread_should_stop() && delay) {
> +            schedule_timeout_interruptible(delay);
> +            delay = writeback_delay(dc, 0);
> +        }
>      }
>  
>      if (0) {
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index a9e3ffb4b03c..6d26927267f8 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -5,6 +5,9 @@
>  #define CUTOFF_WRITEBACK    40
>  #define CUTOFF_WRITEBACK_SYNC    70
>  
> +#define MAX_WRITEBACKS_IN_PASS  5
> +#define MAX_WRITESIZE_IN_PASS   5000    /* *512b */
> +
>  static inline uint64_t bcache_dev_sectors_dirty(struct bcache_device *d)
>  {
>      uint64_t i, ret = 0;
> -- 
> 2.14.1


Thanks,
Tang
