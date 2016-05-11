From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Tue, 10 May 2016 18:13:02 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605101812240.22680@mx.ewheeler.net>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm> <alpine.LNX.2.00.1605020916001.27942@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [66.155.3.69] ([66.155.3.69]:57084 "EHLO mx.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbcEKBMy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 10 May 2016 21:12:54 -0400
In-Reply-To: <alpine.LNX.2.00.1605020916001.27942@cbobk.fhfr.pm>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Maciej Piechotka <uzytkownik2@gmail.com>

On Mon, 2 May 2016, Jiri Kosina wrote:
> On Tue, 19 Apr 2016, Jiri Kosina wrote:
> 
> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > bch_writeback_thread() is calling try_to_freeze(), but that's just an 
> > expensive no-op given the fact that the thread is not marked freezable.
> > 
> > I/O helper kthreads, exactly such as the bcache writeback thread, actually 
> > shouldn't be freezable, because they are potentially necessary for 
> > finalizing the image write-out.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Let's send a friendly ping on these three patches after two weeks...

Maciej,

Were you able to get a backtrace?


--
Eric Wheeler


> 
> -- 
> Jiri Kosina
> SUSE Labs
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
