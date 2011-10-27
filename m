From: Damien Churchill <damoxc@gmail.com>
Subject: Crash when trying to mount ext4
Date: Thu, 27 Oct 2011 13:59:47 +0100
Message-ID: <CAFtEh-dPs+3foczt0Cjs=gWu42as=scALPAfJo+QPK+C3fRUbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <ceph-devel-owner@vger.kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, ceph-devel <ceph-devel@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

I've been testing bcache with the latest sources from the git tree.
I've been attempting to use a rbd (RADOS block device) as the backing
device. I can format the bcache0 device with mkfs.ext4, however when I
mount it, there is a kernel bug when it attempts to initialize the
filesystem.

I'm unsure if this is a bug in rbd or bcache however, I'm including
the stack trace outputted by the kernel. The kernel has been based off
the current Ubuntu Precise kernel (3.1.0) patched with the changes
from the bcache git repository as well as the changes from the ceph
repository in for-next (the same thing happened without the changes
from the ceph repository). bcache does function as expected when using
a raw disk drive.

Oct 27 13:10:10 dev1 kernel: [  253.509761] ------------[ cut here ]------------
Oct 27 13:10:10 dev1 kernel: [  253.509796] kernel BUG at
/home/dchurchill/Packages/oneiric/linux/linux-3.1.0/fs/bio.c:1504!
Oct 27 13:10:10 dev1 kernel: [  253.509842] invalid opcode: 0000 [#1] SMP
Oct 27 13:10:10 dev1 kernel: [  253.509871] CPU 1
Oct 27 13:10:10 dev1 kernel: [  253.509883] Modules linked in: bnep
rfcomm bluetooth ip6table_filter ip6_tables iptable_filter ip_tables
x_tables parport_pc ppdev binfmt_misc snd_hda_codec_hdmi radeon ttm
bridge stp snd_hda_codec_realtek drm_kms_helper drm snd_hda_intel
snd_hda_codec snd_hwdep snd_seq_midi snd_rawmidi snd_pcm
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
soundcore eeepc_wmi asus_wmi i2c_algo_bit serio_raw snd_page_alloc
sparse_keymap dm_multipath video mei(C) wmi rbd libceph lp parport
r8169 firewire_ohci btrfs firewire_core crc_itu_t pata_marvell ahci
libahci xhci_hcd e1000e zlib_deflate libcrc32c [last unloaded: kvm]
Oct 27 13:10:10 dev1 kernel: [  253.510307]
Oct 27 13:10:10 dev1 kernel: [  253.510318] Pid: 5686, comm:
ext4lazyinit Tainted: G         C  3.1.0-2-generic #4 System
manufacturer System Product Name/P8H67-M EVO
Oct 27 13:10:10 dev1 kernel: [  253.510388] RIP:
0010:[<ffffffff811a1bbf>]  [<ffffffff811a1bbf>] bio_split+0x2bf/0x2d0
Oct 27 13:10:10 dev1 kernel: [  253.510438] RSP: 0018:ffff8803e81939f0
 EFLAGS: 00010212
Oct 27 13:10:10 dev1 kernel: [  253.510467] RAX: ffff8804213d9c60 RBX:
ffff880421dee240 RCX: 0000000000005146
Oct 27 13:10:10 dev1 kernel: [  253.510505] RDX: ffff8803f0c35600 RSI:
0000000000015ec0 RDI: 00000000000001c7
Oct 27 13:10:10 dev1 kernel: [  253.512604] RBP: ffff8803e8193a40 R08:
ffff88043f495ec0 R09: 0000000000000000
Oct 27 13:10:10 dev1 kernel: [  253.514711] R10: 0000000000000001 R11:
000000000005d000 R12: 00000000000002e8
Oct 27 13:10:10 dev1 kernel: [  253.516820] R13: ffff8803f0c35600 R14:
ffff880421dee240 R15: 0000000000000000
Oct 27 13:10:10 dev1 kernel: [  253.518926] FS:
0000000000000000(0000) GS:ffff88043f480000(0000)
knlGS:0000000000000000
Oct 27 13:10:10 dev1 kernel: [  253.521046] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Oct 27 13:10:10 dev1 kernel: [  253.523166] CR2: 00000000004b2730 CR3:
0000000001c05000 CR4: 00000000000406e0
Oct 27 13:10:10 dev1 kernel: [  253.525300] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Oct 27 13:10:10 dev1 kernel: [  253.527443] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Oct 27 13:10:10 dev1 kernel: [  253.529564] Process ext4lazyinit (pid:
5686, threadinfo ffff8803e8192000, task ffff8803f4b39720)
Oct 27 13:10:10 dev1 kernel: [  253.531705] Stack:
Oct 27 13:10:10 dev1 kernel: [  253.533827]  ffff8803e8193a70
0000000000000100 ffff8804213d9c60 00004000e8193b28
Oct 27 13:10:10 dev1 kernel: [  253.535992]  ffff880421dee240
ffff8803e8193b38 ffff8803e8193b30 ffff8803e8fa0000
Oct 27 13:10:10 dev1 kernel: [  253.538174]  ffff880421dee240
0000000000000000 ffff8803e8193aa0 ffffffffa003c02d
Oct 27 13:10:10 dev1 kernel: [  253.540353] Call Trace:
Oct 27 13:10:10 dev1 kernel: [  253.542489]  [<ffffffffa003c02d>]
bio_chain_clone.constprop.25+0x7d/0x180 [rbd]
Oct 27 13:10:10 dev1 kernel: [  253.544632]  [<ffffffffa003e0f5>]
rbd_rq_fn+0x225/0x340 [rbd]
Oct 27 13:10:10 dev1 kernel: [  253.546760]  [<ffffffff812fa45a>] ?
cfq_rq_enqueued+0xca/0x1c0
Oct 27 13:10:10 dev1 kernel: [  253.548842]  [<ffffffff812e5710>]
__make_request+0x2c0/0x330
Oct 27 13:10:10 dev1 kernel: [  253.550890]  [<ffffffff812e2582>]
generic_make_request.part.51+0x242/0x500
Oct 27 13:10:10 dev1 kernel: [  253.552961]  [<ffffffff81112369>] ?
mempool_alloc+0x59/0x140
Oct 27 13:10:10 dev1 kernel: [  253.555026]  [<ffffffff81112369>] ?
mempool_alloc+0x59/0x140
Oct 27 13:10:10 dev1 kernel: [  253.557048]  [<ffffffff8108722e>] ?
wake_up_bit+0x2e/0x40
Oct 27 13:10:10 dev1 kernel: [  253.559039]  [<ffffffff812e2885>]
generic_make_request+0x45/0x60
Oct 27 13:10:10 dev1 kernel: [  253.561018]  [<ffffffff812e2927>]
submit_bio+0x87/0x110
Oct 27 13:10:10 dev1 kernel: [  253.562975]  [<ffffffff811a2eca>] ?
bio_alloc_bioset+0xba/0x100
Oct 27 13:10:10 dev1 kernel: [  253.564934]  [<ffffffff812eaa00>]
blkdev_issue_zeroout+0x110/0x170
Oct 27 13:10:10 dev1 kernel: [  253.566898]  [<ffffffff81211cbb>]
ext4_init_inode_table+0x15b/0x370
Oct 27 13:10:10 dev1 kernel: [  253.568854]  [<ffffffff81637625>] ?
schedule_timeout+0x175/0x320
Oct 27 13:10:10 dev1 kernel: [  253.570820]  [<ffffffff812238d5>]
ext4_run_li_request+0x85/0xe0
Oct 27 13:10:10 dev1 kernel: [  253.572789]  [<ffffffff812239cc>]
ext4_lazyinit_thread+0x9c/0x1c0
Oct 27 13:10:10 dev1 kernel: [  253.574752]  [<ffffffff81223930>] ?
ext4_run_li_request+0xe0/0xe0
Oct 27 13:10:10 dev1 kernel: [  253.576685]  [<ffffffff81086aac>]
kthread+0x8c/0xa0
Oct 27 13:10:10 dev1 kernel: [  253.578587]  [<ffffffff816435f4>]
kernel_thread_helper+0x4/0x10
Oct 27 13:10:10 dev1 kernel: [  253.580482]  [<ffffffff81086a20>] ?
flush_kthread_worker+0xa0/0xa0
Oct 27 13:10:10 dev1 kernel: [  253.582329]  [<ffffffff816435f0>] ?
gs_change+0x13/0x13
Oct 27 13:10:10 dev1 kernel: [  253.584138] Code: 48 89 da 49 83 c6 10
8b 4d cc 48 8b 75 c0 ff d0 48 8b 55 b8 4c 89 f0 4c 29 f8 48 8b 44 02
f0 48 85 c0 75 d8 e9 9f fd ff ff 0f 0b <0f> 0b 66 66 66 66 66 66 2e 0f
1f 84 00 00 00 00 00 55 48 89 e5
Oct 27 13:10:10 dev1 kernel: [  253.588081] RIP  [<ffffffff811a1bbf>]
bio_split+0x2bf/0x2d0
Oct 27 13:10:10 dev1 kernel: [  253.590007]  RSP <ffff8803e81939f0>
Oct 27 13:10:10 dev1 kernel: [  253.600316] ---[ end trace 2d89848a4b76a3dc ]---
