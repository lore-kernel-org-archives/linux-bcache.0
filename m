From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 10/19] bcache: initialize stripe_sectors_dirty correctly
 for thin flash device
Date: Thu, 13 Jul 2017 04:10:17 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707130409430.9683@mail.ewheeler.net>
References: <20170629134510.GA32385@infradead.org> <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net> <1498855388-16990-10-git-send-email-bcache@lists.ewheeler.net> <46e7b8b2-7fac-6404-a6fc-696bfb1e0c61@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-235833014-1499919017=:9683"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:49634 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751133AbdGMEKS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jul 2017 00:10:18 -0400
In-Reply-To: <46e7b8b2-7fac-6404-a6fc-696bfb1e0c61@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Tang Junhui <tang.junhui@zte.com.cn>
Cc: Coly Li <i@coly.li>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-235833014-1499919017=:9683
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 2 Jul 2017, Coly Li wrote:

> On 2017/7/1 上午4:42, bcache@lists.ewheeler.net wrote:
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> > 
> > Thin flash device does not initialize stripe_sectors_dirty correctly, this
> > patch fixes this issue.
> 
> Hi Junhui,
> 
> Could you please explain why stripe_sectors_ditry is not correctly
> initialized and how about its negative result ?

Hi Tang,
   
I'm waiting to queue this patch pending your response to Coly.  Can you   
update the message send a v2?

--
Eric Wheeler



> 
> Thanks.
> 
> Coly
> 
> > 
> > Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/md/bcache/super.c     | 3 ++-
> >  drivers/md/bcache/writeback.c | 8 ++++----
> >  drivers/md/bcache/writeback.h | 2 +-
> >  3 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 1f84791..e06641e 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -1030,7 +1030,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
> >  	}
> >  
> >  	if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
> > -		bch_sectors_dirty_init(dc);
> > +		bch_sectors_dirty_init(&dc->disk);
> >  		atomic_set(&dc->has_dirty, 1);
> >  		atomic_inc(&dc->count);
> >  		bch_writeback_queue(dc);
> > @@ -1232,6 +1232,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
> >  		goto err;
> >  
> >  	bcache_device_attach(d, c, u - c->uuids);
> > +	bch_sectors_dirty_init(d);
> >  	bch_flash_dev_request_init(d);
> >  	add_disk(d->disk);
> >  
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> > index 3d463f0..4ac8b13 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -482,17 +482,17 @@ static int sectors_dirty_init_fn(struct btree_op *_op, struct btree *b,
> >  	return MAP_CONTINUE;
> >  }
> >  
> > -void bch_sectors_dirty_init(struct cached_dev *dc)
> > +void bch_sectors_dirty_init(struct bcache_device *d)
> >  {
> >  	struct sectors_dirty_init op;
> >  
> >  	bch_btree_op_init(&op.op, -1);
> > -	op.inode = dc->disk.id;
> > +	op.inode = d->id;
> >  
> > -	bch_btree_map_keys(&op.op, dc->disk.c, &KEY(op.inode, 0, 0),
> > +	bch_btree_map_keys(&op.op, d->c, &KEY(op.inode, 0, 0),
> >  			   sectors_dirty_init_fn, 0);
> >  
> > -	dc->disk.sectors_dirty_last = bcache_dev_sectors_dirty(&dc->disk);
> > +	d->sectors_dirty_last = bcache_dev_sectors_dirty(d);
> >  }
> >  
> >  void bch_cached_dev_writeback_init(struct cached_dev *dc)
> > diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> > index ea2f92e..c2ab4b4 100644
> > --- a/drivers/md/bcache/writeback.h
> > +++ b/drivers/md/bcache/writeback.h
> > @@ -109,7 +109,7 @@ static inline void bch_writeback_add(struct cached_dev *dc)
> >  
> >  void bcache_dev_sectors_dirty_add(struct cache_set *, unsigned, uint64_t, int);
> >  
> > -void bch_sectors_dirty_init(struct cached_dev *dc);
> > +void bch_sectors_dirty_init(struct bcache_device *);
> >  void bch_cached_dev_writeback_init(struct cached_dev *);
> >  int bch_cached_dev_writeback_start(struct cached_dev *);
> 
> 
--1641074820-235833014-1499919017=:9683--
