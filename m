From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v2 2/2] bcache: rearrange writeback main thread ratelimit
Date: Fri, 13 Oct 2017 19:20:13 -0400
Message-ID: <20171013232013.5bm4h5seuxhj7k25@kmo-pixel>
References: <20171009073730.8939-1-mlyle@lyle.org>
 <20171009073730.8939-3-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:45099 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdJMXUR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 19:20:17 -0400
Content-Disposition: inline
In-Reply-To: <20171009073730.8939-3-mlyle@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, colyli@suse.de

On Mon, Oct 09, 2017 at 12:37:30AM -0700, Michael Lyle wrote:
> The time spent searching for things to write back "counts" for the
> actual rate achieved, so don't flush the accumulated rate with each
> chunk.
> 
> This will maintain better fidelity to user-commanded rates, but it
> may slightly increase the burstiness of writeback.  The writeback
> lock needs improvement to help mitigate this.
> 
> Signed-off-by: Michael Lyle <mlyle@lyle.org>

Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>

> ---
>  drivers/md/bcache/writeback.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 42d087b9fb56..719b104db0cc 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -526,6 +526,8 @@ static int bch_writeback_thread(void *arg)
>  	struct cached_dev *dc = arg;
>  	bool searched_full_index;
>  
> +	bch_ratelimit_reset(&dc->writeback_rate);
> +
>  	while (!kthread_should_stop()) {
>  		down_write(&dc->writeback_lock);
>  		if (!atomic_read(&dc->has_dirty) ||
> @@ -553,7 +555,6 @@ static int bch_writeback_thread(void *arg)
>  
>  		up_write(&dc->writeback_lock);
>  
> -		bch_ratelimit_reset(&dc->writeback_rate);
>  		read_dirty(dc);
>  
>  		if (searched_full_index) {
> @@ -563,6 +564,8 @@ static int bch_writeback_thread(void *arg)
>  			       !kthread_should_stop() &&
>  			       !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
>  				delay = schedule_timeout_interruptible(delay);
> +
> +			bch_ratelimit_reset(&dc->writeback_rate);
>  		}
>  	}
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
