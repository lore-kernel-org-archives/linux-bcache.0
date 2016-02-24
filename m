From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache stability patches: Now mainlined!
Date: Wed, 24 Feb 2016 06:45:02 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602240626110.32077@mail.ewheeler.net>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com> <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net> <56841B8B.6070306@kernel.dk> <20151231031500.GA8265@kmo-pixel> <5684A030.1040306@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:36647 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750883AbcBXGpo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 01:45:44 -0500
In-Reply-To: <5684A030.1040306@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Denis Bychkov <manover@gmail.com>, g2p.code@gmail.com, Jiri Kosina <jkosina@suse.com>, Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, stefan.bader@canonical.com, Takashi Iwai <tiwai@suse.de>, Vojtech Pavlik <vojtech@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>

On Wed, 30 Dec 2015, Jens Axboe wrote:
> On 12/30/2015 08:15 PM, Kent Overstreet wrote:
> > Yeah - these patches are all fine, go ahead and pull.
> >
> > I may start doing maintainence again at some point (but if there's 
> > someone willing to step up and take over and do a good job of it, I'd 
> > gladly hand things off)
> 
> As long as we have a path into mainline for stability fixes, at least that's
> better than before.

I would like to thank everyone involved in getting these patches 
mainlined.  Bcache should now be stable on the following releases:

	mainline: 4.5-rc1 (and later)
	longterm: 4.1.18
	longterm: 3.18.27

Please test on your favorite branch and let us know how it goes.

For those working from another branch, please see:
	git log 2ef9ccbf~1..627ccd20

and cherry-pick with
	git cherry-pick 2ef9ccbf~1..627ccd20


Cheers,	


--
Eric Wheeler
Linux since 1996!  
