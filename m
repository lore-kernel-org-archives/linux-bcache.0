From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Wed, 20 Apr 2016 00:25:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1604200021570.27368@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm> <alpine.LRH.2.11.1604192050290.16630@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbcDSWZT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 19 Apr 2016 18:25:19 -0400
In-Reply-To: <alpine.LRH.2.11.1604192050290.16630@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Maciej Piechotka <uzytkownik2@gmail.com>

On Tue, 19 Apr 2016, Eric Wheeler wrote:

> > bch_writeback_thread() is calling try_to_freeze(), but that's just an 
> > expensive no-op given the fact that the thread is not marked freezable.
> > 
> > I/O helper kthreads, exactly such as the bcache writeback thread, actually 
> > shouldn't be freezable, because they are potentially necessary for 
> > finalizing the image write-out.
> 
> This is good timing, as Maciej Piechotka just reported a hang when 
> suspending his system.

Could you please point me to the actual report? Thanks.

> What is the proper way to safely support suspend?  Assuming the 
> try_to_freeze() calls are in the right place, should we simply 
> set_freezable() on these kthreads?

Unfortunately, this is really a tricky question; the issue is that frezing 
semantics is rather undefined for kthreads. For starters, please see

	https://lwn.net/Articles/662703/
	http://lkml.org/lkml/2007/4/27/608

I don't belive in freezable kthreads which serve as I/O helpers. Such 
threads simply have to keep going until the image is written out and 
machine powered down.

So I'd like to start with understanding how bcache is preventning suspend. 
Maciej?

Thanks,

-- 
Jiri Kosina
SUSE Labs
