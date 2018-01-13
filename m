From: Pavel Vazharov <freakpv@gmail.com>
Subject: Re: [PATCH] bcache: btree.c: Fix GC thread exit in case of cache
 device failure and unregister
Date: Sat, 13 Jan 2018 06:43:46 +0200
Message-ID: <20180113064346.8cbbbec0273e00c919a25a77@gmail.com>
References: <1515770690-18562-1-git-send-email-freakpv@gmail.com>
        <8bf2eafd-651e-ce0b-3a4c-aa10e292ce2f@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38165 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965415AbeAMEnt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Jan 2018 23:43:49 -0500
In-Reply-To: <8bf2eafd-651e-ce0b-3a4c-aa10e292ce2f@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: mlyle@lyle.org, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 13 Jan 2018 12:06:26 +0800
Coly Li <i@coly.li> wrote:

> On 12/01/2018 11:24 PM, Pavel Vazharov wrote:
> > There was a possibility for infinite do-while loop inside the GC thread
> > function in case of total failure of the caching device. I was able to
> > reproduce it 3 times simulating disappearing of the caching device via
> > 'echo 1 > /sys/block/<dev>/device/delete'. In that case the btree_root
> > starts to return non zero and non -EAGAIN result, 'gc failed' message
> > start to fill the kernel log and the do-while becomes infinite loop
> > occupying single CPU core at 100%.
> > There is already a logic which unregisters the cache_set (or panics) in
> > case of io errors and thus we exit the loop here if the unregistering
> > procedure has already started.
> > 
> > Signed-off-by: Pavel Vazharov <freakpv@gmail.com>
> > ---
> >  drivers/md/bcache/btree.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index 81e8dc3..a672081 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> > @@ -1748,8 +1748,12 @@ static void bch_btree_gc(struct cache_set *c)
> >  		closure_sync(&writes);
> >  		cond_resched();
> >  
> > -		if (ret && ret != -EAGAIN)
> > -			pr_warn("gc failed!");
> > +		if (ret && ret != -EAGAIN) {
> > +			if (test_bit(CACHE_SET_UNREGISTERING, &c->flags))
> > +				break;
> > +			else
> > +				pr_warn("gc failed!");
> > +		}
> >  	} while (ret);
> >  
> >  	bch_btree_gc_finish(c);
> > 
> 
> Hi Pavel,
> 
> I see the point here. But there are 2 code paths to call
> cache_set_flush(), one is from bch_cache_set_error(), one is from sysfs
> interface (echo 1 > /sys/fs/bcache/<UUID>/stop).
> 
> CACHE_SET_UNREGISTERING is set in the first code path, the another code
> path from sysfs does not set CACHE_SET_UNREGISTERING. In this case maybe
> the above while-loop can not be stopped.
> 
> In my device failure cache set, I add an io_disable (in v2 it is
> CACHE_SET_IO_DISABLE flag) to disable all cache set I/O, maybe it can be
> used to check the condition and break the while-loop.
> 
> Thanks for the hint, I will also try to fix it in my patch set. If you
> don't mind, I am glad to have your "Reviewed-by:" after I post the v2
> patch set.
> 
> Thanks.
> 
> -- 
> Coly Li

Hi Coly,

CACHE_SET_IO_DISABLE looks like more general solution to the problem.
Thanks for the review invitation. I'll do my best.

-- 
Pavel Vazharov <freakpv@gmail.com>
