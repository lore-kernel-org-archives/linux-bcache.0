From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: every boot gives: bcache/alloc.c:78 WARNING
Date: Wed, 3 Aug 2016 21:32:40 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608032110460.10662@mail.ewheeler.net>
References: <20160803231919.GA13477@merlins.org> <alpine.LRH.2.11.1608031707300.10662@mail.ewheeler.net> <20160804003351.GI31234@merlins.org> <alpine.LRH.2.11.1608031842120.10662@mail.ewheeler.net> <alpine.LRH.2.11.1608031943560.10662@mail.ewheeler.net>
 <20160804032344.GA25091@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:51607 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751023AbcHDEh4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 4 Aug 2016 00:37:56 -0400
In-Reply-To: <20160804032344.GA25091@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Wed, 3 Aug 2016, Marc MERLIN wrote:

> On Wed, Aug 03, 2016 at 07:44:41PM -0700, Eric Wheeler wrote:
> > > When you say do "that" do you mean `trigger_gc` ?
> > > 
> > > I think trigger_gc a cache thing, but the whole bcacheN dev might need to 
> > > be online before it can be triggered (not sure).  Backing devices really 
> > > have metadata, just superblock.
> > 
> > I meant to say: 
> > 
> > Backing devices have no metadata, just superblock.
> 
> Mmmh, doing this just killed my cache:
> saruman:/sys/block/bcache0# echo 1 > /sys/fs/bcache/7f2e1508-8db6-48cb-85d6-606c88f81f63/internal/trigger_gc
> 
> [ 1639.204612] bcache: error on fc8cd783-346b-48f5-a619-fb0380584aa9: key too stale: 97, need_gc 97, disabling caching
> [ 1639.204625] CPU: 7 PID: 519 Comm: bcache_gc Tainted: G        W  OE   4.4.5-amd64-volpreempt-sysrq-20160312bc5 #10
> [ 1639.204627] Hardware name: LENOVO 20ERCTO1WW/20ERCTO1WW, BIOS N1DET41W (1.15 ) 12/31/2015
> [ 1639.204629]  0000000000000000 ffff8808781fbbc0 ffffffff8134d88e ffff880875040ab8
> [ 1639.204635]  ffff88087a3edcd0 ffff8808781fbc00 ffffffffc03b8609 0000000000000001
> [ 1639.204639]  ffff880875040ab8 ffffffffc03b17ed ffff88087a3edcd0 ffff8808781fbc50
> [ 1639.204644] Call Trace:
> [ 1639.204649]  [<ffffffff8134d88e>] dump_stack+0x61/0x7d
> [ 1639.204668]  [<ffffffffc03b8609>] bch_extent_bad+0xd7/0x12b [bcache]
> [ 1639.204677]  [<ffffffffc03b17ed>] ? bch_ptr_invalid+0xc/0xc [bcache]
> [ 1639.204684]  [<ffffffffc03b17f7>] bch_ptr_bad+0xa/0xc [bcache]

It seems that you've hit something that might not be a bug.  This looks 
like disk corruption somehow from the looks of the backtrace.  Maybe a 
failed on-SSD writeback flush, writeback controller flush (if any), or 
just erase block wearout.

A quick google shows the last person to have this was in writethrough and 
rebuilt their cache back in 3.11->3.14:
  http://www.spinics.net/lists/linux-bcache/msg02450.html

This looks like a better thread, possibly implicating TRIM:
  https://www.mail-archive.com/linux-bcache@vger.kernel.org/msg02720.html

If you are writeback, then maybe you could disable gc.  I don't think 
there's a way to disable gc via sysfs, but you could try to comment this 
out:

drivers/md/bcache/super.c:
	1669         if (bch_gc_thread_start(c))
	1670                 goto err;

If it still functions (no idea, it might fail in other unexpected ways), 
then perhaps you can detach your cache and get it to writeback.  

> [ 1639.204690]  [<ffffffffc03b1646>] bch_btree_iter_next_filter+0x32/0x42 [bcache]
> [ 1639.204695]  [<ffffffffc03b1ce2>] btree_gc_count_keys+0x3b/0x59 [bcache]
> [ 1639.204701]  [<ffffffffc03b5e44>] btree_gc_recurse+0x11b/0x2db [bcache]
> [ 1639.204705]  [<ffffffff8164ad9b>] ? __schedule+0x3b1/0x575
> [ 1639.204710]  [<ffffffffc03b27e5>] ? __bch_btree_mark_key+0xba/0x1a4 [bcache]
> [ 1639.204716]  [<ffffffffc03b63c9>] bch_btree_gc+0x246/0x3cc [bcache]
> [ 1639.204722]  [<ffffffffc03b63c9>] ? bch_btree_gc+0x246/0x3cc [bcache]
> [ 1639.204725]  [<ffffffff8108d0f8>] ? wake_up_atomic_t+0x2c/0x2c
> [ 1639.204731]  [<ffffffffc03b6586>] bch_gc_thread+0x37/0xea [bcache]
> [ 1639.204736]  [<ffffffffc03b654f>] ? bch_btree_gc+0x3cc/0x3cc [bcache]
> [ 1639.204741]  [<ffffffffc03b654f>] ? bch_btree_gc+0x3cc/0x3cc [bcache]
> [ 1639.204745]  [<ffffffff81075c36>] kthread+0xa5/0xad
> [ 1639.204747]  [<ffffffff81075b91>] ? kthread_parkme+0x24/0x24
> [ 1639.204750]  [<ffffffff8164decf>] ret_from_fork+0x3f/0x70
> [ 1639.204752]  [<ffffffff81075b91>] ? kthread_parkme+0x24/0x24
> [ 1639.246944] bcache: cache_set_free() Cache set fc8cd783-346b-48f5-a619-fb0380584aa9 unregistered

--
Eric Wheeler


> 
> That's not good.
> 
> What should I do now?
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
> 
