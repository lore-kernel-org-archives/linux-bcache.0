From: Denis Bychkov <manover@gmail.com>
Subject: Re: [PULL] Re: bcache stability patches
Date: Sat, 2 Jan 2016 10:48:04 -0500
Message-ID: <CAO2mnoz32T5Y8EijaO1oX4MbgNQC9_dRynS6e2Ka+3cd1_8eJA@mail.gmail.com>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
	<alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
	<56841B8B.6070306@kernel.dk>
	<20151231031500.GA8265@kmo-pixel>
	<5684A030.1040306@kernel.dk>
	<20151231051830.GB8265@kmo-pixel>
	<CAO2mnoyrPvUg+FQ1F-N5nz3v8BBb3UJUCjkhWTZc=MtHsEQDjA@mail.gmail.com>
	<20160101223659.GA12405@kmo-pixel>
	<CAO2mnox2TJAt4LyAghHowK3xMk121to5WccU_jRFjAMYz-ikxQ@mail.gmail.com>
	<20160102115058.GA8321@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35029 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbcABPsH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 2 Jan 2016 10:48:07 -0500
Received: by mail-lb0-f180.google.com with SMTP id bc4so142108320lbc.2
        for <linux-bcache@vger.kernel.org>; Sat, 02 Jan 2016 07:48:05 -0800 (PST)
In-Reply-To: <20160102115058.GA8321@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On Sat, Jan 2, 2016 at 6:50 AM, Vojtech Pavlik <vojtech@suse.com> wrote:
> On Fri, Jan 01, 2016 at 08:28:39PM -0500, Denis Bychkov wrote:
>
>> > We certainly can do all that, but: since new bcache can't read the old bcache
>> > format (I can go into why that's impractical, if people are curious) - that
>> > means there's a pretty high cost to switching to the new format:
>> >  - people have to manually upgrade
>> >  - the kernel would have to carry around both the old and the new
>> >    implementations of bcache for as long as people are using the old format -
>> >    we can't force people to upgrade
>>
>> Not that hard technically, you could just leave the existing bcache
>> module as-is to avoid regressions when adding the new format support,
>> since the existing code does not require a lot of maintenance and add
>> a new module that would only recognize a new superblock. Another
>> question is how easy it is to convince Linus/top maintainers to keep 2
>> modules with a lot of duplication with intention to retire the old
>> code eventually, but something tells me that you know ways around this
>> problem.
>
> We had that with the UHCI drivers, it is there with ext3/ext4, I don't
> think that is a real problem.
>
>> > So this isn't something we want to do more than once, which means we need to
>> > make sure the new on disk format is 100% done. And it's not quite done - the
>> > main thing that's left for it to really be considered done is big endian support
>> > and endian compatibility (writing the code so a little endian machine can read a
>> > big endian layout and vice versa; due to the way bkeys work it's not possible to
>> > just have an endian agnostic layout, we'll have to do swabbing).
>>
>> But this problem is not unique to bcache at all, AFAIK, almost any FS
>> linux supports would not be able to work on a different endianness
>> than it was created for.
>
> On the contrary, all modern filesystems cope with endianness
> portability. The only major filesystem in use where endianness is not
> handled is, as far I know, UFS.
>
> At the same time, I don't see endianness portability, the ability to
> create a cache on a machine with one endian and then mounting it on a
> machine with the opposite endian a real use case.
>
> Unlike fileystems, which can be used to transfer valuable data between
> machines, the cache only contains ephemeral data, which can easily be
> recreated from the backing device.
>
> Hence I believe that it is reasonable to require the user to nuke the
> contents of the cache when moving the cache set between machines of
> different endianity.
>
> Ideally this would happen automatically and error out if the cache isn't
> clean.
>
> Actually, the same would be fine for format version changes.

Yeah, I totally agree with you here. I just think that dirty cache
situation might be much more common and less avoidable, which means it
requires a lot of dancing around in terms of tooling, documentation,
testing, etc. But it can easily be solved, it's not a hard problem,
it's just time-consuming and this is something that Kent might use
some help with.

>
>> > And this isn't a trivial amount of work - and besides finishing the on disk
>> > format, there's a fair amount of work on tooling and related stuff to make sure
>> > everything is ready for the switch.
>> >
>> > And, I can't work for free, so somehow funding has to be secured. Given the
>> > number of companies that are using bcache, and the fact that Canonical and SuSe
>> > are both apparantly putting in at least a little bit of engineering time into
>> > supporting bcache, you'd think it should be possible but offers have not been
>> > forthcoming.
>>
>> I don't know, IMHO bcache was hurt a lot because of a host of small
>> problems that nobody was able to address for quite some time. It
>> gained a bad reputation as a production system, unfortunately, which
>> means not much interest from the enterprise world, which means
>> Canonical & co. did not want to invest into it. Don't get me wrong, I
>> am not blaming you. Of all people, I might understand pretty well what
>> was going on, just explaining why RH or Canonical or Suse did not
>> fight for the privilege to financially support this project.
>
> SUSE had plans for bcache, however, since upstram stable branch
> maintenance has been more than unreliable, we postponed most of them and
> are building knowledge in-house to be able to fully support it before we
> deploy.

Yeah, I was able to deduce that much. Not good.

 >
> The structure of the code doesn't really help, either.
>
> --
> Vojtech Pavlik
> Director SUSE Labs



-- 

Denis
