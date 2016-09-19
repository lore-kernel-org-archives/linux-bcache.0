From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: [dm-devel] [PATCH v2 1/1] block: fix blk_queue_split() resource
 exhaustion
Date: Mon, 19 Sep 2016 22:43:13 +0200
Message-ID: <20160919204313.GG16208@xoff>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
 <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
 <20160711141042.GY13335@soda.linbit>
 <87lh17efap.fsf@notabene.neil.brown.name>
 <alpine.LRH.2.11.1607121834220.16228@mail.ewheeler.net>
 <20160916201429.GB16208@xoff>
 <alpine.LRH.2.11.1609181557190.5413@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:28819 "EHLO sw.mfedv.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbcISUna (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2016 16:43:30 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1609181557190.5413@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Sun, Sep 18, 2016 at 04:10:36PM -0700, Eric Wheeler wrote:
> > Hi,
> > 
> > trying to run some qemu-kvm benchmarks over LVM+bcache+mdraid5(4 disks),
> 
> What is your SSD stack for the bcache cachedev?

Hi,

thanks for looking into this.

Caching device is /dev/sdf1 (SATA Intel SSD 520, onboard SATA port).
Also tried with SATA Intel SSD DC 3510 (80GB) and SATA Intel SSD DC 3710
(200GB), same result.

from lsblk:

sdf                                   8:80   0 111.8G  0 disk  
`-sdf1                                8:81   0    15G  0 part  
  `-bcache0                         251:0    0    96G  0 disk  
    |-mbench-t3--d-cow (dm-8)       252:8    0     4G  0 lvm   
    | `-mbench-t3--d (dm-9)         252:9    0    16G  0 lvm   
    |-mbench-t3--c-cow (dm-6)       252:6    0     4G  0 lvm   
    | `-mbench-t3--c (dm-7)         252:7    0    16G  0 lvm   
    |-mbench-t3--b-cow (dm-4)       252:4    0     4G  0 lvm   
    | `-mbench-t3--b (dm-5)         252:5    0    16G  0 lvm   
    |-mbench-t3--a-cow (dm-2)       252:2    0     4G  0 lvm   
    | `-mbench-t3--a (dm-3)         252:3    0    16G  0 lvm   
    `-mbench-t3--base-real (dm-0)   252:0    0    16G  0 lvm   
      |-mbench-t3--base (dm-1)      252:1    0    16G  0 lvm   
      |-mbench-t3--d (dm-9)         252:9    0    16G  0 lvm   
      |-mbench-t3--c (dm-7)         252:7    0    16G  0 lvm   
      |-mbench-t3--b (dm-5)         252:5    0    16G  0 lvm   
      `-mbench-t3--a (dm-3)         252:3    0    16G  0 lvm   


> Please cat /proc/pid/stack for each hanging pid.  
> I wonder, just where are those tasks stuck?

Sorry everybody, this is going to be a lot of lines...


[100651.768471] INFO: task bcache_writebac:20176 blocked for more than 120 seconds.
[100651.816814]       Not tainted 4.8.0-rc6 #1
[100651.840607] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/20176/stack
    [<ffffffffb03ccd37>] call_rwsem_down_write_failed+0x17/0x30
    [<ffffffffc07a708f>] bch_writeback_thread+0x4f/0x830 [bcache]
    [<ffffffffb0093fb9>] kthread+0xc9/0xe0
    [<ffffffffb07b4f9f>] ret_from_fork+0x1f/0x40
    [<ffffffffffffffff>] 0xffffffffffffffff



[100651.887932] INFO: task qemu-system-x86:21643 blocked for more than 120 seconds.
[100651.936122]       Not tainted 4.8.0-rc6 #1
[100651.959828] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/21643/stack
    [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
    [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
    [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
    [<ffffffffb038db5d>] submit_bio+0x6d/0x150
    [<ffffffffb023c099>] do_blockdev_direct_IO+0x20a9/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fca84>] __vfs_write+0xc4/0x120
    [<ffffffffb01fd0d2>] vfs_write+0xb2/0x1b0
    [<ffffffffb01fe579>] SyS_pwrite64+0x69/0xa0
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff



[100652.007005] INFO: task qemu-system-x86:21901 blocked for more than 120 seconds.
[100652.055399]       Not tainted 4.8.0-rc6 #1
[100652.079430] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/21901/stack
    [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
    [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
    [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
    [<ffffffffb038db5d>] submit_bio+0x6d/0x150
    [<ffffffffb023c099>] do_blockdev_direct_IO+0x20a9/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fc96a>] do_iter_readv_writev+0x9a/0xf0
    [<ffffffffb01fd348>] do_readv_writev+0x178/0x210
    [<ffffffffb01fd5fc>] vfs_writev+0x3c/0x50
    [<ffffffffb01fd782>] do_pwritev+0xa2/0xc0
    [<ffffffffb01fe761>] SyS_pwritev+0x11/0x20
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff



[100652.127291] INFO: task qemu-system-x86:22187 blocked for more than 120 seconds.
[100652.175391]       Not tainted 4.8.0-rc6 #1
[100652.199342] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.


    # cat /proc/22187/stack
    [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
    [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
    [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
    [<ffffffffb038db5d>] submit_bio+0x6d/0x150
    [<ffffffffb023c099>] do_blockdev_direct_IO+0x20a9/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fc96a>] do_iter_readv_writev+0x9a/0xf0
    [<ffffffffb01fd348>] do_readv_writev+0x178/0x210
    [<ffffffffb01fd5fc>] vfs_writev+0x3c/0x50
    [<ffffffffb01fd782>] do_pwritev+0xa2/0xc0
    [<ffffffffb01fe761>] SyS_pwritev+0x11/0x20
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff


[100652.247053] INFO: task qemu-system-x86:22219 blocked for more than 120 seconds.
[100652.295013]       Not tainted 4.8.0-rc6 #1
[100652.318954] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/22219/stack
    [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
    [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
    [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
    [<ffffffffb038db5d>] submit_bio+0x6d/0x150
    [<ffffffffb023ba5f>] do_blockdev_direct_IO+0x1a6f/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fc96a>] do_iter_readv_writev+0x9a/0xf0
    [<ffffffffb01fd348>] do_readv_writev+0x178/0x210
    [<ffffffffb01fd5fc>] vfs_writev+0x3c/0x50
    [<ffffffffb01fd782>] do_pwritev+0xa2/0xc0
    [<ffffffffb01fe761>] SyS_pwritev+0x11/0x20
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff




[100652.366822] INFO: task qemu-system-x86:22025 blocked for more than 120 seconds.
[100652.414457]       Not tainted 4.8.0-rc6 #1
[100652.437851] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/22025/stack
    [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
    [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
    [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
    [<ffffffffb038db5d>] submit_bio+0x6d/0x150
    [<ffffffffb023c099>] do_blockdev_direct_IO+0x20a9/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fc96a>] do_iter_readv_writev+0x9a/0xf0
    [<ffffffffb01fd348>] do_readv_writev+0x178/0x210
    [<ffffffffb01fd5fc>] vfs_writev+0x3c/0x50
    [<ffffffffb01fd782>] do_pwritev+0xa2/0xc0
    [<ffffffffb01fe761>] SyS_pwritev+0x11/0x20
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff



[100652.485572] INFO: task qemu-system-x86:22026 blocked for more than 120 seconds.
[100652.533580]       Not tainted 4.8.0-rc6 #1
[100652.557514] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/22026/stack
    [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
    [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
    [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
    [<ffffffffb038db5d>] submit_bio+0x6d/0x150
    [<ffffffffb023c099>] do_blockdev_direct_IO+0x20a9/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fc96a>] do_iter_readv_writev+0x9a/0xf0
    [<ffffffffb01fd348>] do_readv_writev+0x178/0x210
    [<ffffffffb01fd5fc>] vfs_writev+0x3c/0x50
    [<ffffffffb01fd782>] do_pwritev+0xa2/0xc0
    [<ffffffffb01fe761>] SyS_pwritev+0x11/0x20
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff



[100652.605177] INFO: task qemu-system-x86:22049 blocked for more than 120 seconds.
[100652.653163]       Not tainted 4.8.0-rc6 #1
[100652.677089] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/22049/stack
    [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
    [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
    [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
    [<ffffffffb038db5d>] submit_bio+0x6d/0x150
    [<ffffffffb023c099>] do_blockdev_direct_IO+0x20a9/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fc96a>] do_iter_readv_writev+0x9a/0xf0
    [<ffffffffb01fd348>] do_readv_writev+0x178/0x210
    [<ffffffffb01fd5fc>] vfs_writev+0x3c/0x50
    [<ffffffffb01fd782>] do_pwritev+0xa2/0xc0
    [<ffffffffb01fe761>] SyS_pwritev+0x11/0x20
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff



[100652.724800] INFO: task qemu-system-x86:22986 blocked for more than 120 seconds.
[100652.772809]       Not tainted 4.8.0-rc6 #1
[100652.796748] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/22986/stack
    [<ffffffffb03ccd08>] call_rwsem_down_read_failed+0x18/0x30
    [<ffffffffc079b130>] cached_dev_make_request+0x640/0xdb0 [bcache]
    [<ffffffffb038da31>] generic_make_request+0xe1/0x1a0
    [<ffffffffb038db5d>] submit_bio+0x6d/0x150
    [<ffffffffb023c099>] do_blockdev_direct_IO+0x20a9/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fca84>] __vfs_write+0xc4/0x120
    [<ffffffffb01fd0d2>] vfs_write+0xb2/0x1b0
    [<ffffffffb01fe579>] SyS_pwrite64+0x69/0xa0
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff



[100652.844461] INFO: task qemu-system-x86:21846 blocked for more than 120 seconds.
[100652.892484]       Not tainted 4.8.0-rc6 #1
[100652.916426] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

    # cat /proc/21846/stack
    [<ffffffffb023bca8>] do_blockdev_direct_IO+0x1cb8/0x24b0
    [<ffffffffb023c4da>] __blockdev_direct_IO+0x3a/0x40
    [<ffffffffb0236f13>] blkdev_direct_IO+0x43/0x50
    [<ffffffffb0182071>] generic_file_direct_write+0xa1/0x150
    [<ffffffffb01821db>] __generic_file_write_iter+0xbb/0x1e0
    [<ffffffffb0237662>] blkdev_write_iter+0x72/0xd0
    [<ffffffffb01fc96a>] do_iter_readv_writev+0x9a/0xf0
    [<ffffffffb01fd348>] do_readv_writev+0x178/0x210
    [<ffffffffb01fd5fc>] vfs_writev+0x3c/0x50
    [<ffffffffb01fd782>] do_pwritev+0xa2/0xc0
    [<ffffffffb01fe761>] SyS_pwritev+0x11/0x20
    [<ffffffffb07b4d76>] entry_SYSCALL_64_fastpath+0x1e/0xa8
    [<ffffffffffffffff>] 0xffffffffffffffff



> >   4.8.0-rc5 + LGE's patch (E,
> > v2-1-1-block-fix-blk_queue_split-resource-exhaustion.patch from
> > https://patchwork.kernel.org/patch/9223697/ ):
> >        runs longer than without that patch, but sometimes runs into a
> >        BUG_ON. By calling "lvremove", I can reliably provoke that BUG.
> > 
> >     [ 1930.459062] kernel BUG at block/bio.c:1789!
> >     [ 1930.459648] invalid opcode: 0000 [#1] SMP
> >     [ 1931.251942]  [<ffffffff9639c360>] blk_ioctl_discard+0x80/0xa0
>
> Looks discard related.  If you get a good way to reproduce reliabily, 
> then please report a new BUG thread and Cc linux-block.
> 
> Try turning off discard and see if the issue goes away.

Tried that yesterday, still got that BUG, but not at lvremove time.
Running again right now, since almost 7h, without error or blocked
threads. But today I run it _without_ monitoring
/sys/block/bcache0/bcache/writeback_rate_debug (was mentioned on the
list as possibly dangerous) and _without_ watching the vm host overview
with virt-manager (libvirtd might want to inspect storage pools at the
wrong time).  

So apparently this is triggered by discard.

My method of disabling discard is
   echo '0' >find /sys/ -path '*/block/*' -name 'discard*' | while read x; do echo '0' >"${x}"; done

Seems to work but lacks elegance :-) Is there some better way?


> >   4.2.0 (Ubuntu backport kernel from Ubuntu 15.10 "wily")
> 
> There was a lot of churn from v4.2 to v4.3 in the block layer.  Please 
> test with v4.1.31 or newer.  If you find a working version, then a bisect 
> would be useful.

Oh. My git-fu is really weak, will have to read up on bisect. This might
take several days :-/


Regards
Matthias
