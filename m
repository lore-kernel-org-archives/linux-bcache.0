From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache_writebac gets stuck on DRBD
Date: Tue, 12 Jul 2016 23:18:24 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1607122311050.16228@mail.ewheeler.net>
References: <CAHbmswRRPbVhPOi+WUS4fwhAWdBHYtyzbAGmQQEgAcKuZ9ABaA@mail.gmail.com> <alpine.LRH.2.11.1607111404540.16228@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:45128 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbcGMGSl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 13 Jul 2016 02:18:41 -0400
In-Reply-To: <alpine.LRH.2.11.1607111404540.16228@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jackie Tea <m.jackie.tea@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Mon, 11 Jul 2016, Eric Wheeler wrote:

> On Tue, 5 Jul 2016, Jackie Tea wrote:
> 
> > I've been using bcache on a Xen host (sitting on an LVM partition) for
> > many months without problems
> > 
> > Now that I added DRBD on top of bcache, bcache locks up within a few
> > hours, giving me this message:
> 
> This might be related to the thread to this thread:
> 
> https://lkml.org/lkml/2016/6/22/172
>   and this patch:
> https://patchwork.kernel.org/patch/9223697/
> 
> Notably, this bug was introduced in 4.3 and newer.  You might try 4.1 and 
> see if your problem resolves itself, or 4.8 is supposed to fix this too if 
> the patch gets in.

Make sure you have these patches, too.  Looking at your stack, you 
definitely want "A", maybe the others as well:

A.  [PATCH v2] block: make sure big bio is splitted into at most 256 bvecs
	by Ming Lei: https://patchwork.kernel.org/patch/9169483/

B.  block: don't make BLK_DEF_MAX_SECTORS too big
	by Shaohua Li: http://www.spinics.net/lists/linux-bcache/msg03525.html

D.  dm-crypt: Fix error with too large bios
	by Mikulas Patocka: https://patchwork.kernel.org/patch/9138595/

E.  block: fix blk_queue_split() resource exhaustion
	by Lars Ellenberg: https://patchwork.kernel.org/patch/9223697/
		(as above, previous post.

You probably don't need "D" for your setup by looking at lsblk. 

  [ "C" excluded on purpose because "E" supersedes it, but here it is if 
    you'd like to try.  Note that "E" and "C" are mutually exclusive: 

    C. [1/3] block: flush queued bios when process blocks to avoid deadlock
	by Mikulas Patocka: https://patchwork.kernel.org/patch/9204125/
		(was https://patchwork.kernel.org/patch/7398411/)
  ]

Please try and let us know which (if any of these) fix your issue!

-Eric



--
Eric Wheeler


> 
> 
> 
> > 
> > Jul  5 04:06:43 dom0 kernel: [23043.136864] INFO: task
> > bcache_writebac:1342 blocked for more than 120 seconds.
> > Jul  5 04:06:43 dom0 kernel: [23043.136896]       Not tainted
> > 4.4.0-28-generic #47-Ubuntu
> > Jul  5 04:06:43 dom0 kernel: [23043.136916] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul  5 04:06:43 dom0 kernel: [23043.136946] bcache_writebac D
> > ffff880000983d18     0  1342      2 0x00000000
> > Jul  5 04:06:43 dom0 kernel: [23043.136952]  ffff880000983d18
> > 0000000000007ff0 ffffffff81e11500 ffff880035705780
> > Jul  5 04:06:43 dom0 kernel: [23043.136955]  ffff880000984000
> > ffff880005080af0 ffff880005080ad8 ffffffff00000000
> > Jul  5 04:06:43 dom0 kernel: [23043.136958]  ffffffff00000003
> > ffff880000983d30 ffffffff818235b5 ffff880035705780
> > Jul  5 04:06:43 dom0 kernel: [23043.136962] Call Trace:
> > Jul  5 04:06:43 dom0 kernel: [23043.136971]  [<ffffffff818235b5>]
> > schedule+0x35/0x80
> > Jul  5 04:06:43 dom0 kernel: [23043.136974]  [<ffffffff81826202>]
> > rwsem_down_write_failed+0x202/0x350
> > Jul  5 04:06:43 dom0 kernel: [23043.136990]  [<ffffffffc015e6d0>] ?
> > read_dirty+0x370/0x370 [bcache]
> > Jul  5 04:06:43 dom0 kernel: [23043.136995]  [<ffffffff813f9643>]
> > call_rwsem_down_write_failed+0x13/0x20
> > Jul  5 04:06:43 dom0 kernel: [23043.136999]  [<ffffffff81825a3d>] ?
> > down_write+0x2d/0x40
> > Jul  5 04:06:43 dom0 kernel: [23043.137009]  [<ffffffffc015e72b>]
> > bch_writeback_thread+0x5b/0x4c0 [bcache]
> > Jul  5 04:06:43 dom0 kernel: [23043.137020]  [<ffffffffc015e6d0>] ?
> > read_dirty+0x370/0x370 [bcache]
> > Jul  5 04:06:43 dom0 kernel: [23043.137024]  [<ffffffff810a0808>]
> > kthread+0xd8/0xf0
> > Jul  5 04:06:43 dom0 kernel: [23043.137027]  [<ffffffff810a0730>] ?
> > kthread_create_on_node+0x1e0/0x1e0
> > Jul  5 04:06:43 dom0 kernel: [23043.137029]  [<ffffffff81827a4f>]
> > ret_from_fork+0x3f/0x70
> > Jul  5 04:06:43 dom0 kernel: [23043.137032]  [<ffffffff810a0730>] ?
> > kthread_create_on_node+0x1e0/0x1e0
> > Jul  5 04:06:43 dom0 kernel: [23043.137043] INFO: task
> > blkback.5.hda:3357 blocked for more than 120 seconds.
> > Jul  5 04:06:43 dom0 kernel: [23043.137069]       Not tainted
> > 4.4.0-28-generic #47-Ubuntu
> > Jul  5 04:06:43 dom0 kernel: [23043.137090] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul  5 04:06:43 dom0 kernel: [23043.137119] blkback.5.hda   D
> > ffff88002341ba48     0  3357      2 0x00000000
> > Jul  5 04:06:43 dom0 kernel: [23043.137122]  ffff88002341ba48
> > ffff88002341ba08 ffffffff81e11500 ffff880034189900
> > Jul  5 04:06:43 dom0 kernel: [23043.137124]  ffff88002341c000
> > ffff880005080ad8 ffff880005080af0 ffff880023e08e60
> > Jul  5 04:06:43 dom0 kernel: [23043.137126]  ffff880005080000
> > ffff88002341ba60 ffffffff818235b5 ffff880034189900
> > Jul  5 04:06:43 dom0 kernel: [23043.137128] Call Trace:
> > Jul  5 04:06:43 dom0 kernel: [23043.137131]  [<ffffffff818235b5>]
> > schedule+0x35/0x80
> > Jul  5 04:06:43 dom0 kernel: [23043.137133]  [<ffffffff81826430>]
> > rwsem_down_read_failed+0xe0/0x140
> > Jul  5 04:06:43 dom0 kernel: [23043.137136]  [<ffffffff811903e5>] ?
> > mempool_alloc_slab+0x15/0x20
> > Jul  5 04:06:43 dom0 kernel: [23043.137138]  [<ffffffff813f9614>]
> > call_rwsem_down_read_failed+0x14/0x30
> > Jul  5 04:06:43 dom0 kernel: [23043.137140]  [<ffffffff81825a00>] ?
> > down_read+0x20/0x30
> > Jul  5 04:06:43 dom0 kernel: [23043.137148]  [<ffffffffc01522a2>]
> > cached_dev_make_request+0x682/0xcc0 [bcache]
> > Jul  5 04:06:43 dom0 kernel: [23043.137151]  [<ffffffff813bba52>]
> > generic_make_request+0xf2/0x1d0
> > Jul  5 04:06:43 dom0 kernel: [23043.137153]  [<ffffffff813bbba6>]
> > submit_bio+0x76/0x170
> > Jul  5 04:06:43 dom0 kernel: [23043.137157]  [<ffffffffc04ebbb7>]
> > dispatch_rw_block_io+0x7b7/0xab0 [xen_blkback]
> > Jul  5 04:06:43 dom0 kernel: [23043.137159]  [<ffffffff8101d204>] ?
> > xen_load_sp0+0x84/0x180
> > Jul  5 04:06:43 dom0 kernel: [23043.137162]  [<ffffffff810ca961>] ?
> > __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
> > Jul  5 04:06:43 dom0 kernel: [23043.137165]  [<ffffffffc04ec245>]
> > __do_block_io_op+0x395/0x710 [xen_blkback]
> > Jul  5 04:06:43 dom0 kernel: [23043.137167]  [<ffffffff810ec8a8>] ?
> > del_timer_sync+0x48/0x50
> > Jul  5 04:06:43 dom0 kernel: [23043.137170]  [<ffffffffc04eca7d>]
> > xen_blkif_schedule+0xdd/0x7b0 [xen_blkback]
> > Jul  5 04:06:43 dom0 kernel: [23043.137172]  [<ffffffff810a975d>] ?
> > finish_task_switch+0x7d/0x220
> > Jul  5 04:06:43 dom0 kernel: [23043.137175]  [<ffffffff810c3ca0>] ?
> > wake_atomic_t_function+0x60/0x60
> > Jul  5 04:06:43 dom0 kernel: [23043.137177]  [<ffffffffc04ec9a0>] ?
> > xen_blkif_be_int+0x30/0x30 [xen_blkback]
> > Jul  5 04:06:43 dom0 kernel: [23043.137179]  [<ffffffff810a0808>]
> > kthread+0xd8/0xf0
> > Jul  5 04:06:43 dom0 kernel: [23043.137181]  [<ffffffff810a0730>] ?
> > kthread_create_on_node+0x1e0/0x1e0
> > Jul  5 04:06:43 dom0 kernel: [23043.137183]  [<ffffffff81827a4f>]
> > ret_from_fork+0x3f/0x70
> > Jul  5 04:06:43 dom0 kernel: [23043.137185]  [<ffffffff810a0730>] ?
> > kthread_create_on_node+0x1e0/0x1e0
> > 
> > At the same time (but always after bcache), Xen's blkback will also
> > give a similar message:
> > 
> > Jul  5 04:08:43 dom0 kernel: [23163.135027] INFO: task
> > bcache_writebac:1342 blocked for more than 120 seconds.
> > Jul  5 04:08:43 dom0 kernel: [23163.135056]       Not tainted
> > 4.4.0-28-generic #47-Ubuntu
> > Jul  5 04:08:43 dom0 kernel: [23163.135076] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul  5 04:08:43 dom0 kernel: [23163.135105] bcache_writebac D
> > ffff880000983d18     0  1342      2 0x00000000
> > Jul  5 04:08:43 dom0 kernel: [23163.135109]  ffff880000983d18
> > 0000000000007ff0 ffffffff81e11500 ffff880035705780
> > Jul  5 04:08:43 dom0 kernel: [23163.135112]  ffff880000984000
> > ffff880005080af0 ffff880005080ad8 ffffffff00000000
> > Jul  5 04:08:43 dom0 kernel: [23163.135114]  ffffffff00000003
> > ffff880000983d30 ffffffff818235b5 ffff880035705780
> > Jul  5 04:08:43 dom0 kernel: [23163.135116] Call Trace:
> > Jul  5 04:08:43 dom0 kernel: [23163.135124]  [<ffffffff818235b5>]
> > schedule+0x35/0x80
> > Jul  5 04:08:43 dom0 kernel: [23163.135127]  [<ffffffff81826202>]
> > rwsem_down_write_failed+0x202/0x350
> > Jul  5 04:08:43 dom0 kernel: [23163.135139]  [<ffffffffc015e6d0>] ?
> > read_dirty+0x370/0x370 [bcache]
> > Jul  5 04:08:43 dom0 kernel: [23163.135143]  [<ffffffff813f9643>]
> > call_rwsem_down_write_failed+0x13/0x20
> > Jul  5 04:08:43 dom0 kernel: [23163.135145]  [<ffffffff81825a3d>] ?
> > down_write+0x2d/0x40
> > Jul  5 04:08:43 dom0 kernel: [23163.135153]  [<ffffffffc015e72b>]
> > bch_writeback_thread+0x5b/0x4c0 [bcache]
> > Jul  5 04:08:43 dom0 kernel: [23163.135160]  [<ffffffffc015e6d0>] ?
> > read_dirty+0x370/0x370 [bcache]
> > Jul  5 04:08:43 dom0 kernel: [23163.135162]  [<ffffffff810a0808>]
> > kthread+0xd8/0xf0
> > Jul  5 04:08:43 dom0 kernel: [23163.135164]  [<ffffffff810a0730>] ?
> > kthread_create_on_node+0x1e0/0x1e0
> > Jul  5 04:08:43 dom0 kernel: [23163.135166]  [<ffffffff81827a4f>]
> > ret_from_fork+0x3f/0x70
> > Jul  5 04:08:43 dom0 kernel: [23163.135168]  [<ffffffff810a0730>] ?
> > kthread_create_on_node+0x1e0/0x1e0
> > Jul  5 04:08:43 dom0 kernel: [23163.135178] INFO: task
> > blkback.5.hda:3357 blocked for more than 120 seconds.
> > Jul  5 04:08:43 dom0 kernel: [23163.135204]       Not tainted
> > 4.4.0-28-generic #47-Ubuntu
> > Jul  5 04:08:43 dom0 kernel: [23163.135224] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul  5 04:08:43 dom0 kernel: [23163.135286] blkback.5.hda   D
> > ffff88002341ba48     0  3357      2 0x00000000
> > Jul  5 04:08:43 dom0 kernel: [23163.135289]  ffff88002341ba48
> > ffff88002341ba08 ffffffff81e11500 ffff880034189900
> > Jul  5 04:08:43 dom0 kernel: [23163.135291]  ffff88002341c000
> > ffff880005080ad8 ffff880005080af0 ffff880023e08e60
> > Jul  5 04:08:43 dom0 kernel: [23163.135293]  ffff880005080000
> > ffff88002341ba60 ffffffff818235b5 ffff880034189900
> > Jul  5 04:08:43 dom0 kernel: [23163.135295] Call Trace:
> > Jul  5 04:08:43 dom0 kernel: [23163.135299]  [<ffffffff818235b5>]
> > schedule+0x35/0x80
> > Jul  5 04:08:43 dom0 kernel: [23163.135301]  [<ffffffff81826430>]
> > rwsem_down_read_failed+0xe0/0x140
> > Jul  5 04:08:43 dom0 kernel: [23163.135304]  [<ffffffff811903e5>] ?
> > mempool_alloc_slab+0x15/0x20
> > Jul  5 04:08:43 dom0 kernel: [23163.135307]  [<ffffffff813f9614>]
> > call_rwsem_down_read_failed+0x14/0x30
> > Jul  5 04:08:43 dom0 kernel: [23163.135309]  [<ffffffff81825a00>] ?
> > down_read+0x20/0x30
> > Jul  5 04:08:43 dom0 kernel: [23163.135316]  [<ffffffffc01522a2>]
> > cached_dev_make_request+0x682/0xcc0 [bcache]
> > Jul  5 04:08:43 dom0 kernel: [23163.135319]  [<ffffffff813bba52>]
> > generic_make_request+0xf2/0x1d0
> > Jul  5 04:08:43 dom0 kernel: [23163.135321]  [<ffffffff813bbba6>]
> > submit_bio+0x76/0x170
> > Jul  5 04:08:43 dom0 kernel: [23163.135326]  [<ffffffffc04ebbb7>]
> > dispatch_rw_block_io+0x7b7/0xab0 [xen_blkback]
> > Jul  5 04:08:43 dom0 kernel: [23163.135328]  [<ffffffff8101d204>] ?
> > xen_load_sp0+0x84/0x180
> > Jul  5 04:08:43 dom0 kernel: [23163.135331]  [<ffffffff810ca961>] ?
> > __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
> > Jul  5 04:08:43 dom0 kernel: [23163.135334]  [<ffffffffc04ec245>]
> > __do_block_io_op+0x395/0x710 [xen_blkback]
> > Jul  5 04:08:43 dom0 kernel: [23163.135337]  [<ffffffff810ec8a8>] ?
> > del_timer_sync+0x48/0x50
> > Jul  5 04:08:43 dom0 kernel: [23163.135340]  [<ffffffffc04eca7d>]
> > xen_blkif_schedule+0xdd/0x7b0 [xen_blkback]
> > Jul  5 04:08:43 dom0 kernel: [23163.135343]  [<ffffffff810a975d>] ?
> > finish_task_switch+0x7d/0x220
> > Jul  5 04:08:43 dom0 kernel: [23163.135346]  [<ffffffff810c3ca0>] ?
> > wake_atomic_t_function+0x60/0x60
> > Jul  5 04:08:43 dom0 kernel: [23163.135348]  [<ffffffffc04ec9a0>] ?
> > xen_blkif_be_int+0x30/0x30 [xen_blkback]
> > Jul  5 04:08:43 dom0 kernel: [23163.135350]  [<ffffffff810a0808>]
> > kthread+0xd8/0xf0
> > Jul  5 04:08:43 dom0 kernel: [23163.135352]  [<ffffffff810a0730>] ?
> > kthread_create_on_node+0x1e0/0x1e0
> > Jul  5 04:08:43 dom0 kernel: [23163.135354]  [<ffffffff81827a4f>]
> > ret_from_fork+0x3f/0x70
> > Jul  5 04:08:43 dom0 kernel: [23163.135356]  [<ffffffff810a0730>] ?
> > kthread_create_on_node+0x1e0/0x1e0
> > 
> > Access to the storage is no longer possible, then (it'll just appear to hang).
> > This is on the newest Ubuntu 16.04 LTS, with their 4.4.0-28 kernel.
> > 
> > # lsb_release -d
> > Description:    Ubuntu 16.04 LTS
> > # uname -r
> > 4.4.0-28-generic
> > 
> > bcache is set to writeback.
> > 
> > # cat /sys/block/bcache0/bcache/cache_mode
> > writethrough [writeback] writearound none
> > # cat /sys/block/bcache0/bcache/state
> > dirty
> > # cat /sys/block/bcache0/bcache/dirty_data
> > 56.0k
> > 
> > The relevant disk stack looks like this:
> > 
> > # lsblk
> > sdd                              8:48   0 232.9G  0 disk
> > `-sdd1                           8:49   0 232.9G  0 part
> >   `-md1                          9:1    0 232.8G  0 raid1
> >     `-ssd-bcache--back         252:4    0    30G  0 lvm
> >       `-bcache0                251:0    0     2T  0 disk
> >         `-storage-drback--test 252:6    0   200G  0 lvm
> > 
> > storage-drback--test is the backing device for DRBD.
> > 
> > This is reproducible, but I do not know what causes it, or how to
> > cause it on purpose. All I know is that once I put DRBD on top of
> > bcache, and produce minor load over time (I just have a single idle
> > Windows 2012R2 server on it as test - as Windows would always do
> > *something* ;-) it will lock up within 8 hours.
> > 
> > Do you have any clues as to what could be causing this?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
