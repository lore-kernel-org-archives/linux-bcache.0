From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Re: [PATCH] [PATCH v4] bcache: fix issue of writeback rate at
 minimum 1 key per second
Date: Tue, 27 Jun 2017 23:47:48 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706272346560.17052@mail.ewheeler.net>
References: <1498199015-5652-1-git-send-email-tang.junhui@zte.com.cn> <alpine.LRH.2.11.1706261759100.17052@mail.ewheeler.net> <OF29B296FD.842E6CAB-ON4825814C.000BC8CB-4825814C.000CDFD0@zte.com.cn>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1407129780-1498607268=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:37482 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754119AbdF0Xrt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 19:47:49 -0400
In-Reply-To: <OF29B296FD.842E6CAB-ON4825814C.000BC8CB-4825814C.000CDFD0@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: i@coly.li, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1407129780-1498607268=:17052
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 27 Jun 2017, tang.junhui@zte.com.cn wrote:

> Hello Eric
> 
> > Wouldn't bch_writeback_thread need woken up on stop or reboot?  Otherwise
> > it will hang for a while waiting to exit.  Correct me if I'm wrong here...
> bch_writeback_thread will be recovered to running status immediately after calling
> kthread_stop() in cached_dev_free(). This is my test reuslult:
> 
> //usually bch_writeback_thread rescheduled after 10 seconds
> Jun 27 10:08:52 ceph192-9-9-153 kernel: [  453.402679] ffff88045bd10000: schedule
> Jun 27 10:09:02 ceph192-9-9-153 kernel: [  463.412476] ffff88045bd10000: schedule over
> Jun 27 10:09:02 ceph192-9-9-153 kernel: [  463.414832] ffff88045bd10000: schedule
> Jun 27 10:09:12 ceph192-9-9-153 kernel: [  473.424271] ffff88045bd10000: schedule over
> Jun 27 10:09:12 ceph192-9-9-153 kernel: [  473.425958] ffff88045bd10000: schedule
> Jun 27 10:09:16 ceph192-9-9-153 kernel: [  476.763968] bcache1: in cached_dev_flush
> Jun 27 10:09:16 ceph192-9-9-153 kernel: [  476.765489] bcache1: after bcache_device_unlink
> Jun 27 10:09:16 ceph192-9-9-153 kernel: [  476.766971] bcache1: after bch_cache_accounting_destroy
> Jun 27 10:09:16 ceph192-9-9-153 kernel: [  476.768431] bcache1: in cached_dev_free
> //bch_writeback_thread rescheduled immediately after calling kthread_stop() (less than 10 seconds)


Looks good to me.  I'll add to my commit list for the next pull request.


--
Eric Wheeler


> Jun 27 10:09:16 ceph192-9-9-153 kernel: [  476.769589] ffff88045bd10000: schedule over
> Jun 27 10:09:16 ceph192-9-9-153 kernel: [  476.770895] ffff88045bd10000: bch_writeback_thread stop
> 
> Regards,
> Tang Junhui
> 
> 
> 
> 
> 发件人:         Eric Wheeler <bcache@lists.ewheeler.net>
> 收件人:         tang.junhui@zte.com.cn,
> 抄送:        kent.overstreet@gmail.com, i@coly.li, linux-bcache@vger.kernel.org
> 日期:         2017/06/27 02:00
> 主题:        Re: [PATCH] [PATCH v4] bcache: fix issue of writeback rate at minimum 1 key per second
> 
> _________________________________________________________________________________________________________________
> 
> 
> 
> On Fri, 23 Jun 2017, tang.junhui@zte.com.cn wrote:
> 
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> >
> > When there is not enough dirty data in writeback cache,
> > writeback rate is at minimum 1 key per second
> > util all dirty data to be cleaned, it is inefficiency,
> > and also causes waste of energy;
> >
> > in this patch, When there is not enough dirty data,
> > let the writeback rate to be 0, and writeback re-schedule
> > in bch_writeback_thread() periodically with schedule_timeout(),
> > the behaviors are as follows :
> >
> > 1) If no dirty data have been read into dc->writeback_keys,
> > goto step 2), otherwise keep writing these dirty data to
> > back-end device at 1 key per second, until all these dirty data
> > write over, then goto step 2).
> >
> > 2) Loop in bch_writeback_thread() to check if there is enough
> > dirty data for writeback. if there is not enough diry data for
> > writing, then sleep 10 seconds, otherwise, write dirty data to
> > back-end device.
> >
> > Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> > ---
> >  drivers/md/bcache/util.c      |  9 ++++++++-
> >  drivers/md/bcache/writeback.c | 11 +++++++----
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> > index dde6172..d398f09 100644
> > --- a/drivers/md/bcache/util.c
> > +++ b/drivers/md/bcache/util.c
> > @@ -209,7 +209,14 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
> >  {
> >                   uint64_t now = local_clock();
> >  
> > -                 d->next += div_u64(done * NSEC_PER_SEC, d->rate);
> > +                 /*
> > +                   if d->rate is zero, write the left dirty data
> > +                   at the speed of one key per second
> > +                 */
> > +                 if(!d->rate)
> > +                                  d->next = now + NSEC_PER_SEC;
> > +                 else
> > +                                  d->next += div_u64(done * NSEC_PER_SEC, d->rate);
> >  
> >                   if (time_before64(now + NSEC_PER_SEC, d->next))
> >                                    d->next = now + NSEC_PER_SEC;
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> > index 69e1ae5..7313643 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -15,6 +15,8 @@
> >  #include <linux/kthread.h>
> >  #include <trace/events/bcache.h>
> >  
> > +#define WRITE_BACK_WAIT_CYCLE                                  10 * HZ
> > +
> >  /* Rate limiting */
> >  
> >  static void __update_writeback_rate(struct cached_dev *dc)
> > @@ -54,13 +56,14 @@ static void __update_writeback_rate(struct cached_dev *dc)
> >  
> >                   /* Don't increase writeback rate if the device isn't keeping up */
> >                   if (change > 0 &&
> > +                     dc->writeback_rate.rate >0 &&
> >                       time_after64(local_clock(),
> >                                                      dc->writeback_rate.next + NSEC_PER_MSEC))
> >                                    change = 0;
> >  
> >                   dc->writeback_rate.rate =
> >                                    clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
> > -                                                   1, NSEC_PER_MSEC);
> > +                                                   0, NSEC_PER_MSEC);
> >  
> >                   dc->writeback_rate_proportional = proportional;
> >                   dc->writeback_rate_derivative = derivative;
> > @@ -419,15 +422,15 @@ static int bch_writeback_thread(void *arg)
> >                   while (!kthread_should_stop()) {
> >                                    down_write(&dc->writeback_lock);
> >                                    if (!atomic_read(&dc->has_dirty) ||
> > -                                      (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
> > -                                       !dc->writeback_running)) {
> > +                                      ((!dc->writeback_rate.rate || !dc->writeback_running) &&
> > +                                        !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))) {
> >                                                     up_write(&dc->writeback_lock);
> >                                                     set_current_state(TASK_INTERRUPTIBLE);
> >  
> >                                                     if (kthread_should_stop())
> >                                                                      return 0;
> >  
> > -                                                   schedule();
> > +                                                   schedule_timeout(WRITE_BACK_WAIT_CYCLE);
> 
> 
> Wouldn't bch_writeback_thread need woken up on stop or reboot?  Otherwise
> it will hang for a while waiting to exit.  Correct me if I'm wrong here...
> 
> --
> Eric Wheeler
> 
> 
> >                                                     continue;
> >                                    }
> >  
> > --
> > 2.8.1.windows.1
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> 
--1641074820-1407129780-1498607268=:17052--
