From: Coly Li <i@coly.li>
Subject: Re: [PATCH] [PATCH v2] bcache: gc does not work when triggering by
 manual command
Date: Wed, 21 Jun 2017 16:55:00 +0800
Message-ID: <71e16c03-8c5b-30f9-8d3b-3d3bb8ea389b@coly.li>
References: <1496992301-10448-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:37036 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752566AbdFUIzG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2017 04:55:06 -0400
In-Reply-To: <1496992301-10448-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: kent.overstreet@gmail.com, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

On 2017/6/9 下午3:11, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> I try to execute the following command to trigger gc thread:
> [root@localhost internal]# echo 1 > trigger_gc
> But it does not work, I debug the code in gc_should_run(), It works only
> if in invalidating or sectors_to_gc < 0. So set sectors_to_gc to -1 to
> meet the condition when we trigger gc by manual command.
> 

Hi Junhui,

Thanks for the patch, it totally makes sense IMHO. In most of use cases
I know, people writing to trigger_gc file expecting a force garbage
collection.

But assign a minus value here is quite confused for people who read the
code. Could you please also add some comments in the code to explain why
you set c->sectors_to_gc to -1 here.

And there might be a race that when you set c->sectors_to_gc to -1, and
call wake_up_gc(), but before code go into gc_should_run(),
c->sectors_to_gc is reset by set_gc_sectors(). I have no object if you
don't want to handle this situation, but I do suggest to explain it in
code why we can ignore such a race.

> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/sysfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index b3ff57d..f5bb93a 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -614,8 +614,10 @@ STORE(__bch_cache_set)
>  		bch_cache_accounting_clear(&c->accounting);
>  	}
>  
> -	if (attr == &sysfs_trigger_gc)
> +	if (attr == &sysfs_trigger_gc) {
> +		atomic_set(&c->sectors_to_gc, -1);
>  		wake_up_gc(c);
> +	}
>  
>  	if (attr == &sysfs_prune_cache) {
>  		struct shrink_control sc;
> 


-- 
Coly Li
