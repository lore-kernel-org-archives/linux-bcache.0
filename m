From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH 04/19] bcache: fix wrong cache_misses statistics
Date: Thu, 13 Jul 2017 04:09:31 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707130408230.9683@mail.ewheeler.net>
References: <20170629134510.GA32385@infradead.org> <1498855388-16990-1-git-send-email-bcache@lists.ewheeler.net> <1498855388-16990-4-git-send-email-bcache@lists.ewheeler.net> <20989a81-8448-96c8-f8b6-f3e3fec7c3cc@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-662556455-1499918971=:9683"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:49584 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751181AbdGMEJc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jul 2017 00:09:32 -0400
In-Reply-To: <20989a81-8448-96c8-f8b6-f3e3fec7c3cc@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Tang Junhui <tang.junhui@zte.com.cn>
Cc: Coly Li <i@coly.li>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-662556455-1499918971=:9683
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 2 Jul 2017, Coly Li wrote:

> On 2017/7/1 上午4:42, bcache@lists.ewheeler.net wrote:
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> > 
> > Some missed IOs are not counted into cache_misses, this patch fix this
> > issue.
> 
> Could you please explain more about,
> - which kind of missed I/O are mot counted
> - where cache_missed is located
> 
> This will help the patch to be more understandable.

Hi Tang,

I'm waiting to queue this patch pending your response to Coly.  Can you 
update the message send a v2?

--
Eric Wheeler



> 
> > 
> > Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> > Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>
> > Cc: stable@vger.kernel.org
> 
> [snip]
> 
> > @@ -758,7 +760,7 @@ static void cached_dev_read_done_bh(struct closure *cl)
> >  	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
> >  
> >  	bch_mark_cache_accounting(s->iop.c, s->d,
> > -				  !s->cache_miss, s->iop.bypass);
> > +				  !s->cache_missed, s->iop.bypass);
> >  	trace_bcache_read(s->orig_bio, !s->cache_miss, s->iop.bypass);
> 
> 
> Should the above line be changed to,
> 	trace_bcache_read(s->orig_bio, !s->cache_missed, s->iop.bypass);
> as well ?
> 
> 
> [snip]
> 
> Thanks.
> 
> -- 
> Coly Li
> 
--1641074820-662556455-1499918971=:9683--
