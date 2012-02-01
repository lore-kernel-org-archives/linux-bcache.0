From: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Wed, 1 Feb 2012 21:54:56 +0100
Message-ID: <20120201205456.GA7669@lazy.lzy>
References: <20120201101041.GA2779@lazy.lzy>
 <CAHYUNGYcs3CeRA8Pk-R_3hA6mFHshKzysxRaCcsfm3WLT__B0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHYUNGYcs3CeRA8Pk-R_3hA6mFHshKzysxRaCcsfm3WLT__B0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Adam,

thanks for the answer, see below.

On Wed, Feb 01, 2012 at 11:04:59AM -0800, Adam Berkan wrote:
> You can attach bcache to a drive with an existing file system, and it will
> continue as normal.  If you connect to a drive without a file system, then
> it will continue to not have a file system, but you can format it while
> attached.

Maybe I misused the term "format".

I did not mean filesystem format, but bcache format.

What I understood, maybe I'm wrong, is that the backing
device, before being used, must be "initialized" with
the bcache tool.

From the docs:

Getting started:
You'll need make-bcache from the bcache-tools repository. Both the cache device
and backing device must be formatted before use.
  make-bcache -B /dev/sdb
  make-bcache -C -w2k -b1M -j64 /dev/sdc

I understand this as the backing device gets something
on written on it (note the term "formatted").

Am I wrong? I hope so...

Thanks again,

bye,

pg

> Attach/detach should work while the device is in use.  This isn't the most
> tested code path, especially with writeback on, but it's supposed to work.
>  Detaching while the cache is dirty requires flushing all that data so
> performance will be bad until the detach completes.
> 
> Let us know if you find any bugs.
> Adam
> 
> On Wed, Feb 1, 2012 at 2:10 AM, Piergiorgio Sartor <
> piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
> 
> > Hi all,
> >
> > first of all I would like to congratulate for this
> > project, I think it is one of the most promising
> > feature the Linux kernel can have.
> >
> > Wrote that, I've a question about the concept of
> > formatting the backing device.
> >
> > As far as I understood, the first concept of bcache
> > was to simply "register" or "attach" a cache to a
> > backing device, that is, the backing device had not
> > to be formatted.
> >
> > Lately, still if I understood it correctly, this
> > behaviour was changed and, now, the backing device
> > needs to be formatted.
> >
> > So, the question is:
> >
> > How about an already running device? Is it still
> > possible to attach a cache under such situation?
> >
> > In general, would it be possible to attach/detach
> > a cache to any already available device (in the
> > future)? Or the caching/backing setup must be planned
> > before the HW is available, so to speak?
> >
> > It would be useful (and cool too), to have the
> > possibility to attach/detach the SSD cache, on
> > the fly (at run-time) to any device it needs it.
> >
> > I hope the question(s) are clear, if not please
> > let me know.
> >
> > Thanks a lot in advance,
> >
> > bye,
> >
> > --
> >
> > piergiorgio
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

-- 

piergiorgio
