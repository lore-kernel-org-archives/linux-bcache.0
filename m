From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 17 Jul 2015 19:12:45 -0700
Message-ID: <20150718021245.GB3196@kmo-pixel>
References: <20150714005825.GA24027@kmo-pixel>
 <CAO2mnowhZLM45iSYmLCFZKESrNgKCeRPR7io_tQKoU0u2SYm+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34366 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbbGRCMu (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Jul 2015 22:12:50 -0400
Received: by pdbbh15 with SMTP id bh15so24566306pdb.1
        for <linux-bcache@vger.kernel.org>; Fri, 17 Jul 2015 19:12:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAO2mnowhZLM45iSYmLCFZKESrNgKCeRPR7io_tQKoU0u2SYm+Q@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Denis Bychkov <manover@gmail.com>
Cc: linux-bcache@vger.kernel.org, sviatoslavpestov@gmail.com, mrubin@google.com, adam.berkan@gmail.com, zab@zabbo.net, rickyb@google.com

On Fri, Jul 17, 2015 at 08:01:43PM -0400, Denis Bychkov wrote:
> Hi,
> 
> I actually tried to compile that code recently (maybe 5 days ago) and
> it did not change since then. There was a bunch of trivial errors,
> that I was able to fix - files moved around without #include updated,
> types missing. But at some point I ran into something definitely
> non-trivial: there is a variable in io.c, which is supposed to have a
> node id in it, but the init code commented out and there is no obvious
> way to fix it. So I gave up. I definitely tried the branch you are
> talking about - bcache-dev.

It didn't build? Weird - can you post some of the compiler errors you were
seeing, as well as your archictecture/gcc version? I don't know of any build
errors right now...

> 
> Here is the I code I mentioned:
> 
> static void bch_read_retry(struct bbio *bbio)
> {
> struct bio *bio = &bbio->bio;
> struct bio *parent;
> u64 inode;
> 
> trace_bcache_read_retry(bio);
> 
> /*
> * This used to be a leaf bio from bch_read_fn(), but
> * since we don't know what happened to the btree in
> * the meantime, we have to re-submit it via the
> * top-level bch_read() entry point. Before doing that,
> * we have to reset the bio, preserving the biovec.
> *
> * The inode, offset and size come from the bbio's key,
> * which was set by bch_read_fn().
> */
> //inode = bbio->key.k.p.inode;
> parent = bio->bi_private;
> 
> bch_bbio_reset(bbio);
> bio_chain(bio, parent);
> 
> bch_read(bbio->ca->set, bio, inode);
> bio_endio(parent, 0);  /* for bio_chain() in bch_read_fn() */
> bio_endio(bio, 0);
> }

The read retry path is currently non functional, since I added
checksumming/compression support - the read path needs a fair bit more work. But
that shouldn't cause a build error - and the race the retry path is for is damn
near impossible to trigger without fault injection (I don't think I've ever seen
it happen without fault injection).
