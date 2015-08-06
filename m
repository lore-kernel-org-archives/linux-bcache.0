From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Thu, 6 Aug 2015 16:59:09 -0700
Message-ID: <20150806235909.GA30757@moria.home.lan>
References: <20150717235133.GC4166@kmo-pixel>
 <1437177497.9298.3.camel@ssi>
 <20150718021007.GA3196@kmo-pixel>
 <1437196863.4737.2.camel@hasee>
 <CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
 <20150724191557.GA1928@kmo-pixel>
 <1437770866.21988.16.camel@ssi>
 <CAF1ivSZhj2WuafP0yFey47OyAhjF7-Sznnb1WBXA+Hm5Rem31Q@mail.gmail.com>
 <20150806225834.GA2459@kmo-pixel>
 <CAF1ivSa3RCaydtMWPGyuVo=+wR+siF_5x1sPUsCL6DiDS+7yhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36305 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbbHFX7O (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 6 Aug 2015 19:59:14 -0400
Received: by pdco4 with SMTP id o4so37976892pdc.3
        for <linux-bcache@vger.kernel.org>; Thu, 06 Aug 2015 16:59:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAF1ivSa3RCaydtMWPGyuVo=+wR+siF_5x1sPUsCL6DiDS+7yhA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Thu, Aug 06, 2015 at 04:27:51PM -0700, Ming Lin wrote:
> On Thu, Aug 6, 2015 at 3:58 PM, Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
> > On Tue, Jul 28, 2015 at 11:41:52AM -0700, Ming Lin wrote:
> >> On Fri, Jul 24, 2015 at 1:47 PM, Ming Lin <mlin@kernel.org> wrote:
> >> >
> >> > And I want to learn how the btree node insert/delete/update happens on
> >> > disk. These maybe too detail. I'm going to write a small tool to dump
> >> > the file system. Then I could understand better the on disk btree
> >> > format.
> >>
> >> Here is my simple tool to dump parts of the on-disk format.
> >> http://www.minggr.net/cgit/cgit.cgi/bcache-tools/commit/?id=deb258e2
> >>
> >> It's not in good shape, but simple enough to learn the on-disk format.
> >
> > Hey! Sorry for taking so long to respond, just got my computer set up back in
> > Alaska.
> >
> > If you want to keep going with your tool, this might be a starting point for a
> > debugfs tool - which bcache definitely needs at some point.
> 
> Yes, that's my goal.
> I'll improve it once I get more familiar with bcachefs on-disk format.

I imagine the sanest thing to do will be to reuse some of the kernel side code -
at the very least, the bkey packing code. That code is already pretty self
contained, and it's very algorithmic - no point in redoing it, and no real
reason to do it differently.

If it makes things easier, we could probably shuffle code around a bit so that
perhaps bkey.c contains only code that can be easily compiled in userspace.

I'm not sure if there's any other significant code that you'd want to use in
userspace - possibly the mergesort code (i.e.
bch_extent_sort_fix_overlapping()), but that code is going to be harder to lift
out and compile in userspace without changes.

Journal replay is going to be another major issue... the problem is, the btree
isn't up to date until you do journal replay, and the way bcache does journal
replay is with the same index update path that it uses at runtime - which
modifies the btree, i.e. it can't do journal replay without modifying what's on
disk.

We don't want the userspace debugfs tool to be modifying the disk image, so the
method bcache uses is right out.

The method I had in mind was that when you read the journal, you keep that list
of index updates to do around, in memory - then, when you read or are looking at
any given btree node, you iterate over all the keys in the journal replay list
and apply only the ones that apply to the current node. If the insertions don't
fit into the current node (i.e. if we would have to split the node if we were
doing a normal index update) - just grow the node in memory, since we're just
going to be tossing it out when we're done instead of writing out our changes.
