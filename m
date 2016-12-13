From: "marcin@mejor.pl" <marcin@mejor.pl>
Subject: [bcachefs-testing] missing inode 6502 (nlink 1) (repair
 unimplemented)
Date: Tue, 13 Dec 2016 10:29:47 +0100
Message-ID: <850720fc-0d61-1f10-8e2a-39e644fb79e0@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:48342 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932909AbcLMJaE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Dec 2016 04:30:04 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi Kent, all!

Yesterday I was testing bcacefs mounted at /home on desktop. Next I
hibernated box. Today I resumed OS, upgraded kernel to:
commit ee9f55a7cd209a821f79c1092b5c53959ab1bc47
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Thu Dec 8 17:28:02 2016 -0900

    bcache: don't flush journal unnecessarily

commit 125312566ed797bc0c8b87ae9dbf694a68ddef33
Author: Kent Overstreet <kent.overstreet@gmail.com>
Date:   Mon Dec 12 12:53:56 2016 -0900

    bcache: short circuit bch_prio_write() and journal flush when possible


and next I rebooted. Now I can't mount /home because of error (it's not
problem, I've got backup). Error is:

> [  247.146141] ------------[ cut here ]------------
> [  247.146151] WARNING: CPU: 1 PID: 24880 at mm/page_alloc.c:3421 __alloc_pages_nodemask+0xa26/0xe20
> [  247.146154] Modules linked in: tun mousedev nvidia(PO) coretemp hwmon kvm_intel kvm drm snd_hda_codec_realtek snd_hda_codec_generic nvidiafb cfbfillrect cfbimgblt vgastate cfbcopyarea i2c_algo_bit irqbypass backlight i2c_i801 snd_hda_intel snd_hda_codec snd_hda_core evdev fb_ddc fb psmouse i2c_smbus snd_pcm snd_timer r8169 snd mii 8250 fbdev 8250_base soundcore serial_core intel_agp lpc_ich thermal intel_gtt agpgart mfd_core shpchp button acpi_cpufreq processor pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) zfs(PO) zunicode(PO) icp(PO) sr_mod cdrom pata_acpi zcommon(PO) znvpair(PO) spl(O) zavl(PO) pata_jmicron
> [  247.146232] CPU: 1 PID: 24880 Comm: mount Tainted: P           O    4.8.0-bcache+ #12
> [  247.146235] Hardware name: .   .  /IP35 Pro XE(Intel P35-ICH9R), BIOS 6.00 PG 09/09/2008
> [  247.146239]  0000000000000286 00000000b513f363 ffffa437cc053a60 ffffffffba2edabd
> [  247.146244]  0000000000000000 0000000000000000 ffffa437cc053aa0 ffffffffba05dd4b
> [  247.146250]  00000d5d00000001 00000000024040c0 0000000000000001 ffffa437f733b700
> [  247.146255] Call Trace:
> [  247.146267]  [<ffffffffba2edabd>] dump_stack+0x4f/0x72
> [  247.146271]  [<ffffffffba05dd4b>] __warn+0xcb/0xf0
> [  247.146274]  [<ffffffffba05de7d>] warn_slowpath_null+0x1d/0x20
> [  247.146276]  [<ffffffffba14a036>] __alloc_pages_nodemask+0xa26/0xe20
> [  247.146279]  [<ffffffffba14977d>] ? __alloc_pages_nodemask+0x16d/0xe20
> [  247.146285]  [<ffffffffba167851>] kmalloc_order+0x21/0x50
> [  247.146287]  [<ffffffffba1678a4>] kmalloc_order_trace+0x24/0xc0
> [  247.146294]  [<ffffffffba19813a>] ? __kmalloc+0x1aa/0x210
> [  247.146296]  [<ffffffffba19813a>] __kmalloc+0x1aa/0x210
> [  247.146302]  [<ffffffffba4aaaf2>] cache_alloc+0x582/0x970
> [  247.146304]  [<ffffffffba4aa548>] ? bch_cache_set_alloc+0xab8/0xae0
> [  247.146307]  [<ffffffffba4ade0b>] bch_register_cache_set+0x1eb/0x2e0
> [  247.146310]  [<ffffffffba19818b>] ? __kmalloc+0x1fb/0x210
> [  247.146314]  [<ffffffffba48fac0>] ? bch_mount+0x110/0x4e0
> [  247.146316]  [<ffffffffba48fb28>] bch_mount+0x178/0x4e0
> [  247.146321]  [<ffffffffba1b0958>] mount_fs+0x38/0x160
> [  247.146325]  [<ffffffffba1cd8b7>] vfs_kern_mount+0x67/0x110
> [  247.146327]  [<ffffffffba1d0089>] do_mount+0x1e9/0xce0
> [  247.146331]  [<ffffffffba1a8934>] ? __check_object_size+0x114/0x1ee
> [  247.146333]  [<ffffffffba1d0eb5>] SyS_mount+0x95/0xe0
> [  247.146337]  [<ffffffffba60df9f>] entry_SYSCALL_64_fastpath+0x17/0x93
> [  247.146339] ---[ end trace e5c566378243fe0d ]---
> [  250.726487] bcache (sde): starting mark and sweep:
> [  252.255575] bcache (sde): mark and sweep done
> [  252.255676] bcache (sde): starting journal replay:
> [  252.255974] bcache (sde): journal replay done, 27 keys in 1 entries, seq 100001
> [  252.255975] bcache (sde): journal replay done
> [  252.256456] bcache (sde): starting fs gc:
> [  252.266239] bcache (sde): missing inode 6502 (nlink 1) (repair unimplemented)
> [  252.266283] bcache (sde): filesystem contains errors: please report this to the developers
> [  252.266284] repair unimplemented: inform the developers so that it can be added
> [  252.266337] bcache: bch_open_as_blockdevs() register_cache_set err error in fs gc
> [  252.372030] bcache (sde): stopped
> [  282.611097] bcache (sde): starting mark and sweep:
> [  284.173268] bcache (sde): mark and sweep done
> [  284.173354] bcache (sde): starting journal replay:
> [  284.173670] bcache (sde): journal replay done, 27 keys in 1 entries, seq 100001
> [  284.173673] bcache (sde): journal replay done
> [  284.174010] bcache (sde): starting fs gc:
> [  284.183664] bcache (sde): missing inode 6502 (nlink 1) (repair unimplemented)
> [  284.183701] bcache (sde): filesystem contains errors: please report this to the developers
> [  284.183703] repair unimplemented: inform the developers so that it can be added
> [  284.252080] bcache: bch_open_as_blockdevs() register_cache_set err error in fs gc
> [  284.284043] bcache (sde): stopped



So I'm droping information to the developers:)

Marcin
