From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/5] bcache: fix refcount underflow in
 bcache_device_free()
Date: Tue, 26 May 2020 11:23:05 -0600
Message-ID: <34b826ff-0093-4427-f542-88c17abad934@kernel.dk>
References: <20200526155928.32036-1-colyli@suse.de>
 <20200526155928.32036-4-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388606AbgEZRXI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 May 2020 13:23:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C5C03E96D
        for <linux-bcache@vger.kernel.org>; Tue, 26 May 2020 10:23:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x13so10430363pfn.11
        for <linux-bcache@vger.kernel.org>; Tue, 26 May 2020 10:23:08 -0700 (PDT)
In-Reply-To: <20200526155928.32036-4-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 5/26/20 9:59 AM, Coly Li wrote:
> The problematic code piece in bcache_device_free() is,
> 
>  785 static void bcache_device_free(struct bcache_device *d)
>  786 {
>  787     struct gendisk *disk = d->disk;
>  [snipped]
>  799     if (disk) {
>  800             if (disk->flags & GENHD_FL_UP)
>  801                     del_gendisk(disk);
>  802
>  803             if (disk->queue)
>  804                     blk_cleanup_queue(disk->queue);
>  805
>  806             ida_simple_remove(&bcache_device_idx,
>  807                               first_minor_to_idx(disk->first_minor));
>  808             put_disk(disk);
>  809         }
>  [snipped]
>  816 }
> 
> At line 808, put_disk(disk) may encounter kobject refcount of 'disk'
> being underflow.
> 
> Here is how to reproduce the issue,
> - Attche the backing device to a cache device and do random write to
>   make the cache being dirty.
> - Stop the bcache device while the cache device has dirty data of the
>   backing device.
> - Only register the backing device back, NOT register cache device.
> - The bcache device node /dev/bcache0 won't show up, because backing
>   device waits for the cache device shows up for the missing dirty
>   data.
> - Now echo 1 into /sys/fs/bcache/pendings_cleanup, to stop the pending
>   backing device.
> - After the pending backing device stopped, use 'dmesg' to check kernel
>   message, a use-after-free warning from KASA reported the refcount of
>   kobject linked to the 'disk' is underflow.
> 
> The dropping refcount at line 808 in the above code piece is added by
> add_disk(d->disk) in bch_cached_dev_run(). But in the above condition
> the cache device is not registered, bch_cached_dev_run() has no chance
> to be called and the refcount is not added. The put_disk() for a non-
> added refcount of gendisk kobject triggers a underflow warning.
> 
> This patch checks whether GENHD_FL_UP is set in disk->flags, if it is
> not set then the bcache device was not added, don't call put_disk()
> and the the underflow issue can be avoided.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 467149f3bcc5..c68d42730ca0 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -797,15 +797,20 @@ static void bcache_device_free(struct bcache_device *d)
>  		bcache_device_detach(d);
>  
>  	if (disk) {
> -		if (disk->flags & GENHD_FL_UP)
> +		bool disk_added = false;
> +
> +		if (disk->flags & GENHD_FL_UP) {
> +			disk_added = true;
>  			del_gendisk(disk);
> +		}

This would be cleaner as:

	bool disk_added = (disk->flags & GENHD_FL_UP) != 0;

	if (disk_added)
		del_gendisk(disk);

and so on.

-- 
Jens Axboe
