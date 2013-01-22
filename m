From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Adding caching to existing volumes?
Date: Tue, 22 Jan 2013 15:15:47 -0800
Message-ID: <20130122231547.GF26407@google.com>
References: <17989056.10.1358618905144.JavaMail.root@zimbra>
 <50FBA4A6.7020709@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50FBA4A6.7020709-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Haigh <netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Sun, Jan 20, 2013 at 07:02:46PM +1100, Steven Haigh wrote:
> On 20/01/2013 5:08 AM, Roy Sigurd Karlsbakk wrote:
> >Hi all
> >
> >As far as I can understand from the bcache docs, a volume cached with bcache, must be formatted and setup for bcache in the first place. I come from a ZFS environment, where adding SLOG or L2ARC is done dynamically, so I have a few questions:
> >
> >- Would it be somewhat possible to add caching to an existing volume and its data?
> >- What would happen if the cache device dies - does the whole filesystem become inaccessible?
> 
> I've actually been wondering a bit about this - its not exactly
> clear in the docs as to what I should do to set up bcache.
> 
> In my case, I have a RAID6 over 4 x 2Tb drives. It lives as
> /dev/md2. /dev/md[01] are RAID1 on a pair of 80Gb drives for boot
> and LVM.
> 
> As the system is a Xen Dom0, all the DomU (guests) run from their
> own LV on the RAID6. So - it would make sense to add bcache to
> /dev/md2.
> 
> I'm a bit confused from reading the docs if I can attach to the
> existing /dev/md2 or I have to create something from scratch.
> Obviously, attaching to an existing RAID device is going to be the
> preferred method.
> 
> Covering this in the docs or even on the web site would probably be
> beneficial for a lot of people - especially as I feel that this is
> getting closer to be merged with the upstream kernel.

You've got to start from scratch, unfortunately.

The reason is that there needs to be a bcache specific superblock on the
backing device so bcache can keep the cache and backing device in sync -
and especially so you can't accidentally mount and use the backing
device without the cache. That would be bad.

I just added an explanation to the faq - thanks for pointing it out.
http://bcache.evilpiepirate.org/FAQ
