From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: [PATCH] bcache: set max writeback rate when I/O request is idle
Date: Mon, 23 Jul 2018 11:11:42 +0200
Message-ID: <5fe334e5-1344-2bd4-30da-9b53e5e9f7db@profihost.ag>
References: <20180722161316.2347-1-colyli@suse.de>
 <e81f1e89-3505-e2d1-df52-949cf79bfa5c@profihost.ag>
 <8145df92-922d-9368-fea6-3fe8429ea7a8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <8145df92-922d-9368-fea6-3fe8429ea7a8@suse.de>
Content-Language: de-DE
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org


Am 23.07.2018 um 11:05 schrieb Coly Li:
> On 2018/7/23 2:38 PM, Stefan Priebe - Profihost AG wrote:
>> Hi Coly,
>>
>> thanks for this patch. I was right on the way to debug why i have lot's
>> of stalled I/O on latest SLES12-SP3 kernel. I'll add this patch and try
>> if this solves my issues.
>>
>> Each cache set has two backing devices.
> 
> Hi Stefan,
> 
> Thanks for the testing.

OK it does not apply to  SLES12-SP3 at all. I'll use SLES15 kernel to test.

Stefan

> Coly Li
> 
> 
>>
>> Am 22.07.2018 um 18:13 schrieb Coly Li:
>>> Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
>>> allows the writeback rate to be faster if there is no I/O request on a
>>> bcache device. It works well if there is only one bcache device attached
>>> to the cache set. If there are many bcache devices attached to a cache
>>> set, it may introduce performance regression because multiple faster
>>> writeback threads of the idle bcache devices will compete the btree level
>>> locks with the bcache device who have I/O requests coming.
>>>
>>> This patch fixes the above issue by only permitting fast writebac when
>>> all bcache devices attached on the cache set are idle. And if one of the
>>> bcache devices has new I/O request coming, minimized all writeback
>>> throughput immediately and let PI controller __update_writeback_rate()
>>> to decide the upcoming writeback rate for each bcache device.
>>>
>>> Also when all bcache devices are idle, limited wrieback rate to a small
>>> number is wast of thoughput, especially when backing devices are slower
>>> non-rotation devices (e.g. SATA SSD). This patch sets a max writeback
>>> rate for each backing device if the whole cache set is idle. A faster
>>> writeback rate in idle time means new I/Os may have more available space
>>> for dirty data, and people may observe a better write performance then.
>>>
>>> Please note bcache may change its cache mode in run time, and this patch
>>> still works if the cache mode is switched from writeback mode and there
>>> is still dirty data on cache.
>>>
>>> Fixes: Commit b1092c9af9ed ("bcache: allow quick writeback when backing idle")
>>> Cc: stable@vger.kernel.org #4.16+
>>> Signed-off-by: Coly Li <colyli@suse.de>
>>> Cc: Michael Lyle <mlyle@lyle.org>
>>> ---
>>>  drivers/md/bcache/bcache.h    |  9 +---
>>>  drivers/md/bcache/request.c   | 42 ++++++++++++++-
>>>  drivers/md/bcache/sysfs.c     | 14 +++--
>>>  drivers/md/bcache/util.c      |  2 +-
>>>  drivers/md/bcache/util.h      |  2 +-
>>>  drivers/md/bcache/writeback.c | 98 +++++++++++++++++++++++++----------
>>>  6 files changed, 126 insertions(+), 41 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>>> index d6bf294f3907..f7451e8be03c 100644
>>> --- a/drivers/md/bcache/bcache.h
>>> +++ b/drivers/md/bcache/bcache.h
>>> @@ -328,13 +328,6 @@ struct cached_dev {
>>>  	 */
>>>  	atomic_t		has_dirty;
>>>  
>>> -	/*
>>> -	 * Set to zero by things that touch the backing volume-- except
>>> -	 * writeback.  Incremented by writeback.  Used to determine when to
>>> -	 * accelerate idle writeback.
>>> -	 */
>>> -	atomic_t		backing_idle;
>>> -
>>>  	struct bch_ratelimit	writeback_rate;
>>>  	struct delayed_work	writeback_rate_update;
>>>  
>>> @@ -514,6 +507,8 @@ struct cache_set {
>>>  	struct cache_accounting accounting;
>>>  
>>>  	unsigned long		flags;
>>> +	atomic_t		idle_counter;
>>> +	atomic_t		at_max_writeback_rate;
>>>  
>>>  	struct cache_sb		sb;
>>>  
>>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>>> index ae67f5fa8047..fe45f561a054 100644
>>> --- a/drivers/md/bcache/request.c
>>> +++ b/drivers/md/bcache/request.c
>>> @@ -1104,6 +1104,34 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
>>>  
>>>  /* Cached devices - read & write stuff */
>>>  
>>> +static void quit_max_writeback_rate(struct cache_set *c)
>>> +{
>>> +	int i;
>>> +	struct bcache_device *d;
>>> +	struct cached_dev *dc;
>>> +
>>> +	mutex_lock(&bch_register_lock);
>>> +
>>> +	for (i = 0; i < c->devices_max_used; i++) {
>>> +		if (!c->devices[i])
>>> +			continue;
>>> +
>>> +		if (UUID_FLASH_ONLY(&c->uuids[i]))
>>> +			continue;
>>> +
>>> +		d = c->devices[i];
>>> +		dc = container_of(d, struct cached_dev, disk);
>>> +		/*
>>> +		 * set writeback rate to default minimum value,
>>> +		 * then let update_writeback_rate() to decide the
>>> +		 * upcoming rate.
>>> +		 */
>>> +		atomic64_set(&dc->writeback_rate.rate, 1);
>>> +	}
>>> +
>>> +	mutex_unlock(&bch_register_lock);
>>> +}
>>> +
>>>  static blk_qc_t cached_dev_make_request(struct request_queue *q,
>>>  					struct bio *bio)
>>>  {
>>> @@ -1119,7 +1147,19 @@ static blk_qc_t cached_dev_make_request(struct request_queue *q,
>>>  		return BLK_QC_T_NONE;
>>>  	}
>>>  
>>> -	atomic_set(&dc->backing_idle, 0);
>>> +	if (d->c) {
>>> +		atomic_set(&d->c->idle_counter, 0);
>>> +		/*
>>> +		 * If at_max_writeback_rate of cache set is true and new I/O
>>> +		 * comes, quit max writeback rate of all cached devices
>>> +		 * attached to this cache set, and set at_max_writeback_rate
>>> +		 * to false.
>>> +		 */
>>> +		if (unlikely(atomic_read(&d->c->at_max_writeback_rate) == 1)) {
>>> +			atomic_set(&d->c->at_max_writeback_rate, 0);
>>> +			quit_max_writeback_rate(d->c);
>>> +		}
>>> +	}
>>>  	generic_start_io_acct(q, rw, bio_sectors(bio), &d->disk->part0);
>>>  
>>>  	bio_set_dev(bio, dc->bdev);
>>> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
>>> index 225b15aa0340..d719021bff81 100644
>>> --- a/drivers/md/bcache/sysfs.c
>>> +++ b/drivers/md/bcache/sysfs.c
>>> @@ -170,7 +170,8 @@ SHOW(__bch_cached_dev)
>>>  	var_printf(writeback_running,	"%i");
>>>  	var_print(writeback_delay);
>>>  	var_print(writeback_percent);
>>> -	sysfs_hprint(writeback_rate,	dc->writeback_rate.rate << 9);
>>> +	sysfs_hprint(writeback_rate,
>>> +		     atomic64_read(&dc->writeback_rate.rate) << 9);
>>>  	sysfs_hprint(io_errors,		atomic_read(&dc->io_errors));
>>>  	sysfs_printf(io_error_limit,	"%i", dc->error_limit);
>>>  	sysfs_printf(io_disable,	"%i", dc->io_disable);
>>> @@ -188,7 +189,8 @@ SHOW(__bch_cached_dev)
>>>  		char change[20];
>>>  		s64 next_io;
>>>  
>>> -		bch_hprint(rate,	dc->writeback_rate.rate << 9);
>>> +		bch_hprint(rate,
>>> +			   atomic64_read(&dc->writeback_rate.rate) << 9);
>>>  		bch_hprint(dirty,	bcache_dev_sectors_dirty(&dc->disk) << 9);
>>>  		bch_hprint(target,	dc->writeback_rate_target << 9);
>>>  		bch_hprint(proportional,dc->writeback_rate_proportional << 9);
>>> @@ -255,8 +257,12 @@ STORE(__cached_dev)
>>>  
>>>  	sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent, 0, 40);
>>>  
>>> -	sysfs_strtoul_clamp(writeback_rate,
>>> -			    dc->writeback_rate.rate, 1, INT_MAX);
>>> +	if (attr == &sysfs_writeback_rate) {
>>> +		int v;
>>> +
>>> +		sysfs_strtoul_clamp(writeback_rate, v, 1, INT_MAX);
>>> +		atomic64_set(&dc->writeback_rate.rate, v);
>>> +	}
>>>  
>>>  	sysfs_strtoul_clamp(writeback_rate_update_seconds,
>>>  			    dc->writeback_rate_update_seconds,
>>> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
>>> index fc479b026d6d..84f90c3d996d 100644
>>> --- a/drivers/md/bcache/util.c
>>> +++ b/drivers/md/bcache/util.c
>>> @@ -200,7 +200,7 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
>>>  {
>>>  	uint64_t now = local_clock();
>>>  
>>> -	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
>>> +	d->next += div_u64(done * NSEC_PER_SEC, atomic64_read(&d->rate));
>>>  
>>>  	/* Bound the time.  Don't let us fall further than 2 seconds behind
>>>  	 * (this prevents unnecessary backlog that would make it impossible
>>> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
>>> index cced87f8eb27..7e17f32ab563 100644
>>> --- a/drivers/md/bcache/util.h
>>> +++ b/drivers/md/bcache/util.h
>>> @@ -442,7 +442,7 @@ struct bch_ratelimit {
>>>  	 * Rate at which we want to do work, in units per second
>>>  	 * The units here correspond to the units passed to bch_next_delay()
>>>  	 */
>>> -	uint32_t		rate;
>>> +	atomic64_t		rate;
>>>  };
>>>  
>>>  static inline void bch_ratelimit_reset(struct bch_ratelimit *d)
>>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>>> index ad45ebe1a74b..72059f910230 100644
>>> --- a/drivers/md/bcache/writeback.c
>>> +++ b/drivers/md/bcache/writeback.c
>>> @@ -49,6 +49,63 @@ static uint64_t __calc_target_rate(struct cached_dev *dc)
>>>  	return (cache_dirty_target * bdev_share) >> WRITEBACK_SHARE_SHIFT;
>>>  }
>>>  
>>> +static bool set_at_max_writeback_rate(struct cache_set *c,
>>> +				      struct cached_dev *dc)
>>> +{
>>> +	int i, dirty_dc_nr = 0;
>>> +	struct bcache_device *d;
>>> +
>>> +	mutex_lock(&bch_register_lock);
>>> +	for (i = 0; i < c->devices_max_used; i++) {
>>> +		if (!c->devices[i])
>>> +			continue;
>>> +		if (UUID_FLASH_ONLY(&c->uuids[i]))
>>> +			continue;
>>> +		d = c->devices[i];
>>> +		dc = container_of(d, struct cached_dev, disk);
>>> +		if (atomic_read(&dc->has_dirty))
>>> +			dirty_dc_nr++;
>>> +	}
>>> +	mutex_unlock(&bch_register_lock);
>>> +
>>> +	/*
>>> +	 * Idle_counter is increased everytime when update_writeback_rate()
>>> +	 * is rescheduled in. If all backing devices attached to the same
>>> +	 * cache set has same dc->writeback_rate_update_seconds value, it
>>> +	 * is about 10 rounds of update_writeback_rate() is called on each
>>> +	 * backing device, then the code will fall through at set 1 to
>>> +	 * c->at_max_writeback_rate, and a max wrteback rate to each
>>> +	 * dc->writeback_rate.rate. This is not very accurate but works well
>>> +	 * to make sure the whole cache set has no new I/O coming before
>>> +	 * writeback rate is set to a max number.
>>> +	 */
>>> +	if (atomic_inc_return(&c->idle_counter) < dirty_dc_nr * 10)
>>> +		return false;
>>> +
>>> +	if (atomic_read(&c->at_max_writeback_rate) != 1)
>>> +		atomic_set(&c->at_max_writeback_rate, 1);
>>> +
>>> +
>>> +	atomic64_set(&dc->writeback_rate.rate, INT_MAX);
>>> +
>>> +	/* keep writeback_rate_target as existing value */
>>> +	dc->writeback_rate_proportional = 0;
>>> +	dc->writeback_rate_integral_scaled = 0;
>>> +	dc->writeback_rate_change = 0;
>>> +
>>> +	/*
>>> +	 * Check c->idle_counter and c->at_max_writeback_rate agagain in case
>>> +	 * new I/O arrives during before set_at_max_writeback_rate() returns.
>>> +	 * Then the writeback rate is set to 1, and its new value should be
>>> +	 * decided via __update_writeback_rate().
>>> +	 */
>>> +	if (atomic_read(&c->idle_counter) < dirty_dc_nr * 10 ||
>>> +	    !atomic_read(&c->at_max_writeback_rate))
>>> +		return false;
>>> +
>>> +	return true;
>>> +}
>>> +
>>>  static void __update_writeback_rate(struct cached_dev *dc)
>>>  {
>>>  	/*
>>> @@ -104,8 +161,9 @@ static void __update_writeback_rate(struct cached_dev *dc)
>>>  
>>>  	dc->writeback_rate_proportional = proportional_scaled;
>>>  	dc->writeback_rate_integral_scaled = integral_scaled;
>>> -	dc->writeback_rate_change = new_rate - dc->writeback_rate.rate;
>>> -	dc->writeback_rate.rate = new_rate;
>>> +	dc->writeback_rate_change = new_rate -
>>> +			atomic64_read(&dc->writeback_rate.rate);
>>> +	atomic64_set(&dc->writeback_rate.rate, new_rate);
>>>  	dc->writeback_rate_target = target;
>>>  }
>>>  
>>> @@ -138,9 +196,16 @@ static void update_writeback_rate(struct work_struct *work)
>>>  
>>>  	down_read(&dc->writeback_lock);
>>>  
>>> -	if (atomic_read(&dc->has_dirty) &&
>>> -	    dc->writeback_percent)
>>> -		__update_writeback_rate(dc);
>>> +	if (atomic_read(&dc->has_dirty) && dc->writeback_percent) {
>>> +		/*
>>> +		 * If the whole cache set is idle, set_at_max_writeback_rate()
>>> +		 * will set writeback rate to a max number. Then it is
>>> +		 * unncessary to update writeback rate for an idle cache set
>>> +		 * in maximum writeback rate number(s).
>>> +		 */
>>> +		if (!set_at_max_writeback_rate(c, dc))
>>> +			__update_writeback_rate(dc);
>>> +	}
>>>  
>>>  	up_read(&dc->writeback_lock);
>>>  
>>> @@ -422,27 +487,6 @@ static void read_dirty(struct cached_dev *dc)
>>>  
>>>  		delay = writeback_delay(dc, size);
>>>  
>>> -		/* If the control system would wait for at least half a
>>> -		 * second, and there's been no reqs hitting the backing disk
>>> -		 * for awhile: use an alternate mode where we have at most
>>> -		 * one contiguous set of writebacks in flight at a time.  If
>>> -		 * someone wants to do IO it will be quick, as it will only
>>> -		 * have to contend with one operation in flight, and we'll
>>> -		 * be round-tripping data to the backing disk as quickly as
>>> -		 * it can accept it.
>>> -		 */
>>> -		if (delay >= HZ / 2) {
>>> -			/* 3 means at least 1.5 seconds, up to 7.5 if we
>>> -			 * have slowed way down.
>>> -			 */
>>> -			if (atomic_inc_return(&dc->backing_idle) >= 3) {
>>> -				/* Wait for current I/Os to finish */
>>> -				closure_sync(&cl);
>>> -				/* And immediately launch a new set. */
>>> -				delay = 0;
>>> -			}
>>> -		}
>>> -
>>>  		while (!kthread_should_stop() &&
>>>  		       !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
>>>  		       delay) {
>>> @@ -715,7 +759,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>>>  	dc->writeback_running		= true;
>>>  	dc->writeback_percent		= 10;
>>>  	dc->writeback_delay		= 30;
>>> -	dc->writeback_rate.rate		= 1024;
>>> +	atomic64_set(&dc->writeback_rate.rate, 1024);
>>>  	dc->writeback_rate_minimum	= 8;
>>>  
>>>  	dc->writeback_rate_update_seconds = WRITEBACK_RATE_UPDATE_SECS_DEFAULT;
>>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
