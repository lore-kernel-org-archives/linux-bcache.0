From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PULL] bcache: multiple updates
Date: Sun, 30 Oct 2016 06:00:50 -0800
Message-ID: <20161030140050.q6ywphi3by6yoczc@kmo-pixel>
References: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net>
 <5160da7c-e38e-1527-2b09-2ca240df57c3@kernel.dk>
 <alpine.LRH.2.11.1610291826250.4080@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33739 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753055AbcJ3OAz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 30 Oct 2016 10:00:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1610291826250.4080@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org, dave@stgolabs.net, linux-kernel@vger.kernel.org, Kai Krakow <kai@kaishome.de>, Wido den Hollander <wido@widodh.nl>

On Sat, Oct 29, 2016 at 06:32:38PM -0700, Eric Wheeler wrote:
> On Thu, 27 Oct 2016, Jens Axboe wrote:
> 
> > On 10/27/2016 05:27 PM, Eric Wheeler wrote:
> > > Hi Jens,
> > >
> > > Please pull this v4.9-rc2 based series of bcache updates for v4.9-rc3:
> > > (You may disregard the previous -rc1-based request.)
> > >
> > >   git pull https://bitbucket.org/ewheelerinc/linux.git
> > >   v4.9-rc2-bcache-updates
> > >
> > > Thank you!
> > >
> > > --
> > > Eric Wheeler
> > >
> > > ]# git log --oneline v4.9-rc2..HEAD
> > > bd532a6 bcache: partition support: add 16 minors per bcacheN device
> > > 3312845 bcache: Make gc wakeup sane, remove set_task_state()
> > > 6bb7f1e bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
> > > 3d58a09 bcache: documentation for ioprio cache hinting
> > > 2e8884b bcache: introduce per-process ioprio-based bypass/writeback hints
> > 
> > How many of these are applicable to 4.9-rc3? I took a quick look at
> > them, and some of them look like they should go into the 4.10 branch
> > instead. We're after the merge window, so only strict fixes. Cleanups
> > and no features, no go.
> 
> 3312845 might need to be in 4.9.  Not sure, kent asked me to pick it up in 
> my next pull request.  4.10 is fine for the rest.
> 
> Kent, Davidlohr, does 3312845 need to land in 4.9 for some reason?

No, that can wait until 4.10.
