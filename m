From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/2] bcache: do not perform writeback if dirty data is no
 more than writeback_percent
Date: Sat, 22 Jul 2017 23:49:21 +0800
Message-ID: <f219c00e-2041-52a4-247f-fb0cb1eeeb33@suse.de>
References: <20170719053615.99305-1-colyli@suse.de>
 <20170719053615.99305-2-colyli@suse.de>
 <OF7ADE25A8.9CA7AF89-ON48258165.00108B81-48258165.0010FA59@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43652 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752089AbdGVPtc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 22 Jul 2017 11:49:32 -0400
In-Reply-To: <OF7ADE25A8.9CA7AF89-ON48258165.00108B81-48258165.0010FA59@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: bcache@lists.ewheeler.net, kubuxu@ipfs.io, linux-bcache@vger.kernel.org, linux-bcache-owner@vger.kernel.org

On 2017/7/22 上午11:05, tang.junhui@zte.com.cn wrote:
> Hello Coly，
> 
> Good improvement for the writeback mechanism.
> 
> But you maybe still need pay attention to three things bellow:
> 1) You may introduce a new race in variable "c->last_request_time",
>    other devices or threads may access on it in the same time;

Yes, int64_t last_request_time operations can not be atomic on non-64
bit machines, there is race. I should change it to atomic64_t and use
atomic64_set()/atomic64_read().

And I feel in no_writeback_now() the following line should be fixed too,
	duration = local_clock() - c->last_request_time;
c->last_request_time might be updated after local_clock() is returned,
then duration will be a minus value. I should calculate duration in this
way:
	/*
	 * c->last_request_time might be updated after local_lock()
	 * returns, fetched it firstly to make sure last_request_time
	 * won't be newer then return value of local_clock()
	 */
	int64_t last_request_time =
		atomic64_read(&c->last_request_time);
	duration = local_clock() - last_request_time;

Nice catch!

> 2) Request may be also on thin flash device, so I think you should also
>    record c->last_request_time in flash_dev_make_request();

c->last_request_time is for bcache devices to calculate
dc->writeback_rate.rate, thin flash device does not have cached device
(that is no dc->writeback_rate), this is why I don't counter time stamp
for flash only volume.


> 3) What I worried the most is that, this patch may not takes effection in
>    real application, for example, in Openstack, there is many virtual
> machines
>    running on the bcache device, so there is always some IO requesets (few
>    but frequently) , so it would be never timeout, and the left dirty data
>    will never flush cleanly.

In this patch set, the above situation is what the second patch cares
about. For this patch, it only prevents writeback to continue before
dirty data exceeds writeback_percent, and permit writeback to continue
if a timeer is out.

Indeed, before applying the second patch of this patch set, even
((duration/NSEC_PER_MSEC) > BCH_IDLE_DURATION_MSECS) happens, the
writeback rate is very low, most of time it is 1 only. For data center
application it won't be problematic, but for mobile devices it is. This
is what the second patch of this patch set tries to fix.

Here I also talk about the idea of second patch here as well. The idea
behind PD controller in __update_writeback_rate() is,
- when dirty data exceeds dc->writeback_percent
  more dirty data means high writeback rate, less dirty data means low
writeback rate.
- when dirty data is equal to or less than dc->writeback_percent
  regular I/O is always the highest prior, writeback rate is the lowest
value 1.

For data center environment the above ideas are right, so in your
example the writeback rate will be very low (maybe only 1). And yes,
since the writeback is based on iteration of an in-memory RB tree, there
is no assurance that oldest dirty data will be selected first, it is
possible that a dirty data will be never cleaned in your example.

Less dirty data and low I/O latency can not be achieved at same tine in
bcache code, obviously bcache choose low I/O latency as first priority.

Even in my patch set the second patch for max_writeback_rate_when_idle
will be set writeback_rate to 1 when update_writeback_rate() detect I/O
idle is broken by new coming request.

Thanks for comments :-)

Coly


> 
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
>> stay in cache device for a very long time if I/O on bcache device is
> idle.
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
>> diff --git a/drivers/md/bcache/writeback.c
> b/drivers/md/bcache/writeback.c
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
>> --
>> 2.12.0
