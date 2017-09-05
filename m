From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: remove problematic code block from
 register_bcache()
Date: Tue, 5 Sep 2017 16:03:35 +0800
Message-ID: <c98d0ae0-9b6a-aada-577e-3f34d43a2eed@coly.li>
References: <20170905071049.20273-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:57218 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750766AbdIEIDv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Sep 2017 04:03:51 -0400
In-Reply-To: <20170905071049.20273-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>

On 2017/9/5 下午3:10, Coly Li wrote:
> There is a leak of bdev reference in register_bcache(), and Jan Kara
> posted a patch to fix it. Discussion happened on bcache mailing list,
> Christoph Hellwig pointed out that whole chunk of code where the bdev
> reference leak lied was problematic,
> 
> 	"adding a lookup_bdev and resulting mess just for a
> 	 slightly different error message is just insane"
> 
> This patch jsut removes whole chunk of the problematic code, of cause
> the leak of bdev reference is removed too.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  drivers/md/bcache/super.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 8352fad765f6..85262f2628fb 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1955,20 +1955,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	bdev = blkdev_get_by_path(strim(path),
>  				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
>  				  sb);
> -	if (IS_ERR(bdev)) {
> -		if (bdev == ERR_PTR(-EBUSY)) {
> -			bdev = lookup_bdev(strim(path));
> -			mutex_lock(&bch_register_lock);
> -			if (!IS_ERR(bdev) && bch_is_open(bdev))
> -				err = "device already registered";
> -			else
> -				err = "device busy";
> -			mutex_unlock(&bch_register_lock);
> -			if (attr == &ksysfs_register_quiet)
> -				goto out;
> -		}
> +	if (IS_ERR(bdev))
>  		goto err;
> -	}
>  
>  	err = "failed to set blocksize";
>  	if (set_blocksize(bdev, 4096))
> 

Hi Jan and Christoph,

There are other three functions only referenced in the above chunk of code,
- bch_is_open()
- bch_is_open_cache()
- bch_is_open_backing()
they should be removed as well.

So you may ignore this email, an update version of this patch will be
posted to linux-bache and linux-block mailing lists for review.

Thanks.

-- 
Coly Li
