From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: [bcachefs][branch:bcache-dev] BUG: unable to handle kernel paging
 request at
Date: Fri, 10 Mar 2017 11:40:03 +0100
Message-ID: <6a235744-9f0d-2a9c-b7ea-c0f7d732b238@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:29250 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934813AbdCJKlE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Mar 2017 05:41:04 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi!
commit e990d9cc

command:
mount -t bcache -o verbose_fsck /dev/system10/bcache /mnt/test

gives:
[ 1605.127883] BUG: unable to handle kernel paging request at 0000002783864228
[ 1605.127909] IP: [<ffffffff8349fcbd>] bch_parse_mount_opts+0x8d/0xb0
[ 1605.127921] PGD 138230067 
[ 1605.127925] PUD 0 

[ 1605.127935] Oops: 0000 [#1] PREEMPT SMP
[ 1605.127940] Modules linked in: tun zfs(PO) zunicode(PO) zavl(PO) icp(PO) zcommon(PO) znvpair(PO) spl(O) mousedev nouveau wmi video fbcon bitblit softcursor backlight i2c_algo_bit font ttm drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect coretemp hwmon kvm_intel snd_hda_codec_realtek snd_hda_codec_generic kvm sysimgblt fb_sys_fops cfbcopyarea drm snd_hda_intel snd_hda_codec irqbypass fb r8169 snd_hda_core snd_pcm fbdev psmouse evdev i2c_i801 i2c_smbus mii intel_agp snd_timer lpc_ich intel_gtt snd soundcore 8250 8250_base mfd_core serial_core agpgart shpchp thermal button acpi_cpufreq processor pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) sr_mod cdrom pata_acpi pata_jmicron
[ 1605.128134] CPU: 1 PID: 16520 Comm: mount Tainted: P           O    4.9.0-bcache+ #10
[ 1605.128141] Hardware name: .   .  /IP35 Pro XE(Intel P35-ICH9R), BIOS 6.00 PG 09/09/2008
[ 1605.128150] task: ffff925a26301b80 task.stack: ffff925a0cdd8000
[ 1605.128155] RIP: 0010:[<ffffffff8349fcbd>]  [<ffffffff8349fcbd>] bch_parse_mount_opts+0x8d/0xb0
[ 1605.128165] RSP: 0018:ffff925a0cddbd18  EFLAGS: 00010246
[ 1605.128171] RAX: 00000004fffffffb RBX: 00000000ffffffff RCX: 0000000000000000
[ 1605.128177] RDX: 0000000000000000 RSI: ffffffff839cbcc9 RDI: ffff9259c2695001
[ 1605.128183] RBP: ffff925a0cddbd48 R08: 0000000000000000 R09: ffff9259c269500c
[ 1605.128189] R10: 000000000000003d R11: 0000000000000000 R12: 0000000000000000
[ 1605.128195] R13: ffff925a0cddbda0 R14: ffff925a19696000 R15: 0000000000000000
[ 1605.128201] FS:  00007ff0d5908780(0000) GS:ffff925a4fc80000(0000) knlGS:0000000000000000
[ 1605.128208] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1605.128213] CR2: 0000002783864228 CR3: 0000000112bd9000 CR4: 00000000000006e0
[ 1605.128219] Stack:
[ 1605.128223]  0000000000000000 0000000000000000 0000000000000001 ffff925a393c5c80
[ 1605.128236]  ffff925a4941fe00 0000000000000000 ffff925a0cddbe08 ffffffff83487c9a
[ 1605.128248]  00000000024080c0 ffff925a0cddbde8 ffffffff83150c70 ffff925a26301b80
[ 1605.128261] Call Trace:
[ 1605.128268]  [<ffffffff83487c9a>] bch_mount+0x7a/0x530
[ 1605.128275]  [<ffffffff83150c70>] ? __alloc_pages_nodemask+0x120/0x2d0
[ 1605.128284]  [<ffffffff831b3d68>] mount_fs+0x38/0x160
[ 1605.128291]  [<ffffffff831d0717>] vfs_kern_mount+0x67/0x110
[ 1605.128298]  [<ffffffff831d2f12>] do_mount+0x1c2/0xcb0
[ 1605.128304]  [<ffffffff831d3d35>] SyS_mount+0x95/0xe0
[ 1605.128311]  [<ffffffff836066a4>] entry_SYSCALL_64_fastpath+0x17/0x98
[ 1605.128317] Code: 86 54 9a 83 e8 15 43 e5 ff 4c 8b 65 d8 48 89 c7 4d 85 e4 75 a4 e8 f4 fc ff ff 48 c7 45 e0 01 00 00 00 89 c0 48 89 c3 48 8d 04 80 <8b> 04 c5 50 42 86 83 85 c0 75 07 ba 01 00 00 00 eb 99 b8 ea ff 
[ 1605.128435] RIP  [<ffffffff8349fcbd>] bch_parse_mount_opts+0x8d/0xb0
[ 1605.128443]  RSP <ffff925a0cddbd18>
[ 1605.128448] CR2: 0000002783864228
[ 1605.131243] ---[ end trace e5436835e496393b ]---


Marcin
