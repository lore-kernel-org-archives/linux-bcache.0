From: Brad Campbell <lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: Bcache explodes when trying to attach
Date: Sat, 15 Oct 2011 20:59:29 +0800
Message-ID: <4E9983B1.9060803@fnarfbargle.com>
References: <4E991D90.1040008@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E991D90.1040008-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 15/10/11 13:43, Brad Campbell wrote:
> I'm trying bcache merged with linus' git head (-rc9). I suppose I should really try it with a 
> vanilla bcache-dev tree.
>
> Anyway, I can register the cache and backing device but when I try and attach the cache set to the 
> backing device this happens :

Ok, so the build was broken in some odd way. Turns out the latest git does not build unless you have 
cgroups enabled (which by default I don't).

This came from the same scenario using a vanilla bcache git clone..

[  162.412296] bio: create slab <bio-2> at 2
[  162.441711] bcache: journal entries 3-4 missing! (replaying 2-4)
[  162.441805] bcache: journal replay done, 0 keys in 2 entries, seq 2-4
[  181.955480] md: resync of RAID array md10
[  181.955526] ------------[ cut here ]------------
[  181.955533] kernel BUG at drivers/scsi/scsi_lib.c:1152!
[  181.955539] invalid opcode: 0000 [#1] SMP
[  181.955546] CPU 1
[  181.955549] Modules linked in: nfs ipt_MASQUERADE xt_tcpudp iptable_filter iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables deflate zlib_deflate des_generic 
cbc ecb crypto_blkcipher sha1_generic md5 hmac crypto_hash cryptomgr aead crypto_algapi af_key fuse 
w83627ehf hwmon_vid netconsole configfs vhost_net powernow_k8 mperf kvm_amd kvm xhci_hcd i2c_piix4 
k10temp ohci_hcd ehci_hcd usbcore ahci libahci atl1c megaraid_sas [last unloaded: scsi_wait_scan]
[  181.955600]
[  181.955606] Pid: 1422, comm: md10_raid10 Not tainted 3.1.0-rc9-00152-g3900b5a-dirty #6 To Be 
Filled By O.E.M. To Be Filled By O.E.M./890GX Extreme4 R2.0
[  181.955616] RIP: 0010:[<ffffffff812ad4ee>]  [<ffffffff812ad4ee>] scsi_setup_fs_cmnd+0xae/0xf0
[  181.955631] RSP: 0018:ffff88041bfdbbe0  EFLAGS: 00010046
[  181.955636] RAX: 0000000000000000 RBX: ffff88041c4d3830 RCX: 0000000000001000
[  181.955641] RDX: 0000000000000000 RSI: ffff88041c4d3830 RDI: ffff88041c754800
[  181.955645] RBP: ffff88041c754800 R08: 0000000000000000 R09: 0000000000000001
[  181.955650] R10: 4080000000000000 R11: 0000000000000000 R12: ffff88041c754800
[  181.955654] R13: 0000000000000808 R14: ffff88041c754848 R15: ffff88041c3cbc00
[  181.955661] FS:  00007fc823617700(0000) GS:ffff88042fc40000(0000) knlGS:0000000000000000
[  181.955668] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  181.955672] CR2: ffffffffff600400 CR3: 00000003ffe02000 CR4: 00000000000006e0
[  181.955677] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.955681] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.955687] Process md10_raid10 (pid: 1422, threadinfo ffff88041bfda000, task ffff88041c1bcb00)
[  181.955691] Stack:
[  181.955693]  0000000000000000 ffff88041c4d3830 ffff88041bd83c30 ffffffff812b7fec
[  181.955701]  01ff88041c755000 ffff880400000001 ffff880400001000 0000000000000000
[  181.955707]  ffff88041c4d3830 ffff88041c4d3830 ffff88041c4d3830 ffff88041bd83c30
[  181.955714] Call Trace:
[  181.955723]  [<ffffffff812b7fec>] ? sd_prep_fn+0x15c/0xa50
[  181.955732]  [<ffffffff811c8c04>] ? blk_peek_request+0xb4/0x1d0
[  181.955739]  [<ffffffff812aca10>] ? scsi_request_fn+0x50/0x4a0
[  181.955747]  [<ffffffff811c95b8>] ? blk_flush_plug_list+0x188/0x210
[  181.955755]  [<ffffffff811c964b>] ? blk_finish_plug+0xb/0x30
[  181.955762]  [<ffffffff812fa768>] ? raid10d+0x908/0xb50
[  181.955770]  [<ffffffff81041183>] ? lock_timer_base+0x33/0x70
[  181.955779]  [<ffffffff814082b5>] ? schedule_timeout+0x1c5/0x230
[  181.955786]  [<ffffffff8130e57f>] ? md_thread+0x10f/0x140
[  181.955795]  [<ffffffff81050260>] ? wake_up_bit+0x40/0x40
[  181.955801]  [<ffffffff8130e470>] ? md_register_thread+0x100/0x100
[  181.955807]  [<ffffffff8130e470>] ? md_register_thread+0x100/0x100
[  181.955814]  [<ffffffff8104fe06>] ? kthread+0x96/0xa0
[  181.955821]  [<ffffffff8140b4f4>] ? kernel_thread_helper+0x4/0x10
[  181.955829]  [<ffffffff8104fd70>] ? kthread_worker_fn+0x120/0x120
[  181.955836]  [<ffffffff8140b4f0>] ? gs_change+0xb/0xb
[  181.955839] Code: 80 00 00 00 00 48 83 c4 08 5b 5d c3 90 48 89 ef be 20 00 00 00 e8 73 a2 ff ff 
48 85 c0 48 89 c7 74 d7 48 89 83 d8 00 00 00 eb 8d <0f> 0b eb fe 48 8b 00 48 85 c0 0f 84 67 ff ff ff 
48 8b 40 50 48
[  181.955879] RIP  [<ffffffff812ad4ee>] scsi_setup_fs_cmnd+0xae/0xf0
[  181.955887]  RSP <ffff88041bfdbbe0>
[  181.955892] ---[ end trace 56499f30ff553488 ]---
[  181.955896] Kernel panic - not syncing: Fatal exception
[  181.955902] Pid: 1422, comm: md10_raid10 Tainted: G      D     3.1.0-rc9-00152-g3900b5a-dirty #6
[  181.955906] Call Trace:
[  181.955913]  [<ffffffff81406f69>] ? panic+0x92/0x193
[  181.955920]  [<ffffffff81035451>] ? kmsg_dump+0x41/0xf0
[  181.955929]  [<ffffffff8100504d>] ? oops_end+0x8d/0xa0
[  181.955936]  [<ffffffff81002e34>] ? do_invalid_op+0x84/0xa0
[  181.955943]  [<ffffffff812ad4ee>] ? scsi_setup_fs_cmnd+0xae/0xf0
[  181.955952]  [<ffffffff811d69ae>] ? cfq_set_request+0x15e/0x3b0
[  181.955958]  [<ffffffff8140b375>] ? invalid_op+0x15/0x20
[  181.955966]  [<ffffffff812ad4ee>] ? scsi_setup_fs_cmnd+0xae/0xf0
[  181.955972]  [<ffffffff812b7fec>] ? sd_prep_fn+0x15c/0xa50
[  181.955979]  [<ffffffff811c8c04>] ? blk_peek_request+0xb4/0x1d0
[  181.955986]  [<ffffffff812aca10>] ? scsi_request_fn+0x50/0x4a0
[  181.955993]  [<ffffffff811c95b8>] ? blk_flush_plug_list+0x188/0x210
[  181.956001]  [<ffffffff811c964b>] ? blk_finish_plug+0xb/0x30
[  181.956007]  [<ffffffff812fa768>] ? raid10d+0x908/0xb50
[  181.956013]  [<ffffffff81041183>] ? lock_timer_base+0x33/0x70
[  181.956021]  [<ffffffff814082b5>] ? schedule_timeout+0x1c5/0x230
[  181.956028]  [<ffffffff8130e57f>] ? md_thread+0x10f/0x140
[  181.956035]  [<ffffffff81050260>] ? wake_up_bit+0x40/0x40
[  181.956041]  [<ffffffff8130e470>] ? md_register_thread+0x100/0x100
[  181.956047]  [<ffffffff8130e470>] ? md_register_thread+0x100/0x100
[  181.956054]  [<ffffffff8104fe06>] ? kthread+0x96/0xa0
[  181.956060]  [<ffffffff8140b4f4>] ? kernel_thread_helper+0x4/0x10
[  181.956068]  [<ffffffff8104fd70>] ? kthread_worker_fn+0x120/0x120
[  181.956075]  [<ffffffff8140b4f0>] ? gs_change+0xb/0xb
[  181.958475] Rebooting in 10 seconds..
