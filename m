From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: Raw stats
Date: Fri, 12 Jul 2013 08:14:40 +0200
Message-ID: <51DF9ED0.9010103@profihost.ag>
References: <DE95649B-13EB-4733-BFCD-4B67F82D179B@profihost.ag> <20130712013308.GD17799@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130712013308.GD17799@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Am 12.07.2013 03:33, schrieb Kent Overstreet:
> On Thu, Jul 11, 2013 at 07:35:01AM +0200, Stefan Priebe - Profihost AG wrote:
>> The stats_total counters are formatted to GB MB,... for several use cases raw values would be better (f.e.nagios plugin). Is this possible?
> 
> Heh, I imagine Greg K-H or someone would say the sysfs stuff should only
> be exporting the raw values..
> 
> It'd be pretty easy to add _raw versions, though - or maybe _bytes? I'm
> not terribly eager to wade through the sysfs code right this minute, but
> the sysfs code should be pretty easy to figure out if you want to try
> it and I'd take a patch.
> 
> (Look for sysfs_hprint() calls in sysfs.c and stats.c; add attributes
> (the read_attribute() things) for the files you want to add and
> sysfs_print() calls for the raw versions)

I would vote for dropping this human stuff too and use raw / byte values
in general. Makeing nice looking values out of it is always up to utils
or the user.

Greets,
Stefan
