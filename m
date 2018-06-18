From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 2/3] bcache: do not assign in if condition in
 bcache_init()
Date: Mon, 18 Jun 2018 21:44:35 +0800
Message-ID: <ef26a060-689d-8ee9-57fb-b8473ca97fea@suse.de>
References: <20180618100902.4015-1-flo@geekplace.eu>
 <20180618100902.4015-3-flo@geekplace.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618100902.4015-3-flo@geekplace.eu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Schmaus <flo@geekplace.eu>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/6/18 6:09 PM, Florian Schmaus wrote:
> Fixes an error condition reported by checkpatch.pl which is caused by
> assigning a variable in an if condition.
> 
> Signed-off-by: Florian Schmaus <flo@geekplace.eu>

Signed-off-by: Coly Li <colyli@suse.de>

Added into for-next patch set.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index db7177d422e5..f09f4f046315 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2328,9 +2328,15 @@ static int __init bcache_init(void)
>  		return bcache_major;
>  	}
>  
> -	if (!(bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0)) ||
> -	    !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||
> -	    bch_request_init() ||
> +	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
> +	if (!bcache_wq)
> +		goto err;
> +
> +	bcache_kobj = kobject_create_and_add("bcache", fs_kobj);
> +	if (!bcache_kobj)
> +		goto err;
> +
> +	if (bch_request_init() ||
>  	    bch_debug_init(bcache_kobj) || closure_debug_init() ||
>  	    sysfs_create_files(bcache_kobj, files))
>  		goto err;
> 
