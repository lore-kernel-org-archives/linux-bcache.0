From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: label devices got removed after format
Date: Tue, 16 Jul 2013 14:37:56 -0700
Message-ID: <20130716213756.GA2724@kmo-pixel>
References: <51DE7E3A.5070709@profihost.ag>
 <20130712012806.GB17799@kmo-pixel>
 <krom21$tfo$2@ger.gmane.org>
 <51DFDE21.2040309@profihost.ag>
 <kroq08$tfo$3@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <kroq08$tfo$3@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Jul 12, 2013 at 11:40:56AM +0000, Gabriel de Perthuis wrote:
> On Fri, 12 Jul 2013 12:44:49 +0200, Stefan Priebe - Profihost AG wrote:
> > Am 12.07.2013 12:33, schrieb Gabriel de Perthuis:
> >> On Thu, 11 Jul 2013 18:28:06 -0700, Kent Overstreet wrote:
> >>> On Thu, Jul 11, 2013 at 11:43:22AM +0200, Stefan Priebe - Profihost AG wrote:
> >>>> Hi,
> >>>>
> >>>> after doing mkfs.xfs -f /dev/bcache/by-label/mybcachelabel
> >>>>
> >>>> /dev/bcache/by-label/mybcachelabel gots removed...
> >>>>
> >>>> Only a reboot brings it back.
> >>>>
> >>>> Stefan
> >>>
> > To me it happens alays when a udev event is triggered. It seems the
> > label isn't republished. To me the whole Folder /dev/bcache gets removed.
> > 
> > May i've used the wrong kernel patches on top of 3.10?
> 
> After discussing this on IRC:
> 
> The Squeeze version of udev chokes on newlines in labels, to the point
> that all the device's symlinks are removed; the uuid symlinks aren't
> even involved in label uevents.
> As a workaround, the latest commit in [1] strips endlines when setting
> the label.
> 
> [1] https://github.com/g2p/linux/commits/v3.10%2Bbcache-for-3.11

Thanks, applied.

Gabriel, would you mind sending me these patches with git format-patch
or git send-email? I didn't see this until last night :)
