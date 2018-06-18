From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 3/3] bcache: do not assign in if condition in
 bcache_device_init()
Date: Mon, 18 Jun 2018 21:45:53 +0800
Message-ID: <79b31a5a-ef33-2f4e-6dfd-38c67304ded8@suse.de>
References: <20180618100902.4015-1-flo@geekplace.eu>
 <20180618100902.4015-4-flo@geekplace.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618100902.4015-4-flo@geekplace.eu>
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
> ---
>  drivers/md/bcache/super.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f09f4f046315..4a2a028c8754 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -796,11 +796,12 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  		return idx;
>  
>  	if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
> -			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
> -	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
> -		ida_simple_remove(&bcache_device_idx, idx);
> -		return -ENOMEM;
> -	}
> +				BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))

Signed-off-by: Coly Li <colyli@suse.de>
I fix the above indent and added the patch into for-next patch set. Thanks.

Coly Li

> +		goto err;
> +
> +	d->disk = alloc_disk(BCACHE_MINORS);
> +	if (!d->disk)
> +		goto err;
>  
>  	set_capacity(d->disk, sectors);
>  	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
> @@ -834,6 +835,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  	blk_queue_write_cache(q, true, true);
>  
>  	return 0;
> +
> +err:
> +	ida_simple_remove(&bcache_device_idx, idx);
> +	return -ENOMEM;
> +
>  }
>  
>  /* Cached device */
> 
