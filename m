From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Tue, 14 Jul 2015 01:11:05 -0700
Message-ID: <20150714081105.GA18569@kmo-pixel>
References: <20150714005825.GA24027@kmo-pixel>
 <CACaajQtwx45r8GcRmchrQwDts1GH-V8g0x1FwGfDvnfm02bq+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34919 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbGNILJ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 14 Jul 2015 04:11:09 -0400
Received: by pactm7 with SMTP id tm7so1790150pac.2
        for <linux-bcache@vger.kernel.org>; Tue, 14 Jul 2015 01:11:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CACaajQtwx45r8GcRmchrQwDts1GH-V8g0x1FwGfDvnfm02bq+Q@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: zab@zabbo.net, linux-bcache@vger.kernel.org, rickyb@google.com, mrubin@google.com, sviatoslavpestov@gmail.com, adam.berkan@gmail.com

On Tue, Jul 14, 2015 at 09:05:39AM +0300, Vasiliy Tolstov wrote:
> Does it support discards?

Yes

> Does this announce means that bcache block device
> no longer maintained by developers?

There's no plural, it's just me :)

I've been overly stressed and burned out from a startup gone horribly w=
rong -
I'm going to try to start doing some maintainence of upstream bcache ag=
ain once
I've moved.

I apologize for my absence on the list these past months, I've had (and=
 still
have) entirely too much to juggle - hint hint, if anyone wants to jump =
in and
help out.

> What about performance tests with compared to plain btrfs/ext4?

I haven't done much comparison benchmarking yet, I'll post them once I =
have. If
anyone else wants to do some benchmarking I'd love to see the results.

(From the testing I have done - untarring the kernel (on a fast device,=
 with the
tar file already uncompressed and in kernel so we're purely cpu bound) =
-
bcachefs is equal to ext4 to within the margin of error. On dbench when=
 we're
purely cpu bound, bcachefs is roughly 30% off from ext4. I think the ma=
jority of
that is bcachefs's dirent code being somewhat cpu heavy).

The long term goal is to be at least as fast on ext4/xfs for any given =
workload,
and on typical workloads we ought to be faster - and in particular bcac=
hefs
should have better and more predictable latency, due to the way journal=
ling
works.

> Format command have one device, how provide tiering?

--tier specifies the tier of the devices that come after it, where the =
smaller
index is the faster tier.

Only tiers 0 and 1 are supported for now, that will be increased whenev=
er
someone gets around to it.

If /dev/sda is your fast device and /dev/sdb is your slow device, run

# bcacheadm format -C /dev/sda --tier 1 /dev/sdb

bcacheadm format --help gives you the full list of options.

> 14 =D0=B8=D1=8E=D0=BB=D1=8F 2015 =D0=B3. 3:58 =D0=BF=D0=BE=D0=BB=D1=8C=
=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C "Kent Overstreet" <
> kent.overstreet@gmail.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB=
:
>=20
> > Short announcement, because I'm in the process of moving - but I wa=
nted to
> > get
> > this out there because the code is up and I think it's reasonably s=
table
> > right
> > now.
> >
> > Bcachefs is a posix filesystem that I've been working towards for -=
 well,
> > quite
> > awhile now: it's intended as a competitor/replacement for ext4/xfs/=
btrfs.
> >
> > Current features
> >  - multiple devices
> >  - replication
> >  - tiering
> >  - data checksumming and compression (zlib only; also the code does=
n't
> > work with
> >    tiering yet)
> >  - most of the normal posix fs features (no fallocate or quotas yet=
)
> >
> > Planned features:
> >  - snapshots!
> >  - erasure coding
> >  - more
> >
> > There will be a longer announcement on LKML/linux-fs in the near fu=
ture
> > (after
> > I'm finished moving) - but I'd like to get it a bit more testing fr=
om a
> > wider
> > audience first, if possible.
> >
> > You need the bcache-dev branch, and the new bcache tools - be warne=
d, this
> > code
> > is _not_ compatible with the upstream bcache on disk format:
> >
> > $ git clone -b bcache-dev http://evilpiepirate.org/git/linux-bcache=
=2Egit
> > $ git clone -b dev http://evilpiepirate.org/git/bcache-tools.git
> >
> > Then do the usual compiling...
> >
> > # bcacheadm format -C /dev/sda1
> > # mount /dev/sda1 /mnt
> >
> > The usual caveats apply - it might eat your data, the on disk forma=
t has
> > _not_
> > been stabilized yet, etc. But it's been reasonably stable for me, a=
nd
> > passes all
> > but 2-3 of the supported xfstests.
> >
> > Try it out and let me know how it goes!
> >
> > Also, programmers please check out the bcache guide - feedback is
> > appreciated:
> >
> > http://bcache.evilpiepirate.org/BcacheGuide/
> >
> > Thanks!
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bca=
che" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
