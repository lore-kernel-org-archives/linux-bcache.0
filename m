From: Denis Bychkov <manover@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Sun, 19 Jul 2015 21:11:33 -0400
Message-ID: <CAO2mnowOYReY07-YT23J7jx51wTcjd9VG9-Zy5e2+qCK6Epa+Q@mail.gmail.com>
References: <20150714005825.GA24027@kmo-pixel>
	<CACaajQtwx45r8GcRmchrQwDts1GH-V8g0x1FwGfDvnfm02bq+Q@mail.gmail.com>
	<20150714081105.GA18569@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34198 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbbGTBLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 19 Jul 2015 21:11:33 -0400
Received: by obre1 with SMTP id e1so93753804obr.1
        for <linux-bcache@vger.kernel.org>; Sun, 19 Jul 2015 18:11:33 -0700 (PDT)
In-Reply-To: <20150714081105.GA18569@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Vasiliy Tolstov <v.tolstov@selfip.ru>, zab@zabbo.net, linux-bcache@vger.kernel.org, rickyb@google.com, mrubin@google.com, Slava Pestov <sviatoslavpestov@gmail.com>, adam.berkan@gmail.com

On Tue, Jul 14, 2015 at 4:11 AM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> On Tue, Jul 14, 2015 at 09:05:39AM +0300, Vasiliy Tolstov wrote:
>> Does it support discards?
>
>> Format command have one device, how provide tiering?
>
> --tier specifies the tier of the devices that come after it, where th=
e smaller
> index is the faster tier.
>
> Only tiers 0 and 1 are supported for now, that will be increased when=
ever
> someone gets around to it.
>
> If /dev/sda is your fast device and /dev/sdb is your slow device, run
>
> # bcacheadm format -C /dev/sda --tier 1 /dev/sdb
>
> bcacheadm format --help gives you the full list of options.

Ok, I am really confused right now. So, the format utility still
allows -B (backing device). Is it just an artifact left over after
block caching? Because I could not make it work. Any thread
encountering  the formatted backing device just hangs inside the
kernel space until reboot. Is there something wrong with my setup or
backing devices are just an illusion, a figment of kernel's
imagination? And, if not, how do they relate to tiers?
Could you give a simple example of a usual setup - one small and fast
SSD and huge but slow RAID-6? Should I now format both partitions as
-C and assign tier 1 to RAID-6?

>
>> 14 =D0=B8=D1=8E=D0=BB=D1=8F 2015 =D0=B3. 3:58 =D0=BF=D0=BE=D0=BB=D1=8C=
=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C "Kent Overstreet" <
>> kent.overstreet@gmail.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB=
:
>>
>> > Short announcement, because I'm in the process of moving - but I w=
anted to
>> > get
>> > this out there because the code is up and I think it's reasonably =
stable
>> > right
>> > now.
>> >
>> > Bcachefs is a posix filesystem that I've been working towards for =
- well,
>> > quite
>> > awhile now: it's intended as a competitor/replacement for ext4/xfs=
/btrfs.
>> >
>> > Current features
>> >  - multiple devices
>> >  - replication
>> >  - tiering
>> >  - data checksumming and compression (zlib only; also the code doe=
sn't
>> > work with
>> >    tiering yet)
>> >  - most of the normal posix fs features (no fallocate or quotas ye=
t)
>> >
>> > Planned features:
>> >  - snapshots!
>> >  - erasure coding
>> >  - more
>> >
>> > There will be a longer announcement on LKML/linux-fs in the near f=
uture
>> > (after
>> > I'm finished moving) - but I'd like to get it a bit more testing f=
rom a
>> > wider
>> > audience first, if possible.
>> >
>> > You need the bcache-dev branch, and the new bcache tools - be warn=
ed, this
>> > code
>> > is _not_ compatible with the upstream bcache on disk format:
>> >
>> > $ git clone -b bcache-dev http://evilpiepirate.org/git/linux-bcach=
e.git
>> > $ git clone -b dev http://evilpiepirate.org/git/bcache-tools.git
>> >
>> > Then do the usual compiling...
>> >
>> > # bcacheadm format -C /dev/sda1
>> > # mount /dev/sda1 /mnt
>> >
>> > The usual caveats apply - it might eat your data, the on disk form=
at has
>> > _not_
>> > been stabilized yet, etc. But it's been reasonably stable for me, =
and
>> > passes all
>> > but 2-3 of the supported xfstests.
>> >
>> > Try it out and let me know how it goes!
>> >
>> > Also, programmers please check out the bcache guide - feedback is
>> > appreciated:
>> >
>> > http://bcache.evilpiepirate.org/BcacheGuide/
>> >
>> > Thanks!
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-bc=
ache" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20

Denis
