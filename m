From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] [PATCH v2] bcache: fix calling ida_simple_remove() with
 incorrect minor
Date: Fri, 27 Oct 2017 19:17:52 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1710271914140.24585@mail.ewheeler.net>
References: <OFF5D425D9.E63AA2AA-ON48258155.00224AFB-48258155.002299BE@zte.com.cn> <alpine.LRH.2.11.1707130355040.9683@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-2085676223-1509131872=:24585"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:53552 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751610AbdJ0TRx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 15:17:53 -0400
In-Reply-To: <alpine.LRH.2.11.1707130355040.9683@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Tang Junhui <tang.junhui@zte.com.cn>
Cc: Michael Lyle <mlyle@lyle.org>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-2085676223-1509131872=:24585
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 13 Jul 2017, Eric Wheeler wrote:

> Tang,
> 
> Please resend.  This patch seems to be malformed.

Hi Tang,

This is an important bugfix since v4.10, can you get a clean patch sent to 
the list?

Michael, if Tang can get this in on time, can this squeeze this into v4.14 
before the rc's run out?


--
Eric Wheeler



> 
> --
> Eric Wheeler
> 
> On Thu, 6 Jul 2017, tang.junhui@zte.com.cn wrote:
> 
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> > 
> > bcache called ida_simple_remove() with minor which have multiplied by
> > BCACHE_MINORS, it would cause minor wrong release and leakage.
> > 
> > In addition, when adding partition support to bcache, the name assignment
> > was not updated, resulting in numbers jumping (bcache0, bcache16,
> > bcache32...). This has been fixed implicitly by the rework.
> > 
> > Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> > Reviewed-by: Coly Li <colyli@suse.de>
> > Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
> > Cc: stable@vger.kernel.org # 4.10
> > Cc: Stefan Bader <stefan.bader@canonical.com>
> > Fixes: b8c0d91 (bcache: partition support: add 16 minors per bcacheN device)
> > BugLink: https://bugs.launchpad.net/bugs/1667078
> > ---
> >  drivers/md/bcache/bcache.h | 12 ++++++++++++
> >  drivers/md/bcache/super.c  | 10 ++++------
> >  2 files changed, 16 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index c3ea03c..54f9075 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -212,6 +212,10 @@ BITMASK(GC_MARK,         struct bucket, gc_mark, 0, 2);
> >  #define MAX_GC_SECTORS_USED        (~(~0ULL << GC_SECTORS_USED_SIZE))
> >  BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, GC_SECTORS_USED_SIZE);
> >  BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);
> > +#define BCACHE_MINORS_BITS                4 /* bcache partition support */
> > +#define BCACHE_MINORS                     (1 << BCACHE_MINORS_BITS)
> > +#define BCACHE_MINOR_TO_IDA                                0
> > +#define IDA_MINOR_TO_BCACHE                                1
> >  
> >  #include "journal.h"
> >  #include "stats.h"
> > @@ -751,6 +755,14 @@ static inline bool ptr_available(struct cache_set *c, const struct bkey *k,
> >          return (PTR_DEV(k, i) < MAX_CACHES_PER_SET) && PTR_CACHE(c, k, i);
> >  }
> >  
> > +static inline int convert_minor(int minor, int style)
> > +{
> > +        if(style == BCACHE_MINOR_TO_IDA)
> > +                return (minor) >> BCACHE_MINORS_BITS;
> > +        else
> > +                return  (minor) << BCACHE_MINORS_BITS;
> > +}
> > +
> >  /* Btree key macros */
> >  
> >  /*
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 3a19cbc..6485afe 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -57,8 +57,7 @@ static DEFINE_IDA(bcache_minor);
> >  static wait_queue_head_t unregister_wait;
> >  struct workqueue_struct *bcache_wq;
> >  
> > -#define BTREE_MAX_PAGES                (256 * 1024 / PAGE_SIZE)
> > -#define BCACHE_MINORS                16 /* partition support */
> > +#define BTREE_MAX_PAGES                          (256 * 1024 / PAGE_SIZE)
> >  
> >  /* Superblock */
> >  
> > @@ -734,7 +733,7 @@ static void bcache_device_free(struct bcache_device *d)
> >          if (d->disk && d->disk->queue)
> >                  blk_cleanup_queue(d->disk->queue);
> >          if (d->disk) {
> > -                ida_simple_remove(&bcache_minor, d->disk->first_minor);
> > +                ida_simple_remove(&bcache_minor, convert_minor(d->disk->first_minor, BCACHE_MINOR_TO_IDA));
> >                  put_disk(d->disk);
> >          }
> >  
> > @@ -780,11 +779,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
> >          if (!d->full_dirty_stripes)
> >                  return -ENOMEM;
> >  
> > -        minor = ida_simple_get(&bcache_minor, 0, MINORMASK + 1, GFP_KERNEL);
> > +        minor = ida_simple_get(&bcache_minor, 0, convert_minor(MINORMASK, BCACHE_MINOR_TO_IDA) + 1, GFP_KERNEL);
> >          if (minor < 0)
> >                  return minor;
> >  
> > -        minor *= BCACHE_MINORS;
> >  
> >          if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
> >              !(d->disk = alloc_disk(BCACHE_MINORS))) {
> > @@ -796,7 +794,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
> >          snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", minor);
> >  
> >          d->disk->major                = bcache_major;
> > -        d->disk->first_minor        = minor;
> > +        d->disk->first_minor        = convert_minor(minor, IDA_MINOR_TO_BCACHE);
> >          d->disk->fops                = &bcache_ops;
> >          d->disk->private_data        = d;
> >  
> > --
> > 2.8.1.windows.1
> > 
--1641074820-2085676223-1509131872=:24585--
