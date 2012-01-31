From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache with iscsi, mpath and lvm
Date: Wed, 1 Feb 2012 02:50:01 +1100
Message-ID: <CAOzFzEjE+h5wgY0JhZ6L5mJKtpLYyCSuErFWCd=E0UWNTTsQbQ@mail.gmail.com>
References: <4F280A82.3070802@infernix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F280A82.3070802-ZHiucA87ovfk1uMJSBkQmQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infernix <infernix-ZHiucA87ovfk1uMJSBkQmQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I'm not a bcache expert by any means but I might hazard a few comments =
inline.

On 1 February 2012 02:36, infernix <infernix-ZHiucA87ovfk1uMJSBkQmQ@public.gmane.org> wrote:
> Hi,
>
> I've got the following stack, bottom to top:
>
> - iscsi sans with multiple NICs
> - servers with multiple NICs
> - open-iscsi cross-connecting to the san over those multiple nics
> - multipath to aggregate and load-balance IO over said paths
> - LVM on top of multiple mpathX devices
> - qemu-kvm running with disks connecting to logical volumes in said L=
VM
>
> I am wondering if bcache can fit in, and if so, where?

The primary purpose of bcache is to serve as a writeback cache as this
provides the most benefit to I/O.
However where you place this cache depends on your usage patterns and
bottlenecks...
If you are bottlenecking purely on random I/O then the easiest and
most logical place for bcache is infront of your iSCSI backing store
on your SAN.

Looking something like this:

SAN NICs > IET or SCST > bcache > Backing store

This is super simple and means you make the most possible use out of
the cache because all of your clients random I/O is gauranteed to make
its way through this path.

If however you are bottlenecked on the iSCSI interconnect you could
feasibly place bcache ontop of the multipath devices (they are just
standard dm targets) right below the VMs.
This adds the highest possible amount of performance to the VMs at the
cost of increased maintaince, complexity of multiple caches and
ofcourse cost.

>
> Ideally I would say it sits between multipath and LVM, e.g. it is act=
ive for
> the /dev/mapper/mpathX devices. But that doesn't work because there i=
sn't
> really a filesystem on it and so it doesn't get assigned an UUID. Eve=
n if it
> did, that UUID would be the same for all sdX devices in the multipath
> device.
>
> Is there any other way of activating bcache besides passing it an UUI=
D? And
> can it even work on top of a dm-multipath device?

It works on LVM so it should work fine on multipath targets too.

>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html


Hope that was able to help abit. :)
Keep the list in the loop on your progress.

Joseph.

--=20
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846
