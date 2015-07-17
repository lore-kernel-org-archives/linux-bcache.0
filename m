From: Ming Lin <mlin@kernel.org>
Subject: Re: [ANNOUNCE] bcachefs!
Date: Fri, 17 Jul 2015 16:58:17 -0700
Message-ID: <1437177497.9298.3.camel@ssi>
References: <20150714005825.GA24027@kmo-pixel>
	 <1436940689.6520.1.camel@hasee>
	 <CAC7rs0sbg2ci6=niQ0X11AONZbr2AOYhRbxfDH_w4N4A7dyPLw@mail.gmail.com>
	 <1436944556.6520.5.camel@hasee>
	 <CAF1ivSa4bZaw2w9nu1tQeYx7JBb2_fVDV67Le=ybC2m8OdX3gg@mail.gmail.com>
	 <20150717231700.GA4166@kmo-pixel> <1437176155.9009.0.camel@ssi>
	 <20150717234023.GB4166@kmo-pixel> <1437176911.9298.0.camel@ssi>
	 <20150717235133.GC4166@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58028 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbbGQX6m (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 17 Jul 2015 19:58:42 -0400
In-Reply-To: <20150717235133.GC4166@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, 2015-07-17 at 16:51 -0700, Kent Overstreet wrote:
> On Fri, Jul 17, 2015 at 04:48:31PM -0700, Ming Lin wrote:
> > 
> > On Fri, 2015-07-17 at 16:40 -0700, Kent Overstreet wrote:
> > > On Fri, Jul 17, 2015 at 04:35:55PM -0700, Ming Lin wrote:
> > > > 
> > > > On Fri, 2015-07-17 at 16:17 -0700, Kent Overstreet wrote:
> > > > > On Wed, Jul 15, 2015 at 12:39:36AM -0700, Ming Lin wrote:
> > > > > > On Wed, Jul 15, 2015 at 12:15 AM, Ming Lin <mlin@kernel.org> wrote:
> > > > > > > On Tue, 2015-07-14 at 23:58 -0700, Kent Overstreet wrote:
> > > > > > >> Can you strace it?
> > > > > > >
> > > > > > > Strange. Now error message changed.
> > > > > > 
> > > > > > I mean sometimes it showed:
> > > > > > 
> > > > > > mount: /dev/sdt already mounted or /mnt/ busy
> > > > > 
> > > > > I have no idea what's going on, it works for me - is there anything unusual
> > > > > about your setup? what kind of block device is /dev/sdt? is there any chance
> > > > > there's another process that has it open? maybe try rebooting?
> > > > 
> > > > It's a regular HDD. I tried rebooting several times.
> > > > 
> > > > Now I try in qemu-kvm. Only the first time it can be mounted.
> > > > 
> > > > On host: qemu-img create hdd1.img 20G
> > > > On guest: it's /dev/vda
> > > > 
> > > > root@block:~# bcacheadm format -C /dev/vda 
> > > > UUID:			4730ed95-4c57-42db-856c-dbce36085625
> > > > Set UUID:		e69ef0e0-0344-40d7-a6b1-c23d14745a32
> > > > version:		6
> > > > nbuckets:		40960
> > > > block_size:		1
> > > > bucket_size:		1024
> > > > nr_in_set:		1
> > > > nr_this_dev:		0
> > > > first_bucket:		3
> > > > 
> > > > root@block:~# mount -t bcache /dev/vda /mnt/
> > > > 
> > > > root@block:~# mount |grep bcache
> > > > /dev/vda on /mnt type bcache (rw,relatime)
> > > > 
> > > > root@block:~# reboot
> > > > 
> > > > root@block:~# dmesg |grep -i bcache
> > > > [    2.548754] bcache: bch_journal_replay() journal replay done, 1 keys in 1 entries, seq 3
> > > > [    2.636217] bcache: register_cache() registered cache device vda
> > > > 
> > > > 
> > > > root@block:~# mount -t bcache /dev/vda /mnt/
> > > > mount: No such file or directory
> > > > 
> > > > Now dmesg shows:
> > > > 
> > > > bcache: bch_open_as_blockdevs() register_cache_set err device already registered
> > > 
> > > Ohhhh.
> > > 
> > > The cache set is getting registered by the udev hooks. We should be able to
> > > mount it anyways - same as you can mount any other fs in multiple locations.
> > > 
> > > I won't be able to fix this for at least a couple days, but for now - just
> > > shut it down it via sysfs (echo 1 > /sys/fs/bcache/<uuid>/stop), then mount it.
> > 
> > It works!
> > Any hint how to fix it? On udev or bcache-tool or kernel?
> > I'd like to fix it.
> 
> The relevant code is in drivers/md/bcache/fs.c, bch_mount() ->
> bch_open_as_blockdevs().
> 
> Part of the problem is that bcachefs isn't able to use much of the normal
> generic mount path for block devices, partly because a fs can span multiple
> block devices (same as btrfs).
> 
> I'm not sure the right way to fix it - it's going to take some thought, but
> we want to do something like "is it already open? just take a ref on the
> existing cache set".

I'll look into it.

And, echo 1 > /sys/fs/bcache/<uuid>/stop, got below.
I'll also try to fix it.

[   25.826280] ======================================================
[   25.828038] [ INFO: possible circular locking dependency detected ]
[   25.828587] 4.1.0-00943-g3683e624 #7 Not tainted
[   25.828587] -------------------------------------------------------
[   25.828587] kworker/2:1/660 is trying to acquire lock:
[   25.828587]  (s_active#31){++++.+}, at: [<ffffffff811bc5ee>] kernfs_remove+0x24/0x33
[   25.828587] 
[   25.828587] but task is already holding lock:
[   25.828587]  (&bch_register_lock){+.+.+.}, at: [<ffffffff815c40e1>] cache_set_flush+0x46/0xa6
[   25.828587] 
[   25.828587] which lock already depends on the new lock.
[   25.828587] 
[   25.828587] 
[   25.828587] the existing dependency chain (in reverse order) is:
[   25.828587] 
-> #1 (&bch_register_lock){+.+.+.}:
[   25.828587]        [<ffffffff8108e179>] __lock_acquire+0x73f/0xb0f
[   25.828587]        [<ffffffff8108ecfa>] lock_acquire+0x149/0x25c
[   25.828587]        [<ffffffff816ff284>] mutex_lock_nested+0x6e/0x38f
[   25.828587]        [<ffffffff815c9d01>] bch_cache_set_store+0x2f/0x9e
[   25.828587]        [<ffffffff811bd1ca>] kernfs_fop_write+0x100/0x14a
[   25.828587]        [<ffffffff81154aa5>] __vfs_write+0x26/0xbe
[   25.828587]        [<ffffffff8115511b>] vfs_write+0xbe/0x166
[   25.828587]        [<ffffffff811558b7>] SyS_write+0x51/0x92
[   25.828587]        [<ffffffff81703817>] system_call_fastpath+0x12/0x6f
[   25.828587] 
-> #0 (s_active#31){++++.+}:
[   25.828587]        [<ffffffff8108af24>] validate_chain.isra.31+0x942/0xfc3
[   25.828587]        [<ffffffff8108e179>] __lock_acquire+0x73f/0xb0f
[   25.828587]        [<ffffffff8108ecfa>] lock_acquire+0x149/0x25c
[   25.828587]        [<ffffffff811bba0d>] __kernfs_remove+0x1d1/0x2fd
[   25.828587]        [<ffffffff811bc5ee>] kernfs_remove+0x24/0x33
[   25.828587]        [<ffffffff81402c76>] kobject_del+0x18/0x42
[   25.828587]        [<ffffffff815c40fc>] cache_set_flush+0x61/0xa6
[   25.828587]        [<ffffffff8105ca00>] process_one_work+0x2cc/0x6c4
[   25.828587]        [<ffffffff8105dd21>] worker_thread+0x27a/0x374
[   25.828587]        [<ffffffff81062798>] kthread+0xfb/0x103
[   25.828587]        [<ffffffff81703c02>] ret_from_fork+0x42/0x70
[   25.828587] 
[   25.828587] other info that might help us debug this:
[   25.828587] 
[   25.828587]  Possible unsafe locking scenario:
[   25.828587] 
[   25.828587]        CPU0                    CPU1
[   25.828587]        ----                    ----
[   25.828587]   lock(&bch_register_lock);
[   25.828587]                                lock(s_active#31);
[   25.828587]                                lock(&bch_register_lock);
[   25.828587]   lock(s_active#31);
[   25.828587] 
[   25.828587]  *** DEADLOCK ***
[   25.828587] 
[   25.828587] 3 locks held by kworker/2:1/660:
[   25.828587]  #0:  ("events"){.+.+.+}, at: [<ffffffff8105c8d2>] process_one_work+0x19e/0x6c4
[   25.828587]  #1:  ((&cl->work)#3){+.+.+.}, at: [<ffffffff8105c8d2>] process_one_work+0x19e/0x6c4
[   25.828587]  #2:  (&bch_register_lock){+.+.+.}, at: [<ffffffff815c40e1>] cache_set_flush+0x46/0xa6
[   25.828587] 
[   25.828587] stack backtrace:
[   25.828587] CPU: 2 PID: 660 Comm: kworker/2:1 Not tainted 4.1.0-00943-g3683e624 #7
[   25.828587] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20150306_163512-brownie 04/01/2014
[   25.828587] Workqueue: events cache_set_flush
[   25.828587]  ffffffff827d7bd0 ffff880235937a78 ffffffff816fba3b 0000000000000002
[   25.828587]  ffffffff827f10c0 ffff880235937ac8 ffffffff81089bb8 ffff880235937b00
[   25.828587]  ffff880235a46a90 ffff880235937ac8 ffff880235a46a90 ffff880235a47390
[   25.828587] Call Trace:
[   25.828587]  [<ffffffff816fba3b>] dump_stack+0x4f/0x7b
[   25.828587]  [<ffffffff81089bb8>] print_circular_bug+0x2b1/0x2c2
[   25.828587]  [<ffffffff8108af24>] validate_chain.isra.31+0x942/0xfc3
[   25.828587]  [<ffffffff8108e179>] __lock_acquire+0x73f/0xb0f
[   25.828587]  [<ffffffff8108ecfa>] lock_acquire+0x149/0x25c
[   25.828587]  [<ffffffff811bc5ee>] ? kernfs_remove+0x24/0x33
[   25.828587]  [<ffffffff811bba0d>] __kernfs_remove+0x1d1/0x2fd
[   25.828587]  [<ffffffff811bc5ee>] ? kernfs_remove+0x24/0x33
[   25.828587]  [<ffffffff811bc5ee>] kernfs_remove+0x24/0x33
[   25.828587]  [<ffffffff81402c76>] kobject_del+0x18/0x42
[   25.828587]  [<ffffffff815c40fc>] cache_set_flush+0x61/0xa6
[   25.828587]  [<ffffffff8105ca00>] process_one_work+0x2cc/0x6c4
[   25.828587]  [<ffffffff8105dd21>] worker_thread+0x27a/0x374
[   25.828587]  [<ffffffff8105daa7>] ? rescuer_thread+0x2a6/0x2a6
[   25.828587]  [<ffffffff81062798>] kthread+0xfb/0x103
[   25.828587]  [<ffffffff8108be8a>] ? trace_hardirqs_on_caller+0x1bb/0x1da
[   25.828587]  [<ffffffff8106269d>] ? kthread_create_on_node+0x1c0/0x1c0
[   25.828587]  [<ffffffff81703c02>] ret_from_fork+0x42/0x70
[   25.828587]  [<ffffffff8106269d>] ? kthread_create_on_node+0x1c0/0x1c0
[   25.952174] bcache: cache_set_free() Cache set 80166ca9-ed99-4eb2-aca3-1f518531ca72 unregistered
