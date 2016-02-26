From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: BUG: drivers/md/bcache/writeback.c:237
Date: Fri, 26 Feb 2016 21:17:08 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602262053130.3635@mail.ewheeler.net>
References: <20160224204530.GA13079@merlins.org> <alpine.LRH.2.11.1602250052530.2131@mail.ewheeler.net> <alpine.LRH.2.11.1602250612440.3635@mail.ewheeler.net> <alpine.LRH.2.11.1602250729570.3635@mail.ewheeler.net> <CAC8teKVFASYjf1U+Y3JHCXREC3WwfO=2GR+=-8kYcNh+ugsMxw@mail.gmail.com>
 <alpine.LRH.2.11.1602252330290.3635@mail.ewheeler.net> <20160226024633.GF29543@merlins.org> <20160226031921.GG29543@merlins.org> <alpine.LRH.2.11.1602260422290.3635@mail.ewheeler.net> <20160226162705.GA18927@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:42197 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753495AbcBZVRR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 26 Feb 2016 16:17:17 -0500
In-Reply-To: <20160226162705.GA18927@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>, linux-bcache@vger.kernel.org

On Fri, 26 Feb 2016, Marc MERLIN wrote:

> On Fri, Feb 26, 2016 at 04:55:02AM +0000, Eric Wheeler wrote:
> > According to Documentation/bcache.txt:
> > 	"" If you're booting up and your cache device is gone and never
> > 	coming back, you can force run the backing device:
> > 	  echo 1 > /sys/block/sdb/bcache/running
> > 	[...]
> > 	The backing device will still use that cache set if it shows up
> > 	in the future, but all the cached data will be invalidated.  ""
> > 
> > So it seems that you are safe.  (It would be interesting to know how it 
> > invalidates the cache.  Maybe bumps the Set UUID?  Not sure.)
>  
> Yeah, that was  my understanding too, but I wanted to make sure.
> Strangely (worringly so?) the cache was replayed at boot, and this time
> nothing crashed, or any traceback.

No crash is a good thing!  I think the lock solved it then.  If the lock 
wasn't the problem, then you would get tracebacks---and possibly lots of 
them.

> Now I'm wondering if it pushed garbage onto my filesystem :-/

Read "THE JOURNAL" here:
  https://evilpiepirate.org/git/linux-bcache.git/tree/drivers/md/bcache/bcache.h

 "Bcache's journal is not necessary for consistency [...] Rather, the 
 journal is purely a performance optimization; we can't complete a write 
 until we've updated the index on disk, otherwise the cache would be 
 inconsistent in the event of an unclean shutdown."

I'm not convinced that journal replay will writeback, especially because 
of the documentation stating that forcing a bdev into a running state 
invalidates its cache.  I think it just keeps the datastructures in good 
shape on the cachedev, even though the cachedev was invalidated by forcing 
a 'running' state.

See super.c:bch_cached_dev_run() which was called when you `echo 1>running`.  
It looks like it sets BDEV_STATE_STALE on the bdev superblock.  

Is this the flag that invalidates the cache?

Zhu, Kent, can you confirm this?

> Again, no netconsole, sorry, this happens before my ethernet interface
> comes up.
> https://goo.gl/photos/suqp9sHyijdt9iUG7
> 
> sda6 was the partition I hid and just came back.
> sdb1 is the bcache linked to it.
> 
> On the plus side, no crash, although this didn't get to exercise your
> new code either.

Actually, I'm glad it didn't execute my tracing code.  The BUG_ON can 
stay, it just wasn't initialized at the time the writeback kthread was 
started.
 
> Either way, I'm really starting to have mixed feelings about using
> writeback if it's going to give me random crashes and subsequent
> corruption (which is a risk listed in the doc, admittedly).

Of course writeback comes with increased risk, but read this from 
bcache.h:

   "[...] we always strictly order metadata writes so that the btree and 
   everything else is consistent on disk in the event of an unclean 
   shutdown [...] and in fact bcache had writeback caching (with recovery 
   from unclean shutdown) before journalling was implemented."

So except for unexpected races like this one, bcache should recovery 
gracefully from an unexpected outage.  I think the greater risk of 
writeback cache failure has to do with device wearout and bitflips---so 
watch your TBW values on the caches.

-Eric

> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> 
