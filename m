From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/2] bcache: do not perform writeback if dirty data is no
 more than writeback_percent
Date: Wed, 19 Jul 2017 18:32:51 +0800
Message-ID: <8a2ec66d-332b-d19f-d1ba-933d871db2cb@suse.de>
References: <20170719053615.99305-1-colyli@suse.de>
 <20170719053615.99305-2-colyli@suse.de>
 <0916c3a1-14e6-8a2f-5320-507e8b4df855@coly.li>
 <OF2AB44ECA.94CE1BF0-ON48258162.00356FFD-48258162.00359404@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40253 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753904AbdGSKdD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Jul 2017 06:33:03 -0400
In-Reply-To: <OF2AB44ECA.94CE1BF0-ON48258162.00356FFD-48258162.00359404@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: bcache@lists.ewheeler.net, kubuxu@ipfs.io, linux-bcache@vger.kernel.org

On 2017/7/19 下午5:45, tang.junhui@zte.com.cn wrote:
>> Currently bcache_dev_sectors_dirty() iterates all dirty stripes of
>> bcache device, it will take around 15 milliseconds for a 15.2TB cache
>> device on my hardware. The latency is unacceptable,
> 
> Why it is unacceptable? It does not block the front-endincoming IOs.

Hi Junhui,

Imagine the following situation,

1) Cached device has dirty data but not exceed its writeback_percent,
after its writeback thread is woke up, no_writeback_now() will iterates
all dirty stripes of the bcache device (for 15 ms on my server), and
return true to bch_writeback_thread(), then the thread schedules out and
sleep.

2) Before dirty data exceeds writeback_percent of the cached device, it
is not difficult to have more than 1 writ request onto bcache device for
every 15 ms (on my hardware). If it happens, then the writeback thread
will be woke up repeated and every time no_writeback_now() will be
called and consume CPU cycles to iterate all stripes for 15ms.

3) The result is, there is potential possibility, that the writeback
thread always consume a full CPU core before dirty data exceeds cached
device's writeback_percent, even there is only a few write request on
the bcache device.

This is unacceptable in this patch set.

Thanks.

Coly


> 
> 
> 发件人:         Coly Li <i@coly.li>
> 收件人:         Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
> 抄送:        bcache@lists.ewheeler.net, tang.junhui@zte.com.cn,
> kubuxu@ipfs.io
> 日期:         2017/07/19 16:20
> 主题:        Re: [PATCH 1/2] bcache: do not perform writeback if dirty
> data is no more than writeback_percent
> 发件人:        linux-bcache-owner@vger.kernel.org
> ------------------------------------------------------------------------
> 
> 
> 
> On 2017/7/19 下午1:36, Coly Li wrote:
>> The functionanlity of sysfs entry writeback_percent is explained in file
>> Document/ABI/testing/sysfs-block-bcache:
>> "For backing devices: If nonzero, writeback from cache to
>>  backing device only takes place when more than this percentage
>>  of the cache is used, allowing more write coalescing to take
>>  place and reducing total number of writes sent to the backing
>>  device. Integer between 0 and 40."
>>
>> Indeed currently in writeback mode, even dirty data percent is not exceed
>> writeback_percent of the cached device, writeback still happens at least
>> one key per second. This is not a behavior as designed.
>>
>> This patch does three things to fix the above issue,
>> 1) Move writeback thread related checks from bch_writeback_thread()
>>    to no_writeback_now().
>> 2) Add a duration to count time duration since last I/O request received
>>    to the moment when no_writeback_now() is called. When duration is more
>>    than BCH_IDLE_DURATION_MSECS, perform a proactive writeback no matter
>>    dirty data exceeds writeback_percent or not.
>> 3) If duration is not timeout, and dirty data is not more than cached
>>    device's writeback_percent, writeback thread just schedules out and
>>    waits for another try after BCH_IDLE_DURATION_MSECS.
>>
>> By this patch, if a write request's dirty data does not exceed
>> writeback_percent, writeback will not happen. In this case dirty data may
>> stay in cache device for a very long time if I/O on bcache device is idle.
>> To fix this, bch_writeback_queue() is called in update_writeback_rate()
>> to wake up the writeback thread in period of
> writeback_rate_update_seconds.
>> Then if no I/O happens on bcache device for BCH_IDLE_DURATION_MSECS
>> milliseconds, at least we have chance to wake up writeback thread to find
>> the duration timeout in a not-that-much delay.
>>
>> Now writeback_percent acts as what it is defined for.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/bcache.h    |  4 ++++
>>  drivers/md/bcache/request.c   |  6 +++++
>>  drivers/md/bcache/writeback.c | 55
> +++++++++++++++++++++++++++++++++++++++----
>>  3 files changed, 61 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index dee542fff68e..ab7e60336edb 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -662,6 +662,8 @@ struct cache_set {
>>  
>>  #define BUCKET_HASH_BITS                 12
>>                   struct hlist_head                 bucket_hash[1 <<
> BUCKET_HASH_BITS];
>> +
>> +                 uint64_t                                
>  last_request_time;
>>  };
>>  
>>  struct bbio {
>> @@ -680,6 +682,8 @@ struct bbio {
>>  #define BTREE_PRIO                                  USHRT_MAX
>>  #define INITIAL_PRIO                                  32768U
>>  
>> +#define BCH_IDLE_DURATION_MSECS                 10000U
>> +
>>  #define btree_bytes(c)                                
>  ((c)->btree_pages * PAGE_SIZE)
>>  #define btree_blocks(b)                                              
>                                                                         \
>>                   ((unsigned) (KEY_SIZE(&b->key) >> (b)->c->block_bits))
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index 019b3df9f1c6..98971486f7f1 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -957,10 +957,13 @@ static blk_qc_t cached_dev_make_request(struct
> request_queue *q,
>>                   struct search *s;
>>                   struct bcache_device *d =
> bio->bi_bdev->bd_disk->private_data;
>>                   struct cached_dev *dc = container_of(d, struct
> cached_dev, disk);
>> +                 struct cache_set *c = d->c;
>>                   int rw = bio_data_dir(bio);
>>  
>>                   generic_start_io_acct(rw, bio_sectors(bio),
> &d->disk->part0);
>>  
>> +                 if (c)
>> +                                  c->last_request_time = local_clock();
>>                   bio->bi_bdev = dc->bdev;
>>                   bio->bi_iter.bi_sector += dc->sb.data_offset;
>>  
>> @@ -991,6 +994,9 @@ static blk_qc_t cached_dev_make_request(struct
> request_queue *q,
>>                                    else
>>                                                    
> generic_make_request(bio);
>>                   }
>> +                 /* update last_request_time again to make it to be
> more accurate */
>> +                 if (c)
>> +                                  c->last_request_time = local_clock();
>>  
>>                   return BLK_QC_T_NONE;
>>  }
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index 42c66e76f05e..13594dd7f564 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -78,8 +78,15 @@ static void update_writeback_rate(struct
> work_struct *work)
>>                   down_read(&dc->writeback_lock);
>>  
>>                   if (atomic_read(&dc->has_dirty) &&
>> -                     dc->writeback_percent)
>> +                     dc->writeback_percent) {
>>                                    __update_writeback_rate(dc);
>> +                                  /*
>> +                                   * wake up writeback thread to
> check whether request
>> +                                   * duration is timeout in
> no_writeback_now(). If yes,
>> +                                   * existing dirty data should be
> handled.
>> +                                   */
>> +                                  bch_writeback_queue(dc);
>> +                 }
>>  
>>                   up_read(&dc->writeback_lock);
>>  
>> @@ -412,6 +419,48 @@ static bool refill_dirty(struct cached_dev *dc)
>>                   return bkey_cmp(&buf->last_scanned, &start_pos) >= 0;
>>  }
>>  
>> +static bool no_writeback_now(struct cached_dev *dc)
>> +{
>> +                 uint64_t duration;
>> +                 struct cache_set *c = dc->disk.c;
>> +                 uint64_t cache_set_sectors;
>> +                 uint64_t dirty_sectors;
>> +                 uint64_t percent_sectors;
>> +
>> +                 if (!atomic_read(&dc->has_dirty))
>> +                                  return true;
>> +
>> +                 if (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
>> +                     !dc->writeback_running)
>> +                                  return true;
>> +
>> +                 /*
>> +                  * last_request_time is initialized to 0, it is
> possible that
>> +                  * duration is larger than BCH_IDLE_DURATION_MSECS
> when the first
>> +                  * time it is calculated. If there is dirty data of
> the cached
>> +                  * device, bcache will try to perform a proactive
> writeback.
>> +                  */
>> +                 duration = local_clock() - c->last_request_time;
>> +                 if ((duration/NSEC_PER_MSEC) > BCH_IDLE_DURATION_MSECS)
>> +                                  return false;
>> +
>> +                 /*
>> +                  * If duration is not timeout, and dirty data does
> not exceed
>> +                  * writeback_percent, no writeback now.
>> +                  * This is what writeback_percent is designed for, see
>> +                  * /sys/block/<disk>/bcache/writeback_percentkernel in
>> +                  * Documentation/ABI/testing/sysfs-block-bcache
>> +                  */
>> +                 cache_set_sectors = c->nbuckets * c->sb.bucket_size;
>> +                 percent_sectors = div64_u64(
>> +                                  cache_set_sectors *
> dc->writeback_percent, 100);
>> +                 dirty_sectors = bcache_dev_sectors_dirty(&dc->disk);
> 
> Currently bcache_dev_sectors_dirty() iterates all dirty stripes of
> bcache device, it will take around 15 milliseconds for a 15.2TB cache
> device on my hardware. The latency is unacceptable, I also mentioned
> that on Junhui's work (previously posted patch titled "bcache: update
> bucket_in_use periodically").
> 
> I am working on a low latency dirty sectors counter now, after it gets
> done, I will add them into this patch set and post again.
> 
> Just FYI. Thanks.
> 
> 
> Coly
> 
> 
> 
>> +                 if (dirty_sectors <= percent_sectors)
>> +                                  return true;
>> +
>> +                 return false;
>> +}
>> +
>>  static int bch_writeback_thread(void *arg)
>>  {
>>                   struct cached_dev *dc = arg;
>> @@ -419,9 +468,7 @@ static int bch_writeback_thread(void *arg)
>>  
>>                   while (!kthread_should_stop()) {
>>                                    down_write(&dc->writeback_lock);
>> -                                  if (!atomic_read(&dc->has_dirty) ||
>> -                                    
>  (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
>> -                                       !dc->writeback_running)) {
>> +                                  if (no_writeback_now(dc)) {
>>                                                    
> up_write(&dc->writeback_lock);
>>                                                    
> set_current_state(TASK_INTERRUPTIBLE);
>>  
>>
> 
> 
> -- 
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
