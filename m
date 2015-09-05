From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Sat, 5 Sep 2015 13:29:55 +0200
Message-ID: <20150905112955.GA4078@suse.com>
References: <20150830085442.GA31722@suse.com>
 <20150905130658.Horde.bdSqYx_a293KuFa5vdTuajm@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:46716 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbbIEL35 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 5 Sep 2015 07:29:57 -0400
Content-Disposition: inline
In-Reply-To: <20150905130658.Horde.bdSqYx_a293KuFa5vdTuajm@www3.nde.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-bcache@vger.kernel.org

On Sat, Sep 05, 2015 at 01:06:57PM +0200, Jens-U. Mozdzen wrote:

> I've noticed similar oddities with our servers - not quite the same,
> but close enough so I won't open a new thread:
> 
> We're running kernel 3.18.8 on server machines delivering SAN and
> NAS resources. Back-end storage is a MD-RAID6 (7 WD Red 1TB 2,5"),
> cache is
> on MD-RAID1 (2 SSD TOSHIBA PX02SMF020 200GB). As we live migrated
> from 128GB SSDs to the Toshibas, the cache size is still at 128 GB.
> 
> On one of the servers, I noticed excessive I/O load reported by our
> monitoring tools. Having read this thread, I tried to get the amount
> of dirty data down (cache_mode set to "writeback", writeback_percent
> to 0, writeback_rate to 10000 and then monitoring
> writeback_rate_debug), but unlike with the other server, the amount
> of dirty data would not go below 186M. Unlike with the original
> report, bcache_writeback wasn't at 100% but varying in its CPU usage
> - but always on top of all other processes running. I/O wait was
> unusually high, compared to the amount of data written.

This matches my situation and behavior exactly. Including the fact that
the backing device is a md raid.

> I left the system rest over night, to find that the next day it
> would not go below 197M, so that "bad spot" had changed. The load on
> this server had increased - looking at the stats, it seemed like
> writeback was trying to write data all the time, but for whatever
> reason failing (which matched the lower limit of dirty data).
> 
> Fearing the worst, I set the cache mode to writearound to disable
> further caching (amount of dirty still wouldn't drop below its
> border value), stopped the clients for this server and rebooted.
> 
> Luckily, the server came up without a problem, and *I now could get
> the amount of dirty data down to zero*. I switched back to
> writeback, with writeback_percent to 0 and a fixed writeback_rate.
> 
> So in our case, it looks like something borked in bcache's run-time,
> rather than on-disk (read: SSD cache content).

My understanding of bcache internals is still limited: I only spent
three days gazing into the code and adding debugging. But this is what I
believe is happening:

Bcache tries to be clever and only write whole stripes to the RAID. That
is good as it avoids a R-M-W cycle in the RAID on the data.

However, the stripe optimization was added on top of the usual writeback
code and doesn't play very nicely with it, since it takes over the usage
of the last_scanned pointer, confusing the original code.

This means that bcache_writeback is able to write all complete stripes
back, but gets stuck at any random small dirty data bits.

Stuck and spinning, going to sleep only for zero-length times.

This also explains that write traffic on the device can complete some of
the small dirty bits to full stripes and eventually have them written
back.

I've sent an one-liner patch to the mailing list a few moments ago that
fixes the issue.

> PS: We're still facing random reboots (of unknown cause), which may
> correlate with bcache's "amount dirty" being near the limit set by
> writeback_percent. 

Being near that limit is what bcache tries to achieve. It can be below
or above, in both cases the PID regulator will just do its thing.

> I'm trying to work-around this these days by
> running with writeback_percent set to zero and using a
> writeback_rate that lets the cache clean up over the day... so far,
> so good, but it's too early to tell for sure. Since switching to the
> new SSDs, the reboot rate went down to about once a week and I've
> made this change only two days ago.

With the fix I posted, setting writeback_percent to zero finally works
again without the risk of writeback_thread spinning.

-- 
Vojtech Pavlik
Director SUSE Labs
