From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Subject: Comm: bcache_allocato BUG: unable to handle kernel NULL pointer
 dereference at 00000000000006bc
Date: Sat, 14 Oct 2017 13:14:44 +0200
Message-ID: <CAGmahrSoEjp5Qh4P9OLk-x7W73F3FNbwc7x2wpChHq_Y_SSj=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:54998 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbdJNLOq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 14 Oct 2017 07:14:46 -0400
Received: by mail-qk0-f178.google.com with SMTP id n5so7824024qke.11
        for <linux-bcache@vger.kernel.org>; Sat, 14 Oct 2017 04:14:45 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

This is on 4.13.5. Happens sometime at boot, I just reboot and it
works fine. No other problems.

  40.391116] BUG: unable to handle kernel NULL pointer dereference at
00000000000006bc
   40.391663] IP: _raw_spin_lock_irqsave+0x12/0x30
   40.392152] PGD 0
   40.392153] P4D 0
   40.392658]
   40.393070] bcache: bch_journal_replay() journal replay done, 21
keys in 10 entries, seq 34810
   40.393427] bcache: register_cache() registered cache device sdc4
   40.394669] Oops: 0002 [#1] PREEMPT SMP
   40.395174] Modules linked in: tun(+) vhost tap kvm md_mod bcache
intel_cstate snd_hda_codec_realtek intel_uncore snd_hda_codec_generic
efi_pstore snd_hda_codec_hdmi intel_rapl_perf snd_hda_intel
snd_hda_codec efivars snd_hwdep snd_hda_core mei_me input_leds mei
led_class snd_pcm tpm_crb efivarfs algif_skcipher af_alg psmouse atkbd
libps2 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcspkr shpchp
fan thermal battery i8042 tpm_tis tpm_tis_core tpm acpi_pad vfio_pci
irqbypass vfio_virqfd vfio_iommu_type1 vfio
   40.396917] CPU: 2 PID: 501 Comm: bcache_allocato Not tainted 4.13.5-5-ph #1
   40.397507] Hardware name: Gigabyte Technology Co., Ltd.
Z170X-UD3/Z170X-UD3-CF, BIOS F22 03/06/2017
   40.398095] task: ffff9efb793e5100 task.stack: ffffb546410d8000
   40.398687] RIP: 0010:_raw_spin_lock_irqsave+0x12/0x30
   40.399280] RSP: 0018:ffffb546410dbd60 EFLAGS: 00010046
   40.399883] R10: ffffb5464114d000 R11: ffff9efb74fe27f8 R12: ffff9efb7b69a028
   40.399883] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000000
   40.399883] RBP: 00000000000006bc R08: ffffffffc0474800 R09: 000000000000000c
   40.399883] RDX: 0000000000000001 RSI: 0000000000000003 RDI: 00000000000006bc
   40.399884] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   40.399884] FS:  0000000000000000(0000) GS:ffff9efb8ed00000(0000)
knlGS:0000000000000000
   40.399884] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
   40.399885] CR2: 00000000000006bc CR3: 0000000435928000 CR4: 00000000003406e0
   40.399885] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   40.399885] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   40.399886] Call Trace:
   40.399888]  ? try_to_wake_up+0x39/0x350
   40.399891]  ? bch_bucket_alloc+0x9a/0x280 [bcache]
   40.399892]  ? wait_woken+0x80/0x80
   40.399893]  ? bch_prio_write+0x189/0x330 [bcache]
   40.399895]  ? bch_allocator_thread+0x57b/0xc90 [bcache]
   40.399896]  ? __schedule+0x18e/0x5d0
   40.399897]  ? bch_invalidate_one_bucket+0x70/0x70 [bcache]
   40.399898]  ? kthread+0x10e/0x130
   40.399899]  ? kthread_create_on_node+0x60/0x60
   40.399900]  ? ret_from_fork+0x22/0x30
   40.399900] Code: f5 27 87 64 74 02 f3 c3 e8 08 75 86 ff c3 90 66 2e
0f 1f 84 00 00 00 00 00 53 9c 5b fa 65 ff 05 d5 27 87 64 31 c0 ba 01
00 00 00 <f0> 0f b1 17 85 c0 75 05 48 89 d8 5b c3 89 c6 e8 2a 82 90 ff
48
   40.399909] CR2: 00000000000006bc
   40.399909] RIP: _raw_spin_lock_irqsave+0x12/0x30 RSP: ffffb546410dbd60
   40.399911] ---[ end trace 3b309679f786fde8 ]---
