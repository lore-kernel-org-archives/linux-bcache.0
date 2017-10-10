From: Coly Li <i@coly.li>
Subject: Re: [PATCH v2] bcache: explicitly destroy mutex while exiting
Date: Tue, 10 Oct 2017 20:25:57 +0800
Message-ID: <01f432e8-950a-fc9f-150d-0b51fa9e7559@coly.li>
References: <20171010090049.6596-1-liangchen.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171010090049.6596-1-liangchen.linux@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>, linux-bcache@vger.kernel.org
Cc: mlyle@lyle.org, kent.overstreet@gmail.com, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/10/10 下午5:00, Liang Chen wrote:
> mutex_destroy does nothing most of time, but it's better to call
> it to make the code future proof and it also has some meaning
> for like mutex debug.
> 
> As Coly pointed out in a previous review, bcache_exit() may not be
> able to handle all the references properly if userspace registers
> cache and backing devices right before bch_debug_init runs and
> bch_debug_init failes later. So not exposing userspace interface
> until everything is ready to avoid that issue.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>

Hi Liang,

No more comment from me, it looks good. Thanks.

Reviewed-by: Coly Li <colyli@suse.de>

> ---
>  drivers/md/bcache/super.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index fc0a31b..25bf003 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2085,6 +2085,7 @@ static void bcache_exit(void)
>  	if (bcache_major)
>  		unregister_blkdev(bcache_major, "bcache");
>  	unregister_reboot_notifier(&reboot);
> +	mutex_destroy(&bch_register_lock);
>  }
>  
>  static int __init bcache_init(void)
> @@ -2103,14 +2104,15 @@ static int __init bcache_init(void)
>  	bcache_major = register_blkdev(0, "bcache");
>  	if (bcache_major < 0) {
>  		unregister_reboot_notifier(&reboot);
> +		mutex_destroy(&bch_register_lock);
>  		return bcache_major;
>  	}
>  
>  	if (!(bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0)) ||
>  	    !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||
> -	    sysfs_create_files(bcache_kobj, files) ||
>  	    bch_request_init() ||
> -	    bch_debug_init(bcache_kobj))
> +	    bch_debug_init(bcache_kobj) ||
> +	    sysfs_create_files(bcache_kobj, files))
>  		goto err;
>  
>  	return 0;
> 


-- 
Coly Li
