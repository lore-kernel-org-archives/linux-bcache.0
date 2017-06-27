From: Eric Wheeler <lists@ewheeler.net>
Subject: Re: [PATCH] [PATCH v2] bcache: gc does not work when triggering by
 manual command
Date: Tue, 27 Jun 2017 23:53:25 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706272348280.17052@mail.ewheeler.net>
References: <1496992301-10448-1-git-send-email-tang.junhui@zte.com.cn> <71e16c03-8c5b-30f9-8d3b-3d3bb8ea389b@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1615993100-1498607605=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:37648 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753978AbdF0X7H (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 19:59:07 -0400
In-Reply-To: <71e16c03-8c5b-30f9-8d3b-3d3bb8ea389b@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: Coly Li <i@coly.li>, kent.overstreet@gmail.com, bcache@lists.ewheeler.net, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1615993100-1498607605=:17052
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 21 Jun 2017, Coly Li wrote:

> On 2017/6/9 下午3:11, tang.junhui@zte.com.cn wrote:
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> > 
> > I try to execute the following command to trigger gc thread:
> > [root@localhost internal]# echo 1 > trigger_gc
> > But it does not work, I debug the code in gc_should_run(), It works only
> > if in invalidating or sectors_to_gc < 0. So set sectors_to_gc to -1 to
> > meet the condition when we trigger gc by manual command.
> > 
> 
> Hi Junhui,
> 
> Thanks for the patch, it totally makes sense IMHO. In most of use cases
> I know, people writing to trigger_gc file expecting a force garbage
> collection.
> 
> But assign a minus value here is quite confused for people who read the
> code. Could you please also add some comments in the code to explain why
> you set c->sectors_to_gc to -1 here.

I agree with Coly here.  Please do a v3 with comments explaining why -1 is 
acceptable.
 
> And there might be a race that when you set c->sectors_to_gc to -1, and
> call wake_up_gc(), but before code go into gc_should_run(),
> c->sectors_to_gc is reset by set_gc_sectors(). I have no object if you
> don't want to handle this situation, but I do suggest to explain it in
> code why we can ignore such a race.

Also for v3, please address Coly's race condition concern or refute its 
existence.  Lets not introduce races if we know about them.  It should 
fail gracefully, even if it must refuse to start a gc at that moment which 
is much better than deadlocking (eg, -EINVAL the sysfs call, use a 
spinlock, or something).


--
Eric Wheeler


> 
> > Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>
> > ---
> >  drivers/md/bcache/sysfs.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > index b3ff57d..f5bb93a 100644
> > --- a/drivers/md/bcache/sysfs.c
> > +++ b/drivers/md/bcache/sysfs.c
> > @@ -614,8 +614,10 @@ STORE(__bch_cache_set)
> >  		bch_cache_accounting_clear(&c->accounting);
> >  	}
> >  
> > -	if (attr == &sysfs_trigger_gc)
> > +	if (attr == &sysfs_trigger_gc) {
> > +		atomic_set(&c->sectors_to_gc, -1);
> >  		wake_up_gc(c);
> > +	}
> >  
> >  	if (attr == &sysfs_prune_cache) {
> >  		struct shrink_control sc;
> > 
> 
> 
> -- 
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-1615993100-1498607605=:17052--
