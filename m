From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Thu, 10 Apr 2014 17:46:49 -0700
Message-ID: <20140411004649.GA4817@kmo>
References: <20140411002636.GB9176@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63034 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaDKAqx (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 10 Apr 2014 20:46:53 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so4540780pdj.22
        for <linux-bcache@vger.kernel.org>; Thu, 10 Apr 2014 17:46:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140411002636.GB9176@birch.djwong.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Sam Fulcomer <enotty@brown.edu>, Francis Moreau <francis.moro@gmail.com>, Daniel J Blueman <daniel@quora.org>, linux-bcache@vger.kernel.org

On Thu, Apr 10, 2014 at 05:26:36PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> The attached patch fixes both the "writeback blocked for XXX seconds"
> complaints from the kernel and the oddly high load averages on idle systems
> problems for me.  Can you give it a try to see if it fixes your problem too?
> 
> --D
> ---
> Currently, the writeback thread performs uninterruptible sleep while
> it waits for enough dirty data to accumulate to start writeback.
> Unfortunately, uninterruptible sleep counts towards load average,
> which artificially inflates it.  Since the wb thread is a kernel
> thread and kthreads don't receive signals, we can use the
> interruptible sleep call, which eliminates the high load average
> symptom.
> 
> A second symptom is that if we mount a non-writeback cache, the
> writeback thread will be woken up.  If the cache later accumulates
> dirty data and writeback_running=1 (this seems to be a default) then
> the writeback thread will enter uninterruptible sleep waiting for
> dirty data.  This is unnecessary and (I think) results in the
> "bcache_writebac:155 blocked for more than XXX seconds" complaints
> that people have been talking about.  The fix for this is simple -- if
> we're not in writeback mode, just go to (interruptible) sleep for a
> long time.  Alternately, we could use wait_event until the cache mode
> changes.
> 
> Finally, change bch_cached_dev_attach() to always wake up the
> writeback thread, because the newly created wb thread remains in
> uninterruptible sleep state until something explicitly wakes it up.
> This wakeup allows the thread to call bch_writeback_thread(),
> whereupon it will most likely end up in interruptible sleep.  In
> theory we could just let the first write take care of this, but
> there's really no reason not to do the transition quickly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  drivers/md/bcache/super.c     |    2 +-
>  drivers/md/bcache/writeback.c |   16 ++++++++++++++--
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 24a3a15..3ffe970 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1048,8 +1048,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
>  		bch_sectors_dirty_init(dc);
>  		atomic_set(&dc->has_dirty, 1);
>  		atomic_inc(&dc->count);
> -		bch_writeback_queue(dc);
>  	}
> +	bch_writeback_queue(dc);
>  
>  	bch_cached_dev_run(dc);
>  	bcache_device_link(&dc->disk, c, "bdev");
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index f4300e4..f49e6b1 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -239,7 +239,7 @@ static void read_dirty(struct cached_dev *dc)
>  		if (KEY_START(&w->key) != dc->last_read ||
>  		    jiffies_to_msecs(delay) > 50)
>  			while (!kthread_should_stop() && delay)
> -				delay = schedule_timeout_uninterruptible(delay);
> +				delay = schedule_timeout_interruptible(delay);
>  
>  		dc->last_read	= KEY_OFFSET(&w->key);
>  
> @@ -401,6 +401,18 @@ static int bch_writeback_thread(void *arg)
>  
>  	while (!kthread_should_stop()) {
>  		down_write(&dc->writeback_lock);
> +		if (BDEV_CACHE_MODE(&dc->sb) != CACHE_MODE_WRITEBACK) {
> +			up_write(&dc->writeback_lock);
> +			set_current_state(TASK_INTERRUPTIBLE);
> +
> +			if (kthread_should_stop())
> +				return 0;
> +
> +			try_to_freeze();
> +			schedule_timeout_interruptible(10 * HZ);
> +			continue;
> +		}
> +

So this addition isn't correct - cache mode might've been flipped to
writethrough, but we might still have dirty data we need to flush: that's why
the line below is checking dc->has_dirty.

I don't think your schedule_timeout_interruptible() is correct either, and I'm
not seeing what's wrong with the code right below - where it's doing the
set_current_state() then the schedule() - but from your report of high idle load
average (what about cpu?) it sounds like something is wrong.

Can you try and diagnose further? Also if you want to split the rest of the
changes out into a separate patch I'll definitely take that. Thanks!


>  		if (!atomic_read(&dc->has_dirty) ||
>  		    (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
>  		     !dc->writeback_running)) {
> @@ -436,7 +448,7 @@ static int bch_writeback_thread(void *arg)
>  			while (delay &&
>  			       !kthread_should_stop() &&
>  			       !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
> -				delay = schedule_timeout_uninterruptible(delay);
> +				delay = schedule_timeout_interruptible(delay);
>  		}
>  	}
>  
