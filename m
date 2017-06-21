From: Coly Li <i@coly.li>
Subject: Re: [PATCH] [PATCH v3] bcache: fix issue of writeback rate at minimum
 1 key per second
Date: Wed, 21 Jun 2017 16:45:08 +0800
Message-ID: <7b1cf2be-0813-6f05-3020-18dc866a0376@coly.li>
References: <1498024368-7224-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:37006 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbdFUIpU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2017 04:45:20 -0400
In-Reply-To: <1498024368-7224-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

On 2017/6/21 下午1:52, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> When there is not enough dirty data in writeback cache,
> writeback rate is at minimum 1 key per second
> util all dirty data to be cleaned, it is inefficiency,
> and also causes waste of energy;
> 

Hi Junhui,

Thanks for the informative comments.

> in this patch, When there is not enough dirty data,

Could you please how to judge there is enough dirty data ?

> let the writeback rate to be 0, and writeback re-schedule
> in bch_writeback_thread() periodically with schedule_timeout(),
> the behaviors are as follows :
> 
> 1) If no dirty data have been read into dc->writeback_keys,

Is it read into, or write into ?

> goto step 2), otherwise keep writing these dirty data to
> back-end device at 1 key per second, until all these dirty data
> write over, then goto step 2).
> 
> 2) Loop in bch_writeback_thread() to check if there is enough
> dirty data for writeback. if there is not enough diry data for

It is not clear to me, once in step 1) dirty data already got written
into back device at the rate of 1 key per second, why check dirty data
again here?

> writing, then sleep 10 seconds, otherwise, write dirty data to
> back-end device.

Is this the situation that step 1) handles ? That is, when there is
dirty data in, write it out at rate of 1 key per second ?


> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/util.c      |  9 ++++++++-
>  drivers/md/bcache/writeback.c | 10 ++++++----
>  2 files changed, 14 insertions(+), 5 deletions(-)
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
> index 69e1ae5..2966eab 100644
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
> @@ -60,7 +62,7 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  
>  	dc->writeback_rate.rate =
>  		clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
> -			1, NSEC_PER_MSEC);
> +			0, NSEC_PER_MSEC);
>  
>  	dc->writeback_rate_proportional = proportional;
>  	dc->writeback_rate_derivative = derivative;
> @@ -419,15 +421,15 @@ static int bch_writeback_thread(void *arg)
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

Why use schedule_timeout() here ? This patch is dedicated for mobile
devices, I am not sure whether it is a good idea to wake up process in
every 10 HZ.

>  			continue;
>  		}

I come to understand your idea of this patch step by step, thanks for
your patience to answer my questions.

-- 
Coly Li
