From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache-tools package for Fedora / status probe-bcache
Date: Mon, 09 Sep 2013 17:28:57 +0200
Message-ID: <522DE939.5090009@gmail.com>
References: <521A55D4.20908@rolffokkens.nl> <52282A87.4000801@rolffokkens.nl> <52285A03.7080802@gmail.com> <FEBD3400-93F1-4286-8BE8-45D5413C2EA2@rolffokkens.nl> <52286299.7000708@gmail.com> <20130909132653.GA8061@x2.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130909132653.GA8061-s5vVilr7EKH/9pzu0YdTqQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

lun. 09 sept. 2013 15:26:53 CEST, Karel Zak a =C3=A9crit :
> On Thu, Sep 05, 2013 at 12:53:13PM +0200, Gabriel de Perthuis wrote:
>>>> I'm not a fan of a blkid csum check (I pointed it out on the=20
>>>> bug[1]). If a superblock gets scribbled or corrupted, you want=20
>>>> bcache to complain, and you don't want blkid to look for the next=20
>>>> possible signature.
>>>
>>> Having blkid also verify the csum was requested by Karel Zak, the=20
>>> maintainer of util-linux. As a packager of bcache-tools I'm in favo=
ur
>>> of having blkid identify bcache, but I don't have a preference on
>>> using csum to identify bcache. I can pass the message to Karel, but
>>> it would be better if we both discuss it on the appropriate=20
>>> (util-linux?) mail list.
>>
>> Karel, are you okay if blkid doesn't do the csum verification discus=
sed above?
>
>  I don't insist on csum, but I'd like to have something more robust
>  than check for a magic string only. It's usually better if there
>  is some additional thing (for example within superblock offset,
>  csum, etc.) -- checksums are ideal because it usually verifies=20
>  whole superblock (header).=20
> =20
>> Checksum failures will be reported by the kernel instead.
>
>  I don't care about kernel :-) The important is what userspace (udev)
>  thinks about the device -- is it correct to trigger any action on
>  broken bcache device or the device should be ignored by userspace
>  rules?

It's correct insofar as current consumers expect it, and it's better
for error reporting.  The patches took care of my other objections,
so you can keep the crc check and go with what's on
https://github.com/g2p/util-linux/commits
(the csum patches I sent + Rolf's patch + a patch that depends on both)=
=2E

>> Alternatively, do you see a way libblkid can return good magic / bad=
 checksum
>> results?
>
>  If I good understand your patches then it makes wipefs(8) more
>  "hungry" to zap incomplete superblock. I have no problem to support
>  this scenario.

The second patch does that, and the first one also prevents exposing
nested data when a csum is broken, which was a dangerous failure mode.

>  Something else (like report bad checksums to udev) is probably
>  unnecessary. Right?

It would be good to have, because silent boot failures suck.
Maybe as a tweak to udev's embedded blkid?

>>> I agree, f20 is a specific case, but in general probe-bcache will b=
e=20
>>> needed for a while.
>>
>> For the record, the libblkid patch is a good thing in the long run:
>> common interface, less forks in udev.
>
>  Yes, definitely.=20
> =20
>  Maybe we can backport the patch to F20 if you need it -- it's not to=
o
>  invasive change.=20

(Letting Rolf field this one)
