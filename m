From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/7] bcache: optimize barrier usage for Rmw atomic bitops
Date: Mon, 23 Mar 2020 08:08:15 +0100
Message-ID: <990e3e35-bd4f-7347-9027-e7dfa5171085@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-7-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200322060305.70637-7-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-bcache@vger.kernel.org

On 3/22/20 7:03 AM, Coly Li wrote:
> From: Davidlohr Bueso <dave@stgolabs.net>
> 
> We can avoid the unnecessary barrier on non LL/SC architectures,
> such as x86. Instead, use the smp_mb__after_atomic().
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/writeback.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 6673a37c8bd2..72ba6d015786 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -183,7 +183,7 @@ static void update_writeback_rate(struct work_struct *work)
>   	 */
>   	set_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>   	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -	smp_mb();
> +	smp_mb__after_atomic();
>   
>   	/*
>   	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
> @@ -193,7 +193,7 @@ static void update_writeback_rate(struct work_struct *work)
>   	    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
>   		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>   		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -		smp_mb();
> +		smp_mb__after_atomic();
>   		return;
>   	}
>   
> @@ -229,7 +229,7 @@ static void update_writeback_rate(struct work_struct *work)
>   	 */
>   	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>   	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -	smp_mb();
> +	smp_mb__after_atomic();
>   }
>   
>   static unsigned int writeback_delay(struct cached_dev *dc,
> 
Personally, I'd typically tend to use 'test_and_set_bit', as this not 
only implies a barrier, but also captures any errors; if you just use
'set_bit' you'll never know if the bit had been set already.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
