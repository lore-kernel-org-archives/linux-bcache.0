From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: bcache-3.2 branch
Date: Wed, 20 Jun 2012 22:08:51 +1000
Message-ID: <CAOzFzEh8pO37dVWoMoD+hFoUGrBoubSdktdu7SQS0UcXLcC66w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Kent and list,

I have pulled down the latest bcache code and have been playing around
with it when I noticed that I am having issues starting Xen virtual
machines using bcache + LVM.
What is interesting is the QEMU storage emulation in userspace is able
to access the device fine however blkback kernel module which uses the
device directly seems to fail.
How would I go about debugging any of this?

Older versions of bcache work fine so it's a regression as far as I can=
 tell.

Joseph.

--=20
CTO | Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
