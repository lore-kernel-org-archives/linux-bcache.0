From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: SSD cache with regular partition, like BSD swapcache
Date: Thu, 15 Aug 2013 22:11:10 +0100 (BST)
Message-ID: <alpine.LNX.2.01.1308152103410.24372@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

For some time I've been hoping to use SSD caching, but cannot reasonably 
accomodate the superblock and new partition format.

Hence, looking for a non-writeback SSD cache which can be transparently 
added and removed from the system.

Of course it's at the expense of losing the cache content each time the 
cache is attached -- but for many useful cases and workloads this is 
absolutely ok, eg. workstations (using suspend-RAM) or full-time servers.

Doesn't look like it's possible from the docs; has there been any work on 
this -- a different 'glue' or front end?

IIRC the first public announcement of bcache did something similar -- 
hooked into the system by re-routing the I/O requests to a specific disk.

Tho I did not test it, it looks like DragonFly BSD has what I'm looking 
for, as part of its "swapcache" feature -- looks very easy to set up:

  http://www.dragonflybsd.org/docs/howtos/swapcache/

Thanks

-- 
Mark
