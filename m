From: Coly Li <i@coly.li>
Subject: Re: [PATCH v2 1/2] bcache: writeback rate shouldn't artifically clamp
Date: Mon, 9 Oct 2017 18:59:34 +0800
Message-ID: <e6903153-aae6-b9f0-dea7-73e7b6246908@coly.li>
References: <20171009073730.8939-1-mlyle@lyle.org>
 <20171009073730.8939-2-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:52608 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751598AbdJIK7l (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Oct 2017 06:59:41 -0400
In-Reply-To: <20171009073730.8939-2-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, colyli@suse.de

On 2017/10/9 下午3:37, Michael Lyle wrote:
> The previous code artificially limited writeback rate to 1000000
> blocks/second (NSEC_PER_MSEC), which is a rate that can be met on fast
> hardware.  The rate limiting code works fine (though with decreased
> precision) up to 3 orders of magnitude faster, so use NSEC_PER_SEC.
> 
> Additionally, ensure that uint32_t is used as a type for rate throughout
> the rate management so that type checking/clamp_t can work properly.
> 
> bch_next_delay should be rewritten for increased precision and better
> handling of high rates and long sleep periods, but this is adequate for
> now.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>
> Reported-by: Coly Li <colyli@suse.de>

Current maximum rate number is around 488.2M/sec, it could be easily a
bottleneck for md raid0 deivce with SATA SSD or more hard drives. The
new maximum rate (476G/sec) should be enough for most of common hardware
configurations :-)

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li
> ---
>  drivers/md/bcache/bcache.h    | 2 +-
>  drivers/md/bcache/util.h      | 4 ++--
>  drivers/md/bcache/writeback.c | 7 ++++---
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index df0b2ccfca8d..2f9c380c4692 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -363,7 +363,7 @@ struct cached_dev {
>  	int64_t			writeback_rate_proportional;
>  	int64_t			writeback_rate_integral;
>  	int64_t			writeback_rate_integral_scaled;
> -	int64_t			writeback_rate_change;
> +	int32_t			writeback_rate_change;
>  
>  	unsigned		writeback_rate_update_seconds;
>  	unsigned		writeback_rate_i_term_inverse;
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index cb8d2ccbb6c6..8f509290bb02 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -441,10 +441,10 @@ struct bch_ratelimit {
>  	uint64_t		next;
>  
>  	/*
> -	 * Rate at which we want to do work, in units per nanosecond
> +	 * Rate at which we want to do work, in units per second
>  	 * The units here correspond to the units passed to bch_next_delay()
>  	 */
> -	unsigned		rate;
> +	uint32_t		rate;
>  };
>  
>  static inline void bch_ratelimit_reset(struct bch_ratelimit *d)
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index d63356a60001..42d087b9fb56 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -52,7 +52,8 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  	int64_t error = dirty - target;
>  	int64_t proportional_scaled =
>  		div_s64(error, dc->writeback_rate_p_term_inverse);
> -	int64_t integral_scaled, new_rate;
> +	int64_t integral_scaled;
> +	uint32_t new_rate;
>  
>  	if ((error < 0 && dc->writeback_rate_integral > 0) ||
>  	    (error > 0 && time_before64(local_clock(),
> @@ -74,8 +75,8 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  	integral_scaled = div_s64(dc->writeback_rate_integral,
>  			dc->writeback_rate_i_term_inverse);
>  
> -	new_rate = clamp_t(int64_t, (proportional_scaled + integral_scaled),
> -			dc->writeback_rate_minimum, NSEC_PER_MSEC);
> +	new_rate = clamp_t(int32_t, (proportional_scaled + integral_scaled),
> +			dc->writeback_rate_minimum, NSEC_PER_SEC);
>  
>  	dc->writeback_rate_proportional = proportional_scaled;
>  	dc->writeback_rate_integral_scaled = integral_scaled;
