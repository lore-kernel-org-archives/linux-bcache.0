From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: journel: use for_each_clear_bit() to simplify the
 code
Date: Wed, 24 Jun 2020 22:51:31 +0800
Message-ID: <4c266f0d-3d98-da0f-6c31-4afe922a2d0c@suse.de>
References: <20200624065257.4051-1-vulab@iscas.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389818AbgFXOvh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Jun 2020 10:51:37 -0400
In-Reply-To: <20200624065257.4051-1-vulab@iscas.ac.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Xu Wang <vulab@iscas.ac.cn>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On 2020/6/24 14:52, Xu Wang wrote:
> Using for_each_clear_bit() to simplify the code.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

It looks good to me, I will add it in my testing patches.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/journal.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 90aac4e2333f..b01c953e214c 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -217,10 +217,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
>  		 */
>  		pr_debug("falling back to linear search\n");
>  
> -		for (l = find_first_zero_bit(bitmap, ca->sb.njournal_buckets);
> -		     l < ca->sb.njournal_buckets;
> -		     l = find_next_zero_bit(bitmap, ca->sb.njournal_buckets,
> -					    l + 1))
> +		for_each_clear_bit(l, bitmap, ca->sb.njournal_buckets)
>  			if (read_bucket(l))
>  				goto bsearch;
>  
> 
