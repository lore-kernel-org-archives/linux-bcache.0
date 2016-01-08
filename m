From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PULL] Re: bcache stability patches
Date: Thu, 7 Jan 2016 18:02:51 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1601071755430.14336@mail.ewheeler.net>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com> <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net> <56841B8B.6070306@kernel.dk> <20151231031500.GA8265@kmo-pixel> <5684A030.1040306@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:54311 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753109AbcAHCCy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 7 Jan 2016 21:02:54 -0500
In-Reply-To: <5684A030.1040306@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Al Viro <viro@zeniv.linux.org.uk>, Denis Bychkov <manover@gmail.com>, g2p.code@gmail.com, Jiri Kosina <jkosina@suse.com>, Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, Takashi Iwai <tiwai@suse.de>, Vojtech Pavlik <vojtech@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>

On Wed, 30 Dec 2015, Jens Axboe wrote:

> On 12/30/2015 08:15 PM, Kent Overstreet wrote:
> > On Wed, Dec 30, 2015 at 10:59:39AM -0700, Jens Axboe wrote:
> > > Looking over these, most are really simple one-liners, and nothing sticks
> > > out as being overly complicated. Kent, do you have any plans to maintain
> > > the
> > > in-kernel bcache?
> >
> > Yeah - these patches are all fine, go ahead and pull.
> 
> Great, thanks.
> 
> > I may start doing maintainence again at some point (but if there's someone
> > willing to step up and take over and do a good job of it, I'd gladly hand
> > things
> > off)

We use this in production internally, so I'll keep collecting patches and 
may ask for pulls from time to time.  

> As long as we have a path into mainline for stability fixes, at least that's
> better than before.
> 
> Thanks Eric for collecting these. I've reformatted some of them a bit, not
> sure if that's github crappery, or if they came like that. It's pushed out
> now.

You're welcome.  It could be github crappery, however, these were 
copy-pasted and cleaned up in various ways such that they merge into 
3.17-rc1 and then merge forward into 4.1.15 which we build against---so 
who knows about formatting, whitspace, and other minor issues.  I'm just 
glad they are on their way to 4.5 with stable@ Cc's!

BTW, can someone suggest an alternate git host with less crappery?

-Eric

> 
> -- 
> Jens Axboe
> 
> 
> 
