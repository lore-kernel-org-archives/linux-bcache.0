From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH v2 1/2] bcache: introduce per-process ioprio-based
 bypass/writeback hints
Date: Wed, 19 Oct 2016 17:38:38 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1610191655470.24191@mail.ewheeler.net>
References: <S1751057AbcJKTQx/20161011191653Z+507@vger.kernel.org> <20161012122516.wgeffufqmdmsz3tg@kmo-pixel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:44233 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932509AbcJTAim (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Oct 2016 20:38:42 -0400
In-Reply-To: <20161012122516.wgeffufqmdmsz3tg@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, 12 Oct 2016, Kent Overstreet wrote:
> On Tue, Oct 11, 2016 at 12:04:52PM -0700, Eric Wheeler wrote:
> > Add support to bcache hinting functions and sysfs to hint by the ioprio of
> > 'current' for cache writeback or bypass (configured per-process with `ionice`).
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
> > 
> > Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
> > Tested-by: Kai Krakow <kai@kaishome.de>
> > ---
> >  drivers/md/bcache/bcache.h    |  3 ++
> >  drivers/md/bcache/request.c   | 14 +++++++++
> >  drivers/md/bcache/sysfs.c     | 71 
+++++++++++++++++++++++++++++++++++++++++++
> >  drivers/md/bcache/writeback.c |  8 +++++
> >  drivers/md/bcache/writeback.h | 14 +++++++++
> >  5 files changed, 110 insertions(+)
> > 
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index 6b420a5..bf945fa 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -367,6 +367,9 @@ struct cached_dev {
> >  	unsigned		writeback_rate_update_seconds;
> >  	unsigned		writeback_rate_d_term;
> >  	unsigned		writeback_rate_p_term_inverse;
> > +
> > +	unsigned short		ioprio_writeback;
> > +	unsigned short		ioprio_bypass;
> >  };
> >  
> >  enum alloc_reserve {
> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index 4b177fe..b6911df 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
> > @@ -375,6 +375,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
> >  	unsigned sectors, congested = bch_get_congested(c);
> >  	struct task_struct *task = current;
> >  	struct io *i;
> > +	struct io_context *ioc;
> >  
> >  	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
> >  	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
> > @@ -386,6 +387,19 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
> >  	     op_is_write(bio_op(bio))))
> >  		goto skip;
> >  
> > +	/* If process ioprio is lower-or-equal to dc->ioprio_bypass, then
> > +	 * hint for bypass. Note that a lower-priority IO class+value
> > +	 * has a greater numeric value. */
> > +	ioc = get_task_io_context(current, GFP_ATOMIC, NUMA_NO_NODE);
> 
> get_task_io_context(current) won't work correctly for buffered writes since
> those are issued from writeback work items, not the originating process. There
> is machinery for tracking, per page, the process that the write originated from,
> but I haven't looked into how that works.

Interesting.  Reads work which will help the most common 
backup-bypass-cache usecase; fewer people will use the writeback hint 
unless they really need it.  Walking the bio per page to glean ioprio 
might be a future commit, but for now direct-io works (KVM on LVM, etc).

In v3 (sending shortly) I've set it to use bio_prio(bio) first, falling 
back to current's ioprio if unassigned in the bio in case upper layers are 
smart enough to pass the process's ioprio to the bio correctly.  

> Also, GFP_ATOMIC is wrong here - we're in process context, you want GFP_NOIO.

Also fixed in v3
 
> Other than that, looks reasonable to me.

Yay!  I'm targeting 4.9 since gregkh annouced it as longterm kernel.

I'll send up a pull request unless you see something to fix in v3.

Commit 3/3 adds bi_opf hints too, hopefully they appear sane. 
Let me know what you think.

--
Eric Wheeler



	echo 3,0 > /sys/block/bcache0/bcache/ioprio_bypass 
	echo 1,0 > /sys/block/bcache0/bcache/ioprio_writeback 

	============ Low prio bypass ============
	[root@bcache-dev ~]# ionice -c3 dd bs=1M of=/dev/bcache0 if=/dev/zero oflag=direct count=200
	200+0 records in
	200+0 records out
	209715200 bytes (210 MB) copied, 1.93203 s, 109 MB/s

	[root@bcache-dev ~]# cat /sys/block/bcache0/bcache/dirty_data
	0  <<< nothing dirty
	
	# io rates ber disk:
	dsk/bcache0---dsk/ssd0----dsk/bdev-
	 read  writ: read  writ: read  writ
	   0    95M:   0  4096B:   0    95M
	   0   102M:   0  4608B:   0   102M



	============ High prio writeback ============
	[root@bcache-dev ~]# ionice -c1 dd bs=1M of=/dev/bcache0 if=/dev/zero oflag=direct count=200
	200+0 records in
	200+0 records out
	209715200 bytes (210 MB) copied, 3.36397 s, 62.3 MB/s

	[root@bcache-dev ~]# cat /sys/block/bcache0/bcache/dirty_data
	200M <<< all dirty

	# io rates ber disk - ignore my slow ssd performance, its not an ssd ;)
	dsk/bcache0---dsk/ssd0----dsk/bdev-
	 read  writ: read  writ: read  writ
	   0    37M:   0    50M:   0     0 
	   0    78M:   0   104M:   0     0 
	   0    79M:   0   106M:   0     0 
	 456k 6144k: 456k 8195k:   0     0 
