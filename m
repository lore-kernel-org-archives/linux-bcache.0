From: IT-Support <it-support@spreadshirt.net>
Subject: bcache oops in bch_btree_node_read_done
Date: Tue, 04 Mar 2014 14:28:46 +0100
Message-ID: <5315D50E.8030200@spreadshirt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.spreadomat.net ([85.239.103.149]:55577 "EHLO
	mx.spreadomat.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbaCDNio (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 4 Mar 2014 08:38:44 -0500
Received: from localhost (localhost [127.0.0.1])
	by mx.spreadomat.net (Postfix) with ESMTP id CD94858014B
	for <linux-bcache@vger.kernel.org>; Tue,  4 Mar 2014 14:28:47 +0100 (CET)
Received: from mx.spreadomat.net ([127.0.0.1])
	by localhost (mx.spreadomat.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sv2+NS8lLJ0K for <linux-bcache@vger.kernel.org>;
	Tue,  4 Mar 2014 14:28:46 +0100 (CET)
Received: from [10.100.10.86] (lpz-66.sprd.net [88.79.226.66])
	by mx.spreadomat.net (Postfix) with ESMTPA id C208F580119
	for <linux-bcache@vger.kernel.org>; Tue,  4 Mar 2014 14:28:46 +0100 (CET)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

we operate 4 equal servers (HP DL360 G5), each with 6 hard disks. These
disks are used for ceph OSD's and they are configured to use bcache.
Once per week one of the servers stops with an Oops.

System is Ubuntu 12.04 LTS 64bit with kernel package
linux-image-3.11.0-15-generic.

Here are the kernel messages of 2 incidents on different servers:
(done with OCR, so there may be wrong characters)

[1335759.070167] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[1335759.070340] IP: [<ffffffffa021b59f>]
bch_btree_node_read_done+0x4f/0x430 [bcache]
[1335759.070494] PGD 802573067 PUD 800a1c067 PMD 0
[1335759.070612] Oops: 0002 [#1] SMP
[1335759.070685] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs
msdos jfs reiserfs ext2 mptctl mptbase ipmi_de_intf bonding
radeon xfs coretemp ttm i5000_edac edac_core drm_kms_helper bridge
ipmi_si drm gpio_ich psmouse ipmi_msghandler i5k_amb hpwdt sh
pchp lpc_ich i2c_algo_bit hpilo serio_raw stp mac_hid llc lp parport
bcache ses enclosure btrfs hid_eneric usbhid hid hpsa raid
6_pq mpt2sas bnx2 scsi_transport_sas raid_class cciss xor zlib_deflate
[1335759.072181] CPU: 1 PID: 18619 Comm: kworker/1:2 Not tainted
3.11.0-15-generic #25~precise1-Ubuntu
[1335759.072323] Hardware name: HP ProLiant DL360 G5, BIOS P58 05/02/20=
11
[1335759.072427] Workqueue: bcache bch_journal [bcache]
[1335759.072518] task: ffff880782425dc0 ti: ffff880776cfa000 task.ti:
ffff880776cfa000
[1335759.072640] RIP: 0010:[<ffffffffa021b59f>]  [<ffffffffa021b59f>]
bch_btree_node_read_done+0x4f/0x430 [bcache]
[1335759.072798] RSP: 0018:ffff880776cfbb38  EFLAGS: 00010246
[1335759.072896] RAX: 0000000000000400 RBX: ffff8807f97bc000 RCX:
ffff8807f5480000
[1335759.073007] RDX: 0000000000000000 RSI: 0000000000000282 RDI:
0000000000000282
[1335759.073117] RBP: ffff880776cfbb68 R08: 0000000000011200 R09:
0000000000000f7d
[1335759.073226] R10: 0000000000007d24 R11: 0000000000000000 R12:
0000000000000000
[1335759.073336] R13: ffff880004980000 R14: ffff88030f4e2020 R15:
ffff880782425dc0
[1335759.073446] FS:  0000000000000000(0000) GS:ffff88082fa40000(0000)
knlGS:0000000000000000
[1335759.073575] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1335759.073665] CR2: 0000000000000008 CR3: 0000000802224000 CR4:
00000000000006e0
[1335759.073774] Stack:
[1335759.073820]  ffff880776cfbb68 ffff8807f97bc000 ffff880776cfbb78
0004bedda4b293fc
[1335759.074011]  ffff88030f4e2020 ffff880782425dc0 ffff880776cfbbd8
ffffffffa021d420
[1335759.074140]  0000000000000000 ffff880782425dc0 0000000000000000
0000000000000000
[1335759.074140] Call Trace:
[1335759.074140]  [<ffffffffa021d420>] bch_btree_node_read+0x150/0x1a0
[bcache]
[1335759.074140]  [<ffffffffa021e737>] bch_btree_node_et+0x147/0x290
[bcache]
[1335759.074140]  [<ffffffffa0220f5b>]
bch_btree_insert_recurse+0x36b/0x510 [bcache]
[1335759.074140]  [<ffffffffa0221256>] bch_btree_insert+0x156/0x330 [bc=
ache]
[1335759.074140]  [<ffffffffa022d61a>] bch_btree_insert_async+0x1a/0xe0
[bcache]
[1335759.074140]  [<ffffffffa0228139>] bch_journal+0x49/0x300 [bcache]
[1335759.074140]  [<ffffffff81081060>] process_one_work+0x170/0x4a0
[1335759.074140]  [<ffffffff81082121>] worker_thread+0x121/0x390
[1335759.074140]  [<ffffffff81082000>] ? manage_workers.isra.21+0x170/0=
x170
[1335759.074140]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
[1335759.074140]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
[1335759.074140]  [<ffffffff817508ec>] ret_from_fork+0x7c/0xb0
[1335759.074140]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
[1335759.074140] Code: af c0 00 00 00 48 8b b8 50 35 00 00 e8 8b 04 f3
e0 48 8b 8b 80 00 00 00 49 89 c4 31 d2 0f b7 81 32 04 00
00 66 f7 b1 30 04 00 00 <49> c7 44 24 08 00 00 00 00 0f b7 c0 49 89 04
24 49 8b 45 10 48
[1335759.074140] RIP  [<ffffffffa021b59f>]
bch_btree_node_read_done+0x4f/0x430 [bcache]
[1335759.074140]  RSP <ffff880776cfbb38>
[1335759.074140] CR2: 0000000000000008

[922864.546138] BUG: unable to handle kernel NULL pointer dereference a=
t
0000000000000008
[922864.546303] IP: [<ffffffffa01dd59f>]
bch_btree_node_read_done+0x4f/0x430 [bcache]
[922864.546460] PGD 0
[922864.546509] Oops: 0002 [#1] SMP
[922864.546578] Modules linked in: mptctl mptbase ipmi_de_intf xfs
radeon ttm gpio_ich i5000_edac drm_kms_helper drm edac_core l
pc_ich i2c_algo_bit coretemp i5k_amb psmouse ipmi_si shpchp serio_raw
hpilo bonding ipmi_msghandler hpwdt mac_hid lp parport bca
che ses enclosure btrfs hid_eneric usbhid hid hpsa raid6_q mpt2sas bnx2
scsi_transport_sas raid_class cciss xor zlib_deflate
[922864.547799] CPU: 7 PID: 7846 Comm: kworker/7:0 Not tainted
3.11.0-15-generic #25~precise1-Ubuntu
[922864.547935] Hardware name: HP ProLiant DL360 G5, BIOS P58 05/02/201=
1
[922864.548036] Workqueue: bcache bch_journal [bcache]
[922864.548124] task: ffff88010d1f0000 ti: ffff8806058aa000 task.ti:
ffff8806058aa000
[922864.548243] RIP: 0010:[<ffffffffa01dd59f>]  [<ffffffffa01dd59f>]
bch_btree_node_read_done+0x4f/0x430 [bcache]
[922864.548412] RSP: 0018:ffff8806058abb38  EFLAGS: 00010246
[922864.548499] RAX: 0000000000000400 RBX: ffff8807f52cac00 RCX:
ffff8807f7360000
[922864.548613] RDX: 0000000000000000 RSI: 0000000000000282 RDI:
0000000000000282
[922864.548720] RBP: ffff8806058abb68 R08: 0000000000011200 R09:
0000000000000f7d
[922864.548827] R10: 0000000000007d24 R11: 0000000000000001 R12:
0000000000000000
[922864.548933] R13: ffff8800b40c0000 R14: ffff88009f735020 R15:
ffff88010d1f0000
[922864.549041] FS:  0000000000000000(0000) GS:ffff88082fbc0000(0000)
knlGS:0000000000000000
[922864.549166] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[922864.549253] CR2: 0000000000000008 CR3: 0000000001c0d000 CR4:
00000000000006e0
[922864.549360] Stack:
[922864.549403]  ffff8806058abb68 ffff8807f52cac00 ffff8806058abb78
00034757253e6300
[922864.549583]  ffff88009f735020 ffff88010d1f0000 ffff8806058abbd8
ffffffffa01df420
[922864.549767]  0000000000000000 ffff88010d1f0000 0000000000000000
0000000000000000
[922864.549944] Call Trace:
[922864.549996]  [<ffffffffa01df420>] bch_btree_node_read+0x150/0x1a0
[bcache]
[922864.550110]  [<ffffffffa01e0737>] bch_btree_node_et+0x147/0x290 [bc=
ache]
[922864.550110]  [<ffffffffa01e2f5b>]
bch_btree_insert_recurse+0x36b/0x510 [bcache]
[922864.550110]  [<ffffffffa01e3256>] bch_btree_insert+0x156/0x330 [bca=
che]
[922864.550110]  [<ffffffffa01ef61a>] bch_btree_insert_async+0x1a/0xe0
[bcache]
[922864.550110]  [<ffffffffa01ea139>] bch_journal+0x49/0x300 [bcache]
[922864.550110]  [<ffffffff81081060>] process_one_work+0x170/0x4a0
[922864.550110]  [<ffffffff81082121>] worker_thread+0x121/0x390
[922864.550110]  [<ffffffff81082000>] ? manage_workers.isra.21+0x170/0x=
170
[922864.550110]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
[922864.550110]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
[922864.550110]  [<ffffffff817508ec>] ret_from_fork+0x7c/0xb0
[922864.550110]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
[922864.550110] Code: af c0 00 00 00 48 8b b8 50 35 00 00 e8 8b e4 f6 e=
0
48 8b 8b 80 00 00 00 49 89 c4 31 d2 0f b7 81 32 04 00 0
0 66 f7 b1 30 04 00 00 <49> c7 44 24 08 00 00 00 00 0f b7 c0 49 89 04 2=
4
49 8b 45 10 48
[922864.550110] RIP  [<ffffffffa01dd59f>]
bch_btree_node_read_done+0x4f/0x430 [bcache]
[922864.550110]  RSP <ffff8806058abb38>
[922864.550110] CR2: 0000000000000008

Any help appreciated.

Thanks.

Tino

--=20
Internal Services

phone: +49 (0)341 594 00 5531

sprd.net AG
Gie=DFerstra=DFe 27
04229 Leipzig
Germany

http://www.spreadshirt.net/

Vorstand/Executive Board: Matthias Spie=DF, Tobias Schaugg, Philip Rook=
e
Aufsichtsratsvorsitzender/Chairman of the Supervisory Board: Lukasz Gad=
owski
Handelsregister/Trade Register: Amtsgericht Leipzig, HRB 22478
Umsatzsteuer-IdentNummer/VAT-ID: DE 8138 7149 4
