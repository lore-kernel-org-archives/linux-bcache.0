From: Mark Hills <mark-tknEL9DgK0w@public.gmane.org>
Subject: Re: SSD cache with regular partition, like BSD swapcache
Date: Fri, 16 Aug 2013 18:41:14 +0100 (BST)
Message-ID: <alpine.LNX.2.01.1308161809070.8964@localhost>
References: <alpine.LNX.2.01.1308152103410.24372@localhost> <CAO9TOLd203JdTN1w3kAf25PC1xKqamkSkfbnG3T8L7cHmr+NkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO9TOLd203JdTN1w3kAf25PC1xKqamkSkfbnG3T8L7cHmr+NkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, 15 Aug 2013, Adam Brenner wrote:

> > Hence, looking for a non-writeback SSD cache which can be transparently
> > added and removed from the system.
> 
> Removing / Adding a caching device within Bcache can be done on a live
> system, so long as a backing device is created before hand. This was
> explained here:
> http://comments.gmane.org/gmane.linux.kernel.bcache.devel/1886

Sorry, maybe I should have been more clear. I meant adding without 
modifying the _backing_ device.

> > Doesn't look like it's possible from the docs; has there been any work on
> > this -- a different 'glue' or front end?
> 
> Is this what you are looking for? https://github.com/g2p/blocks
> 
> This should keep any data on the backing device without the need to format.

Not really, keeping the data on the partition is only part of the solution 
-- and this requires free space before the partiion, or LVM.

As I said, I don't wish to modify the backing device at all (even in-place 
for risk to data) or use a new partition format (also prevents mounting 
the filesystem on other systems, or boot disks)

And it's just not necessary anyway if using a non-persistent read cache.

The nature of swapcache's integration makes it easier and less disruptive 
to configure -- especially for people who don't already use an initrd.

It would make it easier to experiement with the caching in different 
scenarios.

Thanks

-- 
Mark
