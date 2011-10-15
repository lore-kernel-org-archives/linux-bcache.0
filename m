From: Brad Campbell <lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Bcache explodes when trying to attach
Date: Sat, 15 Oct 2011 13:43:44 +0800
Message-ID: <4E991D90.1040008@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I'm trying bcache merged with linus' git head (-rc9). I suppose I should really try it with a 
vanilla bcache-dev tree.

Anyway, I can register the cache and backing device but when I try and attach the cache set to the 
backing device this happens :

Cache is /dev/sde. Backing device is /dev/md10 (4 disk RAID10)

[  129.896180] bio: create slab <bio-2> at 2
[  129.972092] bcache: journal replay done, 0 keys in 2 entries, seq 1-2
[  157.704117] md: resync of RAID array md10
[  157.704161] ------------[ cut here ]------------
[  157.704168] kernel BUG at drivers/scsi/scsi_lib.c:1152!
[  157.704174] invalid opcode: 0000 [#1] SMP
[  157.704179] CPU 0
[  157.704181] Modules linked in: nfs ipt_MASQUERADE xt_tcpudp iptable_filter iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables deflate zlib_deflate des_generic 
cbc ecb crypto_blkcipher sha1_generic md5 hmac crypto_hash cryptomgr aead crypto_algapi af_key fuse 
w83627ehf hwmon_vid netconsole configfs vhost_net powernow_k8 mperf kvm_amd kvm i2c_piix4 xhci_hcd 
k10temp ohci_hcd ehci_hcd atl1c ahci libahci usbcore megaraid_sas [last unloaded: scsi_wait_scan]
[  157.704233]
[  157.704239] Pid: 1422, comm: md10_raid10 Not tainted 3.1.0-rc9-00143-g9468c19 #5 To Be Filled By 
O.E.M. To Be Filled By O.E.M./890GX Extreme4 R2.0
[  157.704249] RIP: 0010:[<ffffffff812a541e>]  [<ffffffff812a541e>] scsi_setup_fs_cmnd+0xae/0xf0
[  157.704263] RSP: 0018:ffff88041ba33be0  EFLAGS: 00010046
[  157.704268] RAX: 0000000000000000 RBX: ffff88041bbe3428 RCX: 0000000000001000
[  157.704273] RDX: 0000000000000000 RSI: ffff88041bbe3428 RDI: ffff88041d42b000
[  157.704278] RBP: ffff88041d42b000 R08: 0000000000000000 R09: 0000000000000001
[  157.704282] R10: a080000000000000 R11: dead000000100100 R12: ffff88041d42b000
[  157.704287] R13: 000000000e9c3408 R14: ffff88041d42b048 R15: ffff88041c6a7400
[  157.704293] FS:  00007fa45e67e700(0000) GS:ffff88042fc00000(0000) knlGS:0000000000000000
[  157.704298] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  157.704305] CR2: 0000000000824008 CR3: 0000000407f12000 CR4: 00000000000006f0
[  157.704309] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  157.704314] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  157.704320] Process md10_raid10 (pid: 1422, threadinfo ffff88041ba32000, task ffff88041c779880)
[  157.704323] Stack:
[  157.704326]  0000000000000000 ffff88041bbe3428 ffff88041b998000 ffffffff812aff1c
[  157.704333]  01ff88041d42b800 ffff880400000001 ffff880400001000 0000000000000000
[  157.704339]  ffff88041bbe3428 ffff88041bbe3428 ffff88041bbe3428 ffff88041b998000
[  157.704346] Call Trace:
[  157.704356]  [<ffffffff812aff1c>] ? sd_prep_fn+0x15c/0xa50
[  157.704364]  [<ffffffff811c29e4>] ? blk_peek_request+0xb4/0x1d0
[  157.704371]  [<ffffffff812a4940>] ? scsi_request_fn+0x50/0x4a0
[  157.704377]  [<ffffffff811c3398>] ? blk_flush_plug_list+0x188/0x210
[  157.704384]  [<ffffffff811c342b>] ? blk_finish_plug+0xb/0x30
[  157.704392]  [<ffffffff812f2688>] ? raid10d+0x908/0xb50
[  157.704400]  [<ffffffff813ffed5>] ? schedule_timeout+0x1c5/0x230
[  157.704408]  [<ffffffff81055e91>] ? sched_clock_cpu+0x61/0xf0
[  157.704415]  [<ffffffff8130649f>] ? md_thread+0x10f/0x140
[  157.704423]  [<ffffffff81050130>] ? wake_up_bit+0x40/0x40
[  157.704430]  [<ffffffff81306390>] ? md_register_thread+0x100/0x100
[  157.704437]  [<ffffffff81306390>] ? md_register_thread+0x100/0x100
[  157.704443]  [<ffffffff8104fcd6>] ? kthread+0x96/0xa0
[  157.704452]  [<ffffffff814030f4>] ? kernel_thread_helper+0x4/0x10
[  157.704459]  [<ffffffff8104fc40>] ? kthread_worker_fn+0x120/0x120
[  157.704467]  [<ffffffff814030f0>] ? gs_change+0xb/0xb
[  157.704470] Code: 80 00 00 00 00 48 83 c4 08 5b 5d c3 90 48 89 ef be 20 00 00 00 e8 73 a2 ff ff 
48 85 c0 48 89 c7 74 d7 48 89 83 d8 00 00 00 eb 8d <0f> 0b eb fe 48 8b 00 48 85 c0 0f 84 67 ff ff ff 
48 8b 40 50 48
[  157.704510] RIP  [<ffffffff812a541e>] scsi_setup_fs_cmnd+0xae/0xf0
[  157.704517]  RSP <ffff88041ba33be0>
[  157.704522] ---[ end trace 3cdc1163f94b6a24 ]---
[  157.704526] Kernel panic - not syncing: Fatal exception
[  157.704532] Pid: 1422, comm: md10_raid10 Tainted: G      D     3.1.0-rc9-00143-g9468c19 #5
[  157.704536] Call Trace:
[  157.704542]  [<ffffffff813feb89>] ? panic+0x92/0x193
[  157.704549]  [<ffffffff81035341>] ? kmsg_dump+0x41/0xf0
[  157.704557]  [<ffffffff8100504d>] ? oops_end+0x8d/0xa0
[  157.704564]  [<ffffffff81002e34>] ? do_invalid_op+0x84/0xa0
[  157.704569]  [<ffffffff812a541e>] ? scsi_setup_fs_cmnd+0xae/0xf0
[  157.704577]  [<ffffffff811d078e>] ? cfq_set_request+0x15e/0x3b0
[  157.704584]  [<ffffffff81402f75>] ? invalid_op+0x15/0x20
[  157.704590]  [<ffffffff812a541e>] ? scsi_setup_fs_cmnd+0xae/0xf0
[  157.704598]  [<ffffffff812aff1c>] ? sd_prep_fn+0x15c/0xa50
[  157.704604]  [<ffffffff811c29e4>] ? blk_peek_request+0xb4/0x1d0
[  157.704609]  [<ffffffff812a4940>] ? scsi_request_fn+0x50/0x4a0
[  157.704615]  [<ffffffff811c3398>] ? blk_flush_plug_list+0x188/0x210
[  157.704622]  [<ffffffff811c342b>] ? blk_finish_plug+0xb/0x30
[  157.704628]  [<ffffffff812f2688>] ? raid10d+0x908/0xb50
[  157.704635]  [<ffffffff813ffed5>] ? schedule_timeout+0x1c5/0x230
[  157.704641]  [<ffffffff81055e91>] ? sched_clock_cpu+0x61/0xf0
[  157.704648]  [<ffffffff8130649f>] ? md_thread+0x10f/0x140
[  157.704655]  [<ffffffff81050130>] ? wake_up_bit+0x40/0x40
[  157.704661]  [<ffffffff81306390>] ? md_register_thread+0x100/0x100
[  157.704668]  [<ffffffff81306390>] ? md_register_thread+0x100/0x100
[  157.704675]  [<ffffffff8104fcd6>] ? kthread+0x96/0xa0
[  157.704682]  [<ffffffff814030f4>] ? kernel_thread_helper+0x4/0x10
[  157.704689]  [<ffffffff8104fc40>] ? kthread_worker_fn+0x120/0x120
[  157.704696]  [<ffffffff814030f0>] ? gs_change+0xb/0xb
[  157.707104] Rebooting in 10 seconds..
