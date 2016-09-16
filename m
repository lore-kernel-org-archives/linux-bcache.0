From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Fri, 16 Sep 2016 14:27:11 +0200
Message-ID: <6c126ac9-d88c-680e-c51c-09159485f569@mejor.pl>
References: <20160916083853.5syjxgpb4f73bmtt@kmo-pixel>
 <17792e18-4315-0e12-bc5a-96d1cb3e10d5@mejor.pl>
 <20160916091627.nmu2syyabwcohhh3@kmo-pixel>
 <4ce5eedb-8e38-ef94-e01e-b46f9ce8c4d4@mejor.pl>
 <20160916112436.fbvvirrjc6zkmorw@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:65056 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754107AbcIPM1l (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 08:27:41 -0400
In-Reply-To: <20160916112436.fbvvirrjc6zkmorw@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 16.09.2016 o 13:24, Kent Overstreet pisze:
> addr2line -i -e vmlinux ffffffffc095b021

# addr2line -i -e vmlinux ffffffffc095b021
??:0

bcache is compiled as a module at this host:(
I recompiled kernel and build bcache inside kernel. I'm getting now much
more:

> [  172.035755] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff814883d1                                                                       [24/212]
> [  172.035755] 
> [  172.035789] CPU: 1 PID: 3949 Comm: rsync Tainted: P           O    4.7.0-bcache+ #3
> [  172.035804] Hardware name: .   .  /IP35 Pro XE(Intel P35-ICH9R), BIOS 6.00 PG 09/09/2008
> [  172.035814]  0000000000000086 0000000058043aa7 ffff8800bd39bae0 ffffffff812cbe2d
> [  172.035837]  ffffffff8178a260 ffff8800bd39bb78 ffff8800bd39bb68 ffffffff81128a91
> [  172.035861]  ffff880000000010 ffff8800bd39bb78 ffff8800bd39bb10 0000000058043aa7
> [  172.035883] Call Trace:
> [  172.035895]  [<ffffffff812cbe2d>] dump_stack+0x4f/0x72
> [  172.035905]  [<ffffffff81128a91>] panic+0xd3/0x219
> [  172.035914]  [<ffffffff812942a4>] ? sha1_final+0x94/0x110
> [  172.035924]  [<ffffffff814883d1>] ? bch_xattr_hash+0x2b1/0x2d0
> [  172.035934]  [<ffffffff81058f24>] __stack_chk_fail+0x14/0x30
> [  172.035942]  [<ffffffff814883d1>] bch_xattr_hash+0x2b1/0x2d0
> [  172.035950]  [<ffffffff81488459>] xattr_hash_key+0x9/0x10
> [  172.035960]  [<ffffffff814884e4>] ? bch_xattr_get+0x84/0x1a0
> [  172.035969]  [<ffffffff8145cd69>] ? __bch_write_inode+0x289/0x2d0
> [  172.035978]  [<ffffffff81435438>] ? bch_get_acl+0x48/0x2b0
> [  172.035988]  [<ffffffff811ee9c1>] ? get_acl+0x71/0xf0
> [  172.035996]  [<ffffffff811eea8a>] ? posix_acl_chmod+0x4a/0xe0
> [  172.036005]  [<ffffffff8145d13f>] ? bch_setattr+0x7f/0xa0
> [  172.036015]  [<ffffffff811ac98e>] ? notify_change+0x23e/0x350
> [  172.036024]  [<ffffffff8118c6a9>] ? chmod_common+0x89/0x140
> [  172.036033]  [<ffffffff8118d991>] ? SyS_fchmod+0x31/0x50
> [  172.036042]  [<ffffffff815d0c1f>] ? entry_SYSCALL_64_fastpath+0x17/0x93
> [  172.036062] Kernel Offset: disabled
> [  172.036071] ---[ end Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff814883d1
> [  172.036071]
> [  172.036088] ------------[ cut here ]------------
> [  172.036114] WARNING: CPU: 1 PID: 3949 at arch/x86/kernel/smp.c:125 native_smp_send_reschedule+0x39/0x40
> [  172.037526] Modules linked in: netconsole configfs tun dm_snapshot dm_bufio mousedev pci_stub nouveau vboxpci(O) vboxnetadp(O) vboxnetflt(O) fbcon bitblit wmi softcursor font video t
> tm drm_kms_helper syscopyarea sysfillrect sysimgblt vboxdrv(O) fb_sys_fops drm nvidiafb cfbfillrect cfbimgblt vgastate cfbcopyarea i2c_algo_bit backlight fb_ddc fb coretemp hwmon fbdev 
> snd_hda_codec_realtek snd_hda_codec_generic kvm_intel kvm snd_hda_intel snd_hda_codec irqbypass psmouse snd_hda_core snd_pcm evdev r8169 i2c_i801 snd_timer intel_agp mii acpi_cpufreq in
> tel_gtt 8250 snd thermal agpgart soundcore processor 8250_base shpchp serial_core lpc_ich button mfd_core zfs(PO) zunicode(PO) sr_mod cdrom pata_acpi zcommon(PO) znvpair(PO) spl(O) zavl
> (PO) pata_jmicron
> [  172.040086] CPU: 1 PID: 3949 Comm: rsync Tainted: P           O    4.7.0-bcache+ #3
> [  172.040086] Hardware name: .   .  /IP35 Pro XE(Intel P35-ICH9R), BIOS 6.00 PG 09/09/2008
> [  172.040086]  0000000000000086 0000000058043aa7 ffff88014fc83da0 ffffffff812cbe2d
> [  172.040086]  0000000000000000 0000000000000000 ffff88014fc83de0 ffffffff810591d6
> [  172.040086]  0000007d4fc96200 0000000000000000 0000000000000001 000000000000c888
> [  172.040086] Call Trace:
> [  172.040086]  <IRQ>  [<ffffffff812cbe2d>] dump_stack+0x4f/0x72
> [  172.040086]  [<ffffffff810591d6>] __warn+0xc6/0xe0
> [  172.040086]  [<ffffffff810592f8>] warn_slowpath_null+0x18/0x20
> [  172.040086]  [<ffffffff81039f19>] native_smp_send_reschedule+0x39/0x40
> [  172.040086]  [<ffffffff81092ed1>] trigger_load_balance+0x131/0x210
> [  172.040086]  [<ffffffff81083959>] scheduler_tick+0x99/0xd0
> [  172.040086]  [<ffffffff810d05c0>] ? tick_sched_handle.isra.12+0x60/0x60
> [  172.040086]  [<ffffffff810c137c>] update_process_times+0x4c/0x60
> [  172.040086]  [<ffffffff810d0580>] tick_sched_handle.isra.12+0x20/0x60
> [  172.040086]  [<ffffffff810d05f8>] tick_sched_timer+0x38/0x70
> [  172.040086]  [<ffffffff810c1bf0>] __hrtimer_run_queues+0xb0/0x2c0
> [  172.040086]  [<ffffffff810c2467>] hrtimer_interrupt+0xa7/0x1a0
> [  172.040086]  [<ffffffff8103bee1>] local_apic_timer_interrupt+0x31/0x50
> [  172.040086]  [<ffffffff8103c8e8>] smp_apic_timer_interrupt+0x38/0x50
> [  172.040086]  [<ffffffff815d180f>] apic_timer_interrupt+0x7f/0x90
> [  172.040086]  <EOI>  [<ffffffff81128b99>] ? panic+0x1db/0x219
> [  172.040086]  [<ffffffff812942a4>] ? sha1_final+0x94/0x110
> [  172.040086]  [<ffffffff814883d1>] ? bch_xattr_hash+0x2b1/0x2d0
> [  172.040086]  [<ffffffff81058f24>] __stack_chk_fail+0x14/0x30
> [  172.040086]  [<ffffffff814883d1>] bch_xattr_hash+0x2b1/0x2d0
> [  172.040086]  [<ffffffff81488459>] xattr_hash_key+0x9/0x10
> [  172.040086]  [<ffffffff814884e4>] ? bch_xattr_get+0x84/0x1a0
> [  172.040086]  [<ffffffff8145cd69>] ? __bch_write_inode+0x289/0x2d0
> [  172.040086]  [<ffffffff81435438>] ? bch_get_acl+0x48/0x2b0
> [  172.040086]  [<ffffffff811ee9c1>] ? get_acl+0x71/0xf0
> [  172.040086]  [<ffffffff811eea8a>] ? posix_acl_chmod+0x4a/0xe0
> [  172.040086]  [<ffffffff8145d13f>] ? bch_setattr+0x7f/0xa0
> [  172.040086]  [<ffffffff811ac98e>] ? notify_change+0x23e/0x350
> [  172.040086]  [<ffffffff8118c6a9>] ? chmod_common+0x89/0x140
> [  172.040086]  [<ffffffff8118d991>] ? SyS_fchmod+0x31/0x50
> [  172.040086]  [<ffffffff815d0c1f>] ? entry_SYSCALL_64_fastpath+0x17/0x93
> [  172.040086] ---[ end trace eaafefe4328420aa ]---

And the winner is...:
# addr2line -i -e vmlinux ffffffff814883d1
/usr/src/linux-bcache/drivers/md/bcache/xattr.c:33

_Current_ options are:
# cat /sys/fs/bcache/1005562c-b899-4a27-bfe5-e7d9e89d4bf2/options/*
none lz4 [gzip]
none crc32c [crc64]
1
continue [remount-ro] panic
10
0
0
none crc32c [crc64]
1
0
0
0
crc32c crc64 siphash [sha1]
0


Marcin
