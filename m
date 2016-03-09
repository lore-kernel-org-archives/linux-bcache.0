From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PULL] bcache: fix cache_set_flush() NULL pointer dereference
 on OOM
Date: Wed, 9 Mar 2016 03:36:46 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603090330430.15354@mail.ewheeler.net>
References: <alpine.LRH.2.11.1603072326410.11530@mail.ewheeler.net> <56DEFBC6.5040905@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:47593 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750867AbcCIDhD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 8 Mar 2016 22:37:03 -0500
In-Reply-To: <56DEFBC6.5040905@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org

On Tue, 8 Mar 2016, Jens Axboe wrote:

> On 03/07/2016 04:36 PM, Eric Wheeler wrote:
> > Hi Jens,
> >
> > Here is another OOM fix for bcache.  Please pull:
> >
> >    git pull https://bitbucket.org/ewheelerinc/linux.git
> >    v4.5-rc7-bcache-fixes
> >
> >   # git diff --stat v4.5-rc7
> >   drivers/md/bcache/super.c | 3 +++
> >   1 file changed, 3 insertions(+)
> 
> I pulled this and the previous, but for 4.6. They are all marked stable, so
> that should be fine.
> 
> Note that your 2nd patch in the -rc6 branch, this one:
> 
> bcache: cleaned up error handling around register_cache()
> 
> had a 4 cases of trailing white space. Please ensure that future patches are
> cleaned up, I fixed that one up.

Interesting, do you mean whitespace at the end of a line with code or 
empty lines containing whitespace or both?  Something matched by [ ]+$  ?

Is it acceptable to have empty likes whith whitespace leading up to the 
indent level?  eg:
	if (1) {
		foo
		<<whitespace-to-here but line is blank
		bar
	}

-Eric

> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
