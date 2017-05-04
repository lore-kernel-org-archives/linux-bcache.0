From: Coly Li <i@coly.li>
Subject: Re: [PATCH 1/2] bcache: name bcache devices in an ordered sequence as
 bcache0, bcache1
Date: Thu, 4 May 2017 22:02:47 +0800
Message-ID: <5053a636-b422-30f8-5661-e03ea908d21f@coly.li>
References: <1491813398-7344-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:40836 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752466AbdEDODe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 May 2017 10:03:34 -0400
In-Reply-To: <1491813398-7344-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org

On 2017/4/10 下午4:36, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> Currently, names of bcache devices displayed as bcache0, bcache16,
> bcache32, etc. This patch changes their names as bcache0, bcache1,
> bcache2, etc.
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/bcache/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3a19cbc..867d9a9 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -793,7 +793,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  	}
>  
>  	set_capacity(d->disk, sectors);
> -	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor);
> +	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor / BCACHE_MINORS);
>  
>  	d->disk->major		= bcache_major;
>  	d->disk->first_minor	= minor;
> 

Can I understand that the next patch just revert this modification ? If
yes, I suggest to combine these 2 patch into one.

-- 
Coly Li
