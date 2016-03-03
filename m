From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PULL] bcache fixes for v4.5-rc6
Date: Thu, 3 Mar 2016 02:09:46 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603021947130.3635@mail.ewheeler.net>
References: <alpine.LRH.2.11.1602292216450.3635@mail.ewheeler.net> <56D5B8E3.9050000@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:59695 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751624AbcCCCJx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 2 Mar 2016 21:09:53 -0500
In-Reply-To: <56D5B8E3.9050000@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Marc MERLIN <marc@merlins.org>, linux-bcache@vger.kernel.org, Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>

On Tue, 1 Mar 2016, Jens Axboe wrote:

> On 02/29/2016 06:08 PM, Eric Wheeler wrote:
> > Hi Jens,
> >
> > Can we still get these in for 4.5?  One is a race, the other is just error
> > handling.
> >
> > Please pull:
> >    git pull https://bitbucket.org/ewheelerinc/linux.git
> >    v4.5-rc6-bcache-fixes
> >
> > bcache: fix race of writeback thread starting before complete initialization
> > bcache: cleaned up error handling around register_cache()
> 
> They look simple enough, though I generally don't like collapsing things like
> this:
> 
> if ((ret = cache_alloc(sb, ca)) != 0)
> 
> it's easy to screw up, doing
> 
> ret = cache_alloc(sb, ca);
> if (ret != 0)
>     ...

Done.  Rebased, fixed, and push --force'ed.  

BTW, Is there a better (preferred) way vs. push --force?  Some say push 
--force can break things.

> 
> is a lot more readable and harder to screw up. Can we get that cleaned up? We
> can still make 4.5, I've got a bunch pending that's going out today, and these
> two would have missed the boat for today anyway. But that doesn't mean we
> can't get them out later this week.

Thanks!

-Eric

> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
