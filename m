From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] bcache: fix issue of writeback rate at minimum 1 block
 per second
Date: Fri, 9 Jun 2017 01:40:13 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706090138470.19359@mail.ewheeler.net>
References: <1496914493-8460-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35238 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751445AbdFIBkQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Jun 2017 21:40:16 -0400
In-Reply-To: <1496914493-8460-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, i@coly.li, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

On Thu, 8 Jun 2017, tang.junhui@zte.com.cn wrote:

> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> When there is not enough data in writeback cache, let the writeback rate
> to be 0, and delay 30 seconds in read_dirty().
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/util.c      | 17 ++++++++++++-----
>  drivers/md/bcache/writeback.c |  2 +-
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index dde6172..cf750df 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -15,6 +15,8 @@
>  
>  #include "util.h"
>  
> +#define ZERO_RATE_DELAY_NS	30*NSEC_PER_SEC
> +

Hi tang,

If you re-submit a patch to the list with changes, please annotate [PATCH v2]
so it is clear that the previous version has been replaced.  

Thank you for all of the patches!  Please include test cases whenever 
possible so we understand what is being fixed.

--
Eric Wheeler



>  #define simple_strtoint(c, end, base)	simple_strtol(c, end, base)
>  #define simple_strtouint(c, end, base)	simple_strtoul(c, end, base)
>  
> @@ -209,13 +211,18 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
>  {
>  	uint64_t now = local_clock();
>  
> -	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
> +	if (!d->rate) {
> +		d->next = now + ZERO_RATE_DELAY_NS;
> +	}
> +	else {
> +		d->next += div_u64(done * NSEC_PER_SEC, d->rate);
>  
> -	if (time_before64(now + NSEC_PER_SEC, d->next))
> -		d->next = now + NSEC_PER_SEC;
> +		if (time_before64(now + NSEC_PER_SEC, d->next))
> +			d->next = now + NSEC_PER_SEC;
>  
> -	if (time_after64(now - NSEC_PER_SEC * 2, d->next))
> -		d->next = now - NSEC_PER_SEC * 2;
> +		if (time_after64(now - NSEC_PER_SEC * 2, d->next))
> +			d->next = now - NSEC_PER_SEC * 2;
> +	}
>  
>  	return time_after64(d->next, now)
>  		? div_u64(d->next - now, NSEC_PER_SEC / HZ)
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 69e1ae5..8fac280 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -60,7 +60,7 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  
>  	dc->writeback_rate.rate =
>  		clamp_t(int64_t, (int64_t) dc->writeback_rate.rate + change,
> -			1, NSEC_PER_MSEC);
> +			0, NSEC_PER_MSEC);
>  
>  	dc->writeback_rate_proportional = proportional;
>  	dc->writeback_rate_derivative = derivative;
> -- 
> 2.8.1.windows.1
> 
> 
> 
