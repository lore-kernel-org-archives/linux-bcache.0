From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache-3.2 branch
Date: Wed, 11 Jul 2012 04:52:40 +1000
Message-ID: <CAOzFzEjUy9zakyBhE5CNhcP-Dv7+hQBz3uzhKsMy5kj5GxfGwg@mail.gmail.com>
References: <CAOzFzEh8pO37dVWoMoD+hFoUGrBoubSdktdu7SQS0UcXLcC66w@mail.gmail.com>
	<20120709155734.GA23774@google.com>
	<CAOzFzEjovYu4eE9E_asOBVyBhqFuvhgzJ7UFyESLY0XycAfkuA@mail.gmail.com>
	<20120709170742.GA26798@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120709170742.GA26798-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 10 July 2012 03:07, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jul 10, 2012 at 02:32:36AM +1000, Joseph Glanville wrote:
>> On 10 July 2012 01:57, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Wed, Jun 20, 2012 at 10:08:51PM +1000, Joseph Glanville wrote:
>> >> Hi Kent and list,
>> >>
>> >> I have pulled down the latest bcache code and have been playing around
>> >> with it when I noticed that I am having issues starting Xen virtual
>> >> machines using bcache + LVM.
>> >> What is interesting is the QEMU storage emulation in userspace is able
>> >> to access the device fine however blkback kernel module which uses the
>> >> device directly seems to fail.
>> >> How would I go about debugging any of this?
>> >>
>> >> Older versions of bcache work fine so it's a regression as far as I can tell.
>> >
>> > Hey, sorry for the delay - I just got back from my first sort-of
>> > vacation in... awhile :P
>> >
>> > I'm pretty sure I know the approximate source of the regression - I
>> > fairly recently reworked some code in the generic block layer to handle
>> > arbitrary size bios (which enabled some major cleanups in the bcache
>> > code). I've chased down a few bugs with that code since then.
>> >
>> > Got some logs for me to look at? Or did you want me to give you pointers
>> > on debugging kernel code? :)
>>
>> A few pointers would be great. :)
>
> More than happy to :) I'm not sure what sort of general pointers I could
> give you off the top of my head - there's no Unified Theory of
> Debugging, it's just a big bag of tricks you learn to narrow things down
> until you figure it out. But I'll try to tell you everything I'd do with
> this bug, at least (and whatever else you find :)
>
> Also just understanding how things work so you can figure out a root
> cause from the symptom.
>
>>
>> Also how do I best get it to do a really verbose log that I can use to
>> help you track down bugs?
>
> I think for all the bugs that have shown up in the wild so far we
> haven't needed any special logging, just the normal stuff has been fine.
> There's all kinds of logging and tracing and whatnot buried in there but
> for the most part you don't want to bother with the non default stuff
> unless you have to.
>
> But anyways, just whatever the kernel spits out is the place to start.
> If you've still got that, I'll take a look and tell you what I'd get out
> of it.

Unfortunately the kernel wasn't talking much, I didn't see anything
unusual and everything else seemed to work fine. :(
I was able to successfully use bcached LVM volumes with filesystems
too, it only became an issue when trying to use them as block devices
for virtual machines.
From the virtual machine all I could see where I/O errors, probably
caused by the xen_blkback module returning failed read.
Debugging that beast is not all that fun but I will see how I can go
setting up a test system sometime this week with the latest bcache
code.
We are pretty entrenched in 3.2 but would be be more useful if I
carried out testing on latter kernels instead or is 3.2 fine?

>
>>
>> >
>> >>
>> >> Joseph.
>> >>
>> >> --
>> >> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
>> >> Phone: 1300 56 99 52 | Mobile: 0428 754 846
>>
>> Cheers,
>> Joseph.
>>
>> --
>> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
>> Phone: 1300 56 99 52 | Mobile: 0428 754 846

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
