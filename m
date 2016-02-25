From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache: register_cache() error opening sdh2: cannot allocate
 memory => BUG NULL pointer
Date: Thu, 25 Feb 2016 23:30:05 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602252325320.3635@mail.ewheeler.net>
References: <20160225061821.GB15421@merlins.org> <alpine.LRH.2.11.1602250727120.3635@mail.ewheeler.net> <20160225164439.GA2290@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:40442 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752482AbcBYXaM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 18:30:12 -0500
In-Reply-To: <20160225164439.GA2290@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Thu, 25 Feb 2016, Marc MERLIN wrote:

> On Thu, Feb 25, 2016 at 07:29:36AM +0000, Eric Wheeler wrote:
> > Try this patch.  It adds some error handling:
> 
> Thanks, applied. I'll report back if I get output from it.
> 
> I think one reason I'm having problem on that server is that I run
> zoneminder which requires a lot of shared memory:
> kernel.shmall = 234217728
> kernel.shmmax = 234217728
> 
> Is there a chance that's putting memory pressure in the wrong memory
> pool on the system?

Perhaps, though I'm thinking your shm values are far too large.  Those are 
in units of pages, so with 4k pages you have set almost 900GB of shared 
memory limit.  Does this machine have 1TB of ram?

I like to set vm.min_free_kbytes = 262144 on my machines.  Its <1% on our 
systems and we never have memory issues, even with high memory pressure 
and zram for swap.

-Eric



> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
