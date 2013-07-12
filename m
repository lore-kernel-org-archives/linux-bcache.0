From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: bcache kernel 3.10 wrong bypassed values
Date: Thu, 11 Jul 2013 18:55:59 -0700
Message-ID: <20130712015559.GF17799@kmo-pixel>
References: <51D52EA0.80302@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51D52EA0.80302-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 04, 2013 at 10:13:20AM +0200, Stefan Priebe - Profihost AG wrote:
> Hello list,
> 
> while testing bcache i noticed that while writing a big 48GB file the
> sequential cutoff works fine i see only I/O on the disk but not on the
> cache. I thought i would afterwards see a bypassed value of around 48GB
> but it is only 1.2GB.
> 
> Is this expected? Is bcache in kernel 3.10 stable for production usage?

That sounds like a bug, but bcache in 3.10 certainly should be stable
for production usage.

There can be some weirdness due to the way the stats work, there's a ~13
second update interval (and also the intermediate counters are 32 bit
ints so if you manage to wrap that in 13 seconds you'll lose counts, but
it's counting sectors so I doubt that happened here).

Does that sound like it might explain what you were seeing, or do you
think there's something else going on?
