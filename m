From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PULL] Re: bcache stability patches
Date: Sat, 2 Jan 2016 15:12:24 -0900
Message-ID: <20160103001224.GB1180@kmo-pixel>
References: <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
 <56841B8B.6070306@kernel.dk>
 <20151231031500.GA8265@kmo-pixel>
 <5684A030.1040306@kernel.dk>
 <20151231051830.GB8265@kmo-pixel>
 <CAO2mnoyrPvUg+FQ1F-N5nz3v8BBb3UJUCjkhWTZc=MtHsEQDjA@mail.gmail.com>
 <20160101223659.GA12405@kmo-pixel>
 <CAO2mnox2TJAt4LyAghHowK3xMk121to5WccU_jRFjAMYz-ikxQ@mail.gmail.com>
 <20160102115058.GA8321@suse.com>
 <CAO2mnoz32T5Y8EijaO1oX4MbgNQC9_dRynS6e2Ka+3cd1_8eJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35889 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbcACAM2 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 2 Jan 2016 19:12:28 -0500
Received: by mail-pa0-f47.google.com with SMTP id yy13so85874154pab.3
        for <linux-bcache@vger.kernel.org>; Sat, 02 Jan 2016 16:12:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAO2mnoz32T5Y8EijaO1oX4MbgNQC9_dRynS6e2Ka+3cd1_8eJA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Denis Bychkov <manover@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.com>, linux-bcache@vger.kernel.org

On Sat, Jan 02, 2016 at 10:48:04AM -0500, Denis Bychkov wrote:
> On Sat, Jan 2, 2016 at 6:50 AM, Vojtech Pavlik <vojtech@suse.com> wrote:
> > On the contrary, all modern filesystems cope with endianness
> > portability. The only major filesystem in use where endianness is not
> > handled is, as far I know, UFS.
> >
> > At the same time, I don't see endianness portability, the ability to
> > create a cache on a machine with one endian and then mounting it on a
> > machine with the opposite endian a real use case.
> >
> > Unlike fileystems, which can be used to transfer valuable data between
> > machines, the cache only contains ephemeral data, which can easily be
> > recreated from the backing device.
> >
> > Hence I believe that it is reasonable to require the user to nuke the
> > contents of the cache when moving the cache set between machines of
> > different endianity.
> >
> > Ideally this would happen automatically and error out if the cache isn't
> > clean.
> >
> > Actually, the same would be fine for format version changes.
> 
> Yeah, I totally agree with you here. I just think that dirty cache
> situation might be much more common and less avoidable, which means it
> requires a lot of dancing around in terms of tooling, documentation,
> testing, etc. But it can easily be solved, it's not a hard problem,
> it's just time-consuming and this is something that Kent might use
> some help with.

The bcache2 on disk format is the same on disk format as bcachefs - so I do want
to get endian portability done right.

It shouldn't be an outrageous amount of work though, the biggest hassle is just
going to be getting a test environment set up.

> >> > And this isn't a trivial amount of work - and besides finishing the on disk
> >> > format, there's a fair amount of work on tooling and related stuff to make sure
> >> > everything is ready for the switch.
> >> >
> >> > And, I can't work for free, so somehow funding has to be secured. Given the
> >> > number of companies that are using bcache, and the fact that Canonical and SuSe
> >> > are both apparantly putting in at least a little bit of engineering time into
> >> > supporting bcache, you'd think it should be possible but offers have not been
> >> > forthcoming.
> >>
> >> I don't know, IMHO bcache was hurt a lot because of a host of small
> >> problems that nobody was able to address for quite some time. It
> >> gained a bad reputation as a production system, unfortunately, which
> >> means not much interest from the enterprise world, which means
> >> Canonical & co. did not want to invest into it. Don't get me wrong, I
> >> am not blaming you. Of all people, I might understand pretty well what
> >> was going on, just explaining why RH or Canonical or Suse did not
> >> fight for the privilege to financially support this project.
> >
> > SUSE had plans for bcache, however, since upstram stable branch
> > maintenance has been more than unreliable, we postponed most of them and
> > are building knowledge in-house to be able to fully support it before we
> > deploy.

The biggest reason for maintainence dropping off was me going off to a certain
startup that shall not be named, which ended up being fairly all-consuming, and
left me pretty burned out in the end. I'm not going to revisit that topic right
now, except to say that upstream maintainence is not the only reason I have
mixed feelings about that decision...

I do want to say though that I never knew Suse or Canonical engineers were ever
looking at the code or that either companies were ever considering supporting it
- if I had, I would've certainly made an effort to work with your engineers on
getting them up to speed.

Anyways, what's done is done but if the demand is there I'd really like to see
the codebase live a long happy life, and figure out if we can make that happen
now.
