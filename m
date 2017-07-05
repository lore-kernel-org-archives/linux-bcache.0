From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 07/19] bcache: introduce bcache sysfs entries for
 ioprio-based bypass/writeback hints
Date: Wed, 5 Jul 2017 21:49:36 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707052143470.17052@mail.ewheeler.net>
References: <20170629134510.GA32385@infradead.org> <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net> <1498855388-16990-7-git-send-email-bcache@lists.ewheeler.net> <20170705184719.GA3234@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170705184719.GA3234@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, axboe@kernel.dk, nix@esperi.org.uk
List-Id: linux-bcache@vger.kernel.org

On Wed, 5 Jul 2017, Christoph Hellwig wrote:
> On Fri, Jun 30, 2017 at 01:42:56PM -0700, bcache@lists.ewheeler.net wrote:
> > From: Eric Wheeler <git@linux.ewheeler.net>
> > 
> > Add sysfs entries to support to hint for bypass/writeback by the ioprio
> > assigned to the bio.  If the bio is unassigned, use current's io-context
> > ioprio for cache writeback or bypass (configured per-process with
> > `ionice`).
> > 
> > Having idle IOs bypass the cache can increase performance elsewhere
> > since you probably don't care about their performance.  In addition,
> > this prevents idle IOs from promoting into (polluting) your cache and
> > evicting blocks that are more important elsewhere.
> > 
> > If you really nead the performance at the expense of SSD wearout,
> > then configure ioprio_writeback and set your `ionice` appropriately.
> > 
> > For example:
> > 	echo 2,7 > /sys/block/bcache0/bcache/ioprio_bypass
> > 	echo 2,0 > /sys/block/bcache0/bcache/ioprio_writeback
> > 
> > See the documentation commit for details.
> 
> I'm really worried about this interface, as it basically uses the
> ioprio field for side channel communication - your app must know
> which value it wants, and you need to configure bcache to fit
> exacltly that scheme.
>
> 
> > +	/* If the ioprio already exists on the bio, use that.  We assume that
> > +	 * the upper layer properly assigned the calling process's ioprio to
> > +	 * the bio being passed to bcache. Otherwise, use current's ioc. */
> 
> Please make this fit the normal kernel comment style.

ok
 
> > +	ioprio = bio_prio(bio);
> > +	if (!ioprio_valid(ioprio)) {
> > +		ioc = get_task_io_context(current, GFP_NOIO, NUMA_NO_NODE);
> > +		if (ioc) {
> > +			if (ioprio_valid(ioc->ioprio))
> > +				ioprio = ioc->ioprio;
> > +			put_io_context(ioc);
> > +			ioc = NULL;
> > +		}
> > +	}
> 
> While get_task_io_context currently is exported it really should not
> be - we should only allocate on when setting the io priority or when
> forking.
> 
> What this code really wants is the ioprio related lines of code from
> blk_init_request_from_bio, which should be factored into a new helper.
> 
> > +	if (ioprio_valid(ioprio) && ioprio_valid(dc->ioprio_writeback)
> > +		&& ioprio >= dc->ioprio_bypass) {
> > +		return true;
> > +	}
> 
> Incorrect indentation, this shold be:
> 
> 	if (ioprio_valid(ioprio) && ioprio_valid(dc->ioprio_writeback) &&
> 	    ioprio >= dc->ioprio_bypass)
> 		return true;
> 
> And there is some more of this in this and the following patches.
> Please run them through something like checkpatch.pl

Good idea, will do.

> 
> > +
> >  SHOW(__bch_cached_dev)
> >  {
> >  	struct cached_dev *dc = container_of(kobj, struct cached_dev,
> > @@ -183,6 +186,17 @@ SHOW(__bch_cached_dev)
> >  		return strlen(buf);
> >  	}
> >  
> > +	if (attr == &sysfs_ioprio_bypass)
> > +		return snprintf(buf, PAGE_SIZE-1, "%d,%ld\n",
> > +			IOPRIO_PRIO_CLASS(dc->ioprio_bypass),
> > +			IOPRIO_PRIO_DATA(dc->ioprio_bypass));
> > +
> > +	if (attr == &sysfs_ioprio_writeback)
> > +		return snprintf(buf, PAGE_SIZE-1, "%d,%ld\n",
> > +			IOPRIO_PRIO_CLASS(dc->ioprio_writeback),
> > +			IOPRIO_PRIO_DATA(dc->ioprio_writeback));
> > +
> > +
> 
> Please implement separate sysfs show and store function for your new
> attributes instead of overloading all of them into a giant mess.

ok.

>>

Christoph, thank you for your commentary and quick turn around on all of 
these patches!

--
Eric Wheeler




> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
