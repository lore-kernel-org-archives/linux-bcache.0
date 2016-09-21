From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: bcache: discard BUG (was: [dm-devel] [PATCH v2 1/1] block: fix
 blk_queue_split() resource exhaustion)
Date: Wed, 21 Sep 2016 14:08:06 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609211351070.29933@mail.ewheeler.net>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com> <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com> <20160711141042.GY13335@soda.linbit> <87lh17efap.fsf@notabene.neil.brown.name> <alpine.LRH.2.11.1607121834220.16228@mail.ewheeler.net>
 <20160916201429.GB16208@xoff> <alpine.LRH.2.11.1609181557190.5413@mail.ewheeler.net> <20160919204313.GG16208@xoff>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:46060 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752679AbcIUVKt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Sep 2016 17:10:49 -0400
In-Reply-To: <20160919204313.GG16208@xoff>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthias Ferdinand <bcache@mfedv.net>
Cc: linux-bcache@vger.kernel.org

On Mon, 19 Sep 2016, Matthias Ferdinand wrote:
> On Sun, Sep 18, 2016 at 04:10:36PM -0700, Eric Wheeler wrote:
> > > Hi,
> > > 
> > > trying to run some qemu-kvm benchmarks over LVM+bcache+mdraid5(4 disks),
> > 
> > What is your SSD stack for the bcache cachedev?
> 
> Hi,
> 
> thanks for looking into this.
> 
> Caching device is /dev/sdf1 (SATA Intel SSD 520, onboard SATA port).
> Also tried with SATA Intel SSD DC 3510 (80GB) and SATA Intel SSD DC 3710
> (200GB), same result.
> 
> from lsblk:
> 
> sdf                                   8:80   0 111.8G  0 disk  
> `-sdf1                                8:81   0    15G  0 part  
>   `-bcache0                         251:0    0    96G  0 disk  
>     |-mbench-t3--d-cow (dm-8)       252:8    0     4G  0 lvm   
>     | `-mbench-t3--d (dm-9)         252:9    0    16G  0 lvm   
>     |-mbench-t3--c-cow (dm-6)       252:6    0     4G  0 lvm   
>     | `-mbench-t3--c (dm-7)         252:7    0    16G  0 lvm   
>     |-mbench-t3--b-cow (dm-4)       252:4    0     4G  0 lvm   
>     | `-mbench-t3--b (dm-5)         252:5    0    16G  0 lvm   
>     |-mbench-t3--a-cow (dm-2)       252:2    0     4G  0 lvm   
>     | `-mbench-t3--a (dm-3)         252:3    0    16G  0 lvm   
>     `-mbench-t3--base-real (dm-0)   252:0    0    16G  0 lvm   
>       |-mbench-t3--base (dm-1)      252:1    0    16G  0 lvm   
>       |-mbench-t3--d (dm-9)         252:9    0    16G  0 lvm   
>       |-mbench-t3--c (dm-7)         252:7    0    16G  0 lvm   
>       |-mbench-t3--b (dm-5)         252:5    0    16G  0 lvm   
>       `-mbench-t3--a (dm-3)         252:3    0    16G  0 lvm   
> 
> 
> > Please cat /proc/pid/stack for each hanging pid.  
> > I wonder, just where are those tasks stuck?
> 
> Sorry everybody, this is going to be a lot of lines...
> 
> 
> [100651.768471] INFO: task bcache_writebac:20176 blocked for more than 120 seconds.
> [100651.816814]       Not tainted 4.8.0-rc6 #1
> [100651.840607] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 
>     # cat /proc/20176/stack
>     [<ffffffffb03ccd37>] call_rwsem_down_write_failed+0x17/0x30
>     [<ffffffffc07a708f>] bch_writeback_thread+0x4f/0x830 [bcache]
>     [<ffffffffb0093fb9>] kthread+0xc9/0xe0
>     [<ffffffffb07b4f9f>] ret_from_fork+0x1f/0x40
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> 
> 
> [100651.887932] INFO: task qemu-system-x86:21643 blocked for more than 120 seconds.
> [100651.936122]       Not tainted 4.8.0-rc6 #1
> [100651.959828] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 
>     # cat /proc/21643/stack
>     [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
>     [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
>     [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
>     [<ffffffffb038db5d>] submit_bio+0x6d/0x150
>     [<ffffffffb023c099>] do_blockdev_direct_IO+0x20a9/0x24b0
>     [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
>     [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
>     [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
>     [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
>     [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
>     [<ffffffffb01fca84>] __vfs_write+0xc4/0x120
>     [<ffffffffb01fd0d2>] vfs_write+0xb2/0x1b0
>     [<ffffffffb01fe579>] SyS_pwrite64+0x69/0xa0
>     [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
>     [<ffffffffffffffff>] 0xffffffffffffffff

Looks like a deadlock, maybe?  Kent is good at troubleshooting those.

> > >   4.8.0-rc5 + LGE's patch (E,
> > > v2-1-1-block-fix-blk_queue_split-resource-exhaustion.patch from
> > > https://patchwork.kernel.org/patch/9223697/ ):
> > >        runs longer than without that patch, but sometimes runs into a
> > >        BUG_ON. By calling "lvremove", I can reliably provoke that BUG.
> > > 
> > >     [ 1930.459062] kernel BUG at block/bio.c:1789!
> > >     [ 1930.459648] invalid opcode: 0000 [#1] SMP
> > >     [ 1931.251942]  [<ffffffff9639c360>] blk_ioctl_discard+0x80/0xa0
> >
> > Looks discard related.  If you get a good way to reproduce reliabily, 
> > then please report a new BUG thread and Cc linux-block.
> > 
> > Try turning off discard and see if the issue goes away.
> 
> Tried that yesterday, still got that BUG, but not at lvremove time.
> Running again right now, since almost 7h, without error or blocked
> threads. But today I run it _without_ monitoring
> /sys/block/bcache0/bcache/writeback_rate_debug (was mentioned on the
> list as possibly dangerous) 

Yes, I've hit the writeback_rate_debug but haven't investigated the cause.  
I think it should be removed or simplified for safety.  Patches welcome.

> and _without_ watching the vm host overview with virt-manager (libvirtd 
> might want to inspect storage pools at the wrong time).

virt-manager should be safe.

> So apparently this is triggered by discard.

likely.
 
> My method of disabling discard is
>    echo '0' >find /sys/ -path '*/block/*' -name 'discard*' | while read x; do echo '0' >"${x}"; done
> 
> Seems to work but lacks elegance :-) Is there some better way?

Not to my knowledge.  Just setting discard=0 on bcache0 lower-level devs 
before mounting an fs is probably enough.

> > >   4.2.0 (Ubuntu backport kernel from Ubuntu 15.10 "wily")
> > 
> > There was a lot of churn from v4.2 to v4.3 in the block layer.  Please 
> > test with v4.1.31 or newer.  If you find a working version, then a bisect 
> > would be useful.
> 
> Oh. My git-fu is really weak, will have to read up on bisect. This might
> take several days :-/

The discard bug keeps coming up, I have a feeling you'll find it in v4.1
too---but it would be good to know for sure.  All of my production 
environments are discardless.  If it fails in v4.1, then it would be great 
to investigate this while you have a reproducable problem.  


Can anyone suggest where to start debugging the discard problem based on 
the backtraces in this thread?

Specifically, why is bio_split being with a bad value of sectors?  Is it 
sectors=0 because it is a discard?

This might be relevant:

    [ 1930.459062] kernel BUG at block/bio.c:1789! Matthias, which BUG_ON 
is this below in your code?  My codepaste is below if v4.7 from LXR, I 
don't have 4.8 handy.

    [ 1930.459648] invalid opcode: 0000 [#1] SMP
    [ 1930.520004] CPU: 0 PID: 12673 Comm: lvremove Not tainted 4.8.0-rc5 #2
    [ 1930.545645] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 07/16/2015
    [ 1931.077608]  [<ffffffff96393aad>] blk_queue_split+0x47d/0x640
    [ 1931.101157]  [<ffffffff9638f3a4>] blk_queue_bio+0x44/0x390
    [ 1931.124083]  [<ffffffff9638d8c4>] generic_make_request+0x104/0x1b0
    [ 1931.146371]  [<ffffffff9638d9dd>] submit_bio+0x6d/0x150
    [ 1931.168393]  [<ffffffff96385649>] ? bio_alloc_bioset+0x169/0x2b0
    [ 1931.189853]  [<ffffffff96395e68>] next_bio+0x38/0x40
    [ 1931.210743]  [<ffffffff96395f93>] __blkdev_issue_discard+0x123/0x1c0
    [ 1931.231522]  [<ffffffff963961c2>] blkdev_issue_discard+0x52/0xa0
    [ 1931.251942]  [<ffffffff9639c360>] blk_ioctl_discard+0x80/0xa0
    [ 1931.272067]  [<ffffffff9639cfb6>] blkdev_ioctl+0x716/0x8c0
    [ 1931.291454]  [<ffffffff9621db04>] ? mntput+0x24/0x40
    [ 1931.310551]  [<ffffffff96237231>] block_ioctl+0x41/0x50
    [ 1931.329247]  [<ffffffff96210676>] do_vfs_ioctl+0x96/0x5a0
    [ 1931.347634]  [<ffffffff961bb7d8>] ? do_munmap+0x298/0x390
    [ 1931.366132]  [<ffffffff96210bf9>] SyS_ioctl+0x79/0x90
    [ 1931.384667]  [<ffffffff967b49b6>] entry_SYSCALL_64_fastpath+0x1e/0xa8



1762 /**
1763  * bio_split - split a bio
1764  * @bio:        bio to split
1765  * @sectors:    number of sectors to split from the front of @bio
1766  * @gfp:        gfp mask
1767  * @bs:         bio set to allocate from
1768  *
1769  * Allocates and returns a new bio which represents @sectors from the start of
1770  * @bio, and updates @bio to represent the remaining sectors.
1771  *
1772  * Unless this is a discard request the newly allocated bio will point
1773  * to @bio's bi_io_vec; it is the caller's responsibility to ensure that
1774  * @bio is not freed before the split.
1775  */
1776 struct bio *bio_split(struct bio *bio, int sectors,
1777                       gfp_t gfp, struct bio_set *bs)
1778 {
1779         struct bio *split = NULL;
1780 

# One of these two:
1781         BUG_ON(sectors <= 0);
1782         BUG_ON(sectors >= bio_sectors(bio));

-Eric

> 
> 
> Regards
> Matthias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
