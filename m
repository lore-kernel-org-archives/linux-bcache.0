From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/19] bcache: introduce bcache sysfs entries for
 ioprio-based bypass/writeback hints
Date: Wed, 5 Jul 2017 11:47:19 -0700
Message-ID: <20170705184719.GA3234@infradead.org>
References: <20170629134510.GA32385@infradead.org>
 <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net>
 <1498855388-16990-7-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752200AbdGESrV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jul 2017 14:47:21 -0400
Content-Disposition: inline
In-Reply-To: <1498855388-16990-7-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: bcache@lists.ewheeler.net
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>, nix@esperi.org.uk

On Fri, Jun 30, 2017 at 01:42:56PM -0700, bcache@lists.ewheeler.net wrote:
> From: Eric Wheeler <git@linux.ewheeler.net>
> 
> Add sysfs entries to support to hint for bypass/writeback by the ioprio
> assigned to the bio.  If the bio is unassigned, use current's io-context
> ioprio for cache writeback or bypass (configured per-process with
> `ionice`).
> 
> Having idle IOs bypass the cache can increase performance elsewhere
> since you probably don't care about their performance.  In addition,
> this prevents idle IOs from promoting into (polluting) your cache and
> evicting blocks that are more important elsewhere.
> 
> If you really nead the performance at the expense of SSD wearout,
> then configure ioprio_writeback and set your `ionice` appropriately.
> 
> For example:
> 	echo 2,7 > /sys/block/bcache0/bcache/ioprio_bypass
> 	echo 2,0 > /sys/block/bcache0/bcache/ioprio_writeback
> 
> See the documentation commit for details.

I'm really worried about this interface, as it basically uses the
ioprio field for side channel communication - your app must know
which value it wants, and you need to configure bcache to fit
exacltly that scheme.

> +	/* If the ioprio already exists on the bio, use that.  We assume that
> +	 * the upper layer properly assigned the calling process's ioprio to
> +	 * the bio being passed to bcache. Otherwise, use current's ioc. */

Please make this fit the normal kernel comment style.

> +	ioprio = bio_prio(bio);
> +	if (!ioprio_valid(ioprio)) {
> +		ioc = get_task_io_context(current, GFP_NOIO, NUMA_NO_NODE);
> +		if (ioc) {
> +			if (ioprio_valid(ioc->ioprio))
> +				ioprio = ioc->ioprio;
> +			put_io_context(ioc);
> +			ioc = NULL;
> +		}
> +	}

While get_task_io_context currently is exported it really should not
be - we should only allocate on when setting the io priority or when
forking.

What this code really wants is the ioprio related lines of code from
blk_init_request_from_bio, which should be factored into a new helper.

> +	if (ioprio_valid(ioprio) && ioprio_valid(dc->ioprio_writeback)
> +		&& ioprio >= dc->ioprio_bypass) {
> +		return true;
> +	}

Incorrect indentation, this shold be:

	if (ioprio_valid(ioprio) && ioprio_valid(dc->ioprio_writeback) &&
	    ioprio >= dc->ioprio_bypass)
		return true;

And there is some more of this in this and the following patches.
Please run them through something like checkpatch.pl

> +
>  SHOW(__bch_cached_dev)
>  {
>  	struct cached_dev *dc = container_of(kobj, struct cached_dev,
> @@ -183,6 +186,17 @@ SHOW(__bch_cached_dev)
>  		return strlen(buf);
>  	}
>  
> +	if (attr == &sysfs_ioprio_bypass)
> +		return snprintf(buf, PAGE_SIZE-1, "%d,%ld\n",
> +			IOPRIO_PRIO_CLASS(dc->ioprio_bypass),
> +			IOPRIO_PRIO_DATA(dc->ioprio_bypass));
> +
> +	if (attr == &sysfs_ioprio_writeback)
> +		return snprintf(buf, PAGE_SIZE-1, "%d,%ld\n",
> +			IOPRIO_PRIO_CLASS(dc->ioprio_writeback),
> +			IOPRIO_PRIO_DATA(dc->ioprio_writeback));
> +
> +

Please implement separate sysfs show and store function for your new
attributes instead of overloading all of them into a giant mess.
