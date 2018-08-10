From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: [PATCH] bcache: fix 0day error of setting writeback_rate by sysfs
 interface
Date: Fri, 10 Aug 2018 20:13:21 +0200
Message-ID: <16e6c566-5f4d-0d52-3c6e-aa2815baff29@profihost.ag>
References: <20180810154550.5020-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180810154550.5020-1-colyli@suse.de>
Content-Language: de-DE
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org, Kai Krakow <kai@kaishome.de>
List-Id: linux-bcache@vger.kernel.org

Thanks for cc. How is this exploitable? I mean only root can write to
sysfs? Or do you mean by allowing a user via sudo to write to that entry?

Stefan

Am 10.08.2018 um 17:45 schrieb Coly Li:
> Commit ea8c5356d390 ("bcache: set max writeback rate when I/O request
> is idle") changes struct bch_ratelimit member rate from uint32_t to
> atomic_long_t and uses atomic_long_set() in drivers/md/bcache/sysfs.c
> to set new writeback rate, after the input is converted from memory
> buf to long int by sysfs_strtoul_clamp().
> 
> The above change has a problem because there is an implicit return
> inside sysfs_strtoul_clamp() so the following atomic_long_set()
> won't be called. This error is detected by 0day system with following
> snipped smatch warnings:
> 
> drivers/md/bcache/sysfs.c:271 __cached_dev_store() error: uninitialized
> symbol 'v'.
> 270  sysfs_strtoul_clamp(writeback_rate, v, 1, INT_MAX);
>      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> @271 atomic_long_set(&dc->writeback_rate.rate, v);
> 
> This patch fixes the above error by using strtoul_safe_clamp() to
> convert the input buffer into a long int type result.
> 
> Fixes: Commit ea8c5356d390 ("bcache: set max writeback rate when I/O request is idle")
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: stable@vger.kernel.org #4.16+
> Cc: Kai Krakow <kai@kaishome.de>
> Cc: Stefan Priebe <s.priebe@profihost.ag>
> ---
>  drivers/md/bcache/sysfs.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 543b06408321..150cf4f4cf74 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -267,10 +267,17 @@ STORE(__cached_dev)
>  	sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent, 0, 40);
>  
>  	if (attr == &sysfs_writeback_rate) {
> -		int v;
> +		ssize_t ret;
> +		long int v = atomic_long_read(&dc->writeback_rate.rate);
> +
> +		ret = strtoul_safe_clamp(buf, v, 1, INT_MAX);
>  
> -		sysfs_strtoul_clamp(writeback_rate, v, 1, INT_MAX);
> -		atomic_long_set(&dc->writeback_rate.rate, v);
> +		if (!ret) {
> +			atomic_long_set(&dc->writeback_rate.rate, v);
> +			ret = size;
> +		}
> +
> +		return ret;
>  	}
>  
>  	sysfs_strtoul_clamp(writeback_rate_update_seconds,
> 
