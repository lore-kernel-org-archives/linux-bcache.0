From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 05/10] bcache: stop dc->writeback_rate_update if cache
 set is stopping
Date: Mon, 8 Jan 2018 08:22:19 +0100
Message-ID: <b399ead7-34b4-1dfd-16c3-f506516d4466@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-6-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755768AbeAHHWV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jan 2018 02:22:21 -0500
In-Reply-To: <20180103140325.63175-6-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn

On 01/03/2018 03:03 PM, Coly Li wrote:
> struct delayed_work writeback_rate_update in struct cache_dev is a delayed
> worker to call function update_writeback_rate() in period (the interval is
> defined by dc->writeback_rate_update_seconds).
> 
> When a metadate I/O error happens on cache device, bcache error handling
> routine bch_cache_set_error() will call bch_cache_set_unregister() to
> retire whole cache set. On the unregister code path, cached_dev_free()
> calls cancel_delayed_work_sync(&dc->writeback_rate_update) to stop this
> delayed work.
> 
> dc->writeback_rate_update is a special delayed work from others in bcache.
> In its routine update_writeback_rate(), this delayed work is re-armed
> after a piece of time. That means when cancel_delayed_work_sync() returns,
> this delayed work can still be executed after several seconds defined by
> dc->writeback_rate_update_seconds.
> 
> The problem is, after cancel_delayed_work_sync() returns, the cache set
> unregister code path will eventually release memory of struct cache set.
> Then the delayed work is scheduled to run, and inside its routine
> update_writeback_rate() that already released cache set NULL pointer will
> be accessed. Now a NULL pointer deference panic is triggered.
> 
> In order to avoid the above problem, this patch checks cache set flags in
> delayed work routine update_writeback_rate(). If flag CACHE_SET_STOPPING
> is set, this routine will quit without re-arm the delayed work. Then the
> NULL pointer deference panic won't happen after cache set is released.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/writeback.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 0789a9e18337..745d9b2a326f 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -91,6 +91,11 @@ static void update_writeback_rate(struct work_struct *work)
>  	struct cached_dev *dc = container_of(to_delayed_work(work),
>  					     struct cached_dev,
>  					     writeback_rate_update);
> +	struct cache_set *c = dc->disk.c;
> +
> +	/* quit directly if cache set is stopping */
> +	if (test_bit(CACHE_SET_STOPPING, &c->flags))
> +		return;
>  
>  	down_read(&dc->writeback_lock);
>  
> @@ -100,6 +105,10 @@ static void update_writeback_rate(struct work_struct *work)
>  
>  	up_read(&dc->writeback_lock);
>  
> +	/* do not schedule delayed work if cache set is stopping */
> +	if (test_bit(CACHE_SET_STOPPING, &c->flags))
> +		return;
> +
>  	schedule_delayed_work(&dc->writeback_rate_update,
>  			      dc->writeback_rate_update_seconds * HZ);
>  }
> 
This is actually not quite correct; the function might still be called
after 'struct cached_dev' has been removed.
The correct way of fixing is to either take a reference to struct
cached_dev and release it once 'update_writeback_rate' is finished, or
to call 'cancel_delayed_work_sync()' before deleting struct cached_dev.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
