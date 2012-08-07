From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: RE: add to Debian
Date: Tue, 7 Aug 2012 07:06:04 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B299EA7B3@BITCOM1.int.sbss.com.au>
References: <6035A0D088A63A46850C3988ED045A4B299EA53B@BITCOM1.int.sbss.com.au>
	<CAOzFzEicSMKQ4eerE2_J30vJhsYnm1Y7KPvCkVA5T3Dg0KEN9A@mail.gmail.com>
	<6035A0D088A63A46850C3988ED045A4B299EA666@BITCOM1.int.sbss.com.au>
 <CAOzFzEjONDnhoSdr8J09WhmZsG42Hz6sxZ8YO++NVwGBUSK-GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEjONDnhoSdr8J09WhmZsG42Hz6sxZ8YO++NVwGBUSK-GQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> 
> On 7 August 2012 16:16, James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
> wrote:
> >> Hi James,
> >>
> >> Yes the current patches apply cleanly afaik. :)
> >>
> >> There is still an outstanding bug with relation to Xen's blkback that
> >> I haven't had time to debug further yet that you might run into.
> >>
> >
> > What are the circumstances under which this bug appears? I'm planning on
> doing this initially:
> >
> > sd[ab]
> > md0
> > lvm
> > bcache (per lv)
> >
> > for testing, and then exposing the cached device to xen. Assuming testing
> goes well I'll do it like this:
> >
> > sd[ab]
> > md0
> > bcache
> > lvm
> >
> > with a bit of reworking to create a non-bcache'd /boot raid unless grub2
> knows all about bcache, or if bcache is transparent to grub2.
> >
> > James
> 
> That is precisely the setup I am currently using.
> 
> I haven't done much debugging yet unfortunately but I can't get VMs to boot
> using PV disk drivers (they work fine using QEMU).
> 
> I think it has something to do with DM/blkback interactions with bcaches bio
> splitting code, the bug only emerged recently and older versions of bcache
> work fine.
> 

If I get time to get it all going I'll have a look. If it's blkback interaction problems I should be able to help track it down, although it might be a few days before I can actually get to look at it.

James
