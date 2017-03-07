From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] bcache: Fix leak of bdev reference
Date: Tue, 7 Mar 2017 16:28:01 +0100
Message-ID: <20170307152801.GA11412@quack2.suse.cz>
References: <20170209131916.13330-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932589AbdCGQDp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Mar 2017 11:03:45 -0500
Content-Disposition: inline
In-Reply-To: <20170209131916.13330-1-jack@suse.cz>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Jan Kara <jack@suse.cz>

On Thu 09-02-17 14:19:16, Jan Kara wrote:
> If blkdev_get_by_path() in register_bcache() fails, we try to lookup the
> block device using lookup_bdev() to detect which situation we are in to
> properly report error. However we never drop the reference returned to
> us from lookup_bdev(). Fix that.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Ping? This seems to have fallen through the cracks...

								Honza
> ---
>  drivers/md/bcache/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3a19cbc8b230..2a6a4a0520f6 100644
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
> -- 
> 2.10.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
