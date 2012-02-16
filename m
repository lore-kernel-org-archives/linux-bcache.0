From: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Thu, 16 Feb 2012 19:42:43 +0000 (UTC)
Message-ID: <loom.20120216T200235-190@post.gmane.org>
References: <20120201101041.GA2779@lazy.lzy> <CAHYUNGYcs3CeRA8Pk-R_3hA6mFHshKzysxRaCcsfm3WLT__B0A@mail.gmail.com> <20120201205456.GA7669@lazy.lzy> <CAHYUNGaB4LCESDWU1tWB1ZJp_kBH_=19e07vCndxXS5T98_xBA@mail.gmail.com> <20120201214443.GA8544@lazy.lzy> <CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com> <20120202190122.GA2353@lazy.lzy> <20120202221101.GA26768@google.com> <20120202222431.GA7171@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Piergiorgio Sartor <piergiorgio.sartor@...> writes:

> > The reason for getting rid of transparent caching didn't have anything
> > to do with ease of implementation: the real reason is that safely doing
> > persistent caching (and writeback!) is impossible with transparent
> > caching.
>
> Well, it seems to me "impossible" is a big word...
> I could image is more "invasive".

Not invasive, *horribly unsafe*

> > Adding back a mode that caches a device without a bcache superblock but
> > without the cache being persistent isn't out of the question, but it
> 
> I miss the point, the superblock can be stored in
> the caching device, instead of the backing and
> the actual device *could* stay the same.
> The kernel would have to discover first the caching,
> later the backing and then put things together.
> So, the cache will be persistent, or?

Oh sure, the cache is persistent. But device discovery order is undefined, and
if the backing device is no different from one without a cache and writeback
caching is enabled the kernel has no *possible* way to know that a caching
device is needed or even exists. So it mounts it, but it doesn't have any of the
data in the writeback cache meaning it thinks the filesystem is corrupted.
Depending on the filesystem and exactly what is missing, it may run some
in-kernel recovery code that alters the disk. You just lost your data.
