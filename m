From: Marc MERLIN <marc@merlins.org>
Subject: Re: bcache: register_cache() error opening sdh2: cannot allocate memory => BUG NULL pointer
Date: Thu, 25 Feb 2016 16:18:16 -0800
Message-ID: <20160226001816.GD29543@merlins.org>
References: <20160225061821.GB15421@merlins.org> <alpine.LRH.2.11.1602250727120.3635@mail.ewheeler.net> <20160225164439.GA2290@merlins.org> <alpine.LRH.2.11.1602252325320.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47626 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbcBZASS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 19:18:18 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1602252325320.3635@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Thu, Feb 25, 2016 at 11:30:05PM +0000, Eric Wheeler wrote:
> On Thu, 25 Feb 2016, Marc MERLIN wrote:
> 
> > On Thu, Feb 25, 2016 at 07:29:36AM +0000, Eric Wheeler wrote:
> > > Try this patch.  It adds some error handling:
> > 
> > Thanks, applied. I'll report back if I get output from it.
> > 
> > I think one reason I'm having problem on that server is that I run
> > zoneminder which requires a lot of shared memory:
> > kernel.shmall = 234217728
> > kernel.shmmax = 234217728
> > 
> > Is there a chance that's putting memory pressure in the wrong memory
> > pool on the system?
> 
> Perhaps, though I'm thinking your shm values are far too large.  Those are 
> in units of pages, so with 4k pages you have set almost 900GB of shared 
> memory limit.  Does this machine have 1TB of ram?

Indeed, no.

> I like to set vm.min_free_kbytes = 262144 on my machines.  Its <1% on our 
> systems and we never have memory issues, even with high memory pressure 
> and zram for swap.

Very good catch. I'll fix that.
I use zoneminder which requires stupid amounts of shared memory, but not 1TB
:)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
