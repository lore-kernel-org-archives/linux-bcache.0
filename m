From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache with iscsi, mpath and lvm
Date: Wed, 1 Feb 2012 03:29:18 +1100
Message-ID: <CAOzFzEhGrRwhFu16Y9j7Uk1QQWULWKR90xWzHd59KohQFok3Mw@mail.gmail.com>
References: <4F280A82.3070802@infernix.net>
	<CAOzFzEjE+h5wgY0JhZ6L5mJKtpLYyCSuErFWCd=E0UWNTTsQbQ@mail.gmail.com>
	<4F28110A.8070309@infernix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F28110A.8070309-ZHiucA87ovfk1uMJSBkQmQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infernix <infernix-ZHiucA87ovfk1uMJSBkQmQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 1 February 2012 03:04, infernix <infernix-ZHiucA87ovfk1uMJSBkQmQ@public.gmane.org> wrote:
> Op 31-1-2012 16:50, Joseph Glanville schreef:
>
>>> I've got the following stack, bottom to top:
>>> - iscsi sans with multiple NICs
>>> - servers with multiple NICs
>>> - open-iscsi cross-connecting to the san over those multiple nics
>>> - multipath to aggregate and load-balance IO over said paths
>>> - LVM on top of multiple mpathX devices
>>> - qemu-kvm running with disks connecting to logical volumes in said=
 LVM
>
>
>> If you are bottlenecking purely on random I/O then the easiest and
>> most logical place for bcache is infront of your iSCSI backing store
>> on your SAN.
>
>
> Agreed. But since the SAN is proprietary, there's zero chance of
> implementing bcache on the SAN :)

Ahh the wonders of proprietary appliances. :P

>
>
>> If however you are bottlenecked on the iSCSI interconnect you could
>> feasibly place bcache ontop of the multipath devices (they are just
>> standard dm targets) right below the VMs.
>> This adds the highest possible amount of performance to the VMs at t=
he
>> cost of increased maintaince, complexity of multiple caches and
>> ofcourse cost.
>
>
> Yes. So that is why I think the tradeoff of putting bcache on the mpa=
th
> devices is the best. There's no shared storage use between servers; e=
ach
> just uses its own LVs. As long as I'm using writethrough, this is saf=
e.
> Doing writeback is simply impossible with multiple caches like this.

It's actually quite easy to script, you can use SCSI ID or similar to
map the LUNs or LVs (not sure how you have things setup)
to block paths, which you can then use with multipath -ll to get the
multipath WWID
I'm playing with something similar atm.

>
> Setting up bcache for each and every logical volume is not really goi=
ng to
> work because they are quite dynamic.
>
>
>>> Is there any other way of activating bcache besides passing it an U=
UID?
>>> And
>>> can it even work on top of a dm-multipath device?
>>
>>
>> It works on LVM so it should work fine on multipath targets too.
>
>
> Except that I can't get an UUID from the LVM PVs:
>
> blkid /dev/mpath/mpath2 -s UUID -o value

That is a very valid point.. bcache should probably index by something
other than UUID because most block devices don't have them.. only
filesystems..

>
> Returns nothing. So I'm a little confused as to how to register the d=
evice
> for caching.
>
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
