From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache-3.2 branch
Date: Mon, 9 Jul 2012 08:57:34 -0700
Message-ID: <20120709155734.GA23774@google.com>
References: <CAOzFzEh8pO37dVWoMoD+hFoUGrBoubSdktdu7SQS0UcXLcC66w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEh8pO37dVWoMoD+hFoUGrBoubSdktdu7SQS0UcXLcC66w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jun 20, 2012 at 10:08:51PM +1000, Joseph Glanville wrote:
> Hi Kent and list,
>=20
> I have pulled down the latest bcache code and have been playing aroun=
d
> with it when I noticed that I am having issues starting Xen virtual
> machines using bcache + LVM.
> What is interesting is the QEMU storage emulation in userspace is abl=
e
> to access the device fine however blkback kernel module which uses th=
e
> device directly seems to fail.
> How would I go about debugging any of this?
>=20
> Older versions of bcache work fine so it's a regression as far as I c=
an tell.

Hey, sorry for the delay - I just got back from my first sort-of
vacation in... awhile :P

I'm pretty sure I know the approximate source of the regression - I
fairly recently reworked some code in the generic block layer to handle
arbitrary size bios (which enabled some major cleanups in the bcache
code). I've chased down a few bugs with that code since then.

Got some logs for me to look at? Or did you want me to give you pointer=
s
on debugging kernel code? :)

>=20
> Joseph.
>=20
> --=20
> CTO | Orion Virtualisation Solutions=C2=A0|=C2=A0www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846
