From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache-3.2 branch
Date: Mon, 9 Jul 2012 10:07:43 -0700
Message-ID: <20120709170742.GA26798@google.com>
References: <CAOzFzEh8pO37dVWoMoD+hFoUGrBoubSdktdu7SQS0UcXLcC66w@mail.gmail.com>
 <20120709155734.GA23774@google.com>
 <CAOzFzEjovYu4eE9E_asOBVyBhqFuvhgzJ7UFyESLY0XycAfkuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEjovYu4eE9E_asOBVyBhqFuvhgzJ7UFyESLY0XycAfkuA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Jul 10, 2012 at 02:32:36AM +1000, Joseph Glanville wrote:
> On 10 July 2012 01:57, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, Jun 20, 2012 at 10:08:51PM +1000, Joseph Glanville wrote:
> >> Hi Kent and list,
> >>
> >> I have pulled down the latest bcache code and have been playing around
> >> with it when I noticed that I am having issues starting Xen virtual
> >> machines using bcache + LVM.
> >> What is interesting is the QEMU storage emulation in userspace is able
> >> to access the device fine however blkback kernel module which uses the
> >> device directly seems to fail.
> >> How would I go about debugging any of this?
> >>
> >> Older versions of bcache work fine so it's a regression as far as I can tell.
> >
> > Hey, sorry for the delay - I just got back from my first sort-of
> > vacation in... awhile :P
> >
> > I'm pretty sure I know the approximate source of the regression - I
> > fairly recently reworked some code in the generic block layer to handle
> > arbitrary size bios (which enabled some major cleanups in the bcache
> > code). I've chased down a few bugs with that code since then.
> >
> > Got some logs for me to look at? Or did you want me to give you pointers
> > on debugging kernel code? :)
> 
> A few pointers would be great. :)

More than happy to :) I'm not sure what sort of general pointers I could
give you off the top of my head - there's no Unified Theory of
Debugging, it's just a big bag of tricks you learn to narrow things down
until you figure it out. But I'll try to tell you everything I'd do with
this bug, at least (and whatever else you find :)

Also just understanding how things work so you can figure out a root
cause from the symptom.

> 
> Also how do I best get it to do a really verbose log that I can use to
> help you track down bugs?

I think for all the bugs that have shown up in the wild so far we
haven't needed any special logging, just the normal stuff has been fine.
There's all kinds of logging and tracing and whatnot buried in there but
for the most part you don't want to bother with the non default stuff
unless you have to.

But anyways, just whatever the kernel spits out is the place to start.
If you've still got that, I'll take a look and tell you what I'd get out
of it.

> 
> >
> >>
> >> Joseph.
> >>
> >> --
> >> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> >> Phone: 1300 56 99 52 | Mobile: 0428 754 846
> 
> Cheers,
> Joseph.
> 
> -- 
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846
