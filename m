From: Matthias Ferdinand <bcache@mfedv.net>
Subject: kernel hangs and crashes with 4.15 (also 4.13, 4.14)
Date: Thu, 8 Feb 2018 21:22:08 +0100
Message-ID: <20180208202208.GA23476@xoff>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41349 "EHLO sw.mfedv.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752103AbeBHUW2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Feb 2018 15:22:28 -0500
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

this seems to not have gone through on the first attempt, sorry if you
get this twice.

Running some fio jobs directly on a writeback bcache device (no fs
mounted), I can hang or crash the kernel with high probability (although
not deterministically).

    for n in $(seq 1 8); do
        fio --filename=/dev/bcache0 --direct=1 --sync=1 --rw=write --bs=4k --numjobs=${n} --iodepth=1 --runtime=30 --time_based --group_reporting --name=journal-test
    done

If the backing device is a md raid5, bcache ĺocks up with a kernel BUG
message, "shutdown -r now" hangs, but I can still reboot using magic
sysrq (reisub).

If the backing device is a md raid10, the machine also shows a kernel
BUG but completely freezes after that. On the VGA console, there is
often another kernel BUG message, which hasn't made it to the serial
console, but which is very similar to the first message.

There is no hang or crash if I run those tests on the md devices
directly with no bcache.

This happens with kernel versions 4.15.0 (kernel.org), 4.14.15
(kernel.org), 4.13.0-32 (Ubuntu Xenial HWE kernel). With an older
4.10.1, no crashes happen.

the kernel BUGs seem to happen at different places (from different
runs with 4.15.0):

    [  438.880774] kernel BUG at block/bio.c:560!

    [  440.012034] kernel BUG at block/blk-ioc.c:146!

    [ 5378.266726] Kernel BUG at 000000006726b688 [verbose debug info unavailable]

    [  103.315681] Kernel BUG at 00000000af7724c9 [verbose debug info unavailable]


Kernel BUG messages from a hang with raid5 and a lockup with raid10
caught with USB serial console follow below.

Regards
Matthias Ferdinand

-----------------------------------------------------------------------

raid5:

[  440.012034] kernel BUG at block/blk-ioc.c:146!
[  440.012696] invalid opcode: 0000 [#1] SMP NOPTI
[  440.013355] Modules linked in: bcache ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables intel_rapl ttm x86_pkg_temp_thermal intel_powerclamp drm_kms_helper coretemp kvm_intel drm kvm ipmi_ssif i2c_algo_bit fb_sys_fops syscopyarea sysfillrect irqbypass sysimgblt crct10dif_pclmul crc32_pclmul hpilo ghash_clmulni_intel gpio_ich shpchp serio_raw pcbc aesni_intel ipmi_si aes_x86_64 crypto_simd ipmi_msghandler dm_multipath glue_helper cryptd acpi_power_meter intel_cstate intel_rapl_perf input_leds lpc_ich mfd_core ie31200_edac btrfs zstd_decompress zstd_compr
 ess xxhash
[  440.023485]  raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq hid_generic libcrc32c uas raid1 usbhid psmouse raid0 usb_storage tg3 ahci hid libahci multipath linear [last unloaded: bcache]
[  440.026537] CPU: 2 PID: 2205 Comm: md127_raid5 Not tainted 4.15.0 #8
[  440.027441] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 07/16/2015
[  440.028615] RIP: 0010:put_io_context+0x8b/0x90
[  440.029246] RSP: 0018:ffffa8c882b43af8 EFLAGS: 00010246
[  440.029990] RAX: 0000000000000000 RBX: ffffa8c88294fca0 RCX: 00000000000f4240
[  440.031006] RDX: 0000000000000004 RSI: 0000000000000286 RDI: ffffa8c88294fca0
[  440.032030] RBP: ffffa8c882b43b10 R08: 0000000000000003 R09: ffff949cb80c1700
[  440.033206] R10: 0000000000000104 R11: 000000000000b71c R12: 0000000000001000
[  440.034222] R13: 0000000000000000 R14: ffff949cad84db70 R15: ffff949cb11bd1e0
[  440.035239] FS:  0000000000000000(0000) GS:ffff949cba280000(0000) knlGS:0000000000000000
[  440.060190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  440.084967] CR2: 00007ff0493ef000 CR3: 00000002f1e0a002 CR4: 00000000001606e0
[  440.110498] Call Trace:
[  440.135443]  bio_disassociate_task+0x1b/0x60
[  440.160355]  bio_free+0x1b/0x60
[  440.184666]  bio_put+0x23/0x30
[  440.208272]  search_free+0x23/0x40 [bcache]
[  440.231448]  cached_dev_write_complete+0x31/0x70 [bcache]
[  440.254468]  closure_put+0xb6/0xd0 [bcache]
[  440.277087]  request_endio+0x30/0x40 [bcache]
[  440.298703]  bio_endio+0xa1/0x120
[  440.319644]  handle_stripe+0x418/0x2270 [raid456]
[  440.340614]  ? load_balance+0x17b/0x9c0
[  440.360506]  handle_active_stripes.isra.58+0x387/0x5a0 [raid456]
[  440.380675]  ? __release_stripe+0x15/0x20 [raid456]
[  440.400132]  raid5d+0x3ed/0x5d0 [raid456]
[  440.419193]  ? schedule+0x36/0x80
[  440.437932]  ? schedule_timeout+0x1d2/0x2f0
[  440.456136]  md_thread+0x122/0x150
[  440.473687]  ? wait_woken+0x80/0x80
[  440.491411]  kthread+0x102/0x140
[  440.508636]  ? find_pers+0x70/0x70
[  440.524927]  ? kthread_associate_blkcg+0xa0/0xa0
[  440.541791]  ret_from_fork+0x35/0x40
[  440.558020] Code: c2 48 00 5b 41 5c 41 5d 5d c3 48 89 c6 4c 89 e7 e8 bb c2 48 00 48 8b 3d bc 36 4b 01 48 89 de e8 7c f7 e0 ff 5b 41 5c 41 5d 5d c3 <0f> 0b 0f 1f 00 0f 1f 44 00 00 55 48 8d 47 b8 48 89 e5 41 57 41 
[  440.610020] RIP: put_io_context+0x8b/0x90 RSP: ffffa8c882b43af8
[  440.628575] ---[ end trace a1fd79d85643a73e ]---

-----------------------------------------------------------------------

raid10:

[  438.880774] kernel BUG at block/bio.c:560!
[  438.881378] invalid opcode: 0000 [#1] SMP NOPTI
[  438.882197] Modules linked in: bcache ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables intel_rapl x86_pkg_temp_thermal intel_powerclamp ttm coretemp kvm_intel drm_kms_helper kvm drm irqbypass crct10dif_pclmul ipmi_ssif crc32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd glue_helper ipmi_si i2c_algo_bit ipmi_msghandler gpio_ich fb_sys_fops lpc_ich hpilo mfd_core acpi_power_meter ie31200_edac syscopyarea sysfillrect sysimgblt serio_raw dm_multipath input_leds cryptd shpchp intel_cstate intel_rapl_perf btrfs zstd_decompress zstd_compr
 ess xxhash
[  438.892634]  raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c hid_generic uas raid1 usbhid usb_storage tg3 raid0 psmouse ahci hid libahci multipath linear [last unloaded: bcache]
[  438.895674] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 4.15.0 #8
[  438.896516] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 07/16/2015
[  438.897524] RIP: 0010:bio_put+0x25/0x30
[  438.898069] RSP: 0018:ffff8ca2ba303c70 EFLAGS: 00010246
[  438.898987] RAX: 0000000000000000 RBX: ffff8ca2a1adf788 RCX: 00000000000f4240
[  438.900003] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffffa87782d67c08
[  438.901020] RBP: ffff8ca2ba303c70 R08: 0000000000000000 R09: ffffffff85012480
[  438.902036] R10: 000000000000012b R11: 000000000000013c R12: ffff8ca28fb30010
[  438.903053] R13: 0000000000000000 R14: ffff8ca291327460 R15: 0000000000000000
[  438.904237] FS:  0000000000000000(0000) GS:ffff8ca2ba300000(0000) knlGS:0000000000000000
[  438.928279] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  438.952654] CR2: 00007fe51a454090 CR3: 00000002c420a004 CR4: 00000000001606e0
[  438.977670] Call Trace:
[  439.002472]  <IRQ>
[  439.026414]  search_free+0x23/0x40 [bcache]
[  439.050258]  cached_dev_write_complete+0x31/0x70 [bcache]
[  439.074040]  closure_put+0xb6/0xd0 [bcache]
[  439.097246]  request_endio+0x30/0x40 [bcache]
[  439.119920]  bio_endio+0xa1/0x120
[  439.141667]  raid_end_bio_io+0x30/0xc0 [raid10]
[  439.163411]  one_write_done+0x35/0x50 [raid10]
[  439.184486]  raid10_end_write_request+0x112/0x250 [raid10]
[  439.205551]  bio_endio+0xa1/0x120
[  439.225647]  blk_update_request+0xb7/0x310
[  439.245295]  scsi_end_request+0x34/0x200
[  439.264379]  scsi_io_completion+0x10d/0x5c0
[  439.283087]  scsi_finish_command+0xd9/0x120
[  439.301348]  scsi_softirq_done+0x144/0x170
[  439.318718]  blk_done_softirq+0x7c/0x90
[  439.335596]  __do_softirq+0xc9/0x26a
[  439.352176]  irq_exit+0xa5/0xb0
[  439.368242]  do_IRQ+0x51/0xd0
[  439.383765]  common_interrupt+0x9f/0x9f
[  439.399217]  </IRQ>
[  439.414466] RIP: 0010:cpuidle_enter_state+0xeb/0x290
[  439.430078] RSP: 0018:ffffa87781917e80 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdb
[  439.462221] RAX: ffff8ca2ba3229c0 RBX: ffff8ca2ba32b700 RCX: 000000000000001f
[  439.479067] RDX: 0000000000000000 RSI: ffffffe1cfb49a99 RDI: 0000000000000000
[  439.495611] RBP: ffffa87781917eb8 R08: 00000000000003ff R09: 0000000000000187
[  439.511910] R10: 000000000000008a R11: 0000000000000018 R12: 0000000000000002
[  439.528158] R13: 0000000000000004 R14: ffffffff85171380 R15: 000000662f545620
[  439.543608]  cpuidle_enter+0x17/0x20
[  439.559325]  call_cpuidle+0x23/0x40
[  439.574921]  do_idle+0x185/0x210
[  439.590218]  cpu_startup_entry+0x1d/0x30
[  439.605566]  start_secondary+0x133/0x170
[  439.620897]  secondary_startup_64+0xa5/0xb0
[  439.635885] Code: ff 5b 41 5c 5d c3 0f 1f 44 00 00 55 f6 47 15 01 48 89 e5 74 0f 8b 47 74 85 c0 74 0f f0 ff 4f 74 74 02 5d c3 e8 7d ff ff ff 5d c3 <0f> 0b 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41
[  439.684209] RIP: bio_put+0x25/0x30 RSP: ffff8ca2ba303c70
[  439.700579] ---[ end trace ce9f8201937066d4 ]---
[  439.720653] Kernel panic - not syncing: Fatal exception in interrupt

~ 2 seconds later a similar message, but not on the serial console anymore
