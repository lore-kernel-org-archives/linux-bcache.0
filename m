From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: io.c: Fix check against error_limit in case of io
 errors
Date: Sat, 13 Jan 2018 11:40:54 +0800
Message-ID: <fe58efbf-a859-e9a3-ba86-ed86232cc51f@coly.li>
References: <1515766051-13380-1-git-send-email-freakpv@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:35534 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965415AbeAMDlC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Jan 2018 22:41:02 -0500
In-Reply-To: <1515766051-13380-1-git-send-email-freakpv@gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pavel Vazharov <freakpv@gmail.com>, mlyle@lyle.org, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/01/2018 10:07 PM, Pavel Vazharov wrote:
> The actual sysfs io_error_limit value is left shifted IO_ERROR_SHIFT
> times before it is stored in the error_limit.
> This fixes the un-registering of the cache set when the io_errors reach
> the error_limit value.
> 
> Signed-off-by: Pavel Vazharov <freakpv@gmail.com>
> ---
>  drivers/md/bcache/io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
> index fac97ec..1ef6ae2 100644
> --- a/drivers/md/bcache/io.c
> +++ b/drivers/md/bcache/io.c
> @@ -93,7 +93,7 @@ void bch_count_io_errors(struct cache *ca, blk_status_t error, const char *m)
>  						    &ca->io_errors);
>  		errors >>= IO_ERROR_SHIFT;
>  
> -		if (errors < ca->set->error_limit)
> +		if (errors < (ca->set->error_limit >> IO_ERROR_SHIFT))
>  			pr_err("%s: IO error on %s, recovering",
>  			       bdevname(ca->bdev, buf), m);
>  		else
> 

Hi Pavel,

A similar fix is also in my device failure patch set, its name is,
    bcache: set error_limit correctly
The difference is, I remove the bit shift of error_limit.

-- 
Coly Li
