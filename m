From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Subject: Re: Comm: bcache_allocato BUG: unable to handle kernel NULL pointer
 dereference at 00000000000006bc
Date: Sat, 14 Oct 2017 14:04:25 +0200
Message-ID: <CAGmahrQ=UhHOpwcRXgWqgyb6aWFt3FGn0vip630JSCq8cMH0CA@mail.gmail.com>
References: <CAGmahrSoEjp5Qh4P9OLk-x7W73F3FNbwc7x2wpChHq_Y_SSj=g@mail.gmail.com>
 <c1470bb5-413c-2cc9-0560-b90a3b577c99@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:49530 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753610AbdJNME0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 14 Oct 2017 08:04:26 -0400
Received: by mail-qt0-f196.google.com with SMTP id k31so23993298qta.6
        for <linux-bcache@vger.kernel.org>; Sat, 14 Oct 2017 05:04:26 -0700 (PDT)
In-Reply-To: <c1470bb5-413c-2cc9-0560-b90a3b577c99@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org

Yes. bcache-tools ships some udev rules associated helper utils that
are used here.

On 14 October 2017 at 13:42, Coly Li <i@coly.li> wrote:
> On 2017/10/14 =E4=B8=8B=E5=8D=887:14, Sverd Johnsen wrote:
>> This is on 4.13.5. Happens sometime at boot, I just reboot and it
>> works fine. No other problems.
>>
>>   40.391116] BUG: unable to handle kernel NULL pointer dereference at
>> 00000000000006bc
>>    40.391663] IP: _raw_spin_lock_irqsave+0x12/0x30
>>    40.392152] PGD 0
>>    40.392153] P4D 0
>>    40.392658]
>>    40.393070] bcache: bch_journal_replay() journal replay done, 21
>> keys in 10 entries, seq 34810
>>    40.393427] bcache: register_cache() registered cache device sdc4
>>    40.394669] Oops: 0002 [#1] PREEMPT SMP
>>    40.395174] Modules linked in: tun(+) vhost tap kvm md_mod bcache
>> intel_cstate snd_hda_codec_realtek intel_uncore snd_hda_codec_generic
>> efi_pstore snd_hda_codec_hdmi intel_rapl_perf snd_hda_intel
>> snd_hda_codec efivars snd_hwdep snd_hda_core mei_me input_leds mei
>> led_class snd_pcm tpm_crb efivarfs algif_skcipher af_alg psmouse atkbd
>> libps2 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcspkr shpchp
>> fan thermal battery i8042 tpm_tis tpm_tis_core tpm acpi_pad vfio_pci
>> irqbypass vfio_virqfd vfio_iommu_type1 vfio
>>    40.396917] CPU: 2 PID: 501 Comm: bcache_allocato Not tainted 4.13.5-5=
-ph #1
>>    40.397507] Hardware name: Gigabyte Technology Co., Ltd.
>> Z170X-UD3/Z170X-UD3-CF, BIOS F22 03/06/2017
>>    40.398095] task: ffff9efb793e5100 task.stack: ffffb546410d8000
>>    40.398687] RIP: 0010:_raw_spin_lock_irqsave+0x12/0x30
>>    40.399280] RSP: 0018:ffffb546410dbd60 EFLAGS: 00010046
>>    40.399883] R10: ffffb5464114d000 R11: ffff9efb74fe27f8 R12: ffff9efb7=
b69a028
>>    40.399883] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 000000000=
0000000
>>    40.399883] RBP: 00000000000006bc R08: ffffffffc0474800 R09: 000000000=
000000c
>>    40.399883] RDX: 0000000000000001 RSI: 0000000000000003 RDI: 000000000=
00006bc
>>    40.399884] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>    40.399884] FS:  0000000000000000(0000) GS:ffff9efb8ed00000(0000)
>> knlGS:0000000000000000
>>    40.399884] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000=
0000003
>>    40.399885] CR2: 00000000000006bc CR3: 0000000435928000 CR4: 000000000=
03406e0
>>    40.399885] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
>>    40.399885] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
>>    40.399886] Call Trace:
>>    40.399888]  ? try_to_wake_up+0x39/0x350
>>    40.399891]  ? bch_bucket_alloc+0x9a/0x280 [bcache]
>>    40.399892]  ? wait_woken+0x80/0x80
>>    40.399893]  ? bch_prio_write+0x189/0x330 [bcache]
>>    40.399895]  ? bch_allocator_thread+0x57b/0xc90 [bcache]
>>    40.399896]  ? __schedule+0x18e/0x5d0
>>    40.399897]  ? bch_invalidate_one_bucket+0x70/0x70 [bcache]
>>    40.399898]  ? kthread+0x10e/0x130
>>    40.399899]  ? kthread_create_on_node+0x60/0x60
>>    40.399900]  ? ret_from_fork+0x22/0x30
>>    40.399900] Code: f5 27 87 64 74 02 f3 c3 e8 08 75 86 ff c3 90 66 2e
>> 0f 1f 84 00 00 00 00 00 53 9c 5b fa 65 ff 05 d5 27 87 64 31 c0 ba 01
>> 00 00 00 <f0> 0f b1 17 85 c0 75 05 48 89 d8 5b c3 89 c6 e8 2a 82 90 ff
>> 48
>>    40.399909] CR2: 00000000000006bc
>>    40.399909] RIP: _raw_spin_lock_irqsave+0x12/0x30 RSP: ffffb546410dbd6=
0
>>    40.399911] ---[ end trace 3b309679f786fde8 ]---
>
> Hi Sverd,
>
> A fast glance on the code, c->data_bucket_lock from bch_alloc_sectors()
> is very suspicious. c->data_bucket_lock is initialized in
> bch_open_buckets_alloc(), which is called after calling kobject_init()
> when allocate a cache set in bch_cache_set_alloc().
>
> Cache/cache device register is via sysfs entry, therefor it is possible
> that before spin lock c->data_bucket_lock is initialized, a cache/cached
> device registration request sent into /sys/fs/bcache/register, then
> trigger a NULL deference on the spin lock.
>
> Normally it won't happen if the command is typed by human being. Do you
> use some script to run the bcache automatically ? Then I can do further
> check to confirm whether my guess is correct.
>
> Thanks.
>
> --
> Coly Li
