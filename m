From: Coly Li <i@coly.li>
Subject: Re: [PATCH 12/19] bcache: update bucket_in_use periodically
Date: Tue, 11 Jul 2017 15:20:36 +0800
Message-ID: <c66bfa8f-bbe0-6c1d-ae4c-c1c8806742b3@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-12-git-send-email-bcache@lists.ewheeler.net>
 <e312fb7a-912f-6ecf-e8b4-ef93673efb4e@coly.li>
 <OF5C19A8FA.5FF48E0C-ON4825815A.001E6DB1-4825815A.001F14F2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:52192 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751149AbdGKHUw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 Jul 2017 03:20:52 -0400
In-Reply-To: <OF5C19A8FA.5FF48E0C-ON4825815A.001E6DB1-4825815A.001F14F2@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: axboe@kernel.dk, bcache@lists.ewheeler.net, hch@infradead.org, linux-bcache@vger.kernel.org, linux-bcache-owner@vger.kernel.org, linux-block@vger.kernel.org

On 2017/7/11 下午1:39, tang.junhui@zte.com.cn wrote:
> Compared to bucket depletion, resulting in hanging dead,
> It is worthy to consumes a little time to update the bucket_in_use.
> If you have any better solution, please show to us,
> We should solve it as soon as possible, not wait for it forever.
> 
> 

Your response makes sense, but not all people have same opinion with
yours. The major issue here is, we need to hold bucket_lock here,
otherwise we may access wild pointer to freed kobj and panic kernel.

And we need to measure how much time will be occupied to iterate dirty
buckets number with bucket_lock held. If the latency is not that much,
we can ignore the cost, otherwise we do need to find a better solution.

Thanks.

Coly

> 
> 
> 发件人:         Coly Li <i@coly.li>
> 收件人:         linux-block@vger.kernel.org, Tang Junhui
> <tang.junhui@zte.com.cn>,
> 抄送:        bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org,
> hch@infradead.org, axboe@kernel.dk
> 日期:         2017/07/11 13:06
> 主题:        Re: [PATCH 12/19] bcache: update bucket_in_use periodically
> 发件人:        linux-bcache-owner@vger.kernel.org
> ------------------------------------------------------------------------
> 
> 
> 
> On 2017/7/1 上午4:43, bcache@lists.ewheeler.net wrote:
>> From: Tang Junhui <tang.junhui@zte.com.cn>
>>
>> bucket_in_use is updated in gc thread which triggered by invalidating or
>> writing sectors_to_gc dirty data, It's been too long, Therefore, when we
>> use it to compare with the threshold, it is often not timely, which leads
>> to inaccurate judgment and often results in bucket depletion.
>>
>> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
>> ---
>>  drivers/md/bcache/btree.c | 29 +++++++++++++++++++++++++++--
>>  1 file changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index 866dcf7..77aa20b 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -90,6 +90,8 @@
>>  #define MAX_NEED_GC                                  64
>>  #define MAX_SAVE_PRIO                                  72
>>  
>> +#define GC_THREAD_TIMEOUT_MS                 (30 * 1000)
>> +
>>  #define PTR_DIRTY_BIT                                  (((uint64_t) 1
> << 36))
>>  
>>  #define PTR_HASH(c, k)                                              
>                                                                         \
>> @@ -1760,6 +1762,23 @@ static void bch_btree_gc(struct cache_set *c)
>>                   bch_moving_gc(c);
>>  }
>>  
>> +void bch_update_bucket_in_use(struct cache_set *c)
>> +{
>> +                 struct cache *ca;
>> +                 struct bucket *b;
>> +                 unsigned i;
>> +                 size_t available = 0;
>> +
>> +                 for_each_cache(ca, c, i) {
>> +                                  for_each_bucket(b, ca) {
>> +                                                   if (!GC_MARK(b) ||
> GC_MARK(b) == GC_MARK_RECLAIMABLE)
>> +                                                                  
>  available++;
>> +                                  }
>> +                 }
>> +
> 
> bucket_lock of cache set should be held before accessing buckets.
> 
> 
>> +                 c->gc_stats.in_use = (c->nbuckets - available) * 100
> / c->nbuckets;
>> +}
>> +
>>  static bool gc_should_run(struct cache_set *c)
>>  {
>>                   struct cache *ca;
>> @@ -1778,10 +1797,16 @@ static bool gc_should_run(struct cache_set *c)
>>  static int bch_gc_thread(void *arg)
>>  {
>>                   struct cache_set *c = arg;
>> +                 long  ret;
>> +                 unsigned long timeout =
> msecs_to_jiffies(GC_THREAD_TIMEOUT_MS);
>>  
>>                   while (1) {
>> -                                  wait_event_interruptible(c->gc_wait,
>> -                                                    
>  kthread_should_stop() || gc_should_run(c));
>> +                                  ret =
> wait_event_interruptible_timeout(c->gc_wait,
>> +                                                    
>  kthread_should_stop() || gc_should_run(c), timeout);
>> +                                  if (!ret) {
>> +                                                  
> bch_update_bucket_in_use(c);
>> +                                                   continue;
> 
> A continue here will ignore status returned from kthread_should_stop(),
> which might not be expected behavior.
> 
> 
>> +                                  }
>>  
>>                                    if (kthread_should_stop())
>>                                                     break;
>>
> 
> Iterating all buckets from the cache set requires bucket_lock to be
> held. Waiting for bucket_lock may take quite a long time for either
> bucket allocating code or bch_gc_thread(). What I concern is, this patch
> may introduce bucket allocation delay in period of GC_THREAD_TIMEOUT_MS.
> 
> We need to find out a way to avoid such a performance regression.
> 
> -- 
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
Coly Li
