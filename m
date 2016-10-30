From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PULL] bcache: multiple updates
Date: Sat, 29 Oct 2016 18:32:38 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1610291826250.4080@mail.ewheeler.net>
References: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net> <5160da7c-e38e-1527-2b09-2ca240df57c3@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:56420 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753438AbcJ3Bcm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 29 Oct 2016 21:32:42 -0400
In-Reply-To: <5160da7c-e38e-1527-2b09-2ca240df57c3@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, dave@stgolabs.net, linux-kernel@vger.kernel.org, Kai Krakow <kai@kaishome.de>, Wido den Hollander <wido@widodh.nl>

On Thu, 27 Oct 2016, Jens Axboe wrote:

> On 10/27/2016 05:27 PM, Eric Wheeler wrote:
> > Hi Jens,
> >
> > Please pull this v4.9-rc2 based series of bcache updates for v4.9-rc3:
> > (You may disregard the previous -rc1-based request.)
> >
> >   git pull https://bitbucket.org/ewheelerinc/linux.git
> >   v4.9-rc2-bcache-updates
> >
> > Thank you!
> >
> > --
> > Eric Wheeler
> >
> > ]# git log --oneline v4.9-rc2..HEAD
> > bd532a6 bcache: partition support: add 16 minors per bcacheN device
> > 3312845 bcache: Make gc wakeup sane, remove set_task_state()
> > 6bb7f1e bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
> > 3d58a09 bcache: documentation for ioprio cache hinting
> > 2e8884b bcache: introduce per-process ioprio-based bypass/writeback hints
> 
> How many of these are applicable to 4.9-rc3? I took a quick look at
> them, and some of them look like they should go into the 4.10 branch
> instead. We're after the merge window, so only strict fixes. Cleanups
> and no features, no go.

3312845 might need to be in 4.9.  Not sure, kent asked me to pick it up in 
my next pull request.  4.10 is fine for the rest.

Kent, Davidlohr, does 3312845 need to land in 4.9 for some reason?

See this thread: 
	Re: ciao set_task_state() (was Re: [PATCH -v4 6/8] locking/mutex: Restructure wait loop)
	http://www.gossamer-threads.com/lists/linux/kernel/2550193	


--
Eric Wheeler



> 
> -- 
> Jens Axboe
> 
> 
> 
