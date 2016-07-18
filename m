From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: untagle cache_aolloc
Date: Mon, 18 Jul 2016 02:28:54 -0800
Message-ID: <20160718102854.GA19374@kmo-pixel>
References: <1468836669-1136-1-git-send-email-jthumshirn@suse.de>
 <20160718101333.GA18961@kmo-pixel>
 <20160718102411.t5qm3t6hnjcjpbyr@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35717 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbcGRK27 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 18 Jul 2016 06:28:59 -0400
Content-Disposition: inline
In-Reply-To: <20160718102411.t5qm3t6hnjcjpbyr@c203.arch.suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@fb.com>, Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 18, 2016 at 12:24:11PM +0200, Johannes Thumshirn wrote:
> On Mon, Jul 18, 2016 at 02:13:33AM -0800, Kent Overstreet wrote:
> > On Mon, Jul 18, 2016 at 12:11:09PM +0200, Johannes Thumshirn wrote:
> > > bcache's cache_alloc() function currenty has no way freeing memory if one of
> > > the allocations fails. Untangle the if + allocation statement so we have
> > > defined checkpoints to free previous allocations if one fails.
> > 
> > nack. The existing error path handles failure midway through just fine.
> 
> Come on, the patch improves the readability of the if statement by some orders
> of magnitude as well.
> 
> Are you OK with it if I change the subject/commit log?

No, it's just churn and I don't agree that it improves readability. On the
contrary, now the cleanup code has to be duplicated in two places - which
invites them getting out of sync and introducing bugs.
