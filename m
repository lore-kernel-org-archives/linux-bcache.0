From: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Thu, 16 Feb 2012 21:33:32 +0100
Message-ID: <20120216203332.GA6597@lazy.lzy>
References: <20120201101041.GA2779@lazy.lzy>
 <CAHYUNGYcs3CeRA8Pk-R_3hA6mFHshKzysxRaCcsfm3WLT__B0A@mail.gmail.com>
 <20120201205456.GA7669@lazy.lzy>
 <CAHYUNGaB4LCESDWU1tWB1ZJp_kBH_=19e07vCndxXS5T98_xBA@mail.gmail.com>
 <20120201214443.GA8544@lazy.lzy>
 <CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com>
 <20120202190122.GA2353@lazy.lzy>
 <20120202221101.GA26768@google.com>
 <20120202222431.GA7171@lazy.lzy>
 <loom.20120216T200235-190@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20120216T200235-190-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Alex,

> Oh sure, the cache is persistent. But device discovery order is undefined, and
> if the backing device is no different from one without a cache and writeback
> caching is enabled the kernel has no *possible* way to know that a caching
> device is needed or even exists. So it mounts it, but it doesn't have any of the
> data in the writeback cache meaning it thinks the filesystem is corrupted.
> Depending on the filesystem and exactly what is missing, it may run some
> in-kernel recovery code that alters the disk. You just lost your data.

nonono, I believe I wrote that the kernel
should *first* look for caching devices
and later for the others...

The formatting thing is, clearly, a much
standard approach, for the current kernel
architecture, but nothing forbids to have
a hierarchical search of devices.
This could be done, for example, by assigning
different classes to each device type, to
be scanned in a specific order. 

In this scope (not bcache, but device discovery)
it is already a problem a layered software RAID
with metadata 1.0 together with 1.2 (or 1.1).
Where the first lies at the end and the second
at the beginning of the HDDs, making it difficult
(but not impossible) to find out which is the
outer and which is the inner one.

bye,

-- 

piergiorgio
