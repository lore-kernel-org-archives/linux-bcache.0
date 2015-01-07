From: Jianjian Huo <samuel.huo@gmail.com>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Wed, 7 Jan 2015 09:41:19 -0800
Message-ID: <CAB=cV2TCP5xfP3fjtZaREZCV=LDC0YN04qadgRegVUjESESZ6w@mail.gmail.com>
References: <20141228023534.GA25860@cuci.nl>
	<CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
	<54A81B78.2070409@rolffokkens.nl>
	<20150104004621.GA4460@kmo-pixel>
	<54A94A1C.9050906@rolffokkens.nl>
	<CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
	<54AC5F22.6040200@rolffokkens.nl>
	<20150107014850.GG26845@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57504 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbbAGRlU (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 7 Jan 2015 12:41:20 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so4973631ieb.7
        for <linux-bcache@vger.kernel.org>; Wed, 07 Jan 2015 09:41:20 -0800 (PST)
In-Reply-To: <20150107014850.GG26845@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Rolf Fokkens <rolf@rolffokkens.nl>, Slava Pestov <sp@datera.io>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

Hi Kent,

On Tue, Jan 6, 2015 at 5:48 PM, Kent Overstreet <kmo@daterainc.com> wrote:
>
> On Tue, Jan 06, 2015 at 11:18:10PM +0100, Rolf Fokkens wrote:
> > On 01/05/2015 08:47 AM, Slava Pestov wrote:
> > >The plan is to incrementally backport bug fixes and optimizations from
> > >bcache-dev to upstream for the foreseeable future.
> > I assume (hope) this won't break bcache w.r.t. the current block device
> > layout?
> > >The development branch is going through major changes to support
> > >dynamically adding/removing cache devices
> > Sound nices, that creates great flexibility. Does this also introduce the
> > option of storing mirrored writeback data, while storing single copy read
> > (cached) data (when having multiple SSD's as a cache)?
>
> Yup, and a lot more.
>
> > >and storing data in the btree instead of using it as a cache, enabling
> > >usage without any backing devices.
> > The needs some explanation. I assume you mean it operates as writeback bache
> > that never flushes. If that's correct, I can only imagine it's useful when
> > initially using it. And in that case seems a kind of a time bomb, because
> > when it's "full" (and there's still no backing device)... what happens then?
>
> What Slava is alluding to is that bcache is becoming a full posix filesystem - I
> was actually demoing it... nearly a year ago, I think. With eventual feature
> parity with btrfs and much, much better performance.
>

btrfs use COW b-tree shadowing to support snapshots and clones, what
approach will this new bcache FS use to support those features?

And will this new FS continue to use 2MB buckets without random writes
in them? if that's the case, when this new FS is used on SSDs only, I
guess FS GC has to be turned on for all buckets to reclaim free space.
Since a lot of SSDs use parallel writes, some use compression, it's
not possible to align one logical 2MB bucket at FS level to one single
physical NAND block, then GC will be performed twice for one dirty
bucket at different levels, so SSD life will be cut in half in the
worst case?

> None of the existing functionality is going away either, it'll just be faster
> and more robust.
>
> > >We're actively working on this code and doing a lot of stress testing of
> > >both the new stuff and backing device support. However, it's its too early
> > >to tell what the new features will look like by the time they're ready to
> > >go upstream, or what a transition plan will look like for existing
> > >installs. I wish we had more time for upstreaming stuff, but I can assure
> > >you its not Kent's intent to just dump bcache-dev as one huge pull request
> > >:-)
> > As an ethousiastic bcache user myself I would be very happy if there's a
> > transition plan! :-)
>
> The exact transition plan is really up in the air, but for just caching backing
> devices you'll always be able to detach the cache set, reformat the cache set
> while using your backing device in passthrough mode, and then reattach.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Jianjian
