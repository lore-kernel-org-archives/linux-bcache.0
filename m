From: Coly Li <i@coly.li>
Subject: Re: [PATCH 01/19] bcache: Fix leak of bdev reference
Date: Sun, 2 Jul 2017 00:55:06 +0800
Message-ID: <f47035c9-de0f-3eb9-dfda-65dae304bb14@coly.li>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: bcache@lists.ewheeler.net, linux-block@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Jan Kara <jack@suse.cz>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/7/1 上午4:42, bcache@lists.ewheeler.net wrote:
> From: Jan Kara <jack@suse.cz>
> 
> If blkdev_get_by_path() in register_bcache() fails, we try to lookup the
> block device using lookup_bdev() to detect which situation we are in to
> properly report error. However we never drop the reference returned to
> us from lookup_bdev(). Fix that.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
>  drivers/md/bcache/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 8352fad..9a2c190 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1964,6 +1964,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  			else
>  				err = "device busy";
>  			mutex_unlock(&bch_register_lock);
> +			if (!IS_ERR(bdev))
> +				bdput(bdev);
>  			if (attr == &ksysfs_register_quiet)
>  				goto out;
>  		}
> 


-- 
Coly Li
