From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Tue, 24 May 2016 16:20:32 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1605241619530.31937@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm> <alpine.LNX.2.00.1605020916001.27942@cbobk.fhfr.pm> <alpine.LNX.2.00.1605181727480.31937@cbobk.fhfr.pm> <alpine.LNX.2.00.1605240103090.31937@cbobk.fhfr.pm> <574462C5.40307@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbcEXOUd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 24 May 2016 10:20:33 -0400
In-Reply-To: <574462C5.40307@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Wheeler <bcache@lists.ewheeler.net>

On Tue, 24 May 2016, Jens Axboe wrote:

> > Ok, I call it officially ridiculous now. I guess I'll be resending through
> > akpm.
> 
> You can just send it to me, I've funneled bcache stable fixes before.
> 
> > Is it a time to claim (by MAINTAINERS entry) the in-tree bcache orphaned?
> 
> I think so.

Ok, thanks. I'll add another patch to the series that does this change and 
send it your way later today.

-- 
Jiri Kosina
SUSE Labs
