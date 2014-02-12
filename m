From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] bcache: fix BUG_ON due to integer overflow with
 GC_SECTORS_USED
Date: Tue, 11 Feb 2014 18:09:25 -0800
Message-ID: <20140212020925.GA24805@birch.djwong.org>
References: <20140211180257.GA26313@kmo>
 <20140211181431.GA19110@kroah.com>
 <20140211181805.GA11655@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46266 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBLCJb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 11 Feb 2014 21:09:31 -0500
Content-Disposition: inline
In-Reply-To: <20140211181805.GA11655@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Greg KH <greg@kroah.com>, stable@vger.kernel.org, linux-bcache@vger.kernel.org

On Tue, Feb 11, 2014 at 10:18:05AM -0800, Kent Overstreet wrote:
> On Tue, Feb 11, 2014 at 10:14:31AM -0800, Greg KH wrote:
> > On Tue, Feb 11, 2014 at 10:02:57AM -0800, Darrick J. Wong wrote:
> > > The BUG_ON at the end of __bch_btree_mark_key can be triggered due to
> > > an integer overflow error:
> > > 
> > > BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, 13);
> > > ...
> > > SET_GC_SECTORS_USED(g, min_t(unsigned,
> > > 	     GC_SECTORS_USED(g) + KEY_SIZE(k),
> > > 	     (1 << 14) - 1));
> > > BUG_ON(!GC_SECTORS_USED(g));
> > > 
> > > In bcache.h, the SECTORS_USED bitfield is defined to be 13 bits wide.
> > > While the SET_ code tries to ensure that the field doesn't overflow by
> > > clamping it to (1<<14)-1 == 16383, this is incorrect because 16383
> > > requires 14 bits.  Therefore, if GC_SECTORS_USED() + KEY_SIZE() =
> > > 8192, the SET_ statement tries to store 8192 into a 13-bit field.  In
> > > a 13-bit field, 8192 becomes zero, thus triggering the BUG_ON.
> > > 
> > > Therefore, create a field width constant and a max value constant, and
> > > use those to create the bitfield and check the inputs to
> > > SET_GC_SECTORS_USED.  Arguably the BITMASK() template ought to have
> > > BUG_ON checks for too-large values, but that's a separate patch.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> > > ---
> > > Greg, stable team et. all - can you apply this asap to 3.13? It hasn't hit
> > > Linus's tree yet (it's on its way via Jens), but multiple users are hitting this
> > > BUG_ON() and the fix has been tested.
> > 
> > Think about what you just wrote.
> > 
> > Then go read Documentation/stable_kernel_rules.txt.
> > 
> > You should know better...
> 
> I figured if any patch qualified for skipping ahead this one would - and it
> always takes awhile for stuff to make it through Jens, but ah well.
> 
> It's 947174476701fbc84ea8c7ec9664270f9d80b076, currently in Jens' for-linus
> tree, I'll ping you again when I see it go in since I forgot to add the stable
> tag to the patch.

You might want to fix the From: header as well... ;)

--D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
