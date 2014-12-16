From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
Subject: Kernel OOPs when registering caching device (linux 3.18)
Date: Tue, 16 Dec 2014 19:14:08 +0100
Message-ID: <7363.1418753648@nice>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:47564 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaLPSOM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 16 Dec 2014 13:14:12 -0500
Received: from tours.ram.loc (unknown [82.233.116.188])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 3CC59A6310
	for <linux-bcache@vger.kernel.org>; Tue, 16 Dec 2014 19:13:23 +0100 (CET)
Received: from nice.ram.loc (nice.ram.loc [192.168.0.3])
	by tours.ram.loc (8.14.3/8.14.3/Debian-9.1) with ESMTP id sBGIE9jd025743
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-bcache@vger.kernel.org>; Tue, 16 Dec 2014 19:14:10 +0100
Received: from nice.ram.loc (localhost [127.0.0.1])
	by nice.ram.loc (8.14.4/8.14.4/Debian-4) with ESMTP id sBGIE9Fa007367
	for <linux-bcache@vger.kernel.org>; Tue, 16 Dec 2014 19:14:09 +0100
Received: from nice (ram@localhost)
	by nice.ram.loc (8.14.4/8.14.4/Submit) with ESMTP id sBGIE83o007364
	for <linux-bcache@vger.kernel.org>; Tue, 16 Dec 2014 19:14:09 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I'm experimenting with bcache within a virtual machine, before using it on
a real machine.

I compiled the kernel (plain stock 3.18 from kernel.org) myself and I am
running a para-virtualized kernel on top of XEN 4.4.

When initially running:

	# make-bcache -C /dev/xvdc

the kernel spits out the following:

[   93.748215] ------------[ cut here ]------------
[   93.748741] kernel BUG at drivers/md/bcache/super.c:1840!
[   93.749163] invalid opcode: 0000 [#1] SMP 
[   93.749592] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc bridge stp llc loop snd_pcm snd_timer snd soundcore thermal_sys evdev pcspkr joydev ext4 crc16 mbcache jbd2 dm_mod bcache xen_netfront xen_blkfront
[   93.750946] CPU: 2 PID: 2265 Comm: bcache-register Not tainted 3.18.0 #2
[   93.751492] task: dcab2560 ti: debc6000 task.ti: debc6000
[   93.751939] EIP: 0061:[<e0ae5510>] EFLAGS: 00010246 CPU: 2
[   93.752121] EIP is at register_bcache+0x11e0/0x2170 [bcache]
[   93.752121] EAX: c25129c0 EBX: c25d8000 ECX: 0000002f EDX: dfb16e70
[   93.752121] ESI: 00000000 EDI: 00000008 EBP: debc7f14 ESP: debc7e40
[   93.752121]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0069
[   93.752121] CR0: 8005003b CR2: 086922dc CR3: 1e8a8000 CR4: 00000620
[   93.752121] Stack:
[   93.752121]  00001000 00000008 dcd60580 ffffffff 00000000 debc7e88 c1005f1a 00000022
[   93.752121]  dcd60580 01000100 c2499490 c387d848 00000000 00000000 00000000 dcd27038
[   93.752121]  dcd27028 00000000 00000000 dcd27018 debc7eac c25d8938 00000000 00000000
[   93.752121] Call Trace:
[   93.752121]  [<c1005f1a>] ? xen_batched_set_pte+0x1a/0x160
[   93.752121]  [<c114c8d4>] ? handle_mm_fault+0x524/0xf10
[   93.752121]  [<c116a3b4>] ? __kmalloc+0x94/0x5d0
[   93.752121]  [<e0ae4330>] ? bch_cache_set_alloc+0x4f0/0x4f0 [bcache]
[   93.752121]  [<c126ec25>] ? kobj_attr_store+0x15/0x30
[   93.752121]  [<c11e23e5>] ? sysfs_kf_write+0x35/0x50
[   93.752121]  [<c11e23b0>] ? sysfs_kf_bin_read+0xc0/0xc0
[   93.752121]  [<c11e17c7>] ? kernfs_fop_write+0xc7/0x150
[   93.752121]  [<c11e23b0>] ? sysfs_kf_bin_read+0xc0/0xc0
[   93.752121]  [<c11e1700>] ? kernfs_vma_page_mkwrite+0x80/0x80
[   93.752121]  [<c117eb9e>] ? vfs_write+0x9e/0x1e0
[   93.752121]  [<c118f3dc>] ? do_fcntl+0x36c/0x510
[   93.752121]  [<c117f166>] ? SyS_write+0x46/0x90
[   93.752121]  [<c14aa45f>] ? sysenter_do_call+0x12/0x12
[   93.752121] Code: 0f 85 bf fa ff ff e9 b2 fa ff ff 0f 0b 8b 44 24 6c e8 a5 b9 64 e0 84 c0 0f 85 42 f4 ff ff e9 35 f4 ff ff 90 8d b4 26 00 00 00 00 <0f> 0b 8b bc 24 80 00 00 00 be 0a f0 ae e0 b8 24 54 af e0 e8 d8
[   93.752121] EIP: [<e0ae5510>] register_bcache+0x11e0/0x2170 [bcache] SS:ESP 0069:debc7e40
[   93.767489] ---[ end trace bacc83d385d551aa ]---

Running:

	# bcache-super-show /dev/xvdc

then produces:

sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 C645C4895EA701F1 [match]
sb.version              0 [cache device]

dev.label               (empty)
dev.uuid                2e549ac6-b553-430e-8d79-9914bc4b067d
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 203776
dev.cache.total_sectors 204800
dev.cache.ordered       no
dev.cache.discard       no
dev.cache.pos           0
dev.cache.replacement   0 [lru]

cset.uuid               0f1049f1-fa57-4593-8e8d-e1cdab17a847

The backing device worked fine.

	# make-bcache -B /dev/xvdd

produced at the next boot:

[    2.733692] bcache: register_bdev() registered backing device xvdd

However, I get other OOPses when I reboot with my unregistered xvdc
caching device:

[    2.467772] ------------[ cut here ]------------
[    2.467825] kernel BUG at drivers/md/bcache/super.c:1840!
[    2.467849] invalid opcode: 0000 [#1] SMP 
[    2.467874] Modules linked in: bcache xen_netfront xen_blkfront
[    2.467909] CPU: 0 PID: 110 Comm: bcache-register Not tainted 3.18.0 #2
[    2.467951] task: dcac4560 ti: dcace000 task.ti: dcace000
[    2.468008] EIP: 0061:[<e0af1510>] EFLAGS: 00010246 CPU: 0
[    2.468062] EIP is at register_bcache+0x11e0/0x2170 [bcache]
[    2.468086] EAX: c24e5ea0 EBX: c25d6000 ECX: 00000055 EDX: dfaf6e70
[    2.468111] ESI: 00000000 EDI: 00000008 EBP: dcacff14 ESP: dcacfe40
[    2.468137]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0069
[    2.468173] CR0: 8005003b CR2: b75eb017 CR3: 025dc000 CR4: 00000620
[    2.468207] Stack:
[    2.468231]  00001000 00000008 dfb24000 c25e83d8 00000037 c25e83d8 dcacfec0 c114b5c9
[    2.468289]  de1f0dc0 01000100 de32a350 dfb6fd00 00000000 00000000 00000000 dcb88038
[    2.468348]  dcb88028 00000000 00000000 dcb88018 08070000 c25d6938 00000000 00000000
[    2.468387] Call Trace:
[    2.468417]  [<c114b5c9>] ? do_read_fault.isra.69+0x2f9/0x340
[    2.468453]  [<c114cbc7>] ? handle_mm_fault+0x817/0xf10
[    2.468482]  [<c116a3b4>] ? __kmalloc+0x94/0x5d0
[    2.468510]  [<e0af0330>] ? bch_cache_set_alloc+0x4f0/0x4f0 [bcache]
[    2.468543]  [<c126ec25>] ? kobj_attr_store+0x15/0x30
[    2.468573]  [<c11e23e5>] ? sysfs_kf_write+0x35/0x50
[    2.468602]  [<c11e23b0>] ? sysfs_kf_bin_read+0xc0/0xc0
[    2.468637]  [<c11e17c7>] ? kernfs_fop_write+0xc7/0x150
[    2.468664]  [<c11e23b0>] ? sysfs_kf_bin_read+0xc0/0xc0
[    2.468691]  [<c11e1700>] ? kernfs_vma_page_mkwrite+0x80/0x80
[    2.468721]  [<c117eb9e>] ? vfs_write+0x9e/0x1e0
[    2.468746]  [<c117f166>] ? SyS_write+0x46/0x90
[    2.468773]  [<c14aa549>] ? syscall_call+0x7/0x7
[    2.468793] Code: 0f 85 bf fa ff ff e9 b2 fa ff ff 0f 0b 8b 44 24 6c e8 a5 f9 63 e0 84 c0 0f 85 42 f4 ff ff e9 35 f4 ff ff 90 8d b4 26 00 00 00 00 <0f> 0b 8b bc 24 80 00 00 00 be 0a b0 af e0 b8 24 14 b0 e0 e8 d8
[    2.470510] EIP: [<e0af1510>] register_bcache+0x11e0/0x2170 [bcache] SS:ESP 0069:dcacfe40
[    2.471290] ---[ end trace e787c07ea8fae3da ]---

How can I assist you into nailing down this bug?

Thanks,
Raphael
