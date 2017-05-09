From: Eric Wheeler <bcache@linux.ewheeler.net>
Subject: Re: [PATCH 2/2] bcache: fix calling ida_simple_remove() with incorrect
 minor
Date: Tue, 9 May 2017 17:56:02 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1705091753150.19359@mail.ewheeler.net>
References: <1494311118-10260-1-git-send-email-tang.junhui@zte.com.cn> <dd09ff51-312e-8091-a6cb-5d2829163dc6@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1025355439-1494352564=:19359"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:53418 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752586AbdEISBY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 9 May 2017 14:01:24 -0400
In-Reply-To: <dd09ff51-312e-8091-a6cb-5d2829163dc6@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: tang.junhui@zte.com.cn, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, sam.yaple@servosity.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1025355439-1494352564=:19359
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 9 May 2017, Coly Li wrote:

> On 2017/5/9 下午2:25, tang.junhui@zte.com.cn wrote:
> > From: "tang.junhui" <tang.junhui@zte.com.cn>
> > 
> > bcache called ida_simple_remove() with minor which have multiplied by
> > BCACHE_MINORS, it would cause minor wrong release and leakage
> > 
> > Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> 
> Reviewed-by: Coly Li <colyli@suse.de>
> 
> Hi Eric:
> 
> You are the original author of bcache partition support, I also include
> you, would you like to push this patch upstream ?
> 
> Thanks.

Well, to be certain, this was the original motivation for the patch so Sam 
Yaple should get the credit: https://yaple.net/2016/03/31/bcache-partitions-and-dkms/

But, to answer your question: Yes, I'll put together a pull.  There are 
quite a few patches that need caught up on other points as well.

-Eric


--
Eric Wheeler


> 
> Coly
> 
> > ---
> >  drivers/md/bcache/super.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 867d9a9..5723914 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -57,8 +57,11 @@ static DEFINE_IDA(bcache_minor);
> >  static wait_queue_head_t unregister_wait;
> >  struct workqueue_struct *bcache_wq;
> >  
> > -#define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
> > -#define BCACHE_MINORS		16 /* partition support */
> > +#define BTREE_MAX_PAGES	                  (256 * 1024 / PAGE_SIZE)
> > +#define BCACHE_MINORS_BITS                4 /* bcache partition support */
> > +#define BCACHE_MINORS                     (1 << BCACHE_MINORS_BITS)
> > +#define BCACHE_TO_IDA_MINORS(first_minor) ((first_minor) >> BCACHE_MINORS_BITS)
> > +#define IDA_TO_BCACHE_MINORS(minor)       ((minor) << BCACHE_MINORS_BITS)
> >  
> >  /* Superblock */
> >  
> > @@ -734,7 +737,7 @@ static void bcache_device_free(struct bcache_device *d)
> >  	if (d->disk && d->disk->queue)
> >  		blk_cleanup_queue(d->disk->queue);
> >  	if (d->disk) {
> > -		ida_simple_remove(&bcache_minor, d->disk->first_minor);
> > +		ida_simple_remove(&bcache_minor, BCACHE_TO_IDA_MINORS(d->disk->first_minor));
> >  		put_disk(d->disk);
> >  	}
> >  
> > @@ -780,11 +783,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
> >  	if (!d->full_dirty_stripes)
> >  		return -ENOMEM;
> >  
> > -	minor = ida_simple_get(&bcache_minor, 0, MINORMASK + 1, GFP_KERNEL);
> > +	minor = ida_simple_get(&bcache_minor, 0, BCACHE_TO_IDA_MONIRS(MINORMASK) + 1, GFP_KERNEL);
> >  	if (minor < 0)
> >  		return minor;
> >  
> > -	minor *= BCACHE_MINORS;
> >  
> >  	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
> >  	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
> > @@ -793,10 +795,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
> >  	}
> >  
> >  	set_capacity(d->disk, sectors);
> > -	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor / BCACHE_MINORS);
> > +	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor);
> >  
> >  	d->disk->major		= bcache_major;
> > -	d->disk->first_minor	= minor;
> > +	d->disk->first_minor	= IDA_TO_BCACHE_MINORS(minor);
> >  	d->disk->fops		= &bcache_ops;
> >  	d->disk->private_data	= d;
> >  
> > 
> 
> 
> -- 
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-1025355439-1494352564=:19359--
