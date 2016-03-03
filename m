From: Marc MERLIN <marc@merlins.org>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Wed, 2 Mar 2016 20:25:58 -0800
Message-ID: <20160303042558.GP13143@merlins.org>
References: <alpine.LRH.2.11.1602250612440.3635@mail.ewheeler.net>
 <alpine.LRH.2.11.1602250729570.3635@mail.ewheeler.net>
 <CAC8teKVFASYjf1U+Y3JHCXREC3WwfO=2GR+=-8kYcNh+ugsMxw@mail.gmail.com>
 <alpine.LRH.2.11.1602252330290.3635@mail.ewheeler.net>
 <20160226024633.GF29543@merlins.org>
 <20160226031921.GG29543@merlins.org>
 <alpine.LRH.2.11.1602260422290.3635@mail.ewheeler.net>
 <20160226162705.GA18927@merlins.org>
 <alpine.LRH.2.11.1602262053130.3635@mail.ewheeler.net>
 <alpine.LRH.2.11.1603030415280.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38475 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbcCCE0F (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 2 Mar 2016 23:26:05 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1603030415280.3635@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org

On Thu, Mar 03, 2016 at 04:17:24AM +0000, Eric Wheeler wrote:
> On Fri, 26 Feb 2016, Eric Wheeler wrote:
> > On Fri, 26 Feb 2016, Marc MERLIN wrote:
> > 
> > > On Fri, Feb 26, 2016 at 04:55:02AM +0000, Eric Wheeler wrote:
> > > > According to Documentation/bcache.txt:
> > > > 	"" If you're booting up and your cache device is gone and never
> > > > 	coming back, you can force run the backing device:
> > > > 	  echo 1 > /sys/block/sdb/bcache/running
> > > > 	[...]
> > > > 	The backing device will still use that cache set if it shows up
> > > > 	in the future, but all the cached data will be invalidated.  ""
> > > > 
> > > > So it seems that you are safe.  (It would be interesting to know how it 
> > > > invalidates the cache.  Maybe bumps the Set UUID?  Not sure.)
> > >  
> > > Yeah, that was  my understanding too, but I wanted to make sure.
> > > Strangely (worringly so?) the cache was replayed at boot, and this time
> > > nothing crashed, or any traceback.
> > > Now I'm wondering if it pushed garbage onto my filesystem :-/
> > 
> > I'm not convinced that journal replay will writeback, especially because 
> > of the documentation stating that forcing a bdev into a running state 
> > invalidates its cache.  I think it just keeps the datastructures in good 
> > shape on the cachedev, even though the cachedev was invalidated by forcing 
> > a 'running' state.
>  
> Hi Marc,
> 
> Thank you for your help investigating.  The two patches resulting from our 
> testing are on their way into 4.5.
 
I saw that, thank you.

> How has it been running since?  Any new backtraces to investigate?

No crashes since then, although my last one started when I was shutting
the laptop down, and I don't shut down very often (actually virtually
never unless I upgrade kernels :) ).

But that's another way ot say so far so good :)

Thanks for your work looking into this.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
