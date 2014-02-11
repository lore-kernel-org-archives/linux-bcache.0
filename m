From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] bcache: fix BUG_ON due to integer overflow with
 GC_SECTORS_USED
Date: Tue, 11 Feb 2014 10:14:31 -0800
Message-ID: <20140211181431.GA19110@kroah.com>
References: <20140211180257.GA26313@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36715 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbaBKSNR (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 11 Feb 2014 13:13:17 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id B2D2B2100D
	for <linux-bcache@vger.kernel.org>; Tue, 11 Feb 2014 13:13:16 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20140211180257.GA26313@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Darrick J. Wong" <kmo@daterainc.com>
Cc: stable@vger.kernel.org, linux-bcache@vger.kernel.org

On Tue, Feb 11, 2014 at 10:02:57AM -0800, Darrick J. Wong wrote:
> The BUG_ON at the end of __bch_btree_mark_key can be triggered due to
> an integer overflow error:
> 
> BITMASK(GC_SECTORS_USED, struct bucket, gc_mark, 2, 13);
> ...
> SET_GC_SECTORS_USED(g, min_t(unsigned,
> 	     GC_SECTORS_USED(g) + KEY_SIZE(k),
> 	     (1 << 14) - 1));
> BUG_ON(!GC_SECTORS_USED(g));
> 
> In bcache.h, the SECTORS_USED bitfield is defined to be 13 bits wide.
> While the SET_ code tries to ensure that the field doesn't overflow by
> clamping it to (1<<14)-1 == 16383, this is incorrect because 16383
> requires 14 bits.  Therefore, if GC_SECTORS_USED() + KEY_SIZE() =
> 8192, the SET_ statement tries to store 8192 into a 13-bit field.  In
> a 13-bit field, 8192 becomes zero, thus triggering the BUG_ON.
> 
> Therefore, create a field width constant and a max value constant, and
> use those to create the bitfield and check the inputs to
> SET_GC_SECTORS_USED.  Arguably the BITMASK() template ought to have
> BUG_ON checks for too-large values, but that's a separate patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> ---
> Greg, stable team et. all - can you apply this asap to 3.13? It hasn't hit
> Linus's tree yet (it's on its way via Jens), but multiple users are hitting this
> BUG_ON() and the fix has been tested.

Think about what you just wrote.

Then go read Documentation/stable_kernel_rules.txt.

You should know better...

greg k-h
