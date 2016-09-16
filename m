From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: [dm-devel] [PATCH v2 1/1] block: fix blk_queue_split() resource
 exhaustion
Date: Fri, 16 Sep 2016 22:14:30 +0200
Message-ID: <20160916201429.GB16208@xoff>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
 <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
 <20160711141042.GY13335@soda.linbit>
 <87lh17efap.fsf@notabene.neil.brown.name>
 <alpine.LRH.2.11.1607121834220.16228@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:27454 "EHLO sw.mfedv.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965126AbcIPUOh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 16:14:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1607121834220.16228@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

[sorry if you get this twice - I haven't seen this message appear on the
list]

On Tue, Jul 12, 2016 at 07:18:58PM -0700, Eric Wheeler wrote:
> since 4.3 related to bio splitting/large bios?  I've been collecting a 
> list, none of which appear have landed yet as of 4.7-rc7 (but correct me 
> if I'm wrong):
> 
> A.  [PATCH v2] block: make sure big bio is splitted into at most 256 bvecs
> 	by Ming Lei: https://patchwork.kernel.org/patch/9169483/
> 
> B.  block: don't make BLK_DEF_MAX_SECTORS too big
> 	by Shaohua Li: http://www.spinics.net/lists/linux-bcache/msg03525.html
> 
> C.  [1/3] block: flush queued bios when process blocks to avoid deadlock
> 	by Mikulas Patocka: https://patchwork.kernel.org/patch/9204125/
> 		(was https://patchwork.kernel.org/patch/7398411/)
> 
> D.  dm-crypt: Fix error with too large bios
> 	by Mikulas Patocka: https://patchwork.kernel.org/patch/9138595/


Hi,

trying to run some qemu-kvm benchmarks over LVM+bcache+mdraid5(4 disks),
on Ubuntu 14.04 x86_64 with various kernels.
Especially with VMs on writeable snapshots, I either get
"bcache_writeback blocked" or "kernel BUG" rather quickly, even with
most recent 4.8.0 kernel. In my benchmark setup, I use 4 VMs each
running on a writeable snapshot from the same (not written to) base LV.
They are Ubuntu 12.04 images doing dist-upgrade including
Kernel-Updates. They also do quite a bit of swapping, as they have only
208MB RAM.

Other (non-KVM) benchmarks directly on /dev/bcache0 ran for more than a
week (kernel 4.4.0) before eventually producing a "blocked for more than
120 seconds" message and stalling I/O on it.


Tried patches A, B, C, E, but only E does still apply to 4.8 (with some
hand-work).

Any other patches I should try?


Regards
Matthias

-----------------------------------------------------------------------

  unmodified 4.8.0-rc6:  after some time, I/O completely stops:

    [ 1571.880480] INFO: task bcache_writebac:5469 blocked for more than 120 seconds.
    [ 1571.916217]       Not tainted 4.8.0-rc6 #1
    [ 1571.934039] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [ 1571.971060] INFO: task qemu-system-x86:6499 blocked for more than 120 seconds.
    [ 1572.009144]       Not tainted 4.8.0-rc6 #1
    [ 1572.028125] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.



  4.8.0-rc5 + LGE's patch (E,
v2-1-1-block-fix-blk_queue_split-resource-exhaustion.patch from
https://patchwork.kernel.org/patch/9223697/ ):
       runs longer than without that patch, but sometimes runs into a
       BUG_ON. By calling "lvremove", I can reliably provoke that BUG.

    [ 1930.459062] kernel BUG at block/bio.c:1789!
    [ 1930.459648] invalid opcode: 0000 [#1] SMP
    [ 1930.460208] Modules linked in: dm_snapshot dm_bufio bcache ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp gpio_ich ipmi_ssif kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd dm_multipath serio_raw ipmi_si input_leds ie31200_edac ipmi_msghandler acpi_power_meter lp hpilo edac_core lpc_ich parport btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor uas usb_storage hid_generic raid6_pq libcrc32c usbhid hid raid1 tg3 raid0 ptp pps
 _core psmouse ahci libahci multipath linear [last unloaded: bcache]
    [ 1930.520004] CPU: 0 PID: 12673 Comm: lvremove Not tainted 4.8.0-rc5 #2
    [ 1930.545645] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 07/16/2015
    [ 1930.571245] task: ffff8ce733702580 task.stack: ffff8ce727900000
    [ 1930.596750] RIP: 0010:[<ffffffff96386e2a>]  [<ffffffff96386e2a>] bio_split+0x8a/0x90
    [ 1930.647161] RSP: 0018:ffff8ce727903b78  EFLAGS: 00010246
    [ 1930.672259] RAX: 00000000000000a8 RBX: 000000000001f000 RCX: ffff8ce724974d00
    [ 1930.697289] RDX: 0000000002400000 RSI: 0000000000000000 RDI: ffff8ce7296ef120
    [ 1930.722309] RBP: ffff8ce727903b90 R08: 0000000000000000 R09: ffff8ce7296ef120
    [ 1930.746862] R10: 00058000ffffffff R11: 0000000000000000 R12: 0000000000000000
    [ 1930.771080] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000000a8
    [ 1930.794656] FS:  00007fd3c64d5840(0000) GS:ffff8ce73a200000(0000) knlGS:0000000000000000
    [ 1930.840550] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 1930.863312] CR2: 00007f8e88bb2000 CR3: 00000002e16f8000 CR4: 00000000001406f0
    [ 1930.886799] Stack:
    [ 1930.909851]  000000000001f000 0000000000000000 0000000000000000 ffff8ce727903c30
    [ 1930.957581]  ffffffff96393aad ffff8ce7281eb890 ffff8ce727903bf0 ffff8ce724974d00
    [ 1931.006067]  0000000000000000 ffff8ce725b62c60 ffff8ce727903c40 00000058281eb890
    [ 1931.054370] Call Trace:
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



  4.4.0 (Ubuntu backport kernel from Ubuntu 16.04 "xenial"):
    [  960.092547] INFO: task bcache_writebac:5260 blocked for more than 120 seconds.
    [  960.093584]       Not tainted 4.4.0-31-generic #50~14.04.1
    [  960.094377] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [  960.095553] INFO: task qemu-system-x86:6179 blocked for more than 120 seconds.
    [  960.096593]       Not tainted 4.4.0-31-generic #50~14.04.1
    [  960.097364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.


  4.2.0 (Ubuntu backport kernel from Ubuntu 15.10 "wily")

    [ 4557.761416] INFO: task bcache_writebac:11995 blocked for more than 120 seconds.
    [ 4557.762454]       Not tainted 4.2.0-36-generic #41~14.04.1-Ubuntu
    [ 4557.763309] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [ 4557.764413] bcache_writebac D 0000000000000000     0 11995      2 0x00000000
    [ 4557.764418]  ffff8803e901bd08 0000000000000046 ffff8803f5992640 ffff8803f5994c80
    [ 4557.764420]  ffff8803e901bd28 ffff8803e901c000 ffff8800a7e80b00 ffff8800a7e80ae8
    [ 4557.764422]  ffffffff00000000 ffffffff00000003 ffff8803e901bd28 ffffffff817bfca7
    [ 4557.764425] Call Trace:
    [ 4557.764433]  [<ffffffff817bfca7>] schedule+0x37/0x80
    [ 4557.764435]  [<ffffffff817c21b0>] rwsem_down_write_failed+0x1d0/0x320
    [ 4557.764447]  [<ffffffffc04c45d3>] ? closure_sync+0x23/0x90 [bcache]
    [ 4557.764452]  [<ffffffff813b8f33>] call_rwsem_down_write_failed+0x13/0x20
    [ 4557.764454]  [<ffffffff817c1a81>] ? down_write+0x31/0x50
    [ 4557.764463]  [<ffffffffc04d960c>] bch_writeback_thread+0x4c/0x480 [bcache]
    [ 4557.764470]  [<ffffffffc04d95c0>] ? read_dirty+0x3f0/0x3f0 [bcache]
    [ 4557.764473]  [<ffffffff81097c62>] kthread+0xd2/0xf0
    [ 4557.764476]  [<ffffffff81097b90>] ? kthread_create_on_node+0x1c0/0x1c0
    [ 4557.764478]  [<ffffffff817c399f>] ret_from_fork+0x3f/0x70
    [ 4557.764480]  [<ffffffff81097b90>] ? kthread_create_on_node+0x1c0/0x1c0
    [ 4557.764484] INFO: task kworker/0:17:13958 blocked for more than 120 seconds.
    [ 4557.765494]       Not tainted 4.2.0-36-generic #41~14.04.1-Ubuntu
    [ 4557.766363] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [ 4557.767467] kworker/0:17    D ffff8803fa216640     0 13958      2 0x00000000
    [ 4557.767476] Workqueue: events update_writeback_rate [bcache]
    [ 4557.767477]  ffff880324dfbcc0 0000000000000046 ffffffff81c14500 ffff8800a894bfc0
    [ 4557.767479]  ffffffff810e3678 ffff880324dfc000 ffff8800a7e80ae8 ffff8800a7e80b00
    [ 4557.767482]  0000000000000000 ffff8800a7e80b28 ffff880324dfbce0 ffffffff817bfca7
    [ 4557.767484] Call Trace:
    [ 4557.767487]  [<ffffffff810e3678>] ? add_timer_on+0xb8/0x120
    [ 4557.767490]  [<ffffffff817bfca7>] schedule+0x37/0x80
    [ 4557.767492]  [<ffffffff817c23e0>] rwsem_down_read_failed+0xe0/0x120
    [ 4557.767495]  [<ffffffff81090270>] ? try_to_grab_pending+0xb0/0x150
    [ 4557.767498]  [<ffffffff813b8f04>] call_rwsem_down_read_failed+0x14/0x30
    [ 4557.767500]  [<ffffffff817c1a44>] ? down_read+0x24/0x30
    [ 4557.767506]  [<ffffffffc04d8b05>] update_writeback_rate+0x25/0x210 [bcache]
    [ 4557.767509]  [<ffffffff81091f1d>] process_one_work+0x14d/0x3f0
    [ 4557.767512]  [<ffffffff8109269a>] worker_thread+0x11a/0x470
    [ 4557.767514]  [<ffffffff81092580>] ? rescuer_thread+0x310/0x310
    [ 4557.767516]  [<ffffffff81097c62>] kthread+0xd2/0xf0
    [ 4557.767519]  [<ffffffff81097b90>] ? kthread_create_on_node+0x1c0/0x1c0
    [ 4557.767521]  [<ffffffff817c399f>] ret_from_fork+0x3f/0x70
    [ 4557.767523]  [<ffffffff81097b90>] ? kthread_create_on_node+0x1c0/0x1c0
