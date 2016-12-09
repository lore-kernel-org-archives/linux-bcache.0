From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs-testing] BUG: unable to handle kernel paging request
 at 0000005780540006
Date: Fri, 9 Dec 2016 09:51:57 -0900
Message-ID: <20161209185157.lyvllwqefj5w4pg4@kmo-pixel>
References: <b66c17f1-19d0-702f-f09e-acd6e5116587@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33184 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbcLISwC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Dec 2016 13:52:02 -0500
Received: by mail-pf0-f196.google.com with SMTP id 144so1538127pfv.0
        for <linux-bcache@vger.kernel.org>; Fri, 09 Dec 2016 10:52:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <b66c17f1-19d0-702f-f09e-acd6e5116587@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "marcin@mejor.pl" <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Dec 09, 2016 at 11:08:05AM +0100, marcin@mejor.pl wrote:
> Hi all!
> 
> Kernel at:
> commit a3cccb56d861c0092be2b58cbaf7b44e298f59bc
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Thu Dec 8 14:41:14 2016 -0900
> 
>     bcache: increase default journal write delay for spinning rust
> 
> 
> Today I tried to use bcachefs as /home. After sometime, when I do backup
> of /home I got:
> 
> > Dec  9 10:44:09 localhost kernel: [ 3517.194588] BUG: unable to handle kernel paging request at 0000005780540006
> > Dec  9 10:44:09 localhost kernel: [ 3517.194602] IP: [<ffffffff85493fa5>] page_is_data+0x5/0x50
> > Dec  9 10:44:09 localhost kernel: [ 3517.194615] PGD 124492067 PUD 0 
> > Dec  9 10:44:09 localhost kernel: [ 3517.194620] Oops: 0000 [#1] PREEMPT SMP
> > Dec  9 10:44:09 localhost kernel: [ 3517.194624] Modules linked in: tun mousedev nvidia(PO) coretemp hwmon drm kvm_intel nvidiafb cfbfillrect cfbimgblt vgastate snd_hda_codec_realtek snd_hda_codec_generic kv
> > m i2c_i801 cfbcopyarea i2c_algo_bit backlight fb_ddc irqbypass snd_hda_intel snd_hda_codec i2c_smbus psmouse evdev snd_hda_core snd_pcm fb r8169 snd_timer fbdev snd mii intel_agp thermal lpc_ich intel_gtt mf
> > d_core soundcore agpgart 8250 8250_base serial_core shpchp button acpi_cpufreq processor pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) zfs(PO) zunicode(PO) icp(PO) sr_mod cdrom pata_acpi zcommon
> > (PO) znvpair(PO) spl(O) zavl(PO) pata_jmicron
> > Dec  9 10:44:09 localhost kernel: [ 3517.194681] CPU: 2 PID: 20385 Comm: hb Tainted: P        W  O    4.8.0-bcache+ #10
> > Dec  9 10:44:09 localhost kernel: [ 3517.194683] Hardware name: .   .  /IP35 Pro XE(Intel P35-ICH9R), BIOS 6.00 PG 09/09/2008
> > Dec  9 10:44:09 localhost kernel: [ 3517.194685] task: ffffa23cee8b8000 task.stack: ffffa23cd59d4000
> > Dec  9 10:44:09 localhost kernel: [ 3517.194687] RIP: 0010:[<ffffffff85493fa5>]  [<ffffffff85493fa5>] page_is_data+0x5/0x50
> > Dec  9 10:44:09 localhost kernel: [ 3517.194692] RSP: 0018:ffffa23cd59d7d88  EFLAGS: 00010206
> > Dec  9 10:44:09 localhost kernel: [ 3517.194694] RAX: 0000005780540006 RBX: 000000000000005d RCX: 0000000000000002
> > Dec  9 10:44:09 localhost kernel: [ 3517.194696] RDX: 0000000000000000 RSI: ffffa23c68045a28 RDI: 0000005780540006
> > Dec  9 10:44:09 localhost kernel: [ 3517.194698] RBP: ffffa23cd59d7dc0 R08: 0000005780540006 R09: ffffa23c68045918
> > Dec  9 10:44:09 localhost kernel: [ 3517.194700] R10: ffffa23cd59d7d20 R11: 0000000000000040 R12: 0000005780540006
> > Dec  9 10:44:09 localhost kernel: [ 3517.194702] R13: 000002000005ce00 R14: 000000000005d000 R15: ffffa23bc75d8d00
> > Dec  9 10:44:09 localhost kernel: [ 3517.194704] FS:  00007f395c69b700(0000) GS:ffffa23d0fd00000(0000) knlGS:0000000000000000
> > Dec  9 10:44:09 localhost kernel: [ 3517.194706] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Dec  9 10:44:09 localhost kernel: [ 3517.194708] CR2: 0000005780540006 CR3: 0000000115407000 CR4: 00000000000006e0
> > Dec  9 10:44:09 localhost kernel: [ 3517.194710] Stack:
> > Dec  9 10:44:09 localhost kernel: [ 3517.194712]  ffffffff854942c1 ffffa23c863f57f8 000000000005c000 ffffa23c863f5680
> > Dec  9 10:44:09 localhost kernel: [ 3517.194716]  7fffffffffffffff ffffa23cd59d7ea8 ffffa23bc75d8d00 ffffa23cd59d7f00
> > Dec  9 10:44:09 localhost kernel: [ 3517.194720]  ffffffff854943f2 0000000000000000 000280f100000000 0000000000000000
> > Dec  9 10:44:09 localhost kernel: [ 3517.194724] Call Trace:
> > Dec  9 10:44:09 localhost kernel: [ 3517.194728]  [<ffffffff854942c1>] ? bch_next_pagecache_hole.isra.47+0x61/0xb0
> > Dec  9 10:44:09 localhost kernel: [ 3517.194733]  [<ffffffff854943f2>] bch_seek_hole+0xe2/0x1c0
> > Dec  9 10:44:09 localhost kernel: [ 3517.194739]  [<ffffffff851ce14c>] ? mntput_no_expire+0x2c/0x190
> > Dec  9 10:44:09 localhost kernel: [ 3517.194742]  [<ffffffff8549765a>] bch_llseek+0x1a/0x40
> > Dec  9 10:44:09 localhost kernel: [ 3517.194746]  [<ffffffff851ac1aa>] SyS_lseek+0x8a/0xb0
> > Dec  9 10:44:09 localhost kernel: [ 3517.194749]  [<ffffffff8560df9f>] entry_SYSCALL_64_fastpath+0x17/0x93
> > Dec  9 10:44:09 localhost kernel: [ 3517.194751] Code: c4 18 5b 41 5c 5d c3 f0 80 4e 01 08 e9 76 ff ff ff 31 c0 eb da 80 7b 31 08 74 d4 0f 0b e8 c4 9a bc ff 0f 1f 40 00 66 66 66 66 90 <48> 8b 17 55 31 c0 48 
> > 89 e5 80 e6 08 74 22 48 8b 07 f6 c4 08 74 
> > Dec  9 10:44:09 localhost kernel: [ 3517.194805] RIP  [<ffffffff85493fa5>] page_is_data+0x5/0x50
> > Dec  9 10:44:09 localhost kernel: [ 3517.194809]  RSP <ffffa23cd59d7d88>
> > Dec  9 10:44:09 localhost kernel: [ 3517.194811] CR2: 0000005780540006
> > Dec  9 10:44:09 localhost kernel: [ 3517.194815] ---[ end trace fde98349eb2cf765 ]---
> 
> 
> 
> # addr2line -i -e vmlinux ffffffff85493fa5
> ??:0

Did you have compression enabled?
