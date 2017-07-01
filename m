From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 09/19] bcache: update bio->bi_opf bypass/writeback REQ_
 flag hints
Date: Sat, 1 Jul 2017 19:39:29 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707011930010.17052@mail.ewheeler.net>
References: <20170629134510.GA32385@infradead.org> <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net> <1498855388-16990-9-git-send-email-bcache@lists.ewheeler.net> <f9976cdb-dcff-ac98-9a18-2d06b2d4c475@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-87473125-1498937970=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:55730 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751376AbdGATjb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 Jul 2017 15:39:31 -0400
In-Reply-To: <f9976cdb-dcff-ac98-9a18-2d06b2d4c475@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-87473125-1498937970=:17052
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 2 Jul 2017, Coly Li wrote:

> On 2017/7/1 上午4:42, bcache@lists.ewheeler.net wrote:
> > From: Eric Wheeler <git@linux.ewheeler.net>
> > 
> > Bypass if:     bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND)
> > 
> > Writeback if:  op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)
> > 
> 
> Hi Eric,
> 
> Could you please explain a bit how the above policy is designed ? I'd
> like to understand it more.

Hi Coly,

It is pretty trivial, all of the processing code exists already.  This 
patch only adds to the existing functions for the constraints noted in the 
patch.

What happens is this: cached_dev_make_request() in request.c takes the IO 
decides where the IO should go by using these two functions to decide 
whether a bio should writeback or bypass:
	check_should_bypass()
and
	should_writeback()

In check_should_bypass(), `if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))`
means bypass the cache because the bio has been flagged as a readahead or 
background IO (no sense in polluting cache in either case).

Later, if the bio is a write, then cached_dev_write() checks 
should_writeback()

In bio->bi_opf & (REQ_META|REQ_PRIO), it means writeback to cache.  Some 
filesystems use REQ_META for metadata operations which are best to keep 
low-latency for high transactional performance.  REQ_PRIO is a CFQ hint 
that the priority of the IO has been raised, so writeback is faster here.  


--
Eric Wheeler



> 
> Thanks.
> 
> Coly
> 
> 
> > Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
> > ---
> >  drivers/md/bcache/request.c   | 3 +++
> >  drivers/md/bcache/writeback.h | 3 ++-
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index a95609f..4629b0c 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
> > @@ -386,6 +386,9 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
> >  	     op_is_write(bio_op(bio))))
> >  		goto skip;
> >  
> > +	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))
> > +		goto skip;
> > +
> >  	/* If the ioprio already exists on the bio, use that.  We assume that
> >  	 * the upper layer properly assigned the calling process's ioprio to
> >  	 * the bio being passed to bcache. Otherwise, use current's ioc. */
> > diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> > index cd82fe8..ea2f92e 100644
> > --- a/drivers/md/bcache/writeback.h
> > +++ b/drivers/md/bcache/writeback.h
> > @@ -81,7 +81,8 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
> >  		return true;
> >  	}
> >  
> > -	return op_is_sync(bio->bi_opf) || in_use <= CUTOFF_WRITEBACK;
> > +	return op_is_sync(bio->bi_opf) || bio->bi_opf & (REQ_META|REQ_PRIO)
> > +		|| in_use <= CUTOFF_WRITEBACK;
> >  }
> >  
> >  static inline void bch_writeback_queue(struct cached_dev *dc)
> > 
> 
--1641074820-87473125-1498937970=:17052--
