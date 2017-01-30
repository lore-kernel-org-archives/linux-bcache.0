From: Tim Small <tim@buttersideup.com>
Subject: Misaligned cache device IO (TRIM?) on 4.8.11
Date: Mon, 30 Jan 2017 12:07:32 +0000
Message-ID: <f6cd8e38-b8aa-4846-a739-acf41d5402ce@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.251.4]:51699 "EHLO
        relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753515AbdA3NgQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Jan 2017 08:36:16 -0500
Received: from [81.174.144.187] (helo=zebedee.buttersideup.com)
        by relay1.allsecuredomains.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <tim@buttersideup.com>)
        id 1cYAk9-00020i-77
        for linux-bcache@vger.kernel.org; Mon, 30 Jan 2017 13:07:33 +0100
Received: from [IPv6:2001:470:1b4a:1:405:5dff:fe10:5138] (unknown [IPv6:2001:470:1b4a:1:405:5dff:fe10:5138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by zebedee.buttersideup.com (Postfix) with ESMTPSA id 815F8A23F3
        for <linux-bcache@vger.kernel.org>; Mon, 30 Jan 2017 12:07:32 +0000 (GMT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

Using the Debian 4.8.11 kernel, I'm seeing occasional ATA command
failures on the SSD cache device with 4.8.11, these are making the SSD
fail the commands, and eventually hitting a BUG and lockup.

For the time being, I've disabled discard in the filesystem, and the
fault has not reoccurred.

[25890.520117] ata5: hard resetting link
[25890.996044] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[25890.996740] ata5.00: configured for UDMA/133
[25890.996762] sd 4:0:0:0: [sde] tag#19 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[25890.996765] sd 4:0:0:0: [sde] tag#19 Sense Key : Illegal Request
[current]
[25890.996768] sd 4:0:0:0: [sde] tag#19 Add. Sense: Unaligned write command
[25890.996771] sd 4:0:0:0: [sde] tag#19 CDB: Write(10) 2a 00 0a cf 3f 88
00 00 60 00
[25890.996773] blk_update_request: I/O error, dev sde, sector 181354376
[25890.996777] bcache: bch_count_io_errors() sde3: IO error on writing
data to cache, recovering
[25890.996798] sd 4:0:0:0: [sde] tag#20 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[25890.996800] sd 4:0:0:0: [sde] tag#20 Sense Key : Illegal Request
[current]
[25890.996802] sd 4:0:0:0: [sde] tag#20 Add. Sense: Unaligned write command
[25890.996805] sd 4:0:0:0: [sde] tag#20 CDB: Read(10) 28 00 08 0e f9 e8
00 00 20 00
[25890.996806] blk_update_request: I/O error, dev sde, sector 135199208
[25890.996807] bcache: bch_count_io_errors() sde3: IO error on reading
dirty data from cache, recovering
[25890.996813] sd 4:0:0:0: [sde] tag#21 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[25890.996815] sd 4:0:0:0: [sde] tag#21 Sense Key : Illegal Request
[current]
[25890.996817] sd 4:0:0:0: [sde] tag#21 Add. Sense: Unaligned write command
[25890.996819] sd 4:0:0:0: [sde] tag#21 CDB: Read(10) 28 00 08 0e f9 a8
00 00 20 00
[25890.996820] blk_update_request: I/O error, dev sde, sector 135199144
[25890.996821] bcache: bch_count_io_errors() sde3: IO error on reading
dirty data from cache, recovering
[25890.996829] ata5: EH complete
[25890.997000] ------------[ cut here ]------------
[25890.997037] kernel BUG at
/build/linux-Wgpe2M/linux-4.8.11/block/bio.c:1785!
[25890.997077] invalid opcode: 0000 [#1] SMP
[25890.997099] Modules linked in: cpufreq_powersave(E)
cpufreq_conservative(E) cpufreq_userspace(E) nf_log_ipv4(E)
nf_log_common(E) xt_tcpudp(E) ip6table_mangle(E) iptable_nat(E)
nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E)
xt_TCPMSS(E) xt_LOG(E) ipt_REJECT(E) nf_reject_ipv4(E) iptable_mangle(E)
xt_multiport(E) xt_state(E) xt_limit(E) xt_conntrack(E)
nf_conntrack_ftp(E) nf_conntrack(E) ip6table_filter(E) ip6_tables(E)
iptable_filter(E) ip_tables(E) x_tables(E) nfsd(E) auth_rpcgss(E)
nfs_acl(E) nfs(E) lockd(E) grace(E) fscache(E) sunrpc(E) binfmt_misc(E)
nbd(E) dm_crypt(E) xts(E) gf128mul(E) algif_skcipher(E) af_alg(E)
intel_rapl(E) iTCO_wdt(E) iTCO_vendor_support(E) x86_pkg_temp_thermal(E)
coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E)
crc32_pclmul(E) ghash_clmulni_intel(E)
[25890.997571]  cryptd(E) serio_raw(E) pcspkr(E) tpm_infineon(E)
mgag200(E) ttm(E) drm_kms_helper(E) drm(E) hpilo(E) i2c_algo_bit(E)
hpwdt(E) evdev(E) ipmi_si(E) ipmi_msghandler(E) acpi_power_meter(E)
button(E) ie31200_edac(E) shpchp(E) edac_core(E) lpc_ich(E) mfd_core(E)
tpm_tis(E) tpm_tis_core(E) tpm_rng(E) tpm(E) rng_core(E) autofs4(E)
ext4(E) crc16(E) jbd2(E) fscrypto(E) mbcache(E) btrfs(E) dm_mod(E)
raid456(E) async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E)
async_tx(E) xor(E) raid6_pq(E) libcrc32c(E) crc32c_generic(E) raid1(E)
md_mod(E) bcache(E) sg(E) sd_mod(E) hid_generic(E) usbhid(E) hid(E)
crc32c_intel(E) psmouse(E) thermal(E) fjes(E) ahci(E) libahci(E)
uhci_hcd(E) xhci_pci(E) ehci_pci(E) xhci_hcd(E) ehci_hcd(E) libata(E)
tg3(E) ptp(E) pps_core(E) libphy(E) scsi_mod(E) usbcore(E)
[25890.998061]  usb_common(E)
[25890.998075] CPU: 1 PID: 854 Comm: btrfs-transacti Tainted: G        W
  E   4.8.0-0.bpo.2-amd64 #1 Debian 4.8.11-1~bpo8+1
[25890.998134] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06
07/16/2015
[25890.998174] task: ffff8abb2733d040 task.stack: ffff8abb23d38000
[25890.998207] RIP: 0010:[<ffffffff9cef44f2>]  [<ffffffff9cef44f2>]
bio_split+0x82/0x90
[25890.998259] RSP: 0018:ffff8abb23d3bad0  EFLAGS: 00010246
[25890.998288] RAX: 0000000000000000 RBX: 0000000000003000 RCX:
ffff8abb3331be00
[25890.998327] RDX: 0000000002400000 RSI: 0000000000000000 RDI:
ffff8abb2c181920
[25890.998366] RBP: ffff8abb23d3bb70 R08: ffff8abb2c181920 R09:
0000160000000000
[25890.998404] R10: ffff8abb23d3bb30 R11: 00000000000000a8 R12:
0000000000000000
[25890.998443] R13: 0000000000000000 R14: ffff8abb3292b240 R15:
0000000000000000
[25890.998482] FS:  0000000000000000(0000) GS:ffff8abb3a240000(0000)
knlGS:0000000000000000
[25890.998525] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25890.998557] CR2: 00007fc62fb57000 CR3: 0000000128806000 CR4:
00000000001406e0
[25890.998596] Stack:
[25890.998611]  ffffffff9cf01626 7393cd638ab69a27 d7a3fabff65c2e46
ffff8abb32b2eb30
[25890.998658]  ffff8abb3331be00 0006008000000000 ffff8abb23d3bb80
00000a0000000058
[25890.998704]  000000a800000000 ffff8abb2c181920 0000020200000000
0000000000000000
[25890.998751] Call Trace:
[25890.998770]  [<ffffffff9cf01626>] ? blk_queue_split+0x1f6/0x610
[25890.998804]  [<ffffffff9cefc89f>] ? blk_queue_bio+0x4f/0x3b0
[25890.998837]  [<ffffffff9cefae66>] ? generic_make_request+0x106/0x1f0
[25890.998875]  [<ffffffff9cefafc6>] ? submit_bio+0x76/0x150
[25890.998906]  [<ffffffff9cf030a8>] ? next_bio+0x18/0x40
[25890.998936]  [<ffffffff9cf03225>] ? __blkdev_issue_discard+0x155/0x1b0
[25890.998973]  [<ffffffff9cef1a54>] ? submit_bio_wait+0x54/0x80
[25890.999007]  [<ffffffff9cf0341a>] ? blkdev_issue_discard+0x7a/0xd0
[25890.999065]  [<ffffffffc055d97f>] ? btrfs_issue_discard+0x12f/0x180
[btrfs]
[25890.999121]  [<ffffffffc05649ef>] ? btrfs_discard_extent+0xbf/0x180
[btrfs]
[25890.999175]  [<ffffffffc05682f6>] ?
btrfs_finish_extent_commit+0x116/0x250 [btrfs]
[25890.999235]  [<ffffffffc0581c05>] ?
btrfs_commit_transaction+0x7f5/0xa30 [btrfs]
[25890.999293]  [<ffffffffc0581ed6>] ? start_transaction+0x96/0x4d0 [btrfs]
[25890.999347]  [<ffffffffc057c2de>] ? transaction_kthread+0x1ce/0x1f0
[btrfs]
[25890.999400]  [<ffffffffc057c110>] ?
btrfs_cleanup_transaction+0x590/0x590 [btrfs]
[25890.999442]  [<ffffffff9cc9cecf>] ? kthread+0xdf/0x100
[25890.999473]  [<ffffffff9cc2b78b>] ? __switch_to+0x2bb/0x710
[25890.999506]  [<ffffffff9d1f3daf>] ? ret_from_fork+0x1f/0x40
[25890.999538]  [<ffffffff9cc9cdf0>] ? kthread_park+0x50/0x50
[25890.999568] Code: 10 31 f6 44 89 e2 48 89 df e8 3b 3f 03 00 8b 73 28
48 89 ef e8 90 df ff ff 48 89 d8 5b 5d 41 5c c3 e8 33 fc ff ff 48 89 c3
eb bb <0f> 0b 0f 0b 31 c0 eb e9 66 0f 1f 44 00 00 0f 1f 44 00 00 48 8b
[25890.999771] RIP  [<ffffffff9cef44f2>] bio_split+0x82/0x90
[25891.001795]  RSP <ffff8abb23d3bad0>
