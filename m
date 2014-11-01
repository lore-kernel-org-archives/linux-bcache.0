From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.17-rc6: bcache_gc: BUG: soft lockup - CPU#2 stuck for 23s!
Date: Sat, 1 Nov 2014 13:44:47 -0700
Message-ID: <20141101204447.GB22219@kmo-pixel>
References: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61022 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506AbaKAUms (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 1 Nov 2014 16:42:48 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so9293762pde.32
        for <linux-bcache@vger.kernel.org>; Sat, 01 Nov 2014 13:42:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <linux-bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org, Ross Anderson <rosander@dsotm.net>, Stefan Priebe <s.priebe@profihost.ag>

On Sun, Sep 28, 2014 at 05:25:37PM -0700, Eric Wheeler wrote:
> Hello Kent, Ross, all:
> 
> We're getting bcache_gc backtraces and soft lockups; the system continues to
> be responsive and eventually recovers.  We are running 3.17-rc6. (This
> appears to be a continuation of the thread from 2014-09-15)
> 
> Please see the following two backtraces.  The first shows up in
> btree_gc_count_keys(), the other is triggered somehow by rcu_sched.  We will
> test with -rc7 this week, though I didn't see any bcache commits in rc7.
> 
> The server is quite busy:
>   dd in userspace from dm-thinp snapshots to another server
>   two DRBD verify's active backed by dm-thinp volumes
>   note that, dd fills up the buffers so this could be operating with few
>   pages free. (Though we have min-mem set to 256MB.)
> 
> I see we are hitting functions like bch_ptr_bad() and bch_extent_bad().
> Could that indicate a cache corruption on our volume?

No - those are the normal "check the validity of medata" functions.

> I'm happy to test patches if you have any suggestions or tests that I should
> run it through.

I think it might just be a missing cond_resched()... there's a check during
garbage collection for need_resched() but it appears we might not actually be
calling schedule() then.

Try this patch:

commit a64afc92e17e709bdd1618edd04bc608f6a44c55
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Sat Nov 1 13:44:13 2014 -0700

    bcache: Add a cond_resched() call to gc
    
    Change-Id: Id4f18c533b80ddb40df94ed0bb5e2a236a4bc325

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 00cde40db5..218f21ac02 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1741,6 +1741,7 @@ static void bch_btree_gc(struct cache_set *c)
 	do {
 		ret = btree_root(gc_root, c, &op, &writes, &stats);
 		closure_sync(&writes);
+		cond_resched();
 
 		if (ret && ret != -EAGAIN)
 			pr_warn("gc failed!");
