From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Thu, 27 Oct 2016 00:31:58 +0200
Message-ID: <20161026223158.GA9283@suse.com>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:40965 "EHLO
        jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934991AbcJZWxU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 26 Oct 2016 18:53:20 -0400
Content-Disposition: inline
In-Reply-To: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: James Pharaoh <james@pharaoh.uk>
Cc: linux-bcache@vger.kernel.org

On Wed, Oct 26, 2016 at 04:20:38PM +0100, James Pharaoh wrote:
> Hi all,
> 
> I'm creating an elaborate storage system and using bcache, with
> great success, to combine SSDs with smallish (500GB) network mounted
> block devices, with RAID5 in between.
> 
> I believe this should allow me to use RAID5 at large scale without
> high risk of data loss, because I can very quickly rebuild the small
> number of devices efficiently, across a distributed system.
> 
> I am using separate filesystems on each and abstracting their
> combination at a higher level, and I have redundant copies of their
> data in different locations (different countries in fact), so even
> if I lose one it can be recreated efficiently.
> 
> I believe this addresses the issue of two devices failing
> simultaneously, because it would affect an even smaller proportion
> of the total data than a single failure, which would simply trigger
> a number of RAID5 rebuilds.
> 
> I have high faith in SSD storage, especially given drives' SMART
> capabilities to report failure well in advance of it happening, so
> it occurs to me that bcache is going to close the RAID5 write hole
> for me, assuming certain things.

I believe your faith in SSDs is somewhat misplaced, they do not so
infrequently die ahead of their SMART announcement and if they do, they
don't just get bad sectors, the whole device is gone.

In case you want to protect your data, either use a RAID for your cache
devices, too, use it in write through mode, or in write-back mode with
zero dirty data target.

> I am making assumptions about the ordering of writes that RAID5
> makes, and will post to the appropriate list about that, with the
> possibility of another option. However, I also note that bcache
> "optimises" sequential writes directly to the underlying device:

In case you're using mdraid for the RAID part on a reasonably recent
Linux kernel, there is no write hole. Linux mdraid implements barriers
properly even on RAID5, at the cost of performance - mdraid waits for a
barrier to complete on all drives before submitting more i/o.

Any journalling, log or cow filesystem that relies on i/o barriers for
consistency will be consistent in Linux even on mdraid RAID5.

> > Since random IO is what SSDs excel at, there generally won't be much
> > benefit to caching large sequential IO. Bcache detects sequential IO
> > and skips it; it also keeps a rolling average of the IO sizes per
> > task, and as long as the average is above the cutoff it will skip all
> > IO from that task - instead of caching the first 512k after every
> > seek. Backups and large file copies should thus entirely bypass the
> > cache.

> Since I want my bcache device to essentially be a "journal", and to
> close the RAID5 write hole, I would prefer to disable this
> behaviour.
> 
> I propose, therefore, a further write mode, in which data is always
> written to the cache first, and synced, before it is written to the
> underlying device. This could be called "journal" perhaps, or
> something similar.

Using bcache to accelerate a RAID using a SSD is a fairly common use
case. What you're asking for can likely be achieved by:

	echo writeback	> cache_mode
	echo 0     	> writeback_percent
	echo 10240  	> writeback_rate
	echo 5		> writeback_delay
	echo 0     	> readahead
	echo 0      	> sequential_cutoff
	echo 0      	> cache/congested_read_threshold_us
	echo 0      	> cache/congested_write_threshold_us

This is what I use personally on my system with success.

It enables writeback to optimize writing whole RAID stripes and sets a
writeback delay to make sure whole stripes are collected before writing them
out.

It sets a fixed writeback rate such that reads aren't significantly
delayed even during heavy writes - the dirty data will grow instead. 

It disables readahead, disallows skipping the cache for sequential writes
and disables cache device congestion control to make sure that writes always
go through the cache device.

As a result, if the cached device is busy with writes, only full stripes get
ever written to the raid. When the device is idle, even the remaining dirty
data gets written to the raid.

> I am optimistic that this would be a relatively small change to the
> code, since it only requires to always choose the cache to write
> data to first. Perhaps the sync behaviour is also more complex, I am
> not familiar with the internals.
> 
> So, does anyone have any idea if this is practical, if it would
> genuinely close the write hole, or any other thoughts?

It works without code changes, properly implements barriers throughout the
whole stack, doesn't get corrupted on pulling the cord if using a modern fs,
is fast and doesn't leave dirty data on the SSD unless the cord is pulled in
a busy period.

> I am prepared to write up what I am designing in detail and open
> source it, I believe it would be a useful method of managing this
> kind of high scale storage in general.

-- 
Vojtech Pavlik
Director SuSE Labs
