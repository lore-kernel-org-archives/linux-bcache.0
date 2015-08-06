From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Thu, 6 Aug 2015 15:58:34 -0700
Message-ID: <20150806225834.GA2459@kmo-pixel>
References: <20150717234023.GB4166@kmo-pixel>
 <1437176911.9298.0.camel@ssi>
 <20150717235133.GC4166@kmo-pixel>
 <1437177497.9298.3.camel@ssi>
 <20150718021007.GA3196@kmo-pixel>
 <1437196863.4737.2.camel@hasee>
 <CAF1ivSaqGRWruh8mePvFaKC9CSQB8xW7aAe872dao6J34v6iFg@mail.gmail.com>
 <20150724191557.GA1928@kmo-pixel>
 <1437770866.21988.16.camel@ssi>
 <CAF1ivSZhj2WuafP0yFey47OyAhjF7-Sznnb1WBXA+Hm5Rem31Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35686 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbHFW6j (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 6 Aug 2015 18:58:39 -0400
Received: by pdrg1 with SMTP id g1so37656496pdr.2
        for <linux-bcache@vger.kernel.org>; Thu, 06 Aug 2015 15:58:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAF1ivSZhj2WuafP0yFey47OyAhjF7-Sznnb1WBXA+Hm5Rem31Q@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Tue, Jul 28, 2015 at 11:41:52AM -0700, Ming Lin wrote:
> On Fri, Jul 24, 2015 at 1:47 PM, Ming Lin <mlin@kernel.org> wrote:
> >
> > And I want to learn how the btree node insert/delete/update happens on
> > disk. These maybe too detail. I'm going to write a small tool to dump
> > the file system. Then I could understand better the on disk btree
> > format.
> 
> Here is my simple tool to dump parts of the on-disk format.
> http://www.minggr.net/cgit/cgit.cgi/bcache-tools/commit/?id=deb258e2
> 
> It's not in good shape, but simple enough to learn the on-disk format.

Hey! Sorry for taking so long to respond, just got my computer set up back in
Alaska.

If you want to keep going with your tool, this might be a starting point for a
debugfs tool - which bcache definitely needs at some point.
