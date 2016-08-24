From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: How to create bcachefs?
Date: Wed, 24 Aug 2016 15:52:06 -0800
Message-ID: <20160824235206.tq75ghe5n5gjciqm@kmo-pixel>
References: <e6d5ceae4a7dd53daf2667e25b76539b@mejor.pl>
 <20160824065212.fzs2nk3rg7z7iudb@kmo-pixel>
 <f92c1177-565d-47a1-b3ad-1876774003d4@mejor.pl>
 <alpine.LRH.2.11.1608241611270.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34537 "EHLO
        mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933380AbcHYI2P (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 04:28:15 -0400
Received: by mail-pa0-f43.google.com with SMTP id fi15so14981204pac.1
        for <linux-bcache@vger.kernel.org>; Thu, 25 Aug 2016 01:28:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1608241611270.10662@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: marcin@mejor.pl, linux-bcache@vger.kernel.org

On Wed, Aug 24, 2016 at 04:12:22PM -0700, Eric Wheeler wrote:
> On Wed, 24 Aug 2016, marcin@mejor.pl wrote:
> 
> > W dniu 24.08.2016 o 08:52, Kent Overstreet pisze:
> > [...]
> > 
> > Hi!
> > > Hey, sorry for the long delay, been sick past several days.
> > 
> > I was afraid that I'm asking to easy question:) And I hope everything is
> > fine with you now!
> > 
> > 
> > > The way arguments
> > > were passed to bcache format was a holdover from old style make-bcache, and
> > > didn't make much sense for bcachefs - -C was used for all devices, and
> > > --tier
> > > specifies fast devices and slow devices.
> > > 
> > > I finally got around to redoing the option parsing so we don't need the -C
> > > argument today - update your bcache tools, and the command you want is now:
> > > 
> > > bcache format --tier 0 /dev/sde1 --tier 1 /dev/sdd1
> 
> Neat!  How many performance tiers are (will be) supported?  Arbitrary?

Currently the code just handles two, but the on disk format allows for up to 16.
