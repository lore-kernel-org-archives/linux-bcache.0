From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: [bcachefs] Can't mount tiered fs. (after updating kernel?)
Date: Mon, 29 Aug 2016 14:37:45 +0200
Message-ID: <8e67f156-a5b7-007a-9f5f-81ea11263e9e@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:58782 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932742AbcH2MiA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Aug 2016 08:38:00 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
Today I've updated linux-bcache to
58b5f01a443201c4b6c219fa14e6712a0dc08b06 . Changed some option in
menuconfig:
-CONFIG_CRYPTO_LZ4=y
+CONFIG_CRYPTO_LZ4=m

-CONFIG_LZ4_COMPRESS=y
-CONFIG_LZ4_DECOMPRESS=y
-CONFIG_XZ_DEC=y
+CONFIG_LZ4_COMPRESS=m
+CONFIG_LZ4_DECOMPRESS=m
+CONFIG_XZ_DEC=m

After reboot I can't mount bcachefs:
> [  249.869892] divide error: 0000 [#1] PREEMPT SMP
> [  249.869915] Modules linked in: bcache libcrc32c lz4 lz4_decompress lz4_compress tun mousedev nouveau wmi fbcon video bitblit backlight softcursor font i2c_algo_bit ttm drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt coretemp hwmon kvm_intel kvm fb_sys_fops cfbcopyarea irqbypass drm agpgart fb fbdev snd_ens1371 psmouse snd_ac97_codec ac97_bus snd_rawmidi snd_pcm vboxnetadp(O) evdev e1000e snd_timer snd vboxnetflt(O) soundcore i2c_i801 i82975x_edac acpi_cpufreq 8250 edac_core lpc_ich mfd_core 8250_base processor ptp serial_core button pps_core vboxdrv(O) zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zlib_deflate zavl(PO) sr_mod cdrom sata_sil
> [  249.870107] CPU: 1 PID: 15016 Comm: mount Tainted: P           O    4.7.0-bcache+ #2
> [  249.870114] Hardware name:                  /D975XBX, BIOS BX97510J.86A.1487.2007.0902.1724 09/02/2007
> [  249.870122] task: ffff8800ba3b3680 ti: ffff8800924f4000 task.ti: ffff8800924f4000
> [  249.870129] RIP: 0010:[<ffffffffc092c755>]  [<ffffffffc092c755>] cache_alloc+0x735/0x9c0 [bcache]
> [  249.870186] RSP: 0018:ffff8800924f7c50  EFLAGS: 00010246
> [  249.870192] RAX: 000000000000000f RBX: ffff88009255b000 RCX: 0000000000000000
> [  249.870198] RDX: 0000000000000000 RSI: 00000000000063f1 RDI: 00000000000195a0
> [  249.870205] RBP: ffff8800924f7cc0 R08: ffff88014a001e00 R09: ffffffffc092c8de
> [  249.870211] R10: 0000000000000538 R11: 0000000000002105 R12: 0000000000005710
> [  249.870218] R13: ffff88008ca60000 R14: 0000000000000000 R15: 00000000000000ae
> [  249.870225] FS:  00007f26fb210780(0000) GS:ffff88014fc80000(0000) knlGS:0000000000000000
> [  249.870233] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  249.870239] CR2: 00007f31af9fe000 CR3: 000000008c95f000 CR4: 00000000000006e0
> [  249.870245] Stack:
> [  249.870250]  0000000000000008 ffff88009255b2e0 0000000000005710 0000010104000003
> [  249.870265]  ffff880001000001 ffffffffc092bff3 ff00010104000003 00000000232acf88
> [  249.870279]  0000ffffffffffff ffff88008ca60000 ffff88008c4aa300 0000000000000002
> [  249.870294] Call Trace:
> [  249.870315]  [<ffffffffc092bff3>] ? bch_cache_set_alloc+0xb43/0xb70 [bcache]
> [  249.870336]  [<ffffffffc092f408>] bch_register_cache_set+0x1f8/0x300 [bcache]
> [  249.870357]  [<ffffffffc0910eab>] bch_mount+0x1fb/0x4c0 [bcache]
> [  249.870367]  [<ffffffff8114d12a>] ? pcpu_alloc+0x37a/0x630
> [  249.870376]  [<ffffffff811937e3>] mount_fs+0x33/0x160
> [  249.870382]  [<ffffffff8114d400>] ? __alloc_percpu+0x10/0x20
> [  249.870390]  [<ffffffff811af572>] vfs_kern_mount+0x62/0x100
> [  249.870397]  [<ffffffff811b1bd7>] do_mount+0x247/0xda0
> [  249.870404]  [<ffffffff81180ab1>] ? __kmalloc_track_caller+0x1f1/0x240
> [  249.870413]  [<ffffffff811481ad>] ? memdup_user+0x3d/0x70
> [  249.870422]  [<ffffffff811b2a60>] SyS_mount+0x90/0xd0
> [  249.870430]  [<ffffffff8157031f>] entry_SYSCALL_64_fastpath+0x17/0x93
> [  249.870436] Code: f6 48 c7 83 f0 04 00 00 00 00 00 00 89 c1 31 d2 48 c7 83 e8 04 00 00 00 00 00 00 b8 0f 00 00 00 48 c7 83 08 05 00 00 00 00 00 00 <66> f7 f1 0f b7 c8 66 85 c0 48 89 8b f8 04 00 00 74 50 48 83 e9 
> [  249.870558] RIP  [<ffffffffc092c755>] cache_alloc+0x735/0x9c0 [bcache]
> [  249.870581]  RSP <ffff8800924f7c50>
> [  249.874185] ---[ end trace 1d062786d04c336e ]---


Btw, shouldn't all compression and encryption algo depend on CONFIG_BCACHE ?

Marcin
