From: Denis Bychkov <manover@gmail.com>
Subject: Re: [PULL] Re: bcache stability patches
Date: Thu, 31 Dec 2015 16:19:03 -0500
Message-ID: <CAO2mnoyrPvUg+FQ1F-N5nz3v8BBb3UJUCjkhWTZc=MtHsEQDjA@mail.gmail.com>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
	<alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
	<56841B8B.6070306@kernel.dk>
	<20151231031500.GA8265@kmo-pixel>
	<5684A030.1040306@kernel.dk>
	<20151231051830.GB8265@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35629 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbLaVTF (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 31 Dec 2015 16:19:05 -0500
Received: by mail-lb0-f180.google.com with SMTP id bc4so130600013lbc.2
        for <linux-bcache@vger.kernel.org>; Thu, 31 Dec 2015 13:19:04 -0800 (PST)
In-Reply-To: <20151231051830.GB8265@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Thu, Dec 31, 2015 at 12:18 AM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> On Wed, Dec 30, 2015 at 08:25:36PM -0700, Jens Axboe wrote:
>> On 12/30/2015 08:15 PM, Kent Overstreet wrote:
>> >On Wed, Dec 30, 2015 at 10:59:39AM -0700, Jens Axboe wrote:
>> >>Looking over these, most are really simple one-liners, and nothing sticks
>> >>out as being overly complicated. Kent, do you have any plans to maintain the
>> >>in-kernel bcache?
>> >
>> >Yeah - these patches are all fine, go ahead and pull.
>>
>> Great, thanks.
>>
>> >I may start doing maintainence again at some point (but if there's someone
>> >willing to step up and take over and do a good job of it, I'd gladly hand things
>> >off)
>>
>> As long as we have a path into mainline for stability fixes, at least that's
>> better than before.
>
> I'd really like to get the improvements from the bcache-dev branch upstream -
> there's a lot of _huge_ improvements (performance and otherwise), but
> backporting the non on disk format changes has turned out to be... not really
> practical.
>
> So one of the major obstacles has been that there's a ton of very worthwhile
> code I'd really like to get upstream, but at this point it's pretty much going
> to have to be as drivers/md/bcache2 - effectively a fork that wouldn't support
> the original on disk format. And that's a high hurdle.

Hey Kent,

Why is it so important to keep the same on-disk format? We are are
talking about the
caching device, not the backing device (which does not have its own
on-disk layout, it's
just the layout of the FS it backs, correct?)
So what's so big of a deal if the caching device format changes? You
just disconnect the cache set
before the upgrade, flushing all the cached data that is not on the
backing device, disable caching for
this device (bcache can work without the caching device in
write-through mode), then upgrade the
kernel and re-create the caching device with the new format. Yes, all
you cache is invalidated, but it
will take few days or, in case of very intensive use/lots of new data,
even few hours. And those who
can't tolerate this warm-up period can stick with the old code. But,
if you say there is A LOT of performance
improvements, it definitely should be worth it.
It's not like you are going to lose your backing device data, only
invalidate the cache.
So, can you please tell me where I am wrong here and why can't we do this?

> If the user community is willing to step up and help out (and realistically,
> that'd have to include financial support) - that's probably what I'd like to see
> happen. But it's a non trivial amount of work to get sufficient testing and to
> get the new on disk format stabilized enough to go upstream.

Speaking for myself I can help with maintenance/coding/unit test
writing/code reviewing.
I realize, you have no idea about my skills, but I do have some
experience with low level/
systems programming. I don't have a lot of DEEP knowledge about linux
kernel, but I did a lot of
driver-related programming back in the day, when memory was a scarce
resource (OS/2 in 90s :).
It was long ago, I admit, but I can learn pretty quick and, besides,
can help with some trivial stuff
like regression tests/debugging, etc


>
>> Thanks Eric for collecting these. I've reformatted some of them a bit, not
>> sure if that's github crappery, or if they came like that. It's pushed out
>> now.
>
> Thanks Eric - and let me know if you'd be willing to take on more maintainence
> work, I may have had some more patches in my backlog and we could talk about
> testing.

-- 

Denis
