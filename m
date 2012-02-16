From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Fri, 17 Feb 2012 10:09:57 +1100
Message-ID: <CAOzFzEhO+6ECN-WjvtMK+-2g7Dwo+DPwQMVWuCZG=Y3BVRNEBw@mail.gmail.com>
References: <20120201205456.GA7669@lazy.lzy>
	<CAHYUNGaB4LCESDWU1tWB1ZJp_kBH_=19e07vCndxXS5T98_xBA@mail.gmail.com>
	<20120201214443.GA8544@lazy.lzy>
	<CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com>
	<20120202190122.GA2353@lazy.lzy>
	<20120202221101.GA26768@google.com>
	<20120202222431.GA7171@lazy.lzy>
	<loom.20120216T200235-190@post.gmane.org>
	<20120216203332.GA6597@lazy.lzy>
	<CA++fp8wcxTDJ=mbsKmWi27+yRZg-tyNdWgmhWU6=UeWgC0TZuw@mail.gmail.com>
	<20120216223554.GA6947@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120216223554.GA6947-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Cc: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Piergiorgio,

Your reasoning is quite sound assuming the cache device is present at
activation time.

In the case where the cache device has failed but the backing device
has persisted the failure then the case looks somewhat more like this:
1) OS probes all devices, searches for caches and finds none.
2) Activate the raw backing device with possibly corrupt data....

This is the primary reason Alex has been trying to convince you of the
necessity of the super block on the backing device, it exists to tell
the kernel not to try activate it raw if the cache is not found.

Joseph.

On 17 February 2012 09:35, Piergiorgio Sartor
<piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
> Hi Alex.
>
>> The difference is that for MD devices, both types
>> of metadata are on the same block device. You're
>> prioritizing which *type of metadata* is checked
>
> how? 1.0 in 1.1 is the same as 1.1 in 1.0...
> The only difference would be that one is smaller
> than the other, which can hint which is first
> and which is second.
>
>> for first in that case. For bcache, you'd have to
>> scan /dev/sdz before /dev/sda if sdz is the cache
>> and sda is the backing device. Now consider a
>> few things:
>
> Again, you scan *all* and check *only* for
> cache devices.
> After that, if none found, you've your list of
> devices, if someone found, you activate these
> first and then the corresponding backing device.
>
>> 1.) SCSI/SATA devices may be probed in parallel
>
> And this does not make any difference, in
> this context. Probed does not mean necessarily
> activated. Maybe you mean probed as activated.
> For me it is different.
>
>> 2.) udev gets events when each device is probed,
>> *not* after all devices have been probed
>
> This is a udev issue, which can be fixed... :-)
>
>> 3.) The bcache device may not even be attached
>> to the system at the time
>
> Good, so the persistency is not needed, I guess,
> in that case...
> Or, the backing device cannot be activated,
> which might be an option, in the current
> architecture, but, maybe a bit borderline.
>
>> 4.) Even in the MD case, there is still *some*
>> change to the backing device, there is still some
>> sort of data there that says "hey, there's more."
>
> If you mean the 1.1 in 1.0 (or the other way around),
> there is no information telling you there's more,
> except, as mentioned, the size, which is not directly
> related to device probing.
>
> Otherwise, I do not understand what do you mean.
>
>> Even if it doesn't invalidate the other metadata, it
>> still tells the kernel that it's not enough - think of
>> it as invalidating it at the logical rather than the
>> physical level
>>
>> 3 and 4 are the really critical ones. If the cable
>> that connects the SSD to the computer is flaky,
>
> In this case you've much more serious problems,
> I guess, this is not a use case.
> The cable can be flaky also after the probing
> and activation, and result in a disaster.
>
>> Also, you say that the cache must be scanned
>> before the backing device - but how do you know
>> it's a cache or a backing device until you've probed it?
>
> The cache has ad "header" with enough information,
> namely the UUID(s) of the backing device(s)
> So you probe (I use "scan") all devices, sort out
> caches, sort out backing and the rest.
> Then you activate in proper order.
> There are many other alternatives.
>
>> You could delay sending any uevents untill all
>> devices are probed, except there are some devices
>> that take 30sec timeouts and fail, or iscsi, or devices
>> that get plugged in at runtime, or...
>
> Those are *all* solvable problems. Some of
> them are even too generic. That is, they're
> problems in any case.
>
> As I wrote few posts ago, it is clear why it is
> like it is. It is *complex* to implement all the
> required changes in order to have the backing
> device unformatted. Which has, in the end,
> limited advantage.
>
> No problem with that, very fine for me, but
> telling the it is not possible, it is just,
> well, let's say funny.
>
>> And since you can't do that, you have a chicken
>> and egg problem. You can't probe the backing
>> device before the cache, but you don't know which
>> is the cache until you probe it. And there may be
>> more than one of each. You can have one cache
>> and 200 backing devices, in theory. Want to take
>> the odds that the cache gets probed first at random?
>> Because the kernel doesn't have enough information
>> for it to be anything other than random.
>
> The kernel, again, has to separate the probing
> process, from the activation process.
>
> Furthermore, it could always be possible to
> configure the booting process to do so, in
> an *explicit* way, like md does usually, i.e.
> with a configuration file (in initramfs).
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846
