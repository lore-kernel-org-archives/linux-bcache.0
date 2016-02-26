From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Fri, 26 Feb 2016 04:55:02 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602260422290.3635@mail.ewheeler.net>
References: <20160224204530.GA13079@merlins.org> <alpine.LRH.2.11.1602250052530.2131@mail.ewheeler.net> <alpine.LRH.2.11.1602250612440.3635@mail.ewheeler.net> <alpine.LRH.2.11.1602250729570.3635@mail.ewheeler.net> <CAC8teKVFASYjf1U+Y3JHCXREC3WwfO=2GR+=-8kYcNh+ugsMxw@mail.gmail.com>
 <alpine.LRH.2.11.1602252330290.3635@mail.ewheeler.net> <20160226024633.GF29543@merlins.org> <20160226031921.GG29543@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:40911 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751338AbcBZE41 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 25 Feb 2016 23:56:27 -0500
In-Reply-To: <20160226031921.GG29543@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org

On Thu, 25 Feb 2016, Marc MERLIN wrote:
> On Thu, Feb 25, 2016 at 06:46:33PM -0800, Marc MERLIN wrote:
> > Given that, I'm happy to run code that spits out diagostics, but probably
> > not something that will attempt to write an outdated cache on a filesytem
> > that's already ahead.
> > Or does bcache understand that the backing device is ahead already and the
> > cache should just be discarded?
> 
> Yeah, sorry, I did forget to mention that I did a force run on the 
> backing device so that I could get to its data. In doing so, I probably 
> invalidated options to try and reply the cache to see if things would 
> crash, or not, sorry about that.
> 
> Now, if I try to make the cache available again, will the code be smart and
> not try to reapply a stale cache (never mind that it's probably corrupted in
> addition to being old?)

According to Documentation/bcache.txt:
	"" If you're booting up and your cache device is gone and never
	coming back, you can force run the backing device:
	  echo 1 > /sys/block/sdb/bcache/running
	[...]
	The backing device will still use that cache set if it shows up
	in the future, but all the cached data will be invalidated.  ""

So it seems that you are safe.  (It would be interesting to know how it 
invalidates the cache.  Maybe bumps the Set UUID?  Not sure.)

This is what the patch does:

The code in super.c would do what bcache has always done in your kernel, 
except that it holds the writeback_lock to prevent a writeback kthread 
race before initialization is complete.  All that does is delay the 
writeback thread slightly.  If that fixes it, then it is a trivial patch 
from which everyone may benefit.

The code in writeback.c just jumps to the OOM case instead of bugging. If 
it does meet the printk(KERN_WARNING)+dump_stack() condition, then it 
might give us useful data to troubleshoot from.  I think this is quite 
safe since the OOM path just sleeps the kthread until the next writeback 
is scheduled and will try again.  If it dump_stack()'s every scheduled 
writeback interval, then something is seriously wrong somewhere else.

-Eric



> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> 
