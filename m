From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Tue, 29 Nov 2011 01:16:41 -0800
Message-ID: <20111129091641.GA16431@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com>
 <4ED47771.9030309@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ED47771.9030309-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hey Tejun, mind taking a glance? I think I might be doing something dumb
here, but I'm not quite sure what and I haven't dealt much with struct
request:

(This is bcache on 3.1 with a raid10)

scsi_setup_fs_cmnd() is triggering BUG_ON(!req->nr_phys_segments). 

I'm not finding the code where req->nr_phys_segments is set right now,
but I'm guessing what's happening is it's getting set incorrectly
because the bio(s) in the request have it set to 0, not -1. 

If that's the case, then the bug is that bio_split_front()
(bcache/util.c) creates a new bio but doesn't initalize
bio->bi_phys_segments, so just setting it to -1 so it gets recalculated
later should fix it...

That sound right to you?

On Tue, Nov 29, 2011 at 02:10:57PM +0800, Brad Campbell wrote:
> This happens immediately I try and attach a cache set to /dev/md10 :
> 
> [   73.287556] md: resync of RAID array md10
> [   73.287614] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [   73.287620] ------------[ cut here ]------------
> [   73.287628] kernel BUG at drivers/scsi/scsi_lib.c:1152!
> [   73.287633] invalid opcode: 0000 [#1] SMP
> [   73.287638] CPU 1
> [   73.287641] Modules linked in: xt_state ipt_REJECT xt_CHECKSUM
> iptable_mangle nfs ipt_MASQUERADE xt_tcpudp iptable_filter
> iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
> ip_tables x_tables deflate zlib_deflate des_generic cbc ecb
> crypto_blkcipher sha1_generic md5 hmac crypto_hash cryptomgr aead
> crypto_algapi af_key fuse w83627ehf hwmon_vid netconsole configfs
> vhost_net powernow_k8 mperf kvm_amd kvm xhci_hcd k10temp i2c_piix4
> ohci_hcd ehci_hcd usbcore ahci atl1c libahci megaraid_sas [last
> unloaded: scsi_wait_scan]
> [   73.287694]
> [   73.287700] Pid: 1428, comm: md10_raid10 Not tainted
> 3.1.0-g143cdea #1 To Be Filled By O.E.M. To Be Filled By
> O.E.M./890GX Extreme4 R2.0
> [   73.287711] RIP: 0010:[<ffffffff812adbfe>]  [<ffffffff812adbfe>]
> scsi_setup_fs_cmnd+0xae/0xf0
> [   73.287726] RSP: 0018:ffff88041bb73be0  EFLAGS: 00010046
> [   73.287731] RAX: 0000000000000000 RBX: ffff88041ba5c560 RCX:
> 0000000000001000
> [   73.287736] RDX: 0000000000000000 RSI: ffff88041ba5c560 RDI:
> ffff88041bbf8000
> [   73.287740] RBP: ffff88041bbf8000 R08: 0000000000000000 R09:
> 0000000000000001
> [   73.287745] R10: 4080000000000000 R11: dead000000100100 R12:
> ffff88041bbf8000
> [   73.287750] R13: 0000000000000808 R14: ffff88041bbf8048 R15:
> ffff88041c029400
> [   73.287756] FS:  00007fa5803717c0(0000) GS:ffff88042fc40000(0000)
> knlGS:0000000000000000
> [   73.287761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   73.287766] CR2: 0000000001b7c1b8 CR3: 0000000418a24000 CR4:
> 00000000000006e0
> [   73.287770] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [   73.287774] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [   73.287780] Process md10_raid10 (pid: 1428, threadinfo
> ffff88041bb72000, task ffff88041c760640)
> [   73.287784] Stack:
> [   73.287787]  0000000000000000 ffff88041ba5c560 ffff88041c603c30
> ffffffff812b86fc
> [   73.287794]  01ff88041bbf8800 ffff880400000001 ffff880400001000
> 0000000000000000
> [   73.287800]  ffff88041ba5c560 ffff88041ba5c560 ffff88041ba5c560
> ffff88041c603c30
> [   73.287807] Call Trace:
> [   73.287816]  [<ffffffff812b86fc>] ? sd_prep_fn+0x15c/0xa50
> [   73.287825]  [<ffffffff811c8be4>] ? blk_peek_request+0xb4/0x1d0
> [   73.287832]  [<ffffffff812ad120>] ? scsi_request_fn+0x50/0x4a0
> [   73.287840]  [<ffffffff811c9598>] ? blk_flush_plug_list+0x188/0x210
> [   73.287847]  [<ffffffff811c962b>] ? blk_finish_plug+0xb/0x30
> [   73.287854]  [<ffffffff812fae78>] ? raid10d+0x908/0xb50
> [   73.287862]  [<ffffffff81041183>] ? lock_timer_base+0x33/0x70
> [   73.287870]  [<ffffffff814089c5>] ? schedule_timeout+0x1c5/0x230
> [   73.287878]  [<ffffffff8130ec8f>] ? md_thread+0x10f/0x140
> [   73.287886]  [<ffffffff81050240>] ? wake_up_bit+0x40/0x40
> [   73.287892]  [<ffffffff8130eb80>] ? md_register_thread+0x100/0x100
> [   73.287898]  [<ffffffff8130eb80>] ? md_register_thread+0x100/0x100
> [   73.287905]  [<ffffffff8104fde6>] ? kthread+0x96/0xa0
> [   73.287912]  [<ffffffff8140bbf4>] ? kernel_thread_helper+0x4/0x10
> [   73.287920]  [<ffffffff8104fd50>] ? kthread_worker_fn+0x120/0x120
> [   73.287926]  [<ffffffff8140bbf0>] ? gs_change+0xb/0xb
> [   73.287929] Code: 80 00 00 00 00 48 83 c4 08 5b 5d c3 90 48 89 ef
> be 20 00 00 00 e8 73 a2 ff ff 48 85 c0 48 89 c7 74 d7 48 89 83 d8 00
> 00 00 eb 8d <0f> 0b eb fe 48 8b 00 48 85 c0 0f 84 67 ff ff ff 48 8b
> 40 50 48
> [   73.287969] RIP  [<ffffffff812adbfe>] scsi_setup_fs_cmnd+0xae/0xf0
> [   73.287977]  RSP <ffff88041bb73be0>
> [   73.287982] ---[ end trace 4ce4e575167cc0ff ]---
> [   73.287986] Kernel panic - not syncing: Fatal exception
> [   73.287993] Pid: 1428, comm: md10_raid10 Tainted: G      D
> 3.1.0-g143cdea #1
> [   73.287998] Call Trace:
> [   73.288005]  [<ffffffff81407679>] ? panic+0x92/0x193
> [   73.288012]  [<ffffffff81035451>] ? kmsg_dump+0x41/0xf0
> [   73.288021]  [<ffffffff8100504d>] ? oops_end+0x8d/0xa0
> [   73.288028]  [<ffffffff81002e34>] ? do_invalid_op+0x84/0xa0
> [   73.288035]  [<ffffffff812adbfe>] ? scsi_setup_fs_cmnd+0xae/0xf0
> [   73.288044]  [<ffffffff811d698e>] ? cfq_set_request+0x15e/0x3b0
> [   73.288050]  [<ffffffff8140ba75>] ? invalid_op+0x15/0x20
> [   73.288058]  [<ffffffff812adbfe>] ? scsi_setup_fs_cmnd+0xae/0xf0
> [   73.288064]  [<ffffffff812b86fc>] ? sd_prep_fn+0x15c/0xa50
> [   73.288071]  [<ffffffff811c8be4>] ? blk_peek_request+0xb4/0x1d0
> [   73.288078]  [<ffffffff812ad120>] ? scsi_request_fn+0x50/0x4a0
> [   73.288085]  [<ffffffff811c9598>] ? blk_flush_plug_list+0x188/0x210
> [   73.288092]  [<ffffffff811c962b>] ? blk_finish_plug+0xb/0x30
> [   73.288098]  [<ffffffff812fae78>] ? raid10d+0x908/0xb50
> [   73.288104]  [<ffffffff81041183>] ? lock_timer_base+0x33/0x70
> [   73.288112]  [<ffffffff814089c5>] ? schedule_timeout+0x1c5/0x230
> [   73.288119]  [<ffffffff8130ec8f>] ? md_thread+0x10f/0x140
> [   73.288126]  [<ffffffff81050240>] ? wake_up_bit+0x40/0x40
> [   73.288132]  [<ffffffff8130eb80>] ? md_register_thread+0x100/0x100
> [   73.288138]  [<ffffffff8130eb80>] ? md_register_thread+0x100/0x100
> [   73.288144]  [<ffffffff8104fde6>] ? kthread+0x96/0xa0
> [   73.288151]  [<ffffffff8140bbf4>] ? kernel_thread_helper+0x4/0x10
> [   73.288159]  [<ffffffff8104fd50>] ? kthread_worker_fn+0x120/0x120
> [   73.288165]  [<ffffffff8140bbf0>] ? gs_change+0xb/0xb
> [   73.290590] Rebooting in 10 seconds..
> 
> I can attach the same cache set to /dev/sde and all is ok (the same
> config I used to run the last set of benchmarks).
> 
> Regards,
> Brad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
