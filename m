From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: lock in btree_flush_write() to avoid races
Date: Wed, 24 Jan 2018 17:13:31 +0800
Message-ID: <bfa1be99-05fd-ffae-3d6d-0d9cae140415@suse.de>
References: <1516776864-26993-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40023 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932327AbeAXJNj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Jan 2018 04:13:39 -0500
In-Reply-To: <1516776864-26993-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 24/01/2018 2:54 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> In btree_flush_write(), two places need to take a locker to
> avoid races:
> 
> Firstly, we need take rcu read locker to protect the bucket_hash
> traverse, since hlist_for_each_entry_rcu() must be called under
> the protection of rcu read locker.
> 
> Secondly, we need take b->write_lock locker to protect journal
> of the btree node, otherwise, the btree node may have been
> written, and the journal have been assign to NULL.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/journal.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 02a98dd..505f9f3 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -375,7 +375,9 @@ static void btree_flush_write(struct cache_set *c)
>  retry:
>  	best = NULL;
>  
> -	for_each_cached_btree(b, c, i)
> +	rcu_read_lock();
> +	for_each_cached_btree(b, c, i) {
> +		mutex_lock(&b->write_lock);
>  		if (btree_current_write(b)->journal) {
>  			if (!best)
>  				best = b;
> @@ -385,6 +387,9 @@ static void btree_flush_write(struct cache_set *c)
>  				best = b;
>  			}
>  		}
> +		mutex_unlock(&b->write_lock);
> +	}
> +	rcu_read_unlock();
>  
>  	b = best;
>  	if (b) {
> 

Hi Junhui,

Do you run into some real problem ? The patch looks good to me at first
glance, but I need time to dig it more before I provide my response.

Thanks.

Coly Li
