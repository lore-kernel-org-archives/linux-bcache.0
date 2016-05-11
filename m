From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Wed, 11 May 2016 09:55:51 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1605110954310.31937@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm> <alpine.LNX.2.00.1605020916001.27942@cbobk.fhfr.pm> <alpine.LRH.2.11.1605101812240.22680@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbcEKHzw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 May 2016 03:55:52 -0400
In-Reply-To: <alpine.LRH.2.11.1605101812240.22680@mx.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Maciej Piechotka <uzytkownik2@gmail.com>

On Tue, 10 May 2016, Eric Wheeler wrote:

> > > bch_writeback_thread() is calling try_to_freeze(), but that's just an 
> > > expensive no-op given the fact that the thread is not marked freezable.
> > > 
> > > I/O helper kthreads, exactly such as the bcache writeback thread, actually 
> > > shouldn't be freezable, because they are potentially necessary for 
> > > finalizing the image write-out.
> > > 
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > Let's send a friendly ping on these three patches after two weeks...
> 
> Maciej,
> 
> Were you able to get a backtrace?

While I'd definitely like to understand the issues in interaction between 
hibernation and bcache Maciej is supposedly seeing, this shouldn't hold 
the application of the three patches in this series, as they are just a 
cleanup that doesn't affect the behavior of the code in question.

Thanks,

-- 
Jiri Kosina
SUSE Labs
