From: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Formatting of backing device
Date: Thu, 16 Feb 2012 15:34:21 -0800
Message-ID: <CA++fp8w7_uUd35Tcwy1bwEYpR6tJ+fkWMEg+iVEyJ1H4hqKBKg@mail.gmail.com>
References: <20120201214443.GA8544@lazy.lzy>
	<CAHYUNGYyPafQzmwMdS-tRAPsYYM+9uRpN-38Av4uDJwtwY_d=A@mail.gmail.com>
	<20120202190122.GA2353@lazy.lzy>
	<20120202221101.GA26768@google.com>
	<20120202222431.GA7171@lazy.lzy>
	<loom.20120216T200235-190@post.gmane.org>
	<20120216203332.GA6597@lazy.lzy>
	<CA++fp8wcxTDJ=mbsKmWi27+yRZg-tyNdWgmhWU6=UeWgC0TZuw@mail.gmail.com>
	<20120216223554.GA6947@lazy.lzy>
	<CAOzFzEhO+6ECN-WjvtMK+-2g7Dwo+DPwQMVWuCZG=Y3BVRNEBw@mail.gmail.com>
	<20120216231754.GA14206@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120216231754.GA14206-W+Wf6LxwHt0@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Feb 16, 2012 at 3:17 PM, Piergiorgio Sartor
<piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org> wrote:
> Hi joseph,
>
>> Your reasoning is quite sound assuming the cache device is present at
>> activation time.
>>
>> In the case where the cache device has failed but the backing device
>> has persisted the failure then the case looks somewhat more like this:
>> 1) OS probes all devices, searches for caches and finds none.
>> 2) Activate the raw backing device with possibly corrupt data....
>
> as I mentioned, this is a bit borderline.
>
> One reason is that it would be a failure in
> any case, depending on what the system will
> do with the backing device.

Perhaps, but there are two types of failures that are
absolutely critical to distinguish between:

Recoverable, and unrecoverable.

If there is a superblock, any error in which the cache
device is not available at activation is recoverable so
long as the cache device can be made available at
some other time.

If there is a superblock, whether such a situation is
recoverable is now undefined, and dependent on the
implementation of the filesystem.

This is a recipe for a horrible disaster.

> Second, as per md, the configuration could
> be in a file in initramfs, which will allow
> to support this type of failure *and* have
> the backing device unformatted.

Actually, in modern initramfs' (see dracut) the
way md devices are set up is via dynamic scanning,
NOT via a static configuration file.

This is possible *because* md devices have a
superblock on the backing devices. This is
*desirable* because a generic initramfs reduces
the burden on the user (to know what they are
doing) and on the distribution (to support users
who roll their own initramfs)

And dracut's entire logic is based on acting on
devices as they are detected, so delaying all
uevents until everything has been found would
catastrophically break it. Especially because
it acting on those events can create more devices
which also need probed.

What if your cache is on LVM but your backing
devices are whole disks? Waiting until all devices
have been probed before poking userspace means
that you will never find the cache at all.
