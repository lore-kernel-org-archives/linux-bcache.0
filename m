From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PULL] bcache: multiple updates
Date: Mon, 31 Oct 2016 19:35:58 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1610311934310.4080@mail.ewheeler.net>
References: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net> <5160da7c-e38e-1527-2b09-2ca240df57c3@kernel.dk> <alpine.LRH.2.11.1610291826250.4080@mail.ewheeler.net> <20161030140050.q6ywphi3by6yoczc@kmo-pixel>
 <6bda49c5-5ed8-939f-aab3-faa9c8127ff0@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:54490 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965234AbcKACgA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 31 Oct 2016 22:36:00 -0400
In-Reply-To: <6bda49c5-5ed8-939f-aab3-faa9c8127ff0@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, dave@stgolabs.net, linux-kernel@vger.kernel.org, Kai Krakow <kai@kaishome.de>, Wido den Hollander <wido@widodh.nl>

On Sun, 30 Oct 2016, Jens Axboe wrote:
> On 10/30/2016 08:00 AM, Kent Overstreet wrote:
> > On Sat, Oct 29, 2016 at 06:32:38PM -0700, Eric Wheeler wrote:
> > > On Thu, 27 Oct 2016, Jens Axboe wrote:
> > >
> > > > On 10/27/2016 05:27 PM, Eric Wheeler wrote:
> > > > > Hi Jens,
> > > > >
> > > > > Please pull this v4.9-rc2 based series of bcache updates for v4.9-rc3:
> > > > > (You may disregard the previous -rc1-based request.)
> > > > >
> > > > >   git pull https://bitbucket.org/ewheelerinc/linux.git
> > > > >   v4.9-rc2-bcache-updates
> > > > >
> > > > > Thank you!
> > > > >
> > > > > --
> > > > > Eric Wheeler
> > > > >
> > > > > ]# git log --oneline v4.9-rc2..HEAD
> > > > > bd532a6 bcache: partition support: add 16 minors per bcacheN device
> > > > > 3312845 bcache: Make gc wakeup sane, remove set_task_state()
> > > > > 6bb7f1e bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
> > > > > 3d58a09 bcache: documentation for ioprio cache hinting
> > > > > 2e8884b bcache: introduce per-process ioprio-based bypass/writeback
> > > > > hints
> > > >
> > > > How many of these are applicable to 4.9-rc3? I took a quick look at
> > > > them, and some of them look like they should go into the 4.10 branch
> > > > instead. We're after the merge window, so only strict fixes. Cleanups
> > > > and no features, no go.
> > >
> > > 3312845 might need to be in 4.9.  Not sure, kent asked me to pick it up in
> > > my next pull request.  4.10 is fine for the rest.
> > >
> > > Kent, Davidlohr, does 3312845 need to land in 4.9 for some reason?
> >
> > No, that can wait until 4.10.
> 
> Great, that's what it looked like.
> 
> Eric, three things. The first is that you based this branch as if it was
> going into 4.9, which means if I pull it into my 4.10 branch, I get a
> ton of extra stuff that has been added to master since. Not a huge
> problem, I can just generate the patches and apply them.
> 
> Secondly, you are depending on REQ_THROTTLED, which in the 4.10 series,
> has been modified:
> 
> commit 8d2bbd4c8236e9e38e6b36ac9e2c54fdcfe5b335
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Thu Oct 20 15:12:12 2016 +0200
> 
>     block: replace REQ_THROTTLED with a bio flag
> 
> And lastly, would you mind using the regular git request-pull to
> generate your pull requests? It's what everybody else is using, and
> honestly I think it's a lot more readable than the oneline thing you are
> doing.
> 
> Please resend the series against for-4.10/block and we can get it
> applied, thanks.

Will do, thanks!

-Eric


--
Eric Wheeler


> 
> -- 
> Jens Axboe
> 
> 
> 
