From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Tue, 6 Jan 2015 17:48:50 -0800
Message-ID: <20150107014850.GG26845@kmo-pixel>
References: <20141228023534.GA25860@cuci.nl>
 <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
 <54A81B78.2070409@rolffokkens.nl>
 <20150104004621.GA4460@kmo-pixel>
 <54A94A1C.9050906@rolffokkens.nl>
 <CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
 <54AC5F22.6040200@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32981 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbbAGBqR (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 6 Jan 2015 20:46:17 -0500
Received: by mail-pa0-f44.google.com with SMTP id et14so1476337pad.3
        for <linux-bcache@vger.kernel.org>; Tue, 06 Jan 2015 17:46:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <54AC5F22.6040200@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: Slava Pestov <sp@datera.io>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On Tue, Jan 06, 2015 at 11:18:10PM +0100, Rolf Fokkens wrote:
> On 01/05/2015 08:47 AM, Slava Pestov wrote:
> >The plan is to incrementally backport bug fixes and optimizations from
> >bcache-dev to upstream for the foreseeable future.
> I assume (hope) this won't break bcache w.r.t. the current block device
> layout?
> >The development branch is going through major changes to support
> >dynamically adding/removing cache devices
> Sound nices, that creates great flexibility. Does this also introduce the
> option of storing mirrored writeback data, while storing single copy read
> (cached) data (when having multiple SSD's as a cache)?

Yup, and a lot more.

> >and storing data in the btree instead of using it as a cache, enabling
> >usage without any backing devices.
> The needs some explanation. I assume you mean it operates as writeback bache
> that never flushes. If that's correct, I can only imagine it's useful when
> initially using it. And in that case seems a kind of a time bomb, because
> when it's "full" (and there's still no backing device)... what happens then?

What Slava is alluding to is that bcache is becoming a full posix filesystem - I
was actually demoing it... nearly a year ago, I think. With eventual feature
parity with btrfs and much, much better performance.

None of the existing functionality is going away either, it'll just be faster
and more robust.

> >We're actively working on this code and doing a lot of stress testing of
> >both the new stuff and backing device support. However, it's its too early
> >to tell what the new features will look like by the time they're ready to
> >go upstream, or what a transition plan will look like for existing
> >installs. I wish we had more time for upstreaming stuff, but I can assure
> >you its not Kent's intent to just dump bcache-dev as one huge pull request
> >:-)
> As an ethousiastic bcache user myself I would be very happy if there's a
> transition plan! :-)

The exact transition plan is really up in the air, but for just caching backing
devices you'll always be able to detach the cache set, reformat the cache set
while using your backing device in passthrough mode, and then reattach.
