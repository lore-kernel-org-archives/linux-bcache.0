From: Marc MERLIN <marc@merlins.org>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Thu, 25 Feb 2016 18:46:33 -0800
Message-ID: <20160226024633.GF29543@merlins.org>
References: <20160224204530.GA13079@merlins.org> <alpine.LRH.2.11.1602250052530.2131@mail.ewheeler.net> <alpine.LRH.2.11.1602250612440.3635@mail.ewheeler.net> <alpine.LRH.2.11.1602250729570.3635@mail.ewheeler.net> <CAC8teKVFASYjf1U+Y3JHCXREC3WwfO=2GR+=-8kYcNh+ugsMxw@mail.gmail.com> <alpine.LRH.2.11.1602252330290.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48847 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbcBZCqf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 21:46:35 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1602252330290.3635@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org

On Fri, Feb 26, 2016 at 02:38:11AM +0000, Eric Wheeler wrote:
> Disclaimer: if you are comfortable forcing the writeback thread to proceed 
> instead of BUG, then try this patch.  It may cause other problems, or it 
> may not work at all.  If the cache is attached and corrupt, then its 
> backing dev could become corrupt during writeback if bcache still thinks 
> they are associated.

Thanks for the patch.

So, I could lose the data on the target filesystem, but it's 2TB and if it
gets mangled in a subtle way, that wouldn't be so great.
Btrfs is happier with data that never gets written since it's atomic, than
when garbage that shows up later.

Actually, I've now already mounted and used the backing device without the
cache, so it would be unsafe to bring up the cache and write it considering
the backing device is more ahead then the cache, correct?

Given that, I'm happy to run code that spits out diagostics, but probably
not something that will attempt to write an outdated cache on a filesytem
that's already ahead.
Or does bcache understand that the backing device is ahead already and the
cache should just be discarded?

Thanks,
Marc

> Here is how it works:
> 
> First, in super.c, I hold the writeback lock until initialization is 
> complete on the referenced cached_dev *dc and release it when it should be 
> safe to proceed; this should work because bch_writeback_thread downs 
> writeback_lock at the top of its loop.
> 
> Next, in writeback.c's read_dirty(), I jump to some additional error 
> handling instead of BUG_ON.  Except for debug output, it handles the early 
> exit in the the same way as the out of memory path.
> 
> If you feel that it is safe to run this code, then I would be interested 
> to know the result.  If it works, then I wonder which of the two patches 
> solved the problem.  If the problem is persistent, then you should get the 
> printk(KERN_WARNING) every time writeback runs.  OTOH, if it only printk's 
> a few times, then it is an initial startup issue (but the locking should 
> prevent that).
> 
> -Eric
> 
> 
> ====================================================================
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index a542b58..c0362a0 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1016,8 +1016,12 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
>  	 */
>  	atomic_set(&dc->count, 1);
>  
> -	if (bch_cached_dev_writeback_start(dc))
> +	/* Block writeback thread, but spawn it */
> +	down_write(&dc->writeback_lock);
> +	if (bch_cached_dev_writeback_start(dc)) {
> +		up_write(&dc->writeback_lock);
>  		return -ENOMEM;
> +	}
>  
>  	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
>  		bch_sectors_dirty_init(dc);
> @@ -1029,6 +1033,9 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
>  	bch_cached_dev_run(dc);
>  	bcache_device_link(&dc->disk, c, "bdev");
>  
> +	/* Allow the writeback thread to proceed */
> +	up_write(&dc->writeback_lock);
> +
>  	pr_info("Caching %s as %s on set %pU",
>  		bdevname(dc->bdev, buf), dc->disk.disk->disk_name,
>  		dc->disk.c->sb.set_uuid);
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index ca38362..0fe5de0 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -234,7 +234,8 @@ static void read_dirty(struct cached_dev *dc)
>  		if (!w)
>  			break;
>  
> -		BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
> +		if (ptr_stale(dc->disk.c, &w->key, 0))
> +			goto err_ptr_stale;
>  
>  		if (KEY_START(&w->key) != dc->last_read ||
>  		    jiffies_to_msecs(delay) > 50)
> @@ -273,7 +274,13 @@ static void read_dirty(struct cached_dev *dc)
>  	if (0) {
>  err_free:
>  		kfree(w->private);
> +
> +err_ptr_stale:
> +		printk(KERN_WARNING "ptr_stale(dc->disk.c, &w->key, 0) in read_dirty() with dc->disk.flags=%lx\n",
> +			dc->disk.flags);
> +		dump_stack();
>  err:
> +
>  		bch_keybuf_del(&dc->writeback_keys, w);
>  	}
>  
> ====================================================================
> 
> 
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
