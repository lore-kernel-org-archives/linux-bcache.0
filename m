From: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Thu, 16 Feb 2012 12:52:33 -0800
Message-ID: <CA++fp8xkhSGM2iQLAHD_rBrR5HyZQmvBgxPExvbAz-jO598bAQ@mail.gmail.com>
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
	<20120216203332.GA6597@lazy.lzy>
	<CA++fp8wcxTDJ=mbsKmWi27+yRZg-tyNdWgmhWU6=UeWgC0TZuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA++fp8wcxTDJ=mbsKmWi27+yRZg-tyNdWgmhWU6=UeWgC0TZuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Feb 16, 2012 at 12:50 PM, Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Feb 16, 2012 at 12:33 PM, Piergiorgio Sartor
> <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
>> Hi Alex,
>>
>>> Oh sure, the cache is persistent. But device discovery order is undefined, and
>>> if the backing device is no different from one without a cache and writeback
>>> caching is enabled the kernel has no *possible* way to know that a caching
>>> device is needed or even exists. So it mounts it, but it doesn't have any of the
>>> data in the writeback cache meaning it thinks the filesystem is corrupted.
>>> Depending on the filesystem and exactly what is missing, it may run some
>>> in-kernel recovery code that alters the disk. You just lost your data.
>>
>> nonono, I believe I wrote that the kernel
>> should *first* look for caching devices
>> and later for the others...
>>
>> The formatting thing is, clearly, a much
>> standard approach, for the current kernel
>> architecture, but nothing forbids to have
>> a hierarchical search of devices.
>> This could be done, for example, by assigning
>> different classes to each device type, to
>> be scanned in a specific order.
>>
>> In this scope (not bcache, but device discovery)
>> it is already a problem a layered software RAID
>> with metadata 1.0 together with 1.2 (or 1.1).
>> Where the first lies at the end and the second
>> at the beginning of the HDDs, making it difficult
>> (but not impossible) to find out which is the
>> outer and which is the inner one.
>
> The difference is that for MD devices, both types
> of metadata are on the same block device. You're
> prioritizing which *type of metadata* is checked
> for first in that case. For bcache, you'd have to
> scan /dev/sdz before /dev/sda if sdz is the cache
> and sda is the backing device. Now consider a
> few things:
>
> 1.) SCSI/SATA devices may be probed in parallel
>
> 2.) udev gets events when each device is probed,
> *not* after all devices have been probed
>
> 3.) The bcache device may not even be attached
> to the system at the time
>
> 4.) Even in the MD case, there is still *some*
> change to the backing device, there is still some
> sort of data there that says "hey, there's more."
> A totally unchanged backing device won't do that.
> Even if it doesn't invalidate the other metadata, it
> still tells the kernel that it's not enough - think of
> it as invalidating it at the logical rather than the
> physical level
>
> 3 and 4 are the really critical ones. If the cable
> that connects the SSD to the computer is flaky,
> and it never gets probed, and there is *no*
> metadata on the backing device, there is
> *exactly* zero information available to the kernel
> to inform it that a backing device ever existed at all.

Er, to inform it that a *cache* device ever existed

>
> Also, you say that the cache must be scanned
> before the backing device - but how do you know
> it's a cache or a backing device until you've probed it?
> You could delay sending any uevents untill all
> devices are probed, except there are some devices
> that take 30sec timeouts and fail, or iscsi, or devices
> that get plugged in at runtime, or...
>
> And since you can't do that, you have a chicken
> and egg problem. You can't probe the backing
> device before the cache, but you don't know which
> is the cache until you probe it. And there may be
> more than one of each. You can have one cache
> and 200 backing devices, in theory. Want to take
> the odds that the cache gets probed first at random?
> Because the kernel doesn't have enough information
> for it to be anything other than random.
