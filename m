From: Marc MERLIN <marc@merlins.org>
Subject: Re: 4.11: ida_remove called for id=16 which is not allocated.
Date: Fri, 19 May 2017 10:10:37 -0700
Message-ID: <20170519171037.iuqjqzz25nbzog36@merlins.org>
References: <20170514152522.u5kejltr3nz4ogmz@merlins.org>
 <alpine.LRH.2.11.1705181707030.19359@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49532 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753364AbdESRhm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 19 May 2017 13:37:42 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1705181707030.19359@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Thu, May 18, 2017 at 05:08:56PM +0000, Eric Wheeler wrote:
> On Sun, 14 May 2017, Marc MERLIN wrote:
> 
> > 
> > gargamel:/sys/block/bcache16/bcache# echo 1 > stop
> > 
> > bcache: bcache_device_free() bcache16 stopped
> > ------------[ cut here ]------------
> > WARNING: CPU: 7 PID: 11051 at lib/idr.c:383 ida_remove+0xe8/0x10b
> > ida_remove called for id=16 which is not allocated.
> 
> Hi Marc,
> 
> Try the patch below.  I'm preparing it for a pull request---its been 
> compile tested but not actually tested.  If you can confirm that this 
> fixes it I'll add your Tested-by: if you like.
 
Thanks for the patch.
I'll hve to try it, but it may take a little while, I'm in the middle of
recovering 2 of my multi terabyte arrays after multiple bugs due to a
new SAS card and apparently new issues in 4.11

Marc

> --
> Eric Wheeler
> 
> commit 7311ad5a130ba79050e6f803f7fdb4e2b3f259d6
> Author: tang.junhui <tang.junhui@zte.com.cn>
> Date:   Tue May 9 12:14:06 2017 -0700
> 
>     bcache: fix calling ida_simple_remove() with incorrect minor
>     
>     bcache called ida_simple_remove() with minor which have multiplied by
>     BCACHE_MINORS, it would cause minor wrong release and leakage.
>     
>     In addition, when adding partition support to bcache, the name assignment
>     was not updated, resulting in numbers jumping (bcache0, bcache16,
>     bcache32...). This has been fixed implicitly by the rework.
>     
>     Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
>     Reviewed-by: Coly Li <colyli@suse.de>
>     Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
>     Cc: stable@vger.kernel.org # 4.10
>     Cc: Stefan Bader <stefan.bader@canonical.com>
>     Fixes: b8c0d91 (bcache: partition support: add 16 minors per bcacheN device)
>     BugLink: https://bugs.launchpad.net/bugs/1667078
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 0f9242d..2b07933 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -58,7 +58,10 @@
>  struct workqueue_struct *bcache_wq;
>  
>  #define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
> -#define BCACHE_MINORS		16 /* partition support */
> +#define BCACHE_MINORS_BITS                4 /* bcache partition support */
> +#define BCACHE_MINORS                     (1 << BCACHE_MINORS_BITS)
> +#define BCACHE_TO_IDA_MINORS(first_minor) ((first_minor) >> BCACHE_MINORS_BITS)
> +#define IDA_TO_BCACHE_MINORS(minor)       ((minor) << BCACHE_MINORS_BITS)
>  
>  /* Superblock */
>  
> @@ -734,7 +737,8 @@ static void bcache_device_free(struct bcache_device *d)
>  	if (d->disk && d->disk->queue)
>  		blk_cleanup_queue(d->disk->queue);
>  	if (d->disk) {
> -		ida_simple_remove(&bcache_minor, d->disk->first_minor);
> +		ida_simple_remove(&bcache_minor,
> +			BCACHE_TO_IDA_MINORS(d->disk->first_minor));
>  		put_disk(d->disk);
>  	}
>  
> @@ -776,11 +780,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  	if (!d->full_dirty_stripes)
>  		return -ENOMEM;
>  
> -	minor = ida_simple_get(&bcache_minor, 0, MINORMASK + 1, GFP_KERNEL);
> +	minor = ida_simple_get(&bcache_minor, 0,
> +		BCACHE_TO_IDA_MINORS(MINORMASK) + 1, GFP_KERNEL);
>  	if (minor < 0)
>  		return minor;
>  
> -	minor *= BCACHE_MINORS;
>  
>  	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
>  	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
> @@ -792,7 +796,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
>  	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor);
>  
>  	d->disk->major		= bcache_major;
> -	d->disk->first_minor	= minor;
> +	d->disk->first_minor	= IDA_TO_BCACHE_MINORS(minor);
>  	d->disk->fops		= &bcache_ops;
>  	d->disk->private_data	= d;
>  
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
