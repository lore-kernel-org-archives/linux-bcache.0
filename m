From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 1/2] bcache: add journal statistic
Date: Wed, 31 Jan 2018 18:29:50 -0800
Message-ID: <3390db1e-c6aa-5b41-d84d-facc9e9012cc@lyle.org>
References: <1516955032-6234-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:43201 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbeBAC34 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Jan 2018 21:29:56 -0500
Received: by mail-pl0-f66.google.com with SMTP id f4so2343826plr.10
        for <linux-bcache@vger.kernel.org>; Wed, 31 Jan 2018 18:29:56 -0800 (PST)
In-Reply-To: <1516955032-6234-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

LGTM except for formatting / an extra newline (will fix) -- in my test
branch for possible 4.16

Reviewed-by: Michael Lyle <mlyle@lyle.org>

On 01/26/2018 12:23 AM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Sometimes, Journal takes up a lot of CPU, we need statistics
> to know what's the journal is doing. So this patch provide
> some journal statistics:
> 1) reclaim: how many times the journal try to reclaim resource,
>    usually the journal bucket or/and the pin are exhausted.
> 2) flush_write: how many times the journal try to flush btree node
>    to cache device, usually the journal bucket are exhausted.
> 3) retry_flush_write: how many times the journal retry to flush
>    the next btree node, usually the previous tree node have been
>    flushed by other thread.
> we show these statistic by sysfs interface. Through these statistics
> We can totally see the status of journal module when the CPU is too
> high.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/bcache.h  |  5 +++++
>  drivers/md/bcache/journal.c |  5 +++++
>  drivers/md/bcache/sysfs.c   | 15 +++++++++++++++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index abd31e8..0432e28 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -647,6 +647,11 @@ struct cache_set {
>  	atomic_long_t		writeback_keys_done;
>  	atomic_long_t		writeback_keys_failed;
>  
> +
> +	atomic_long_t		reclaim;
> +	atomic_long_t		flush_write;
> +	atomic_long_t		retry_flush_write;
> +
>  	enum			{
>  		ON_ERROR_UNREGISTER,
>  		ON_ERROR_PANIC,
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 02a98dd..47fd0b8 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -372,6 +372,8 @@ static void btree_flush_write(struct cache_set *c)
>  	 */
>  	struct btree *b, *best;
>  	unsigned i;
> +
> +	atomic_long_inc(&c->flush_write);
>  retry:
>  	best = NULL;
>  
> @@ -392,6 +394,7 @@ static void btree_flush_write(struct cache_set *c)
>  		if (!btree_current_write(b)->journal) {
>  			mutex_unlock(&b->write_lock);
>  			/* We raced */
> +			atomic_long_inc(&c->retry_flush_write);
>  			goto retry;
>  		}
>  
> @@ -471,6 +474,8 @@ static void journal_reclaim(struct cache_set *c)
>  	unsigned iter, n = 0;
>  	atomic_t p;
>  
> +	atomic_long_inc(&c->reclaim);
> +
>  	while (!atomic_read(&fifo_front(&c->journal.pin)))
>  		fifo_pop(&c->journal.pin, p);
>  
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 234b2f5..0afbf1a 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -65,6 +65,9 @@
>  
>  read_attribute(state);
>  read_attribute(cache_read_races);
> +read_attribute(reclaim);
> +read_attribute(flush_write);
> +read_attribute(retry_flush_write);
>  read_attribute(writeback_keys_done);
>  read_attribute(writeback_keys_failed);
>  read_attribute(io_errors);
> @@ -543,6 +546,15 @@ static unsigned bch_average_key_size(struct cache_set *c)
>  	sysfs_print(cache_read_races,
>  		    atomic_long_read(&c->cache_read_races));
>  
> +	sysfs_print(reclaim,
> +		    atomic_long_read(&c->reclaim));
> +
> +	sysfs_print(flush_write,
> +		    atomic_long_read(&c->flush_write));
> +
> +	sysfs_print(retry_flush_write,
> +		    atomic_long_read(&c->retry_flush_write));
> +
>  	sysfs_print(writeback_keys_done,
>  		    atomic_long_read(&c->writeback_keys_done));
>  	sysfs_print(writeback_keys_failed,
> @@ -729,6 +741,9 @@ static void bch_cache_set_internal_release(struct kobject *k)
>  
>  	&sysfs_bset_tree_stats,
>  	&sysfs_cache_read_races,
> +	&sysfs_reclaim,
> +	&sysfs_flush_write,
> +	&sysfs_retry_flush_write,
>  	&sysfs_writeback_keys_done,
>  	&sysfs_writeback_keys_failed,
>  
> 
