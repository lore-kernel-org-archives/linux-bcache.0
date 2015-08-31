From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Mon, 31 Aug 2015 08:53:54 -0800
Message-ID: <20150831165354.GB27538@kmo-pixel>
References: <20150830085442.GA31722@suse.com>
 <20150831163937.00ca3f7a@harpe.intellique.com>
 <20150831144949.GA3276@suse.com>
 <20150831150429.GA27538@kmo-pixel>
 <20150831164531.GA9810@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33986 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbHaQx6 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 31 Aug 2015 12:53:58 -0400
Received: by pabzx8 with SMTP id zx8so144959887pab.1
        for <linux-bcache@vger.kernel.org>; Mon, 31 Aug 2015 09:53:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150831164531.GA9810@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, kmo@daterainc.com, linux-bcache@vger.kernel.org

On Mon, Aug 31, 2015 at 06:45:31PM +0200, Vojtech Pavlik wrote:
> On Mon, Aug 31, 2015 at 07:04:29AM -0800, Kent Overstreet wrote:
> 
> > I suspect there's two different bugs here.
> > 
> >  - I'm starting to suspect there's a bug in the dirty data accounting, and it's
> >    getting out of sync - i.e. reading 2.8 GB or whatever when it's actually 0.
> >    that would explain it spinning when there actually isn't any work for it to
> >    do.
> 
> That may be the case, but doesn't quite match my observation. Using this
> command line:
> 
> 	echo 2 > writeback_percent; echo 0 > writeback_percent; echo 100000 > writeback_rate; echo none > cache_mode; while true; do if top -b -n 1 | grep 'R.*bcache_write'; then date; echo looping; echo writeback > cache_mode; echo 40 > writeback_percent; sleep 1; echo 2 > writeback_percent; echo 0 > writeback_percent; echo 100000 > writeback_rate; echo none > cache_mode; echo fixed; cat /sys/block/bcache0/bcache/dirty_data; fi; done
> 
> I managed to get down to about 200 MB od dirty data reported. If the
> reporting was off by a fixed offset, I wouldn't be getting the 100% CPU
> and running bcache_writeback at 5GB of dirty data already.
> 
> At least unless the accounting of dirty data is very wrong and
> fluctuating.

Huh, that's good to know then.

> >  - with a large enough amount of data, the 30 second writeback_delay may be
> >    insufficient; if it takes longer than that just to scan the entire keyspace
> >    it'll never get a chance to sleep. try bumping writeback_delay up and see if
> >    that helps.
> 
> That shouldn't be the case when the amount of dirty data is below a
> gigabyte, or is it?

No - it has to scan the entire btree, cached _and_ dirty data - so the scanning
gets expensive when you have lots of clean cached data and very little dirty
data, so it's supposed to ratelimit to no more than one scan every 30 seconds
(IIRC; that algorithm has gone through a couple different iterations). But if
it's taking more than 30 seconds to complete one scan... well, you see the
problem?
