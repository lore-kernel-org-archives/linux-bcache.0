From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Wed, 7 Jan 2015 18:29:11 -0800
Message-ID: <20150108022911.GA1263@kmo-pixel>
References: <20141228023534.GA25860@cuci.nl>
 <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
 <54A81B78.2070409@rolffokkens.nl>
 <20150104004621.GA4460@kmo-pixel>
 <54A94A1C.9050906@rolffokkens.nl>
 <CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
 <54AC5F22.6040200@rolffokkens.nl>
 <20150107014850.GG26845@kmo-pixel>
 <CAB=cV2TCP5xfP3fjtZaREZCV=LDC0YN04qadgRegVUjESESZ6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54001 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbbAHC0m (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 7 Jan 2015 21:26:42 -0500
Received: by mail-qa0-f43.google.com with SMTP id v10so564625qac.2
        for <linux-bcache@vger.kernel.org>; Wed, 07 Jan 2015 18:26:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAB=cV2TCP5xfP3fjtZaREZCV=LDC0YN04qadgRegVUjESESZ6w@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jianjian Huo <samuel.huo@gmail.com>
Cc: Rolf Fokkens <rolf@rolffokkens.nl>, Slava Pestov <sp@datera.io>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On Wed, Jan 07, 2015 at 09:41:19AM -0800, Jianjian Huo wrote:
> Hi Kent,
> 
> On Tue, Jan 6, 2015 at 5:48 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> >
> > On Tue, Jan 06, 2015 at 11:18:10PM +0100, Rolf Fokkens wrote:
> > > On 01/05/2015 08:47 AM, Slava Pestov wrote:
> > > >The plan is to incrementally backport bug fixes and optimizations from
> > > >bcache-dev to upstream for the foreseeable future.
> > > I assume (hope) this won't break bcache w.r.t. the current block device
> > > layout?
> > > >The development branch is going through major changes to support
> > > >dynamically adding/removing cache devices
> > > Sound nices, that creates great flexibility. Does this also introduce the
> > > option of storing mirrored writeback data, while storing single copy read
> > > (cached) data (when having multiple SSD's as a cache)?
> >
> > Yup, and a lot more.
> >
> > > >and storing data in the btree instead of using it as a cache, enabling
> > > >usage without any backing devices.
> > > The needs some explanation. I assume you mean it operates as writeback bache
> > > that never flushes. If that's correct, I can only imagine it's useful when
> > > initially using it. And in that case seems a kind of a time bomb, because
> > > when it's "full" (and there's still no backing device)... what happens then?
> >
> > What Slava is alluding to is that bcache is becoming a full posix filesystem - I
> > was actually demoing it... nearly a year ago, I think. With eventual feature
> > parity with btrfs and much, much better performance.
> >
> 
> btrfs use COW b-tree shadowing to support snapshots and clones, what
> approach will this new bcache FS use to support those features?

bcache has always been COW for data, and it supports copy offload (i.e. btrfs
reflink) today via just multiple extents pointing to the same data.

I'll write up the plan for snapshots at some point, it's quite different from
the btrfs approach.

> And will this new FS continue to use 2MB buckets without random writes
> in them? if that's the case, when this new FS is used on SSDs only, I
> guess FS GC has to be turned on for all buckets to reclaim free space.
> Since a lot of SSDs use parallel writes, some use compression, it's
> not possible to align one logical 2MB bucket at FS level to one single
> physical NAND block, then GC will be performed twice for one dirty
> bucket at different levels, so SSD life will be cut in half in the
> worst case?

Yeah that is a potential issue, for SSDs what we really want is to get raw
access to flash and have bcache be the FTL. Even if that doesn't happen there
are things we can do to mitigate though, suffice it to say this issue has been
discussed a lot :)
