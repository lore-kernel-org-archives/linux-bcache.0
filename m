From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: bcache: remove driver private bio splitting code
Date: Wed, 13 Jan 2016 06:54:00 +0100
Message-ID: <20160113055400.GA32697@suse.com>
References: <1439363241-31772-1-git-send-email-mlin@kernel.org>
 <1439363241-31772-4-git-send-email-mlin@kernel.org>
 <alpine.LRH.2.11.1601071743540.14336@mail.ewheeler.net>
 <alpine.LRH.2.11.1601121759100.10151@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:38080 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbcAMFyE (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 13 Jan 2016 00:54:04 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1601121759100.10151@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Tue, Jan 12, 2016 at 06:00:49PM -0800, Eric Wheeler wrote:

Hello Eric,

> Have you tested the patch below in SLE12-* when bcache is backed by md
> raid5/6?
> 
> FYI: I was compared the drivers/md/bcache/io.c functions in the various
> branches here:
>   https://github.com/openSUSE/kernel
> I compared the presence of bch_generic_make_request() (which the patch
> below removes).  It looks like the branch SLE12-SP2 has the patch, but
> version before SLE12-SP2 and openSUSE-* do not (as they still have
> bch_generic_make_request).
> 
> Since the patch does exist in SLE12-SP2, I'm guessing that is been tested,
> though I am curious if it has been tested specifically when being backed
> by md raid5/6 so that queue->limits->partial_stripes_expensive is nonzero.
> 
> If you have and it is stable, then I want to get it to Kent and Jens for 
> upstream integration.

The SLES12-SP2 kernel branch is very fresh, created this week. So while
the patch was tested by Johannes before adding it, and by our per-commit
automated tests, it didn't go through fully qualified QA test cycle yet.
So I won't say it's proven stable just yet.

-- 
Vojtech Pavlik
Director SUSE Labs
