From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: Fix bcache device names
Date: Thu, 2 Mar 2017 22:11:23 +0800
Message-ID: <bbc24f07-64c7-2095-f2ba-877016070175@coly.li>
References: <1488453115-17245-1-git-send-email-stefan.bader@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488453115-17245-1-git-send-email-stefan.bader@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Bader <stefan.bader@canonical.com>, linux-bcache@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Wheeler <bcache@linux.ewheeler.net>
List-Id: linux-bcache@vger.kernel.org

On 2017/3/2 下午7:11, Stefan Bader wrote:
> When adding partition support to bcache, the name assignment was not
> updated, resulting in numbers jumping (bcache0, bcache16, bcache32...).
> Fix this by taking BCACHE_MINORS into account when assigning the disk
> name.
> 
> BugLink: https://bugs.launchpad.net/bugs/1667078
> 
> Fixes: b8c0d91 (bcache: partition support: add 16 minors per bcacheN device)
> Cc: <stable@vger.kernel.org> # v4.10
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
>  drivers/md/bcache/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 85e3f21..817e155 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -793,7 +793,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  	}
>  
>  	set_capacity(d->disk, sectors);
> -	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor);
> +	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i",
> +		 minor / BCACHE_MINORS);
>  
>  	d->disk->major		= bcache_major;
>  	d->disk->first_minor	= minor;
> 
