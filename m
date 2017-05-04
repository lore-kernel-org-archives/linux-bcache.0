From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: explicitly destory mutex while exiting
Date: Thu, 4 May 2017 21:59:41 +0800
Message-ID: <823fcdcf-893e-edc7-62c2-585db7f868ed@coly.li>
References: <1493712595-21528-1-git-send-email-liangchen.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:40822 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755342AbdEDOAR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 May 2017 10:00:17 -0400
In-Reply-To: <1493712595-21528-1-git-send-email-liangchen.linux@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Liang Chen <liangchen.linux@gmail.com>, linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net

On 2017/5/2 下午4:09, Liang Chen wrote:
> mutex_destroy does nothing most of time, but it's better to call
> it to make the code future proof and it also has some meaning
> for like mutex debug.
> 

Hi Liang,

Could you please explain a little bit more about how mutex_destroy()
helps to future proof of the code, and how it helps to mutex debug ?

Forgive me for not catching your point.

Thanks.


> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  drivers/md/bcache/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 85e3f21..406fe03 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2083,6 +2083,7 @@ static void bcache_exit(void)
>  	if (bcache_major)
>  		unregister_blkdev(bcache_major, "bcache");
>  	unregister_reboot_notifier(&reboot);
> +	mutex_destroy(&bch_register_lock);
>  }
>  
>  static int __init bcache_init(void)
> @@ -2100,6 +2101,7 @@ static int __init bcache_init(void)
>  
>  	bcache_major = register_blkdev(0, "bcache");
>  	if (bcache_major < 0) {
> +		mutex_destroy(&bch_register_lock);
>  		unregister_reboot_notifier(&reboot);
>  		return bcache_major;
>  	}
> 


-- 
Coly Li
