From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 24 Jul 2015 12:15:57 -0700
Message-ID: <20150724191557.GA1928@kmo-pixel>
References: <CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
 <20150717231700.GA4166@kmo-pixel>
 <1437176155.9009.0.camel@ssi>
 <20150717234023.GB4166@kmo-pixel>
 <1437176911.9298.0.camel@ssi>
 <20150717235133.GC4166@kmo-pixel>
 <1437177497.9298.3.camel@ssi>
 <20150718021007.GA3196@kmo-pixel>
 <1437196863.4737.2.camel@hasee>
 <CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34227 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbbGXTQE (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 24 Jul 2015 15:16:04 -0400
Received: by pdbbh15 with SMTP id bh15so17725708pdb.1
        for <linux-bcache@vger.kernel.org>; Fri, 24 Jul 2015 12:16:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Tue, Jul 21, 2015 at 10:11:11PM -0700, Ming Lin wrote:
> On Fri, Jul 17, 2015 at 10:21 PM, Ming Lin <mlin@kernel.org> wrote:
> > On Fri, 2015-07-17 at 19:10 -0700, Kent Overstreet wrote:
> >> BTW - probably the most valuable thing you could help out with is the
> >> documentation, in particular the guide:
> >> http://bcache.evilpiepirate.org/BcacheGuide/
> >>
> >> Can you read through (at least some of) that, and tell me what's useful and what
> >> needs clarifying? And tell me what you'd like to see added to the guide next -
> >> I'll try and work on documentation over the next two weeks, since I probably
> >> won't be able to do much real coding with my test machines offline.
> >
> > Yes, I'll read through that.
> 
> Would you add some example to explain how the extents/inodes/dirents are stored
> in the btree on disk?

Can you be more specific? Like how inodes/dirents map to keys in the btree, or
how it all ends up on disk?

The inodes/dirents code is pretty short, I'd look at inode.c and dirent.c

> I'm reading the debug code in drivers/md/bcache/debug.c.
> It seems helpful to learn about the internal btree structure.

Are you interested in more the format of the btree node itself, on disk? Like
struct btree_node, struct btree_node_entry, struct bset, and the packing?

I could try and elaborate on that in the guide, give me some specific questions
to cover if you've got any
