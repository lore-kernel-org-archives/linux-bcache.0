From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Thu, 2 Feb 2012 14:11:01 -0800
Message-ID: <20120202221101.GA26768@google.com>
References: <20120201101041.GA2779@lazy.lzy>
 <CAHYUNGYcs3CeRA8Pk-R_3hA6mFHshKzysxRaCcsfm3WLT__B0A@mail.gmail.com>
 <20120201205456.GA7669@lazy.lzy>
 <CAHYUNGaB4LCESDWU1tWB1ZJp_kBH_=19e07vCndxXS5T98_xBA@mail.gmail.com>
 <20120201214443.GA8544@lazy.lzy>
 <CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com>
 <20120202190122.GA2353@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120202190122.GA2353-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Cc: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Feb 02, 2012 at 08:01:22PM +0100, Piergiorgio Sartor wrote:
> Hi Adam,
> 
> On Wed, Feb 01, 2012 at 03:11:54PM -0800, Adam Berkan wrote:
> > When we make-bcache on a drive we need to replace the filesytem
> > superblock with a bcache superblock so the kernel knows to load the
> > drive through bcache, but this destroys the filesystem.  We've talked
> 
> well, I guess it will destroy the md superblock 1.1 too,
> how about LVM metadata?
> 
> I think the mismatch is with /dev/bcacheX device.
> 
> The first implementation, as far as I remember, was simply
> telling the caching device (using UUID) which was the
> backing device, i.e. it was registering the backing to
> the caching.
> Then, still if I got it right, the bcache was caching the
> backing device directly, without any need of a third
> device (/dev/bcacheX).
> 
> I understand that the actual implementation is easier and,
> maybe, simpler, since a completely new device is added,
> which will have the new caching "features", while the
> old one (backing device) is just a further layer.
> This is similar to LVM over md over /dev/sdX.

The reason for getting rid of transparent caching didn't have anything
to do with ease of implementation: the real reason is that safely doing
persistent caching (and writeback!) is impossible with transparent
caching.

Adding back a mode that caches a device without a bcache superblock but
without the cache being persistent isn't out of the question, but it
wouldn't be terribly useful to us so it's not at all a priority for me.
If someone else wrote the code I'd take patches, though.
