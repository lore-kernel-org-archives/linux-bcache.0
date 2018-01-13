From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: btree.c: Fix GC thread exit in case of cache
 device failure and unregister
Date: Sat, 13 Jan 2018 12:06:26 +0800
Message-ID: <8bf2eafd-651e-ce0b-3a4c-aa10e292ce2f@coly.li>
References: <1515770690-18562-1-git-send-email-freakpv@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:35592 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965403AbeAMEGd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Jan 2018 23:06:33 -0500
In-Reply-To: <1515770690-18562-1-git-send-email-freakpv@gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pavel Vazharov <freakpv@gmail.com>, mlyle@lyle.org, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/01/2018 11:24 PM, Pavel Vazharov wrote:
> There was a possibility for infinite do-while loop inside the GC thread
> function in case of total failure of the caching device. I was able to
> reproduce it 3 times simulating disappearing of the caching device via
> 'echo 1 > /sys/block/<dev>/device/delete'. In that case the btree_root
> starts to return non zero and non -EAGAIN result, 'gc failed' message
> start to fill the kernel log and the do-while becomes infinite loop
> occupying single CPU core at 100%.
> There is already a logic which unregisters the cache_set (or panics) in
> case of io errors and thus we exit the loop here if the unregistering
> procedure has already started.
> 
> Signed-off-by: Pavel Vazharov <freakpv@gmail.com>
> ---
>  drivers/md/bcache/btree.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 81e8dc3..a672081 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1748,8 +1748,12 @@ static void bch_btree_gc(struct cache_set *c)
>  		closure_sync(&writes);
>  		cond_resched();
>  
> -		if (ret && ret != -EAGAIN)
> -			pr_warn("gc failed!");
> +		if (ret && ret != -EAGAIN) {
> +			if (test_bit(CACHE_SET_UNREGISTERING, &c->flags))
> +				break;
> +			else
> +				pr_warn("gc failed!");
> +		}
>  	} while (ret);
>  
>  	bch_btree_gc_finish(c);
> 

Hi Pavel,

I see the point here. But there are 2 code paths to call
cache_set_flush(), one is from bch_cache_set_error(), one is from sysfs
interface (echo 1 > /sys/fs/bcache/<UUID>/stop).

CACHE_SET_UNREGISTERING is set in the first code path, the another code
path from sysfs does not set CACHE_SET_UNREGISTERING. In this case maybe
the above while-loop can not be stopped.

In my device failure cache set, I add an io_disable (in v2 it is
CACHE_SET_IO_DISABLE flag) to disable all cache set I/O, maybe it can be
used to check the condition and break the while-loop.

Thanks for the hint, I will also try to fix it in my patch set. If you
don't mind, I am glad to have your "Reviewed-by:" after I post the v2
patch set.

Thanks.

-- 
Coly Li
