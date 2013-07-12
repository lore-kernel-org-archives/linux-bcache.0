From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Raw stats
Date: Thu, 11 Jul 2013 18:33:08 -0700
Message-ID: <20130712013308.GD17799@kmo-pixel>
References: <DE95649B-13EB-4733-BFCD-4B67F82D179B@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DE95649B-13EB-4733-BFCD-4B67F82D179B-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 11, 2013 at 07:35:01AM +0200, Stefan Priebe - Profihost AG wrote:
> The stats_total counters are formatted to GB MB,... for several use cases raw values would be better (f.e.nagios plugin). Is this possible?

Heh, I imagine Greg K-H or someone would say the sysfs stuff should only
be exporting the raw values..

It'd be pretty easy to add _raw versions, though - or maybe _bytes? I'm
not terribly eager to wade through the sysfs code right this minute, but
the sysfs code should be pretty easy to figure out if you want to try
it and I'd take a patch.

(Look for sysfs_hprint() calls in sysfs.c and stats.c; add attributes
(the read_attribute() things) for the files you want to add and
sysfs_print() calls for the raw versions)
