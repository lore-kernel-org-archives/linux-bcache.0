From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 15:07:20 +0200
Message-ID: <20161028130720.GA31703@suse.com>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161026223158.GA9283@suse.com>
 <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:57714 "EHLO
        jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757923AbcJ1NHZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 09:07:25 -0400
Content-Disposition: inline
In-Reply-To: <20161028115249.6myzx2ae24n2w4v7@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: James Pharaoh <james@pharaoh.uk>, linux-bcache@vger.kernel.org

On Fri, Oct 28, 2016 at 03:52:49AM -0800, Kent Overstreet wrote:
> On Thu, Oct 27, 2016 at 12:31:58AM +0200, Vojtech Pavlik wrote:
> > In case you're using mdraid for the RAID part on a reasonably recent
> > Linux kernel, there is no write hole. Linux mdraid implements barriers
> > properly even on RAID5, at the cost of performance - mdraid waits for a
> > barrier to complete on all drives before submitting more i/o.
> 
> That's not what the raid 5 hole is. The raid 5 hole comes from the fact that
> it's not possible to update the p/q blocks atomically with the data blocks, thus
> there is a point in time when they are _inconsistent_ with the rest of the
> stripe, and if used will lead to reconstructing incorrect data. There's no way
> to fix this with just flushes.

Indeed. However, together with the write intent bitmap, and filesystems
ensuring consistency through barriers, it's still greatly mitigated. 

Mdraid will mark areas of disk dirty in the write intent bitmap before
writing to them. When the system comes up after a power outage, all
areas marked dirty are scanned and the xor block written where it
doesn't match the rest.

Thanks to the strict ordering using barriers, the damage to the
consistency of the RAID can only be in request since the last
successfully written barrier.

As such, the filesystem will always see a consistent state, and the raid
will also always recover to a consistent state.

The only situation where data damage can happen is a power outage that
comes together with a loss of one of the drives. In such a case, the
content of any blocks written past the last barrier is undefined. It
then depends on the filesystem whether it can revert to the last sane
state. Not sure about others, but btrfs will do so.

-- 
Vojtech Pavlik
Director SuSE Labs
