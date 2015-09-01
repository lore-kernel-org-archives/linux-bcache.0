From: Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: Bcache stuck at writeback of a key, consuming 100% CPU, not
 possible to detach
Date: Tue, 1 Sep 2015 15:34:52 +0200
Message-ID: <20150901133452.GA3804@suse.cz>
References: <20150830085442.GA31722@suse.com>
 <20150831163937.00ca3f7a@harpe.intellique.com>
 <20150831144949.GA3276@suse.com>
 <20150831150429.GA27538@kmo-pixel>
 <20150831164531.GA9810@suse.com>
 <20150831165354.GB27538@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbbIANey (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 1 Sep 2015 09:34:54 -0400
Content-Disposition: inline
In-Reply-To: <20150831165354.GB27538@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-bcache@vger.kernel.org

On Mon, Aug 31, 2015 at 08:53:54AM -0800, Kent Overstreet wrote:

> > >  - with a large enough amount of data, the 30 second writeback_delay may be
> > >    insufficient; if it takes longer than that just to scan the entire keyspace
> > >    it'll never get a chance to sleep. try bumping writeback_delay up and see if
> > >    that helps.
> > 
> > That shouldn't be the case when the amount of dirty data is below a
> > gigabyte, or is it?
> 
> No - it has to scan the entire btree, cached _and_ dirty data - so the scanning
> gets expensive when you have lots of clean cached data and very little dirty
> data, so it's supposed to ratelimit to no more than one scan every 30 seconds
> (IIRC; that algorithm has gone through a couple different iterations). But if
> it's taking more than 30 seconds to complete one scan... well, you see the
> problem?

I tested that and set 'writeback_delay' to 600. That should be 10
minutes. No change:

	 PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
	1721 root      20   0       0      0      0 R 100.0 0.000   1075:09 bcache_writeback

Vojtech
