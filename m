From: "Cyril B." <cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org>
Subject: bcache oops in bch_insert_data with the latest stables fixes (3.10.15)
Date: Sun, 06 Oct 2013 12:38:53 +0200
Message-ID: <52513DBD.80005@excellency.fr>
Reply-To: cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hello,

I get the following oops immediately after booting on 3.10.15. 
Everything works fine in 3.10.10. Both the backing and cache devices are 
on top of mdadm.


Oct  6 12:01:33 stats kernel: [   19.742952] BUG: unable to handle 
kernel NULL pointer dereference at 000000000000006c
Oct  6 12:01:33 stats kernel: [   19.743132] IP: [<ffffffffa02119d4>] 
bch_insert_data+0x14/0x20 [bcache]
Oct  6 12:01:33 stats kernel: [   19.743255] PGD 101759f067 PUD 0
Oct  6 12:01:33 stats kernel: [   19.743407] Oops: 0002 [#1] SMP
Oct  6 12:01:33 stats kernel: [   19.743562] Modules linked in: 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state nf_conntrack xt_mul
tiport bcache sb_edac edac_core ehci_pci ehci_hcd coretemp usbcore 
i2c_i801 usb_common ioatdma igb hwmon dca i2c_algo_bit e1000e ptp pps_core
Oct  6 12:01:33 stats kernel: [   19.744814] CPU: 2 PID: 5702 Comm: 
mysqld Not tainted 3.10.15-alwaysdata #1
Oct  6 12:01:33 stats kernel: [   19.744885] Hardware name: Supermicro 
X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 2.0a 
04/19/2013
Oct  6 12:01:33 stats kernel: [   19.744976] task: ffff88101b1fe7c0 ti: 
ffff8810177aa000 task.ti: ffff8810177aa000
Oct  6 12:01:33 stats kernel: [   19.745060] RIP: 
0010:[<ffffffffa02119d4>]  [<ffffffffa02119d4>] 
bch_insert_data+0x14/0x20 [bcache]
Oct  6 12:01:33 stats kernel: [   19.745197] RSP: 0018:ffff8810177ab398 
  EFLAGS: 00010246
Oct  6 12:01:33 stats kernel: [   19.745264] RAX: 0000000000000000 RBX: 
ffff8810177ab3b8 RCX: 0000000000000000
Oct  6 12:01:33 stats kernel: [   19.745334] RDX: ffff88101b8bc378 RSI: 
0000000000000000 RDI: ffff88101b8bc378
Oct  6 12:01:33 stats kernel: [   19.745405] RBP: ffff8810177ab398 R08: 
ffff88102c584000 R09: 000000000000ffff
Oct  6 12:01:33 stats kernel: [   19.745475] R10: ffff88102e3bd540 R11: 
ffffc90010c02ffc R12: ffff88102e3bd540
Oct  6 12:01:33 stats kernel: [   19.745545] R13: ffff88101b8bc278 R14: 
ffff88101bc20000 R15: ffff88101b8bc2d8
Oct  6 12:01:33 stats kernel: [   19.745615] FS:  00007f463d72f6f0(0000) 
GS:ffff88107fc80000(0000) knlGS:0000000000000000
Oct  6 12:01:33 stats kernel: [   19.745701] CS:  0010 DS: 0000 ES: 0000 
CR0: 0000000080050033
Oct  6 12:01:33 stats kernel: [   19.745768] CR2: 000000000000006c CR3: 
000000102f10c000 CR4: 00000000000407e0
Oct  6 12:01:33 stats kernel: [   19.745839] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct  6 12:01:33 stats kernel: [   19.745911] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct  6 12:01:33 stats kernel: [   19.745980] Stack:
Oct  6 12:01:33 stats kernel: [   19.746042]  ffff8810177ab3a8 
ffffffffa021b883 ffff8810177ab408 ffffffffa02103be
Oct  6 12:01:33 stats kernel: [   19.746301]  8000000000000000 
000000007284d9f8 8000000000000000 000000007284d9e0
Oct  6 12:01:33 stats kernel: [   19.746560]  ffff8810177ab408 
ffff88101b8bc278 ffff88101b1fe7c0 ffff88102e3bd540
Oct  6 12:01:33 stats kernel: [   19.746819] Call Trace:
Oct  6 12:01:33 stats kernel: [   19.746888]  [<ffffffffa021b883>] 
closure_queue+0x43/0x60 [bcache]
Oct  6 12:01:33 stats kernel: [   19.746959]  [<ffffffffa02103be>] 
request_write+0x29e/0x3d0 [bcache]
Oct  6 12:01:33 stats kernel: [   19.747030]  [<ffffffffa0210728>] 
cached_dev_make_request+0x238/0x3b0 [bcache]
Oct  6 12:01:33 stats kernel: [   19.747119]  [<ffffffff813e3d62>] 
generic_make_request+0xd2/0x110
Oct  6 12:01:33 stats kernel: [   19.747188]  [<ffffffff813e3e18>] 
submit_bio+0x78/0x130
Oct  6 12:01:33 stats kernel: [   19.747262]  [<ffffffff81165d06>] ? 
bio_alloc_bioset+0x136/0x1d0
Oct  6 12:01:33 stats kernel: [   19.747332]  [<ffffffff812a3a5f>] 
_xfs_buf_ioapply+0x18f/0x370
Oct  6 12:01:33 stats kernel: [   19.747402]  [<ffffffff812ffd3e>] ? 
xlog_bdstrat+0x1e/0x60
Oct  6 12:01:33 stats kernel: [   19.747470]  [<ffffffff812a4c74>] 
xfs_buf_iorequest+0x74/0xa0
Oct  6 12:01:33 stats kernel: [   19.747538]  [<ffffffff812ffd3e>] 
xlog_bdstrat+0x1e/0x60
Oct  6 12:01:33 stats kernel: [   19.747606]  [<ffffffff81300300>] 
xlog_sync+0x2f0/0x470
Oct  6 12:01:33 stats kernel: [   19.747674]  [<ffffffff813005fb>] 
xlog_state_release_iclog+0x9b/0xd0
Oct  6 12:01:33 stats kernel: [   19.747743]  [<ffffffff81300bad>] 
_xfs_log_force+0x1ed/0x270
Oct  6 12:01:33 stats kernel: [   19.747811]  [<ffffffff81300e04>] 
xfs_log_force+0x54/0x80
Oct  6 12:01:33 stats kernel: [   19.747879]  [<ffffffff812a528d>] ? 
_xfs_buf_find+0x15d/0x290
Oct  6 12:01:33 stats kernel: [   19.747948]  [<ffffffff812a3db3>] 
xfs_buf_lock+0xc3/0xd0
Oct  6 12:01:33 stats kernel: [   19.748016]  [<ffffffff812a528d>] 
_xfs_buf_find+0x15d/0x290
Oct  6 12:01:33 stats kernel: [   19.748084]  [<ffffffff812a585f>] 
xfs_buf_get_map+0x2f/0x170
Oct  6 12:01:33 stats kernel: [   19.748161]  [<ffffffff81308187>] 
xfs_trans_get_buf_map+0xe7/0x140
Oct  6 12:01:33 stats kernel: [   19.748231]  [<ffffffff812db312>] 
xfs_da_get_buf+0xb2/0xf0
Oct  6 12:01:33 stats kernel: [   19.748299]  [<ffffffff812e1d20>] 
xfs_dir3_data_init+0x50/0x1e0
Oct  6 12:01:33 stats kernel: [   19.748368]  [<ffffffff812bae15>] ? 
kmem_free+0x35/0x40
Oct  6 12:01:33 stats kernel: [   19.748435]  [<ffffffff812df83e>] 
xfs_dir2_sf_to_block+0xee/0x590
Oct  6 12:01:33 stats kernel: [   19.748504]  [<ffffffff812bad37>] ? 
kmem_zone_alloc+0x77/0xe0
Oct  6 12:01:33 stats kernel: [   19.748573]  [<ffffffff812e9d20>] 
xfs_dir2_sf_addname+0x430/0x520
Oct  6 12:01:33 stats kernel: [   19.748643]  [<ffffffff812b2430>] ? 
xfs_setup_inode+0x210/0x310
Oct  6 12:01:33 stats kernel: [   19.748713]  [<ffffffff812df29c>] 
xfs_dir_createname+0x14c/0x1b0
Oct  6 12:01:33 stats kernel: [   19.748786]  [<ffffffff812b9e8e>] 
xfs_create+0x4ae/0x5c0
Oct  6 12:01:33 stats kernel: [   19.748854]  [<ffffffff813079c7>] ? 
xfs_trans_log_buf+0xb7/0xd0
Oct  6 12:01:33 stats kernel: [   19.748923]  [<ffffffff812b1b1a>] 
xfs_vn_mknod+0x8a/0x1a0
Oct  6 12:01:33 stats kernel: [   19.748991]  [<ffffffff812b1c5e>] 
xfs_vn_create+0xe/0x10
Oct  6 12:01:33 stats kernel: [   19.749064]  [<ffffffff8113dfa1>] 
vfs_create+0xb1/0xe0
Oct  6 12:01:33 stats kernel: [   19.749131]  [<ffffffff8113f440>] 
do_last+0xad0/0xdb0
Oct  6 12:01:33 stats kernel: [   19.749198]  [<ffffffff8113bd8d>] ? 
inode_permission+0x3d/0x60
Oct  6 12:01:33 stats kernel: [   19.749267]  [<ffffffff8113f7fa>] 
path_openat+0xda/0x4b0
Oct  6 12:01:33 stats kernel: [   19.749339]  [<ffffffff81145630>] ? 
d_lookup+0x30/0x50
Oct  6 12:01:33 stats kernel: [   19.749406]  [<ffffffff8113fd13>] 
do_filp_open+0x43/0xa0
Oct  6 12:01:33 stats kernel: [   19.749479]  [<ffffffff8114c99e>] ? 
__alloc_fd+0xde/0x140
Oct  6 12:01:33 stats kernel: [   19.749549]  [<ffffffff8112e210>] 
do_sys_open+0x160/0x1f0
Oct  6 12:01:33 stats kernel: [   19.749617]  [<ffffffff8112e2d9>] 
SyS_open+0x19/0x20
Oct  6 12:01:33 stats kernel: [   19.749688]  [<ffffffff816a05d2>] 
system_call_fastpath+0x16/0x1b
Oct  6 12:01:33 stats kernel: [   19.749756] Code: bd b8 fe ff ff be 01 
00 00 20 e8 e8 9e 00 00 e9 4f fd ff ff 0f 1f 00 48 8d 47 68 55 48 89 47 
60 48 89 47 58 48 89 e5 48 8b 47 40 <f0> ff 40 6c e8 53 f4 ff ff c9 c3 
90 55 48 89 e5 41 55 4c 8d af
Oct  6 12:01:33 stats kernel: [   19.752730] RIP  [<ffffffffa02119d4>] 
bch_insert_data+0x14/0x20 [bcache]
Oct  6 12:01:33 stats kernel: [   19.752845]  RSP <ffff8810177ab398>
Oct  6 12:01:33 stats kernel: [   19.752909] CR2: 000000000000006c
Oct  6 12:01:33 stats kernel: [   19.752981] ---[ end trace 
1774b77e3cdc2a57 ]---
Oct  6 12:01:39 stats kernel: [   25.471716] BUG: unable to handle 
kernel NULL pointer dereference at 000000000000006c
Oct  6 12:01:39 stats kernel: [   25.471896] IP: [<ffffffffa02119d4>] 
bch_insert_data+0x14/0x20 [bcache]
Oct  6 12:01:39 stats kernel: [   25.472017] PGD 101b3e6067 PUD 
101b8b1067 PMD 0
Oct  6 12:01:39 stats kernel: [   25.472215] Oops: 0002 [#2] SMP
Oct  6 12:01:39 stats kernel: [   25.472368] Modules linked in: 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state nf_conntrack xt_multiport bcache sb_edac edac_core ehci_pci 
ehci_hcd coretemp usbcore i2c_i801 usb_common ioatdma igb hwmon dca 
i2c_algo_bit e1000e ptp pps_core
Oct  6 12:01:39 stats kernel: [   25.473619] CPU: 5 PID: 5319 Comm: 
php5-fpm Tainted: G      D      3.10.15-alwaysdata #1
Oct  6 12:01:39 stats kernel: [   25.473705] Hardware name: Supermicro 
X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 2.0a 
04/19/2013
Oct  6 12:01:39 stats kernel: [   25.473796] task: ffff88101b17a080 ti: 
ffff88101b1a8000 task.ti: ffff88101b1a8000
Oct  6 12:01:39 stats kernel: [   25.473880] RIP: 
0010:[<ffffffffa02119d4>]  [<ffffffffa02119d4>] 
bch_insert_data+0x14/0x20 [bcache]
Oct  6 12:01:39 stats kernel: [   25.474014] RSP: 0018:ffff88101b1a9468 
  EFLAGS: 00010246
Oct  6 12:01:39 stats kernel: [   25.474081] RAX: 0000000000000000 RBX: 
ffff88101b1a9488 RCX: 0000000000000000
Oct  6 12:01:39 stats kernel: [   25.474151] RDX: ffff88102ebf1c18 RSI: 
0000000000000000 RDI: ffff88102ebf1c18
Oct  6 12:01:39 stats kernel: [   25.474221] RBP: ffff88101b1a9468 R08: 
000000000008bbb0 R09: 000000000000ffff
Oct  6 12:01:39 stats kernel: [   25.474291] R10: ffff88102e3bd6c0 R11: 
ffffc90010c0effc R12: ffff88102e3bd6c0
Oct  6 12:01:39 stats kernel: [   25.474361] R13: ffff88102ebf1b18 R14: 
ffff88101bc20000 R15: ffff88102ebf1b78
Oct  6 12:01:39 stats kernel: [   25.474431] FS:  00007fa0b7f39700(0000) 
GS:ffff88107fd40000(0000) knlGS:0000000000000000
Oct  6 12:01:39 stats kernel: [   25.474516] CS:  0010 DS: 0000 ES: 0000 
CR0: 0000000080050033
Oct  6 12:01:39 stats kernel: [   25.474584] CR2: 000000000000006c CR3: 
000000101b3e7000 CR4: 00000000000407e0
Oct  6 12:01:39 stats kernel: [   25.474654] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Oct  6 12:01:39 stats kernel: [   25.474726] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Oct  6 12:01:39 stats kernel: [   25.474795] Stack:
Oct  6 12:01:39 stats kernel: [   25.474857]  ffff88101b1a9478 
ffffffffa021b883 ffff88101b1a94d8 ffffffffa02103be
Oct  6 12:01:39 stats kernel: [   25.475116]  8000000000000000 
000000007284da30 8000000000000000 000000007284d9f8
Oct  6 12:01:39 stats kernel: [   25.475376]  ffff88101b1a94d8 
ffff88102ebf1b18 ffff88101b17a080 ffff88102e3bd6c0
Oct  6 12:01:39 stats kernel: [   25.475642] Call Trace:
Oct  6 12:01:39 stats kernel: [   25.475711]  [<ffffffffa021b883>] 
closure_queue+0x43/0x60 [bcache]
Oct  6 12:01:39 stats kernel: [   25.475781]  [<ffffffffa02103be>] 
request_write+0x29e/0x3d0 [bcache]
Oct  6 12:01:39 stats kernel: [   25.475852]  [<ffffffffa0210728>] 
cached_dev_make_request+0x238/0x3b0 [bcache]
Oct  6 12:01:39 stats kernel: [   25.475939]  [<ffffffff813e3d62>] 
generic_make_request+0xd2/0x110
Oct  6 12:01:39 stats kernel: [   25.476007]  [<ffffffff813e3e18>] 
submit_bio+0x78/0x130
Oct  6 12:01:39 stats kernel: [   25.476078]  [<ffffffff81165d06>] ? 
bio_alloc_bioset+0x136/0x1d0
Oct  6 12:01:39 stats kernel: [   25.476149]  [<ffffffff812a3a5f>] 
_xfs_buf_ioapply+0x18f/0x370
Oct  6 12:01:39 stats kernel: [   25.476220]  [<ffffffff812ffd3e>] ? 
xlog_bdstrat+0x1e/0x60
Oct  6 12:01:39 stats kernel: [   25.476288]  [<ffffffff812a4c74>] 
xfs_buf_iorequest+0x74/0xa0
Oct  6 12:01:39 stats kernel: [   25.476356]  [<ffffffff812ffd3e>] 
xlog_bdstrat+0x1e/0x60
Oct  6 12:01:39 stats kernel: [   25.476288]  [<ffffffff812a4c74>] 
xfs_buf_iorequest+0x74/0xa0
Oct  6 12:01:39 stats kernel: [   25.476356]  [<ffffffff812ffd3e>] 
xlog_bdstrat+0x1e/0x60
Oct  6 12:01:39 stats kernel: [   25.476424]  [<ffffffff81300300>] 
xlog_sync+0x2f0/0x470
Oct  6 12:01:39 stats kernel: [   25.476491]  [<ffffffff813005fb>] 
xlog_state_release_iclog+0x9b/0xd0
Oct  6 12:01:39 stats kernel: [   25.476560]  [<ffffffff81300bad>] 
_xfs_log_force+0x1ed/0x270
Oct  6 12:01:39 stats kernel: [   25.476628]  [<ffffffff81300e04>] 
xfs_log_force+0x54/0x80
Oct  6 12:01:39 stats kernel: [   25.476696]  [<ffffffff812a528d>] ? 
_xfs_buf_find+0x15d/0x290
Oct  6 12:01:39 stats kernel: [   25.476764]  [<ffffffff812a3db3>] 
xfs_buf_lock+0xc3/0xd0
Oct  6 12:01:39 stats kernel: [   25.476832]  [<ffffffff812a528d>] 
_xfs_buf_find+0x15d/0x290
Oct  6 12:01:39 stats kernel: [   25.476900]  [<ffffffff812a585f>] 
xfs_buf_get_map+0x2f/0x170
Oct  6 12:01:39 stats kernel: [   25.476969]  [<ffffffff81308187>] 
xfs_trans_get_buf_map+0xe7/0x140
Oct  6 12:01:39 stats kernel: [   25.477045]  [<ffffffff812db312>] 
xfs_da_get_buf+0xb2/0xf0
Oct  6 12:01:39 stats kernel: [   25.477113]  [<ffffffff812e1d20>] 
xfs_dir3_data_init+0x50/0x1e0
Oct  6 12:01:39 stats kernel: [   25.477182]  [<ffffffff812bae15>] ? 
kmem_free+0x35/0x40
Oct  6 12:01:39 stats kernel: [   25.477250]  [<ffffffff812df83e>] 
xfs_dir2_sf_to_block+0xee/0x590
Oct  6 12:01:39 stats kernel: [   25.477322]  [<ffffffff812d3306>] ? 
xfs_bmbt_get_all+0x16/0x20
Oct  6 12:01:39 stats kernel: [   25.477390]  [<ffffffff812d1836>] ? 
xfs_bmap_del_extent+0x956/0xba0
Oct  6 12:01:39 stats kernel: [   25.477460]  [<ffffffff812e9d20>] 
xfs_dir2_sf_addname+0x430/0x520
Oct  6 12:01:39 stats kernel: [   25.477528]  [<ffffffff812bad37>] ? 
kmem_zone_alloc+0x77/0xe0
Oct  6 12:01:39 stats kernel: [   25.477599]  [<ffffffff812df29c>] 
xfs_dir_createname+0x14c/0x1b0
Oct  6 12:01:39 stats kernel: [   25.477672]  [<ffffffff812b55dd>] 
xfs_rename+0x5bd/0x730
Oct  6 12:01:39 stats kernel: [   25.478971]  [<ffffffff8113bd8d>] ? 
inode_permission+0x3d/0x60
Oct  6 12:01:39 stats kernel: [   25.479041]  [<ffffffff8113e46f>] ? 
vfs_rename+0xdf/0x480
Oct  6 12:01:39 stats kernel: [   25.479110]  [<ffffffff812b19d5>] 
xfs_vn_rename+0x65/0x70
Oct  6 12:01:39 stats kernel: [   25.479177]  [<ffffffff8113e750>] 
vfs_rename+0x3c0/0x480
Oct  6 12:01:39 stats kernel: [   25.479247]  [<ffffffff81140490>] 
SyS_renameat+0x2f0/0x320
Oct  6 12:01:39 stats kernel: [   25.479318]  [<ffffffff81132374>] ? 
fput+0x74/0xe0
Oct  6 12:01:39 stats kernel: [   25.479385]  [<ffffffff8112df08>] ? 
filp_close+0x68/0xa0
Oct  6 12:01:39 stats kernel: [   25.479455]  [<ffffffff8113b646>] 
SyS_rename+0x16/0x20
Oct  6 12:01:39 stats kernel: [   25.479526]  [<ffffffff816a05d2>] 
system_call_fastpath+0x16/0x1b
Oct  6 12:01:39 stats kernel: [   25.479594] Code: bd b8 fe ff ff be 01 
00 00 20 e8 e8 9e 00 00 e9 4f fd ff ff 0f 1f 00 48 8d 47 68 55 48 89 47 
60 48 89 47 58 48 89 e5 48 8b 47 40 <f0> ff 40 6c e8 53 f4 ff ff c9 c3 
90 55 48 89 e5 41 55 4c 8d af
Oct  6 12:01:39 stats kernel: [   25.482588] RIP  [<ffffffffa02119d4>] 
bch_insert_data+0x14/0x20 [bcache]
Oct  6 12:01:39 stats kernel: [   25.482703]  RSP <ffff88101b1a9468>
Oct  6 12:01:39 stats kernel: [   25.482766] CR2: 000000000000006c
Oct  6 12:01:39 stats kernel: [   25.482840] ---[ end trace 
1774b77e3cdc2a58 ]---

-- 
Cyril B.
