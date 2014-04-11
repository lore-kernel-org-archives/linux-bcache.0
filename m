From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Fri, 11 Apr 2014 09:26:45 +0200
Message-ID: <53479935.5070205@gmail.com>
References: <20140411002636.GB9176@birch.djwong.org> <20140411004649.GA4817@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:64569 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaDKHZ1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 11 Apr 2014 03:25:27 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so4908537wes.2
        for <linux-bcache@vger.kernel.org>; Fri, 11 Apr 2014 00:25:26 -0700 (PDT)
In-Reply-To: <20140411004649.GA4817@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Sam Fulcomer <enotty@brown.edu>, Daniel J Blueman <daniel@quora.org>, linux-bcache@vger.kernel.org

On 04/11/2014 02:46 AM, Kent Overstreet wrote:
> On Thu, Apr 10, 2014 at 05:26:36PM -0700, Darrick J. Wong wrote:
>> Hi all,
>>
>> The attached patch fixes both the "writeback blocked for XXX seconds"
>> complaints from the kernel and the oddly high load averages on idle systems
>> problems for me.  Can you give it a try to see if it fixes your problem too?
>>
>> --D
>> ---
>> Currently, the writeback thread performs uninterruptible sleep while
>> it waits for enough dirty data to accumulate to start writeback.
>> Unfortunately, uninterruptible sleep counts towards load average,
>> which artificially inflates it.  Since the wb thread is a kernel
>> thread and kthreads don't receive signals, we can use the
>> interruptible sleep call, which eliminates the high load average
>> symptom.
>>
>> A second symptom is that if we mount a non-writeback cache, the
>> writeback thread will be woken up.  If the cache later accumulates
>> dirty data and writeback_running=1 (this seems to be a default) then
>> the writeback thread will enter uninterruptible sleep waiting for
>> dirty data.  This is unnecessary and (I think) results in the
>> "bcache_writebac:155 blocked for more than XXX seconds" complaints
>> that people have been talking about.  The fix for this is simple -- if
>> we're not in writeback mode, just go to (interruptible) sleep for a
>> long time.  Alternately, we could use wait_event until the cache mode
>> changes.
>>
>> Finally, change bch_cached_dev_attach() to always wake up the
>> writeback thread, because the newly created wb thread remains in
>> uninterruptible sleep state until something explicitly wakes it up.
>> This wakeup allows the thread to call bch_writeback_thread(),
>> whereupon it will most likely end up in interruptible sleep.  In
>> theory we could just let the first write take care of this, but
>> there's really no reason not to do the transition quickly.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  drivers/md/bcache/super.c     |    2 +-
>>  drivers/md/bcache/writeback.c |   16 ++++++++++++++--
>>  2 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 24a3a15..3ffe970 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1048,8 +1048,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
>>  		bch_sectors_dirty_init(dc);
>>  		atomic_set(&dc->has_dirty, 1);
>>  		atomic_inc(&dc->count);
>> -		bch_writeback_queue(dc);
>>  	}
>> +	bch_writeback_queue(dc);
>>  
>>  	bch_cached_dev_run(dc);
>>  	bcache_device_link(&dc->disk, c, "bdev");
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index f4300e4..f49e6b1 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -239,7 +239,7 @@ static void read_dirty(struct cached_dev *dc)
>>  		if (KEY_START(&w->key) != dc->last_read ||
>>  		    jiffies_to_msecs(delay) > 50)
>>  			while (!kthread_should_stop() && delay)
>> -				delay = schedule_timeout_uninterruptible(delay);
>> +				delay = schedule_timeout_interruptible(delay);
>>  
>>  		dc->last_read	= KEY_OFFSET(&w->key);
>>  
>> @@ -401,6 +401,18 @@ static int bch_writeback_thread(void *arg)
>>  
>>  	while (!kthread_should_stop()) {
>>  		down_write(&dc->writeback_lock);
>> +		if (BDEV_CACHE_MODE(&dc->sb) != CACHE_MODE_WRITEBACK) {
>> +			up_write(&dc->writeback_lock);
>> +			set_current_state(TASK_INTERRUPTIBLE);
>> +
>> +			if (kthread_should_stop())
>> +				return 0;
>> +
>> +			try_to_freeze();
>> +			schedule_timeout_interruptible(10 * HZ);
>> +			continue;
>> +		}
>> +
> 
> So this addition isn't correct - cache mode might've been flipped to
> writethrough, but we might still have dirty data we need to flush: that's why
> the line below is checking dc->has_dirty.
> 
> I don't think your schedule_timeout_interruptible() is correct either, and I'm
> not seeing what's wrong with the code right below - where it's doing the
> set_current_state() then the schedule() - but from your report of high idle load
> average (what about cpu?) it sounds like something is wrong.

could you then try to explain then why people is currently facing this
issue (3.13 and 3.14 at least):

[Apr11 09:15] INFO: task bcache_writebac:166 blocked for more than 120
seconds.
[  +0.000009]       Not tainted 3.14.0-4-ARCH #1
[  +0.000002] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  +0.000003] bcache_writebac D 0000000000000000     0   166      2
0x00000000
[  +0.000007]  ffff880405223eb8 0000000000000046 ffff8800d8939d70
ffff880405223fd8
[  +0.000006]  00000000000142c0 00000000000142c0 ffff8800d8939d70
ffff880405223e38
[  +0.000004]  ffffffff81097c1a 0000000000000000 0000000000000000
0000000000000046
[  +0.000005] Call Trace:
[  +0.000015]  [<ffffffff81097c1a>] ? try_to_wake_up+0x1fa/0x2c0
[  +0.000005]  [<ffffffff81097d32>] ? default_wake_function+0x12/0x20
[  +0.000007]  [<ffffffff810a9b48>] ? __wake_up_common+0x58/0x90
[  +0.000035]  [<ffffffffa0428ff0>] ? read_dirty_endio+0x60/0x60 [bcache]
[  +0.000007]  [<ffffffff814d7d89>] schedule+0x29/0x70
[  +0.000005]  [<ffffffff8108715d>] kthread+0xad/0xf0
[  +0.000005]  [<ffffffff810870b0>] ? kthread_create_on_node+0x180/0x180
[  +0.000006]  [<ffffffff814e2ebc>] ret_from_fork+0x7c/0xb0
[  +0.000004]  [<ffffffff810870b0>] ? kthread_create_on_node+0x180/0x180

This has been reported several times but it seems that you ignored it
each time.

Thanks.
