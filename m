From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Mon, 2 May 2016 09:16:51 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1605020916001.27942@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbcEBHQ4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 2 May 2016 03:16:56 -0400
In-Reply-To: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Wheeler <bcache@lists.ewheeler.net>

On Tue, 19 Apr 2016, Jiri Kosina wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> 
> bch_writeback_thread() is calling try_to_freeze(), but that's just an 
> expensive no-op given the fact that the thread is not marked freezable.
> 
> I/O helper kthreads, exactly such as the bcache writeback thread, actually 
> shouldn't be freezable, because they are potentially necessary for 
> finalizing the image write-out.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Let's send a friendly ping on these three patches after two weeks...

-- 
Jiri Kosina
SUSE Labs
