From: tang.junhui@zte.com.cn
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Wed, 27 Sep 2017 15:32:33 +0800
Message-ID: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:38372 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751936AbdI0Hcf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 03:32:35 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: i@coly.li, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Tang Junhui <tang.junhui@zte.com.cn>

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Mike:

For the second question, I thinks this modification is somewhat complex, 
cannot we do something simple to resolve it? I remember there were some
patches trying to avoid too small writeback rate, Coly, is there any 
progress now?

-------
Tang Junhui
                       
> Ah-- re #1 -- I was investigating earlier why not as much was combined
> as I thought should be when idle.  This is surely a factor.  Thanks
> for the catch-- KEY_OFFSET is correct.  I will fix and retest.
> 
> (Under heavy load, the correct thing still happens, but not under
> light or intermediate load0.
> 
> About #2-- I wanted to attain a bounded amount of "combining" of
> operations.  If we have 5 4k extents in a row to dispatch, it seems
> really wasteful to issue them as 5 IOs 60ms apart, which the existing
> code would be willing to do-- I'd rather do a 20k write IO (basically
> the same cost as a 4k write IO) and then sleep 300ms.  It is dependent
> on the elevator/IO scheduler merging the requests.  At the same time,
> I'd rather not combine a really large request.
> 
> It would be really neat to blk_plug the backing device during the
> write issuance, but that requires further work.
> 
> Thanks
> 
> Mike
> 
> On Tue, Sep 26, 2017 at 11:51 PM,  <tang.junhui@zte.com.cn> wrote:
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> >
> > Hello Lyle:
> >
> > Two questions:
> > 1) In keys_contiguous(), you judge I/O contiguous in cache device, but not
> > in backing device. I think you should judge it by backing device (remove
> > PTR_CACHE() and use KEY_OFFSET() instead of PTR_OFFSET()?).
> >
> > 2) I did not see you combine samll contiguous I/Os to big I/O, so I think
> > it is useful when writeback rate was low by avoiding single I/O write, but
> > have no sense in high writeback rate, since previously it is also write
> > I/Os asynchronously.
> >
> > -----------
> > Tang Junhui
> >
> >> Previously, there was some logic that attempted to immediately issue
> >> writeback of backing-contiguous blocks when the writeback rate was
> >> fast.
> >>
> >> The previous logic did not have any limits on the aggregate size it
> >> would issue, nor the number of keys it would combine at once.  It
> >> would also discard the chance to do a contiguous write when the
> >> writeback rate was low-- e.g. at "background" writeback of target
> >> rate = 8, it would not combine two adjacent 4k writes and would
> >> instead seek the disk twice.
> >>
> >> This patch imposes limits and explicitly understands the size of
> >> contiguous I/O during issue.  It also will combine contiguous I/O
> >> in all circumstances, not just when writeback is requested to be
> >> relatively fast.
> >>
> >> It is a win on its own, but also lays the groundwork for skip writes to
> >> short keys to make the I/O more sequential/contiguous.
> >>
> >> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> >> ---
> >>  drivers/md/bcache/bcache.h    |   6 --
> >>  drivers/md/bcache/writeback.c | 131 ++++++++++++++++++++++++++++++------------
> >>  2 files changed, 93 insertions(+), 44 deletions(-)
> >>
> >> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> >> index eb83be693d60..da803a3b1981 100644
> >> --- a/drivers/md/bcache/bcache.h
> >> +++ b/drivers/md/bcache/bcache.h
> >> @@ -321,12 +321,6 @@ struct cached_dev {
> >>                struct bch_ratelimit            writeback_rate;
> >>                struct delayed_work             writeback_rate_update;
> >>
> >> -              /*
> >> -               * Internal to the writeback code, so read_dirty() can keep track of
> >> -               * where it's at.
> >> -               */
> >> -              sector_t                                last_read;
> >> -
> >>                /* Limit number of writeback bios in flight */
> >>                struct semaphore                in_flight;
> >>                struct task_struct              *writeback_thread;
> >> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> >> index 0b7c89813635..cf29c44605b9 100644
> >> --- a/drivers/md/bcache/writeback.c
> >> +++ b/drivers/md/bcache/writeback.c
> >> @@ -229,10 +229,26 @@ static void read_dirty_submit(struct closure *cl)
> >>                continue_at(cl, write_dirty, io->dc->writeback_write_wq);
> >>  }
> >>
> >> +static inline bool keys_contiguous(struct cached_dev *dc,
> >> +                              struct keybuf_key *first, struct keybuf_key *second)
> >> +{
> >> +              if (PTR_CACHE(dc->disk.c, &second->key, 0)->bdev !=
> >> +                                              PTR_CACHE(dc->disk.c, &first->key, 0)->bdev)
> >> +                              return false;
> >> +
> >> +              if (PTR_OFFSET(&second->key, 0) !=
> >> +                                              (PTR_OFFSET(&first->key, 0) + KEY_SIZE(&first->key)))
> >> +                              return false;
> >> +
> >> +              return true;
> >> +}
> >> +
> >>  static void read_dirty(struct cached_dev *dc)
> >>  {
> >>                unsigned delay = 0;
> >> -              struct keybuf_key *w;
> >> +              struct keybuf_key *next, *keys[5], *w;
> >> +              size_t size;
> >> +              int nk, i;
> >>                struct dirty_io *io;
> >>                struct closure cl;
> >>
> >> @@ -243,45 +259,84 @@ static void read_dirty(struct cached_dev *dc)
> >>                 * mempools.
> >>                 */
> >>
> >> -              while (!kthread_should_stop()) {
> >> -
> >> -                              w = bch_keybuf_next(&dc->writeback_keys);
> >> -                              if (!w)
> >> -                                              break;
> >> -
> >> -                              BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
> >> -
> >> -                              if (KEY_START(&w->key) != dc->last_read ||
> >> -                                  jiffies_to_msecs(delay) > 50)
> >> -                                              while (!kthread_should_stop() && delay)
> >> -                                                              delay = schedule_timeout_interruptible(delay);
> >> -
> >> -                              dc->last_read           = KEY_OFFSET(&w->key);
> >> -
> >> -                              io = kzalloc(sizeof(struct dirty_io) + sizeof(struct bio_vec)
> >> -                                                   * DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
> >> -                                                   GFP_KERNEL);
> >> -                              if (!io)
> >> -                                              goto err;
> >> -
> >> -                              w->private              = io;
> >> -                              io->dc                          = dc;
> >> -
> >> -                              dirty_init(w);
> >> -                              bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
> >> -                              io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
> >> -                              bio_set_dev(&io->bio, PTR_CACHE(dc->disk.c, &w->key, 0)->bdev);
> >> -                              io->bio.bi_end_io               = read_dirty_endio;
> >> -
> >> -                              if (bio_alloc_pages(&io->bio, GFP_KERNEL))
> >> -                                              goto err_free;
> >> -
> >> -                              trace_bcache_writeback(&w->key);
> >> +              next = bch_keybuf_next(&dc->writeback_keys);
> >> +
> >> +              while (!kthread_should_stop() && next) {
> >> +                              size = 0;
> >> +                              nk = 0;
> >> +
> >> +                              do {
> >> +                                              BUG_ON(ptr_stale(dc->disk.c, &next->key, 0));
> >> +
> >> +                                              /* Don't combine too many operations, even if they
> >> +                                               * are all small.
> >> +                                               */
> >> +                                              if (nk >= 5)
> >> +                                                              break;
> >> +
> >> +                                              /* If the current operation is very large, don't
> >> +                                               * further combine operations.
> >> +                                               */
> >> +                                              if (size > 5000)
> >> +                                                              break;
> >> +
> >> +                                              /* Operations are only eligible to be combined
> >> +                                               * if they are contiguous.
> >> +                                               *
> >> +                                               * TODO: add a heuristic willing to fire a
> >> +                                               * certain amount of non-contiguous IO per pass,
> >> +                                               * so that we can benefit from backing device
> >> +                                               * command queueing.
> >> +                                               */
> >> +                                              if (nk != 0 && !keys_contiguous(dc, keys[nk-1], next))
> >> +                                                              break;
> >> +
> >> +                                              size += KEY_SIZE(&next->key);
> >> +                                              keys[nk++] = next;
> >> +                              } while ((next = bch_keybuf_next(&dc->writeback_keys)));
> >> +
> >> +                              /* Now we have gathered a set of 1..5 keys to write back. */
> >> +
> >> +                              for (i = 0; i < nk; i++) {
> >> +                                              w = keys[i];
> >> +
> >> +                                              io = kzalloc(sizeof(struct dirty_io) +
> >> +                                                                   sizeof(struct bio_vec) *
> >> +                                                                   DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS),
> >> +                                                                   GFP_KERNEL);
> >> +                                              if (!io)
> >> +                                                              goto err;
> >> +
> >> +                                              w->private              = io;
> >> +                                              io->dc                          = dc;
> >> +
> >> +                                              dirty_init(w);
> >> +                                              bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
> >> +                                              io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
> >> +                                              bio_set_dev(&io->bio,
> >> +                                                                  PTR_CACHE(dc->disk.c, &w->key, 0)->bdev);
> >> +                                              io->bio.bi_end_io               = read_dirty_endio;
> >> +
> >> +                                              if (bio_alloc_pages(&io->bio, GFP_KERNEL))
> >> +                                                              goto err_free;
> >> +
> >> +                                              trace_bcache_writeback(&w->key);
> >> +
> >> +                                              down(&dc->in_flight);
> >> +
> >> +                                              /* We've acquired a semaphore for the maximum
> >> +                                               * simultaneous number of writebacks; from here
> >> +                                               * everything happens asynchronously.
> >> +                                               */
> >> +                                              closure_call(&io->cl, read_dirty_submit, NULL, &cl);
> >> +                              }
> >>
> >> -                              down(&dc->in_flight);
> >> -                              closure_call(&io->cl, read_dirty_submit, NULL, &cl);
> >> +                              delay = writeback_delay(dc, size);
> >>
> >> -                              delay = writeback_delay(dc, KEY_SIZE(&w->key));
> >> +                              while (!kthread_should_stop() && delay) {
> >> +                                              schedule_timeout_interruptible(delay);
> >> +                                              delay = writeback_delay(dc, 0);
> >> +                              }
> >>                }
> >>
> >>                if (0) {
> >> --
> > --
