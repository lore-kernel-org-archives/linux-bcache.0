From: Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>
Subject: Re: SSD cache with regular partition, like BSD swapcache
Date: Thu, 15 Aug 2013 15:50:31 -0700
Message-ID: <CAO9TOLd203JdTN1w3kAf25PC1xKqamkSkfbnG3T8L7cHmr+NkQ@mail.gmail.com>
References: <alpine.LNX.2.01.1308152103410.24372@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.01.1308152103410.24372@localhost>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Hence, looking for a non-writeback SSD cache which can be transparently
> added and removed from the system.

Removing / Adding a caching device within Bcache can be done on a live
system, so long as a backing device is created before hand. This was
explained here:
http://comments.gmane.org/gmane.linux.kernel.bcache.devel/1886

> Doesn't look like it's possible from the docs; has there been any work on
> this -- a different 'glue' or front end?

Is this what you are looking for? https://github.com/g2p/blocks

This should keep any data on the backing device without the need to format.

Hope that helps,
-Adam

--
Adam Brenner
Computer Science, Undergraduate Student
Donald Bren School of Information and Computer Sciences

Research Computing Support
Office of Information Technology
http://www.oit.uci.edu/rcs/

University of California, Irvine
www.ics.uci.edu/~aebrenne/
aebrenne-sXc7qaQca9o@public.gmane.org


On Thu, Aug 15, 2013 at 2:11 PM, Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org> wrote:
> For some time I've been hoping to use SSD caching, but cannot reasonably
> accomodate the superblock and new partition format.
>
> Hence, looking for a non-writeback SSD cache which can be transparently
> added and removed from the system.
>
> Of course it's at the expense of losing the cache content each time the
> cache is attached -- but for many useful cases and workloads this is
> absolutely ok, eg. workstations (using suspend-RAM) or full-time servers.
>
> Doesn't look like it's possible from the docs; has there been any work on
> this -- a different 'glue' or front end?
>
> IIRC the first public announcement of bcache did something similar --
> hooked into the system by re-routing the I/O requests to a specific disk.
>
> Tho I did not test it, it looks like DragonFly BSD has what I'm looking
> for, as part of its "swapcache" feature -- looks very easy to set up:
>
>   http://www.dragonflybsd.org/docs/howtos/swapcache/
>
> Thanks
>
> --
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
