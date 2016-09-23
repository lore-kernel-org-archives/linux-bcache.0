From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: bcache: discard BUG during lvremove
Date: Fri, 23 Sep 2016 14:47:27 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609231441290.29933@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:37591 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933405AbcIWVr3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 23 Sep 2016 17:47:29 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Matthias Ferdinand <mf@mfedv.net>
Cc: linux-bcache@vger.kernel.org

On Thu, 22 Sep 2016, Matthias Ferdinand wrote:
> On Wed, Sep 21, 2016 at 02:08:06PM -0700, Eric Wheeler wrote:
> > Looks like a deadlock, maybe?  Kent is good at troubleshooting those.
> 
> I guess so.
> 
> >     [ 1930.459062] kernel BUG at block/bio.c:1789! Matthias, which BUG_ON 
> > is this below in your code?  My codepaste is below if v4.7 from LXR, I 
> > don't have 4.8 handy.
> > 
> >     [ 1930.459648] invalid opcode: 0000 [#1] SMP
> >     [ 1930.520004] CPU: 0 PID: 12673 Comm: lvremove Not tainted 4.8.0-rc5 #2
> >     [ 1930.545645] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 07/16/2015
> >     [ 1931.077608]  [<ffffffff96393aad>] blk_queue_split+0x47d/0x640
> >     [ 1931.101157]  [<ffffffff9638f3a4>] blk_queue_bio+0x44/0x390
> >     [ 1931.124083]  [<ffffffff9638d8c4>] generic_make_request+0x104/0x1b0
> >     [ 1931.146371]  [<ffffffff9638d9dd>] submit_bio+0x6d/0x150
> >     [ 1931.168393]  [<ffffffff96385649>] ? bio_alloc_bioset+0x169/0x2b0
> >     [ 1931.189853]  [<ffffffff96395e68>] next_bio+0x38/0x40
> >     [ 1931.210743]  [<ffffffff96395f93>] __blkdev_issue_discard+0x123/0x1c0
> >     [ 1931.231522]  [<ffffffff963961c2>] blkdev_issue_discard+0x52/0xa0
> >     [ 1931.251942]  [<ffffffff9639c360>] blk_ioctl_discard+0x80/0xa0
> >     [ 1931.272067]  [<ffffffff9639cfb6>] blkdev_ioctl+0x716/0x8c0
> >     [ 1931.291454]  [<ffffffff9621db04>] ? mntput+0x24/0x40
> >     [ 1931.310551]  [<ffffffff96237231>] block_ioctl+0x41/0x50
> >     [ 1931.329247]  [<ffffffff96210676>] do_vfs_ioctl+0x96/0x5a0
> >     [ 1931.347634]  [<ffffffff961bb7d8>] ? do_munmap+0x298/0x390
> >     [ 1931.366132]  [<ffffffff96210bf9>] SyS_ioctl+0x79/0x90
> >     [ 1931.384667]  [<ffffffff967b49b6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
> 
> 
> For some reason, it pointed to the comment immediately after the
> BUG_ONs. I now recompiled and re-tested with some added printk, and it
> shows it throws a BUG because sectors==0:

Lets try to rule out bcache since I don't see it in the lvremove BUG 
trace: detach your cache device to remove the writeback thread activity 
and try again.  Does it still bomb?

--
Eric Wheeler

> 
>    1780 struct bio *bio_split(struct bio *bio, int sectors,
>    1781                       gfp_t gfp, struct bio_set *bs)
>    1782 {
>    1783         struct bio *split = NULL;
>    1784 
>    1785         if (sectors <= 0) {
>    1786             printk(KERN_ERR " bio_split: sectors <= 0: %d\n", sectors);
>    1787         }
> => 1788         BUG_ON(sectors <= 0);
>    1789         if (sectors >= bio_sectors(bio)) {
>    1790             printk(KERN_ERR " bio_split: sectors >= bio_sectors(bio): %d\n", bio_sectors(bio));
>    1791         }
>    1792         BUG_ON(sectors >= bio_sectors(bio));
>    1793 
> 
> =>  [  581.921539]  bio_split: sectors <= 0: 0
>     [  581.922118] ------------[ cut here ]------------
> =>  [  581.922778] kernel BUG at block/bio.c:1788!
>     [  581.923375] invalid opcode: 0000 [#1] SMP
>     [  581.923947] Modules linked in: dm_snapshot dm_bufio bcache ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp gpio_ich kvm_intel ipmi_ssif kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd dm_multipath serio_raw ipmi_si input_leds ipmi_msghandler lp acpi_power_meter hpilo lpc_ich ie31200_edac parport edac_core btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx hid_generic uas xor tg3 usbhid psmouse usb_storage raid6_pq hid libcrc32c ahci raid
 1 libahci raid0 ptp multipath pps_core linear
>     [  581.936332] CPU: 0 PID: 8869 Comm: lvremove Not tainted 4.8.0-rc5 #2
>     [  581.937238] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 07/16/2015
>     [  581.938244] task: ffffa248af6fd780 task.stack: ffffa248ab3a0000
>     [  581.939087] RIP: 0010:[<ffffffffa9386dc3>]  [<ffffffffa9386dc3>] bio_split+0xd3/0xe0
>     [  581.963285] RSP: 0018:ffffa248ab3a3b78  EFLAGS: 00010286
>     [  581.987429] RAX: 000000000000001b RBX: 0000000000002000 RCX: 0000000000000000
>     [  582.012220] RDX: 0000000000000001 RSI: ffffa248cac0dc68 RDI: ffffa248cac0dc68
>     [  582.036724] RBP: ffffa248ab3a3b98 R08: 0000000000000388 R09: ffffba6780277620
>     [  582.061007] R10: 0000000000000001 R11: 0000000000cdcdcd R12: 0000000000000000
>     [  582.084953] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000000a8
>     [  582.108219] FS:  00007f9fbc0c1840(0000) GS:ffffa248cac00000(0000) knlGS:0000000000000000
>     [  582.153456] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     [  582.176597] CR2: 00007f5c43346000 CR3: 00000003ed67a000 CR4: 00000000001406f0
>     [  582.200295] Stack:
>     [  582.223609]  ffffa248ab3a3b88 0000000000002000 0000000000000000 0000000000000000
>     [  582.272070]  ffffa248ab3a3c38 ffffffffa9393a1d ffffa248ae66e2c0 ffffa248ab3a3bf8
>     [  582.321312]  ffffa248c955ec80 0000000000000000 ffffa248c9a8f360 ffffa248ab3a3c48
>     [  582.370370] Call Trace:
>     [  582.394036]  [<ffffffffa9393a1d>] blk_queue_split+0x45d/0x620
>     [  582.417899]  [<ffffffffa938f334>] blk_queue_bio+0x44/0x390
>     [  582.441143]  [<ffffffffa938d841>] generic_make_request+0xe1/0x1a0
>     [  582.463975]  [<ffffffffa938d96d>] submit_bio+0x6d/0x150
>     [  582.486262]  [<ffffffffa93855a8>] ? bio_alloc_bioset+0x168/0x2a0
>     [  582.508189]  [<ffffffffa9395dd8>] next_bio+0x38/0x40
>     [  582.529570]  [<ffffffffa9395f03>] __blkdev_issue_discard+0x123/0x1c0
>     [  582.550840]  [<ffffffffa9396132>] blkdev_issue_discard+0x52/0xa0
>     [  582.571751]  [<ffffffffa939c2d0>] blk_ioctl_discard+0x80/0xa0
>     [  582.592265]  [<ffffffffa939cf26>] blkdev_ioctl+0x716/0x8c0
>     [  582.612358]  [<ffffffffa921db04>] ? mntput+0x24/0x40
>     [  582.631881]  [<ffffffffa9237231>] block_ioctl+0x41/0x50
>     [  582.651145]  [<ffffffffa9210676>] do_vfs_ioctl+0x96/0x5a0
>     [  582.670099]  [<ffffffffa91bb7d8>] ? do_munmap+0x298/0x390
>     [  582.688879]  [<ffffffffa9210bf9>] SyS_ioctl+0x79/0x90
>     [  582.707361]  [<ffffffffa97b49b6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
>     [  582.726040] Code: e0 e8 3b 6a df ff 41 8b 44 24 28 48 8b 4d e0 c1 e8 09 41 39 c5 0f 82 6a ff ff ff 0f 0b 48 c7 c7 e8 43 ab a9 31 c0 e8 16 6a df ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44 00 00 48 8b 07 
>     [  582.785705] RIP  [<ffffffffa9386dc3>] bio_split+0xd3/0xe0
>     [  582.804880]  RSP <ffffa248ab3a3b78>
>     [  582.823680] ---[ end trace 16c2130868fdd195 ]---
>     
>     
> Not having found anything suspicious in
> v2-1-1-block-fix-blk_queue_split-resource-exhaustion.patch, I tried
> lvremove (with discard) of that (rc5-patched-created) structure under
> unpatched 4.8.0-rc6, and it threw the same BUG_ON.
> 
> I had not reached that point in my test scenario with unpatched 4.8
> before, since the deadlock always hit first.
> 
> So it seems to actually be a bug in the kernel, not in LGEs patch.
> 
> 
> Will try to find simple steps to reproduce tomorrow.
> 
> 
> Matthias
> 
