From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] [PATCH v4] bcache: fix issue of writeback rate at minimum
 1 key per second
Date: Mon, 26 Jun 2017 18:00:14 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706261759100.17052@mail.ewheeler.net>
References: <1498199015-5652-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35102 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751335AbdFZSAQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Jun 2017 14:00:16 -0400
In-Reply-To: <1498199015-5652-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, i@coly.li, linux-bcache@vger.kernel.org

On Fri, 23 Jun 2017, tang.junhui@zte.com.cn wrote:

> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> When there is not enough dirty data in writeback cache,
> writeback rate is at minimum 1 key per second
> util all dirty data to be cleaned, it is inefficiency,
> and also causes waste of energy;
> 
> in this patch, When there is not enough dirty data,
> let the writeback rate to be 0, and writeback re-schedule
> in bch_writeback_thread() periodically with schedule_timeout(),
> the behaviors are as follows :
> 
> 1) If no dirty data have been read into dc->writeback_keys,
> goto step 2), otherwise keep writing these dirty data to
> back-end device at 1 key per second, until all these dirty data
> write over, then goto step 2).
> 
> 2) Loop in bch_writeback_thread() to check if there is enough
> dirty data for writeback. if there is not enough diry data for
> writing, then sleep 10 seconds, otherwise, write dirty data to
> back-end device.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/util.c      |  9 ++++++++-
>  drivers/md/bcache/writeback.c | 11 +++++++----
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index dde6172..d398f09 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -209,7 +209,14 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
>  {
>  	uint64_t now = local_clock();
>  
> -	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
> +	/* 
> +	  if d->rate is zero, write the left dirty data
> +	  at the speed of one key per second 
> +	*/
> +	if(!d->rate)
> +		d->next = now + NSEC_PER_SEC;
> +	else
> +		d->next += div_u64(done * NSEC_PER_SEC, d->rate);
>  
>  	if (time_before64(now + NSEC_PER_SEC, d->next))
>  		d->next = now + NSEC_PER_SEC;
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 69e1ae5..7313643 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -15,6 +15,8 @@
>  #include <linux/kthread.h>
>  #include <trace/events/bcache.h>
>  
> +#define WRITE_BACK_WAIT_CYCLE		10 * HZ
> +
>  /* Rate limiting */
>  
>  static void __update_writeback_rate(struct cached_dev *dc)
> @@ -54,13 +56,14 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  
>  	/* Don't increase writeback rate if the device isn't keeping up */
>  	if (change > 0 &&
> +	    dc->writeback_rate.rate >0 &&
>  	    time_after64(local_clock(),
>  			 dc->writeback_rate.next + NSEC_PER_MSEC))
>  		change = 0;
>  
>  	dc->writeback_rate.rate =
>  		clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
> -			1, NSEC_PER_MSEC);
> +			0, NSEC_PER_MSEC);
>  
>  	dc->writeback_rate_proportional = proportional;
>  	dc->writeback_rate_derivative = derivative;
> @@ -419,15 +422,15 @@ static int bch_writeback_thread(void *arg)
>  	while (!kthread_should_stop()) {
>  		down_write(&dc->writeback_lock);
>  		if (!atomic_read(&dc->has_dirty) ||
> -		    (!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) &&
> -		     !dc->writeback_running)) {
> +		    ((!dc->writeback_rate.rate || !dc->writeback_running) &&
> +		      !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))) {
>  			up_write(&dc->writeback_lock);
>  			set_current_state(TASK_INTERRUPTIBLE);
>  
>  			if (kthread_should_stop())
>  				return 0;
>  
> -			schedule();
> +			schedule_timeout(WRITE_BACK_WAIT_CYCLE);


Wouldn't bch_writeback_thread need woken up on stop or reboot?  Otherwise 
it will hang for a while waiting to exit.  Correct me if I'm wrong here...

--
Eric Wheeler


>  			continue;
>  		}
>  
> -- 
> 2.8.1.windows.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
