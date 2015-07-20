From: Denis Bychkov <manover@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Sun, 19 Jul 2015 22:52:09 -0400
Message-ID: <CAO2mnowmtws19urvHpUOk_6vT7NMOJ_Xge1N1fMy_-vSyXTVoA@mail.gmail.com>
References: <20150714005825.GA24027@kmo-pixel>
	<CACaajQtwx45r8GcRmchrQwDts1GH-V8g0x1FwGfDvnfm02bq+Q@mail.gmail.com>
	<20150714081105.GA18569@kmo-pixel>
	<CAO2mnowOYReY07-YT23J7jx51wTcjd9VG9-Zy5e2+qCK6Epa+Q@mail.gmail.com>
	<CAC7rs0uWSt85F443PRw1zvybccg+EfebaSyH9EhUwHjhTGryRA@mail.gmail.com>
	<CAC7rs0upqkuH1CPd-OAmrpQ=8PmaDpzHYY1MaBDpAL6TS_iKyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34200 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbbGTCwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 19 Jul 2015 22:52:10 -0400
Received: by obre1 with SMTP id e1so94572577obr.1
        for <linux-bcache@vger.kernel.org>; Sun, 19 Jul 2015 19:52:09 -0700 (PDT)
In-Reply-To: <CAC7rs0upqkuH1CPd-OAmrpQ=8PmaDpzHYY1MaBDpAL6TS_iKyw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Adam Berkan <adam.berkan@gmail.com>, linux-bcache@vger.kernel.org, Vasiliy Tolstov <v.tolstov@selfip.ru>, Michael Rubin <mrubin@google.com>, Slava Pestov <sviatoslavpestov@gmail.com>, zab@zabbo.net, Ricky Benitez <rickyb@google.com>

I don't think I found anything in the design description or anywhere
else explaining how tiering works and what data, when and why ends up
on the next tier. And how to control this. The old bcache has a pretty
advanced set of knobs allowing you to fine-tune this behavior
(read-ahead limit, sequential cutoff, congestion thresholds, etc.) If
I overlooked, please point me to the right direction.

On Sun, Jul 19, 2015 at 9:44 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> And yes, format ask drives as -C and use --tier for the slower drives=
=2E
>
> -B means an externally managed device - bcache doesn't remap anything=
 to it,
> it exposes a passthrough block device just so it can snoop on accesse=
s to it
> and cache them. The functionality still exists in the bcache codebase=
, but
> has no meaning in bcachefs land
>
> On Jul 19, 2015 6:41 PM, kent.overstreet@gmail.com wrote:
>>
>> Probably broken because I haven't tested them recently. Once I've un=
packed
>> my computers (in a few weeks) I'll debug it
>>
>> On Jul 19, 2015 6:11 PM, "Denis Bychkov" <manover@gmail.com> wrote:
>>>
>>> On Tue, Jul 14, 2015 at 4:11 AM, Kent Overstreet
>>> <kent.overstreet@gmail.com> wrote:
>>> > On Tue, Jul 14, 2015 at 09:05:39AM +0300, Vasiliy Tolstov wrote:
>>> >> Does it support discards?
>>> >
>>> >> Format command have one device, how provide tiering?
>>> >
>>> > --tier specifies the tier of the devices that come after it, wher=
e the
>>> > smaller
>>> > index is the faster tier.
>>> >
>>> > Only tiers 0 and 1 are supported for now, that will be increased
>>> > whenever
>>> > someone gets around to it.
>>> >
>>> > If /dev/sda is your fast device and /dev/sdb is your slow device,=
 run
>>> >
>>> > # bcacheadm format -C /dev/sda --tier 1 /dev/sdb
>>> >
>>> > bcacheadm format --help gives you the full list of options.
>>>
>>> Ok, I am really confused right now. So, the format utility still
>>> allows -B (backing device). Is it just an artifact left over after
>>> block caching? Because I could not make it work. Any thread
>>> encountering  the formatted backing device just hangs inside the
>>> kernel space until reboot. Is there something wrong with my setup o=
r
>>> backing devices are just an illusion, a figment of kernel's
>>> imagination? And, if not, how do they relate to tiers?
>>> Could you give a simple example of a usual setup - one small and fa=
st
>>> SSD and huge but slow RAID-6? Should I now format both partitions a=
s
>>> -C and assign tier 1 to RAID-6?
>>>
>>> >
>>> >> 14 =D0=B8=D1=8E=D0=BB=D1=8F 2015 =D0=B3. 3:58 =D0=BF=D0=BE=D0=BB=
=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C "Kent Overstreet=
" <
>>> >> kent.overstreet@gmail.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=
=BB:
>>> >>
>>> >> > Short announcement, because I'm in the process of moving - but=
 I
>>> >> > wanted to
>>> >> > get
>>> >> > this out there because the code is up and I think it's reasona=
bly
>>> >> > stable
>>> >> > right
>>> >> > now.
>>> >> >
>>> >> > Bcachefs is a posix filesystem that I've been working towards =
for -
>>> >> > well,
>>> >> > quite
>>> >> > awhile now: it's intended as a competitor/replacement for
>>> >> > ext4/xfs/btrfs.
>>> >> >
>>> >> > Current features
>>> >> >  - multiple devices
>>> >> >  - replication
>>> >> >  - tiering
>>> >> >  - data checksumming and compression (zlib only; also the code
>>> >> > doesn't
>>> >> > work with
>>> >> >    tiering yet)
>>> >> >  - most of the normal posix fs features (no fallocate or quota=
s yet)
>>> >> >
>>> >> > Planned features:
>>> >> >  - snapshots!
>>> >> >  - erasure coding
>>> >> >  - more
>>> >> >
>>> >> > There will be a longer announcement on LKML/linux-fs in the ne=
ar
>>> >> > future
>>> >> > (after
>>> >> > I'm finished moving) - but I'd like to get it a bit more testi=
ng
>>> >> > from a
>>> >> > wider
>>> >> > audience first, if possible.
>>> >> >
>>> >> > You need the bcache-dev branch, and the new bcache tools - be
>>> >> > warned, this
>>> >> > code
>>> >> > is _not_ compatible with the upstream bcache on disk format:
>>> >> >
>>> >> > $ git clone -b bcache-dev
>>> >> > http://evilpiepirate.org/git/linux-bcache.git
>>> >> > $ git clone -b dev http://evilpiepirate.org/git/bcache-tools.g=
it
>>> >> >
>>> >> > Then do the usual compiling...
>>> >> >
>>> >> > # bcacheadm format -C /dev/sda1
>>> >> > # mount /dev/sda1 /mnt
>>> >> >
>>> >> > The usual caveats apply - it might eat your data, the on disk =
format
>>> >> > has
>>> >> > _not_
>>> >> > been stabilized yet, etc. But it's been reasonably stable for =
me,
>>> >> > and
>>> >> > passes all
>>> >> > but 2-3 of the supported xfstests.
>>> >> >
>>> >> > Try it out and let me know how it goes!
>>> >> >
>>> >> > Also, programmers please check out the bcache guide - feedback=
 is
>>> >> > appreciated:
>>> >> >
>>> >> > http://bcache.evilpiepirate.org/BcacheGuide/
>>> >> >
>>> >> > Thanks!
>>> >> > --
>>> >> > To unsubscribe from this list: send the line "unsubscribe
>>> >> > linux-bcache" in
>>> >> > the body of a message to majordomo@vger.kernel.org
>>> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.=
html
>>> >> >
>>> > --
>>> > To unsubscribe from this list: send the line "unsubscribe linux-b=
cache"
>>> > in
>>> > the body of a message to majordomo@vger.kernel.org
>>> > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>>
>>>
>>> --
>>>
>>> Denis



--=20

Denis
