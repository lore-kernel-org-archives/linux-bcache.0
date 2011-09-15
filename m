From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] Bcache version 12
Date: Thu, 15 Sep 2011 14:33:36 -0700
Message-ID: <CAC7rs0t_J+foaLZSuuw5BhpUAYfr-KY1iegFOxEBPCpbrkk1Dg@mail.gmail.com>
References: <20110910064531.GA32536@moria>
	<20110911081854.2958fdc8@notabene.brown>
	<20110911192259.GA3743@moria>
	<FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
	<20110912014407.GA5171@moria>
	<CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org" <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, Sep 15, 2011 at 2:15 PM, Dan Williams <dan.j.williams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
> On Sun, Sep 11, 2011 at 6:44 PM, Kent Overstreet
> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Sun, Sep 11, 2011 at 07:35:56PM -0600, Andreas Dilger wrote:
>>> On 2011-09-11, at 1:23 PM, Kent Overstreet <kent.overstreet@gmail.c=
om> wrote:
>>> > I don't think that makes any more sense, as module paramaters AFA=
IK are
>>> > even more explicitly just a value you can stick in and pull out.
>>> > /sys/fs/bcache/register is really more analagous to mount().
>
> ... and you looked at module_param_call()?

Damn, nope. I still think a module parameter is even uglier than a
sysfs file, though.

As far as I can tell, the linux kernel is really lacking any sort of
coherent vision for how to make arbitrary interfaces available from
the filesystem.

We all seem to agree that it's a worthwhile thing to do - nobody likes
ioctls, /proc/sys has been around for ages; something visible and
discoverable beats an ioctl or a weird special purpose system call any
day.

But until people can agree on - hell, even come up with a decent plan
- for the right way to put interfaces in the filesystem, I'm not going
to lose much sleep over it.

>> I looked into that many months ago, spent quite a bit of time fighti=
ng
>> with the dm code trying to get it to do what I wanted and... no. Nev=
er
>> again
>
> Did you do a similar analysis of md? =A0I had a pet caching project t=
hat
> had it's own sysfs interface registration system, and came to the
> conclusion that it would have been better to have started with an MD
> personality. =A0Especially when one of the legs of the cache is a
> md-raid array it helps to keep all that assembly logic using the same
> interface.

I did spend some time looking at md, I don't really remember if I gave
it a fair chance or if I found a critical flaw.

I agree that an md personality ought to be a good fit but I don't
think the current md code is ideal for what bcache wants to do. Much
saner than dm, but I think it still suffers from the assumption that
there's some easy mapping from superblocks to block devices, with
bcache they really can't be tied together.

> And md supports assembling devices via sysfs without
> requiring mdadm which is a nice feature.

Didn't know that, I'll have to look at that. If nothing else
consistency is good...

> Also has the benefit of reusing the distro installation / boot
> enabling for md devices which turned out to be a bit of work when
> enabling external-metadata in md.

Dunno what you mean about external metadata, but it would be nice to
not have to do anything to userspace to boot from a bcache device. As
is though it's only a couple lines of bash you have to drop in your
initramfs.
