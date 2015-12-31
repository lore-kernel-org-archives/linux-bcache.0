From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PULL] Re: bcache stability patches
Date: Wed, 30 Dec 2015 20:18:31 -0900
Message-ID: <20151231051830.GB8265@kmo-pixel>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
 <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
 <56841B8B.6070306@kernel.dk>
 <20151231031500.GA8265@kmo-pixel>
 <5684A030.1040306@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36404 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbbLaFSf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 31 Dec 2015 00:18:35 -0500
Content-Disposition: inline
In-Reply-To: <5684A030.1040306@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Al Viro <viro@zeniv.linux.org.uk>, Denis Bychkov <manover@gmail.com>, g2p.code@gmail.com, Jiri Kosina <jkosina@suse.com>, Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, Takashi Iwai <tiwai@suse.de>, Vojtech Pavlik <vojtech@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>

On Wed, Dec 30, 2015 at 08:25:36PM -0700, Jens Axboe wrote:
> On 12/30/2015 08:15 PM, Kent Overstreet wrote:
> >On Wed, Dec 30, 2015 at 10:59:39AM -0700, Jens Axboe wrote:
> >>Looking over these, most are really simple one-liners, and nothing sticks
> >>out as being overly complicated. Kent, do you have any plans to maintain the
> >>in-kernel bcache?
> >
> >Yeah - these patches are all fine, go ahead and pull.
> 
> Great, thanks.
> 
> >I may start doing maintainence again at some point (but if there's someone
> >willing to step up and take over and do a good job of it, I'd gladly hand things
> >off)
> 
> As long as we have a path into mainline for stability fixes, at least that's
> better than before.

I'd really like to get the improvements from the bcache-dev branch upstream -
there's a lot of _huge_ improvements (performance and otherwise), but
backporting the non on disk format changes has turned out to be... not really
practical.

So one of the major obstacles has been that there's a ton of very worthwhile
code I'd really like to get upstream, but at this point it's pretty much going
to have to be as drivers/md/bcache2 - effectively a fork that wouldn't support
the original on disk format. And that's a high hurdle.

If the user community is willing to step up and help out (and realistically,
that'd have to include financial support) - that's probably what I'd like to see
happen. But it's a non trivial amount of work to get sufficient testing and to
get the new on disk format stabilized enough to go upstream.

> Thanks Eric for collecting these. I've reformatted some of them a bit, not
> sure if that's github crappery, or if they came like that. It's pushed out
> now.

Thanks Eric - and let me know if you'd be willing to take on more maintainence
work, I may have had some more patches in my backlog and we could talk about
testing.
