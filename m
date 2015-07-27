From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: crash: kernel bug in bch_generic_make_request
Date: Mon, 27 Jul 2015 12:36:16 +0200
Message-ID: <20150727123616.Horde.QmkKAZrQpCm25D6aq4ZAhJY@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:40764 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbG0KmY (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 27 Jul 2015 06:42:24 -0400
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.8 AUTH)
	with ESMTPA id k0580er6RAaM2Fj
	for <linux-bcache@vger.kernel.org>;
	Mon, 27 Jul 2015 12:36:22 +0200 (CEST)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id E12101C05C
	for <linux-bcache@vger.kernel.org>; Mon, 27 Jul 2015 12:36:16 +0200 (CEST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi everybody,

we experience reproducible server crashes (reboots) when creating new  
file systems on bcache'd devices.

- kernel is 3.18.8-5-default (it's an OpenSUSE 13.1 install with a  
custom kernel)

- modinfo bcache
filename:        
/lib/modules/3.18.8-5-default/kernel/drivers/md/bcache/bcache.ko
license:        GPL
author:         Kent Overstreet <koverstreet@google.com>
author:         Kent Overstreet <kent.overstreet@gmail.com>
license:        GPL
srcversion:     92A8EFA83993DEC9D37BD5E
depends:
intree:         Y
vermagic:       3.18.8-5-default SMP mod_unload modversions

- modinfo drbd
filename:       /lib/modules/3.18.8-5-default/updates/drbd.ko
alias:          block-major-147-*
license:        GPL
version:        8.4.6
description:    drbd - Distributed Replicated Block Device v8.4.6
author:         Philipp Reisner <phil@linbit.com>, Lars Ellenberg  
<lars@linbit.com>
srcversion:     36DF3A3564C161B02724575
depends:        libcrc32c
vermagic:       3.18.8-5-default SMP mod_unload modversions

- crash details from (remote) syslog:

--- cut here ---
Jul 23 07:39:47 server kernel: [78293.803010] ------------[ cut here  
]------------
Jul 23 07:39:47 server kernel: [78293.803059] kernel BUG at  
../block/bio.c:1836!
Jul 23 07:39:47 server kernel: [78293.803097] invalid opcode: 0000 [#1] SMP
Jul 23 07:39:47 server kernel: [78293.803134] Modules linked in: md5  
binfmt_misc qla2x00tgt(O) scst_vdisk(O) nfsd lockd grace nfs_acl  
auth_rpcgss scst(O) sunrpc drbd(O) tcp_diag libcrc32c inet_diag  
bonding joydev hid_generic usbhid usb_storage iTCO_wdt  
iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp coretemp  
kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel  
ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw gf128mul  
glue_helper aes_x86_64 pcspkr qla2xxx_scst(O) scsi_transport_fc  
sb_edac edac_core lpc_ich i2c_i801 mfd_core xhci_pci xhci_hcd mei_me  
mei ioatdma igb dca ptp pps_core ses enclosure tpm_tis shpchp tpm wmi  
8250_fintek ipmi_si ipmi_msghandler acpi_power_meter acpi_pad button  
sg linear ast ttm drm_kms_helper ehci_pci drm ehci_hcd i2c_algo_bit  
sysimgblt sysfillrect syscopyarea usbcore usb_common processor  
scsi_dh_alua scsi_dh_rdac scsi_dh_emc scsi_dh_hp_sw scsi_dh raid456  
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy  
async_tx raid10 raid1 raid0 md_mod dm_snapshot dm_bufio dm_mirror  
dm_region_hash dm_log dm_mod mpt3sas scsi_transport_sas raid_class  
bcache
Jul 23 07:39:47 server kernel: [78293.820577] CPU: 2 PID: 25532 Comm:  
kworker/u24:0 Tainted: G           O   3.18.8-5-default #1
Jul 23 07:39:47 server kernel: [78293.822659] Hardware name:  
Supermicro X10DRT-P Series/X10DRT-P, BIOS 1.0b 01/06/2015
Jul 23 07:39:47 server kernel: [78293.824771] Workqueue:  
drbd122_submit do_submit [drbd]
Jul 23 07:39:47 server kernel: [78293.826883] task: ffff880849a5a590  
ti: ffff8807d81f4000 task.ti: ffff8807d81f4000
Jul 23 07:39:47 server kernel: [78293.828997] RIP:  
0010:[<ffffffff812f9e1e>]  [<ffffffff812f9e1e>] bio_split+0x6e/0x70
Jul 23 07:39:47 server kernel: [78293.831131] RSP:  
0018:ffff8807d81f7ae8  EFLAGS: 00010246
Jul 23 07:39:47 server kernel: [78293.833225] RAX: 0000000000000000  
RBX: ffff88003710a020 RCX: ffff88105785f2c0
Jul 23 07:39:47 server kernel: [78293.835318] RDX: 0000000000000010  
RSI: 0000000000000000 RDI: ffff88003710a020
Jul 23 07:39:47 server kernel: [78293.837403] RBP: 0000000000000000  
R08: ffff8810574804c0 R09: ffff8808567f7810
Jul 23 07:39:47 server kernel: [78293.839480] R10: ffff88087fc985b8  
R11: 0000000000000025 R12: ffff8807cdd24140
Jul 23 07:39:47 server kernel: [78293.841544] R13: ffff8807cdd24168  
R14: ffff88105785f2c0 R15: ffff880856875e58
Jul 23 07:39:47 server kernel: [78293.843593] FS:   
0000000000000000(0000) GS:ffff88087fc80000(0000) knlGS:0000000000000000
Jul 23 07:39:47 server kernel: [78293.845676] CS:  0010 DS: 0000 ES:  
0000 CR0: 0000000080050033
Jul 23 07:39:47 server kernel: [78293.847766] CR2: 0000000002382390  
CR3: 0000000001e16000 CR4: 00000000001407e0
Jul 23 07:39:47 server kernel: [78293.849887] Stack:
Jul 23 07:39:47 server kernel: [78293.851999]  ffff88003710a020  
ffff88003710a020 ffff8807cdd24140 ffffffffa000d4dd
Jul 23 07:39:47 server kernel: [78293.854165]  ffff88003710a020  
ffff880856875d10 ffff880856875d10 ffffc90017581000
Jul 23 07:39:47 server kernel: [78293.856328]  ffff880856875df0  
ffffffffa0012bd3 ffff88003710a020 ffff880856875d10
Jul 23 07:39:47 server kernel: [78293.858488] Call Trace:
Jul 23 07:39:47 server kernel: [78293.860648]  [<ffffffffa000d4dd>]  
bch_generic_make_request+0x14d/0x1e0 [bcache]
Jul 23 07:39:47 server kernel: [78293.862842]  [<ffffffffa0012bd3>]  
bch_data_insert_start+0xc3/0x550 [bcache]
Jul 23 07:39:47 server kernel: [78293.865014]  [<ffffffffa0013dc4>]  
cached_dev_make_request+0xc34/0xe60 [bcache]
Jul 23 07:39:47 server kernel: [78293.867168]  [<ffffffff812fe210>]  
generic_make_request+0xb0/0x100
Jul 23 07:39:47 server kernel: [78293.869327]  [<ffffffffa06de3fa>]  
drbd_send_and_submit+0x92a/0x1cb0 [drbd]
Jul 23 07:39:47 server kernel: [78293.871498]  [<ffffffffa06dff5d>]  
send_and_submit_pending+0x7d/0xa0 [drbd]
Jul 23 07:39:47 server kernel: [78293.873637]  [<ffffffffa06e032d>]  
do_submit+0x3ad/0x490 [drbd]
Jul 23 07:39:47 server kernel: [78293.875758]  [<ffffffff810781b8>]  
process_one_work+0x148/0x3c0
Jul 23 07:39:47 server kernel: [78293.877898]  [<ffffffff81078806>]  
worker_thread+0x116/0x470
Jul 23 07:39:47 server kernel: [78293.880011]  [<ffffffff8107d57a>]  
kthread+0xca/0xe0
Jul 23 07:39:47 server kernel: [78293.882097]  [<ffffffff8160fc7c>]  
ret_from_fork+0x7c/0xb0
Jul 23 07:39:47 server kernel: [78293.884166] Code: 31 f6 89 ea 48 89  
c7 e8 81 08 03 00 8b 73 28 4c 89 e7 e8 86 f1 ff ff 48 89 d8 5b 5d 41  
5c c3 66 0f 1f 44 00 00 31 c0 eb f1 0f 0b <0f> 0b 0f 1f 44 00 00 41 57  
49 89 d2 41 56 41 89 f6 be 01 00 00
Jul 23 07:39:47 server kernel: [78293.888557] RIP   
[<ffffffff812f9e1e>] bio_split+0x6e/0x70
Jul 23 07:39:47 server kernel: [78293.890696]  RSP <ffff8807d81f7ae8>
Jul 23 07:39:47 server kernel: [78294.110317] ---[ end trace  
ec3665f2de46ff27 ]---
Jul 23 07:39:47 server kernel: [78294.142139] BUG: unable to handle  
kernel paging request at ffffffffffffffd8
Jul 23 07:39:47 server kernel: [78294.142150] IP: [<ffffffff8107db2c>]  
kthread_data+0xc/0x20
Jul 23 07:39:47 server kernel: [78294.142153] PGD 1e17067 PUD 1e19067 PMD 0
Jul 23 07:39:47 server kernel: [78294.142156] Oops: 0000 [#2] SMP
Jul 23 07:39:47 server kernel: [78294.142204] Modules linked in: md5  
binfmt_misc qla2x00tgt(O) scst_vdisk(O) nfsd lockd grace nfs_acl  
auth_rpcgss scst(O) sunrpc drbd(O) tcp_diag libcrc32c inet_diag  
bonding joydev hid_generic usbhid usb_storage iTCO_wdt  
iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp coretemp  
kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel  
ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw gf128mul  
glue_helper aes_x86_64 pcspkr qla2xxx_scst(O) scsi_transport_fc  
sb_edac edac_core lpc_ich i2c_i801 mfd_core xhci_pci xhci_hcd mei_me  
mei ioatdma igb dca ptp pps_core ses enclosure tpm_tis shpchp tpm wmi  
8250_fintek ipmi_si ipmi_msghandler acpi_power_meter acpi_pad button  
sg linear ast ttm drm_kms_helper ehci_pci drm ehci_hcd i2c_algo_bit  
sysimgblt sysfillrect syscopyarea usbcore usb_common processor  
scsi_dh_alua scsi_dh_rdac scsi_dh_emc scsi_dh_hp_sw scsi_dh raid456  
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy  
async_tx raid10 raid1 raid0 md_mod dm_snapshot dm_bufio dm_mirror  
dm_region_hash dm_log dm_mod mpt3sas scsi_transport_sas raid_class  
bcache
Jul 23 07:39:47 server kernel: [78294.142224] CPU: 9 PID: 25532 Comm:  
kworker/u24:0 Tainted: G      D    O   3.18.8-5-default #1
Jul 23 07:39:47 server kernel: [78294.142225] Hardware name:  
Supermicro X10DRT-P Series/X10DRT-P, BIOS 1.0b 01/06/2015
Jul 23 07:39:47 server kernel: [78294.142241] task: ffff880849a5a590  
ti: ffff8807d81f4000 task.ti: ffff8807d81f4000
Jul 23 07:39:47 server kernel: [78294.142244] RIP:  
0010:[<ffffffff8107db2c>]  [<ffffffff8107db2c>] kthread_data+0xc/0x20
Jul 23 07:39:47 server kernel: [78294.142245] RSP:  
0018:ffff8807d81f7860  EFLAGS: 00010002
Jul 23 07:39:47 server kernel: [78294.142246] RAX: 0000000000000000  
RBX: 0000000000000009 RCX: 0000000000000000
Jul 23 07:39:47 server kernel: [78294.142247] RDX: 0000000000000000  
RSI: 0000000000000009 RDI: ffff880849a5a590
Jul 23 07:39:47 server kernel: [78294.142248] RBP: ffff8807d81f78d8  
R08: 0000000000000000 R09: 0000000000000246
Jul 23 07:39:47 server kernel: [78294.142249] R10: ffffffff821ef3b0  
R11: 0000000000000000 R12: ffff88107fcd2480
Jul 23 07:39:47 server kernel: [78294.142250] R13: 0000000000000009  
R14: 0000000000000000 R15: ffff880849a5a590
Jul 23 07:39:47 server kernel: [78294.142252] FS:   
0000000000000000(0000) GS:ffff88107fcc0000(0000) knlGS:0000000000000000
Jul 23 07:39:47 server kernel: [78294.142253] CS:  0010 DS: 0000 ES:  
0000 CR0: 0000000080050033
Jul 23 07:39:47 server kernel: [78294.142254] CR2: 0000000000000028  
CR3: 0000000001e16000 CR4: 00000000001407e0
Jul 23 07:39:47 server kernel: [78294.142255] Stack:
Jul 23 07:39:47 server kernel: [78294.142258]  ffffffff81078bdd  
ffff880849a5a590 ffffffff8160ba69 ffff880849a5a590
Jul 23 07:39:47 server kernel: [78294.142259]  ffff8807d81f7fd8  
0000000000012480 0000000000012480 ffff8807d81f7898
Jul 23 07:39:47 server kernel: [78294.142261]  ffff880849a5a590  
0000000000000246 ffff880849a5ad08 ffff880849a5a580
Jul 23 07:39:47 server kernel: [78294.142262] Call Trace:
Jul 23 07:39:47 server kernel: [78294.142277]  [<ffffffff81078bdd>]  
wq_worker_sleeping+0xd/0xa0
Jul 23 07:39:47 server kernel: [78294.142285]  [<ffffffff8160ba69>]  
thread_return+0x28c/0x4c3
Jul 23 07:39:47 server kernel: [78294.142296]  [<ffffffff810637ef>]  
do_exit+0x6ff/0xa70
Jul 23 07:39:47 server kernel: [78294.142304]  [<ffffffff810066c7>]  
oops_end+0x97/0xe0
Jul 23 07:39:47 server kernel: [78294.142309]  [<ffffffff81003730>]  
do_error_trap+0x70/0xe0
Jul 23 07:39:47 server kernel: [78294.142316]  [<ffffffff816117be>]  
invalid_op+0x1e/0x30
Jul 23 07:39:47 server kernel: [78294.142324]  [<ffffffff812f9e1e>]  
bio_split+0x6e/0x70
Jul 23 07:39:47 server kernel: [78294.142343]  [<ffffffffa000d4dd>]  
bch_generic_make_request+0x14d/0x1e0 [bcache]
Jul 23 07:39:47 server kernel: [78294.142358]  [<ffffffffa0012bd3>]  
bch_data_insert_start+0xc3/0x550 [bcache]
Jul 23 07:39:47 server kernel: [78294.142370]  [<ffffffffa0013dc4>]  
cached_dev_make_request+0xc34/0xe60 [bcache]
Jul 23 07:39:47 server kernel: [78294.142377]  [<ffffffff812fe210>]  
generic_make_request+0xb0/0x100
Jul 23 07:39:47 server kernel: [78294.142393]  [<ffffffffa06de3fa>]  
drbd_send_and_submit+0x92a/0x1cb0 [drbd]
Jul 23 07:39:47 server kernel: [78294.142424]  [<ffffffffa06dff5d>]  
send_and_submit_pending+0x7d/0xa0 [drbd]
Jul 23 07:39:47 server kernel: [78294.142433]  [<ffffffffa06e032d>]  
do_submit+0x3ad/0x490 [drbd]
Jul 23 07:39:47 server kernel: [78294.142440]  [<ffffffff810781b8>]  
process_one_work+0x148/0x3c0
Jul 23 07:39:47 server kernel: [78294.142444]  [<ffffffff81078806>]  
worker_thread+0x116/0x470
Jul 23 07:39:47 server kernel: [78294.142448]  [<ffffffff8107d57a>]  
kthread+0xca/0xe0
Jul 23 07:39:47 server kernel: [78294.142454]  [<ffffffff8160fc7c>]  
ret_from_fork+0x7c/0xb0
Jul 23 07:39:47 server kernel: [78294.142475] Code: 00 05 00 00 48 8b  
40 c8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00  
00 00 0f 1f 44 00 00 48 8b 87 00 05 00 00 <48> 8b 40 d8 c3 66 66 66 66  
66 66 2e 0f 1f 84 00 00 00 00 00 0f
Jul 23 07:39:47 server kernel: [78294.142478] RIP   
[<ffffffff8107db2c>] kthread_data+0xc/0x20
Jul 23 07:39:47 server kernel: [78294.142479]  RSP <ffff8807d81f7860>
Jul 23 07:39:47 server kernel: [78294.142479] CR2: ffffffffffffffd8
Jul 23 07:39:47 server kernel: [78294.142482] ---[ end trace  
ec3665f2de46ff28 ]---
Jul 23 07:39:47 server kernel: [78294.156953] Fixing recursive fault  
but reboot is needed!
--- cut here ---

- bcache bucket size is 512k, tree_depth is 1

- setup details:

-- md RAID6 "data" via seven 1 TB physical disks ("blockdev --getsz"  
reports 9767605760 512byte blocks, approx 5 TB)

-- md RAID1 "cache" via two 128 GB SSDs ("blockdev --getsz" reports  
249936512 512byte blocks, approx 125 GB)

-- "bcache0" made from "data" and "cache"

-- LVM via single physical volume "bcache0"

-- many LVs create with older kernel

-- DRBD on top of each LV. This server is always primary, no  
"fail-over" to a different node!

-- file system (to be) created on the DRBD devices

We upgraded the kernel incl. DRBD as we experienced random server  
reboots (probably in DRBD, but that was just guessing based on DRBD  
change logs), to the versions mentioned above, and now have the first  
case where we need to create an additional logical volume plus file  
system. Creating the LV works nicely, as does DRBD resync, but when  
running the "mkfs" command, the above exceptions occur and the server  
reboots.

I've seen 5 bcache patches that were reported on the list and  
back-ported to OpenSUSE 13.2  
(https://bugzilla.suse.com/attachment.cgi?id=617628&action=edit), but  
none of these immediately seem to apply to the above situation.

While I couldn't find references on the net to the symptoms we  
experience, can anybody tell this is an already known problem, and  
probably point to a solution? Any other help would of course be  
appreciated as well :)

Regards,
Jens
