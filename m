From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: [PATCH] bcache: backing device set to clean after finishing detach
Date: Fri, 18 Dec 2015 12:56:54 +0800
Message-ID: <CAC8teKXae0oRrzki3ky2-WQ9rm1zqCRTmCqSBpaM7GKSpQXn4g@mail.gmail.com>
References: <566AAB9A.8040201@evilazrael.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35318 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbbLRE5O (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 17 Dec 2015 23:57:14 -0500
Received: by mail-oi0-f51.google.com with SMTP id l9so25591963oia.2
        for <linux-bcache@vger.kernel.org>; Thu, 17 Dec 2015 20:57:14 -0800 (PST)
In-Reply-To: <566AAB9A.8040201@evilazrael.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

2015-12-11 18:55 GMT+08:00 Christoph Nelles <evilazrael@evilazrael.de>:
> Hi,
> first time sending a patch, please be kind.
>
> Detaching a cache set from a backing device set to writeback with dirty
> data in it may cause the backing device to get a final state of
> BDEV_STATE_CLEAN instead of BDEV_STATE_NONE. bcache-supert-show will
> show this as:
>
> dev.data.cache_state        1 [clean]
>
> cset.uuid                00000000-0000-0000-0000-000000000000
>
> When trying to register this device, the kernel will log the message
> "bcache: register_bdev() registered backing device md126" but no
> /dev/bcache* and /sys/block/bcache* device will show up. Registering the
> device a second time will hang the echo. Unloading the bcache module is
> not possible as the refcount is increased. There's no way to stop this
> device within bcache as there is no sysfs entry. The issue is persistent.
>
> Johannes Thumshirn fron SUSE assuemes it may only happen when using
> Software RAIDs for the bcache devices.
>
>
> Steps to reproduce:
> Setup /dev/md/cache as bcache caching device
> Setup /dev/md/storage as bcache caching device in writeback mode
> Startup bcache and make sure the cache set is attached
> Format /dev/bcache0 with XFS and mount it at /x
> ./fio --name=test --filename=/x/test.dat --bs=1M --rw=randwrite
> --size=128G --fallocate=none
> There should be >100GB of dirty data for /dev/bcache0 (check from
> /sys/block/bcache0/bcache/dirty_data)
> Then immediately do echo 1 > /sys/block/bcache0/bcache/detach
> Wait until all dirty data was written back. With a high probability
> /sys/block/bcache0/bcache/state will be clean instead of "no cache"
>
> Reboot the system, try to register the device
> # echo /dev/md/storage > /sys/fs/bcache/register
> # dmesg |tail
> [ 1248.965231] bcache: register_bdev() registered backing device md127
> # ls -al /dev/bcache?
> ls: cannot access /dev/bcache?: No such file or directory
> # ls -al /sys/block/bcache?
> ls: cannot access /sys/block/bcache?: No such file or directory
> # grep ^bcache /proc/modules
> bcache 238115 1 - Live 0xffffffffa0582000
> # rmmod bcache
> rmmod: ERROR: Module bcache is in use
>
>
>
> I looked into the code. There are only two places in the kernel where
> the cache state is set to "clean". It looks that due to the asynchrony
> in the bcache module  SET_BDEV_STATE() in writeback.c/refill_dirty() may
> be called after the function super.c/cached_dev_detach_finished() and
> sets the the state from BDEV_STATE_NONE (set by
> cached_dev_detach_finished()) to BDEV_STATE_CLEAN. I do not understand
> completely the flow in bcache  but adding an additional check in
> refill_dirty() to not change the state from NONE to CLEAN is probably
> the most minimal change to prevent having a detached backing device in
> the state CLEAN.
> I tested the patch multiple times and with different operations, the
> issue is gone and there were no side-effects.
>
> The patch is against 3.12.
>
> Signed-off-by: Christoph Nelles <evilazrael@evilazrael.de>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>
>
> diff -rup linux/drivers/md/bcache/writeback.c
> linux-fix/drivers/md/bcache/writeback.c
> --- linux/drivers/md/bcache/writeback.c 2015-10-05 12:08:10.000000000 +0200
> +++ linux-fix/drivers/md/bcache/writeback.c     2015-12-09
> 15:55:46.524238412 +0100
> @@ -169,8 +169,11 @@ static void refill_dirty(struct closure
>         down_write(&dc->writeback_lock);
>
>         if (!atomic_read(&dc->has_dirty)) {
> -               SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
> -               bch_write_bdev_super(dc, NULL);
> +
        mutex_lock(&bch_register_lock); See
cached_dev_detach_finish(), the flag is protected by it.

> +               if (BDEV_STATE(&dc->sb) != BDEV_STATE_NONE) {
> +                       SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
> +                       bch_write_bdev_super(dc, NULL);
This should be a sync write
> +               }
        mutex_unlock(&bch_register_lock);

Also this patch makes me remember there is still a similar catch in
bch_writeback_add(), as the comment in it reads, "/* XXX: should do
this synchronously */". An async superblock write here means he old
superblock write with BDEV_STATE_DIRTY might arrive at SSD later than
the write with BDEV_STATE_NONE in cached_dev_detach_finish()  , which
still leads to the register fail in the future.

My another question is, the register fail for a BDEV_STATE_CLEAN or
BDEV_STATE_DIRTY backend device is caused by

        if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
            BDEV_STATE(&dc->sb) == BDEV_STATE_STALE)
                bch_cached_dev_run(dc);

Do we really need this check?

-zyh

>
>                 up_write(&dc->writeback_lock);
>                 closure_return(cl);
>
>
>
>
> --
> Christoph Nelles
>
> E-Mail    : evilazrael@evilazrael.de
> Jabber    : eazrael@evilazrael.net      ICQ       : 78819723
>
> PGP-Key   : ID 0x3123487D on subkeys.pgp.net
>             or https://evilazrael.net/pgp.txt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
