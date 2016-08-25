From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: [bcachefs][tier] kernel BUG at drivers/md/bcache/super.c:1561! after
 double changing state of device
Date: Thu, 25 Aug 2016 12:59:19 +0200
Message-ID: <d29af387-c549-345d-974a-ee21047978ad@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:39915 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757802AbcHYK7w (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 06:59:52 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!

I did:
# echo readonly > /sys/<...>/cache0/state

try to write but filesystem was readonly. Next I did:
# echo active > /sys/<...>/cache0/state

And I got:
[ 1417.679079] bcache (181708b5-8f1d-4533-bad9-c3ebfea4db0c): required
member dm-10 going RO, forcing fs RO
[ 1417.764650] bcache (181708b5-8f1d-4533-bad9-c3ebfea4db0c): dm-10 read
only
[ 1504.428743] ------------[ cut here ]------------
[ 1504.428769] kernel BUG at drivers/md/bcache/super.c:1561!
[ 1504.428777] invalid opcode: 0000 [#1] PREEMPT SMP
[ 1504.428783] Modules linked in: bcache libcrc32c tun mousedev nouveau
wmi video fbcon bitblit softcursor font backlight vboxnetadp(O)
i2c_algo_bit ttm drm_kms_helper cfbfillrect vboxnetflt(O) syscopyarea
cfbimgblt sysfillrect vboxdrv(O) sysimgblt fb_sys_fops snd_ens1371
snd_ac97_codec cfbcopyarea coretemp drm ac97_bus agpgart hwmon
snd_rawmidi snd_pcm fb kvm_intel kvm snd_timer fbdev irqbypass e1000e
psmouse snd soundcore evdev i2c_i801 ptp i82975x_edac acpi_cpufreq
edac_core pps_core lpc_ich mfd_core 8250 processor 8250_base button
serial_core zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) spl(O) zavl(PO)
zlib_deflate sr_mod cdrom sata_sil
[ 1504.428957] CPU: 0 PID: 31355 Comm: bash Tainted: P           O
4.7.0-bcache+ #5
[ 1504.428964] Hardware name:                  /D975XBX, BIOS
BX97510J.86A.1487.2007.0902.1724 09/02/2007
[ 1504.428972] task: ffff8800a09e8000 ti: ffff880016784000 task.ti:
ffff880016784000
[ 1504.428979] RIP: 0010:[<ffffffffc0952f63>]  [<ffffffffc0952f63>]
__bch_cache_read_write+0xe3/0xf0 [bcache]
[ 1504.429026] RSP: 0018:ffff880016787d30  EFLAGS: 00010202
[ 1504.429031] RAX: ffffffffc09706b0 RBX: ffff8800c820d000 RCX:
0000000000000000
[ 1504.429038] RDX: 0000000000000000 RSI: 0000000000000246 RDI:
ffff8800c820d000
[ 1504.429044] RBP: ffff880016787d48 R08: ffff88014fc80000 R09:
00000000000003ea
[ 1504.429050] R10: 00000000000003fa R11: 0000000000000000 R12:
ffff88008bc80000
[ 1504.429056] R13: ffff8800c820d2e0 R14: ffff8800c785ac50 R15:
ffff88008bc80000
[ 1504.429063] FS:  00007f7b45c31700(0000) GS:ffff88014fc00000(0000)
knlGS:0000000000000000
[ 1504.429070] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1504.429076] CR2: 0000000000547bc0 CR3: 00000000cf167000 CR4:
00000000000006f0
[ 1504.429082] Stack:
[ 1504.429086]  ffffffffc0957831 ffffffffc0973ec0 0000000000000007
ffff880016787db8
[ 1504.429099]  ffffffffc095a96d ffff8800c820d000 ffff880016787d01
0000000000000002
[ 1504.429110]  ffff8800cfb79300 ffff88014a0a4aa0 ffff880149c51240
000000008ea8ec62
[ 1504.429123] Call Trace:
[ 1504.429142]  [<ffffffffc0957831>] ? bch_cache_read_write+0x51/0xa0
[bcache]
[ 1504.429163]  [<ffffffffc095a96d>] __bch_cache_store+0x5ad/0x650 [bcache]
[ 1504.429183]  [<ffffffffc095aa44>] bch_cache_store+0x34/0x50 [bcache]
[ 1504.429192]  [<ffffffff81206272>] sysfs_kf_write+0x32/0x40
[ 1504.429199]  [<ffffffff812057f3>] kernfs_fop_write+0x113/0x190
[ 1504.429207]  [<ffffffff8118e5c2>] __vfs_write+0x32/0x150
[ 1504.429215]  [<ffffffff812e8a33>] ? __this_cpu_preempt_check+0x13/0x20
[ 1504.429223]  [<ffffffff8109f201>] ? update_fast_ctr+0x41/0x70
[ 1504.429230]  [<ffffffff8109f262>] ? percpu_down_read+0x12/0x50
[ 1504.429236]  [<ffffffff8118f8c3>] vfs_write+0xb3/0x1b0
[ 1504.429243]  [<ffffffff81190ce0>] SyS_write+0x50/0xc0
[ 1504.429249]  [<ffffffff811adbde>] ? __close_fd+0x9e/0xc0
[ 1504.429257]  [<ffffffff8157431f>] entry_SYSCALL_64_fastpath+0x17/0x93
[ 1504.429262] Code: 8b 03 48 85 c0 75 eb 65 ff 0d 4a 94 6b 3f 74 05 e9
4f ff ff ff e8 c6 f0 6a c0 e9 45 ff ff ff e8 bc f0 6a c0 31 c0 5b 41 5c
5d c3 <0f> 0b 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 8b 87 90 00 00 00
[ 1504.429372] RIP  [<ffffffffc0952f63>]
__bch_cache_read_write+0xe3/0xf0 [bcache]
[ 1504.429394]  RSP <ffff880016787d30>
[ 1504.432174] ---[ end trace 88c06790c8a7571e ]---
