From: Coly Li <i@coly.li>
Subject: Re: [PATCH 3/5] bcache: smooth writeback rate control
Date: Wed, 27 Sep 2017 16:44:51 +0800
Message-ID: <51e8cadd-787c-fc4f-f8e4-8d122e6cad7c@coly.li>
References: <20170926192423.10665-1-mlyle@lyle.org>
 <20170926192423.10665-3-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:59034 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbdI0IpZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 04:45:25 -0400
In-Reply-To: <20170926192423.10665-3-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org

On 2017/9/27 上午3:24, Michael Lyle wrote:
> This works in conjunction with the new PI controller.  Currently, in
> real-world workloads, the rate controller attempts to write back 1
> sector per second.  In practice, these minimum-rate writebacks are
> between 4k and 60k in test scenarios, since bcache aggregates and
> attempts to do contiguous writes and because filesystems on top of
> bcachefs typically write 4k or more.
> 
> Previously, bcache used to guarantee to write at least once per second.
> This means that the actual writeback rate would exceed the configured
> amount by a factor of 8-120 or more.
> 
> This patch adjusts to be willing to sleep up to 2.5 seconds, and to
> target writing 4k/second.  On the smallest writes, it will sleep 1
> second like before, but many times it will sleep longer and load the
> backing device less.  This keeps the loading on the cache and backing
> device related to writeback more consistent when writing back at low
> rates.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>

Reviewed-by: Coly Li <colyli@suse.de>

Added to for-test. Thanks.

> ---
>  drivers/md/bcache/util.c      | 10 ++++++++--
>  drivers/md/bcache/writeback.c |  2 +-
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 176d3c2ef5f5..4dbe37e82877 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -232,8 +232,14 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
>  
>  	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
>  
> -	if (time_before64(now + NSEC_PER_SEC, d->next))
> -		d->next = now + NSEC_PER_SEC;
> +	/* Bound the time.  Don't let us fall further than 2 seconds behind
> +	 * (this prevents unnecessary backlog that would make it impossible
> +	 * to catch up).  If we're ahead of the desired writeback rate,
> +	 * don't let us sleep more than 2.5 seconds (so we can notice/respond
> +	 * if the control system tells us to speed up!).
> +	 */
> +	if (time_before64(now + NSEC_PER_SEC * 5 / 2, d->next))
> +		d->next = now + NSEC_PER_SEC * 5 / 2;
>  
>  	if (time_after64(now - NSEC_PER_SEC * 2, d->next))
>  		d->next = now - NSEC_PER_SEC * 2;
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 5a8f5655151b..0b7c89813635 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -523,7 +523,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>  	dc->writeback_percent		= 10;
>  	dc->writeback_delay		= 30;
>  	dc->writeback_rate.rate		= 1024;
> -	dc->writeback_rate_minimum	= 1;
> +	dc->writeback_rate_minimum	= 8;
>  
>  	dc->writeback_rate_update_seconds = 5;
>  	dc->writeback_rate_p_term_inverse = 40;
> 


-- 
Coly Li
