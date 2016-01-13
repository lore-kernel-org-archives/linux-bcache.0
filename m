From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache: remove driver private bio splitting code
Date: Wed, 13 Jan 2016 15:03:41 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1601131501290.24343@mail.ewheeler.net>
References: <1439363241-31772-1-git-send-email-mlin@kernel.org> <1439363241-31772-4-git-send-email-mlin@kernel.org> <alpine.LRH.2.11.1601071743540.14336@mail.ewheeler.net> <alpine.LRH.2.11.1601121759100.10151@mail.ewheeler.net>
 <20160113055400.GA32697@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:37778 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752174AbcAMXDs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 13 Jan 2016 18:03:48 -0500
In-Reply-To: <20160113055400.GA32697@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vojtech Pavlik <vojtech@suse.com>
Cc: linux-bcache@vger.kernel.org

> On Tue, Jan 12, 2016 at 06:00:49PM -0800, Eric Wheeler wrote:
> 
> Hello Eric,
> 
> > Have you tested the patch below in SLE12-* when bcache is backed by md
> > raid5/6?
> > 
> > FYI: I was compared the drivers/md/bcache/io.c functions in the various
> > branches here:
> >   https://github.com/openSUSE/kernel
> > I compared the presence of bch_generic_make_request() (which the patch
> > below removes).  It looks like the branch SLE12-SP2 has the patch, but
> > version before SLE12-SP2 and openSUSE-* do not (as they still have
> > bch_generic_make_request).
> > 
> > Since the patch does exist in SLE12-SP2, I'm guessing that is been tested,
> > though I am curious if it has been tested specifically when being backed
> > by md raid5/6 so that queue->limits->partial_stripes_expensive is nonzero.
> > 
> > If you have and it is stable, then I want to get it to Kent and Jens for 
> > upstream integration.
> 
> The SLES12-SP2 kernel branch is very fresh, created this week. So while
> the patch was tested by Johannes before adding it, and by our per-commit
> automated tests, it didn't go through fully qualified QA test cycle yet.
> So I won't say it's proven stable just yet.

Good to know, thank you for that!  

I encourage you to include md-based raid5/6 backed bcache volumes in your 
testing if it is not already.  This particular patch may affect that use 
case.  Please keep us posted, I look forward to learning about the 
bcache-specific test cycle results.

-Eric


> 
> -- 
> Vojtech Pavlik
> Director SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
