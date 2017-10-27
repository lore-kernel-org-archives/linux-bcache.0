From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 12/19] bcache: update bucket_in_use periodically
Date: Fri, 27 Oct 2017 19:11:11 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1710271909510.24585@mail.ewheeler.net>
References: <20170629134510.GA32385@infradead.org> <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net> <1498855388-16990-12-git-send-email-bcache@lists.ewheeler.net> <e312fb7a-912f-6ecf-e8b4-ef93673efb4e@coly.li>
 <OF5C19A8FA.5FF48E0C-ON4825815A.001E6DB1-4825815A.001F14F2@zte.com.cn> <52d57172-777d-5df6-6ee5-51a0d9560f82@coly.li> <alpine.LRH.2.11.1707130412130.9683@mail.ewheeler.net> <a5660607-f0b9-53a6-1ed4-bfec40932671@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1911353927-1509131471=:24585"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:53296 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752522AbdJ0TLM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 15:11:12 -0400
In-Reply-To: <a5660607-f0b9-53a6-1ed4-bfec40932671@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Michael Lyle <mlyle@lyle.org>, tang.junhui@zte.com.cn, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1911353927-1509131471=:24585
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 13 Jul 2017, Coly Li wrote:

> On 2017/7/13 下午12:13, Eric Wheeler wrote:
> > On Tue, 11 Jul 2017, Coly Li wrote:
> > 
> >> On 2017/7/11 下午1:39, tang.junhui@zte.com.cn wrote:
> >>> Compared to bucket depletion, resulting in hanging dead,
> >>> It is worthy to consumes a little time to update the bucket_in_use.
> >>> If you have any better solution, please show to us,
> >>> We should solve it as soon as possible, not wait for it forever.
> >>>
> >>
> >> I also test this patch on a cache device with 4x3.8TB size, all buckets
> >> iteration takes around 40-50ms. If the iteration needs to hold
> >> bucket_lock of cache set, it is very probably to introduce a huge I/O
> >> latency in period of every 30 seconds.
> >>
> >> For database people, this is not good news.
> > 
> > 
> > Hi Tang,
> >    
> > I'm waiting to queue this patch pending your response to Coly.  
> > 
> > Please send a v2 when you're ready.
> 
> 
> Eric,
> 
> I guess Tang is working on the I/O hang issue during back ground garbage
> collection running. From discussion from other email thread, it seems a
> regular I/O request gets hung for 10+ second in some cases. Maybe that
> issue is more urgent than this one.
> 
> From my personal opinion, updating bucket_in_use is for acting garbage
> collection. If number of bucket in use is not updated in time, garbage
> collection won't start due to old bucket_in_use still beyond
> CUTOFF_WRITEBACK_SYNC.
> 
> We may maintain an atomic counter per-cache set for dirty buckets, and
> update it at some locations when allocating or reclaiming bucket. This
> counter is unnecessary to be very accurate, just accurate enough for
> should_writeback() working correctly.
> 
> I am also looking at it for a better solution as well.

Hi Coli & Tang,

Have either of you had a chance to come up with a solution to this?

--
Eric Wheeler

> 
> Coly
> 
> 
> >>
> >> Coly
> >>
> >>
> >>>
> >>>
> >>>
> >>> 发件人:         Coly Li <i@coly.li>
> >>> 收件人:         linux-block@vger.kernel.org, Tang Junhui
> >>> <tang.junhui@zte.com.cn>,
> >>> 抄送:        bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org,
> >>> hch@infradead.org, axboe@kernel.dk
> >>> 日期:         2017/07/11 13:06
> >>> 主题:        Re: [PATCH 12/19] bcache: update bucket_in_use periodically
> >>> 发件人:        linux-bcache-owner@vger.kernel.org
> >>> ------------------------------------------------------------------------
> >>>
> >>>
> >>>
> >>> On 2017/7/1 上午4:43, bcache@lists.ewheeler.net wrote:
> >>>> From: Tang Junhui <tang.junhui@zte.com.cn>
> >>>>
> >>>> bucket_in_use is updated in gc thread which triggered by invalidating or
> >>>> writing sectors_to_gc dirty data, It's been too long, Therefore, when we
> >>>> use it to compare with the threshold, it is often not timely, which leads
> >>>> to inaccurate judgment and often results in bucket depletion.
> >>>>
> >>>> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> >>>> ---
> >>>>  drivers/md/bcache/btree.c | 29 +++++++++++++++++++++++++++--
> >>>>  1 file changed, 27 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> >>>> index 866dcf7..77aa20b 100644
> >>>> --- a/drivers/md/bcache/btree.c
> >>>> +++ b/drivers/md/bcache/btree.c
> >>>> @@ -90,6 +90,8 @@
> >>>>  #define MAX_NEED_GC                                  64
> >>>>  #define MAX_SAVE_PRIO                                  72
> >>>>  
> >>>> +#define GC_THREAD_TIMEOUT_MS                 (30 * 1000)
> >>>> +
> >>>>  #define PTR_DIRTY_BIT                                  (((uint64_t) 1
> >>> << 36))
> >>>>  
> >>>>  #define PTR_HASH(c, k)                                              
> >>>                                                                         \
> >>>> @@ -1760,6 +1762,23 @@ static void bch_btree_gc(struct cache_set *c)
> >>>>                   bch_moving_gc(c);
> >>>>  }
> >>>>  
> >>>> +void bch_update_bucket_in_use(struct cache_set *c)
> >>>> +{
> >>>> +                 struct cache *ca;
> >>>> +                 struct bucket *b;
> >>>> +                 unsigned i;
> >>>> +                 size_t available = 0;
> >>>> +
> >>>> +                 for_each_cache(ca, c, i) {
> >>>> +                                  for_each_bucket(b, ca) {
> >>>> +                                                   if (!GC_MARK(b) ||
> >>> GC_MARK(b) == GC_MARK_RECLAIMABLE)
> >>>> +                                                                  
> >>>  available++;
> >>>> +                                  }
> >>>> +                 }
> >>>> +
> >>>
> >>> bucket_lock of cache set should be held before accessing buckets.
> >>>
> >>>
> >>>> +                 c->gc_stats.in_use = (c->nbuckets - available) * 100
> >>> / c->nbuckets;
> >>>> +}
> >>>> +
> >>>>  static bool gc_should_run(struct cache_set *c)
> >>>>  {
> >>>>                   struct cache *ca;
> >>>> @@ -1778,10 +1797,16 @@ static bool gc_should_run(struct cache_set *c)
> >>>>  static int bch_gc_thread(void *arg)
> >>>>  {
> >>>>                   struct cache_set *c = arg;
> >>>> +                 long  ret;
> >>>> +                 unsigned long timeout =
> >>> msecs_to_jiffies(GC_THREAD_TIMEOUT_MS);
> >>>>  
> >>>>                   while (1) {
> >>>> -                                  wait_event_interruptible(c->gc_wait,
> >>>> -                                                    
> >>>  kthread_should_stop() || gc_should_run(c));
> >>>> +                                  ret =
> >>> wait_event_interruptible_timeout(c->gc_wait,
> >>>> +                                                    
> >>>  kthread_should_stop() || gc_should_run(c), timeout);
> >>>> +                                  if (!ret) {
> >>>> +                                                  
> >>> bch_update_bucket_in_use(c);
> >>>> +                                                   continue;
> >>>
> >>> A continue here will ignore status returned from kthread_should_stop(),
> >>> which might not be expected behavior.
> >>>
> >>>
> >>>> +                                  }
> >>>>  
> >>>>                                    if (kthread_should_stop())
> >>>>                                                     break;
> >>>>
> >>>
> >>> Iterating all buckets from the cache set requires bucket_lock to be
> >>> held. Waiting for bucket_lock may take quite a long time for either
> >>> bucket allocating code or bch_gc_thread(). What I concern is, this patch
> >>> may introduce bucket allocation delay in period of GC_THREAD_TIMEOUT_MS.
> >>>
> >>> We need to find out a way to avoid such a performance regression.
> >>>
> >>> -- 
> >>> Coly Li
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>>
> >>
> >>
> >> -- 
> >> Coly Li
> 
> 
> -- 
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-1911353927-1509131471=:24585--
