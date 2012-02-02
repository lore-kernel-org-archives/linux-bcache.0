From: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Thu, 2 Feb 2012 23:24:31 +0100
Message-ID: <20120202222431.GA7171@lazy.lzy>
References: <20120201101041.GA2779@lazy.lzy>
 <CAHYUNGYcs3CeRA8Pk-R_3hA6mFHshKzysxRaCcsfm3WLT__B0A@mail.gmail.com>
 <20120201205456.GA7669@lazy.lzy>
 <CAHYUNGaB4LCESDWU1tWB1ZJp_kBH_=19e07vCndxXS5T98_xBA@mail.gmail.com>
 <20120201214443.GA8544@lazy.lzy>
 <CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com>
 <20120202190122.GA2353@lazy.lzy>
 <20120202221101.GA26768@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120202221101.GA26768-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>, Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

nice to have you in this discussion!

> > I understand that the actual implementation is easier and,
> > maybe, simpler, since a completely new device is added,
> > which will have the new caching "features", while the
> > old one (backing device) is just a further layer.
> > This is similar to LVM over md over /dev/sdX.
> 
> The reason for getting rid of transparent caching didn't have anything
> to do with ease of implementation: the real reason is that safely doing
> persistent caching (and writeback!) is impossible with transparent
> caching.

Well, it seems to me "impossible" is a big word...
I could image is more "invasive".

> Adding back a mode that caches a device without a bcache superblock but
> without the cache being persistent isn't out of the question, but it

I miss the point, the superblock can be stored in
the caching device, instead of the backing and
the actual device *could* stay the same.
The kernel would have to discover first the caching,
later the backing and then put things together.
So, the cache will be persistent, or?

As I wrote above, I see this more complex than
adding a further layer, likely I would do the same.

> wouldn't be terribly useful to us so it's not at all a priority for me.
> If someone else wrote the code I'd take patches, though.

No time for that, unfortunately.

I take the opportunity to congratulate personally
to you for this project, well done!

bye,

-- 

piergiorgio
