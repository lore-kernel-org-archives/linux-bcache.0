From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: bcache and load average
Date: Fri, 15 May 2015 13:37:36 -0700
Message-ID: <20150515203736.GB24997@birch.djwong.org>
References: <20150515185032.6b129595@harpe.intellique.com>
 <alpine.DEB.2.02.1505151053020.8760@ware.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32563 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056AbbEOUhm (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 15 May 2015 16:37:42 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1505151053020.8760@ware.dreamhost.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-bcache@vger.kernel.org

On Fri, May 15, 2015 at 10:55:32AM -0700, Eric Wheeler wrote:
> > Going through various forum messages and bug reports (for Debian: 
> > https://lists.debian.org/debian-kernel/2015/03/msg00060.html for Arch: 
> > https://bugs.archlinux.org/task/38843 for some other distro: 
> > https://groups.google.com/forum/#!msg/esos-users/NXp8tG7sVE8/QXZyPdZ2saIJ 
> > ) it looks like the bcache_writeback kernel thread, being in 
> > uninterruptible sleep, keeps the load average at 1.0 (or maybe more) 
> > always. Could you please confirm this ?
> 
> Try the attached patches that I've been collecting over the past year or 
> two. I do not believe they have been merged into mainline (BUT SOMEONE 
> NEEDS TO).
> 
> I am not sure that these address the load bug, but if the load is being 
> increased by a large amount of dmesg output caused by rcu traces, then the 
> patches will help.

I just put all five of them into a 4.0.3 kernel, but sadly they don't
fix the load average bug.  That said, they look like pretty reasonable
bugfixes to me.  Maybe someone should just send them to Linus, if the
maintainer hasn't otherwise objected?

(Shrug, I haven't been following bcache enough to be familiar with the
status of these patches.)

--D

> 
> -Eric
>  
> > 
> >  - this behaviour should be described in the bcache documentation
> >    because it feels to me (and many other) like a true gotcha. It's
> >    apparently completely undocumented. A "CAVEATS" section at the
> >    bottom of bcache.txt in the kernel Documentation explaining this
> >    would be nice, what do you think?
> > 
> >  - Is there any way around this? Some people seem to grow uneasy (maybe
> >    irrationnally) having a constant load on an otherwise unused system
> >    (I know that a sleeping thread actually does nothing, but many 
> >    system administrators can't wrap their head around this idea). 
> > 
> > I've tried some advice I've found on the web, like switching to
> > writethrough and "echo 0 > /sys/block/bcache0/bcache/writeback_running"
> > but to absolutely no effect.
> > 
> > Any advice and idea is welcome :)
> > 
> > -- 
> > ------------------------------------------------------------------------
> > Emmanuel Florac     |   Direction technique
> >                     |   Intellique
> >                     |	<eflorac@intellique.com>
> >                     |   +33 1 78 94 84 02
> > ------------------------------------------------------------------------
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In bcache_init() function it forgot to unregister reboot notifier if
> bcache fails to unregister a block device.  This commit fixes this.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Tested-by: Joshua Schmid <jschmid@suse.com>
> ---
>  drivers/md/bcache/super.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 4dd2bb7..fdbb211 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2100,8 +2100,10 @@ static int __init bcache_init(void)
>  	closure_debug_init();
>  
>  	bcache_major = register_blkdev(0, "bcache");
> -	if (bcache_major < 0)
> +	if (bcache_major < 0) {
> +		unregister_reboot_notifier(&reboot);
>  		return bcache_major;
> +	}
>  
>  	if (!(bcache_wq = create_workqueue("bcache")) ||
>  	    !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||

> 	
> From:	Zheng Liu <gnehzuil.liu@gmail.com>
> To:	linux-bcache@vger.kernel.org
> Cc:	Zheng Liu <wenqing.lz@taobao.com>, Joshua Schmid <jschmid@suse.com>, Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kmo@daterainc.com>
> Subject:	[PATCH v2] bcache: fix a livelock in btree lock
> Date:	Wed, 25 Feb 2015 20:32:09 +0800 (02/25/2015 04:32:09 AM)
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit tries to fix a livelock in bcache.  This livelock might
> happen when we causes a huge number of cache misses simultaneously.
> 
> When we get a cache miss, bcache will execute the following path.
> 
> ->cached_dev_make_request()
>   ->cached_dev_read()
>     ->cached_lookup()
>       ->bch->btree_map_keys()
>         ->btree_root()  <------------------------
>           ->bch_btree_map_keys_recurse()        |
>             ->cache_lookup_fn()                 |
>               ->cached_dev_cache_miss()         |
>                 ->bch_btree_insert_check_key() -|
>                   [If btree->seq is not equal to seq + 1, we should return
>                    EINTR and traverse btree again.]
> 
> In bch_btree_insert_check_key() function we first need to check upgrade
> flag (op->lock == -1), and when this flag is true we need to release
> read btree->lock and try to take write btree->lock.  During taking and
> releasing this write lock, btree->seq will be monotone increased in
> order to prevent other threads modify this in cache miss (see btree.h:74).
> But if there are some cache misses caused by some requested, we could
> meet a livelock because btree->seq is always changed by others.  Thus no
> one can make progress.
> 
> This commit will try to take write btree->lock if it encounters a race
> when we traverse btree.  Although it sacrifice the scalability but we
> can ensure that only one can modify the btree.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Tested-by: Joshua Schmid <jschmid@suse.com>
> Cc: Joshua Schmid <jschmid@suse.com>
> Cc: Zhu Yanhai <zhu.yanhai@gmail.com>
> Cc: Kent Overstreet <kmo@daterainc.com>
> ---
> changelog:
> v2: fix a bug that stops all concurrency writes unconditionally.
> 
>  drivers/md/bcache/btree.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 218f21a..43829d9 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2163,8 +2163,10 @@ int bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
>  		rw_lock(true, b, b->level);
>  
>  		if (b->key.ptr[0] != btree_ptr ||
> -		    b->seq != seq + 1)
> +                   b->seq != seq + 1) {
> +                       op->lock = b->level;
>  			goto out;
> +               }
>  	}
>  
>  	SET_KEY_PTRS(check_key, 1);

> 
> From: Joshua Schmid <jschmid@suse.com>
> Subject: [PATCH] fix a leak in bch_cached_dev_run()
> Newsgroups: gmane.linux.kernel.bcache.devel
> Date: 2015-02-03 11:24:06 GMT (3 weeks, 2 days, 11 hours and 43 minutes ago)
> 
> From: Al Viro <viro@ZenIV.linux.org.uk>
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Tested-by: Joshua Schmid <jschmid@suse.com>
> ---
>  drivers/md/bcache/super.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 8c2d657..53f1512 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -880,8 +880,11 @@ void bch_cached_dev_run(struct cached_dev *dc)
>  	buf[SB_LABEL_SIZE] = '\0';
>  	env[2] = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf);
> 
> -	if (atomic_xchg(&dc->running, 1))
> +	if (atomic_xchg(&dc->running, 1)) {
> +		kfree(env[1]);
> +		kfree(env[2]);
>  		return;
> +	}
> 
>  	if (!d->c &&
>  	    BDEV_STATE(&dc->sb) != BDEV_STATE_NONE) {
> -- 
> 2.1.2
> 

> From f0e6320a7874af434575f37a11ec6e4992cef790 Mon Sep 17 00:00:00 2001
> From: Kent Overstreet <kmo@daterainc.com>
> Date: Sat, 1 Nov 2014 13:44:47 -0700
> Subject: [PATCH 1/5] bcache: Add a cond_resched() call to gc
> Git-commit: f0e6320a7874af434575f37a11ec6e4992cef790
> Patch-mainline: Submitted
> References: bnc#910440
> 
> Change-id: Id4f18c533b80ddb40df94ed0bb5e2a236a4bc325
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
>  drivers/md/bcache/btree.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/drivers/md/bcache/btree.c	2014-11-03 16:51:01.720000000 -0800
> +++ b/drivers/md/bcache/btree.c	2014-11-03 16:51:26.456000000 -0800
> @@ -1741,6 +1741,7 @@
>  	do {
>  		ret = btree_root(gc_root, c, &op, &writes, &stats);
>  		closure_sync(&writes);
> +		cond_resched();
>  
>  		if (ret && ret != -EAGAIN)
>  			pr_warn("gc failed!");

> From: Joshua Schmid <jschmid@suse.com>
> Subject: [PATCH] bcache: [BUG] clear BCACHE_DEV_UNLINK_DONE flag when attaching a backing device
> Newsgroups: gmane.linux.kernel.bcache.devel
> Date: 2015-02-03 11:18:01 GMT (3 weeks, 2 days, 11 hours and 45 minutes ago)
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This bug can be reproduced by the following script:
> 
>   #!/bin/bash
> 
>   bcache_sysfs="/sys/fs/bcache"
> 
>   function clear_cache()
>   {
>   	if [ ! -e $bcache_sysfs ]; then
>   		echo "no bcache sysfs"
>   		exit
>   	fi
> 
>   	cset_uuid=$(ls -l $bcache_sysfs|head -n 2|tail -n 1|awk '{print $9}')
>   	sudo sh -c "echo $cset_uuid > /sys/block/sdb/sdb1/bcache/detach"
>   	sleep 5
>   	sudo sh -c "echo $cset_uuid > /sys/block/sdb/sdb1/bcache/attach"
>   }
> 
>   for ((i=0;i<10;i++)); do
>   	clear_cache
>   done
> 
> The warning messages look like below:
> [  275.948611] ------------[ cut here ]------------
> [  275.963840] WARNING: at fs/sysfs/dir.c:512 sysfs_add_one+0xb8/0xd0() (Tainted: P        W 
> ---------------   )
> [  275.979253] Hardware name: Tecal RH2285
> [  275.994106] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:09.0/0000:08:00.0/host4/target4:2:1/4:2:1:0/block/sdb/sdb1/bcache/cache'
> [  276.024105] Modules linked in: bcache tcp_diag inet_diag ipmi_devintf ipmi_si ipmi_msghandler
> bonding 8021q garp stp llc ipv6 ext3 jbd loop sg iomemory_vsl(P) bnx2 microcode serio_raw i2c_i801
> i2c_core iTCO_wdt iTCO_vendor_support i7core_edac edac_core shpchp ext4 jbd2 mbcache megaraid_sas
> pata_acpi ata_generic ata_piix dm_mod [last unloaded: scsi_wait_scan]
> [  276.072643] Pid: 2765, comm: sh Tainted: P        W  ---------------    2.6.32 #1
> [  276.089315] Call Trace:
> [  276.105801]  [<ffffffff81070fe7>] ? warn_slowpath_common+0x87/0xc0
> [  276.122650]  [<ffffffff810710d6>] ? warn_slowpath_fmt+0x46/0x50
> [  276.139361]  [<ffffffff81205c08>] ? sysfs_add_one+0xb8/0xd0
> [  276.156012]  [<ffffffff8120609b>] ? sysfs_do_create_link+0x12b/0x170
> [  276.172682]  [<ffffffff81206113>] ? sysfs_create_link+0x13/0x20
> [  276.189282]  [<ffffffffa03bda21>] ? bcache_device_link+0xc1/0x110 [bcache]
> [  276.205993]  [<ffffffffa03bfa08>] ? bch_cached_dev_attach+0x478/0x4f0 [bcache]
> [  276.222794]  [<ffffffffa03c4a17>] ? bch_cached_dev_store+0x627/0x780 [bcache]
> [  276.239680]  [<ffffffff8116783a>] ? alloc_pages_current+0xaa/0x110
> [  276.256594]  [<ffffffff81203b15>] ? sysfs_write_file+0xe5/0x170
> [  276.273364]  [<ffffffff811887b8>] ? vfs_write+0xb8/0x1a0
> [  276.290133]  [<ffffffff811890b1>] ? sys_write+0x51/0x90
> [  276.306368]  [<ffffffff8100c072>] ? system_call_fastpath+0x16/0x1b
> [  276.322301] ---[ end trace 9f5d4fcdd0c3edfb ]---
> [  276.338241] ------------[ cut here ]------------
> [  276.354109] WARNING: at /home/wenqing.lz/bcache/bcache/super.c:720
> bcache_device_link+0xdf/0x110 [bcache]() (Tainted: P        W  ---------------   )
> [  276.386017] Hardware name: Tecal RH2285
> [  276.401430] Couldn't create device <-> cache set symlinks
> [  276.401759] Modules linked in: bcache tcp_diag inet_diag ipmi_devintf ipmi_si ipmi_msghandler
> bonding 8021q garp stp llc ipv6 ext3 jbd loop sg iomemory_vsl(P) bnx2 microcode serio_raw i2c_i801
> i2c_core iTCO_wdt iTCO_vendor_support i7core_edac edac_core shpchp ext4 jbd2 mbcache megaraid_sas
> pata_acpi ata_generic ata_piix dm_mod [last unloaded: scsi_wait_scan]
> [  276.465477] Pid: 2765, comm: sh Tainted: P        W  ---------------    2.6.32 #1
> [  276.482169] Call Trace:
> [  276.498610]  [<ffffffff81070fe7>] ? warn_slowpath_common+0x87/0xc0
> [  276.515405]  [<ffffffff810710d6>] ? warn_slowpath_fmt+0x46/0x50
> [  276.532059]  [<ffffffffa03bda3f>] ? bcache_device_link+0xdf/0x110 [bcache]
> [  276.548808]  [<ffffffffa03bfa08>] ? bch_cached_dev_attach+0x478/0x4f0 [bcache]
> [  276.565569]  [<ffffffffa03c4a17>] ? bch_cached_dev_store+0x627/0x780 [bcache]
> [  276.582418]  [<ffffffff8116783a>] ? alloc_pages_current+0xaa/0x110
> [  276.599341]  [<ffffffff81203b15>] ? sysfs_write_file+0xe5/0x170
> [  276.616142]  [<ffffffff811887b8>] ? vfs_write+0xb8/0x1a0
> [  276.632607]  [<ffffffff811890b1>] ? sys_write+0x51/0x90
> [  276.648671]  [<ffffffff8100c072>] ? system_call_fastpath+0x16/0x1b
> [  276.664756] ---[ end trace 9f5d4fcdd0c3edfc ]---
> 
> We forget to clear BCACHE_DEV_UNLINK_DONE flag in bcache_device_attach()
> function when we attach a backing device first time.  After detaching this
> backing device, this flag will be true and sysfs_remove_link() isn't called in
> bcache_device_unlink().  Then when we attach this backing device again,
> sysfs_create_link() will return EEXIST error in bcache_device_link().
> 
> So the fix is trival and we clear this flag in bcache_device_link().
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Tested-by: Joshua Schmid <jschmid@suse.com>
> ---
>  drivers/md/bcache/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 4dd2bb7..f624ae8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -708,6 +708,8 @@ static void bcache_device_link(struct bcache_device *d, struct cache_set *c,
>  	WARN(sysfs_create_link(&d->kobj, &c->kobj, "cache") ||
>  	     sysfs_create_link(&c->kobj, &d->kobj, d->name),
>  	     "Couldn't create device <-> cache set symlinks");
> +
> +	clear_bit(BCACHE_DEV_UNLINK_DONE, &d->flags);
>  }
> 
>  static void bcache_device_detach(struct bcache_device *d)
> -- 
> 2.1.2
> 
